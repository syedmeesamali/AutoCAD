(defun c:CircleExport ()
  (setq sset (ssget '((-4 . "<OR")
                                  (0 . "CIRCLE")
                      (-4 . "OR>"))))
  (if sset
    (progn
      (setq itm 0 num (sslength sset))
      (setq fn (getfiled "Point Export File" "" "txt" 1))
      (if (/= fn nil)
        (progn
          (setq fh (open fn "w"))
          (while (< itm num)
            (setq hnd (ssname sset itm))
            (setq ent (entget hnd))
            (setq obj (cdr (assoc 0 ent)))
            (cond 
              ((= obj "CIRCLE")
                (setq pnt (cdr (assoc 10 ent)))
                (princ (strcat 
                               (rtos (car  pnt) 2 8) ";"
                               (rtos (cadr pnt) 2 8) ";"
                               (rtos (caddr pnt) 2 8)) fh)
                (princ "\n" fh)
              ) 
              (t nil)
            )
            (setq itm (1+ itm))
          )
          (close fh)
        )
      )
    )
  )
  (princ)
)
(princ "\nCircleExport loaded, type CircleExport to run. ")
(princ)