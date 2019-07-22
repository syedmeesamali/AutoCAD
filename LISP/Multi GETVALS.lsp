; Getvals multi allows multiple line inputs
; By Alan H Feb 2019
; code examples
; the input box size can be bigger just change the two values tetsed with 145 145 and worked ok.
; (if (not AH:getvalsm)(load "Multi Getvals.lsp"))
; (setq ans (AH:getvalsm (list "This is heading" "Line 1" 5 4 "11" "Line2" 8 7 "22" "Line3" 8 7 "33" "Line4" 8 7 "4")))
;
; (setq newvals (AH:getvalsm (list "Cross fall percent" "Enter Horizontal scale " 5 4 "100" "Enter Vertical scale" 5 4 "50" "Enter number of decimal places" 5 4 "2")))
; note the values are strings

(defun AH:getvalsm (dcllst / x y ans fo fname keynum key_lst v_lst)
  (setq num (/ (- (length dcllst) 1) 4))
  (setq x 0)
  (setq y 0)
  (setq fo (open (setq fname (vl-filename-mktemp "" "" ".dcl")) "w"))
  (write-line "ddgetvalAH : dialog {" fo)
  (write-line (strcat "	label =" (chr 34) (nth 0 dcllst) (chr 34) " ;") fo)
  (write-line " : column {" fo)
  (repeat num
    (write-line "spacer_1 ;" fo)
    (write-line ": edit_box {" fo)
    (setq keynum (strcat "key" (rtos (setq y (+ Y 1)) 2 0)))
    (write-line (strcat "    key = " (chr 34) keynum (chr 34) ";") fo)
    (write-line (strcat " label = " (chr 34) (nth (+ x 1) dcllst) (chr 34) ";") fo)
    (write-line (strcat "     edit_width = " (rtos (nth (+ x 2) dcllst) 2 0) ";") fo)
    (write-line (strcat "     edit_limit = " (rtos (nth (+ x 3) dcllst) 2 0) ";") fo)
    (write-line "   is_enabled = true ;" fo)
    (write-line "    }" fo)
    (setq x (+ x 4))
  )
  (write-line "    }" fo)
  (write-line "spacer_1 ;" fo)
  (write-line "ok_only;}" fo)
  (close fo)

  (setq dcl_id (load_dialog fname))
  (if (not (new_dialog "ddgetvalAH" dcl_id))
    (exit)
  )
  (setq x 0)
  (setq y 0)
  (setq v_lst '())
  (repeat num
    (setq keynum (strcat "key" (rtos (setq y (+ Y 1)) 2 0)))
    (setq key_lst (cons keynum key_lst))
    (set_tile keynum (nth (setq x (+ x 4)) dcllst))
    (mode_tile keynum 3)
  )
  (action_tile "accept" "(mapcar '(lambda (x) (setq v_lst (cons (get_tile x) v_lst))) key_lst)(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (vl-file-delete fname)

  (princ v_lst)
)

