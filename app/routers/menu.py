from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List
from app.database.connection import get_db
from app.database.models import Role, Menu, RoleMenu
from app.schemas.schemas import RoleBase, MenuSchema, UpdateRoleMenuRequest, MenuUpdate, MenuCreate
from sqlalchemy.exc import IntegrityError
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy import func, or_, cast, String, text

router = APIRouter()

@router.get("/api/menus/all")
def get_all_menus(db: Session = Depends(get_db)):
    all_menus = db.query(Menu).all()
    return {"menus": all_menus}

# ✅ 역할 목록 가져오기
@router.get("/api/roles", response_model=List[RoleBase])
def get_roles(db: Session = Depends(get_db)):
    return db.query(Role).all()

# ✅ 역할별 메뉴 목록 가져오기
@router.get("/api/menus/by-role/{role_id}")
def get_menus_by_role(role_id: int, db: Session = Depends(get_db)):
    
    # ✅ 해당 역할의 메뉴 ID 및 메뉴 순서(menu_order) 가져오기
    granted_menus_query = (
        db.query(RoleMenu.menu_id, RoleMenu.menu_order)
        .filter(RoleMenu.role_id == role_id)
        .order_by(RoleMenu.menu_order)  # 🔥 menu_order 기준 정렬
        .all()
    )

    # 역할에 부여된 메뉴 ID 및 순서 매핑
    granted_menu_dict = {menu_id: order for menu_id, order in granted_menus_query}

    # 전체 메뉴 가져오기
    all_menus = db.query(Menu).all()

    # 역할에 할당된 메뉴와 할당되지 않은 메뉴 분리
    granted_menus = sorted(
        [menu for menu in all_menus if menu.menu_id in granted_menu_dict],
        key=lambda menu: granted_menu_dict[menu.menu_id]  # 🔥 menu_order 기준 정렬
    )

    ungranted_menus = [menu for menu in all_menus if menu.menu_id not in granted_menu_dict]

    return {
        "all_menus": all_menus,
        "granted_menus": granted_menus,
        "ungranted_menus": ungranted_menus,
    }

@router.post("/api/menus/update-role-menus")
def update_role_menus(request: UpdateRoleMenuRequest, db: Session = Depends(get_db)):
    try:
        # ✅ 역할 존재 여부 확인
        role_exists = db.query(Role).filter(Role.role_id == request.role_id).first()
        if not role_exists:
            raise HTTPException(status_code=404, detail=f"역할 ID {request.role_id}가 존재하지 않습니다.")

        # ✅ 기존 데이터 삭제 (현재 역할의 메뉴 제거)
        db.query(RoleMenu).filter(RoleMenu.role_id == request.role_id).delete()
        db.flush()

        # ✅ 새로운 순서로 삽입
        stmt = insert(RoleMenu).values([
            {"role_id": request.role_id, "menu_id": item.menu_id, "menu_order": item.menu_order}
            for item in request.menu_items
        ]).on_conflict_do_nothing()

        db.execute(stmt.execution_options(synchronize_session=False))
        db.commit()

        return {"message": "메뉴 권한이 업데이트되었습니다."}

    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"데이터베이스 무결성 오류: {str(e)}")

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"서버 오류 발생: {str(e)}")

@router.put("/api/menus/{menu_id}")
def update_menu(menu_id: int, menu_update: MenuUpdate, db: Session = Depends(get_db)):
    # 해당 메뉴 조회
    menu = db.query(Menu).filter(Menu.menu_id == menu_id).first()
    if not menu:
        raise HTTPException(status_code=404, detail="Menu not found")

    # 업데이트: 입력된 데이터로 메뉴 값을 변경
    menu.menu_name = menu_update.menu_name
    menu.route = menu_update.route
    menu.is_active = menu_update.is_active

    db.commit()
    db.refresh(menu)
    return menu

@router.delete("/api/menus/{menu_id}")
def delete_menu(menu_id: int, db: Session = Depends(get_db)):
    # 먼저 RoleMenu에서 해당 menu_id를 가진 항목 삭제
    role_menu_entries = db.query(RoleMenu).filter(RoleMenu.menu_id == menu_id).all()
    for entry in role_menu_entries:
        db.delete(entry)
    
    # 그 후 Menu 테이블에서 해당 메뉴 삭제
    menu = db.query(Menu).filter(Menu.menu_id == menu_id).first()
    if not menu:
        raise HTTPException(status_code=404, detail="Menu not found")
    
    db.delete(menu)
    db.commit()
    return {"detail": "Menu and related role menus deleted successfully"}

@router.post("/api/menus", response_model=MenuCreate)
def create_menu(menu: MenuCreate, db: Session = Depends(get_db)):
    """
    새로운 메뉴를 추가하는 API
    """
    # 새로운 메뉴 생성
    new_menu = Menu(
        menu_name=menu.menu_name,
        route=menu.route,
        is_active=menu.is_active,
        parent_id=menu.parent_id
    )

    # 데이터베이스에 추가
    db.add(new_menu)
    db.commit()
    db.refresh(new_menu)  # 새로 추가된 데이터 반환

    return new_menu

@router.get("/get_menus")
def get_menus(role_id: str = Query(...), db: Session = Depends(get_db)):
    """
    사용자 역할(role_id)에 따라 접근 가능한 메뉴를 반환하는 API
    - role_id는 "0,1,2" 같은 문자열 형식으로 전달됨
    """
    # role_id 문자열을 리스트로 변환
    try:
        role_ids = tuple(map(int, role_id.split(',')))  # "0,1,2" -> (0,1,2)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid role_id format")

    # SQL 쿼리 실행 (IN 조건을 사용하여 여러 역할의 메뉴 조회)
    query = text("""
        SELECT *
        FROM (
        SELECT DISTINCT ON (rm.menu_id)
                rm.menu_id,
                m.menu_name,
                m.route,
                m.parent_id,
                rm.menu_order,
                rm.role_id
        FROM public.menus m
        JOIN public.role_menus rm ON m.menu_id = rm.menu_id
        WHERE rm.role_id IN :role_ids
        ORDER BY rm.menu_id, rm.role_id ASC, rm.menu_order ASC
        ) AS sub
        ORDER BY sub.role_id ASC, sub.menu_order ASC;
    """)

    menus = db.execute(query, {"role_ids": role_ids}).fetchall()

    # 메뉴 데이터를 JSON 형식으로 변환하여 반환
    menu_list = [
        {"menu_id": row[0], "menu_name": row[1], "route": row[2], "parent_id": row[3], "menu_order": row[4]}
        for row in menus
    ]

    return menu_list