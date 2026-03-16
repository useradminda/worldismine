--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Gift = {}                                                                      --道具类
                                               

local Gift = ItemBase:new()                                                  
local this = Gift


Gift.Count = 0                                                                  --道具数量
Gift.TargetList = {}                                                   
Gift.IsGift = false
Gift.UseLvl = 0
function  Gift:InitSome(_Data,_Count)                                              --生成一个道具实例
    if _Data~=nil then
       self:SetDBdata(_Data)
       self.Count = _Count
	   local list = GameMain.StringSplit( _Data.Target , ";")
	   self.UseLvl = _Data.UseLvl
	   self.TargetList = list
    end
	self.IsGift = true
end


function Gift:UseItem(count) --使用道具
	GiftPackageSys.Use(self , 0 , count)
end

return Gift
--endregion
