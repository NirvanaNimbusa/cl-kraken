;;;; cl-kraken/tests/ticker.lisp

(defpackage #:cl-kraken/tests/ticker
  (:use #:cl #:rove)
  (:import-from #:jsown
                #:filter))
(in-package #:cl-kraken/tests/ticker)

(deftest ticker
  (testing "when passed \"xBteuR\", evaluates to XBTEUR ticker"
    (let* ((response (cl-kraken:ticker "xBteuR"))
           (error!   (filter response "error"))
           (result   (filter response "result"))
           (pair     (filter result "XXBTZEUR"))
           (ask      (filter pair "a"))
           (bid      (filter pair "b"))
           (closed   (filter pair "c"))
           (volume   (filter pair "v"))
           (vwap     (filter pair "p"))
           (number   (filter pair "t"))
           (low      (filter pair "l"))
           (high     (filter pair "h"))
           (open     (filter pair "o")))
      (ok (null error!))
      (ok (consp result))
      (ok (= (length result) 2))
      (ok (consp pair))
      (ok (= (length pair) 10))
      (ok (consp ask))
      (ok (= (length ask) 3))
      (ok (consp bid))
      (ok (= (length bid) 3))
      (ok (consp closed))
      (ok (= (length closed) 2))
      (ok (consp volume))
      (ok (= (length volume) 2))
      (ok (consp vwap))
      (ok (= (length vwap) 2))
      (ok (consp number))
      (ok (= (length number) 2))
      (ok (consp low))
      (ok (= (length low) 2))
      (ok (consp high))
      (ok (stringp open))
      (ok (= (length high) 2))))
  (testing "when passed \" xbtjpy ,ETCusd \", evaluates to XBTJPY+ETCUSD ticker"
    (let* ((response (cl-kraken:ticker " xbtjpy ,ETCusd "))
           (error!   (filter response "error"))
           (result   (filter response "result"))
           (pair-1   (filter result "XXBTZJPY"))
           (pair-2   (filter result "XETCZUSD")))
      (ok (null error!))
      (ok (consp result))
      (ok (= (length result) 3))
      (ok (consp pair-1))
      (ok (= (length pair-1) 10))
      (ok (consp pair-2))
      (ok (= (length pair-2) 10))))
  (testing "when passed an invalid PAIR, evaluates to unknown asset pair error"
    (ok (equal (cl-kraken:ticker "abc")
               '(:OBJ ("error" "EQuery:Unknown asset pair")))))
  (testing "when passed an empty PAIR, evaluates to unknown asset pair error"
    (ok (equal (cl-kraken:ticker "")
               '(:OBJ ("error" "EQuery:Unknown asset pair")))))
  (testing "when passed a symbol PAIR, a type error is signaled"
    (ok (signals (cl-kraken:ticker 'xbteur) 'type-error)
        "The value of PAIR is XBTEUR, which is not of type (AND STRING (NOT NULL))."))
  (testing "when passed a keyword PAIR, a type error is signaled"
    (ok (signals (cl-kraken:ticker :xbteur) 'type-error)
        "The value of PAIR is :XBTEUR, which is not of type (AND STRING (NOT NULL)).")))
