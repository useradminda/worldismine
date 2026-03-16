UIBattleField = {}
local UIBattleField = BasePanel:new()     
local this = UIBattleField
UIBattleField.UIBattleFieldGob = nil
UIBattleField.BattleFieldType = 1                   --1沙场点兵  2 豆酱台

function UIBattleField:OpenUI(_PanelName , _LuaName , _data)
   if UIBattleField.UIBattleFieldGob==nil then
      UIBattleField.UIBattleFieldGob = MainGameUI.FindPanel("UIBattleField")
   end

   UIBattleField.BattleFieldType = _data
   BattleFieldSys.BattleFieldType = _data
   this:SetTitle()
   
   this:SetMyHonour()
   this:SetMyName()
   
   if UIBattleField.BattleFieldType==1 then
      BattleFieldSys.RequestBFList()
   elseif UIBattleField.BattleFieldType==2 then
      BattleFieldSys.RequestBHList()
   end
   
end

UIBattleField.SandTitle = nil
UIBattleField.HeroBattleTitle = nil
function UIBattleField:SetTitle()
   if UIBattleField.SandTitle==nil then
      UIBattleField.SandTitle = UIBattleField.UIBattleFieldGob.transform:FindChild("SandTitle")
      UIBattleField.HeroBattleTitle = UIBattleField.UIBattleFieldGob.transform:FindChild("HeroBattleTitle")
   end
   if UIBattleField.BattleFieldType==1 then
      UIBattleField.SandTitle.transform.localPosition = Vector3(-442 , 289 , 0)
      UIBattleField.HeroBattleTitle.transform.localPosition = Vector3(-442 , 1000 , 0)
   elseif UIBattleField.BattleFieldType==2 then
      UIBattleField.SandTitle.transform.localPosition = Vector3(-442 , 1000 , 0)
      UIBattleField.HeroBattleTitle.transform.localPosition = Vector3(-442 , 289 , 0)
   end
end

UIBattleField.Rank = nil
function UIBattleField:SetMyRank()
   if UIBattleField.Rank == nil then
      UIBattleField.Rank = UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Rank"):GetComponent("UILabel")
   end
   if UIBattleField.BattleFieldType==1 then
      UIBattleField.Rank.text = tostring(BattleFieldSys.MyBattleFieldRank)
   elseif UIBattleField.BattleFieldType==2 then
      UIBattleField.Rank.text = tostring(BattleFieldSys.MyBattleHeroRank)
   end
end

function UIBattleField:SetMyHonour()
    UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Honey"):GetComponent("UILabel").text = tostring(ClinetInfomation.Honour)
end

function UIBattleField:SetMyName()
   UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Name"):GetComponent("UILabel").text = tostring(ClinetInfomation.Name)
end

UIBattleField.FightTime = 0
function UIBattleField:SetTime()
   if UIBattleField.BattleFieldType==1 then
      UIBattleField.FightTime = 5 - BattleFieldSys.BattleFieldTime
      if UIBattleField.FightTime > 0 then
         UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Times"):GetComponent("UILabel").text = tostring(5 - BattleFieldSys.BattleFieldTime).."/5"
      else
         local Count = ItemPackageSys.GetItemCountById(1141)
         UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Times"):GetComponent("UILabel").text = tostring("挑战令").."("..tostring(Count)..")"
      end
   elseif UIBattleField.BattleFieldType==2 then
      UIBattleField.FightTime = 5 - BattleFieldSys.BattleHeroTime
      --Debug.LogError( BattleFieldSys.BattleHeroTime)
      if UIBattleField.FightTime > 0 then
         UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Times"):GetComponent("UILabel").text = tostring(5 - BattleFieldSys.BattleHeroTime).."/5"
      else
         local Count = ItemPackageSys.GetItemCountById(1141)
         UIBattleField.UIBattleFieldGob.transform:FindChild("MyInfomation"):FindChild("Prop"):FindChild("Times"):GetComponent("UILabel").text = tostring("挑战令").."("..tostring(Count)..")"
      end
   end
end

