(defun c:COV (/ foo ss)
 ;; Circles On Vertices (create circle on vertices of selected Arcs, Lines, *Polylines, Splines)
 ;; Alan J. Thompson, 09.09.10 / 09.22.10

 (defun foo (p)
   (if (vl-consp p)
     (or (vl-member-if
           (function (lambda (a) (equal (list (car a) (cadr a)) (list (car p) (cadr p)))))
           plst
         )
         (setq plst (cons (cdr
                            (assoc 10
                                   (entmake (list '(0 . "CIRCLE") (cons 10 p) (cons 40 *COV:RAD*)))
                            )
                          )
                          pLst
                    )
         )
     )
   )
 )

 (if (and (setq ss (ssget '((0 . "ARC,LINE,*POLYLINE,SPLINE"))))
          (not (initget 6))
          (setq *COV:RAD* (cond ((getdist (strcat "\nSpecify circle radius"
                                                  (if *COV:RAD*
                                                    (strcat " <" (rtos *COV:RAD*) ">: ")
                                                    ": "
                                                  )
                                          )
                                 )
                                )
                                (*COV:RAD*)
                          )
          )
     )
   ((lambda (i / e eLst p pLst)
      (while (setq e (ssname ss (setq i (1+ i))))
        (cond
          ((vl-position (cdr (assoc 0 (setq eLst (entget e)))) '("ARC" "LINE" "SPLINE"))
           (mapcar (function foo) (list (vlax-curve-getStartPoint e) (vlax-curve-getEndPoint e)))
          )
          ((vl-position (cdr (assoc 0 eLst)) '("LWPOLYLINE" "POLYLINE"))
           (repeat (setq p (1+ (fix (vlax-curve-getEndParam e))))
             (foo (vlax-curve-getPointAtParam e (setq p (1- p))))
           )
          )
        )
      )
    )
     -1
   )
 )
 (princ)
)