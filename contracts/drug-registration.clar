;; Drug Registration Contract

;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-found (err u102))

;; Define data structures
(define-map drugs
  { drug-id: (string-ascii 32) }
  {
    manufacturer: principal,
    name: (string-ascii 64),
    batch-number: (string-ascii 32),
    manufacture-date: uint,
    expiry-date: uint,
    current-owner: principal
  }
)

;; Define public functions
(define-public (register-drug (drug-id (string-ascii 32)) (name (string-ascii 64)) (batch-number (string-ascii 32)) (manufacture-date uint) (expiry-date uint))
  (let ((caller tx-sender))
    (asserts! (is-eq caller contract-owner) err-unauthorized)
    (asserts! (is-none (map-get? drugs { drug-id: drug-id })) err-already-registered)
    (ok (map-set drugs
      { drug-id: drug-id }
      {
        manufacturer: caller,
        name: name,
        batch-number: batch-number,
        manufacture-date: manufacture-date,
        expiry-date: expiry-date,
        current-owner: caller
      }
    ))
  )
)

(define-public (transfer-ownership (drug-id (string-ascii 32)) (new-owner principal))
  (let ((drug (unwrap! (map-get? drugs { drug-id: drug-id }) err-not-found))
        (caller tx-sender))
    (asserts! (is-eq (get current-owner drug) caller) err-unauthorized)
    (ok (map-set drugs
      { drug-id: drug-id }
      (merge drug { current-owner: new-owner })
    ))
  )
)

;; Define read-only functions
(define-read-only (get-drug-info (drug-id (string-ascii 32)))
  (map-get? drugs { drug-id: drug-id })
)

