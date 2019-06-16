-- https://github.com/Luigimaster1/gaster-blasters/
-- written by ally
-- please dont steal and claim as your own

local self = {}

self.blasters = {}

function self.New(x,y,x2,y2,angle,startangle)
    local _blaster = {}
    _blaster.sprite = CreateSprite("blaster/spr_gasterblaster_0","Top")
    _blaster.sprite.Scale(2,2)
    _blaster.sprite.MoveTo(x,y)
    _blaster.sprite.rotation = 0
    _blaster.updatetimer = 0
    _blaster.x = x
    _blaster.y = y
    _blaster.x2 = x2
    _blaster.y2 = y2
    _blaster.xscale = 1
    _blaster.yscale = 1
    _blaster.shootdelay = 40
    _blaster.angle = angle % 360
    _blaster.dorotation = 0
    _blaster.builderspd = 0
    if startangle then
        _blaster.dorotation = startangle
        _blaster.sprite.rotation = startangle
    end
    Audio.PlaySound("gasterintro") 

    function _blaster.SpawnBeam()
        _blaster.beam = CreateProjectileAbs("blaster/beam",0,0)
        Misc.ShakeScreen(30,3)
        _blaster.beam.sprite.Scale(2,2*_blaster.yscale)
        _blaster.beam.ppcollision = true
        _blaster.beam.sprite.yscale = 1.75*_blaster.xscale
        _blaster.CalculateBeamPosition()
        Audio.PlaySound("gasterfire")
    end

    function _blaster.CalculateBeamPosition()
        _blaster.beam.MoveToAbs(_blaster.x,_blaster.y)
        _blaster.beam.sprite.rotation = _blaster.sprite.rotation+90
        _blaster.beam.Move((44*_blaster.yscale) * math.sin(math.rad(_blaster.sprite.rotation)),(-44*_blaster.yscale) * math.cos(math.rad(_blaster.sprite.rotation)))
        _blaster.beam.sprite.SetPivot(1,0.5)
    end

    function _blaster.Scale(x,y)
        _blaster.xscale = x
        _blaster.yscale = y
        _blaster.sprite.Scale(2*x,2*y)
    end
    function _blaster.UpdatePosition(x,y)
        _blaster.x = x
        _blaster.y = y
        _blaster.sprite.MoveTo(x,y)
        if _blaster.beam then
            _blaster.CalculateBeamPosition()
        end
    end

    function lerp(a, b, t)
        return a + (b - a) * t
    end

    function _blaster.Update()
        local angle
        _blaster.updatetimer = _blaster.updatetimer + 1
        if _blaster.angle >= 180 then
            angle = _blaster.angle-360
        else
            angle = _blaster.angle
        end
        _blaster.dorotation = lerp(_blaster.dorotation,angle,6/_blaster.shootdelay)
        _blaster.sprite.rotation = _blaster.dorotation
        if _blaster.updatetimer > _blaster.shootdelay then
            _blaster.builderspd = _blaster.builderspd + 1
            _blaster.x = _blaster.x - (_blaster.builderspd * math.sin(math.rad(_blaster.sprite.rotation)))
            _blaster.y = _blaster.y - (-_blaster.builderspd * math.cos(math.rad(_blaster.sprite.rotation)))
        else
            _blaster.x = lerp(_blaster.x,_blaster.x2,6/_blaster.shootdelay)
            _blaster.y = lerp(_blaster.y,_blaster.y2,6/_blaster.shootdelay)
        end

        if (_blaster.updatetimer > _blaster.shootdelay) and (_blaster.updatetimer <= _blaster.shootdelay+8) then
            _blaster.beam.sprite.yscale = _blaster.beam.sprite.yscale + 0.125*_blaster.xscale
        end
        if _blaster.updatetimer > _blaster.shootdelay+8 then
            if _blaster.beam.sprite.yscale > 0 then
                _blaster.beam.sprite.yscale = _blaster.beam.sprite.yscale - 0.125*_blaster.xscale
            else
                _blaster.beam.sprite.yscale = 0
            end
            _blaster.beam.sprite.alpha = _blaster.beam.sprite.alpha - 0.05
            if ((_blaster.x < -20) or (_blaster.x > 660) or (_blaster.y < -20) or (_blaster.y > 500)) and (_blaster.beam.sprite.alpha == 0) then
                _blaster.Destroy()
                return
            end
        end
        _blaster.UpdatePosition(_blaster.x,_blaster.y)
        if _blaster.updatetimer == _blaster.shootdelay-12 then
            _blaster.sprite.Set("blaster/spr_gasterblaster_1")
        elseif _blaster.updatetimer == _blaster.shootdelay-8 then
            _blaster.sprite.Set("blaster/spr_gasterblaster_2")
        elseif _blaster.updatetimer == _blaster.shootdelay-4 then
            _blaster.sprite.Set("blaster/spr_gasterblaster_3")
        elseif _blaster.updatetimer == _blaster.shootdelay then
            _blaster.sprite.SetAnimation({"spr_gasterblaster_4","spr_gasterblaster_5"},6/60,"blaster")
            _blaster.SpawnBeam()
        end
    end

    function _blaster.Destroy()
        _blaster.sprite.Remove()
        if _blaster.beam then
            _blaster.beam.Remove()
        end
        for index, value in pairs(self.blasters) do
            if value == _blaster then
                table.remove(self.blasters,index)
                return
            end
        end
    end
    table.insert(self.blasters,_blaster)
    return _blaster
end

local _Update = Update
function Update()
    for i = #self.blasters, 1, -1 do
        self.blasters[i].Update()
    end
    if _Update then
        _Update()
    end
end

local _EndingWave = EndingWave
function EndingWave()
    for i = #self.blasters, 1, -1 do
        self.blasters[i].Destroy()
    end
    if _EndingWave then
        _EndingWave()
    end
end

blaster = self