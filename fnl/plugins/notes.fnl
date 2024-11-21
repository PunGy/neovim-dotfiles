(import-macros {: plug!} :utils.macros)
(import-macros {: map! : exec!} :hibiscus.vim)
(local {: insert-timestamp} (require :utils.vim))

(fn insert-timestamp []
  (let [timestamp (os.date "(%H:%M): ")]
    (vim.api.nvim_put [timestamp] :c true true)))

(fn make-list [type]
  (if (= type :new-list)
      (vim.api.nvim_put ["- [ ] "] :l true true)))

(macro zkcmd! [cmd opts]
  `(((. (require :zk.commands) :get) ,cmd) ,opts))

(local keymaps (fn []
                 (map! [n] :<A-n>
                       (fn []
                         (let [title (vim.fn.input "Title: ")]
                           (when (not= title "")
                             (zkcmd! :ZkNew {: title})))))
                 (map! [n] :<leader>nf #(zkcmd! :ZkNotes) "Find note")
                 (map! [n] :<leader>nd
                       #(zkcmd! :ZkNew {:group :daily :dir :daily})
                       "Open daily note")
                 (map! [ni] "<A-;>" insert-timestamp)
                 (map! [ni] :<A-o> #(make-list :new-list))))

(local on-attach (fn []
                   (keymaps)))

{1 :zk-org/zk-nvim
 :config (fn []
           (plug! :zk :setup {:picker :fzf_lua})
           (on-attach))}
