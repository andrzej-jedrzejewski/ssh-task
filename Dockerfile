FROM mikefarah/yq:latest

RUN apk add --no-cache \
  openssh-client \
  openssh \
  ca-certificates \
  bash

COPY ./inventory.yml /workdir/
COPY ./ssh_to_server.sh /workdir/
COPY ./*.pem /workdir/

ENTRYPOINT ["/workdir/ssh_to_server.sh"]