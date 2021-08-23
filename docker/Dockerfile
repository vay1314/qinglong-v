FROM node:lts-alpine
LABEL maintainer="vay1314"
ARG QL_URL=https://github.com/vay1314/qinglong-v.git
ARG QL_BRANCH=master
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    QL_DIR=/ql \
    ENABLE_WEB_JDC=false
WORKDIR ${QL_DIR}
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
                             coreutils \
                             moreutils \
                             git \
                             curl \
                             wget \
                             tzdata \
                             perl \
                             openssl \
                             nginx \
                             python3 \
                             jq \
                             openssh \
                             build-base \
                             g++ \
                             cairo-dev \
                             pango-dev \
                             giflib-dev \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && touch ~/.bashrc \
    && mkdir /run/nginx \
    && git clone -b ${QL_BRANCH} https://github.com/vay1314/qinglong-v-static.git /static \
    && git clone -b ${QL_BRANCH} ${QL_URL} ${QL_DIR} \
    && git config --global user.email "niuniuhaogou@gmail.com" \
    && git config --global user.name "vay1314" \
    && git config --global pull.rebase true \
    && cd ${QL_DIR} \
    && cp -rf /static/* ./ \
    && rm -rf /static \
    && cp -f .env.example .env \
    && chmod 777 ${QL_DIR}/shell/*.sh \
    && chmod 777 ${QL_DIR}/docker/*.sh \
    && npm install -g pnpm \
    && pnpm install -g pm2 \
    && pnpm install -g ts-node typescript \
    && rm -rf /root/.npm \
    && pnpm install --prod \
    && rm -rf /root/.pnpm-store \
    && mkdir -p /ql/scripts/node_modules \
    && cd /ql/scripts \
    && pip3 install -r /ql/sample/requirements.txt \
    && npm install canvas --build-from-source
ENTRYPOINT ["./docker/docker-entrypoint.sh"]
