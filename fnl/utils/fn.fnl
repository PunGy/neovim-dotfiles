(fn find [lst pred]
  (match lst
    (where [a] (pred a)) a
    [a & rest] (find rest pred)
    _ nil))

(fn tail [lst]
  (case lst
    [a & tail] tail
    _ []))

(fn head [lst]
  (case lst
    [a] a
    _ nil))

{: head : tail : find }
