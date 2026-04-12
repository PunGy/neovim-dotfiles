(local {: shell-cmd} (require :utils.system))

(fn is-in-arcadia [] (: (vim.fn.getcwd) :match :arcadia))

(fn copy-arcadia-path []
  (let [[linenum] (vim.api.nvim_win_get_cursor 0)
        arc-path (string.sub (vim.fn.fnamemodify (vim.fn.expand "%:p") ":~:") 2)]
    (vim.fn.setreg "+" (.. "https://a.yandex-team.ru" arc-path "#L" linenum))))

(fn status []
  (shell-cmd "arc status -b --no-ahead-behind -s"))

(fn current-branch []
  (shell-cmd "arc status -b --no-ahead-behind -s | head -n 1 | cut -c4-"))

(fn starts-with [text prefix]
  (= (string.sub text 1 (length prefix)) prefix))

(fn current-task []
  (let [output (current-branch)]
    (if (starts-with output :VLG-)
        (let [(desc? _) (string.find output "_")]
          (if desc?
              (string.sub output 1 (- desc? 1))
              output))
        nil)))

{: is-in-arcadia : copy-arcadia-path}
