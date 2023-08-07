FROM ubuntu
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get update
RUN apt-get install -y gcc-multilib
RUN apt-get install -y gfortran
COPY bonnie++_1.04.tar.gz /
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1"]
