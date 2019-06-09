FROM python:3.7
RUN pip install pipenv
COPY . .
RUN pipenv install --deploy --system
ENTRYPOINT ["./play.py"]
