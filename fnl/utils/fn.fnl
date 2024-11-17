(fn find [lst pred]
  (match lst
    (where [a] (pred a)) a
    [a & rest] (find rest pred)
    _ nil))

(let [items [1 2 3 4 5]]
  (find items (fn [item] (= item 3))))

(fn tail [lst]
  (case lst
    [a & tail] tail
    _ nil))

(fn head [lst]
  (case lst
    [a] a
    _ nil))

{: head : tail : find }
