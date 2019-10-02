# syntax = docker/dockerfile:experimental

################### buildx-testing-image-a-builder ###################
FROM n0madic/alpine-gcc:8.3.0 as buildx-testing-image-a-builder

RUN apk add --quiet --no-cache \
    curl ccache libffi-dev && \
    ln -s /usr/bin/ccache /usr/local/bin/gcc && \
    ln -s /usr/bin/ccache /usr/local/bin/g++ && \
    ln -s /usr/bin/ccache /usr/local/bin/cc && \
    ln -s /usr/bin/ccache /usr/local/bin/c++

ENV PATH /usr/local/bin:${PATH}

RUN --mount=type=cache,target=/tmp/ccache \
    --mount=type=cache,target=/tmp/downloads \
    export CCACHE_DIR=/tmp/ccache && \
    export DOWNLOADS_DIR=/tmp/downloads && \
    if [ ! -f $DOWNLOADS_DIR/Python-3.7.3.tgz ] ; then curl --location https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz -o $DOWNLOADS_DIR/Python-3.7.3.tgz ; fi && \
    tar xf $DOWNLOADS_DIR/Python-3.7.3.tgz && \
    cd Python-3.7.3 && \
    ./configure \
        --prefix=/usr/local \
        --enable-shared && \
    make -j4 && \
    make install && \
    ccache --show-stats

################### buildx-testing-image-a-ccache ###################
FROM scratch as buildx-testing-image-a-ccache

COPY --from=buildx-testing-image-a-builder /tmp/ccache.tar.gz /ccache/ccache.tar.gz


################### buildx-testing-image-a ###################
FROM alpine as buildx-testing-image-a

COPY --from=buildx-testing-image-a-builder /usr/local/ /usr/local/


################### buildx-testing-image-b ###################
FROM buildx-testing-image-a as buildx-testing-image-b

RUN /usr/local/bin/python3 --version
