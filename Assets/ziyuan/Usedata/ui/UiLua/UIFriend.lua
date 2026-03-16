UIFriend = {}
local UIFriend = BasePanel:new()     
local this = UIFriend

--UI
UIFriend.UIFriendGob = nil
UIFriend.Controls = {}
UIFriend.TagBtns = {}
UIFriend.PopPanel = nil
UIFriend.PopControls = {}
UIFriend.GodList = {}		

UIFriend.SearchPanel = nil	--查找界面
--Data
UIFriend.ClickTagIndex = 0	--当前所在的界面
UIFriend.DataList = {}
UIFriend.RecommendList = {}	--推荐的好友
UIFriend.FriendDataList = {}	--好友数据
UIFriend.ApplyDataList = {}		--申请的数据
UIFriend.BlackDataList = {}		--黑名单

UIFriend.CurClickIndex = 0	--当前点击的那个请求的好友

UIFriend.FriendCount = 0	--好友数量
UIFriend.BlackCount = 0		--黑名单数量
UIFriend.SearchPlayerData = nil	--查找的玩家信息

function UIFriend:OpenUI()
	if UIFriend.UIFriendGob == nil then
		UIFriend.UIFriendGob=MainGameUI.FindPanel("UIFriend")
		UIFriend.PopPanel = UIFriend.UIFriendGob.transform:FindChild("PopPanel")
		this:GetControls()
	end
	this:ShowChangePanel(1)
end

function UIFriend:GetControls()
	local btnGrid = UIFriend.UIFriendGob.transform:FindChild("ButtonGrid")
	
	UIFriend.TagBtns[1] = btnGrid.transform:FindChild("Friend")
	UIFriend.TagBtns[2] = btnGrid.transform:FindChild("AddFriend")
	UIFriend.TagBtns[3] = btnGrid.transform:FindChild("BlackFriend")
	UIFriend.TagBtns[4] = btnGrid.transform:FindChild("ApplyFriend")
	
	UIFriend.Controls.ListPanel = UIFriend.UIFriendGob.transform:FindChild("RankPanel"):GetComponent("UIPanel")
	UIFriend.Controls.ListGrid = UIFriend.Controls.ListPanel.transform:FindChild("Grid"):GetComponent("UIGrid")
	
	UIFriend.SearchPanel = UIFriend.UIFriendGob.transform:FindChild("Search")
	UIFriend.Controls.InputTxt = UIFriend.SearchPanel.transform:FindChild("Input/Label"):GetComponent("UIInput")
--	UIFriend.Controls.InfoTxt = UIFriend.UIFriendGob.transform:FindChild("Info"):GetComponent("UILabel")
	UIFriend.Controls.AddFriendInfo = UIFriend.UIFriendGob.transform:FindChild("AddFriendInfo")
	UIFriend.Controls.FriendInfo = UIFriend.UIFriendGob.transform:FindChild("FriendInfo")
	UIFriend.Controls.BlackFriendInfo = UIFriend.UIFriendGob.transform:FindChild("BlackFriendInfo")
	UIFriend.Controls.FriendCount = UIFriend.Controls.FriendInfo.transform:FindChild("Info"):GetComponent("UILabel")
	UIFriend.Controls.BlackFriendCount = UIFriend.Controls.BlackFriendInfo.transform:FindChild("info"):GetComponent("UILabel")

	UIFriend.Controls.FriendItem = UIFriend.UIFriendGob.transform:FindChild("AddFriendItem")
end

