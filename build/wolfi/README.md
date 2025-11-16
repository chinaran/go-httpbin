测试步骤：

```bash
# 创建输出目录
mkdir -p packages

# 生成签名密钥
docker run --rm -v "$PWD":/work \
  cgr.dev/chainguard/melange:latest keygen

# 使用 melange 构建 go-httpbin APK 包
# --privileged 是 QEMU 模拟多架构构建所必需的
docker run --rm --privileged -v "$PWD":/work \
  cgr.dev/chainguard/melange:latest build \
  /work/melange.yaml \
  --signing-key /work/melange.rsa \
  --arch amd64

# 使用 apko 构建最终镜像
docker run --rm -v "$PWD":/work \
  cgr.dev/chainguard/apko:latest build \
  /work/apko.yaml \
  go-httpbin:1.4.0 \
  image.tar

# 加载镜像到 Docker
docker load < image.tar

# 测试
docker run --rm -p 8888:8080 go-httpbin:1.4.0-amd64
curl localhost:8888/get
```
