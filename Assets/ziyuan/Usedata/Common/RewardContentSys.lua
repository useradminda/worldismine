RewardContentSys ={}                            --解析奖励Json结构
RewardContentSys.Rewards ={}

function RewardContentSys.GetRewardTableType(Reward)             --非线性表结构
   
   RewardContentSys.Rewards ={}

   if Reward['Sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['Sta'])
   end
  
   if Reward['Exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
   end
   if Reward['Coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin'])
   end
   if Reward['Diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
   end
 
   if Reward['Reputation']~=nil then
	 RewardContentSys.Rewards.reputation = tonumber(Reward['Reputation'])
   end
	if Reward['VipExp'] ~= nil then
		RewardContentSys.Rewards.vipExp = tonumber(Reward['VipExp'])
	end
	if Reward['King'] ~= nil then
		 RewardContentSys.Rewards.King = tonumber(Reward['King'])
	end
   if Reward['Item']~=nil then
      if RewardContentSys.Rewards.Item==nil then
         RewardContentSys.Rewards.Item = {}
      else
         RewardContentSys.Rewards.Item = {}
      end

      local RewardItemList = Reward['Item']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ItemInfo = RewardItemList[i]
         local ItemId = tonumber(ItemInfo["Id"])
         local ItemCount = tonumber(ItemInfo["Qtt"])
         local Item = ItemDataConfig.GetItemDBConfig(ItemId)
         RewardContentSys.Rewards.Item[i] = Item
         RewardContentSys.Rewards.Item[i].Count = ItemCount
      end

   end

   if Reward['Resource']~=nil then
      if RewardContentSys.Rewards.Resource==nil then
         RewardContentSys.Rewards.Resource = {}
      else
         RewardContentSys.Rewards.Resource = {}
      end

      local RewardItemList = Reward['Resource']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ResourceInfo = RewardItemList[i]
         local ResourceId = tonumber(ResourceInfo["Id"])
         local ResourceCount = tonumber(ResourceInfo["Qtt"])
         local Resource = ResourceDataConfig.GetResourceDBConfig(ResourceId)
         RewardContentSys.Rewards.Resource[i] = Resource
         RewardContentSys.Rewards.Resource[i].Count = ResourceCount
      end


   end

   if Reward['Equip']~=nil then   
      if RewardContentSys.Rewards.Equip==nil then
         RewardContentSys.Rewards.Equip = {}
      else
         RewardContentSys.Rewards.Equip = {}
      end

      local RewardItemList = Reward['Equip']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do        
         local EquipInfo = RewardItemList[i]
         local EquipId = tonumber(EquipInfo["Id"])
         local EquipCount = tonumber(EquipInfo["Qtt"])
         local Equip =  EquipDataConfig.GetEquipDBConfig(EquipId)
         RewardContentSys.Rewards.Equip[i] = Equip
         RewardContentSys.Rewards.Equip[i].Count = EquipCount
      end
   end

   if Reward['Symbol']~=nil then
      
      if RewardContentSys.Rewards.Symbols==nil then
         RewardContentSys.Rewards.Symbols = {}
      else
         RewardContentSys.Rewards.Symbols = {}
      end

      local RewardItemList = Reward['Symbol']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local SymbolsInfo = RewardItemList[i]
         local SymbolsId = tonumber(SymbolsInfo["Id"])
         local SymbolsCount = tonumber(SymbolsInfo["Qtt"])
         local Symbols = BattleFlagDataSys.GetBattleFlagById(SymbolsId)
         RewardContentSys.Rewards.Symbols[i] = Symbols
         RewardContentSys.Rewards.Symbols[i].Count = SymbolsCount
      end

   end

   return RewardContentSys.Rewards
end

function RewardContentSys.GetRewardStringType(RewardString)      --字符串结构

    local RewardData = GameMain.JsonDecode(RewardString)
    local Rewards = RewardContentSys.GetRewardTableType(RewardData)
    return Rewards
end

function RewardContentSys.GetRewardListString(RewardString)    --字符串结构 转化为 list
    local RewardData = GameMain.JsonDecode(RewardString)
    local _Reward = RewardContentSys.HandleReward(RewardData)
    return _Reward
end

function RewardContentSys.GetRewardResourceString(RewardString)
   local RewardData = GameMain.JsonDecode(RewardString)
   local _Reward = RewardContentSys.GetRewardInCludeResources(RewardData)
   return _Reward
end

function RewardContentSys.HandleReward(Reward)      --把所有的有显示需求的都放在一个Itms表里面 参数是表

    RewardContentSys.Rewards ={}

    if Reward['Sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['Sta'])
   end
  
   if Reward['Exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
   end
   if Reward['Coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin'])
   end
   if Reward['Diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
   end
	if Reward['King'] ~= nil then
		 RewardContentSys.Rewards.King = tonumber(Reward['King'])
	end

   if Reward['Reputation']~=nil then
		RewardContentSys.Rewards.reputation = tonumber(Reward['Reputation'])
   end
	if Reward['VipExp'] ~= nil then
		RewardContentSys.Rewards.vipExp = tonumber(Reward['VipExp'])
	end
   if RewardContentSys.Rewards.Items==nil then
         RewardContentSys.Rewards.Items = {}
   else
         RewardContentSys.Rewards.Items = {}
   end

   if Reward['Item']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items
      local RewardItemList = Reward['Item']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ItemInfo = RewardItemList[i]
         local ItemId = tonumber(ItemInfo["Id"])
         local ItemCount = tonumber(ItemInfo["Qtt"])
         local Item = ItemDataConfig.GetItemDBConfig(ItemId)
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Item
         RewardContentSys.Rewards.Items[totalCount + i].Count = ItemCount
      end

   end

   if Reward['Resource']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Resource']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ResourceInfo = RewardItemList[i]
         local ResourceId = tonumber(ResourceInfo["Id"])
         local ResourceCount = tonumber(ResourceInfo["Qtt"])
         local Resource = ResourceDataConfig.GetResourceDBConfig(ResourceId)
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Resource
         RewardContentSys.Rewards.Items[totalCount + i].Count = ResourceCount
      end


   end

   if Reward['Equip']~=nil then   
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Equip']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do        
         local EquipInfo = RewardItemList[i]
         local EquipId = tonumber(EquipInfo["Id"])
         local EquipCount = tonumber(EquipInfo["Qtt"])
         local Equip =  EquipDataConfig.GetEquipDBConfig(EquipId)
          if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Equip
         RewardContentSys.Rewards.Items[totalCount + i].Count = EquipCount
      end
   end

   if Reward['Symbol']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Symbol']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local SymbolsInfo = RewardItemList[i]
         local SymbolsId = tonumber(SymbolsInfo["Id"])
         local SymbolsCount = tonumber(SymbolsInfo["Qtt"])
         local Symbols = BattleFlagDataSys.GetBattleFlagById(SymbolsId)
          if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Symbols
         RewardContentSys.Rewards.Items[totalCount + i].Count = SymbolsCount
      end

   end

    if Reward['Gift']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Gift']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local GiftInfo = RewardItemList[i]
         local GiftId = tonumber(GiftInfo["Id"])
         local GiftCount = tonumber(GiftInfo["Qtt"])
         local Gift = GiftDataConfig.GetGiftDataBuyId(GiftId) 
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Gift
         RewardContentSys.Rewards.Items[totalCount + i].Count = GiftCount
      end

   end
	if Reward['Debris']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Debris']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local debrisInfo = RewardItemList[i]
         local debrisId = tonumber(debrisInfo["Id"])
         local debrisCount = tonumber(debrisInfo["Qtt"])
         local debris = DebrisConfig.GetDebrisById(debrisId) 
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = debris
         RewardContentSys.Rewards.Items[totalCount + i].Count = debrisCount
      end

   end
   return RewardContentSys.Rewards
end

function RewardContentSys.HandleTableReward(Reward)
   RewardContentSys.Rewards ={}
   if Reward['Sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['Sta'])
   end
  
   if Reward['Exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
   end
   if Reward['Coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin'])
   end
   if Reward['Diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
   end
   if Reward['King'] ~= nil then
		 RewardContentSys.Rewards.King = tonumber(Reward['King'])
	end
	 if Reward['Reputation']~=nil then
	 RewardContentSys.Rewards.reputation = tonumber(Reward['Reputation'])
   end
   if RewardContentSys.Rewards.Items==nil then
         RewardContentSys.Rewards.Items = {}
   else
         RewardContentSys.Rewards.Items = {}
   end

   if Reward['Item']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items
      local RewardItemList = Reward['Item']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do   
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = RewardItemList[i]
         RewardContentSys.Rewards.Items[totalCount + i].Count = RewardItemList[i].Count
      end
   end

   if Reward['Resource']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items
      local RewardItemList = Reward['Resource']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = RewardItemList[i]
         RewardContentSys.Rewards.Items[totalCount + i].Count = RewardItemList[i].Count
      end
   end

   if Reward['Equip']~=nil then   
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Equip']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do          
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = RewardItemList[i]
         RewardContentSys.Rewards.Items[totalCount + i].Count = RewardItemList[i].Count
      end
   end

   if Reward['Symbol']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Symbol']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
          if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = RewardItemList[i]
         RewardContentSys.Rewards.Items[totalCount + i].Count = RewardItemList[i].Count
      end
   end

   return RewardContentSys.Rewards
end

function RewardContentSys.GetRewardInCludeResources(Reward)
   RewardContentSys.Rewards ={}
   if RewardContentSys.Rewards.Items==nil then
         RewardContentSys.Rewards.Items = {}
   else
         RewardContentSys.Rewards.Items = {}
   end

   if Reward['Sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['Sta'])
   end

   if Reward['Exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
   end

   if Reward['Coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin'])
   end
   if Reward['Diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
   end

   if Reward['Honour']~=nil then
      RewardContentSys.Rewards.honour = tonumber(Reward['Honour'])
   end

   if Reward['Reputation']~=nil then
      RewardContentSys.Rewards.reputation = tonumber(Reward['Reputation'])
   end
   if Reward['King'] ~= nil then
		 RewardContentSys.Rewards.King = tonumber(Reward['King'])
	end
   if Reward['Coin']~=nil and tonumber(Reward['Coin'])~=0 then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin'])
      local _Reward = ItemDataSys.GetResourceData(2 , tonumber(Reward['Coin']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count
   end
   if Reward['Diamond']~=nil and tonumber(Reward['Diamond'])~=0 then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
      local _Reward = ItemDataSys.GetResourceData(1 , tonumber(Reward['Diamond']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count    
   end
	 if Reward['King']~=nil and tonumber(Reward['King'])~=0 then
      RewardContentSys.Rewards.King = tonumber(Reward['King'])
      local _Reward = ItemDataSys.GetResourceData(9, tonumber(Reward['King']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count    
   end

   if Reward['Exp']~=nil and tonumber(Reward['Exp'])~=0 then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
      local _Reward = ItemDataSys.GetResourceData(5 , tonumber(Reward['Exp']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count    
   end

   if Reward['Item']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items
      local RewardItemList = Reward['Item']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ItemInfo = RewardItemList[i]
         local ItemId = tonumber(ItemInfo["Id"])
         local ItemCount = tonumber(ItemInfo["Qtt"])
         local Item = ItemDataConfig.GetItemDBConfig(ItemId)
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Item
         RewardContentSys.Rewards.Items[totalCount + i].Count = ItemCount
      end

   end

   if Reward['Resource']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Resource']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local ResourceInfo = RewardItemList[i]
         local ResourceId = tonumber(ResourceInfo["Id"])
         local ResourceCount = tonumber(ResourceInfo["Qtt"])
         local Resource = ResourceDataConfig.GetResourceDBConfig(ResourceId)
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Resource
         RewardContentSys.Rewards.Items[totalCount + i].Count = ResourceCount
      end


   end

   if Reward['Equip']~=nil then   
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Equip']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do        
         local EquipInfo = RewardItemList[i]
         local EquipId = tonumber(EquipInfo["Id"])
         local EquipCount = tonumber(EquipInfo["Qtt"])
         local Equip =  EquipDataConfig.GetEquipDBConfig(EquipId)
          if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Equip
         RewardContentSys.Rewards.Items[totalCount + i].Count = EquipCount
      end
   end

   if Reward['Symbol']~=nil then
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Symbol']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local SymbolsInfo = RewardItemList[i]
         local SymbolsId = tonumber(SymbolsInfo["Id"])
         local SymbolsCount = tonumber(SymbolsInfo["Qtt"])
         local Symbols = BattleFlagDataSys.GetBattleFlagById(SymbolsId)
          if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Symbols
         RewardContentSys.Rewards.Items[totalCount + i].Count = SymbolsCount
      end

   end

   if Reward['Gift']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Gift']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local GiftInfo = RewardItemList[i]
         local GiftId = tonumber(GiftInfo["Id"])
         local GiftCount = tonumber(GiftInfo["Qtt"])
         local Gift = GiftDataConfig.GetGiftDataBuyId(GiftId) 
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Gift
         RewardContentSys.Rewards.Items[totalCount + i].Count = GiftCount
      end

   end

   if Reward['Debris']~=nil then
      
      local totalCount = #RewardContentSys.Rewards.Items

      local RewardItemList = Reward['Debris']
      local Count = #RewardItemList
      for i = 1 , Count , 1 do 
         
         local DebrisInfo = RewardItemList[i]
         local DebrisId = tonumber(DebrisInfo["Id"])
         local DebrisCount = tonumber(DebrisInfo["Qtt"])
         local Debris = DebrisConfig.GetDebrisById(DebrisId) 
         if RewardContentSys.Rewards.Items[totalCount + i]==nil then
            RewardContentSys.Rewards.Items[totalCount + i] = {}
         end
         RewardContentSys.Rewards.Items[totalCount + i] = Debris
         RewardContentSys.Rewards.Items[totalCount + i].Count = DebrisCount
      end

   end

   return RewardContentSys.Rewards
end

function RewardContentSys.GetRewardIncludeResourceByList(Reward)
    RewardContentSys.Rewards ={}
   if RewardContentSys.Rewards.Items==nil then
         RewardContentSys.Rewards.Items = {}
   else
         RewardContentSys.Rewards.Items = {}
   end

   if Reward['sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['sta'])
   end

   if Reward['exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['exp'])
   end

   if Reward['coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['coin'])
   end
   if Reward['diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['diamond'])
   end
if Reward['King'] ~= nil then
		 RewardContentSys.Rewards.King = tonumber(Reward['King'])
	end

   if Reward['coin']~=nil and tonumber(Reward['coin'])~=0 then
      RewardContentSys.Rewards.coin = tonumber(Reward['coin'])
      local _Reward = ItemDataSys.GetResourceData(2 , tonumber(Reward['coin']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count
   end
   if Reward['diamond']~=nil and tonumber(Reward['diamond'])~=0 then
      RewardContentSys.Rewards.diamond = tonumber(Reward['diamond'])
      local _Reward = ItemDataSys.GetResourceData(1 , tonumber(Reward['diamond']))
      local totalCount = #RewardContentSys.Rewards.Items
      if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
      end
      RewardContentSys.Rewards.Items[totalCount + 1] = _Reward.Item
      RewardContentSys.Rewards.Items[totalCount + 1].Count = _Reward.Count    
   end
   
   for i = 1 , #Reward.Items , 1 do
       local totalCount = #RewardContentSys.Rewards.Items
       if RewardContentSys.Rewards.Items[totalCount + 1]==nil then
         RewardContentSys.Rewards.Items[totalCount + 1] = {}
       end
       RewardContentSys.Rewards.Items[totalCount + 1] = Reward.Items[i]
       RewardContentSys.Rewards.Items[totalCount + 1].Count = Reward.Items[i].Count   
   end
 

   return RewardContentSys.Rewards
end

function RewardContentSys.GetMapStringType(_MapStringReward)
    local RewardData = GameMain.JsonDecode(_MapStringReward)  
    local Rewards = RewardContentSys.GetMapReward(RewardData)
    return Rewards
end

function RewardContentSys.GetMapReward(Reward)
   RewardContentSys.Rewards ={}
   --GameMain.Print(Reward)
  --[[ if Reward['Sta']~=nil then
      RewardContentSys.Rewards.sta = tonumber(Reward['Sta'])
   end--]]
  
   if Reward['Exp']~=nil then
      RewardContentSys.Rewards.exp = tonumber(Reward['Exp'])
   end
   if Reward['Coin']~=nil then
      RewardContentSys.Rewards.coin = tonumber(Reward['Coin']["Min"])
   end
   --[[if Reward['Diamond']~=nil then
      RewardContentSys.Rewards.diamond = tonumber(Reward['Diamond'])
   end--]]
   if RewardContentSys.Rewards.Items==nil then
         RewardContentSys.Rewards.Items = {}
      else
         RewardContentSys.Rewards.Items = {}
   end
   if Reward["Item"]~=nil then
      for i = 1 , #Reward["Item"] , 1 do
          local _ItemId = Reward["Item"][i].Id
          local _Item = ItemDataConfig.GetItemDBConfig(_ItemId)
          table.insert(RewardContentSys.Rewards.Items , #RewardContentSys.Rewards.Items + 1 , _Item)
      end
   end
   
   if Reward["Gift"]~=nil then
      for i = 1 , #Reward["Gift"] , 1 do
          local _GiftId = Reward["Gift"][i].Id
          local _Gift = GiftDataConfig.GetGiftDataBuyId(_GiftId) 
          table.insert(RewardContentSys.Rewards.Items , #RewardContentSys.Rewards.Items + 1 , _Gift)
      end
   end  
   
   return RewardContentSys.Rewards
end

function RewardContentSys.PopReward(Reward)
       local RewardString = ""
       local Reward = RewardContentSys.GetRewardInCludeResources(RewardContentSys.GetRewardTableType(Reward))
       if Reward.sta~=nil then
          if RewardString~="" then 
             RewardString = RewardString.."/n"..tostring(UIstring.Sta).."+"..tostring(Reward.sta)
          else
              RewardString = RewardString..tostring(UIstring.Sta).."+"..tostring(Reward.sta)
          end
         
       end
       if Reward.energy~=nil then
          if RewardString~="" then 
             RewardString = RewardString.."/n"..tostring(UIstring.Energy).."+"..tostring(Reward.energy)
          else
             RewardString = RewardString..tostring(UIstring.Energy).."+"..tostring(Reward.energy)
          end
       end
       
       for i = 1 , #Reward.Items , 1 do
           if RewardString~="" then
              RewardString = RewardString.."\n"..UIstring.WordColor[Reward.Items[i].Item.Quality]..Reward.Items[i].Item.Name.."X"..tostring(Reward.Items[i].Count).."[-]"
           else
              RewardString = RewardString..UIstring.WordColor[Reward.Items[i].Item.Quality]..Reward.Items[i].Item.Name.."X"..tostring(Reward.Items[i].Count).."[-]"
           end
       end
       DataUIInstance.PopTip(RewardString)
end

function RewardContentSys.ShowFightOver(RewardList , data , Win)
   local _Reward = RewardContentSys.HandleReward(data)
   RewardList.gameObject:SetActive(true)
   if _Reward.coin~=nil then
      RewardList:GetComponent("lgJiangliMag").Jinbiobj.gameObject:SetActive(false) -- .transform:FindChild("lab2"):GetComponent("UILabel").text = tostring(_Reward.coin)
   else
      RewardList:GetComponent("lgJiangliMag").Jinbiobj.gameObject:SetActive(false) --.transform:FindChild("lab2"):GetComponent("UILabel").text = "0"
   end

   if _Reward.exp ~=nil then
      RewardList:GetComponent("lgJiangliMag").Jinyanobj.gameObject:SetActive(false)--.transform:FindChild("lab2"):GetComponent("UILabel").text = tostring(_Reward.exp)
   else
      RewardList:GetComponent("lgJiangliMag").Jinyanobj.gameObject:SetActive(false)--.transform:FindChild("lab2"):GetComponent("UILabel").text = "0"
   end
   RewardList:GetComponent("lgJiangliMag").Rongyao.gameObject:SetActive(true)
   if Win==1 then
      RewardList:GetComponent("lgJiangliMag").Rongyao.transform:FindChild("lab2"):GetComponent("UILabel").text = "50"
   else
      RewardList:GetComponent("lgJiangliMag").Rongyao.transform:FindChild("lab2"):GetComponent("UILabel").text = "25"
   end
   --if Win==1 then         
      for i = 1 , 6 , 1 do
          if _Reward.Items[i]~=nil then
             RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].gameObject:SetActive(true)
             local _Sprite = RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("jingyansp2"):GetComponent("UISprite")
             AtlasMsg.SetAtlas(_Sprite , _Reward.Items[i].AtlasName , _Reward.Items[i].SpriteName)
             RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("jingyansp1"):GetComponent("UISprite").spriteName = UIstring.ItemFg[_Reward.Items[i].Quality]
             RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("lab1"):GetComponent("UILabel").text = tostring(_Reward.Items[i].Count)
          else
             RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].gameObject:SetActive(false)
          end
      end

 --  else
      
  -- end
end 

return RewardContentSys