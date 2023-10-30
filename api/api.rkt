#lang racket

(require
  taino/request/req
  taino/response/resp
  taino/server/serve)

(struct title (t) #:mutable)

(define title-header
  (list (title "Chief HTML Officer")
        (title "Remote Funnel Marketing Ninja")
        (title "Content Hero")
        (title "GIF Librarian")))

(define (random-title titles)
  (define index (random (length titles)))
  (define selected-title (list-ref titles index))
  (title-t selected-title))

(define (start req)
  ; (print (get-uri-resource req))
  (resp/text (string->bytes/utf-8 (random-title title-header))))

(server start 8080)