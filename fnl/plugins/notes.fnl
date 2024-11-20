(import-macros {: plug!} :utils.macros)
(import-macros {: map! : exec!} :hibiscus.vim)
(local {: insert-timestamp } (require :utils.vim))

(macro zkcmd! [cmd opts]
  `(((. (require :zk.commands) :get) ,cmd) ,opts))

(local keymaps
       (fn []
         (map! [n] :<A-n>
               (fn []
                 (let [title (vim.fn.input "Title: ")]
                   (zkcmd! :ZkNew {: title}))))
         (map! [n] :<leader>nf #(zkcmd! :ZkNotes) "Find note")
         (map! [n] :<leader>nd #(zkcmd! :ZkNew {:group :daily :dir :daily}) "Open daily note")
         (map! [ni] "<A-;>" insert-timestamp)))

(local on-attach (fn []
                   (keymaps)))

{1 :zk-org/zk-nvim
 :config (fn []
           (plug! :zk :setup {:picker :fzf_lua})
           (on-attach))}
