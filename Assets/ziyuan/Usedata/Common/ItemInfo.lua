--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ItemInfo = {}                                                                      --道具类
                                               

local ItemInfo = ItemBase:new()                                                  
local this = ItemInfo


ItemInfo.Count = 0                                                                  --道具数量
                                                               
function  ItemInfo:InitSome(_Itemdata,count)                                              --生成一个道具实例
    if _Itemdata~=nil then
       self:SetDBdata(_Itemdata)
       self.Count = count
    end
end

function ItemInfo:SellItem(count)--出售道具
	ItemPackageSys.SellItem(self.Dbid,count)--出售道具
end

function ItemInfo:UseItem(count) --使用道具
	ItemPackageSys.UseItem(self.Dbid , count)
end
return ItemInfo
--endregion
