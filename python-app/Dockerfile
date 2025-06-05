FROM python:3.11-slim-buster AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt

FROM python:3.11-alpine AS final

WORKDIR /app
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*
COPY . .
CMD ["--bind", "0.0.0.0:8080", "main:app"]
ENTRYPOINT ["gunicorn"]
