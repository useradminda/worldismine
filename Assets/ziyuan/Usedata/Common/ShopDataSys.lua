ShopDataSys = {}

function ShopDataSys.GetShopItemsByType(_Type)
   local _ShopItems = ShopConfig.GetShopConfigByType(_Type) 
   if _ShopItems ~= nil then
      return _ShopItems
   else
      return nil
   end
end

return ShopDataSys