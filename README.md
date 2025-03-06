# git setting

```bash

git init
git add .
git commit -m "first commit"

git branch -M main
git remote add origin https://github.com/khsok212/fastapiServer.git
git push -u origin main

```

# 개발환경 세팅

``` cmd

1. 가상환경 설정
python -m venv venv

2. 활성화 
MacOS/Linux: source venv/bin/activate
Window : .\venv\Scripts\activate (cmd터미널)

참고 : deactivate (가상환경 탈출)

3. 라이브러리 설치
pip install -r requirements.txt

4. 서버 실행
uvicorn app.main:app --reload

5. 라이브러리 파일 업데이트
pip freeze > requirements.txt
pip freeze > T:\khs\requirements.txt

```
