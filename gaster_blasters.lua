--[[
    gaster_blasters.lua, a gaster blaster library for Create Your Frisk
    https://github.com/AllyTally/gaster-blasters/
    Copyright (C) 2019-2020  Alexia Tilde
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]--

return (function()
    local self = {}

    self.blasters = {}
    
    function self.lerp(a, b, t)
        return a + (b - a) * t
    end

    function self.New(x,y,x2,y2,angle,startangle,sound,fire_sound,sprite_prefix,beam_sprite)
        local _blaster = {}
        _blaster.sprite_prefix = sprite_prefix
        if (sprite_prefix == nil) then _blaster.sprite_prefix = "blaster/spr_gasterblaster_" end
        _blaster.beam_sprite = beam_sprite
        if (beam_sprite == nil) then _blaster.beam_sprite = "blaster/beam" end
        _blaster.sprite = CreateSprite(_blaster.sprite_prefix .. "0","Top")
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
        _blaster.speed = 40
        _blaster.angle = angle % 360
        _blaster.dorotation = 0
        _blaster.builderspd = 0
        _blaster.holdfire = 0
        _blaster.sound = sound
        _blaster.fire_sound = fire_sound
        if (sound      == nil) then _blaster.sound      = "gasterintro" end
        if (fire_sound == nil) then _blaster.fire_sound = "gasterfire"  end
        if startangle then
            _blaster.dorotation = startangle
            _blaster.sprite.rotation = startangle
        end
        if _blaster.sound then Audio.PlaySound(_blaster.sound) end
        
        if _blaster.angle >= 180 then
            _blaster.angle = _blaster.angle-360
        end
    
        function _blaster.SpawnBeam()
            _blaster.beam = CreateProjectileAbs(_blaster.beam_sprite,0,0)
            Misc.ShakeScreen(30,3)
            _blaster.beam.sprite.Scale(2,2*_blaster.yscale)
            _blaster.beam.ppcollision = true
            _blaster.beam.sprite.yscale = 1.75*_blaster.xscale
            _blaster.beam["blaster"] = true
            _blaster.CalculateBeamPosition()
            if _blaster.fire_sound then Audio.PlaySound(_blaster.fire_sound) end
            if _blaster.OnBeam then _blaster.OnBeam(_blaster.beam) end
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
    
        function _blaster.Update()
            _blaster.updatetimer = _blaster.updatetimer + 1
            if (_blaster.updatetimer > _blaster.shootdelay) and (_blaster.updatetimer > (_blaster.shootdelay)+_blaster.holdfire) then
                _blaster.sprite.rotation = _blaster.angle
                _blaster.builderspd = _blaster.builderspd + 1
                _blaster.x = _blaster.x - (_blaster.builderspd * math.sin(math.rad(_blaster.sprite.rotation)))
                _blaster.y = _blaster.y - (-_blaster.builderspd * math.cos(math.rad(_blaster.sprite.rotation)))
            else
                _blaster.x = self.lerp(_blaster.x,_blaster.x2,6/_blaster.speed)
                _blaster.y = self.lerp(_blaster.y,_blaster.y2,6/_blaster.speed)
                _blaster.dorotation = self.lerp(_blaster.dorotation,_blaster.angle,6/_blaster.speed)
                _blaster.sprite.rotation = _blaster.dorotation
            end
    
            if (_blaster.updatetimer > _blaster.shootdelay) and (_blaster.updatetimer <= _blaster.shootdelay+8) then
                _blaster.beam.sprite.yscale = _blaster.beam.sprite.yscale + 0.125*_blaster.xscale
            end
            if (_blaster.updatetimer > _blaster.shootdelay+8) and (_blaster.updatetimer > (_blaster.shootdelay+8)+_blaster.holdfire) then
                if _blaster.beam.sprite.yscale > 0 then
                    _blaster.beam.sprite.yscale = _blaster.beam.sprite.yscale - 0.125*_blaster.xscale
                else
                    _blaster.beam.sprite.yscale = 0
                end
                if (_blaster.updatetimer > (_blaster.shootdelay+_blaster.holdfire)) then
                    _blaster.beam.sprite.alpha = _blaster.beam.sprite.alpha - 0.05
                end
                if ((_blaster.x < -20) or (_blaster.x > 660) or (_blaster.y < -20) or (_blaster.y > 500)) and (_blaster.beam.sprite.alpha == 0) then
                    _blaster.Destroy()
                    return
                end
            end
            _blaster.UpdatePosition(_blaster.x,_blaster.y)
            if _blaster.updatetimer == _blaster.shootdelay-12 then
                _blaster.sprite.Set(_blaster.sprite_prefix .. "1")
            elseif _blaster.updatetimer == _blaster.shootdelay-8 then
                _blaster.sprite.Set(_blaster.sprite_prefix .. "2")
            elseif _blaster.updatetimer == _blaster.shootdelay-4 then
                _blaster.sprite.Set(_blaster.sprite_prefix .. "3")
            elseif _blaster.updatetimer == _blaster.shootdelay then
                _blaster.sprite.SetAnimation({_blaster.sprite_prefix .. "4",_blaster.sprite_prefix .. "5"},6/60)
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
    
    function self.Update()
        for i = #self.blasters, 1, -1 do
            self.blasters[i].Update()
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

    return self
end)()
