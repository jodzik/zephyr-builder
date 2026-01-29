# docker build -t zephyr-builder .

FROM zephyrprojectrtos/zephyr-build

RUN echo "USERNAME=$USERNAME"

WORKDIR /workdir

RUN sudo apt-get -y install \
    rsync

RUN west init --mr "v4.3.0" && \
    west update 

ADD ./spore-codegen /usr/bin/

COPY bootstrap.sh /home/bootstrap.sh

ENTRYPOINT [ "/home/bootstrap.sh" ]

CMD [ "/bin/bash" ]
