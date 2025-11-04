(fn is-in-arcadia [] (: (vim.fn.getcwd) :match :arcadia))

(fn copy-arcadia-path []
  (let [[linenum] (vim.api.nvim_win_get_cursor 0)
        arc-path (string.sub (vim.fn.fnamemodify (vim.fn.expand "%:p") ":~:") 2)]
    (vim.fn.setreg "+" (.. "https://a.yandex-team.ru" arc-path "#L" linenum))))

{: is-in-arcadia : copy-arcadia-path}
