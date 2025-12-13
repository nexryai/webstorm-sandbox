FROM ubuntu:rolling
RUN apt-get update && apt-get install -y \
    weston libgl1-mesa-dri mesa-vulkan-drivers wget gpg socat waypipe gosu git

RUN wget -O- https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null

RUN sh -c 'echo "deb http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null'
RUN echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg arch=amd64] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" \
    | tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null

RUN wget -O- https://deb.nodesource.com/setup_24.x | bash

RUN apt-get update && apt-get install -y webstorm nodejs

ENV XDG_RUNTIME_DIR=/run/container
RUN mkdir -p /run/container && chown -R ubuntu:ubuntu /run/container

RUN printf '#!/bin/bash\n\
\n\
socat UNIX-LISTEN:/tmp/waypipe.sock,fork,user=ubuntu,group=ubuntu,mode=600,unlink-early UNIX-CONNECT:/tmp/waypipe-bridge.sock &\n\
\n\
# SSH Agent Forwarding\n\
if [ -S /tmp/ssh.sock ]; then\n\
    socat UNIX-LISTEN:/tmp/ssh.ubuntu.sock,fork,user=ubuntu,group=ubuntu,mode=600,unlink-early UNIX-CONNECT:/tmp/ssh.sock &\n\
    export SSH_AUTH_SOCK=/tmp/ssh.ubuntu.sock\n\
fi\n\
\n\
sleep 0.1\n\
\n\
exec gosu ubuntu "$@"\n\
' > /usr/local/bin/entrypoint.sh && \
chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["waypipe", "--socket", "/tmp/waypipe.sock", "server", "webstorm", "-Dawt.toolkit.name=WLToolkit"]
