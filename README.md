# Alpine + PyPy3 + UV docker image

PyPy3 build from source base on uv-alpine image

## Build and push

```bash
export DOCKER_USER="shkarupaalex"

export BUILD_VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)

export ALPINE_VERSION="3.22"
export PYPY_VERSION="3.11"
export PYPY_RELEASE="7.3.20"

# Cross-compilation doesn't work with PyPy :(
# export BUILD_PLATFORM="linux/amd64,linux/arm64"
# docker buildx build \
#     --platform ${BUILD_PLATFORM} \
#     --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
#     --build-arg PYPY_VERSION=${PYPY_VERSION} \
#     --build-arg PYPY_RELEASE=${PYPY_RELEASE} \
#     -t ${DOCKER_USER}/pypy:b${BUILD_VERSION}-v${PYPY_VERSION}-r${PYPY_RELEASE}-alpine${ALPINE_VERSION} .

docker build \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    --build-arg PYPY_VERSION=${PYPY_VERSION} \
    --build-arg PYPY_RELEASE=${PYPY_RELEASE} \
    -t ${DOCKER_USER}/pypy:b${BUILD_VERSION}-v${PYPY_VERSION}-r${PYPY_RELEASE}-alpine${ALPINE_VERSION} .

docker push ${DOCKER_USER}/pypy:b${BUILD_VERSION}-v${PYPY_VERSION}-r${PYPY_RELEASE}-alpine${ALPINE_VERSION}
```