(import-macros {: map!} :macros.vim)

(local {: cmd : term-cmd} (require :utils.exec))
(local {: is-in-arcadia} (require :utils.yndx))

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

                     (map! n "]h" #(gs.nav_hunk :next)
                           {:desc "Next hunk" :silent true :buffer true})
                     (map! n "[h" #(gs.nav_hunk :prev)
                           {:desc "Prev hunk" :silent true :buffer true})
                     (map! nv :<leader>vs (cmd ":Gitsigns stage_hunk")
                           {:desc "Stage Hunk" :silent true :buffer true})
                     (map! nv :<leader>vr (cmd ":Gitsigns reset_hunk")
                           {:desc "Reset Hunk" :silent true :buffer true})
                     (map! n :<leader>vS gs.stage_buffer
                           {:desc "Stage Buffer" :silent true :buffer true})
                     (map! n :<leader>vu gs.undo_stage_hunk
                           {:desc "Undo Stage Hunk"
                            :silent true
                            :buffer true})
                     (map! n :<leader>vR gs.reset_buffer
                           {:desc "Reset Buffer" :silent true :buffer true})
                     (map! n :<leader>vp gs.preview_hunk_inline
                           {:desc "Preview Hunk Inline"
                            :silent true
                            :buffer true})
                     (map! n :<leader>vb #(gs.blame_line {:full true})
                           {:desc "Blame Line" :silent true :buffer true})
                     (map! n :<leader>vB #(gs.blame)
                           {:desc "Blame Buffer" :silent true :buffer true})
                     (map! n :<leader>vd gs.diffthis
                           {:desc "Diff This" :silent true :buffer true})
                     (map! n :<leader>vD #(gs.diffthis "~")
                           {:desc "Diff This ~" :silent true :buffer true})
                     (map! ox :ih (cmd ":<C-U>Gitsigns select_hunk")
                           {:desc "GitSigns Select Hunk"
                            :silent true
                            :buffer true})
                     ;; Git management commands
                     (map! n :<leader>vms
                           (term-cmd
                             "git add . && git commit -m $(timestamp) && git push")
                           {:desc "Save changes and push"
                            :silent true
                            :buffer true})
                     (map! n :<leader>vmP (term-cmd "git push")
                           {:desc "Push" :silent true :buffer true})
                     (map! n :<leader>vmp (term-cmd "git pull")
                           {:desc "Pull" :silent true :buffer true})
                     (map! n :<leader>vmh (term-cmd "git stash")
                           {:desc "Stash changes (hide)"
                            :silent true
                            :buffer true})
                     (map! n :<leader>vmu (term-cmd "git stash pop")
                           {:desc "Unstash changes (unhide)"
                            :silent true
                            :buffer true}))})

;; IF arcadia mounted AND we are inside mounted instance - load arc vcs
[(if (is-in-arcadia)
     ;; Patched gitsigns for arc vcs
     {:dir "~/arcadia/contrib/tier1/gitsigns.arc.nvim"
      :dev true
      :opts gitsigns-opts}
     ;; Plain gitsigns
     {1 :lewis6991/gitsigns.nvim :opts gitsigns-opts})]
