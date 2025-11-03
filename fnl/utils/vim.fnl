;; [nfnl-macro]

(fn set! [opt val?]
  `(tset vim :opt ,(tostring opt) ,(if (= val? nil) true val?)))

(fn map! [mode seq cmd desc?]
  (lambda string-split [str]
    (let [tbl []]
      (string.gsub str "." (fn [c] (table.insert tbl c)))
      tbl))

  `(vim.keymap.set ,(string-split (tostring mode)) ,seq ,cmd ,(when (not (= nil desc?)) { :desc desc? })))

;---
; (plug! beep :setup {:x 20 :y 30})
; >> require("beep").setup({ x = 20, y = 30})
;---
(fn plug! [plug path & opts]
  `((. (require ,(tostring plug)) ,(if (= (type path) :table) (unpack path) path))
    ,(unpack opts)))

{: set! : map! : plug!}
