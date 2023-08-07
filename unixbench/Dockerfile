FROM ubuntu
RUN apt-get update
RUN apt-get install -y net-tools
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install make
RUN apt-get update
RUN apt-get install -y gcc-multilib
#COPY unixbench .
RUN apt-get install -y git
RUN git clone https://github.com/kdlucas/byte-unixbench.git
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN pip install pandas
COPY entrypoint.sh /
COPY mergeCSV.py /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1", "1", "1", "runc"]