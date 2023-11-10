#lang racket

;; fogaraté

;; -------
;; imports
;; -------

(require
  web-server/dispatch
  web-server/servlet-env
  web-server/http
  response-ext)

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
  ; absurd job titles
  (list (title "Chief HTML Officer")
        (title "Remote Funnel Marketing Ninja")
        (title "Content Hero")
        (title "GIF Librarian")
        (title "Galactic Viceroy of Research Excellence")
        (title "Innovation Sherpa")
        (title "Digital Prophet")
        (title "Innovation Evangelist")
        (title "Dream Alchemist")
        (title "Time Mage")
        (title "Innovation Alchemist")
        (title "Senior Chaos Monkey")))

(define lao-tzu-quotes
  ; feeling enlightened
  (list (wise-quote "Be the chief but never the lord.")
        (wise-quote "Because of a great love, one is courageous.")
        (wise-quote "Simulated disorder postulates perfect discipline; simulated fear postulates courage; simulated weakness postulates strength.")
        (wise-quote "A scholar who cherishes the love of comfort is not fit to be deemed a scholar.")
        (wise-quote "If the Great Way perishes there will morality and duty. When cleverness and knowledge arise great lies will flourish. When relatives fall out with one another there will be filial duty and love. When states are in confusion there will be faithful servants.")
        (wise-quote "To know yet to think that one does not know is best; Not to know yet to think that one knows will lead to difficulty.")
        (wise-quote "Heaven is long-enduring, and earth continues long. The reason why heaven and earth are able to endure and continue thus long is because they do not live of, or for, themselves.")
        (wise-quote "He who talks more is sooner exhausted.")
        (wise-quote "One who is too insistent on his own views, finds few to agree with him.")
        (wise-quote "Sincere words are not fine; fine words are not sincere.")
        (wise-quote "If you keep feeling a point that has been sharpened, the point cannot long preserve its sharpness.")
        (wise-quote "Man takes his law from the Earth; the Earth takes its law from Heaven; Heaven takes its law from the Tao. The law of the Tao is its being what it is.")))
        
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

(define (resp/text #:request r
                   #:text t 
                   #:code [c 200]
                   #:headers [h (list (make-header 
                                        #"Content-Type" #"text/html;charset=utf-8"))])
  (response/output
    (λ (op) (write-bytes t op))
      #:code c
      #:message #"OK"
      #:seconds (current-seconds)
      #:mime-type TEXT/HTML-MIME-TYPE
      #:headers h))

(define (start req)
  (response/file "src/index.html"))

(define (get-title req)
  (resp/text #:request req #:text (string->bytes/utf-8 (random-title title-header))))

(define (get-lao-tzu req)
  (resp/text #:request req #:text (string->bytes/utf-8 (random-quote lao-tzu-quotes))))

(define-values (api-dispatch api-url)
    (dispatch-rules
      [("") start]
      [("title") get-title]
      [("lao-tzu") get-lao-tzu]))

(serve/servlet
  api-dispatch
  #:command-line? #t
  #:extra-files-paths (list 
                        (build-path 'same "src" "assets" "css") 
                        (build-path 'same "src" "assets" "image") 
                        (build-path 'same "src"))
  #:listen-ip "0.0.0.0"
  #:port 8080
  #:servlet-path ""
  #:servlet-regexp #rx"")