UIBattleField.BattleFieldTopData = {}
UIBattleField.BattleFieldModels = {}
UIBattleField.ModelsFather = {}
UIBattleField.GoodPlayerInfo = {}
function UIBattleField:CreateModels()                        --创建前5名模型
   UIBattleField.BattleFieldTopData = {}

   if UIBattleField.BattleFieldType==1 then
      UIBattleField.BattleFieldTopData = BattleFieldSys.BattleFieldTopList     
   elseif UIBattleField.BattleFieldType==2 then
      UIBattleField.BattleFieldTopData = BattleFieldSys.BattleHeroTopList      
   end


   if #UIBattleField.ModelsFather==0 then
      for i = 1 , 5 , 1 do
          UIBattleField.ModelsFather[i] = UIBattleField.UIBattleFieldGob.transform:FindChild("ModelFather"):FindChild(tostring(i))
      end
   end
   
   if #UIBattleField.GoodPlayerInfo==0 then
      for i = 1 , 5 , 1 do
          UIBattleField.GoodPlayerInfo[i] = UIBattleField.UIBattleFieldGob.transform:FindChild("GoodPlayerInfo"):FindChild(tostring(i)):FindChild("PlayerInfo")
      end   
   end

   for i = 1 , #UIBattleField.BattleFieldTopData , 1 do
       if UIBattleField.BattleFieldTopData[i]~=nil then
          local _RoleData = UIBattleField.BattleFieldTopData[i].RoleData
          local data = 
          {
             Index = i ,
          }
         -- local _ModelFather = UIBattleField.ModelsFather[i]
         -- Create3DModel.CreateThModel(_RoleData.FbxName , nil , 5 , _ModelFather , UIBattleField.Create3DModelCallBack , true , data)
         local _Sn = ""
         local _Role = RoleDataConfig.GetRoleById(UIBattleField.BattleFieldTopData[i].GuaShuaiId)

         if _Role~=nil then
            _Sn = _Role.SpriteName       
         end

         UIBattleField.GoodPlayerInfo[i].transform.localPosition = Vector3(0 , 0 , 0)
         local _RoleData = UIBattleField.BattleFieldTopData[i].RoleData
         _Sn = _RoleData.SpriteName
         UIBattleField.GoodPlayerInfo[i].transform:FindChild("name"):GetComponent("UILabel").text =  tostring(UIBattleField.BattleFieldTopData[i].Name)
         UIBattleField.GoodPlayerInfo[i].transform:FindChild("Vip"):FindChild("Vip"):GetComponent("UILabel").text = "Vip."..tostring(UIBattleField.BattleFieldTopData[i].Vip)
         UIBattleField.GoodPlayerInfo[i].transform:FindChild("Img"):GetComponent("UISprite").spriteName = _Sn
       end
   end
 
end

function UIBattleField.Create3DModelCallBack(_Gob , _Data)
  -- UIBattleField.BattleFieldModels[_Data.Index] = _Gob
   
   
   --GameMain.Print(_RoleData)
   
end

function UIBattleField.ClearModels()
   for i = 1 , #UIBattleField.BattleFieldModels , 1 do
       GameObject.Destroy(UIBattleField.BattleFieldModels[i].gameObject)
   end
   
   for i = 1 , #UIBattleField.GoodPlayerInfo , 1 do
       UIBattleField.GoodPlayerInfo[i].transform.localPosition = Vector3(0 , 10000 , 0)
   end

   UIBattleField.BattleFieldModels = {}
end

