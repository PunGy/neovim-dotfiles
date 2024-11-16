(fn diagnostic-goto [next ?severity]
  (let [go (or (and next vim.diagnostic.goto_next) vim.diagnostic.goto_prev)
        severity (or (and ?severity (. vim.diagnostic.severity ?severity)) nil)]
    (fn [] (go {: severity}))))

{ : diagnostic-goto }
