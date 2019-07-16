;This program calculates the area of a circle in AutoLISP.

(defun c:carea()
  (setq rad(getint "Enter radius: "))
  ;getint will only input the integers if you want real numbers then use getreal
  (setq Carea(* 3.141 rad rad))
  (princ Carea)
  (princ)
)