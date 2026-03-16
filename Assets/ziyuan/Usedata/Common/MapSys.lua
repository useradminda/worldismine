MapSys = {}
MapSys.MapList = {}
MapSys.ChapterList = {}
MapSys.NowChapter = 1
MapSys.NowMap = 1
MapSys.MapRank = {}
MapSys.NeedHufu = 0

function MapSys.Init()
   for key , value in pairs(MapConfig.MapConfig) do
       local _ChapterId = value.Chapter_Id
       local _Chapter = MapDataSys.GetChapterByDbId(_ChapterId)
       if _Chapter~=nil then          
          local _MapTurn = value.Turn
          if MapSys.MapList[_Chapter.Turn]==nil then
             MapSys.MapList[_Chapter.Turn] = {}
          end
          if MapSys.MapList[_Chapter.Turn][_MapTurn]==nil then         
             local _Map = MapSys.CreateMap(value)
             MapSys.MapList[_Chapter.Turn][_MapTurn] = _Map
          end
       end
   end
   
   for i = 1 , #ChapterConfig.ChapterConfig , 1 do
       MapSys.ChapterList[i] = ChapterConfig.ChapterConfig[i]
   end
end

function MapSys.CreateMap(_MapData)
    local lua = GameMain.requireLuaFile("Map")
	local Map = lua:new()
    Map:InitSome(_MapData)
    return Map
end

function MapSys.GetMpasByChapterId(_ChapterId)
    if MapSys.MapList[_ChapterId]~=nil then
       return MapSys.MapList[_ChapterId]
    end
    return nil
end

function MapSys.GetChapter(_ChapterIndex)
    if MapSys.ChapterList[_ChapterIndex]~=nil then
       return MapSys.ChapterList[_ChapterIndex]
    end
    return nil
end

MapSys.Map = nil
function MapSys.Fight(_Map)                                     --开始战斗
   MapSys.Map = _Map
   local Info = tostring(_Map.Chapter_Id)..","..tostring(_Map.Turn)..","..tostring(MapSys.Map.BattleType)
   WebEvent.MapFight(Info , "MapSys.FightCallBack" , MapSys.FightCallBack)
end

function MapSys.FightCallBack(data , returnId)              --开始战斗回调
   if returnId == 0 then
      if MapSys.Map.Chapter_Id == MapSys.NowChapter and MapSys.Map.Turn == MapSys.NowMap then
         GameMain.EnterZQBattle(MapSys.Map.BattleType , MapSys.Map.DBid , true)
      else
         GameMain.EnterZQBattle(MapSys.Map.BattleType , MapSys.Map.DBid , false) 
      end
      --MapSys.OverMap()
   elseif returnId==1 then
   
   elseif returnId==2 then
      DataUIInstance.PopTip("X8")
   end  
end

MapSys.RewardList = nil
MapSys.Win = 0
function MapSys.OverMap(_Win , _RewardList)                                    --战斗结束
   MapSys.RewardList = _RewardList
   MapSys.Win = _Win
   Debug.LogError(MapSys.Win)
   if _Win==-1 then
      Debug.LogError("_Win==-1_Win==-1_Win==-1_Win==-1")
      MapSys.Win = 0
   end
   if MapSys.Map==nil then
      MapSys.RewardList.transform.parent.gameObject:SetActive(false)
      lgNoDelCsFun.Ins:QuitB()
      return
   end
   local Info = tostring(MapSys.Map.Chapter_Id)..","..tostring(MapSys.Map.Turn)..","..tostring(MapSys.Map.BattleType)..","..tostring(MapSys.Win)
   WebEvent.MapFightOver(Info , "MapSys.OverMapCallBack" , MapSys.OverMapCallBack)
end

