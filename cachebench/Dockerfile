FROM ubuntu
RUN apt-get update
RUN apt-get install -y net-tools
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install make
RUN apt-get update
RUN apt-get install -y gcc-multilib
COPY llcbench.tar.gz /
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["300"]

