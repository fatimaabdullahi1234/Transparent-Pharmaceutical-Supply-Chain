;; Recall Management Contract

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-recalled (err u102))

;; Define data structures
(define-map recalls
  { recall-id: (string-ascii 32) }
  {
    drug-id: (string-ascii 32),
    batch-numbers: (list 10 (string-ascii 32)),
    reason: (string-ascii 256),
    date-issued: uint,
    status: (string-ascii 16)
  }
)

(define-map recall-responses
  { recall-id: (string-ascii 32), responder: principal }
  {
    response-date: uint,
    quantity-returned: uint,
    notes: (string-ascii 256)
  }
)

;; Define public functions
(define-public (issue-recall (recall-id (string-ascii 32)) (drug-id (string-ascii 32)) (batch-numbers (list 10 (string-ascii 32))) (reason (string-ascii 256)))
  (let ((caller tx-sender))
    (asserts! (is-eq caller contract-owner) err-unauthorized)
    (asserts! (is-none (map-get? recalls { recall-id: recall-id })) err-already-recalled)
    (ok (map-set recalls
      { recall-id: recall-id }
      {
        drug-id: drug-id,
        batch-numbers: batch-numbers,
        reason: reason,
        date-issued: block-height,
        status: "ACTIVE"
      }
    ))
  )
)

(define-public (respond-to-recall (recall-id (string-ascii 32)) (quantity-returned uint) (notes (string-ascii 256)))
  (let ((caller tx-sender))
    (asserts! (is-some (map-get? recalls { recall-id: recall-id })) err-not-found)
    (ok (map-set recall-responses
      { recall-id: recall-id, responder: caller }
      {
        response-date: block-height,
        quantity-returned: quantity-returned,
        notes: notes
      }
    ))
  )
)

(define-public (close-recall (recall-id (string-ascii 32)))
  (let ((caller tx-sender)
        (recall (unwrap! (map-get? recalls { recall-id: recall-id }) err-not-found)))
    (asserts! (is-eq caller contract-owner) err-unauthorized)
    (ok (map-set recalls
      { recall-id: recall-id }
      (merge recall { status: "CLOSED" })
    ))
  )
)

;; Define read-only functions
(define-read-only (get-recall-info (recall-id (string-ascii 32)))
  (map-get? recalls { recall-id: recall-id })
)

(define-read-only (get-recall-response (recall-id (string-ascii 32)) (responder principal))
  (map-get? recall-responses { recall-id: recall-id, responder: responder })
)

