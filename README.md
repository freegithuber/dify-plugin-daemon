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

## Overview

Dify Plugin Daemon is a service that manages the lifecycle of plugins. It's responsible for 3 types of runtimes:

1. Local runtime: runs on the same machine as the Dify server.
2. Debug runtime: listens to a port to wait for a debugging plugin to connect.
3. Serverless runtime: runs on a serverless platform such as AWS Lambda.

Dify api server will communicate with the daemon to get all the status of plugins like which plugin was installed to which workspace, and receive requests from Dify api server to invoke a plugin like a serverless function.

All requests from Dify api based on HTTP protocol, but depends on the runtime type, the daemon will forward the request to the corresponding runtime in different ways.

- For local runtime, daemon will start plugin as the subprocess and communicate with the plugin via STDIN/STDOUT.
- For debug runtime, daemon wait for a plugin to connect and communicate in full-duplex way, it's TCP based.
- For serverless runtime, plugin will be packaged to a third-party service like AWS Lambda and then be invoked by the daemon via HTTP protocol.

For more detailed introduction about Dify plugin, please refer to our docs [https://docs.dify.ai/plugins/introduction](https://docs.dify.ai/plugins/introduction).

## Development

### Run daemon

Firstly copy the `.env.example` file to `.env` and set the correct environment variables like `DB_HOST` etc.

```bash
cp .env.example .env
```

Attention that the `PYTHON_INTERPRETER_PATH` is the path to the python interpreter, please specify the correct path according to your python installation and make sure the python version is 3.11 or higher, as dify-plugin-sdk requires.

We recommend you to use `vscode` to debug the daemon,  and a `launch.json` file is provided in the `.vscode` directory.

## LICENSE

Dify Plugin Daemon is released under the [Apache-2.0 license](LICENSE).
