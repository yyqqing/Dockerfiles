FROM node:alpine

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

ENV PATH=$PATH:/home/node/.npm-global/bin

RUN npm config set registry https://registry.npm.taobao.org

WORKDIR /usr/src/app