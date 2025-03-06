from fastapi import APIRouter, Depends, HTTPException, status, Query, Request
from sqlalchemy.orm import Session
from app.database.connection import get_db
from app.database.models import User, UserRole, UserHistory, Blacklist
from app.schemas.user import UserSchema, UserCreate, UserUpdate, LoginRequest, UserRoleList, UsersRequest, UserHistoryCreate, BlacklistBase  # Pydantic 스키마 가져오기
from app.utils.utils import verify_password  # 비밀번호 검증을 위한 유틸리티
from app.utils.utils import hash_password  # 비밀번호 해싱을 위한 유틸리티
from app.jwt import create_access_token, decode_access_token  # JWT 토큰 생성 함수 임포트
from datetime import timedelta, datetime
from fastapi.security import OAuth2PasswordBearer  # OAuth2 패스워드 베어러 가져오기
from jose import JWTError
from sqlalchemy import func, or_

import logging
import re

router = APIRouter()
logger = logging.getLogger(__name__)  # 로거 생성
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")  # OAuth2 스킴 생성

# JWT 검증 함수
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_access_token(token)
        user_id: str = payload.get("sub")  # 'sub' 필드에서 사용자 ID 가져오기
        if user_id is None:
            raise credentials_exception
    except (JWTError, Exception):
        raise credentials_exception

    user = db.query(User).filter(User.user_id == user_id).first()
    if user is None:
        raise credentials_exception
    return user

# 기본 루트 경로 추가
@router.get("/")
def root():
    return {"message": "Welcome to the FastAPI SQLite User API!"}

# 로그인 API
@router.post("/login/")
async def login(request: Request, login_data: LoginRequest, db: Session = Depends(get_db)):

    blocked_user = db.query(Blacklist).filter(Blacklist.ip_address == request.client.host).first()
    if blocked_user:
        return {
        "message": "차단된 IP 사용자입니다.", "status": "block"
    }

    user = db.query(User).filter(User.user_id == login_data.user_id).first()

    if user is None:
        # 로그인 실패 로그 남기기
        user_history = UserHistoryCreate(
            user_id=login_data.user_id,
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="로그인 실패 - 존재하지 않는 계정",
            login_time=get_kst_now(),
        )
        create_user_history(user_history, db)  # 실패 로그 기록
        # 예외 발생
        raise HTTPException(status_code=404, detail="User not found")

    # 비밀번호 검증
    if not verify_password(login_data.password, user.password):  # 비밀번호 해시 검증

        user_history = UserHistoryCreate(
            user_id=login_data.user_id,
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="로그인 실패 - 비밀번호 해시 불일치",
            login_time=get_kst_now(),
        )
        create_user_history(user_history, db)  # 실패 로그 기록

        raise HTTPException(status_code=401, detail="Invalid password")
    
    # 로그인 성공 시 JWT 토큰 생성
    access_token_expires = timedelta(minutes=30)  # 토큰 만료 시간 설정
    access_token = create_access_token(data={"sub": user.user_id}, expires_delta=access_token_expires)

    # 권한 및 승인 여부 조회
    roles = (
        db.query(User, UserRole)
        .join(UserRole, User.user_id == UserRole.user_id)
        .filter(User.user_id == user.user_id)
        .all()
        )

    logger.info(f"roles: {roles}")  # f-string 사용

    # roles 리스트를 UserRoles 모델로 변환
    roles_data = []
    for user_obj, role_obj in roles:
        roles_data.append(UserRoleList(role_id=role_obj.role_id))

    user_history = UserHistoryCreate(
            user_id=login_data.user_id,
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="로그인 성공",
            login_time=get_kst_now(),
        )
    create_user_history(user_history, db)  # 성공공 로그 기록

    return {
        "message": "로그인 성공",
        "user": UserSchema.from_orm(user),
        "roles": roles_data,  # 여기서 roles_data를 반환
        "access_token": access_token,
        "token_type": "bearer"  # 토큰 유형 (보통 "bearer" 사용)
    }

# 모든 사용자 조회 API
# @router.get("/api/users/", response_model=list[UserSchema])
# def read_all_users(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
#     users = (
#         db.query(User).all()
#     )
#     return users

