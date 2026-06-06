FROM ubuntu:22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 libjsoncpp25 libpq5 libmariadb3 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY libs/*.so* /usr/local/lib/
RUN ldconfig
COPY build/dost-fhe .
COPY test_suite.sh .
RUN groupadd -r dost && useradd -r -g dost dost && chown -R dost:dost /app
USER dost
EXPOSE 8086
ENV LD_LIBRARY_PATH=/usr/local/lib
ENTRYPOINT ["./dost-fhe"]
