;; [nfnl-macro]

(import-macros {: plug!} :macros.vim)

(fn cmd$ [cmd]
  (values (.. "<cmd>" cmd "<cr>")))

(fn term$ [cmd]
  (values (.. "<cmd>terminal " cmd "<cr>")))

{: cmd$ : term$}
