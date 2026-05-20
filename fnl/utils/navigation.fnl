(fn diagnostic-goto [next ?severity]
  (let [count (if next 1 -1)
        severity (when ?severity (. vim.diagnostic.severity ?severity))]
    (fn [] (vim.diagnostic.jump {: count : severity}))))

{ : diagnostic-goto }
