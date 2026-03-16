ArmyGloryDataSys = {}

function ArmyGloryDataSys.GetGloryRewardTotalNum()
   local _Feat = FeatsRewardConfig.GetFeatsRewardByLvl(ClinetInfomation.Lvl)
   if _Feat~=nil then
      return _Feat.TopFeats
   end
   return 0
end

function ArmyGloryDataSys.GetGloryRewardFeatList()
   local _Feat = FeatsRewardConfig.GetFeatsRewardByLvl(ClinetInfomation.Lvl)
   if _Feat~=nil then
      return _Feat.Feats
   end
   return nil
end

function ArmyGloryDataSys.GetTotalBoxNumLeft()
   local _Feats = ArmyGloryDataSys.GetGloryRewardFeatList()
   local _TotalBoxNum = 0
   local _BoxLevel = 0
   for i = 1 , #_Feats , 1 do
       if _Feats[i] <= ClinetInfomation.Feats then
          _BoxLevel = i
       end
   end
   if _BoxLevel==0 then
      _TotalBoxNum = 0
   elseif _BoxLevel==1 then
      _TotalBoxNum = 4
   elseif _BoxLevel==2 then
      _TotalBoxNum = 10
   elseif _BoxLevel==3 then
      _TotalBoxNum = 20
   elseif _BoxLevel==4 then
      _TotalBoxNum = 33
   elseif _BoxLevel==5 then
      _TotalBoxNum = 50
   end
   local tempindex = _TotalBoxNum - ClinetInfomation.featsRewardTimes
   if tempindex<=0 then
      tempindex = 0
   end
   return tempindex
end

return ArmyGloryDataSys