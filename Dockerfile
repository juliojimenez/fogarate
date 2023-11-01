FROM racket/racket:latest
WORKDIR /api
COPY api .
RUN raco setup --no-docs
RUN raco pkg install --auto --no-docs web-server
EXPOSE 8080
ENTRYPOINT [ "/api/entrypoint.sh" ]
