FROM lsiobase/alpine:3.11 as buildstage

ARG HUGO_VERSION

RUN \
    apk add --no-cache \
    curl \
    grep && \
if [ -z ${HUGO_VERSION+x} ]; then \
    HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | grep "tag_name.*" | cut -d ":" -f 2,3 | tr -d '\",v '); \
fi && \
mkdir -p /root-layer/hugo && \
curl -o \
    /root-layer/hugo/hugo.deb -L \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb
# for i in x86_64; do \
#     mkdir -p "/tmp/${i}"; \
#     tar xzf "/root-layer/hugo/hugo_${i}.tar.gz" -C "/tmp/${i}"; \
# done

COPY root/ /root-layer/

FROM scratch

LABEL maintainer="xenon"

COPY --from=buildstage /root-layer/ /