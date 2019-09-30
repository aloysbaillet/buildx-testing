# syntax = docker/dockerfile:experimental
FROM n0madic/alpine-gcc:8.3.0 as builder

RUN apk add --quiet --no-cache \
    curl ccache libffi-dev

RUN --mount=type=cache,target=/tmp/ccache \
    --mount=type=cache,target=/tmp/downloads \
    export CCACHE_DIR=/tmp/ccache && \
    export DOWNLOADS_DIR=/tmp/downloads && \
    if [ ! -f $DOWNLOADS_DIR/Python-${PYTHON_VERSION_FULL}.tgz ] ; then curl --location https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz -o $DOWNLOADS_DIR/Python-3.7.3.tgz ; fi && \
    tar xf $DOWNLOADS_DIR/Python-3.7.3.tgz && \
    cd Python-3.7.3 && \
    ./configure \
        --prefix=/usr/local \
        --enable-unicode=ucs4 \
        --enable-shared && \
    make -j4 && \
    make altinstall

FROM alpine

COPY --from=builder /usr/local/ /usr/
