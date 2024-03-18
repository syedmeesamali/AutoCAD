(defun c:CircleExport ()
  (setq ss (ssget (list (cons 0 "CIRCLE")))) ;;Select Circles
  (if ss
    (progn
      (setq itm 0 num (sslength sset))
      (setq fn (getfiled "Point Export File" "" "txt" 1))
      (if (/= fn nil)
        (progn
          (setq fh (open fn "w"))
          (while (< itm num) ;; while itm < num
            (setq hnd (ssname ss itm))  ;; hnd is the name of each item
            (setq ent (entget hnd))
            (setq obj (cdr (assoc 0 ent)))
            (cond 
              ((= obj "CIRCLE")
                (setq pnt (cdr (assoc 40 ent))) ;; 10 is the code for circle center
                (princ (strcat 
                               (rtos pnt 2 2) " mm Dia." ) fh)

			       ;;(rtos (cadr pnt) 2 2)) fh)
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