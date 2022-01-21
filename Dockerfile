FROM ubuntu:20.04 as build
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev  
RUN wget https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz -O python-src.tgz && \
    mkdir python-src && \
    cd python-src && \
    tar -xf ../python-src.tgz --strip-components=1 && \
    ./configure --enable-optimizations && \
    make -j 4

FROM mcr.microsoft.com/playwright
COPY --from=build /python-src /python-src
RUN cd python-src && make altinstall && pip3.10 install -U pip wheel && mkdir /application

WORKDIR /application

ENV REQUIREMENTS_FILE=requirements.txt
ENV MAIN_FILE=src/main.py

CMD pip3.10 install -r $REQUIREMENTS_FILE && python3.10 $MAIN_FILE