function UIFriend:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
   if _Gob.name=="CloseBtn" then
      this:ClosePanel()
   end
	if _Gob.name == "Delete" then
		local key =tonumber(_Gob.transform.parent.name)
		if key~=nil then
			this:DeletFriend(key)
		end
	end
	if _Gob.name == "Friend" then
		this:ShowChangePanel(1)
	end
	if _Gob.name == "AddFriend" then
		this:ShowChangePanel(2)		--请求推荐的好友
	end
	if _Gob.name == "BlackFriend" then
		this:ShowChangePanel(3)
	end
	if _Gob.name == "ApplyFriend" then
		this:ShowChangePanel(4)		
	end

	if _Gob.name == "ClosePopBtn" then
		this:ClosePopPanel()
	end
	if _Gob.name == "Cancel" then
		local key =tonumber(_Gob.transform.parent.name)
		if key~=nil then
			this:SendWebCancelBlack(key)
		end
	end

	if _Gob.name == "Add" then
		local parentName =_Gob.transform.parent.name 
		if parentName == "AddFriendItem" then
			this:AddSearchFriend()
		end
		local key =tonumber(parentName)
		if key~=nil then
			this:SendWebAddFriend(key)
		end
	end
	if _Gob.name == "Agree" then
		local key =tonumber(_Gob.transform.parent.name)
		if key~=nil then
			this:AgreeToFriend(key)
		end
	end
	if _Gob.name == "Refuse" then
		local key =tonumber(_Gob.transform.parent.name)
		if key~=nil then
			this:RefuseToFriend(key)
		end
	end

	if _Gob.name == "HeroHead" and UIFriend.ClickTagIndex == 2  then
		local key =tonumber(_Gob.transform.parent.name)
		if key~=nil then
			this:ShowPopPanel(key)
		end
	end
	if _Gob.name == "ReplaceBtn" then
		--换一批推荐好友
		this:ReplaceAddFriendInfo(1)
	end
	if _Gob.name == "SearchBtn" then
		--查找相应的好友
		this:ShowSearchFriend()
	end


	if _Gob.name == "AddBtn" then
		
		this:SendWebAddFriend(UIFriend.CurClickIndex)
		
		this:ClosePopPanel()
	end
	if _Gob.name == "BlackBtn" then
		
		this:SendWebBlackFriend(UIFriend.CurClickIndex)
	
		this:ClosePopPanel()
	end
end

--查找相应的好友
function UIFriend:ShowSearchFriend()
	UIFriend.SearchPlayerData = nil
	local id = UIFriend.Controls.InputTxt.value
	FriendSys.SearchPlayerInfo(id)
--	PlayerInfoSys.SearchInfo(1 , id , 2,UIFriend.SearchCallBack)
--	DataUIInstance.PopTip("未找到该玩家")
end

function UIFriend:SearchCallBack(_PlayerData)
	UIFriend.SearchPlayerData = _PlayerData
	GameMain.CloseObj(UIFriend.Controls.ListPanel)
	GameMain.OpenObj(UIFriend.Controls.FriendItem)
	local godInfo = UIFriend.Controls.FriendItem.transform:FindChild("HeroHead")
	local img = godInfo.transform:FindChild("IMG"):GetComponent("UISprite")
	local lvl = godInfo.transform:FindChild("Lvl"):GetComponent("UILabel")
	local godContent = UIFriend.Controls.FriendItem.transform:FindChild("FriendContent")
	local countroy = godContent.transform:FindChild("Contory"):GetComponent("UILabel")
	local name = godContent.transform:FindChild("Name"):GetComponent("UILabel")
	local add = UIFriend.Controls.FriendItem.transform:FindChild("Add")
	local hasAdd = UIFriend.Controls.FriendItem.transform:FindChild("hasAdd")
	GameMain.CloseObj(hasAdd)
	GameMain.OpenObj(add)

	AtlasMsg.SetAtlas(img , _PlayerData.AtlasName , _PlayerData.SpriteName)
	lvl.text = "Lv" .. _PlayerData.lvl
	name.text = _PlayerData.name
	countroy.text = UIstring.Ownerships[ _PlayerData.Camp]
	local vipLabel = UIFriend.Controls.FriendItem.transform:FindChild("vip"):GetComponent("UILabel")
	vipLabel.text = "V" .. _PlayerData.VipLvl
end 
function UIFriend:ShowNormalSearchInfo()
	UIFriend.Controls.InputTxt.value = ""
end

