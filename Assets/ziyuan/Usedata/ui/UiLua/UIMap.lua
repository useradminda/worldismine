UIMap = {}
local UIMap = BasePanel:new()     
local this = UIMap
UIMap.UIMapGob = nil

UIMap.ChapterList = {}
function UIMap:OpenUI(_PanelName , _LuaName)
	
    UIMap.UIMapGob = MainGameUI.FindPanel("UIMap") 
    this:CreateChapter()
  
end

function UIMap:ShowInitChapter()
  this:CreateMaps(MapSys.NowChapter)
    MapSys.RequireMapRank()
end

UIMap.RankList = {}
function UIMap:SetRank()
    if #UIMap.RankList==0 then
       for i =1 , 10 , 1 do
           UIMap.RankList[i] = UIMap.UIMapGob.transform:FindChild("MapPassPanel"):FindChild("MapPass"):FindChild("MapPassPanel"):FindChild("MapPassGrid"):FindChild(tostring(i))
       end
    end
    for i =1 , 10 , 1 do
        UIMap.RankList[i].gameObject:SetActive(false)
    end
    
    for i =1 , #MapSys.MapRank , 1 do
        UIMap.RankList[i].gameObject:SetActive(true)
        UIMap.RankList[i].transform:FindChild("Rank"):GetComponent("UILabel").text = tostring(MapSys.MapRank[i].Rank)
        UIMap.RankList[i].transform:FindChild("Name"):GetComponent("UILabel").text = MapSys.MapRank[i].Name
        UIMap.RankList[i].transform:FindChild("MapNum"):GetComponent("UILabel").text = tostring(MapSys.MapRank[i].Star)
    end
end

UIMap.ChapterFather = nil
function UIMap:CreateChapter()
    if #UIMap.ChapterList==0 then
        UIMap.ChapterFather = UIMap.UIMapGob.transform:FindChild("MapChapterFather"):FindChild("ChapterFather")
        for i = 1 , #MapSys.ChapterList , 1 do
            local data = 
            {
               Index = i,
               ChapterData = MapSys.ChapterList[i],
            }
            MainGameUI.CreateLittleItem(tostring(i) , "ChapterItem" , UIMap.ChapterFather , data , this.CreateChapterCallBack  , "UIMap")
        end
	else
		this:ShowInitChapter()
    end
end

function UIMap:CreateChapterCallBack(_Gob , _Info)
    --_Gob.transform.localPosition = Vector3(_Info.ChapterData.PosX , _Info.ChapterData.PosY , 0)
    _Gob.transform:FindChild("ChapterName"):GetComponent("UILabel").text = _Info.ChapterData.Name
    if MapSys.NowChapter >  _Info.Index then
       _Gob.transform:FindChild(_Info.ChapterData.Icon).gameObject:SetActive(true)
    else
       _Gob.transform:FindChild("NoPass").gameObject:SetActive(true)
    end

    if MapSys.NowChapter == _Info.Index then
       this:SetChapterArrow(_Gob)
    end

    UIMap.ChapterList[_Info.Index] = 
    {
        ChapterGob = _Gob,
        ChapterData = _Info.ChapterData,
    }
	UIMap.ChapterFather.transform:GetComponent("UIGrid").enabled = true
       UIMap.ChapterFather.transform:GetComponent("UIGrid"):Reposition()
    if _Info.Index==#MapSys.ChapterList then
		this:ShowInitChapter()
    end
end

function UIMap:SetChapterArrow(_Gob)
   _Gob.transform:FindChild("Arrow").gameObject:SetActive(true)
end

UIMap.MapsList = {}
UIMap.MapsFather = nil
UIMap.TempChapIndex = 0
function UIMap:CreateMaps(_ChapterIndex)
    if UIMap.MapsFather == nil then
       UIMap.MapsFather = UIMap.UIMapGob.transform:FindChild("MapList"):FindChild("MapsPanel"):FindChild("MapsGrid")
    end
    if _ChapterIndex > MapSys.NowChapter then
       DataUIInstance.PopTip("U6")
       return
    end
    local _MapsData = MapSys.GetMpasByChapterId(_ChapterIndex)
    if _MapsData==nil then
       Debug.LogError("该章节无法打开")
       return
    end
    --GameMain.Print(_MapsData)
    for i = 1 , #_MapsData , 1 do
        local _MapData = _MapsData[i]
        local data = 
        {
            Index = i,
            MapData = _MapData,
            ChapterIndex = _ChapterIndex,
        }
        if UIMap.MapsList[i]==nil or UIMap.MapsList[i].Gob == nil then
           this:CreateMapsCallBack(UIMap.MapsFather.transform:FindChild(tostring(i)).gameObject , data)
          -- MainGameUI.CreateLittleItem(tostring(i) , "MapItem" , UIMap.MapsFather , data , this.CreateMapsCallBack  , "UIMap")  
        else
           this:CreateMapsCallBack(UIMap.MapsList[i].Gob , data)
        end
    end
    local _Chapter = MapSys.GetChapter(_ChapterIndex)
    UIMap.TempChapIndex = _ChapterIndex
    this:SetChapterTitle(_Chapter.Name)
