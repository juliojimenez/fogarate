#lang racket

(require
  web-server/dispatch
  web-server/servlet-env
  web-server/http)

(struct title (t) #:mutable)

(struct wise-quote (q) #:mutable)

(define title-header
  (list (title "Chief HTML Officer")
        (title "Remote Funnel Marketing Ninja")
        (title "Content Hero")
        (title "GIF Librarian")
        (title "Galactic Viceroy of Research Excellence")
        (title "Innovation Sherpa")))

(define lao-tzu-quotes
  (list (wise-quote "Be the chief but never the lord.")
        (wise-quote "Because of a great love, one is courageous.")
        (wise-quote "Simulated disorder postulates perfect discipline; simulated fear postulates courage; simulated weakness postulates strength.")
        (wise-quote "A scholar who cherishes the love of comfort is not fit to be deemed a scholar.")))

(define (random-title titles)
  (define index (random (length titles)))
  (define selected-title (list-ref titles index))
  (title-t selected-title))

(define (random-quote quotes)
  (define index (random (length quotes)))
  (define selected-quote (list-ref quotes index))
  (wise-quote-q selected-quote))

(define (resp/text #:text t 
                   #:code [c 200]
                   #:headers [h (list (make-header 
                                        #"Content-Type" #"text/plain;charset=us-ascii")
                                      (make-header
                                        #"Access-Control-Allow-Origin" #"https://julio.sh"))])
  (response/output
    (λ (op) (write-bytes t op))
    #:code c
    #:message #"OK"
    #:seconds (current-seconds)
    #:mime-type TEXT/HTML-MIME-TYPE
    #:headers h))

(define-values (api-dispatch api-url)
    (dispatch-rules
      [("") health]
      [("title") get-title]
      [("lao-tzu") get-lao-tzu]))

(define (health req)
  (resp/text #"OK"))

(define (get-title req)
  (resp/text (string->bytes/utf-8 (random-title title-header))))

(define (get-lao-tzu req)
  (resp/text (string->bytes/utf-8 (random-quote lao-tzu-quotes))))

(serve/servlet
  api-dispatch
  #:command-line? #t
  #:listen-ip "0.0.0.0"
  #:port 8080
  #:servlet-path ""
  #:servlet-regexp #rx"")
