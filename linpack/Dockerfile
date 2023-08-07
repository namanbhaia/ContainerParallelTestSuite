FROM ubuntu
RUN apt-get update
RUN apt-get install -y net-tools
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get update
RUN apt-get install -y gcc-multilib
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN pip install pandas
COPY linpack.c /
COPY entrypoint.sh /
COPY mergeCSV.py /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1", "1", "1", "runc"]