UIBattleField.BattleFieldList = {}
UIBattleField.BattleFieldData = {}
UIBattleField.BattleFieldGrid = nil
function UIBattleField:CreateHeroItems()
    if UIBattleField.BattleFieldGrid==nil then
       UIBattleField.BattleFieldGrid = UIBattleField.UIBattleFieldGob.transform:FindChild("HerosPanel"):FindChild("HeroGrid")
    end
    
    UIBattleField.BattleFieldData = {}

    if UIBattleField.BattleFieldType==1 then
       UIBattleField.BattleFieldData = BattleFieldSys.BattleFieldList     
    elseif UIBattleField.BattleFieldType==2 then
       UIBattleField.BattleFieldData = BattleFieldSys.BattleHeroList      
    end
    --GameMain.Print(UIBattleField.BattleFieldData)
    if #UIBattleField.BattleFieldList==0 then
       for i = 1 ,  15 , 1 do
            local data = 
            {
                Index = i,
            }
            MainGameUI.CreateLittleItem(tostring(i) , "BattleFieldItem" , UIBattleField.BattleFieldGrid , data , this.CreateHeroItemsCallBack  , "UIBattleField")
        end
    else
       --[[for i = 1 , 15 , 1 do 
           UIBattleField.BattleFieldList[i].BattleFieldGob.gameObject:SetActive(false)
       end--]]
       for i = 1 , 15 , 1 do
           local _Gob = UIBattleField.BattleFieldList[i].BattleFieldGob
           local data = 
            {
                Index = i,
            }
           this:CreateHeroItemsCallBack(_Gob , data)
       end
    end
end

function UIBattleField:CreateHeroItemsCallBack(_Gob , _Info)
    local _data = UIBattleField.BattleFieldData[_Info.Index]
    if _data==nil then
       _Gob.gameObject:SetActive(false)
    else
       _Gob.gameObject:SetActive(true)
       local _RoleData = _data.RoleData
       local _Sprite = _Gob.transform:FindChild("IMG"):GetComponent("UISprite")
       AtlasMsg.SetAtlas(_Sprite , _RoleData.AtlasName , _RoleData.SpriteName)
       _Gob.transform:FindChild("name"):GetComponent("UILabel").text = _data.Name
       _Gob.transform:FindChild("Rank"):GetComponent("UILabel").text = tostring(_data.Rank)
       _Gob.transform:FindChild("Vip"):FindChild("VipNum"):GetComponent("UILabel").text = tostring(_data.Vip)
    end
    
    UIBattleField.BattleFieldList[_Info.Index] = 
    {
        BattleFieldGob = _Gob,
    }
    if _Info.Index==15 then
       UIBattleField.BattleFieldGrid:GetComponent("UIGrid").enabled = true
       UIBattleField.BattleFieldGrid:GetComponent("UIGrid"):Reposition()        
    end
end

function UIBattleField:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob.name ==  "BackButton" then
      this:ClosePanel()
   elseif _Gob.name ==  "TeamMake" then
      if UIBattleField.BattleFieldType==1 then
         this:OpenTeamMake()
      else
         this:OpenHeroBattleTeam()
      end   
   elseif _Gob.name ==  "BattleInfo" then
      this:OpenBattleInfoPanel()
   elseif _Gob.name ==  "CloseBattleInfoPanel" then
      this:CloseBattleInfoPanel()
   elseif _Gob.name ==  "GetReward" then
      this:OpenResvRewardPanel()
   elseif _Gob.name == "GetBattleReward" then
      this:GetBattleReward()
   elseif _Gob.name ==  "CloseReceiveRewardPanel" then
      this:CloseResvRewardPanel()
   elseif _Gob.transform.parent.name == "HeroGrid" then
      if UIBattleField.FightTime <= 0 then                  
         local Count = ItemPackageSys.GetItemCountById(1141)
         if Count<=0 then                                   
            DataUIInstance.PopTip("B6")                     --没有次数
            return
         end       
      end
      local _Index = tonumber(_Gob.name)
      this:StartBattle(_Index)
   end
	if _Gob.name == "BattleShop" then
		this:OpenHonerShop()
	end
end

function UIBattleField:OpenHonerShop()
	DataUIInstance.OpenHonerShop(UIBattleField.BattleFieldType)
end

UIBattleField.PlayerId = 0
UIBattleField.PlayerIndex = 0
function UIBattleField:StartBattle(_Index)
   UIBattleField.PlayerIndex = _Index

   local _Player = UIBattleField.BattleFieldData[UIBattleField.PlayerIndex]

   if _Player.PlayerId == ClinetInfomation.World_id then
      DataUIInstance.PopTip("J6")
      return
   end

   local _data = nil
   if UIBattleField.BattleFieldType==1 then
      _data = TeamSys.GetPvpTeamUpInfo()
   elseif UIBattleField.BattleFieldType==2 then
      _data = TeamSys.GetJJCTeamUpInfo()
   end  
	
   DataUIInstance.PopTipPanel("ChangeTeam" , UIBattleField.ChangeTeam , _data) 
	
