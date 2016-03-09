FROM h0tbird/confd:v0.11.0-1

ADD confd /etc/confd
ADD run.sh /run.sh

ENV CONFD_INTERVAL=10

ENTRYPOINT [ "/run.sh" ]
