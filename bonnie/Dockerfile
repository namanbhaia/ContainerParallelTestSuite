FROM ubuntu
RUN apt-get update
RUN apt-get install bonnie++
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["1"]
