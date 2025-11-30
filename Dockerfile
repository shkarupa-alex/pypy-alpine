ARG ALPINE_VERSION="3.22"


FROM ghcr.io/astral-sh/uv:alpine${ALPINE_VERSION} AS build

ARG PYPY_VERSION="3.11"
ARG PYPY_RELEASE="7.3.20"

ENV PYTHONUNBUFFERED=1

RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk update && \
    apk add git \ 
            alpine-sdk \ 
            libffi-dev zlib-dev bzip2-dev expat-dev libunwind \
            sqlite-dev openssl-dev ncurses-dev gdbm-dev tk-dev xz-dev && \
    apk add pypy --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN --mount=type=cache,sharing=locked,target=/root/.cache/pip \
    pypy -m ensurepip && \
    pypy -m pip install -U pip setuptools wheel cffi

RUN git clone https://github.com/pypy/pypy.git

RUN cd pypy && \
    git pull && \
    git checkout release-pypy${PYPY_VERSION}-v${PYPY_RELEASE} && \
    cd pypy/goal && \
    pypy ../../rpython/bin/rpython --opt=jit && \
    PYTHONPATH=../.. ./pypy${PYPY_VERSION}-c ../../pypy/tool/release/package.py --builddir ../../dist --archive-name=pypy


FROM ghcr.io/astral-sh/uv:alpine${ALPINE_VERSION}

ARG PYPY_VERSION="3.11"

ENV PYTHONUNBUFFERED=1
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=never

RUN --mount=type=cache,sharing=locked,target=/var/cache/apk \
    apk update && \
    apk add curl \ 
            libgcc \ 
            libffi pkgconf \
            zlib libbz2 libexpat libunwind \
            sqlite-libs libssl3 ncurses-libs gdbm tk-lib xz-libs

COPY --from=build /pypy/dist/pypy /opt/pypy

ENV PATH="/opt/pypy/bin:$PATH"

RUN --mount=type=cache,sharing=locked,target=/root/.cache/pip \
    ln -s /opt/pypy/bin/pypy${PYPY_VERSION} /usr/local/bin/python && \
    python -m ensurepip && \
    python -m pip install -U pip setuptools wheel cffi

CMD ["python"]
