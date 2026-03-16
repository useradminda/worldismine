ShopSys = {}
ShopSys.ItemsList = {}  --道具
ShopSys.RewardBags = {} --礼包
ShopSys.Flags = {}  --符文
ShopSys.Others = {} --其他
ShopSys.Bosses = {} --主公

function ShopSys.InitShop()
   
   local _ItemData = nil 
   for key , value in pairs(ShopConfig.ShopConfig) do
       
       if value.Type == 1 then                      --道具
          _ItemData = ItemDataConfig.GetItemDBConfig(value.GoodsId)
       elseif value.Type == 2 then                  --礼包
          _ItemData = GiftDataConfig.GetGiftDataBuyId(value.GoodsId)
       elseif value.Type == 3 then                  --符文
          _ItemData = BattleFlagConfig.GetBattleFlagConfigById(value.GoodsId)
       elseif value.Type == 4 then                  --其他
          --_ItemData = ItemDataConfig.GetItemDBConfig(value.GoodsId)
       elseif value.Type == 5 then                  --主公
          _ItemData = RoleDataSys.GetRoleById(value.GoodsId)
       end

          
       local data = 
       {
           ShopItem = _ItemData,
           Pos = value.GoodsPos,
           ShopCostType = value.CurrencyType,
           ShopCostCount = value.CurrencyParam,
           ShopId = key,
        }

        if _ItemData~=nil then
           if value.Type == 1 then
              if data.Pos == -1 then
                 table.insert(ShopSys.ItemsList , 1 , data)
              else
                 table.insert (ShopSys.ItemsList , #ShopSys.ItemsList + 1 , data)
              end
           elseif value.Type == 2 then
              if data.Pos == -1 then
                 table.insert(ShopSys.RewardBags , 1 , data)
              else
                 table.insert(ShopSys.RewardBags , #ShopSys.RewardBags + 1 , data)
              end
           elseif value.Type == 3 then
              if data.Pos == -1 then
                 table.insert(ShopSys.Flags , 1 , data)
              else
                 table.insert(ShopSys.Flags , #ShopSys.Flags + 1 , data)
              end
           elseif value.Type == 4 then
              if data.Pos == -1 then
                 table.insert(ShopSys.Others , 1 , data)
              else
                 table.insert(ShopSys.Others , #ShopSys.Others + 1 , data)
              end
           elseif value.Type == 5 then
              if data.Pos == -1 then
                 table.insert(ShopSys.Bosses , 1 , data)
              else
                 table.insert(ShopSys.Bosses , #ShopSys.Bosses + 1 , data)
              end
           end
        end
   end
end

function ShopSys.GetItemById(_Id , _Type)
	local list = {}
	if _Type == 1 then
		list = ShopSys.ItemsList
	end
	if _Type == 2 then
		list = ShopSys.RewardBags
	end
	if _Type == 3 then
		list = ShopSys.Flags
	end
	if _Type == 4 then
		list = ShopSys.Others
	end
	if _Type == 5 then
		list = ShopSys.Bosses
	end
	for i=1,#list,1 do
		if list[i].ShopItem.Id == _Id then
			return list[i]
		end
	end
	return nil
end

function ShopSys.BuyNormalItem(_ID , _Count)
   local Info = tostring(_ID)..","..tostring(_Count)
   WebEvent.BuyNormalItem(Info , "ShopSys.BuyNormalItemCallBack" , ShopSys.BuyNormalItemCallBack)
end

function ShopSys.BuyNormalItemCallBack(_data , _returnId)
    if _returnId==0 then
        local _ShopTar = MainGameUI.FindPanelTarget("UIShop")
        if _ShopTar~=nil then
           _ShopTar:PopReward()
        end
        DataUIInstance.PopTip("M1")

        local uiSoliderTar = MainGameUI.FindPanelTarget("UISoldier")
	    if uiSoliderTar~=nil then
		    if uiSoliderTar.UISoldierGob.gameObject.activeInHierarchy == true then
		
			    uiSoliderTar:ShowHeroUpGradePanel()
		    end
	    end
		local UIHireHeroTar = MainGameUI.FindPanelTarget("UIHireHero")
		if UIHireHeroTar ~=nil then
			if UIHireHeroTar.UIHireHeroGod.gameObject.activeInHierarchy == true then
				UIHireHeroTar:ShowHireHeroProp()
			end
		end
	
	    local uiEquipTar = MainGameUI.FindPanelTarget("UIEquip")
	    if uiEquipTar~=nil then
		    if uiEquipTar.UIEquipGod.gameObject.activeInHierarchy == true then
		
			    uiEquipTar:ShowSmeltBasicInfo()
			    uiEquipTar:ShowPurifyItemCount()
		    end
	    end

    elseif _returnId == 2 then
       DataUIInstance.PopTip("W2")
    end
	
end

function ShopSys.BuyBossItem(_ID)
   local Info = tostring(_ID)..","..tostring(1)
   WebEvent.BuyNormalItem(Info , "ShopSys.BuyBossItemCallBack" , ShopSys.BuyBossItemCallBack)
end

function ShopSys.BuyBossItemCallBack(_data , _returnId)
   if _returnId==0 then
      local _ShopTar = MainGameUI.FindPanelTarget("UIShop")
      if _ShopTar~=nil then
         _ShopTar:PopReward()
      end
      DataUIInstance.PopTip("M1")
   elseif _returnId == 2 then
      DataUIInstance.PopTip("Z3")
   end
end

return ShopSys