end

function UIMap:CreateMapsCallBack(_Gob , _Info) 
   --GameMain.Print(_Info) 
   if _Info.ChapterIndex == MapSys.NowChapter and _Info.Index < MapSys.NowMap then              
      this:SetStar(true , _Gob)
   else
      this:SetStar(false , _Gob)
   end

   if _Info.ChapterIndex < MapSys.NowChapter then
      this:SetStar(true , _Gob)
   end

   UIMap.MapsList[_Info.Index] = 
   {
      Gob = _Gob,
      MapData = _Info.MapData,
   }

   if _Info.Index == MapSys.NowMap and _Info.ChapterIndex == MapSys.NowChapter then
      this:SetNowMap(true)
   end
   if _Info.ChapterIndex~=MapSys.NowChapter then
      this:SetNowMap(false)
   end 

   this:SetMapType(_Info.MapData.BattleType , _Gob)
   this:SetMapNum(_Info.MapData.Turn , _Gob)
   if _Info.Index==10 then
      UIMap.MapsFather:GetComponent("UIGrid").enabled = true
      UIMap.MapsFather:GetComponent("UIGrid"):Reposition()
      
   end
end

function UIMap:SetStar(_Show , _Gob)
    if _Show== true then
       _Gob.transform:FindChild("Star"):FindChild("StarUp").gameObject:SetActive(true)
       --_Gob.transform:FindChild("Star"):FindChild("StarDown").gameObject:SetActive(false)
    else
       _Gob.transform:FindChild("Star"):FindChild("StarUp").gameObject:SetActive(false)
       --_Gob.transform:FindChild("Star"):FindChild("StarDown").gameObject:SetActive(false)
    end
end

function UIMap:SetNowMap(_Show)                   --设置当前已经打到第几个关
   UIMap.MapsList[MapSys.NowMap].Gob.transform:FindChild("NowMap").gameObject:SetActive(_Show)
end

function UIMap:SetMapType(_MapType , _Gob)
   if _MapType==1 then
      _Gob.transform:FindChild("BossMap").gameObject:SetActive(false)
      _Gob.transform:FindChild("MapNum").gameObject:SetActive(true)
   elseif _MapType==3 then
      _Gob.transform:FindChild("BossMap").gameObject:SetActive(true)
      _Gob.transform:FindChild("MapNum").gameObject:SetActive(false)
   end
end  

function UIMap:SetMapNum(_Index , _Gob)
   _Gob.transform:FindChild("MapNum"):FindChild("ChapterName"):GetComponent("UILabel").text = tostring(_Index)
end


UIMap.ChapterName = nil
function UIMap:SetChapterTitle(_ChaptName)      --设置章节名称
   if UIMap.ChapterName == nil then
      UIMap.ChapterName = UIMap.UIMapGob.transform:FindChild("MapList"):FindChild("ChapterTitle"):FindChild("ChapterName"):GetComponent("UILabel")
   end
   UIMap.ChapterName.text = _ChaptName
end

function UIMap:SetLastChapter(_ChaptIndex)
   local _ChoseChapt = _ChaptIndex - 1
   if _ChoseChapt==0 then
      Debug.LogError("当前章节为第一章")
      return
   end
   this:CreateMaps(_ChoseChapt)
end

function UIMap:SetNextChapter(_ChaptIndex)
   local _ChoseChapt = _ChaptIndex + 1
   this:CreateMaps(_ChoseChapt)
end

UIMap.MapPanel = nil
UIMap.MapData = nil                             --临时副本
function UIMap:OpenMapPanel(_MapIndex)          --打开临时副本信息界面
   if UIMap.MapPanel == nil then
      UIMap.MapPanel = UIMap.UIMapGob.transform:FindChild("MapPanel")
   end
   local _MapData = UIMap.MapsList[_MapIndex].MapData
   UIMap.MapData = _MapData
   UIMap.MapPanel.gameObject:SetActive(true)
   this:SetMapTitle(_MapData.Name)
   this:SetRewards(_MapData.MapData.Reward)
   this:SetCount(0)
   this:SetLeft()
