# Dify Plugin Repackaging

感谢 [junjiem](https://github.com/junjiem) 大佬开源奉献：[https://github.com/junjiem/dify-plugin-repackaging](https://github.com/junjiem/dify-plugin-repackaging)

## 1. Windows

### 1.1. 构建

```powershell
docker build -t langgenius/dify-plugin-repackaging:%VERSION%-local ^
  --build-arg VERSION=%VERSION% ^
  --file docker/repackaging.dockerfile .
```

```powershell
docker save -o langgenius_dify-plugin-repackaging_%VERSION%-local.tar.gz langgenius/dify-plugin-repackaging:%VERSION%-local
```

```powershell
docker load -i langgenius_dify-plugin-repackaging_%VERSION%-local.tar.gz
```

### 1.2. 使用

```powershell
docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:%VERSION%-local ^
  market junjiem mcp_sse 0.0.1
```

```powershell
docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:%VERSION%-local ^
  github junjiem/dify-plugin-agent-mcp_sse 0.0.5 agent-mcp_sse.difypkg
```

```powershell
docker run --rm -v %CD%/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:%VERSION%-local ^
  local ./dify-plugin/langgenius-openai_api_compatible_0.0.8.difypkg
```

## 2. Linux OS

### 1.1. 构建

```sh
docker build -t langgenius/dify-plugin-repackaging:${VERSION}-local \
  --build-arg VERSION=${VERSION} \
  --file docker/repackaging.dockerfile .
```

```sh
docker save -o langgenius_dify-plugin-repackaging_${VERSION}-local.tar.gz langgenius/dify-plugin-repackaging:${VERSION}-local
```

```sh
docker load -i langgenius_dify-plugin-repackaging_${VERSION}-local.tar.gz
```

### 1.2. 使用

```sh
docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:${VERSION}-local \
  market junjiem mcp_sse 0.0.1
```

```sh
docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:${VERSION}-local \
  github junjiem/dify-plugin-agent-mcp_sse 0.0.5 agent-mcp_sse.difypkg
```

```sh
docker run --rm -v $PWD/dify-plugin:/app/dify-plugin langgenius/dify-plugin-repackaging:${VERSION}-local \
  local ./dify-plugin/langgenius-openai_api_compatible_0.0.8.difypkg
```

# Dify Plugin Daemon

