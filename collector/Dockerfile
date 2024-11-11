FROM alpine:3.20.3

RUN apk add --no-cache openssh-server \
                       inotify-tools \
                       ca-certificates \
                       curl \
                       shadow

RUN update-ca-certificates

RUN mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY launch.sh /launch.sh
COPY brother.conf /etc/ssh/sshd_config.d/brother.conf

RUN mkdir /input && \
    addgroup upload && \
    chgrp upload /input && \
    chmod 775 /input

CMD [ "/launch.sh" ]

ENV SSH_USERNAME=collector

EXPOSE 22
