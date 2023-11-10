FROM racket/racket:latest
WORKDIR /app
COPY app .
RUN raco setup --no-docs
RUN raco pkg install --auto --no-docs web-server response-ext
EXPOSE 8080
ENTRYPOINT [ "/app/entrypoint.sh" ]
