#lang racket

;; fogaraté API

;; -------
;; imports
;; -------

(require
  web-server/dispatch     ;; Dispatch Rules
  web-server/servlet-env  ;; Runs the servlet
  web-server/http)        ;; Responses and Requests

;; -----------
;; data models
;; -----------

(struct title (t) #:mutable)
(struct wise-quote (q) #:mutable)

;; -----------------------------
;; stuff that will eventually be
;; replaced with ClickHouse
;; -----------------------------

(define title-header
  ; fun job titles
  (list (title "Chief HTML Officer")
        (title "Remote Funnel Marketing Ninja")
        (title "Content Hero")
        (title "GIF Librarian")
        (title "Galactic Viceroy of Research Excellence")
        (title "Innovation Sherpa")))

(define lao-tzu-quotes
  ; feeling enlightened
  (list (wise-quote "Be the chief but never the lord.")
        (wise-quote "Because of a great love, one is courageous.")
        (wise-quote "Simulated disorder postulates perfect discipline; simulated fear postulates courage; simulated weakness postulates strength.")
        (wise-quote "A scholar who cherishes the love of comfort is not fit to be deemed a scholar.")
        (wise-quote "If the Great Way perishes there will morality and duty. When cleverness and knowledge arise great lies will flourish. When relatives fall out with one another there will be filial duty and love. When states are in confusion there will be faithful servants.")
        (wise-quote "To know yet to think that one does not know is best; Not to know yet to think that one knows will lead to difficulty.")))

;; -----
;; utils
;; -----

(define (random-title titles)
  ; returns a random job title
  (define index (random (length titles)))
  (define selected-title (list-ref titles index))
  (title-t selected-title))

(define (random-quote quotes)
  ; returns a random quote
  (define index (random (length quotes)))
  (define selected-quote (list-ref quotes index))
  (wise-quote-q selected-quote))

;; ----------------
;; request handlers
;; ----------------

(define (handle-options req)
  (response/full
    #:code 200
    #:message #"OK"
    #:header (list
               (make-header #"Access-Control-Allow-Origin" #"*")
               (make-header #"Access-Control-Allow-Methods" #"GET, POST, PUT, DELETE, OPTIONS")
               (make-header #"Access-Control-Allow-Headers" #"Content-Type, Authorization")
               (make-header #"Access-Control-Max-Age" #"86400")
               (make-header #"Content-Length" #"0"))))

(define (resp/text #:request r
                   #:text t 
                   #:code [c 200]
                   #:headers [h (list (make-header 
                                        #"Content-Type" #"text/html;charset=utf-8")
                                      (make-header
                                        #"Access-Control-Allow-Origin" #"*")
                                      (make-header #"Access-Control-Allow-Methods" #"GET, POST, PUT, DELETE, OPTIONS")
                                      (make-header 
                                        #"Access-Control-Allow-Headers" #"Content-Type, Authorization")
                                      (make-header 
                                        #"Access-Control-Max-Age" #"86400"))])
  (match (request-method r)
    [(or #"GET" #"POST" #"PUT" #"DELETE")
      (response/output
        (λ (op) (write-bytes t op))
          #:code c
          #:message #"OK"
          #:seconds (current-seconds)
          #:mime-type TEXT/HTML-MIME-TYPE
          #:headers h)]
    [#"OPTIONS"
      (handle-options r)]))

(define (health req)
  (resp/text #:request req #:text #"OK"))

(define (get-title req)
  (resp/text #:request req #:text (string->bytes/utf-8 (random-title title-header))))

(define (get-lao-tzu req)
  (resp/text #:request req #:text (string->bytes/utf-8 (random-quote lao-tzu-quotes))))

(define-values (api-dispatch api-url)
    (dispatch-rules
      [("") health]
      [("title") get-title]
      [("lao-tzu") get-lao-tzu]))

(serve/servlet
  api-dispatch
  #:command-line? #t
  #:listen-ip "0.0.0.0"
  #:port 8080
  #:servlet-path ""
  #:servlet-regexp #rx"")
