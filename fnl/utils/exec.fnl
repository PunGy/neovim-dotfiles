;; [nfnl-macro]

(import-macros {: plug!} :utils.vim)

(fn cmd$ [cmd]
  (values (.. "<cmd>" cmd "<cr>")))

{: cmd$}
