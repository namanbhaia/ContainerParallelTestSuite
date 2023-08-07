FROM ubuntu
RUN apt-get update
RUN apt-get install -y net-tools
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get update
RUN apt-get install -y gcc-multilib
RUN apt-get install -y time
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN pip install pandas
COPY noploop.s /
COPY entrypoint.sh /
COPY mergeCSV.py /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1", "1", "1", "runc"]
