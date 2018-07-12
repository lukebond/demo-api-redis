FROM gliderlabs/alpine:3.6

RUN \
  apk --update add nodejs nodejs-npm python make g++ \
    curl wget \
      build-base ca-certificates git haproxy socat

WORKDIR /usr/src/app

ADD ./package.json /usr/src/app/package.json
RUN npm install

ADD ./index.js /usr/src/app/

EXPOSE 9000

CMD [ "node", "index" ]
