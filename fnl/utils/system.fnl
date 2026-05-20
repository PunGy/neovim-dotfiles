;; Check if a file or directory exists in this path
(fn exists [path]
  (not= (vim.uv.fs_stat path) nil))

(fn is-dir [path]
  (let [stat (vim.uv.fs_stat path)]
    (and stat (= stat.type :directory))))

(fn shell-cmd [cmd]
  (let [output (vim.fn.system cmd)]
    (if (= vim.v.shell_error 0)
      (string.sub output 1 -2)
      (vim.notify (.. "Command failed: " output) vim.log.levels.ERROR))))

{: exists : is-dir : shell-cmd}