end

UIMap.MapName = nil
UIMap.Num = 0
function UIMap:SetMapTitle(_MapName)
   if UIMap.MapName==nil then
      UIMap.MapName = UIMap.MapPanel.transform:FindChild("MapTitle"):FindChild("MapName"):GetComponent("UILabel")
   end
   UIMap.MapName.text = _MapName
end

UIMap.RewardItems = {}
function UIMap:SetRewards(_RewardString)
   if #UIMap.RewardItems == 0 then
      for i = 1 , 6 , 1 do
          UIMap.RewardItems[i] = UIMap.MapPanel.transform:FindChild("MapItemPanel"):FindChild("ItemGrid"):FindChild(tostring(i))
      end
   end
   for i = 1 , 6 , 1 do
       UIMap.RewardItems[i].gameObject:SetActive(false)
   end
   
   local _Reward = RewardContentSys.GetMapStringType(_RewardString)

   for i = 1 , #_Reward.Items , 1 do
       local _ItemData = _Reward.Items[i]
       UIMap.RewardItems[i].gameObject:SetActive(true)
       local _Sprite =UIMap.RewardItems[i].transform:FindChild("Img"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_Sprite , _ItemData.AtlasName , _ItemData.SpriteName)
       local _FGSprite =UIMap.RewardItems[i].transform:FindChild("FG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_FGSprite , UIstring.QualityAtlasName , UIstring.ItemFg[_ItemData.Quality])
       local _BGSprite =UIMap.RewardItems[i].transform:FindChild("BG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_BGSprite , UIstring.QualityBGAtlasName , UIstring.ItemFg[_ItemData.Quality])
   end  
end

function UIMap:Sub()
   if UIMap.Num <= 0 then
      Debug.LogError("最小为1")
      return
   end
   UIMap.Num = UIMap.Num - 1
   this:SetCount(UIMap.Num)
end

function UIMap:Add()
   if UIMap.Num >= ClinetInfomation.Sta then
      return
   end
   UIMap.Num = UIMap.Num + 1
   this:SetCount(UIMap.Num)
end

function UIMap:Max()
   local _Count = ClinetInfomation.Sta
   if _Count==0 then
      DataUIInstance.PopTip("X7")
      return
   end
   if _Count > 30 then
      UIMap.Num = 30
   else
      UIMap.Num = _Count
   end
   this:SetCount(UIMap.Num)
end

function UIMap:SetLeft()
   local _Count = ClinetInfomation.Sta
   
   UIMap.MapPanel.transform:FindChild("LeftCount"):GetComponent("UILabel").text = tostring(_Count)
end

function UIMap:SetCount(_Count)
   UIMap.Num = _Count
   UIMap.MapPanel.transform:FindChild("Count"):GetComponent("UILabel").text = tostring(_Count)
end

function UIMap:Fight(_Map)

  if UIMap.TempChapIndex < MapSys.NowChapter then
     if _Map.BattleType==3 then                    --Boss关
         local _data = nil
         _data = TeamSys.GetPvpTeamUpInfo()
         DataUIInstance.PopTipPanel("ChangeTeam" , UIMap.ChangeTeam , _data)
      else
         if ClinetInfomation.Sta == 0 then
            
            local UseCount = MapSys.NeedHufu
            local Descrip = UIstring.UseHuFu..tostring(UseCount)
            
            DataUIInstance.PopConfirmPanel(Descrip , UIMap.GoFight , nil , nil , nil)	--确认弹框  
            return
         end      

         MapSys.Fight(_Map)
      end
  elseif UIMap.TempChapIndex > MapSys.NowChapter then
       DataUIInstance.PopTip("V3")
  elseif UIMap.TempChapIndex == MapSys.NowChapter then
       if _Map.Turn <= MapSys.NowMap then
          if _Map.BattleType==3 then                    --Boss关
             local _data = nil
             _data = TeamSys.GetPvpTeamUpInfo()
             DataUIInstance.PopTipPanel("ChangeTeam" , UIMap.ChangeTeam , _data)
          else

             if ClinetInfomation.Sta == 0 then              
                local UseCount = MapSys.NeedHufu
                local Descrip = UIstring.UseHuFu..tostring(UseCount)
                
                DataUIInstance.PopConfirmPanel(Descrip , UIMap.GoFight , nil , nil , nil)	--确认弹框  
                return
             end

             MapSys.Fight(_Map)
          end
       else
          DataUIInstance.PopTip("V3")

       end
  end  
end

function UIMap.GoFight()
   local hufuCount = ItemPackageSys.GetItemCountById(1021)
   if hufuCount==0 then
      DataUIInstance.PopTip("X9")
      return
   end
   if hufuCount < MapSys.NeedHufu then
      DataUIInstance.PopTip("X9")
      return
   end
   MapSys.Fight(UIMap.MapData)
end

function UIMap.ChangeTeam(_TeamNumber)
   TeamSys.SetPvpTeamType(_TeamNumber)
   if ClinetInfomation.Sta == 0 then     
      local UseCount = MapSys.NeedHufu
      local Descrip = UIstring.UseHuFu..tostring(UseCount)
      
      DataUIInstance.PopConfirmPanel(Descrip , UIMap.GoFight , nil , nil , nil)	--确认弹框  
      return
   end
   MapSys.Fight(UIMap.MapData)
end

function UIMap:Sweep(_Map)
   
   if UIMap.TempChapIndex > MapSys.NowChapter then
       DataUIInstance.PopTip("V3")
       return
   elseif UIMap.TempChapIndex == MapSys.NowChapter then
       if _Map.Turn < MapSys.NowMap then
          if ClinetInfomation.Vip < 1 then
             DataUIInstance.PopTip("X6")
             return
          end
          if ClinetInfomation.Sta==0 then                                   --军令是0                    
             local UseCount = MapSys.NeedHufu
             local Descrip = UIstring.UseHuFu..tostring(UseCount)
                
             DataUIInstance.PopConfirmPanel(Descrip , UIMap.GoSweep , nil , nil , nil)	--确认弹框  
             return
          end
          if UIMap.Num==0 then
             DataUIInstance.PopTip("Y9")
             return
          end
          MapSys.Sweep(_Map , UIMap.Num)
       else
          DataUIInstance.PopTip("V3")
       end
   elseif UIMap.TempChapIndex < MapSys.NowChapter then
       if ClinetInfomation.Vip < 1 then
          DataUIInstance.PopTip("X6")
          return
       end
       if ClinetInfomation.Sta==0 then                                   --军令是0                    
          local UseCount = MapSys.NeedHufu
          local Descrip = UIstring.UseHuFu..tostring(UseCount)
             
          DataUIInstance.PopConfirmPanel(Descrip , UIMap.GoSweep , nil , nil , nil)	--确认弹框  
          return
       end
       if UIMap.Num==0 then
          DataUIInstance.PopTip("Y9")
          return
       end
       MapSys.Sweep(_Map , UIMap.Num)
   end
end

function UIMap.GoSweep()
   local hufuCount = ItemPackageSys.GetItemCountById(1021)
   if hufuCount==0 then
      DataUIInstance.PopTip("X9")
      return
   end
   if hufuCount < MapSys.NeedHufu then
      DataUIInstance.PopTip("X9")
      return
   end
   MapSys.Sweep(UIMap.MapData , 1)
end

function UIMap:CloseMapPanel()
   if UIMap.MapPanel ~= nil then
      UIMap.MapPanel.gameObject:SetActive(false)
   end
end

UIMap.SweepPanel = nil
function UIMap:OpenSweepPanel(_Rewardc)            --扫荡结算
   if UIMap.SweepPanel == nil then
      UIMap.SweepPanel = UIMap.UIMapGob.transform:FindChild("SweepPanel")
   end
   UIMap.SweepPanel.gameObject:SetActive(true)
  -- GameMain.Print(_Rewardc)
   local _Exp = 0
   local _Coin = 0
   local _TempData = {}
   local _Data = {}
   local _IsHave = false
   for i = 1 , #_Rewardc , 1 do
       if _Rewardc[i]~=nil then
          if _Rewardc[i].Exp~=nil then
             _Exp = _Rewardc[1].Exp + _Rewardc[i].Exp
          end
          if _Rewardc[i].Coin~=nil then
             _Coin = _Rewardc[1].Coin + _Rewardc[i].Coin
          end
          for j = 1 , #_Rewardc[i].Item  , 1 do 
              _IsHave = false

              for k = 1 , #_TempData ,  1 do
                  if _TempData[k].Id == _Rewardc[i].Item[j].Id then
                     _Data[k].Qtt = _Data[k].Qtt + _Rewardc[i].Item[j].Qtt  
                     _IsHave = true               
                  end
              end
              if _IsHave == false then
                 table.insert(_Data , #_Data + 1 , _Rewardc[i].Item[j])
              end
          end
          _TempData = {}
          _TempData = _Data
       end
   end
   local _Reward = {}
   _Reward.Item = _Data
   _Reward.Exp = _Exp
   _Reward.Coin = _Coin
  -- GameMain.Print(_Reward)
   this:SetSweepReward(_Reward)
   this:CloseMapPanel()
end

UIMap.SweepItems = {}
function UIMap:SetSweepReward(_Rewardc)
   if #UIMap.SweepItems==0 then
      for i = 1 , 6 , 1 do
          UIMap.SweepItems[i] = UIMap.SweepPanel.transform:FindChild("SweepItemPanel"):FindChild("SweepGrid"):FindChild(tostring(i))
      end
   end
   local _Reward = RewardContentSys.HandleReward(_Rewardc)

   if _Reward.exp~=nil then
      UIMap.SweepPanel.transform:FindChild("ExpCoinPanel"):FindChild("Exp"):FindChild("ExpC"):GetComponent("UILabel").text = tostring(_Reward.exp)
   end
   if _Reward.coin ~= nil then
      UIMap.SweepPanel.transform:FindChild("ExpCoinPanel"):FindChild("Coin"):FindChild("CoinC"):GetComponent("UILabel").text = tostring(_Reward.coin)
   end 
 
   for i = 1 , 6 , 1 do
       if i > #_Reward.Items then
          UIMap.SweepItems[i].gameObject:SetActive(false)
       else
          local _ItemData = _Reward.Items[i]
          UIMap.SweepItems[i].gameObject:SetActive(true)
          local _Img = UIMap.SweepItems[i].transform:FindChild("Img"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Img , _ItemData.AtlasName , _ItemData.SpriteName)
          local _Bg = UIMap.SweepItems[i].transform:FindChild("BG"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Bg , UIstring.QualityBGAtlasName , UIstring.ItemFg[_ItemData.Quality])
          local _Fg = UIMap.SweepItems[i].transform:FindChild("FG"):GetComponent("UISprite")
          AtlasMsg.SetAtlas(_Fg , UIstring.QualityAtlasName , UIstring.ItemFg[_ItemData.Quality])
          UIMap.SweepItems[i].transform:FindChild("Count"):GetComponent("UILabel").text = tostring(_ItemData.Count)
       end     
   end  
end

function UIMap:CloseSweepPanel()
   if UIMap.SweepPanel~=nil then
      UIMap.SweepPanel.gameObject:SetActive(false)
   end
end

function UIMap:BackChosePanel()
   UIMap.UIMapGob.gameObject:SetActive(false)
end

function UIMap:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob~=nil then
      local _GobFatherName = _Gob.transform.parent.name
      local _GobName = _Gob.transform.name

      if _GobFatherName == "ChapterFather" then
         local _ChapIndex = tonumber(_GobName)
         this:CreateMaps(_ChapIndex)
      elseif _GobFatherName == "MapsGrid" then
         local _MapIndex = tonumber(_GobName)
         this:OpenMapPanel(_MapIndex)
      else
         if _GobName == "CloseMapPanelButton" then
            this:CloseMapPanel()
         elseif _GobName == "Back" then
            this:BackChosePanel()
         elseif _GobName == "Fight" then 
            this:Fight(UIMap.MapData)
            --GameMain.EnterZQBattle(1 , UIMap.Map.DBid)
         elseif _GobName == "LastChapter" then 
            this:SetLastChapter(this.TempChapIndex)
         elseif _GobName == "NextChapter" then 
            this:SetNextChapter(this.TempChapIndex)
         elseif _GobName == "Sub" then
            this:Sub()
         elseif _GobName == "Max" then 
            this:Max()
         elseif _GobName == "Add" then
            this:Add()     
         elseif _GobName == "Sweep" then    
            this:Sweep(UIMap.MapData)
         elseif _GobName == "CloseSweepPanel" then    
            this:CloseSweepPanel()  
         end
      end    
   end
end

function UIMap:ReleasPanel()
UIMap.UIMapGob = nil

UIMap.ChapterList = {}
UIMap.RankList = {}

UIMap.ChapterFather = nil

UIMap.MapsList = {}
UIMap.MapsFather = nil
UIMap.ChapterName = nil

UIMap.MapPanel = nil
UIMap.MapData = nil                             --临时副本

UIMap.MapName = nil
UIMap.RewardItems = {}

UIMap.SweepPanel = nil
UIMap.SweepItems = {}

UIMap.TempChapIndex = 0
end

return UIMap