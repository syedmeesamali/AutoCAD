;;
;; Original Routine for POINT/LWPOLYLINE by DotSoft.com
;;
;; Updated (very DIRTY) for CIRCLEs by Patrice 
;; 
;; Routine has to be optimized / purged from unused code ...
;; and LOCAL variables must be declared ... 
;;
;;--- Interrogation Entite/Objet en Lisp ---
;; (entget (car (entsel)) '("*"))
;; 

(defun c:CircleExport ()

  (setq sset (ssget '((-4 . "<OR")
;;                                (0 . "POINT")
;;                                (0 . "LWPOLYLINE") 
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

;;            ((= obj "POINT") 
              ((= obj "CIRCLE")
                (setq pnt (cdr (assoc 10 ent)))
                (princ (strcat 

;;                             (rtos (car  pnt) 2 8) ","
;;                             (rtos (cadr pnt) 2 8) ","

                               (rtos (car  pnt) 2 8) ";"
                               (rtos (cadr pnt) 2 8) ";"

                               (rtos (caddr pnt) 2 8)) fh)
                (princ "\n" fh)
              ) 

;             ((= obj "LWPOLYLINE")
;               (if (= (cdr (assoc 38 ent)) nil)
;                 (setq elv 0.0)
;                 (setq elv (cdr (assoc 38 ent)))
;               )
;               (foreach rec ent
;                 (if (= (car rec) 10)
;                   (progn
;                     (setq pnt (cdr rec))
;                     (princ (strcat 

;;;;                                 (rtos (car  pnt) 2 8) ","
;;;;                                 (rtos (cadr pnt) 2 8) ","

;                                    (rtos (car  pnt) 2 8) ";"
;                                    (rtos (cadr pnt) 2 8) ";"


;                                    (rtos elv 2 8)) fh)
;                     (princ "\n" fh) 
;                   ) 

;                 )
;               )
;              )

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