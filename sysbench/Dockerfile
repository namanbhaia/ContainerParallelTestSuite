FROM ubuntu
RUN apt-get update
RUN apt-get install -y sysbench
RUN apt-get install -y python3
RUN apt-get install -y pip
RUN pip install pandas
COPY entrypoint.sh /
COPY mergeCSVCPU.py /
COPY mergeCSVMemory.py /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1", "1", "1", "runc"]

