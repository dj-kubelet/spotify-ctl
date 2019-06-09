FROM python:3.7
RUN pip install pipenv
COPY Pipfile* ./
RUN pipenv install --deploy --system
COPY *.py ./
ENTRYPOINT ["./play.py"]
