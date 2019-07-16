(defun c:test ( / lst)
  (foreach x '(1 2 3 4 5)
    (setq lst (cons x lst))
   )

  (print lst)
  (princ)
 )