@router.get("/api/users/", response_model=list[UserSchema])
def read_all_users(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    user_id: str = Query(None),
    name: str = Query(None),
    email: str = Query(None),
    phone: str = Query(None),
    approval_status: str = Query(None),
    role_ids: str = Query(None)
):
  # 서브쿼리를 사용하여 group_concat 결과를 처리합니다.
    subquery = (
        db.query(
            User.user_id,
            User.name,
            User.email,
            User.phone,
            User.address1,
            User.address2,
            User.approval_status,
            User.created_at,
            func.group_concat(UserRole.role_id).label('role_ids')
        )
        .outerjoin(UserRole)
        .group_by(User.user_id)
        .subquery()
    )

    # 메인 쿼리
    query = db.query(subquery)

    # 필터 적용
    if user_id:
        query = query.filter(subquery.c.user_id.like(f"%{user_id}%"))
    if name:
        query = query.filter(subquery.c.name.like(f"%{name}%"))
    if email:
        query = query.filter(subquery.c.email.like(f"%{email}%"))
    if phone:
        query = query.filter(subquery.c.phone.like(f"%{phone}%"))
    if approval_status:
        query = query.filter(subquery.c.approval_status == approval_status)

    if role_ids:
        role_id_list = role_ids.split(',')  # role_ids를 리스트로 변환
        role_conditions = [subquery.c.role_ids.like(f"%{role_id}%") for role_id in role_id_list]
        query = query.filter(or_(*role_conditions))  # 역할 필터링

    users = query.all()

    # 반환할 데이터 형식에 맞게 변환
    user_list = []
    for user in users:
        address1 = user.address1 or ""
        address2 = user.address2 or ""

        user_data = UserSchema(
            user_id=user.user_id,
            name=user.name,
            email=user.email,
            phone=user.phone,
            address = f"{address1} {address2}".strip(),
            created_at=user.created_at,
            approval_status=user.approval_status,
            role_ids=[int(role_id) for role_id in user.role_ids.split(',')] if user.role_ids else []
        )
        user_list.append(user_data)

    # UserHistory 객체 생성
    user_history = UserHistoryCreate(
        user_id=current_user.user_id,
        login_ip=request.client.host,
        request_path=f"{request.method} {request.url.path}",
        memo="회원 관리 - 회원 조회 성공",
        login_time=get_kst_now(),
    )

    # user_history를 DB에 삽입하는 로직 추가
    create_user_history(user_history, db)
    
    return user_list

# 사용자 정보 조회
@router.get("/api/user/{user_id}")
async def get_user(user_id: str, db: Session = Depends(get_db)):

    user = db.query(User).filter(User.user_id == user_id).first()
    
    # 권한 및 승인 여부 조회
    roles = (
        db.query(User, UserRole)
        .join(UserRole, User.user_id == UserRole.user_id)
        .filter(User.user_id == user.user_id)
        .all()
        )

    # roles 리스트를 UserRoles 모델로 변환
    roles_data = []
    for user_obj, role_obj in roles:
        roles_data.append(UserRoleList(role_id=role_obj.role_id))

    return {
        "user": UserSchema.from_orm(user),
        "roles": roles_data,  # 여기서 roles_data를 반환
    }

# 특정 사용자 조회 API
@router.get("/users/{user_id}", response_model=UserSchema)
def read_user(user_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.user_id == user_id).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# 특정 사용자 조회 직접 쿼리 실행 API(sql)
@router.get("/users/details/{user_id}")
def get_user_details(user_id: str, db: Session = Depends(get_db)):
    sql = text("""
        SELECT users.user_id, users.name, profiles.bio 
        FROM users 
        INNER JOIN profiles ON users.user_id = profiles.user_id
        WHERE id = :id
    """)
    result = db.execute(sql, {"id": user_id})
    users = result.fetchall()
    return users

# ID 중복 확인 API
@router.get("/api/users/check/{user_id}")
def check_user_id(user_id: str, db: Session = Depends(get_db)):
    # 사용자 존재 여부 확인
    existing_user = db.query(User).filter(User.user_id == user_id).first()
    if existing_user:
        return {"available": False}  # ID가 존재하는 경우
    return {"available": True}  # ID가 사용 가능한 경우

