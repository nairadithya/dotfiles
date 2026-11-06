hl.curve( "overshoot", { type = "bezier", points = { {0.5, 0.9}, {0.1, 1.1} } } )
hl.animation({ leaf = "workspaces", enabled = true, speed=5, style = "slide", bezier="overshoot"})
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier="overshoot", style = "popin 80%" })
