FROM zensical/zensical

RUN --mount=target=/build/requirements.txt,source=docs/requirements.txt \
    pip install -r /build/requirements.txt
