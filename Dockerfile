FROM alpine:3.6
COPY ./janus-pp-rec /usr/local/bin/janus-pp-rec
COPY ./convert-all-mjr-to-webm.sh /usr/local/bin/mjr2webm_all
COPY ./mjr2webm.sh /usr/local/bin/mjr2webm
RUN apk update && apk add glib ffmpeg jansson && chmod a+x /usr/local/bin/mjr2webm && rm -rf /var/cache/apk/*
CMD ["mjr2webm_all"]

