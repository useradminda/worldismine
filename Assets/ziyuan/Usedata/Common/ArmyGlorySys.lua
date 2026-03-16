ArmyGlorySys = {}
ArmyGlorySys.GloryRankList = {}
ArmyGlorySys.MyGloryRank = 0
function ArmyGlorySys.BuyGlory()           --²¹ÆëËùÓÐ¹¦Ñ«
   WebEvent.BuyArmyGloryReward(nil , "ArmyGlorySys.BuyGloryCallBack" , ArmyGlorySys.BuyGloryCallBack)
end

function ArmyGlorySys.BuyGloryCallBack(data , returnId)
   if returnId == 0 then
      local _UIWorldTar = MainGameUI.FindPanelTarget("UIWorldMap")
      if _UIWorldTar~=nil then
      _UIWorldTar:SetGloryPanel()
      end
      DataUIInstance.PopTip("Y1")
   end
end

function ArmyGlorySys.GetGloryReward()
   local _Info = nil
   WebEvent.GetArmyGloryReward(_Info , "ArmyGlorySys.GetGloryRewardCallBack" , ArmyGlorySys.GetGloryRewardCallBack)  
end

function ArmyGlorySys.GetGloryRewardCallBack(data , returnId)
   if returnId == 0 then
      local _UIWorldTar = MainGameUI.FindPanelTarget("UIWorldMap")
      _UIWorldTar:SetGloryPanel()
      local mul = tonumber(data["mul"])
      local list = RewardContentSys.GetRewardInCludeResources(data["rwd"])
      for i = 1  , #list.Items , 1 do
          if list.Items[i].Id == 1002 then
             list.Items[i].Count = list.Items[i].Count * mul
          end
      end
      DataUIInstance.OpenRewards(list.Items)
      if mul~=nil then
         if mul>1 then
            DataUIInstance.PopTip("Y2")
         end
      end
   end
end

function ArmyGlorySys.GetGloryRank()
   local _Info = nil
   WebEvent.GetArmyGloryRank(_Info , "ArmyGlorySys.GetGloryRankCallBack" , ArmyGlorySys.GetGloryRankCallBack)  
end

function ArmyGlorySys.GetGloryRankCallBack(data , returnId)
   if returnId==0 then
      local _UIWorldTar = MainGameUI.FindPanelTarget("UIWorldMap")
      if _UIWorldTar ~=nil then
         _UIWorldTar:GetGloryRankCallBack()
      end
   elseif returnId == 1 then
      DataUIInstance.PopTip("X2")
   end
end
--ArmyGlorySys.ShowGloryRankRoleNum =10  --xian shi gong xun  pai hang ren shu
function ArmyGlorySys.GloryComminfo(data)
--GameMain.Print(data,"data=s")
   ArmyGlorySys.GloryRankList = {}
   for key , value in pairs(data) do
       local _Index = tonumber(key)
     
       if _Index~=nil then
        --Debug.LogError(key)
        --GameMain.Print(value,"value=s")
       
        --   if _Index==0 then
         --     ArmyGlorySys.MyGloryRank = tonumber(value["rank"])
         --  else
         --     local data = 
          --    {   
         --        Name = tostring(value["name"]),
        --         Vip = tonumber(value["vip"]), 
         --        Camp = UIstring.Ownerships[tonumber(value["camp"])],       
         --        Rank = tonumber(value["rank"]),                               
         --        Feats = tonumber(value["feats"]),
         --     }
          
         --     table.insert(ArmyGlorySys.GloryRankList , #ArmyGlorySys.GloryRankList + 1 , data) 
        --  end
          
         
           --local tempdata = 
             -- {   
             --    Name = tostring(value["name"]),
             --    Vip = tonumber(value["vip"]), 
             --    Camp = UIstring.Ownerships[tonumber(value["camp"])],       
             --    Rank = tonumber(value["rank"]),                               
             --    Feats = tonumber(value["feats"]),
             -- }
              local tempdata = {};
              tempdata.Name = tostring(value["name"])
                  tempdata.Vip = tonumber(value["vip"])
                  tempdata.Camp = UIstring.Ownerships[tonumber(value["camp"])]       
                  tempdata.Rank = tonumber(value["rank"])                               
                  tempdata.Feats = tonumber(value["feats"])
                  
                  
              if tempdata.Name== ClinetInfomation.Name then
               		ArmyGlorySys.MyGloryRank = tempdata.Rank
              end
              --if tempdata.Rank <= ArmyGlorySys.ShowGloryRankRoleNum then
              --GameMain.Print(tempdata,"tempdata=s")
              table.insert(ArmyGlorySys.GloryRankList , #ArmyGlorySys.GloryRankList + 1 , tempdata)
              --end
             
       end
   end
   table.sort(ArmyGlorySys.GloryRankList , ArmyGlorySys.Comp)
end

function ArmyGlorySys.Comp(A , B)
	if A.Rank==nil or B.Rank==nil then
	
		return 0
	else
	
   		return A.Rank < B.Rank
   end
end

return ArmyGlorySys