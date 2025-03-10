from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker, declarative_base

# 이벤트 리스너 등록
from sqlalchemy.engine import Engine
import sqlparse

@event.listens_for(Engine, "before_cursor_execute")
def before_cursor_execute(conn, cursor, statement, parameters, context, executemany):
    if context is not None and getattr(context, "compiled", None):
        try:
            # literal_binds 옵션을 통해 파라미터 치환된 SQL 생성
            literal_statement = context.compiled.statement.compile(
                dialect=conn.dialect,
                compile_kwargs={"literal_binds": True}
            )
            # sqlparse를 이용해 포맷팅
            formatted_sql = sqlparse.format(
                str(literal_statement), 
                reindent=True, 
                keyword_case='upper'
            )
            print("Executing SQL (compiled, formatted):")
            print(formatted_sql)
        except Exception as e:
            print("Could not compile statement with literal_binds:", e)
            print("Executing SQL:")
            print(statement)
    else:
        print("Executing SQL:")
        print(statement)
    print("With parameters:")
    print(parameters)

# SQLite 데이터베이스 URL 설정(수정문제로 절대경로로 지정)
# DATABASE_URL = "sqlite:///T:\\khs\\work\\database\\test.db"
DATABASE_URL = "postgresql://postgres:1234@localhost/projectdb"

# SQLAlchemy 엔진 생성
# engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False}, echo=True)
engine = create_engine(DATABASE_URL, echo=True)

# 세션 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# SQLAlchemy 모델 베이스 클래스
Base = declarative_base()

# 데이터베이스 세션 종속성 (FastAPI에서 사용)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
