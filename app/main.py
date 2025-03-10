from app import app  # app/__init__.py에서 FastAPI 객체 가져오기

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000, reload=True)