FROM python:3.10-bookworm

ENV POETRY_HOME=/app/.poetry \
    POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=1

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:${POETRY_HOME}/bin"

WORKDIR /app

# COPY ./d4g-utils /app/d4g-utils
COPY ./peer_session_3 /app/peer_session_3
COPY ./main.py /app/main.py
COPY poetry.lock /app/poetry.lock
COPY pyproject.toml /app/pyproject.toml
COPY README.md /app/README.md

RUN python -m venv ${VIRTUAL_ENV}
RUN which python

# Install dependencies
RUN poetry install

ENTRYPOINT [ "poetry", "run", "python", "main.py" ]
