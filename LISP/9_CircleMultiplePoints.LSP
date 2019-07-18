(defun c:drawc (/ a b i) ;;Define main variables
 (if (and (setq a (ssget '((0 . "point"))))  ;; Get point entity and save in variable a
   (setq b (getdist "\nSpecify Circle Radius : ")) ;; Circle radius to be saved in b
   )
   (repeat (setq i (sslength a))  ;; Repeat i number of times ;; i is obtained from selection
     (entmakex (list (cons 0 "CIRCLE") (assoc 10 (entget (ssname a (setq i (1- i)))))  ;;this part CREATES circles based on entry point and radius
      (cons 40 b)
)
     )
   )
 )
 (princ)
)