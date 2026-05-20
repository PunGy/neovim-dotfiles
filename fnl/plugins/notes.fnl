(import-macros {: map! : plug-setup!} :macros.vim)

(local {: is-dir} (require :utils.system))

[{1 :zk-org/zk-nvim
  :lazy (not (is-dir (.. (vim.fn.getcwd) :/.zk)))
  :config (fn []
           (fn insert-timestamp []
             (let [timestamp (os.date "(%H:%M): ")]
               (vim.api.nvim_put [timestamp] :c true true)))

           (fn make-list [type]
             (local list-str "- [ ] ")
             (if (= type :new-list)
                 (let [[current-line] (vim.api.nvim_win_get_cursor 0)]
                   (vim.api.nvim_put [list-str] :l true true)
                   (vim.api.nvim_win_set_cursor 0
                                                [(+ current-line 1)
                                                 (length list-str)]))))

           (macro zkcmd! [cmd opts]
             `(((. (require :zk.commands) :get) ,cmd) ,opts))
           (plug-setup! :zk
                        {:picker :fzf_lua
                         :lsp {:config {:cmd [:zk :lsp] :name :zk}}})

           (map! n :<A-n>
                 (fn []
                   (let [title (vim.fn.input "Title: ")]
                     (when (not= title "")
                       (zkcmd! :ZkNew {: title})))))
           (map! n :<localleader>f #(zkcmd! :ZkNotes) {:desc "Find note by name"})
           (map! n :<localleader>t #(zkcmd! :ZkTags) {:desc "Notes by tag"})
           (map! n :<localleader>b #(zkcmd! :ZkBacklinks)
                 {:desc "Find links to this note"})
           (map! n :<localleader>l #(zkcmd! :ZkLinks)
                 {:desc "Show links in this note"})
           (map! n :<localleader>d
                 #(zkcmd! :ZkNew {:group :daily :dir :daily})
                 {:desc "Open daily note"})
           (map! ni "<A-;>" insert-timestamp)
           (map! ni :<A-o> #(make-list :new-list)))}]
