# # BASE
# FROM python:3.11-slim as base
# # install gcc
# RUN apt-get update \
# 	&& apt-get -y install gcc \
# 	&& rm -rf /var/lib/apt/lists/* 

# # DEVELOPMENT
# FROM base as development
# ENV \
# 	PIP_NO_CACHE_DIR=off \
# 	PIP_DISABLE_PIP_VERSION_CHECK=on \
# 	PYTHONDONTWRITEBYTECODE=1 \
# 	PYTHONUNBUFFERED=1 \
# 	VIRTUAL_ENV=/d4g-env 
# ENV \
# 	POETRY_VIRTUALENVS_CREATE=false \
# 	POETRY_VIRTUALENVS_IN_PROJECT=false \
# 	POETRY_NO_INTERACTION=1 \
# 	POETRY_VERSION=1.7.1

# # install poetry 
# RUN pip install "poetry==$POETRY_VERSION"
# # copy requirements
# COPY poetry.lock pyproject.toml main.py ./

# # add venv to path 
# ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# # Install python packages
# RUN python -m venv $VIRTUAL_ENV \
# 	&& . $VIRTUAL_ENV/bin/activate \
# 	&& poetry install --no-root

# ENTRYPOINT ${VIRTUAL_ENV}/bin/pip list

FROM python:3.10-bookworm

ENV POETRY_HOME=/app/.poetry \
    POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=1

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
# RUN apt update
# RUN apt install -y pipx
# RUN pipx ensurepath

# RUN pipx install poetry
ENV PATH="${PATH}:${POETRY_HOME}/bin"
# RUN pip install poetry==1.4.2

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

# FROM python:3.10-slim-bookworm


# ENV PYTHONFAULTHANDLER=1 \
#   PYTHONUNBUFFERED=1 \
#   PYTHONHASHSEED=random \
#   PIP_NO_CACHE_DIR=off \
#   PIP_DISABLE_PIP_VERSION_CHECK=on \
#   PIP_DEFAULT_TIMEOUT=100 \
#   # Poetry's configuration:
#   POETRY_NO_INTERACTION=1 \
#   POETRY_VIRTUALENVS_CREATE=false \
#   POETRY_CACHE_DIR='/var/cache/pypoetry' \
#   POETRY_HOME='/usr/local' \
#   POETRY_VERSION=1.7.1

# ENV VIRTUAL_ENV /env
# ENV PATH /env/bin:$PATH


# ENV PATH="${PATH}:${POETRY_HOME}/bin"

# # System deps:
# RUN curl -sSL https://install.python-poetry.org | python3 -

# RUN python -m venv ${VIRTUAL_ENV}
# RUN which python

# # Copy only requirements to cache them in docker layer
# WORKDIR /code
# COPY poetry.lock pyproject.toml /code/

# # Project initialization:
# RUN poetry install --no-interaction --no-ansi

# # Creating folders, and files for a project:
# COPY . /code
# ENTRYPOINT [ "python", "main.py" ]

