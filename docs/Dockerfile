FROM python:3.11

RUN pip install --upgrade pip

WORKDIR /mkdocs

RUN --mount=target=/build/requirements.txt,source=docs/requirements.txt \
    pip install -r /build/requirements.txt

ENTRYPOINT ["mkdocs"]