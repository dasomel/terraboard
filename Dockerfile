FROM --platform=$BUILDPLATFORM golang:1.23 AS builder
LABEL org.opencontainers.image.authors="Camptocamp, dasomel <dasomell@gmail.com>"
WORKDIR /opt/build
COPY . .
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH make build VERSION=${VERSION}

FROM --platform=$BUILDPLATFORM node:22 AS node-builder
WORKDIR /opt/build
COPY static/terraboard-vuejs ./terraboard-vuejs
WORKDIR /opt/build/terraboard-vuejs
RUN yarn install
RUN yarn run build

FROM scratch
LABEL org.opencontainers.image.authors="Camptocamp, dasomel <dasomell@gmail.com>"
LABEL org.opencontainers.image.title="Terraboard"
LABEL org.opencontainers.image.description="A Web dashboard to inspect Terraform States"
LABEL org.opencontainers.image.source="https://github.com/dasomel/terraboard"
LABEL org.opencontainers.image.vendor="dasomel"
LABEL org.opencontainers.image.licenses="Apache-2.0"
WORKDIR /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /opt/build/terraboard /
COPY --from=node-builder /opt/build/terraboard-vuejs/dist /static
ENTRYPOINT ["/terraboard"]
CMD [""]