end

function UIBattleField.ChangeTeam(_TeamNumber)
   
   local _Player = UIBattleField.BattleFieldData[UIBattleField.PlayerIndex]
  
   
   --GameMain.Print(_Player)
   UIBattleField.PlayerId = _Player.PlayerId
   if UIBattleField.BattleFieldType==1 then
      TeamSys.SetPvpTeamType(_TeamNumber)
      PlayerInfoSys.SearchInfo(1 , _Player.PlayerId , 1,UIBattleField.StartBattleCallBack)
   elseif UIBattleField.BattleFieldType==2 then
      TeamSys.SetJJCTeamType(_TeamNumber)
      PlayerInfoSys.SearchInfo(1 , _Player.PlayerId , 1,UIBattleField.StartBattleCallBack)
   end  
end

function UIBattleField.StartBattleCallBack(_EnemyHero)
    BattleFieldSys.TempPlayerInfo = _EnemyHero[UIBattleField.PlayerId]
   --GameMain.Print(BattleFieldSys.TempPlayerInfo)
   if UIBattleField.BattleFieldType==1 then
      BattleFieldSys.BattleFieldFight(UIBattleField.PlayerId)
   elseif UIBattleField.BattleFieldType==2 then
      BattleFieldSys.BattleHeroFight(UIBattleField.PlayerId)
   end  
      
end

function UIBattleField:GetBattleReward()
   if UIBattleField.BattleFieldType==1 then
      BattleFieldSys.GetBattleFieldReward()
   elseif UIBattleField.BattleFieldType==2 then
      BattleFieldSys.GetBattleHeroReward()
   end  
end

UIBattleField.BattleInfoPanel = nil
function UIBattleField:OpenBattleInfoPanel()                    --打开战报
   if UIBattleField.BattleInfoPanel==nil then
      UIBattleField.BattleInfoPanel = UIBattleField.UIBattleFieldGob.transform:FindChild("BattleInfoPanel")
   end
   UIBattleField.BattleInfoPanel.gameObject:SetActive(true)

   if UIBattleField.BattleFieldType==1 then
      BattleFieldSys.RequestBattleFieldInfo()
   elseif UIBattleField.BattleFieldType==2 then
      BattleFieldSys.RequestBattleHeroInfo()
   end
   
end

function UIBattleField:ReflashBattleInfo()
   local _descrip = ""
   for i = 1 , #BattleFieldSys.BattleInfo , 1 do
       _descrip = _descrip..BattleFieldSys.BattleInfo[i].."\n"
   end
   UIBattleField.BattleInfoPanel.transform:FindChild("InfoPanel"):FindChild("Descrip"):GetComponent("UILabel").text = _descrip
end

function UIBattleField:CloseBattleInfoPanel()
   if UIBattleField.BattleInfoPanel~=nil then
      UIBattleField.BattleInfoPanel.gameObject:SetActive(false)
   end
end

