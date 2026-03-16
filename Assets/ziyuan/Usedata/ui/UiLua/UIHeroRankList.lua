UIHeroRankList = {}
local UIHeroRankList = BasePanel:new()     
local this = UIHeroRankList
UIHeroRankList.UIHeroRankListGob = nil
UIHeroRankList.HeroRankType = 1                 --1 综合排名 2  战斗力排名
UIHeroRankList.ShowPlayerInfoType = 1			--1 武将列表 2 士兵	3 坐骑

UIHeroRankList.ClickPlayerIndex = 0				--当前点击的玩家index		

UIHeroRankList.MyCompRank = 0				--我的综合排名
UIHeroRankList.MyBattleRank = 0				--我的战斗力排名
function UIHeroRankList:OpenUI(_PanelName , _LuaName)
   if UIHeroRankList.UIHeroRankListGob==nil then
	  UIHeroRankList.UIHeroRankListGob=MainGameUI.FindPanel("UIHeroRankList")		
   end
	if UIHeroRankList.TempButton == nil then
		UIHeroRankList.TempButton = UIHeroRankList.UIHeroRankListGob.transform:FindChild("GeneralButton")
	end
	this:SetInitData()
   UIHeroRankList.HeroRankType = 0
   this:ShowMyInfo()
   this:ChangeButton(UIHeroRankList.TempButton ,1)
end

function UIHeroRankList.SetInitData()
	UIHeroRankList.MyCompRank = ClinetInfomation.compRank
	UIHeroRankList.MyBattleRank = ClinetInfomation.powerRank
end

UIHeroRankList.MyInfo = nil
function UIHeroRankList:ShowMyInfo()
	if UIHeroRankList.MyInfo == nil then
		UIHeroRankList.MyInfo = UIHeroRankList.UIHeroRankListGob.transform:FindChild("myRankInfo"):GetComponent("UILabel")
	end
	if UIHeroRankList.HeroRankType ==1 then
		UIHeroRankList.MyInfo.text = "我的排名：" .. UIHeroRankList.MyCompRank
	end
	if UIHeroRankList.HeroRankType ==2 then
		UIHeroRankList.MyInfo.text = "我的排名：" .. UIHeroRankList.MyBattleRank
	end

end

UIHeroRankList.TempButton = nil
function UIHeroRankList:ChangeButton( _Button, _Type)
   if UIHeroRankList.HeroRankType==_Type then
      return
   end
   UIHeroRankList.HeroRankType = _Type

	if UIHeroRankList.TempButton ~= nil then
		GameMain.CloseObj(UIHeroRankList.TempButton.transform:FindChild("ClickBg"))
		GameMain.OpenObj(UIHeroRankList.TempButton.transform:FindChild("BG"))
	end
	UIHeroRankList.TempButton = _Button
	GameMain.OpenObj(UIHeroRankList.TempButton.transform:FindChild("ClickBg"))
	GameMain.CloseObj(UIHeroRankList.TempButton.transform:FindChild("BG"))

	this:ShowMyInfo()
   if UIHeroRankList.HeroRankType==1 then
      HeroRankListSys.GetComprehensiveRank()
      UIHeroRankList.UIHeroRankListGob.transform:FindChild("Rank"):FindChild("RankTitle").gameObject:SetActive(true)
      UIHeroRankList.UIHeroRankListGob.transform:FindChild("Rank"):FindChild("FightTitle").gameObject:SetActive(false)
   elseif UIHeroRankList.HeroRankType==2 then
      HeroRankListSys.GetFightRank()
      UIHeroRankList.UIHeroRankListGob.transform:FindChild("Rank"):FindChild("RankTitle").gameObject:SetActive(false)
      UIHeroRankList.UIHeroRankListGob.transform:FindChild("Rank"):FindChild("FightTitle").gameObject:SetActive(true)
   end
end

