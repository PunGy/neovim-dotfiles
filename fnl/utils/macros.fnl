;; fennel-ls: macro-file

;; Execute plugin command
(fn plug! [plugin cmd & opts]
  `((. (require ,plugin) ,cmd) ,(unpack opts)))

;; Execute plugin command -> every other plug should be replaced with this one
(fn plug-> [plugin cmd & opts]
  `((. (require ,plugin) ,(unpack cmd)) ,(unpack opts)))


;; Create a handler which executes a command
(fn plug$ [plugin cmd & opts]
  `(fn [] ((. (require ,plugin) ,cmd) ,(unpack opts))))
;; create a handler for executing vim command
(fn cmd$ [cmd]
  (values (.. "<cmd>" cmd "<cr>")))

;; create a handler for executing terminal command
(fn term$ [cmd]
  (values (.. "<cmd>terminal " cmd "<cr>")))



{: plug-> : plug! : plug$ : cmd$ : term$}
