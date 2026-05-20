(fn cmd [c]
  (.. "<cmd>" c "<cr>"))

(fn term-cmd [c]
  (.. "<cmd>terminal " c "<cr>"))

{: cmd : term-cmd}