UIBattleField.ReceiveRewardPanel = nil
UIBattleField.RewardItems = {}
function UIBattleField:OpenResvRewardPanel()
   if UIBattleField.ReceiveRewardPanel==nil then
      UIBattleField.ReceiveRewardPanel = UIBattleField.UIBattleFieldGob.transform:FindChild("ReceiveRewardPanel")
   end
   UIBattleField.ReceiveRewardPanel.gameObject:SetActive(true)

   if #UIBattleField.RewardItems==0 then
      for i = 1 , 8 , 1 do
          UIBattleField.RewardItems[i] = UIBattleField.ReceiveRewardPanel.transform:FindChild("RulePanel"):FindChild("RulePanelGrid"):FindChild(tostring(i))
      end
   end

   local _TempReward = {}
   local _NowReward = {}
   if UIBattleField.BattleFieldType==1 then                     --沙场点兵
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyRank"):GetComponent("UILabel").text = tostring(BattleFieldSys.MyBattleFieldRank)
      _TempReward = BattleFieldSys.InquireBattleFieldReward()
      _NowReward = BattleFieldSys.FindMyRankReward(BattleFieldSys.MyBattleFieldRank , _TempReward)
      
   elseif UIBattleField.BattleFieldType==2 then                 --斗将台
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyRank"):GetComponent("UILabel").text = tostring(BattleFieldSys.MyBattleHeroRank)
      _TempReward = BattleFieldSys.InquireBattleHeroReward() 
      _NowReward = BattleFieldSys.FindMyRankReward(BattleFieldSys.MyBattleHeroRank , _TempReward)
   end

   if _NowReward~=nil then
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyReward"):FindChild("HoneyT"):FindChild("Rank"):GetComponent("UILabel").text = tostring(_NowReward.Reward.honour) 
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyReward"):FindChild("MoneyT"):FindChild("Money"):GetComponent("UILabel").text = tostring(_NowReward.Reward.coin) 
   else
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyReward"):FindChild("HoneyT"):FindChild("Rank"):GetComponent("UILabel").text = tostring(0) 
      UIBattleField.ReceiveRewardPanel.transform:FindChild("MyReward"):FindChild("MoneyT"):FindChild("Money"):GetComponent("UILabel").text = tostring(0)
   end
   --GameMain.Print(_TempReward)
   for i = 1 , #_TempReward , 1 do
       UIBattleField.RewardItems[i].transform:FindChild("RankT"):FindChild("Rank"):GetComponent("UILabel").text = _TempReward[i].Descrip
       UIBattleField.RewardItems[i].transform:FindChild("HoneyT"):FindChild("Rank"):GetComponent("UILabel").text = tostring(_TempReward[i].Reward.honour)
       UIBattleField.RewardItems[i].transform:FindChild("MoneyT"):FindChild("Money"):GetComponent("UILabel").text = tostring(_TempReward[i].Reward.coin)
   end
   
end

function UIBattleField:CloseResvRewardPanel()
   if UIBattleField.ReceiveRewardPanel~=nil then
      UIBattleField.ReceiveRewardPanel.gameObject:SetActive(false)
   end
end

function UIBattleField:OpenTeamMake()               --沙场
   local UIConTar = MainGameUI.FindPanelTarget("UIControl")
   if UIConTar~=nil then
      UIConTar:OpenTeamMake()
   end
end

function UIBattleField:OpenHeroBattleTeam()        --斗将台
   local UIConTar = MainGameUI.FindPanelTarget("UIControl")
   if UIConTar~=nil then
      UIConTar:OpenJJCTeamMake()
   end
end

function UIBattleField:ClosePanel()
   if UIBattleField.UIBattleFieldGob~=nil then
      UIBattleField.UIBattleFieldGob.gameObject:SetActive(false)
      UIBattleField.ClearModels()
   end
end

function UIBattleField:ReleasPanel()               									
	 UIBattleField.UIBattleFieldGob = nil
     UIBattleField.BattleFieldType = 1                   --1沙场点兵  2 豆酱台
     UIBattleField.SandTitle = nil
     UIBattleField.HeroBattleTitle = nil
     UIBattleField.Rank = nil
     UIBattleField.BattleFieldTopData = {}
     UIBattleField.BattleFieldModels = {}
     UIBattleField.ModelsFather = {}
     UIBattleField.GoodPlayerInfo = {}
     UIBattleField.BattleFieldList = {}
     UIBattleField.BattleFieldData = {}
     UIBattleField.BattleFieldGrid = nil
     UIBattleField.PlayerId = 0
     UIBattleField.PlayerIndex = 0

     UIBattleField.BattleInfoPanel = nil
     UIBattleField.ReceiveRewardPanel = nil
     UIBattleField.RewardItems = {}
end

function UIBattleField:InitPanel()
     UIBattleField.UIBattleFieldGob.gameObject:SetActive(false)
end

return UIBattleField