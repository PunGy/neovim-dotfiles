(import-macros {: plug!} :utils.macros)
(import-macros {: map! : exec!} :hibiscus.vim)
(local {: insert-timestamp} (require :utils.vim))
(local {: is-dir} (require :utils.system))

(fn insert-timestamp []
  (let [timestamp (os.date "(%H:%M): ")]
    (vim.api.nvim_put [timestamp] :c true true)))

(fn make-list [type]
  (local list-str "- [ ] ")
  (if (= type :new-list)
      (let [[current-line] (vim.api.nvim_win_get_cursor 0)]
        (vim.api.nvim_put [list-str] :l true true)
        (vim.api.nvim_win_set_cursor 0 [(+ current-line 1) (length list-str)]))))

(macro zkcmd! [cmd opts]
  `(((. (require :zk.commands) :get) ,cmd) ,opts))

(local keymaps (fn []
                 (map! [n] :<A-n>
                       (fn []
                         (let [title (vim.fn.input "Title: ")]
                           (when (not= title "")
                             (zkcmd! :ZkNew {: title})))))
                 (map! [n] :<leader>nf #(zkcmd! :ZkNotes) "Find note by name")
                 (map! [n] :<leader>nt #(zkcmd! :ZkTags) "Notes by tag")
                 (map! [n] :<leader>nb #(zkcmd! :ZkBacklinks) "Find links to this note")
                 (map! [n] :<leader>nl #(zkcmd! :ZkLinks) "Show links in this note")
                 (map! [n] :<leader>nd
                       #(zkcmd! :ZkNew {:group :daily :dir :daily})
                       "Open daily note")
                 (map! [ni] "<A-;>" insert-timestamp)
                 (map! [ni] :<A-o> #(make-list :new-list))))

(if (is-dir (.. (vim.fn.getcwd) :/.zk))
    {1 :zk-org/zk-nvim
     :config (fn []
               (plug! :zk :setup
                      {:picker :fzf_lua
                       :lsp {:config {:cmd [:zk :lsp] :name :zk}}})
               (keymaps))}
    {})
