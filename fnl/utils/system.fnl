;; Check if a file or directory exists in this path
(fn exists [file]
  (let [(ok err code) (os.rename file file)]
    (if (and (not ok) (= code 13))
      true ;; Permission denied, but it exists
      ok)))

(fn is-dir [path]
  (exists (.. path :/)))

{: exists : is-dir}
