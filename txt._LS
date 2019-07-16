;Write text from a point
(defun c:txt()
 (setq p1 (getpoint "Pick point"))
  (command "text" "j" "tc" p1 "" "0" "(Autocad)")
)