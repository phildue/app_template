FROM ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y python3 python3-pip build-essential cmake

RUN pip install conan && conan remote add conanbins http://host.docker.internal:8082/artifactory/api/conan/conanbins
ENV CONAN_REVISIONS_ENABLED=1
ADD . /usr/src
RUN conan user ci -r conanbins -p Conanbins1

RUN mkdir -p /usr/src/build && cd /usr/src/build && cmake .. -DCMAKE_BUILD_TYPE=Release && make -j4 && make install

FROM ubuntu:20.04 AS runtime

COPY --from=builder /usr/local/bin /usr/local/bin

ENTRYPOINT ["app"]
