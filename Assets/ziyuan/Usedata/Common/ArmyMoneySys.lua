ArmyMoneySys = {}
ArmyMoneySys.GetArmyMoneyId = 0
ArmyMoneySys.ArmyMoneyList = {}

function ArmyMoneySys.SetArmyMoneyId(data)

   if data["campRwdId"]==nil then
      ArmyMoneySys.GetArmyMoneyId = 0
      
   else
      ArmyMoneySys.GetArmyMoneyId = tonumber(data["campRwdId"])
   end
end

function ArmyMoneySys.GetArmyMoney()
   local _Count = ArmyMoneySys.GetArmyMoneyCount()
   if _Count==0 then
      DataUIInstance.PopTip("U5")
      return
   end
   local _TempArmyMoney = ArmyMoneySys.GetNowArmyMoney()
   local _info = tostring(_TempArmyMoney.Time)
   WebEvent.GetArmyMoney(_info , "ArmyMoneySys.GetArmyMoneyCallBack" , ArmyMoneySys.GetArmyMoneyCallBack)
end

function ArmyMoneySys.GetArmyMoneyCallBack(data , returnId)
   if returnId ==0 then
      local _UIWorldTar = MainGameUI.FindPanelTarget("UIWorldMap")
      if _UIWorldTar~=nil then
         _UIWorldTar:GetArmyMoneyCallBack()
         _UIWorldTar:SetArmyMoneyPanel()
      end
   end
end

function ArmyMoneySys.GetNowArmyMoney()
   if ArmyMoneySys.GetArmyMoneyId==0 then
      return ArmyMoneySys.ArmyMoneyList[1]
   end
   for i = 1 , #ArmyMoneySys.ArmyMoneyList , 1 do
       if ArmyMoneySys.ArmyMoneyList[i].Time ==ArmyMoneySys.GetArmyMoneyId then
          if i==#ArmyMoneySys.ArmyMoneyList then
             return ArmyMoneySys.ArmyMoneyList[#ArmyMoneySys.ArmyMoneyList]
          end
          return ArmyMoneySys.ArmyMoneyList[i + 1]
       end 
   end
   return ArmyMoneySys.ArmyMoneyList[1] 
end

function ArmyMoneySys.GetArmyMoneyCount()
   if ArmyMoneySys.GetArmyMoneyId==0 then
      return #ArmyMoneySys.ArmyMoneyList
   end
   for i = 1 , #ArmyMoneySys.ArmyMoneyList , 1 do
       if ArmyMoneySys.ArmyMoneyList[i].Time ==ArmyMoneySys.GetArmyMoneyId then
          return #ArmyMoneySys.ArmyMoneyList - i
       end 
   end
   return #ArmyMoneySys.ArmyMoneyList
end


function ArmyMoneySys.ArmyMoneyCallBack(data)
    ArmyMoneySys.ArmyMoneyList = {}
    for key , value in pairs(data) do
        local _ArmyMoneyId = tonumber(key)
        if _ArmyMoneyId~=nil then
            _ArmyMoneyId = _ArmyMoneyId + 1
            if ArmyMoneySys.ArmyMoneyList[_ArmyMoneyId]==nil then
               ArmyMoneySys.ArmyMoneyList[_ArmyMoneyId] = {}
            end
            ArmyMoneySys.ArmyMoneyList[_ArmyMoneyId].Money = tonumber(value["feats"])
            ArmyMoneySys.ArmyMoneyList[_ArmyMoneyId].Time = tonumber(value["batch"])
        end
    end

end

return ArmyMoneySys 