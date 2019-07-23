;; there is a list of lists.  (list (list ID IND)) .  If holds a numeric ID (1 2 3 ...);
;; IND holds the index of the unsorted list
;; This function inserts a new item, its position in the list depending on its ID.
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
;; returns the index of the next found item
(defun find_next (list_sorted id / i result)
  (setq i 0)
  (setq result nil)
  (foreach item list_sorted
    (if (= id (nth 0 item))
      (setq result i)
    )
    (setq i (+ i 1))
  )
  result
)

(defun c:ltc ( / ss id ids list_sorted cur_int cur_ind obj zoomlevel)
  (setq zoomlevel 100)  ;; feel free to adapt
  ;; (setq ss (ssget "_X" (list (cons 0 "INSERT") (cons 2 "CORING") )))

  (princ "\nSelect objects: ")
  (setq ss (ssget (list (cons 0 "TEXT") (cons 8 "0")  (cons 62 200) )))
  
  (princ "\nCoring texts found: ")
  (princ (sslength ss))
 
  ;; make a list of every ID of those blocks
  (setq i 0)
  (setq ids (list))
  (setq list_sorted (list))
  (repeat (sslength ss)
    ;;(setq id (atoi (LM:getattributevalue (ssname ss i) "ID")))
    (setq id (atoi (cdr (assoc 1 (entget (ssname ss i))))))
    (setq ids (append ids (list id)))
    (setq list_sorted (insert_sorted list_sorted id i))
    (setq i (+ i 1))
  )
 
  (setq cur_int (getint "\nEnter ID to start with.  Or press Enter to start from 1.  Press Esc to exit the loop: "))
  (if (not cur_int)
    (setq cur_int 1)
  )
  ;; now select them in order
  (while (setq cur_ind (find_next list_sorted cur_int))
    ;; grip the block
    (setq obj (ssname ss (nth 1 (nth cur_ind list_sorted))))
    (command "ZOOM" "OBject" obj "")
    (command "ZOOM" zoomlevel)
    (sssetfirst nil (ssadd obj))
    (getstring "\nPress Enter: ")
    (setq cur_int (+ cur_int 1))
  )
  (princ)
)