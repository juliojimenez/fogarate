#lang racket

(require
  taino/request/req
  taino/response/resp
  taino/server/serve)

(struct title (t) #:mutable)

(struct quote (q) #:mutable)

(define title-header
  (list (title "Chief HTML Officer")
        (title "Remote Funnel Marketing Ninja")
        (title "Content Hero")
        (title "GIF Librarian")
        (title "Galactic Viceroy of Research Excellence")
        (title "Innovation Sherpa")))

(define lao-tzu-quotes
  (list (quote "Be the chief but never the lord.")
        (quote "Because of a great love, one is courageous.")))

(define (random-title titles)
  (define index (random (length titles)))
  (define selected-title (list-ref titles index))
  (title-t selected-title))

(define (start req)
  ; (print (get-uri-resource req))
  (resp/text (string->bytes/utf-8 (random-title title-header))))

(server start 8080)