# 사용자 생성 API
@router.post("/users/", response_model=UserSchema)
def create_user(request: Request, user: UserCreate, db: Session = Depends(get_db)):
    # 이메일 형식 검증
    email_regex = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    if not re.match(email_regex, user.email):
        # user_history 이력 추가가
        user_history = UserHistoryCreate(
            user_id='',
            login_time=get_kst_now(),
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="회원 등록 실패 - 유효하지 않은 이메일 형식입니다.",  
        )

        # user_history를 DB에 삽입하는 로직 추가
        create_user_history(user_history, db)
        raise HTTPException(status_code=400, detail="유효하지 않은 이메일 형식입니다.")

    # 사용자 중복 확인
    existing_user = db.query(User).filter(User.user_id == user.user_id).first()
    if existing_user:
        # user_history 이력 추가가
        user_history = UserHistoryCreate(
            user_id='',
            login_time=get_kst_now(),
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="회원 등록 실패 - 아이디가 이미 존재합니다.",  
        )

        # user_history를 DB에 삽입하는 로직 추가
        create_user_history(user_history, db)
        raise HTTPException(status_code=400, detail="아이디가 이미 존재합니다.")

    # 비밀번호 해싱
    hashed_password = hash_password(user.password)

    # 사용자 생성
    db_user = User(
        user_id=user.user_id,
        name=user.name,
        email=user.email,
        password=hashed_password,
        phone=user.phone,  # 핸드폰 번호 추가
        address1=user.address1,  # 주소 추가
        address2=user.address2,  # 주소 추가
        approval_status=user.approval_status,
        created_at=get_kst_now(),
    )

    db.add(db_user)

    # 권한 추가 (멀티셀렉 지원)
    if user.role_ids:  # role_ids가 제공되면
        for role_id in user.role_ids:  # role_ids가 배열일 경우 반복
            user_role = UserRole(user_id=db_user.user_id, role_id=role_id)
            db.add(user_role)

    # UserSchema에서 roles 속성 포함하여 반환
    user_roles = db.query(UserRole).filter(UserRole.user_id == db_user.user_id).all()
    db_user.roles = user_roles  # roles에 추가된 권한 정보 담기

    db.commit()
    db.refresh(db_user)

    # user_history 이력 추가가
    user_history = UserHistoryCreate(
        user_id='',
        login_time=get_kst_now(),
        login_ip=request.client.host,
        request_path=f"{request.method} {request.url.path}",
        memo=f"회원 등록 성공: {db_user.user_id}",  # 등록된 사용자 ID
    )

    # user_history를 DB에 삽입하는 로직 추가
    create_user_history(user_history, db)

    return db_user

@router.put("/api/user/{user_id}", response_model=UserSchema)
def update_user(user_id: str, user_update: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.user_id == user_id).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    update_data = user_update.dict(exclude_unset=True)

    # 🔹 비밀번호 변경 요청이 있는 경우
    if "password" in update_data or "passwordConfirm" in update_data:
        password = update_data.get("password", "")
        password_confirm = update_data.get("passwordConfirm", "")
        
        if password and password_confirm:
            if password != password_confirm:
                raise HTTPException(status_code=400, detail="비밀번호가 일치하지 않습니다.")
            hashed_password = hash_password(password)
            update_data["password"] = hashed_password
        else:
            raise HTTPException(status_code=400, detail="비밀번호와 비밀번호 확인을 모두 입력해야 합니다.")

        # 🔹 passwordConfirm 필드는 DB에 저장할 필요 없으므로 제거
        update_data.pop("passwordConfirm", None)

    # 🔹 입력값이 있는 필드만 업데이트
    for key, value in update_data.items():
        setattr(user, key, value)

    db.commit()
    db.refresh(user)
    
    return user


