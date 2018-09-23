FROM alpine

RUN apk --update add netcat-openbsd curl bash

CMD ["bash", "-c", "FLAG=$(echo | nc -q 0 problem 8080) && curl http://flag-submit:8080 --data \"$FLAG\""]