UIHeroRankList.RankPanel = nil
UIHeroRankList.RankWrap = nil
UIHeroRankList.RankGrid = nil
UIHeroRankList.RankListGob = {}
UIHeroRankList.RankListData = {}
function UIHeroRankList:CreateRankList()
    UIHeroRankList.RankListData = {}
    if UIHeroRankList.HeroRankType == 1 then
       UIHeroRankList.RankListData = HeroRankListSys.ComprehensiveRankData
    elseif UIHeroRankList.HeroRankType == 2 then
       UIHeroRankList.RankListData = HeroRankListSys.FightRankData
    end
   
    if UIHeroRankList.RankPanel==nil then
       UIHeroRankList.RankPanel = UIHeroRankList.UIHeroRankListGob.transform:FindChild("Rank"):FindChild("RankPanel")
    end
    if UIHeroRankList.RankWrap==nil then
       UIHeroRankList.RankWrap = UIHeroRankList.RankPanel.transform:GetComponent("UIWrap")
    end 
    if UIHeroRankList.RankGrid==nil then
       UIHeroRankList.RankGrid = UIHeroRankList.RankPanel.transform:FindChild("Grid")
    end
	
      for i = 1 , 10 , 1 do
           local data = 
           {
               Index = i,
           }
		if  UIHeroRankList.RankListGob[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "HeroRankItem" , UIHeroRankList.RankGrid , data , this.CreateRankListCallBack  , "UIHeroRankList")
		else
			this:CreateRankListCallBack(UIHeroRankList.RankListGob[i] , data)
		end
     end
    
       UIHeroRankList.RankPanel.transform.localPosition = Vector3(0 , 0 , 0)
       UIHeroRankList.RankWrap:ResetTrans(#UIHeroRankList.RankListData)
       UIHeroRankList.RankGrid:GetComponent("UIGrid").enabled = true
       UIHeroRankList.RankGrid:GetComponent("UIGrid"):Reposition()
end

function UIHeroRankList:CreateRankListCallBack(_Gob , _Info) 
	UIHeroRankList.RankListGob[_Info.Index] = _Gob
	if _Info.Index == 10 then
      UIHeroRankList.RankGrid:GetComponent("UIGrid").enabled = true
      UIHeroRankList.RankGrid:GetComponent("UIGrid"):Reposition()
      UIHeroRankList.RankWrap:SetData(#UIHeroRankList.RankListData , "UIHeroRankList")
	
	  this:SendWebShowPlayerInfo(1)
   end
	
   local _Data =  UIHeroRankList.RankListData[_Info.Index]
   if _Data==nil then
      _Gob.gameObject:SetActive(false)
   else   
       _Gob.gameObject:SetActive(true)
       if UIHeroRankList.HeroRankType==1 then
          this:SetComprehensiveRankInfo(_Gob , _Data)
       elseif UIHeroRankList.HeroRankType==2 then 
          this:SetFightRankInfo(_Gob , _Data)  
       end
   end
   
  
   
end

function UIHeroRankList:SetComprehensiveRankInfo(_Gob , _Data)
    _Gob.transform:FindChild("RankContent").gameObject:SetActive(true)
    _Gob.transform:FindChild("FightContent").gameObject:SetActive(false)
    _Gob.transform:FindChild("RankImg").gameObject:SetActive(true)
    if _Data.Rank==1 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "diyi"
       _Gob.transform:FindChild("RankContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    elseif _Data.Rank == 2 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "dier"
       _Gob.transform:FindChild("RankContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    elseif _Data.Rank == 3 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "disan"
       _Gob.transform:FindChild("RankContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    else      	
       _Gob.transform:FindChild("RankContent").transform:FindChild("RankC"):GetComponent("UILabel").text = tostring(_Data.Rank)
       _Gob.transform:FindChild("RankImg").gameObject:SetActive(false)
    end
    _Gob.transform:FindChild("RankContent").transform:FindChild("Vip"):GetComponent("UILabel").text = "V"..tostring(_Data.Vip)
    _Gob.transform:FindChild("RankContent").transform:FindChild("GodC"):GetComponent("UILabel").text = tostring(_Data.Qlt5)..UIstring.Ming
    _Gob.transform:FindChild("RankContent").transform:FindChild("DoubleC"):GetComponent("UILabel").text = tostring(_Data.Qlt4)..UIstring.Ming
    _Gob.transform:FindChild("RankContent").transform:FindChild("MiracleC"):GetComponent("UILabel").text = tostring(_Data.Qlt3)..UIstring.Ming
    _Gob.transform:FindChild("RankContent").transform:FindChild("GoodC"):GetComponent("UILabel").text = tostring(_Data.Qlt2)..UIstring.Ming
    _Gob.transform:FindChild("RankContent").transform:FindChild("BossName"):GetComponent("UILabel").text = tostring(_Data.Name)
end

function UIHeroRankList:SetFightRankInfo(_Gob , _Data)
	if _Data.Rank==1 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "diyi"
       _Gob.transform:FindChild("FightContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    elseif _Data.Rank == 2 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "dier"
       _Gob.transform:FindChild("FightContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    elseif _Data.Rank == 3 then
       _Gob.transform:FindChild("RankImg"):GetComponent("UISprite").spriteName = "disan"
       _Gob.transform:FindChild("FightContent").transform:FindChild("RankC"):GetComponent("UILabel").text = ""
    else      	
       _Gob.transform:FindChild("FightContent").transform:FindChild("RankC"):GetComponent("UILabel").text = tostring(_Data.Rank)
       _Gob.transform:FindChild("RankImg").gameObject:SetActive(false)
    end

    _Gob.transform:FindChild("RankContent").gameObject:SetActive(false)
    _Gob.transform:FindChild("FightContent").gameObject:SetActive(true)
   -- _Gob.transform:FindChild("FightContent").transform:FindChild("RankC"):GetComponent("UILabel").text = tostring(_Data.Rank)
    _Gob.transform:FindChild("FightContent").transform:FindChild("BossName"):GetComponent("UILabel").text = tostring(_Data.Name)
    _Gob.transform:FindChild("FightContent").transform:FindChild("FightC"):GetComponent("UILabel").text = tostring(_Data.Fight)
    _Gob.transform:FindChild("FightContent").transform:FindChild("Vip (1)"):GetComponent("UILabel").text = "V"..tostring(_Data.Vip)
end

UIHeroRankList.HumenPanel = nil
UIHeroRankList.HumenWrap = nil
UIHeroRankList.HumenGrid = nil
UIHeroRankList.HumenListGob = {}
UIHeroRankList.HumenListData = {}

function UIHeroRankList:ChangePlayerInfo(_Type)
--	if UIHeroRankList.ShowPlayerInfoType == _Type then
--		return
--	end
	UIHeroRankList.ShowPlayerInfoType = _Type

	if UIHeroRankList.HeroButton == nil then
		UIHeroRankList.HeroButton = UIHeroRankList.UIHeroRankListGob.transform:FindChild("HeroButton")
	end
	if UIHeroRankList.SoldierButton == nil then
		UIHeroRankList.SoldierButton = UIHeroRankList.UIHeroRankListGob.transform:FindChild("SoldierButton")
	end
	if UIHeroRankList.ShowPlayerInfoType == 1 then
		GameMain.CloseObj(UIHeroRankList.HeroButton.transform:FindChild("BG"))
		GameMain.OpenObj(UIHeroRankList.HeroButton.transform:FindChild("ClickBg"))
		GameMain.OpenObj(UIHeroRankList.SoldierButton.transform:FindChild("BG"))
		GameMain.CloseObj(UIHeroRankList.SoldierButton.transform:FindChild("ClickBg"))
	else
		GameMain.OpenObj(UIHeroRankList.HeroButton.transform:FindChild("BG"))
		GameMain.CloseObj(UIHeroRankList.HeroButton.transform:FindChild("ClickBg"))
		GameMain.CloseObj(UIHeroRankList.SoldierButton.transform:FindChild("BG"))
		GameMain.OpenObj(UIHeroRankList.SoldierButton.transform:FindChild("ClickBg"))
	end
	UIHeroRankList.HumenListData = {}
	if UIHeroRankList.HumenPanel == nil then
		UIHeroRankList.HumenPanel = UIHeroRankList.UIHeroRankListGob.transform:FindChild("HumenPanel"):GetComponent("UIPanel")
	end
	if UIHeroRankList.CurPlayerInfo == nil then
		GameMain.CloseObj(UIHeroRankList.HumenPanel)
		return
	else
		GameMain.OpenObj(UIHeroRankList.HumenPanel)
	end	
	if UIHeroRankList.ShowPlayerInfoType == 1 then
        for i = 1 , #UIHeroRankList.CurPlayerInfo.HeroList , 1 do 
            if UIHeroRankList.CurPlayerInfo.HeroList[i].quality >= 5 then
               table.insert(UIHeroRankList.HumenListData , #UIHeroRankList.HumenListData + 1 , UIHeroRankList.CurPlayerInfo.HeroList[i])
            end
        end
		--UIHeroRankList.HumenListData = UIHeroRankList.CurPlayerInfo.HeroList
	else
		UIHeroRankList.HumenListData = UIHeroRankList.CurPlayerInfo.SoliderList
	end
	this:CreateHumanList()
end

function UIHeroRankList:CreateHumanList()
   if UIHeroRankList.HumenPanel == nil then
      UIHeroRankList.HumenPanel = UIHeroRankList.UIHeroRankListGob.transform:FindChild("HumenPanel"):GetComponent("UIPanel")
   end
   if UIHeroRankList.HumenWrap == nil then
      UIHeroRankList.HumenWrap = UIHeroRankList.HumenPanel.transform:GetComponent("UIWrap")
   end
   if UIHeroRankList.HumenGrid == nil then
      UIHeroRankList.HumenGrid = UIHeroRankList.HumenPanel.transform:FindChild("HumenGrid"):GetComponent("UIGrid")
   end
  
   UIHeroRankList.HumenPanel.clipOffset = Vector2(0 ,0)
   UIHeroRankList.HumenPanel.transform.localPosition = Vector3(0,0,0)
   UIHeroRankList.HumenWrap:ResetTrans(#UIHeroRankList.HumenListData)
   
	if #UIHeroRankList.HumenListData<=0 then
		GameMain.CloseObj(UIHeroRankList.HumenPanel)
		return
	else
		GameMain.OpenObj(UIHeroRankList.HumenPanel)
	end
   for i=1,16,1  do
		local data = 
        {
           Index = i,
        }
		if UIHeroRankList.HumenListGob[i] == nil then
		   MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , UIHeroRankList.HumenGrid , data , this.CreateHumanListCallBack  , "UIHeroRankList")
		else
			this:CreateHumanListCallBack(UIHeroRankList.HumenListGob[i] , data)
		end
   end
	
end

function UIHeroRankList:CreateHumanListCallBack(_Gob , _Info)
   
   if _Info.Index == 16 then
		UIHeroRankList.HumenGrid.enabled = true
		UIHeroRankList.HumenGrid:Reposition()
		UIHeroRankList.HumenWrap:SetData(#UIHeroRankList.HumenListData , "UIHeroRankList")
   end
	UIHeroRankList.HumenListGob[tonumber(_Info.Index)] = _Gob
   local data = UIHeroRankList.HumenListData[_Info.Index]
   this:ShowHumanItemInfo(_Gob , data)
end

function UIHeroRankList:ShowHumanItemInfo(_Gob , _Data)
	if _Data == nil then
		GameMain.CloseObj(_Gob)
		return 
	end 
	GameMain.OpenObj(_Gob)
	local name = _Gob.transform:FindChild("name"):GetComponent("UILabel")
	local lvl = _Gob.transform:FindChild("Lvl"):GetComponent("UILabel")
	local Img = _Gob.transform:FindChild("IMG"):GetComponent("UISprite")
	local FG = _Gob.transform:FindChild("FG"):GetComponent("UISprite")
	local bg = _Gob.transform:FindChild("bg"):GetComponent("UISprite") 
	name.text = UIstring.WordColor[_Data.quality] .. _Data.nickname .. "[-]"
	lvl.text = "Lv" .. _Data.lvl
	FG.spriteName = UIstring.ItemFg[tonumber(_Data.quality)]
	bg.spriteName = UIstring.ItemFg[tonumber(_Data.quality)]
	AtlasMsg.SetAtlas(Img , _Data.AtlasName , _Data.SpriteName)
end

function UIHeroRankList:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
  if _Gob.name == "GeneralButton" then
     this:ChangeButton( _Gob,1)	--综合排名
  elseif _Gob.name == "FightButton" then
     this:ChangeButton(_Gob,2) --战斗力排名
  elseif _Gob.name == "HeroButton" then
	this:ChangePlayerInfo(1)
  elseif _Gob.name == "SoldierButton" then
	this:ChangePlayerInfo(2)
  elseif _Gob.name == "CloseBtn" then
     this:CloseHeroRankPanel()
  end
  
  local key = tonumber(_Gob.name)
  if key~=nil then
	local parentName = _Gob.transform.parent.name
	if parentName == "Grid" then
		this:ShowClickPlayerInfo(key)
	end
	if parentName == "HumenGrid" then
		this:ShowClickHumenInfo(key)
	end
  end
	
	if _Gob.name == "MyRankBtn" then
		this:ToMyRankInfo()
	end
end

function UIHeroRankList:ToMyRankInfo()			--去到我的位置
	
end

function UIHeroRankList:ShowClickHumenInfo(_Index)
	local data = UIHeroRankList.HumenListData[_Index]
	if data~=nil then
		--GameMain.Print(data.nickname , data.Dbid)
	end
end

function UIHeroRankList:ShowClickPlayerInfo(_Index)
	if UIHeroRankList.ClickPlayerIndex == _Index then
		return 
	end
	
	this:SendWebShowPlayerInfo(_Index)
end

UIHeroRankList.HeroButton = nil
UIHeroRankList.SoldierButton = nil

function UIHeroRankList:SendWebShowPlayerInfo(_Index)

	if UIHeroRankList.ClickPlayerIndex ~= 0 then
		local clickImg = UIHeroRankList.RankListGob[UIHeroRankList.ClickPlayerIndex].transform:FindChild("Arrow")
		GameMain.CloseObj(clickImg)
	end
	UIHeroRankList.ClickPlayerIndex = _Index
	local clickImg = UIHeroRankList.RankListGob[_Index].transform:FindChild("Arrow")
	GameMain.OpenObj(clickImg)
	local data = UIHeroRankList.RankListData[_Index]
	if UIHeroRankList.HumenPanel == nil then
		UIHeroRankList.HumenPanel = UIHeroRankList.UIHeroRankListGob.transform:FindChild("HumenPanel"):GetComponent("UIPanel")
	end
	if data~=nil then
		GameMain.OpenObj(UIHeroRankList.HumenPanel)
		PlayerInfoSys.SearchInfo(0 , data.Id , 1,UIHeroRankList.ShowPlayerInfo)
	else
		UIHeroRankList.CurPlayerInfo = nil
		GameMain.CloseObj(UIHeroRankList.HumenPanel)
	end
end

UIHeroRankList.CurPlayerInfo = nil	--当前的玩家信息

function UIHeroRankList.ShowPlayerInfo(_Data)
	local playerData = _Data[UIHeroRankList.RankListData[UIHeroRankList.ClickPlayerIndex].Id]
	UIHeroRankList.CurPlayerInfo = playerData
	this:ChangePlayerInfo(1)
end

function UIHeroRankList:UpdateItem(_LuaName , _Item)
	local parentName = _Item.transform.parent.name
	if parentName == "Grid" then
		 if UIHeroRankList.HeroRankType==1 then
		  local _Index = tonumber(_Item.name)
		  local _Data = UIHeroRankList.RankListData[_Index]
		  if _Data~=nil then
			 _Item.gameObject:SetActive(true)
			 this:SetComprehensiveRankInfo(_Item.gameObject , _Data)
		  end
	   else
		  local _Index = tonumber(_Item.name)
		  local _Data = UIHeroRankList.RankListData[_Index]
		  if _Data~=nil then
			 _Item.gameObject:SetActive(true)
			 this:SetFightRankInfo(_Item.gameObject , _Data)
		  end
	   end
	end
	if parentName == "HumenGrid" then
		local _Index = tonumber(_Item.name)
		local _Data = UIHeroRankList.HumenListData[_Index]
        if _Data~=nil then
           _Item.gameObject:SetActive(true)
           UIHeroRankList.HumenListGob[_Index] = _Item
		   this:ShowHumanItemInfo(_Item , _Data)
        else
           _Item.gameObject:SetActive(false)
        end
		
	end
end

function UIHeroRankList:CloseHeroRankPanel()
   if UIHeroRankList.UIHeroRankListGob~=nil then
      UIHeroRankList.UIHeroRankListGob.gameObject:SetActive(false)
   end
end

function UIHeroRankList:ReleasPanel()
	UIHeroRankList.UIHeroRankListGob = nil
	UIHeroRankList.HeroRankType = 1                 --1 综合排名 2  战斗力排名
	UIHeroRankList.ShowPlayerInfoType = 1			--1 武将列表 2 士兵	3 坐骑

	UIHeroRankList.HumenPanel = nil
	UIHeroRankList.HumenWrap = nil
	UIHeroRankList.HumenGrid = nil
	UIHeroRankList.HumenListGob = {}
	UIHeroRankList.HumenListData = {}

	UIHeroRankList.RankPanel = nil
	UIHeroRankList.RankWrap = nil
	UIHeroRankList.RankGrid = nil
	UIHeroRankList.RankListGob = {}
	UIHeroRankList.RankListData = {}

	UIHeroRankList.TempButton = nil
	UIHeroRankList.MyInfo = nil

	UIHeroRankList.CurPlayerInfo = nil	--当前的玩家信息

	UIHeroRankList.HeroButton = nil
	UIHeroRankList.SoldierButton = nil
	UIHeroRankList.MyCompRank = 0				--我的综合排名
	UIHeroRankList.MyBattleRank = 0				--我的战斗力排名
end

function UIHeroRankList.ReleasData()
	HeroRankListSys.ComprehensiveRankData = {}
	HeroRankListSys.FightRankData = {}
	HeroRankListSys.HeroData = {}
	HeroRankListSys.SoldierData = {}

end

return UIHeroRankList