# 사용자 삭제 API
@router.delete("/api/users/", response_model=dict)
def delete_user(request: Request, request_user: UsersRequest, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
   
    users = db.query(User).filter(User.user_id.in_(request_user.user_ids)).all()

    if not users:
        raise HTTPException(status_code=404, detail="Users not found")

    for user in users:
        db.query(UserRole).filter(UserRole.user_id == user.user_id).delete()
        db.delete(user)

    db.commit()

    # UserHistory 객체 생성
    user_history = UserHistoryCreate(
        user_id=current_user.user_id,
        login_time=get_kst_now(),
        login_ip=request.client.host,
        request_path=f"{request.method} {request.url.path}",
        memo=f"사용자 삭제 성공: {', '.join(request_user.user_ids)}",  # 삭제된 사용자 ID 포함
    )

    # user_history를 DB에 삽입하는 로직 추가
    create_user_history(user_history, db)

    return {"message": "Users deleted successfully"}

# 사용자 승인 API
@router.post("/api/users/approve", response_model=dict)
def approve_user(request: Request, request_user: UsersRequest, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    users = db.query(User).filter(User.user_id.in_(request_user.user_ids)).all()

    if not users:
        raise HTTPException(status_code=404, detail="Users not found")

    for user in users:
        user.approval_status = 'Y'  # 승인 상태를 'Y'로 변경
        # 권한 삭제(user_roles) 관련 코드가 필요하면 여기에 추가

    db.commit()

    # UserHistory 객체 생성
    user_history = UserHistoryCreate(
        user_id=current_user.user_id,
        login_time=get_kst_now(),
        login_ip=request.client.host,
        request_path=f"{request.method} {request.url.path}",
        memo=f"사용자 승인 성공: {', '.join(request_user.user_ids)}",  # 승인된 사용자 ID 포함
    )

    # user_history를 DB에 삽입하는 로직 추가
    create_user_history(user_history, db)

    return {"message": "Users approved successfully"}

# create_user_history 함수를 업데이트
def create_user_history(user_history: UserHistoryCreate, db: Session):
    # UserHistory 객체 생성
    db_user_history = UserHistory(
        user_id=user_history.user_id,
        login_time=user_history.login_time,  # login_time 추가
        login_ip=user_history.login_ip,
        request_path=user_history.request_path,  # request_path 추가
        memo=user_history.memo,  # memo 추가
    )

    # 데이터베이스에 추가
    db.add(db_user_history)

    # 변경 사항 커밋
    db.commit()

    # 생성된 객체 반환 (선택적)
    db.refresh(db_user_history)
    return db_user_history

# 접속 이력 조회
@router.get("/api/userHistory", response_model=list[UserHistoryCreate])
def get_user_history(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    user_id: str = Query(None),
    login_ip: str = Query(None),
    request_path: str = Query(None),
    memo: str = Query(None),
    login_time: str = Query(None),
):
    # 메인 쿼리
    query = (
        db.query(UserHistory)
    )

    # 필터 적용
    if user_id:
        query = query.filter(UserHistory.user_id.like(f"%{user_id}%"))
    if login_ip:
        query = query.filter(UserHistory.login_ip.like(f"%{login_ip}%"))
    if request_path:
        query = query.filter(UserHistory.request_path.like(f"%{request_path}%"))
    if memo:
        query = query.filter(UserHistory.memo.like(f"%{memo}%"))
    if login_time:
        try:
            # 날짜를 datetime 객체로 변환
            date_obj = datetime.strptime(login_time, "%Y-%m-%d")
            # 날짜의 시작과 끝을 설정하여 필터링
            query = query.filter(UserHistory.login_time >= date_obj, UserHistory.login_time < date_obj + timedelta(days=1))
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

    history = query.all()

    # UserHistory 객체 생성
    user_history = UserHistoryCreate(
        user_id=current_user.user_id,
        login_time=get_kst_now(),
        login_ip=request.client.host,
        request_path=f"{request.method} {request.url.path}",
        memo="접속 이력 - 접속 이력 조회 성공",
    )

    # user_history를 DB에 삽입하는 로직 추가
    create_user_history(user_history, db)
    
    return history

@router.post("/api/blockIp")
def block_user(
    request: Request,
    blockList: BlacklistBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        # 이미 차단된 IP인지 확인
        existing_ip = db.query(Blacklist).filter(Blacklist.ip_address == blockList.ip_address).first()
        if existing_ip:
            return {"message": f"IP {blockList.ip_address}이(가) 이미 차단되어 있습니다.", "status" : "ok"}

        # 새 블록된 IP 생성
        blocked_ip = Blacklist(ip_address=blockList.ip_address)

        # 블록된 IP를 데이터베이스에 추가
        db.add(blocked_ip)
        db.commit()
        db.refresh(blocked_ip)

        # UserHistory 기록 추가
        user_history = UserHistoryCreate(
            user_id=current_user.user_id,
            login_time=get_kst_now(),
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo=f"IP 차단 성공: {blockList.ip_address}",
        )
        create_user_history(user_history, db)

        return {"message": f"IP {blockList.ip_address}이(가) 차단되었습니다.", "status" : "fail"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))  # 일반적인 예외 처리


@router.post("/logout")
def logout_user_history(request: Request, user_history: UserHistoryCreate, db: Session = Depends(get_db)):
    try:
            # UserHistory 객체 생성
        user_history = UserHistoryCreate(
            user_id=user_history.user_id,
            login_time=get_kst_now(),
            login_ip=request.client.host,
            request_path=f"{request.method} {request.url.path}",
            memo="로그아웃 성공",
        )

        # user_history를 DB에 삽입하는 로직 추가
        create_user_history(user_history, db)

        return {"message": "로그아웃이 성공하였습니다.", "status" : "ok"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/api/blockedIps")
def get_blocked_ips(db: Session = Depends(get_db)):
    # 차단된 IP 목록 조회
    blocked_ips = db.query(Blacklist.ip_address).all()
    return {"blocked_ips": [ip[0] for ip in blocked_ips]}

# 차단해제 기능
@router.post("/api/unblockIp")
def unblock_user(
    request: Request,
    blockList: BlacklistBase,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        # 차단된 IP 존재 여부 확인
        blocked_ip = db.query(Blacklist).filter(Blacklist.ip_address == blockList.ip_address).first()
        
        if not blocked_ip:
            return {"message": f"IP {blockList.ip_address}는 차단되지 않았습니다.", "status": "ok"}

        # 차단된 IP 삭제
        db.delete(blocked_ip)
        db.commit()

        return {"message": f"IP {blockList.ip_address}의 차단이 해제되었습니다.", "status": "success"}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))  # 예외 처리

def get_kst_now():
    return datetime.utcnow() + timedelta(hours=9)

# ================================테스트================================

# Users 테이블과 Profile 테이블 inner join
@router.get("/users/join/", response_model=list[UserSchema])
def read_users(db: Session = Depends(get_db)):
    users = (
        db.query(User)
        .join(Profile, User.user_id == Profile.user_id)
        .all()
        )
    return users

# Users 테이블과 Profile 테이블 left outer join
@router.get("/users/outerjoin/", response_model=list[UserSchema])
def read_users(db: Session = Depends(get_db)):
    users = (
        db.query(User)
        .outerjoin(Profile, User.user_id == Profile.user_id)
        .all()
        )
    return users

# Join + Select 특정 컬럼만 조회 
@router.get("/users/", response_model=list[UserSchema])
def read_users(db: Session = Depends(get_db)):
    users = db.query(User.user_id, User.username, Profile.bio).join(Profile, User.user_id == Profile.user_id).all()
    return users

# 트랜잭션 테스트
@router.put("/users/transaction/{user_id}")
def update_user(user_id: str, user_update: UserUpdate, db: Session = Depends(get_db)):
    try:
        # 1️. User 테이블 업데이트
        user = db.query(User).filter(User.user_id == user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        user.username = user_update.username
        user.email = user_update.email

        # 2️. Profile 테이블 업데이트
        profile = db.query(Profile).filter(Profile.user_id == user_id).first()
        if profile:
            profile.bio = user_update.bio
            profile.avatar = user_update.avatar
        else:
            # 프로필이 없으면 새로 생성
            new_profile = Profile(user_id=user_id, bio=user_update.bio, avatar=user_update.avatar)
            db.add(new_profile)

        # 3️. 트랜잭션 커밋
        db.commit()
        return {"message": "User and profile updated successfully"}
    
    except Exception as e:
        db.rollback()  # 오류 발생 시 롤백
        raise HTTPException(status_code=500, detail=str(e))
    
    # ================================테스트================================