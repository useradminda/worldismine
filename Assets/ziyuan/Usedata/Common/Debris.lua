--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Debris = {}                                                                      --道具类
                                               

local Debris = ItemBase:new()                                                  
local this = Debris


Debris.Count = 0                                                                  --道具数量
Debris.ComposeNum = 0								--合成的数量                                    
Debris.IsDebris = true  
Debris.TargetId = 0                      
function  Debris:InitSome(_Itemdata,count)                                              --生成一个道具实例
    if _Itemdata~=nil then
       self:SetDBdata(_Itemdata)
       self.Count = count
	   self.ComposeNum = _Itemdata.NeedCount
		self.TargetId = _Itemdata.Target
	   self.IsDebris = true
    end
end

function Debris:UseItem(count)--使用
	local useCount = GameMain.ConvertToInt( count / self.ComposeNum )
	DebrisPackageSys.Use(self , useCount)
end

return Debris
--endregion
