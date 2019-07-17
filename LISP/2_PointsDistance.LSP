;Find distance between two points as text
(defun c:pdist()
 (setq p1 (getpoint "Pick first point")
       p2 (getpoint p1 "\nPick second point")
       ;this will make sure that the first point is already picked and used as a reference
       ;d (distance p1 p2)
  )
  (command "text" p1 1 0 (rtos (distance p1 p2)))
  ;Above command will convert the real number to text
)



  