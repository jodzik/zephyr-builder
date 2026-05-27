# docker build -t zephyr-builder .

FROM zephyrprojectrtos/zephyr-build

WORKDIR /workdir

ADD ./spore-codegen /usr/bin/

COPY bootstrap.sh /home/bootstrap.sh

ENTRYPOINT [ "/home/bootstrap.sh" ]

CMD [ "/bin/bash" ]