function MapSys.OverMapCallBack(data , returnId)            --战斗结束
   if returnId == 0 then
      if MapSys.RewardList==nil then
         return
      end

      
      GuideSys.BattleOutGuide(MapSys.Map , MapSys.Win)

      local _Reward = RewardContentSys.HandleReward(data)
      MapSys.RewardList.gameObject:SetActive(true)
      if _Reward.coin~=nil then
         MapSys.RewardList:GetComponent("lgJiangliMag").Jinbiobj.transform:FindChild("lab2"):GetComponent("UILabel").text = tostring(_Reward.coin)
      else
         MapSys.RewardList:GetComponent("lgJiangliMag").Jinbiobj.transform:FindChild("lab2"):GetComponent("UILabel").text = "0"
      end

      if _Reward.exp ~=nil then
         MapSys.RewardList:GetComponent("lgJiangliMag").Jinyanobj.transform:FindChild("lab2"):GetComponent("UILabel").text = tostring(_Reward.exp)
      else
         MapSys.RewardList:GetComponent("lgJiangliMag").Jinyanobj.transform:FindChild("lab2"):GetComponent("UILabel").text = "0"
      end

      if MapSys.Win==1 then
          
          for i = 1 , 6 , 1 do
              if _Reward.Items[i]~=nil then
                 MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].gameObject:SetActive(true)
                 local _Sprite = MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("jingyansp2"):GetComponent("UISprite")
                 AtlasMsg.SetAtlas(_Sprite , _Reward.Items[i].AtlasName , _Reward.Items[i].SpriteName)
                 MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("jingyansp1"):GetComponent("UISprite").spriteName = UIstring.ItemFg[_Reward.Items[i].Quality]
                 MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("jingyansp"):GetComponent("UISprite").spriteName = UIstring.ItemFg[_Reward.Items[i].Quality]
                 MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].transform:FindChild("lab1"):GetComponent("UILabel").text = tostring(_Reward.Items[i].Count)
              else
                 MapSys.RewardList:GetComponent("lgJiangliMag").Jianglidaojuobj[i - 1].gameObject:SetActive(false)
              end
          end
          --MapSys.RewardList.transform:FindChild("jiangli_win"):FindChild("daoju"):GetComponent("UIGrid").enabled = true
          --MapSys.RewardList.transform:FindChild("jiangli_win"):FindChild("daoju"):GetComponent("UIGrid"):Reposition()
      else
         --MapSys.RewardList.gameObject:SetActive(true)
      end
   elseif returnId==1 then

   end

   MapSys.Map = nil
end

function MapSys.Sweep(_Map , _Time)                                     --扫荡
   local Info = tostring(_Map.Chapter_Id)..","..tostring(_Map.Turn)..","..tostring(_Map.BattleType)..","..tostring(_Time)
   WebEvent.MapSweep(Info , "MapSys.SweepCallBack" , MapSys.SweepCallBack)
end

function MapSys.SweepCallBack(data , returnId)              --扫荡回调
  
   if returnId==0 then
      local MapTar = MainGameUI.FindPanelTarget("UIMap")
      if MapTar~=nil then
         MapTar:OpenSweepPanel(data)
      end    
      DataUIInstance.PopTip("Y10")
   elseif returnId == 1 then
      DataUIInstance.PopTip("X6")
   end
end

function MapSys.RequireMapRank()
   WebEvent.RequireMapRankInfo(nil , "MapSys.RequireMapRankCallBack" , MapSys.RequireMapRankCallBack)
end

function MapSys.RequireMapRankCallBack(data , returnId)
   if returnId==0 then
      local MapTar = MainGameUI.FindPanelTarget("UIMap")
      if MapTar~=nil then
         MapTar:SetRank()
      end
   end
end

function MapSys.ComminfoCallBack(_data)
   local _MapInfo = _data["progress"]
   for key , value in pairs(_MapInfo) do
        local ID = tonumber(key)
        if ID~=nil and ID==1 then
           local data = value
           local _NowChapterID = tonumber(data["area"])
           local _NowMapID = tonumber(data["pos"])
           local _NowChapter = MapDataSys.GetChapterByDbId(_NowChapterID)
           --local _NowMap = MapDataSys.GetMapByDbId(_NowMapID)
           if _NowChapter==nil and _NowMapID==0 then
              MapSys.NowChapter = _NowChapterID + 1
              MapSys.NowMap = _NowMapID + 1
             
           else
               MapSys.NowChapter = _NowChapter.Turn
               MapSys.NowMap = _NowMapID + 1--_NowMap.Turn + 1
               
           end
           local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
           if UIControlTar~=nil then
              UIControlTar:SetNowMap()
           end

        end
        if ID~=nil and ID==3 then                                       --精英关
           local data = value
           local _NowChapterID = tonumber(data["area"])
           local _NowMapID = tonumber(data["pos"])
           local _NowChapter = MapDataSys.GetChapterByDbId(_NowChapterID)
           if _NowChapter~=nil then           
               local _tempTurn = _NowChapter.Turn
               if _tempTurn>=MapSys.NowChapter then                       --已经通过该章第十关
                  MapSys.NowChapter = _NowChapter.Turn + 1
				  MapSys.NowMap = 1
               end

               if _tempTurn < MapSys.NowChapter then
              
               else
                  -- MapSys.NowMap = 1 --_NowMap.Turn + 1              
               end
               local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
               if UIControlTar~=nil then
                  UIControlTar:SetNowMap()
               end
           end

        end
    end
    local _ItemUseCount = tonumber(_data["itemUseCount"])
    MapSys.NeedHufu = GameMain.ConvertToInt(_ItemUseCount/2) + 1
end

function MapSys.MapRankCallBack(_data)
  -- GameMain.Print(_data)
   MapSys.MapRank = {}
   local _RanInfo = _data
   for key , value in pairs(_RanInfo["list"]) do
        local ID = tonumber(key)
        if ID~=nil then
           local data =
           {
               Rank = tonumber(value["rank"]),
               Name = tostring(value["name"]),
               Star = tostring(value["star"]),
           }
           MapSys.MapRank[data.Rank] = data
        end
    end
end

return MapSys