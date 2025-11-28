# Alpine + PyPy3 + UV docker image

PyPy3 build from source base on uv-alpine image

## Build and push

```bash
export DOCKER_USER="shkarupaalex"
export ALPINE_VERSION="3.22"
export PYPY_VERSION="3.11"
export PYPY_RELEASE="7.3.20"

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    --build-arg PYPY_VERSION=${PYPY_VERSION} \
    --build-arg PYPY_RELEASE=${PYPY_RELEASE} \
    -t ${DOCKER_USER}/pypy${PYPY_VERSION}r${PYPY_RELEASE}-alpine${ALPINE_VERSION} .

docker push ${DOCKER_USER}/pypy${PYPY_VERSION}r${PYPY_RELEASE}-alpine${ALPINE_VERSION}
```