function UIFriend:ShowChangePanel(Index)
	UIFriend.SearchPlayerData = nil
	GameMain.OpenObj(UIFriend.Controls.ListPanel)
	GameMain.CloseObj(UIFriend.Controls.FriendItem)

	if UIFriend.ClickTagIndex == Index then
		return
	end
	if UIFriend.ClickTagIndex~=0 then
		local god = UIFriend.TagBtns[UIFriend.ClickTagIndex]
		GameMain.CloseObj(god.transform:FindChild("Choose"))
		GameMain.OpenObj(god.transform:FindChild("BG"))
	end

	UIFriend.ClickTagIndex = Index
	GameMain.OpenObj(UIFriend.TagBtns[UIFriend.ClickTagIndex].transform:FindChild("Choose"))
	GameMain.CloseObj(UIFriend.TagBtns[UIFriend.ClickTagIndex].transform:FindChild("BG"))

	if UIFriend.ClickTagIndex == 2 then
		GameMain.OpenObj(UIFriend.SearchPanel)
	else
		GameMain.CloseObj(UIFriend.SearchPanel)
	end
	if UIFriend.ClickTagIndex == 1 then
		this:ShowFriendInfo()
	end
	if UIFriend.ClickTagIndex == 2 then
		this:ShowAddFriendInfo(0)
	end
	if UIFriend.ClickTagIndex == 3 then
		this:ShowBlackFriendInfo()
	end
	if UIFriend.ClickTagIndex == 4 then
		this:ShowApplyFriendInfo()
	end
end

function UIFriend:DeletFriend(Index)		--删除好友
	local _data = UIFriend.FriendDataList[Index]
	FriendSys.RemoveFriend(_data.Dbid)
	table.remove(UIFriend.FriendDataList , Index)
	this:ShowListInfo(UIFriend.FriendDataList)
	local str = "玩家" .. _data.name .. "已经被删除"
	DataUIInstance.PopTip(str)
	UIFriend.FriendCount= UIFriend.FriendCount -1
	UIFriend.Controls.FriendCount.text = "好友数量："..UIFriend.FriendCount .. "/100"
end

function UIFriend:RefuseToFriend(Index)		--拒绝成为好友
	local _data = UIFriend.ApplyDataList[Index]
	FriendSys.ResponseFriend(_data.Dbid , 0)
	table.remove(UIFriend.ApplyDataList , Index)
	this:ShowListInfo(UIFriend.ApplyDataList)
end

function UIFriend:AgreeToFriend(Index)		--同意成为好友
	local _data = UIFriend.ApplyDataList[Index]
	FriendSys.ResponseFriend(_data.Dbid , 1)
	table.remove(UIFriend.ApplyDataList , Index)
	this:ShowListInfo(UIFriend.ApplyDataList)
end

function UIFriend:ShowFriendInfo()			--显示好友信息
	GameMain.CloseObj(UIFriend.Controls.AddFriendInfo)
	GameMain.CloseObj(UIFriend.Controls.BlackFriendInfo)
	GameMain.OpenObj(UIFriend.Controls.FriendInfo)
	this:ClearDataList()
	FriendSys.GetMyFriends(UIFriend.GetFriendCallBack)
end

