(import-macros {: cmd$ : term$} :macros.exec)
(local {: is-dir} (require :utils.system))
(local {: is-in-arcadia} (require :utils.yndx))


(macro map! [mode seq cmd desc]
  (lambda string-split [str]
    (let [tbl []]
      (string.gsub str "." (fn [c] (table.insert tbl c)))
      tbl))

  `(vim.keymap.set ,(string-split (tostring mode)) ,seq ,cmd ,{ :desc desc :silent true :buffer true }))

;; Common gitsigns config
(local gitsigns-opts
       {:signs {:add {:text "▎"}
                :change {:text "▎"}
                :delete {:text ""}
                :topdelete {:text ""}
                :changedelete {:text "▎"}
                :untracked {:text "▎"}}
        :numhl true
        :current_line_blame true
        :current_line_blame_opts {:virt_text true
                                  :virt_text_pos :eol
                                  :delay 500
                                  :ignore_whitespace false
                                  :virt_text_priority 100}
        :on_attach (fn [bufnr]
                     (local gs (require :gitsigns))

                     (map! n "]h" #(gs.nav_hunk :next) "Next hunk")
                     (map! n "[h" #(gs.nav_hunk :prev) "Prev hunk")
                     (map! nv :<leader>vs
                           (cmd$ ":Gitsigns stage_hunk") "Stage Hunk")
                     (map! nv :<leader>vr
                           (cmd$ ":Gitsigns reset_hunk") "Reset Hunk")
                     (map! n :<leader>vS gs.stage_buffer
                           "Stage Buffer")
                     (map! n :<leader>vu gs.undo_stage_hunk
                           "Undo Stage Hunk")
                     (map! n :<leader>vR gs.reset_buffer
                           "Reset Buffer")
                     (map! n :<leader>vp gs.preview_hunk_inline
                           "Preview Hunk Inline")
                     (map! n :<leader>vb
                           #(gs.blame_line {:full true}) "Blame Line")
                     (map! n :<leader>vB #(gs.blame) "Blame Buffer")
                     (map! n :<leader>vd gs.diffthis "Diff This")
                     (map! n :<leader>vD #(gs.diffthis "~")
                           "Diff This ~")
                     (map! ox :ih (cmd$ ":<C-U>Gitsigns select_hunk")
                           "GitSigns Select Hunk")
                     ;; Git management commands
                     (map! n :<leader>vms
                           (term$ "git add . && git commit -m $(timestamp) && git push")
                           "Save changes and push")
                     (map! n :<leader>vmP
                           (term$ "git push")
                           "Push")
                     (map! n :<leader>vmp (term$ "git pull")
                           "Pull")
                     (map! n :<leader>vmh (term$ "git stash")
                           "Stash changes (hide)")
                     (map! n :<leader>vmu (term$ "git stash pop")
                           "Unstash changes (unhide)"))})

;; IF arcadia mounted AND we are inside mounted instance - load arc vcs
(if (is-in-arcadia)
    ;; Patched gitsigns for arc vcs
    {:dir "~/arcadia/contrib/tier1/gitsigns.arc.nvim"
     :dev true
     :opts gitsigns-opts}
    ;; Plain gitsigns
    {1 :lewis6991/gitsigns.nvim :opts gitsigns-opts})
