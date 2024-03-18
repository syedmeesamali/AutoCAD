;;;;;;;;;;;;;;;;;;;
;; draw text object
(defun Text (pt hgt str color)
 (entmakex (list (cons 0 "TEXT")
                 (cons 10  pt)
                 (cons 40 hgt)
                 (cons 62 color)
                 (cons 1  str)))
)

;;;;;;;;;;;;;;;;;;;
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

  (setq tab (vla-addtable space (vlax-3d-point pt) (length lst) (length (cadr lst)) (* 1.1 ht) (* 10.0 ht)  ))  ;;
  (vla-SetTextHeight tab 1 ht)
  (vla-SetTextHeight tab 2 ht)
  (vla-SetTextHeight tab 4 ht)
  
  (vla-put-VertCellMargin tab (* 0.14 ht))
  
  (setq i 0)
  (repeat (length lst)  ;; iterates the rows
    (vla-setrowHeight tab i htc)
    (setq row (nth i lst))
    (setq j 0)
    (repeat (length row)  ;; iterates the cols in the row
      ;;(princ "\n")
      ;;(princ  (nth j row))
      (vla-SetText tab i j (nth j row) )
      (setq j (+ j 1))
    )
    (setq i (+ i 1))
  )
  ;; default Autocad expects a totle row.  If the first row has more than 1 cel, let's unmerge this row
  (if (> (length (nth 0 lst)) 1)
    (vla-unMergeCells tab 0 0 0 0)
  )
  tab
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; there is a list of lists.  (list (list ID IND)) .  If holds a numeric ID (1 2 3 ...);
;; IND holds the index of the unsorted list
;; This function inseerts a new item, its position in the list depending on its ID.
(defun insert_sorted (lst_sorted id ind / lst_new inserted id_ i)
  (setq inserted nil)
  (setq lst_new (list))
  (if (= (length lst_sorted) 0)
    (progn
      ;; first item, so we insert it
      (setq lst_new (list (list
        id ind
      )))
    )
    (progn
      (setq i 0)
      ;; we loop through the existing list.  When the new ID is smaller than the ID in the list  => we insert the new item there
      (foreach item lst_sorted
        (setq id_ (nth 0 item))
        (if (and (= inserted nil) (< id id_)) (progn
          (setq lst_new (append lst_new (list (list
            id ind
          ))))
          (setq inserted T)
        ))
        ;; continue copying the items from lst_sorted to lst_new
        (setq lst_new (append lst_new (list (list
          (nth 0 item) (nth 1 item)
        ))))
        (setq i (+ i 1))
      )
      ;; if the item isn't inserted yet we add it to the end
      (if (= inserted nil)
        (setq lst_new (append lst_new (list (list
          id ind
        ))))
      )
    )
  )
  lst_new  
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sort_ss_by_xy (ss xOry / i j data item ip)
 
  (setq i 0)
  (setq data (list))
  (repeat (sslength ss)
    (setq ip (cdr (assoc 10 (entget (ssname ss i)))))  ;; insert point of the core
    (if (= xOry "x")
      ;; sort by x
      (setq data (insert_sorted data (nth 0 ip) i))
      ;; sort by y
      (setq data (insert_sorted data (nth 1 ip) i))
    )
    (setq i (+ i 1))
  )
  ;;(princ data)
 
  ;; now let's rebuild a ss selection, but sorted like data
  (setq ss_sorted (ssadd))
  (foreach item data
    (setq j (nth 1 item))  ;; j now holds the index of the ss selection
    (ssadd (ssname ss j) ss_sorted)
  )
  ss_sorted
)

;; Offset for each Circle Center
(defun c:occ ( / lst startnumber ss ss_sorted bp pt i ip radi)
  ;; select circles
  ;(setq zoomlevel 70)
  (princ "\nSelect circles then press enter (should be on layer with name 'Cores'): ")
  (setq ss (ssget (list (cons 8 "Cores") (cons 0 "CIRCLE"))))
 
  (setq ss (sort_ss_by_xy ss "x"))
  (setq pt (getpoint "\nInsert point of the table: "))
 
  (setq startnumber (getint "\nStart Number: "))
  
  ;; make the list
  (setq lst (list
    (list "Core #" "x" "y" "Dia. (mm)")  ;; head
  ))
  (setq i 0)
  (repeat (sslength ss)
    (setq ip (cdr (assoc 10 (entget (ssname ss i)))))    ;; circle center
    (setq radi (cdr (assoc 40 (entget (ssname ss i)))))  ;; circle radius (so we know where to put the label)
    ;; append the list
    (setq lst (append lst (list
      (list  
        (+ i startnumber )  ;; counter, starting with user set start number
        (rtos (car ip) 2 2)  ;; 2 decimals, feel free to change this
        (rtos (cadr ip) 2 2)
        (rtos (* radi 2.0) 2 2)
      )
    )))
    ;(setq bb (getpoint "\nPause so you can see numbering. Press any key to continue.. "))
    ;(command "ZOOM" "OBject" ip "")
    ;(command "ZOOM" zoomlevel)
    (Text
      (list (+ (nth 0 ip) (* 2. radi)) (- (nth 1 ip) radi) )
      300
      (itoa (+ i startnumber))
      200  ;; purple
    )
    (setq i (+ i 1))
  )
  (inserttable lst pt)
)
