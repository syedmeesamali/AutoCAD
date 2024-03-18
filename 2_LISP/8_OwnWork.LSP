
;;;;;;;;;;;;;;;;;;; Start of Visual Lisp Activex objects
(vl-load-com)
 
(setq acadDocument (vla-get-activedocument (vlax-get-acad-object)))

(setq theLayers (vla-get-layers acadDocument))
(setq i 0)
