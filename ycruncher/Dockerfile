FROM ubuntu
RUN apt-get update
RUN apt-get install -y libtbb12
RUN apt-get install -y xz-utils 
RUN apt-get update
RUN apt-get install -y libnuma-dev
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN pip install pandas
COPY entrypoint.sh /
COPY mergeCSV.py /
COPY y-cruncher-v0.8.1.9317-dynamic.tar.xz /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1"]
