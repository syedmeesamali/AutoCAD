
;;;;;;;;;;;;;;;;;;; Start of Visual Lisp Activex objects
(vl-load-com)
 
;; document, model space, ...
  (setq acObj (vlax-get-acad-object)
        acDoc (vla-get-activedocument acObj)
        space (vlax-get acDoc (if (= 1 (getvar 'cvport)) 'PaperSpace 'ModelSpace))
  )

(setq pt1 (getpoint "\nSpecify First Point : "))
(while (setq pt2 (getpoint "\nSpecify next point : " pt1))
(vla-addline modelSpace (vlax-3d-point pt1) (vlax-3d-point pt2))
(setq pt1 pt2)
)