function UIFriend.GetFriendCallBack(_Data)
	if _Data == nil then
		UIFriend.Controls.FriendCount.text = "好友数量:0/100"
		UIFriend.FriendCount = 0
		return
	end
	UIFriend.FriendDataList = {}
	UIFriend.FriendCount = 0
	for key,value in pairs(_Data) do
		UIFriend.FriendCount = UIFriend.FriendCount +1
		table.insert(UIFriend.FriendDataList , #UIFriend.FriendDataList +1 , value)
	end
	GameMain.OpenObj(UIFriend.Controls.InfoTxt)
	UIFriend.Controls.FriendCount.text = "好友数量:" .. UIFriend.FriendCount .."/100"
	this:ShowListInfo(UIFriend.FriendDataList)
end
--显示推荐添加的好友信息 1 刷新 0 不刷新
function UIFriend:ShowAddFriendInfo(_Type) 
	GameMain.CloseObj(UIFriend.Controls.FriendInfo)
	GameMain.CloseObj(UIFriend.Controls.BlackFriendInfo)
	GameMain.OpenObj(UIFriend.Controls.AddFriendInfo)
	this:ShowNormalSearchInfo()
	this:ClearDataList()
	if #UIFriend.RecommendList>0 then
		
		this:ShowListInfo(UIFriend.RecommendList)
		return
	end
	FriendSys.RecommendFriend(_Type)
end

function UIFriend:ReplaceAddFriendInfo(_Type) 
	this:ClearDataList()
	this:ShowNormalSearchInfo()
	FriendSys.RecommendFriend(_Type)
end
function UIFriend:ShowAddFriendCallBack()
	local dataList = FriendSys.RecommendDataList
	UIFriend.RecommendList = {}
	for i=1,#dataList,1  do
		if FriendSys.FriendDataDic[dataList[i].Dbid]== nil and FriendSys.BlackFriendDic[dataList[i].Dbid] == nil  then
			if ClinetInfomation.Player_id ~= dataList[i].Dbid then
				table.insert(UIFriend.RecommendList , #UIFriend.RecommendList +1 , dataList[i])
			end
		end
	end
	this:ShowListInfo(UIFriend.RecommendList)
end
--显示黑名单
function UIFriend:ShowBlackFriendInfo()
	GameMain.CloseObj(UIFriend.Controls.AddFriendInfo)
	GameMain.OpenObj(UIFriend.Controls.BlackFriendInfo)
	GameMain.CloseObj(UIFriend.Controls.FriendInfo)
	this:ClearDataList()
	
	FriendSys.GetBlackFriends(UIFriend.ShowBlackInfoCallBack)
end

function UIFriend.ShowBlackInfoCallBack(_Data)
	if _Data ==nil then
		UIFriend.BlackCount = 0
		UIFriend.Controls.BlackFriendCount.text = "已屏蔽0/100"
		return 
	end
	UIFriend.BlackDataList = {}
	UIFriend.BlackCount = 0
	for key,value in pairs(_Data) do
		UIFriend.BlackCount = UIFriend.BlackCount +1
		table.insert(UIFriend.BlackDataList , #UIFriend.BlackDataList +1 , value)
	end
	UIFriend.Controls.BlackFriendCount.text = "已屏蔽" .. UIFriend.BlackCount .."/100"
	this:ShowListInfo(UIFriend.BlackDataList)
end

--显示申请的好友名单
function UIFriend:ShowApplyFriendInfo()
	this:ClearDataList()
	GameMain.CloseObj(UIFriend.Controls.AddFriendInfo)
	GameMain.CloseObj(UIFriend.Controls.BlackFriendInfo)
	GameMain.CloseObj(UIFriend.Controls.FriendInfo)
	FriendSys.GetRequirseFriends(UIFriend.ShowApplyCallBack)
end

function UIFriend.ShowApplyCallBack(_Data)
	if _Data == nil then
		return
	end
	UIFriend.ApplyDataList = {}
	for key,value in pairs(_Data) do
		if FriendSys.FriendDataDic[tostring( value.Dbid)] == nil then
			table.insert(UIFriend.ApplyDataList , #UIFriend.ApplyDataList +1 ,value)
		end
	end
	this:ShowListInfo(UIFriend.ApplyDataList);
end

function UIFriend:ClearDataList()
	if #UIFriend.GodList>0 then
		for i=1,#UIFriend.GodList,1 do
			GameMain.CloseObj(UIFriend.GodList[i])
		end
	end
end

function UIFriend:SetSpringAfterInfo(_Len)
	UIFriend.Controls.ListPanel.transform:GetComponent("UIWrap"):ResetTrans(_Len)
	UIFriend.Controls.ListPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UIFriend.Controls.ListPanel.clipOffset = Vector2(0 , 0)
end

function UIFriend:ShowListInfo(_List)
	for i=1,8,1  do
		local data = 
		{
			Index = i,
			Len = #_List
		}
		if UIFriend.GodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "FriendItem" , UIFriend.Controls.ListGrid , data , this.CreateListCallBack , "UIFriend") 
		else
			this:CreateListCallBack(UIFriend.GodList[i],data)
		end
	end
end

function UIFriend:CreateListCallBack(_God , _Info)
	if _Info.Index == 8 then
		UIFriend.Controls.ListGrid.enabled = true
		UIFriend.Controls.ListGrid:Reposition()
		UIFriend.Controls.ListPanel.transform:GetComponent("UIWrap"):SetData(_Info.Len , "UIFriend")
		this:SetSpringAfterInfo(_Info.Len)
	end
	local index = _Info.Index
	
	UIFriend.GodList[index] = _God
	this:ShowPlayerItemInfo(_God , index)
end

--显示单个玩家的信息
function UIFriend:ShowPlayerItemInfo(_God , _Index)
	local _Data = nil
	if UIFriend.ClickTagIndex == 2 then
		_Data = UIFriend.RecommendList[_Index]
	end
	if UIFriend.ClickTagIndex == 1 then
		_Data = UIFriend.FriendDataList[_Index]
	end
	if UIFriend.ClickTagIndex == 3 then
		_Data = UIFriend.BlackDataList[_Index]
	end
	if UIFriend.ClickTagIndex == 4 then
		_Data = UIFriend.ApplyDataList[_Index]
	end
	
	if _Data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local chatBtn = _God.transform:FindChild("Chat")
	local deleteBtn = _God.transform:FindChild("Delete")
	local AddBtn = _God.transform:FindChild("Add")
	local AgreeBtn = _God.transform:FindChild("Agree")
	local RefuseBtn = _God.transform:FindChild("Refuse")
	local camp = _God.transform:FindChild("FriendContent/Contory"):GetComponent("UILabel")
	local name = _God.transform:FindChild("FriendContent/Name"):GetComponent("UILabel")
	local vip = _God.transform:FindChild("vip"):GetComponent("UILabel")
	local lvl =  _God.transform:FindChild("HeroHead/Lvl"):GetComponent("UILabel")
	local hasSend = _God.transform:FindChild("hasAdd")
	local CancelBtn = _God.transform:FindChild("Cancel")

	lvl.text = tostring(_Data.lvl)
	vip.text = "V" .. tostring(_Data.VipLvl)
	name.text = _Data.name
	
	if UIFriend.ClickTagIndex == 2 then	--推荐好友
		GameMain.CloseObj(chatBtn)
		GameMain.OpenObj(AddBtn)
		GameMain.CloseObj(deleteBtn)
		GameMain.CloseObj(AgreeBtn)
		GameMain.CloseObj(RefuseBtn)
		GameMain.CloseObj(CancelBtn)
		
		if FriendSys.HasSendStrsList[tostring(_Data.Dbid)] == nil then
			GameMain.CloseObj(hasSend)
			GameMain.OpenObj(AddBtn)
		else
			
			GameMain.OpenObj(hasSend)
			GameMain.CloseObj(AddBtn)
		end
	end

	if UIFriend.ClickTagIndex == 1 then		--我的好友
		GameMain.OpenObj(chatBtn)
		GameMain.CloseObj(AddBtn)
		GameMain.OpenObj(deleteBtn)
		GameMain.CloseObj(AgreeBtn)
		GameMain.CloseObj(RefuseBtn)
		GameMain.CloseObj(CancelBtn)
		GameMain.CloseObj(hasSend)
	end
	
	if UIFriend.ClickTagIndex == 3 then
		GameMain.CloseObj(chatBtn)
		GameMain.CloseObj(AddBtn)
		GameMain.CloseObj(deleteBtn)
		GameMain.CloseObj(AgreeBtn)
		GameMain.CloseObj(RefuseBtn)
		GameMain.OpenObj(CancelBtn)
		GameMain.CloseObj(hasSend)
	end
	
	if UIFriend.ClickTagIndex == 4 then
		GameMain.CloseObj(chatBtn)
		GameMain.CloseObj(AddBtn)
		GameMain.CloseObj(deleteBtn)
		GameMain.OpenObj(AgreeBtn)
		GameMain.OpenObj(RefuseBtn)
		GameMain.CloseObj(CancelBtn)
		GameMain.CloseObj(hasSend)
	end
	if _Data.Camp == 0 then
		GameMain.CloseObj(camp.gameObject)
	end
	if _Data.Camp == 1 then
		GameMain.OpenObj(camp.gameObject)
		camp.text = "蜀"
	end
	if _Data.Camp == 2 then
		GameMain.OpenObj(camp.gameObject)
		camp.text = "魏"
	end
	if _Data.Camp == 3 then
		GameMain.OpenObj(camp.gameObject)
		camp.text = "吴"
	end

	if _Data.CommanderId~=0 then
		local role = RoleDataConfig.GetRoleById(_Data.CommanderId)
		if role~=nil then
			local info = _God.transform:FindChild("HeroHead")
			local FG = info.transform:FindChild("FG"):GetComponent("UISprite")
			local img = info.transform:FindChild("IMG"):GetComponent("UISprite")
			FG.spriteName = UIstring.ItemFg[role.Quality]
			AtlasMsg.SetAtlas(img , role.AtlasName , role.SpriteName)
		end
	end


end

function UIFriend:UpdateItem(_LuaName , _Item) 
	local index = tonumber(_Item.name)
	UIFriend.GodList[index] = _Item 
	this:ShowPlayerItemInfo(_Item ,index)

end
--弹框
function UIFriend:ShowPopPanel(Index)
	GameMain.OpenObj(UIFriend.PopPanel)
	if UIFriend.PopControls.HeroName == nil then
		this:GetPopPanelControls()
	end
	
	this:ShowPopInfo(Index)
end

function UIFriend:ClosePopPanel()
	GameMain.CloseObj(UIFriend.PopPanel)
end

function UIFriend.GetPopPanelControls()
	local info = UIFriend.PopPanel.transform:FindChild("HeroInfo")
	UIFriend.PopControls.HeroName = info.transform:FindChild("name"):GetComponent("UILabel")
	UIFriend.PopControls.HeroCamp = info.transform:FindChild("Contory"):GetComponent("UILabel")
	UIFriend.PopControls.HeroVipLvl = info.transform:FindChild("vip"):GetComponent("UILabel")
	UIFriend.PopControls.HeroLvl = info.transform:FindChild("Lvl"):GetComponent("UILabel")
	UIFriend.PopControls.HeroImg = info.transform:FindChild("IMG"):GetComponent("UISprite")
	UIFriend.PopControls.HeroFg = info.transform:FindChild("FG"):GetComponent("UISprite")
end

function UIFriend:ShowPopInfo(Index)
	UIFriend.CurClickIndex = Index
	local data = nil
	if UIFriend.ClickTagIndex == 2 then
		data = UIFriend.RecommendList[Index]
	end
	if UIFriend.ClickTagIndex == 4 then
		data = UIFriend.ApplyDataList[Index]
	end
	UIFriend.PopControls.HeroName.text = data.name
	UIFriend.PopControls.HeroLvl.text = "Lv." .. data.lvl
	UIFriend.PopControls.HeroVipLvl.text = "V" .. data.VipLvl
	if data.CommanderId~=0 then
		local role = RoleDataConfig.GetRoleById(data.CommanderId)
		if role~=nil then
			AtlasMsg.SetAtlas(UIFriend.PopControls.HeroImg , role.AtlasName , role.SpriteName)
			UIFriend.PopControls.HeroFg.spriteName = UIstring.ItemFg[role.Quality]
		end
	end
	 
	if data.Camp == 0 then
		GameMain.CloseObj(UIFriend.PopControls.HeroCamp)
	end
	if data.Camp == 1 then
		GameMain.OpenObj(UIFriend.PopControls.HeroCamp)
		UIFriend.PopControls.HeroCamp.text = "[蜀]"
	end
	if data.Camp == 2 then
		GameMain.OpenObj(UIFriend.PopControls.HeroCamp)
		UIFriend.PopControls.HeroCamp.text = "[魏]"
	end
	if data.Camp == 3 then
		GameMain.OpenObj(UIFriend.PopControls.HeroCamp)
		UIFriend.PopControls.HeroCamp.text = "[吴]"
	end 
	
end
--加好友
function UIFriend:AddSearchFriend()
	local id = tostring(UIFriend.SearchPlayerData.Dbid)
	if FriendSys.HasSendStrsList[id] ~= nil then
		DataUIInstance.PopTip("已经向该好友发送请求")
		return
	end
	if FriendSys.FriendDataDic[id] ~= nil then
		DataUIInstance.PopTip("对方已是好友")
		return
	end
	if FriendSys.BlackFriendDic[id] ~= nil then
		DataUIInstance.PopTip("对方已被你加入黑名单")
		return
	end
	
	local hasAdd = UIFriend.Controls.FriendItem.transform:FindChild("hasAdd")
	FriendSys.RequestFriend(id)
	GameMain.OpenObj(hasAdd)
	GameMain.CloseObj(UIFriend.Controls.FriendItem.transform:FindChild("Add"))
end

function UIFriend:SendWebAddFriend(Index)
	
	local data = UIFriend.RecommendList[Index]	
	
	if FriendSys.HasSendStrsList[tostring(data.Dbid)] ~= nil then
		DataUIInstance.PopTip("已经向该好友发送请求")
		return
	end
	local god = UIFriend.GodList[Index]
	local hasAdd = god.transform:FindChild("hasAdd")
	data:AddFriend()
	GameMain.OpenObj(hasAdd)
	GameMain.CloseObj(god.transform:FindChild("Add"))
end

function UIFriend:SendWebCancelBlack(Index)
	local data = UIFriend.BlackDataList[Index]
	UIFriend.BlackCount = UIFriend.BlackCount -1
	UIFriend.Controls.BlackFriendCount.text = "已屏蔽" .. UIFriend.BlackCount .."/100"
	DataUIInstance.PopTip("玩家" .. data.name .. "已经取消屏蔽")
	FriendSys.RemoveBlackFriend(data.Dbid)
	table.remove(UIFriend.BlackDataList , Index)
	this:ShowListInfo(UIFriend.BlackDataList)
	
end

function UIFriend:SendWebBlackFriend(Index)
	local data = UIFriend.RecommendList[Index]
--	local god = UIFriend.GodList[Index]
	DataUIInstance.PopTip("玩家" .. data.name .."已被屏蔽")
	FriendSys.AddBlackFriend(data.Dbid)
	table.remove(UIFriend.RecommendList , Index)
	this:ShowListInfo(UIFriend.RecommendList)
end

function UIFriend:ClosePopPanel()
	GameMain.CloseObj(UIFriend.PopPanel)
end

function UIFriend:ClosePanel()
   GameMain.CloseObj(UIFriend.UIFriendGob)
end

function UIFriend:ReleasPanel()
	--UI
	UIFriend.UIFriendGob = nil
	UIFriend.Controls = {}
	UIFriend.TagBtns = {}
	UIFriend.PopPanel = nil
	UIFriend.PopControls = {}
	UIFriend.GodList = {}		

	UIFriend.SearchPanel = nil	--查找界面
	--Data
	UIFriend.ClickTagIndex = 0	--当前所在的界面
	UIFriend.DataList = {}
	UIFriend.RecommendList = {}	--推荐的好友
	UIFriend.FriendDataList = {}	--好友数据
	UIFriend.ApplyDataList = {}		--申请的数据
	UIFriend.BlackDataList = {}		--黑名单

	UIFriend.CurClickIndex = 0	--当前点击的那个请求的好友

	UIFriend.FriendCount = 0	--好友数量
	UIFriend.BlackCount = 0		--黑名单数量
	UIFriend.SearchPlayerData = nil	--查找的玩家信息
end 

function UIFriend:ReleasData()
	FriendSys.RecommendDataList = {}	--推荐好友的数据
	FriendSys.FriendDataDic = {}		--我拥有的好友
	FriendSys.BlackFriendDic = {}		--黑名单
	FriendSys.RequireDataDic = {}		--向我申请的好友
	FriendSys.HasSendStrsList = {}		--已经申请的好友list

end

return UIFriend