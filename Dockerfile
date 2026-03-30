FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:0.6 /uv /uvx /bin/

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup --create-home appuser

WORKDIR /app

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies without installing the project itself
RUN uv sync --frozen --no-dev --no-install-project

# Copy application source
COPY server/ server/

USER appuser

# Run the MCP server via stdio transport
CMD ["uv", "run", "mcp", "run", "server/main.py"]
