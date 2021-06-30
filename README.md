# gaster-blasters
please, not another sans fight...

## "THE LIBRARY DOESN'T WORK"

yes, it does. there's a lot of people who use it. you're just using it wrong. stop blaming my library and just ask for help on the unitale server, thanks.

## HI IF YOU USE THIS PLEASE CREDIT ME FOR SOME REASON PEOPLE DONT

!! if you encounter any issues, my discord is `Ally 🌠#1540` !!

heres a video of it in action. https://ringo.is-a-good-waifu.com/7N1pvcA.mp4


✨✨✨ HOW TO USE ✨✨✨

throw `blasters = require ("Libraries/gaster_blasters")` at the bottom of your wave script

throw `blasters.Update()` somewhere in your update function, you should probably put that at the bottom

to create a gaster blaster, use blasters.New

`blasters.New(start_x,start_y,goto_x,goto_y,rotation[,startrotation[,sound[,fire_sound[,sprite_prefix[,beam_sprite]]]]]) returns GasterBlaster`

!! anything in square brackets are optional and have default arguments !!

start_x and start_y are where the gaster blaster spawns, this is normally off screen

goto_x and goto_y are where the gaster blaster moves to, this is normally on screen

rotation is where the gaster blaster turns to face

startrotation is what the gaster blaster starts out as, this is 0 by default as thats what undertale does im pretty sure

sound is "gasterintro" by default, if you set it to false then the blaster is silent

same with fire_sound except it's "gasterfire" by default

sprite_prefix is "blaster/spr_gasterblaster_" by default

beam_sprite is "blaster/beam" by default

✨✨✨ variables and functions ✨✨✨

`GasterBlaster.Scale(width,height)` rescales the gaster blaster, if you set width to 0.5 and height to 1 its just like the small ones in undertale

these get cleaned up when the wave ends but if you want to instantly destroy one call `GasterBlaster.Destroy()`

`GasterBlaster.x` is its x position, note that itll try and move to x2

`GasterBlaster.y` is its y position, note that itll try and move to y2

`GasterBlaster.x2` is where the blaster is trying to move to

`GasterBlaster.y2` is where the blaster is trying to move to

`GasterBlaster.shootdelay` is how long until the blaster shoots its beam, 40 by default

`GasterBlaster.speed` is how fast it moves/turns, default 40

`GasterBlaster.angle` is its angle, you can modify this and nothing bad should happen probably

`GasterBlaster.holdfire` is how long it stays in place before moving away after firing, 0 by default

`GasterBlaster.beam` is the beam projectile, you shouldn't overwrite this

✨✨✨ the single event that this library has ✨✨✨

`GasterBlaster.OnBeam(bullet)` gets called when the blaster shoots its beam. `bullet` is the beam (its a projectile btw)

a good example of this being used is [colored blasters](https://o.lol-sa.me/2CUA1G7.mp4)

```lua
local my_super_cool_blue_blaster = blasters.New(320, 480, 320, 300, 0, 0)
my_super_cool_blue_blaster.sprite.color32 = {0,162,232}
function my_super_cool_blue_blaster.OnBeam(bullet)
    bullet["color"] = "blue"
    bullet.sprite.color32 = {0,162,232}
end
function OnHit(bullet)
    if bullet["color"] == "blue" and Player.ismoving then
        Player.Hurt(1,0)
    end
end
```
in this wave (which is missing a few things but you get the point) creates a blue gaster blaster.
