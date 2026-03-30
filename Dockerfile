FROM python:3.12-slim@sha256:<PYTHON_3_12_SLIM_DIGEST>

COPY --from=ghcr.io/astral-sh/uv:0.4.18@sha256:<UV_0_4_18_DIGEST> /uv /uvx /bin/

WORKDIR /app

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application source
COPY server/ server/

# Run the MCP server via stdio transport
CMD ["uv", "run", "mcp", "run", "server/main.py"]
