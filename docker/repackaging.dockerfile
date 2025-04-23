########################################################################################################################
# docker build -t langgenius/dify-plugin-repackaging:0.0.6-local --build-arg VERSION=0.0.6 --file docker/repackaging.dockerfile .
# docker save -o langgenius_dify-plugin-repackaging_0.0.6-local.tar.gz langgenius/dify-plugin-repackaging:0.0.6-local
# docker load -i langgenius_dify-plugin-repackaging_0.0.6-local.tar.gz
# Windows:
# docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local market junjiem mcp_sse 0.0.1
# docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local github junjiem/dify-plugin-agent-mcp_sse 0.0.5 agent-mcp_sse.difypkg
# docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local local ./dify-plugin/langgenius-openai_api_compatible_0.0.8.difypkg
# LinuxOS:
# docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local market junjiem mcp_sse 0.0.1
# docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local github junjiem/dify-plugin-agent-mcp_sse 0.0.5 agent-mcp_sse.difypkg
# docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:0.0.6-local local ./dify-plugin/langgenius-openai_api_compatible_0.0.8.difypkg
########################################################################################################################

# set version
ARG VERSION=main

########################################################################################################################
#
########################################################################################################################
FROM golang:1.22-alpine AS builder

# copy project
COPY . /app

# set working directory
WORKDIR /app

# using goproxy if you have network issues
ENV GOPROXY=https://goproxy.cn,direct

# change version
RUN sed -i 's/REPLACE_ME/${VERSION}/g' ./cmd/commandline/version.go

# build
RUN go build -ldflags "-X 'main.VersionX=${VERSION}'" -o /app/dify ./cmd/commandline

########################################################################################################################
#
########################################################################################################################
FROM langgenius/dify-plugin-daemon:${VERSION}-local

COPY --from=builder /app/dify /app/dify

COPY --from=builder /app/plugin_repackaging.sh /app/plugin_repackaging.sh

WORKDIR /app

RUN set -x \
 && chmod +x /app/plugin_repackaging.sh \
 && apt-get update \
 && apt-get install -y --no-install-recommends curl unzip pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/*

ENTRYPOINT ["/app/plugin_repackaging.sh"]
