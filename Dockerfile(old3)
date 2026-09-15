FROM python:3.12-slim

WORKDIR /app

COPY app/requirements.txt .

RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir "setuptools>=78.1.1" \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && python -m pip install --no-cache-dir --upgrade "msgpack>=1.2.1" \
    && python -m pip show setuptools \
    && python -m pip show msgpack

COPY app/ .

EXPOSE 3000

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "app:app"]