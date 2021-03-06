(defun C:RADCT (/ rad ss count obj)
(setq obj (vlax-ename->vla-object (car (entsel "\nSelect circle to count: "))))
(if (= (vla-get-objectname obj) "AcDbCircle")
(progn
(setq rad (vla-get-radius obj))
(setq ss (ssget (list '(0 . "CIRCLE")(cons 40 rad))))
(if (/= (setq count (sslength ss)) 0)
(alert (strcat "There are " (itoa count) " items matching"))
(alert "no circles match")
)
)
)
(command "Text" (getpoint) "" (itoa count))
(princ)
)?