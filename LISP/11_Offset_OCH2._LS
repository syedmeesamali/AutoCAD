;;;;;;;;;;;;;;;;;;;
;; draw text object
(defun Text (pt hgt str color)
 (entmakex (list (cons 0 "TEXT")
                 (cons 10  pt)
                 (cons 40 hgt)
                 (cons 62 color)
                 (cons 1  str)))
)


;;;;;;;;;;;;;;;;;;; Start of Visual Lisp Activex objects
(vl-load-com)

(defun inserttable (lst pt / ht htc tab i j row tb acObj acDoc space)
  ;; settings, text height, cel height
  (setq ht 200)
  (setq htc 380)
 
  ;; document, model space, ...
  (setq acObj (vlax-get-acad-object)
        acDoc (vla-get-activedocument acObj)
        space (vlax-get acDoc (if (= 1 (getvar 'cvport)) 'PaperSpace 'ModelSpace))
  )
  ;; Add table for later to be used for information output
  
  (setq tab (vla-addtable space (vlax-3d-point pt) (length lst) (length (cadr lst)) (* 1.1 ht) (* 10.0 ht)  ))  ;;
  (vla-SetTextHeight tab 1 ht)
  (vla-SetTextHeight tab 2 ht)
  (vla-SetTextHeight tab 4 ht)
 
  (setq i 0)
  (repeat (length lst)  ;; iterates the rows
    (vla-setrowHeight tab i htc)
    (setq row (nth i lst))
    (setq j 0)
    (repeat (length row)  ;; iterates the cols in the row
      (princ "\n")
      (princ  (nth j row))
      (vla-SetText tab i j (nth j row) )
      (setq j (+ j 1))
    )
    (setq i (+ i 1))
  )
  ;; default Autocad expects a totle row.  If the first row has more than 1 cel, let's unmerge this row
  (if (> (length (nth 0 lst)) 1) ;; if length > 1 (for 0th element of lst)
    (vla-unMergeCells tab 0 0 0 0)
  )
  tab
)

(defun c:och2 ( / lst ss bp pt i ip2 radi2)
  ;; select circles
	
  	(setq pt1 "0,33000,0") ;;Change the origin to suit the offset requirements
	(command ".UCS" "Origin" pt1) ;;New Origin for the H2 part of drawings

  (princ "\nSelect circles then press enter: ")
  (setq ss (ssget (list (cons 0 "CIRCLE"))))
  (setq bp (getpoint "\nBase point for offset: "))
  (setq pt (getpoint "\nInsert point of the table: "))


  
  ;; make the list
  (setq lst (list
    (list "Core #" "x-offset" "y-offset" "Radius")  ;; head
  ))
  (setq i 0)
  (repeat (sslength ss)
    (setq ip2 (cdr (assoc 10 (entget (ssname ss i)))))    ;; circle center
    (setq radi2 (cdr (assoc 40 (entget (ssname ss i)))))  ;; circle radius (so we know where to put the label)
    ;; append the list
    (setq lst (append lst (list
      (list  
        (+ i 1)  ;; 1-based counter, Core#
        (rtos (car ip2) 2 1)  ;; 1 decimals, feel free to change this
        (rtos (cadr ip2) 2 1)
        (rtos (* radi2 2.0) 2 2)  ;; radi * 2 means the diameter of each circle to be used
      )
    )))
    (Text
      (list (+ (nth 0 ip2) radi2) (- (nth 1 ip2) radi2) )
      240
      (strcat " " (itoa (+ i 1)))
      160  ;; blue
    )
    (setq i (+ i 1))
  )
  (inserttable lst pt)
)