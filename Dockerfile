FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim AS builder

FROM python:3.13-slim-trixie

COPY --from=builder /usr/local/bin/uv /usr/local/bin

WORKDIR /app

COPY . .

RUN uv sync --locked

EXPOSE 8000

CMD ["/app/.venv/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

