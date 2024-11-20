;(fn concat [lst1 lst2]
;  ;; NASTY IMPERATIVE SHIT
;  (let [result []]
;    ;; Add all elements from the first array
;    (each [_elem1 in lst1]
;      (table.insert result _elem1))
;    ;; Add all elements from the second array
;    (each [_elem2 in lst2]
;      (table.insert result _elem2))
;    result))

(fn find [lst pred]
  (match lst
    (where [a] (pred a)) a
    [a & rest] (find rest pred)
    _ nil))

(fn tail [lst]
  (case lst
    [a & tail] tail
    _ nil))

(fn head [lst]
  (case lst
    [a] a
    _ nil))

(fn filter [lst pred]
  ;(print (vim.inspect lst))
  (let [filtered []]
    (each [_ elem in (ipairs lst)]
      (when (pred elem)
        (table.insert filtered elem)))
    filtered))

{: head : tail : find : filter}
