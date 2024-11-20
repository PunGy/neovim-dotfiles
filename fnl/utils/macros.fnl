;; fennel-ls: macro-file

;; Execute plugin command
(fn plug! [plugin cmd & opts]
  `((. (require ,plugin) ,cmd) ,(unpack opts)))

;; Create a handler which executes a command
(fn plug$ [plugin cmd & opts]
  `(fn [] ((. (require ,plugin) ,cmd) ,(unpack opts))))

;; create a handler for executing vim command
(fn cmd$ [cmd]
  (values (.. "<cmd>" cmd "<cr>")))



{: plug! : plug$ : cmd$}
