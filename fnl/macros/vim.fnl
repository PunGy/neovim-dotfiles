;; [nfnl-macro]

(fn set! [opt val?]
  `(tset vim :opt ,(tostring opt) ,(if (= val? nil) true val?)))

(fn set-local! [opt val?]
  `(tset vim :opt_local ,(tostring opt) ,(if (= val? nil) true val?)))

(fn split-modes [mode]
  (let [tbl []]
    (string.gsub (tostring mode) "." (fn [c] (table.insert tbl c)))
    tbl))

(fn map! [mode lhs rhs ?opts]
  `(vim.keymap.set ,(split-modes mode) ,lhs ,rhs ,(or ?opts {})))

;---
; Compile-time string builders. Argument must be a literal string or keyword:
;   (cmd! :w)              -> "<cmd>w<cr>"
;   (cmd! "FzfLua files")  -> "<cmd>FzfLua files<cr>"
;   (term-cmd! "git push") -> "<cmd>terminal git push<cr>"
; Passing a runtime variable is unsafe — the macro will inline the variable's
; *name*, not its value.
;---
(fn cmd! [c]
  (.. "<cmd>" (tostring c) "<cr>"))

(fn term-cmd! [c]
  (.. "<cmd>terminal " (tostring c) "<cr>"))

;---
; (plug! :foo :bar {:x 1})
; >> require("foo").bar({ x = 1 })
;---
(fn plug! [plug method & args]
  `((. (require ,(tostring plug)) ,(tostring method)) ,(unpack args)))

;---
; (plug-setup! :foo {:x 1})
; >> require("foo").setup({ x = 1 })
;---
(fn plug-setup! [plug ?opts]
  `((. (require ,(tostring plug)) :setup) ,(or ?opts {})))

{: set! : set-local! : map! : plug! : plug-setup! : cmd! : term-cmd!}
