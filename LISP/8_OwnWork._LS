
;;;;;;;;;;;;;;;;;;; Start of Visual Lisp Activex objects
(vl-load-com)
 
;; document, model space, ...
  (setq acObj (vlax-get-acad-object)
        acDoc (vla-get-activedocument acObj)
        space (vlax-get acDoc (if (= 1 (getvar 'cvport)) 'PaperSpace 'ModelSpace))
  )
