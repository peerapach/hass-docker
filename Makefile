
amd64:
	docker buildx build --push --platform=linux/amd64 \
	--build-arg BASE_IMAGE="alpine:latest" \
	-f autossh/Dockerfile \
	-t peerapach/autossh-agent \
	autossh

arm64:
		docker buildx build --push --platform=linux/arm64 \
	--build-arg BASE_IMAGE="arm64v8/alpine:latest" \
	-f autossh/Dockerfile \
	-t peerapach/autossh-agent:arm64 \
	autossh

arm32:
		docker buildx build --push --platform=linux/arm32 \
	--build-arg BASE_IMAGE="arm32v7/alpine:latest" \
	-f autossh/Dockerfile \
	-t peerapach/autossh-agent:arm32 \
	autossh
