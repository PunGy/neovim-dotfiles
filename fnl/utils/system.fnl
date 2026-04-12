;; Check if a file or directory exists in this path
(fn exists [file]
  (let [(ok err code) (os.rename file file)]
    (if (and (not ok) (= code 13))
      true ;; Permission denied, but it exists
      ok)))

(fn is-dir [path]
  (exists (.. path :/)))

(fn shell-cmd [cmd]
  (let [output (vim.fn.system cmd)]
    (if (= vim.v.shell_error 0)
      (string.sub output 1 -2)
      (vim.notify (.. "Command failed: " output) vim.log.levels.ERROR))))

{: exists : is-dir : shell-cmd}
