;Find distance between two points as text
(defun c:pdistance()
 (setq p1 (getpoint "Pick first point: ")
       p2 (getpoint p1 "Pick second point: ")
       d (distance p1 p2)
  )
)



  