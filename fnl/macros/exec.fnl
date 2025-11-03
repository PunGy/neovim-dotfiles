;; [nfnl-macro]

(import-macros {: plug!} :macros.vim)

(fn cmd$ [cmd]
  (values (.. "<cmd>" cmd "<cr>")))

{: cmd$}
