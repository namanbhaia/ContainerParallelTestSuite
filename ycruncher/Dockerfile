FROM ubuntu
RUN apt-get update
RUN apt-get install -y libtbb12
RUN apt-get install -y xz-utils 
RUN apt-get update
RUN apt-get install -y libnuma-dev
COPY y-cruncher-v0.8.1.9317-dynamic.tar.xz /
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1"]
