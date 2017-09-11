FROM ubuntu:16.04

COPY start.bash /start.bash

RUN apt-get -y update && apt install kmod
RUN apt-get install -y build-essential linux-headers-4.4.0-93-generic dkms git net-tools gcc make pkg-config libnl-genl-3-dev autoconf automake

RUN git clone https://github.com/NICMx/Jool.git /usr/src/Jool

RUN cd /usr/src/Jool && git checkout -b docker origin/docker

# RUN cd /usr/src && dkms install --verbose Jool

RUN cd /usr/src/Jool/usr && ./autogen.sh && ./configure && make && make install

CMD [ "/start.bash", ""]
