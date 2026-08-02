# docker build -t zephyr-builder .

FROM zephyrprojectrtos/zephyr-build

WORKDIR /workdir

ADD ./spore-codegen /usr/bin/

RUN sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-20 100

COPY bootstrap.sh /home/bootstrap.sh

ENTRYPOINT [ "/home/bootstrap.sh" ]

CMD [ "/bin/bash" ]
