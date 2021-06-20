FROM python:3.8.1-slim

ENV PYTHONUNBUFFERED 1

EXPOSE 8000
WORKDIR /home/python/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat git graphviz && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY poetry.lock pyproject.toml ./
RUN pip install poetry==1.1 pylint==2.4.4 && \
    poetry config virtualenvs.in-project true && \
    poetry install --no-dev

CMD poetry run alembic upgrade head && \
    poetry run uvicorn --host=0.0.0.0 app.main:app

RUN useradd -u 1000 -o -m python && chown -R python:python /home/python
