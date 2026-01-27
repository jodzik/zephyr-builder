# docker build -t zephyr-builder .

FROM zephyrprojectrtos/zephyr-build

RUN echo "USERNAME=$USERNAME"

WORKDIR /workdir

RUN sudo apt-get -y install \
    rsync \
    telnet

RUN west init && \
    west update 

ADD ./spore-codegen /usr/bin/

COPY bootstrap.sh /home/bootstrap.sh

ENTRYPOINT [ "/home/bootstrap.sh" ]

CMD [ "/bin/bash" ]
