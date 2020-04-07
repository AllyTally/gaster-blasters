# gaster-blasters
please, not another sans fight...

!! if you encounter any issues, my discord is `Ally 🍦#1540` !!

heres a video of it in action. https://ringo.is-a-good-waifu.com/7N1pvcA.mp4

ok so this ones actually super straight forward

throw `blasters = require "Libraries/gaster_blasters"` at the top of your wave script

throw `blasters.Update()` somewhere in your update function, you should probably put that at the bottom

to create a gaster blaster, use blasters.New

`blasters.New(start_x,start_y,goto_x,goto_y,rotation,startrotation=0) returns GasterBlaster`

start_x and start_y are where the gaster blaster spawns, this is normally off screen

goto_x and goto_y are where the gaster blaster moves to, this is normally on screen

rotation is where the gaster blaster turns to face

startrotation is what the gaster blaster starts out as, this is 0 by default as thats what undertale does im pretty sure

`GasterBlaster.Scale(width,height)` rescales the gaster blaster, if you set width to 0.5 and height to 1 its just like the small ones in undertale

these get cleaned up when the wave ends but if you want to instantly destroy one call `GasterBlaster.Destroy()`

other stuff in the file lol just look in it
