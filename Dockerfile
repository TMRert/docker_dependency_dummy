ARG PY_VERSION=3.8
FROM python:${PY_VERSION}

ARG WORKSPACE_DIR=/workspace/application
COPY . ${WORKSPACE_DIR}
WORKDIR ${WORKSPACE_DIR}
ENTRYPOINT ["pip", "install", "."]