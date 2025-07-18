(fn is-in-arcadia [] (: (vim.fn.getcwd) :match :arcadia))

; (fn get-arc-root [cwd]
;   (let [result (if cwd
;                    (:wait (vim.system [:arc :root] {: cwd}))
;                    (:wait (vim.system [:arc :root])))]
;     [(vim.trim result.stdout) (= 0 result.code)]))
;
; (get-arc-root)
;
; (fn get-url-in-arcadia [path]
;   (var path! (or path (vim.fn.expand "%")))
;   (set path! (if (not= (string.sub path! 1 1) "/")
;                  (do
;                    (vim.print path!)
;                    (.. (vim.fn.getcwd) "/" path!))
;                  path!))
;   (let [dir (string.gsub path! "(.*)/.*" "%1")]
;     (vim.print dir)
;     (let [[root ok] (get-arc-root dir)]
;       (if (not ok)
;           (do
;             (vim.print "File is not in arc repo")
;             nil)
;           (let [arc-path (string.gsub path! (.. "^" root) "")]
;             (.. "https://a.yandex-team.ru/arcadia" arc-path))))))
;
; (fn open-in-arcadia [path line]
;   (var url (get-url-in-arcadia path))
;   (when url
;     (when line
;       (if (= line :line)
;           (set url
;                (.. url "#L" (tostring (. (vim.api.nvim_win_get_cursor 0) 1))))
;           (= line :range)
;           (do
;             (vim.print :normal)
;             (vim.cmd "execute \"normal! \\<ESC>\"")
;             (let [start (. (vim.api.nvim_buf_get_mark 0 "<") 1)
;                   endl (. (vim.api.nvim_buf_get_mark 0 ">") 1)]
;               (if (= start endl)
;                   (set url (.. url "#L" start))
;                   (set url (.. url "#L" start "-" endl)))))))
;     (vim.ui.open url)))
;
; (fn arcadia-map [mode]
;   (fn [] (open-in-arcadia nil mode)))

; => 3

{: is-in-arcadia}
