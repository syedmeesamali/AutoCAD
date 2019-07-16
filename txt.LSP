;Write text from a point
(defun c:txt()
 (setq p1 (getpoint "Pick point"))
 (command "text" "j" "mi" argXYPt "45" (rtos argText)) 
)