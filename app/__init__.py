from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import users
from app.database.connection import Base, engine
from app.utils.logging import setup_logging  # 로깅 설정 함수 가져오기
import httpx

# 로깅 설정
setup_logging()

# FastAPI 앱 생성
app = FastAPI()

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:9000"],  # 허용할 프론트엔드 도메인 (Vue.js 개발 서버)
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],  # 모든 헤더 허용
)

# 비동기 HTTP 요청을 사용하기 위한 httpx 클라이언트 생성
client = httpx.AsyncClient()

# 외부 API 요청을 FastAPI에서 프록시하는 엔드포인트
@app.get("/get-emoji-flags")
async def get_emoji_flags():
    try:
        # 외부 URL로 GET 요청을 보냄
        response = await client.get('https://echarts.apache.org/en/js/vendors/emoji-flags@1.3.0/data.json')
        response.raise_for_status()  # 오류가 발생하면 예외를 발생시킴
        return response.json()  # JSON 응답을 반환
    except httpx.RequestError as e:
        return {"error": str(e)}

@app.get("/get-life-expectancy")
async def get_life_expectancy():
    try:
        # 외부 URL로 GET 요청을 보냄
        response = await client.get('https://echarts.apache.org/examples/data/asset/data/life-expectancy-table.json')
        response.raise_for_status()  # 오류가 발생하면 예외를 발생시킴
        return response.json()  # JSON 응답을 반환
    except httpx.RequestError as e:
        return {"error": str(e)}

# 데이터베이스 테이블 생성
Base.metadata.create_all(bind=engine)

# 라우터 등록
app.include_router(users.router)
