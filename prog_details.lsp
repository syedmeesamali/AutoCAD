;;;Program to read circle details

(defun c:cdet()
  (setq eName(car (entsel)))
  (setq eData(entget eName))
  (setq stp (cdr (assoc 10 eData)))
  (setq radi (cdr (assoc 40 eData)))
  (princ)
);end of program