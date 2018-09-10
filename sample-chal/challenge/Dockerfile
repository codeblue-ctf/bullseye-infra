FROM alpine

RUN apk --update add netcat-openbsd bash

CMD ["bash", "-c", "cat /flag | nc -l 8080"]
