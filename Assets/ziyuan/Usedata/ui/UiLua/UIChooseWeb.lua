--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIChooseWeb = {}
UIChooseWeb = BasePanel:new()
local this = UIChooseWeb
--UI相关
UIChooseWeb.UIChooseWebGod = nil

UIChooseWeb.WebListPanel = nil
UIChooseWeb.EnterPanel = nil
UIChooseWeb.BoardPanel = nil

UIChooseWeb.WebControls = {}
UIChooseWeb.EnterControls = {}
UIChooseWeb.BoardControls = {}

UIChooseWeb.BoardGodList = {}
UIChooseWeb.WebArenGodList = {}
UIChooseWeb.WebItemGodList = {}

--Data相关
UIChooseWeb.BoardDataList = {}
UIChooseWeb.WebDataList = {}
UIChooseWeb.WebAreanDataList = {}
UIChooseWeb.ClickWebIndex = 0	--点击的网络index
UIChooseWeb.ClickBoardIndex = 0	--点击的公告index

UIChooseWeb.CanEnterGame = false

function UIChooseWeb:OpenUI(_PanelName , _LuaName)
	UIChooseWeb.CanEnterGame = false
	if UIChooseWeb.UIChooseWebGod == nil then
		UIChooseWeb.UIChooseWebGod = MainGameUI.FindPanel("UIChooseWeb")
		UIChooseWeb.WebListPanel = UIChooseWeb.UIChooseWebGod.transform:FindChild("WebLists")
		UIChooseWeb.EnterPanel = UIChooseWeb.UIChooseWebGod.transform:FindChild("UIEnter")
		UIChooseWeb.BoardPanel = UIChooseWeb.UIChooseWebGod.transform:FindChild("Board")
	end
	GameMain.OpenObj(UIChooseWeb.UIChooseWebGod)
	LoginData.GetBroad()
	this:ShowInitInfo()
	MusicManagerSys.LoginMusic()
end

function UIChooseWeb:ShowInitInfo()
	if UIChooseWeb.EnterControls.ChooseWeb == nil then
		this:GetEnterControls()
	end
	local list = LoginData.GetLoginWebInfo()
	if list.Server_id ~= 0 then
		GameMain.OpenObj(UIChooseWeb.EnterControls.ChooseWebState)
		UIChooseWeb.EnterControls.ChooseWeb.text = list.Name .. "（点击换区）"
		UIChooseWeb.EnterControls.ChooseWebState.spriteName = UIstring.WebState[list.State]
	else
		UIChooseWeb.EnterControls.ChooseWeb.text = "（点击换区）"
		GameMain.CloseObj(UIChooseWeb.EnterControls.ChooseWebState)
	end
end

function UIChooseWeb:GetWebControls()
	UIChooseWeb.WebControls.CurWebInfo = UIChooseWeb.WebListPanel.transform:FindChild("info"):GetComponent("UILabel")
	UIChooseWeb.WebControls.RecommendWebInfo = UIChooseWeb.WebListPanel.transform:FindChild("RecommedWeb/Label"):GetComponent("UILabel")
	UIChooseWeb.WebControls.WebRegionUIWrap = UIChooseWeb.WebListPanel.transform:FindChild("WebRegionLists"):GetComponent("UIWrap")
	UIChooseWeb.WebControls.WebRegionGrid = UIChooseWeb.WebControls.WebRegionUIWrap.transform:FindChild("RegionGrid"):GetComponent("UIGrid")
	UIChooseWeb.WebControls.WebItemUIWrap = UIChooseWeb.WebListPanel.transform:FindChild("WebItemLists"):GetComponent("UIWrap")
	UIChooseWeb.WebControls.WebItemGrid = UIChooseWeb.WebControls.WebItemUIWrap.transform:FindChild("WebItemGrid"):GetComponent("UIGrid")
	
end

function UIChooseWeb:GetEnterControls()
	UIChooseWeb.EnterControls.ChooseWeb = UIChooseWeb.EnterPanel.transform:FindChild("WebName/Label"):GetComponent("UILabel")
	UIChooseWeb.EnterControls.ChooseWebState = UIChooseWeb.EnterPanel.transform:FindChild("state"):GetComponent("UISprite")
end

function UIChooseWeb:GetBoardControls()
	UIChooseWeb.BoardControls.UIWrap = UIChooseWeb.BoardPanel.transform:FindChild("BoradLists"):GetComponent("UIWrap")
	UIChooseWeb.BoardControls.Grid = UIChooseWeb.BoardControls.UIWrap.transform:FindChild("BoardGrid"):GetComponent("UIGrid")
	
	UIChooseWeb.BoardControls.Content = UIChooseWeb.BoardPanel.transform:FindChild("boardInfo/Info"):GetComponent("UILabel")
	UIChooseWeb.BoardControls.Title = UIChooseWeb.BoardPanel.transform:FindChild("info"):GetComponent("UILabel")
end

function UIChooseWeb:SetBroad()
	UIChooseWeb.CanEnterGame = true
	GameMain.CloseObj(UIChooseWeb.WebListPanel)
	GameMain.OpenObj(UIChooseWeb.BoardPanel)
	if UIChooseWeb.BoardControls.Content == nil then
		this:GetBoardControls()
	end
	this:SetBoardData()
	this:ShowBoardList()
end

function UIChooseWeb:SetBoardData()
	UIChooseWeb.BoardDataList = {}
	for key,value in pairs(LoginData.BroadText) do
		table.insert(UIChooseWeb.BoardDataList , #UIChooseWeb.BoardDataList +1 , value)
	end
end

function UIChooseWeb:ShowBoardList()
	UIChooseWeb.BoardControls.UIWrap.transform.localPosition = Vector3(0,0,0)
	UIChooseWeb.BoardControls.UIWrap.transform:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIChooseWeb.BoardControls.UIWrap:ResetTrans(#UIChooseWeb.BoardDataList)
	
	for i=1,6,1  do
		local data = 
		{
			Index =i,
		}
		if UIChooseWeb.BoardGodList[i] ~=nil then
			this:CreateBoardListCallBack(UIChooseWeb.BoardGodList[i],data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "BoardItem" , UIChooseWeb.BoardControls.Grid , data , this.CreateBoardListCallBack , "UIChooseWeb") 
		end
	end
	
end

function UIChooseWeb:CreateBoardListCallBack(_Gob , _Info)
	if _Info.Index==6   then
		UIChooseWeb.BoardControls.Grid.enabled = true
		UIChooseWeb.BoardControls.Grid:Reposition()
		UIChooseWeb.BoardControls.UIWrap:SetData(#UIChooseWeb.BoardDataList , "UIChooseWeb")
		this:ShowBoardClickInfo(1)
        UIChooseWeb.BoardPanel.transform:FindChild("BoardLoaing").gameObject:SetActive(false)
	end
	this:ShowBoardItem(_Info.Index , _Gob)
end

function UIChooseWeb:ShowBoardClickInfo(_Index)
	if UIChooseWeb.ClickBoardIndex ~= 0 then
		local click = UIChooseWeb.BoardGodList[UIChooseWeb.ClickBoardIndex].transform:FindChild("choose")
		GameMain.CloseObj(click)
	end
	UIChooseWeb.ClickBoardIndex = _Index
	local godClick = UIChooseWeb.BoardGodList[UIChooseWeb.ClickBoardIndex].transform:FindChild("choose")
	GameMain.OpenObj(godClick)
	local data = UIChooseWeb.BoardDataList[_Index]
	if data ~= nil then
		UIChooseWeb.BoardControls.Content.text = data.Content
		UIChooseWeb.BoardControls.Title.text = data.Title
	end
end

function UIChooseWeb:ShowBoardItem(_Index , _God)
	UIChooseWeb.BoardGodList[_Index] = _God
	local data = UIChooseWeb.BoardDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local title = _God.transform:FindChild("name"):GetComponent("UILabel")
	title.text = data.Title
end

function UIChooseWeb:UpdateItem(_LuaName , _Item) 
	local parent = _Item.transform.parent
	if parent.name == "BoardGrid" then
		local index = tonumber(_Item.name)
		this:ShowBoardItem(index , _Item)
	end
	if parent.name == "RegionGrid" then
		local index = tonumber(_Item.name)
		this:ShowAreanItem(index, _Item)
	end
	if parent.name == "WebItemGrid" then
		local index = tonumber(_Item.name)
		this:ShowWebItemInfo(index , _Item)
	end
end

function UIChooseWeb:ShowWebInfo()
	if UIChooseWeb.CanEnterGame == false then
		return
	end
--	LoginData.GetServerList()
	this:ShowWeb()
end

function UIChooseWeb:ShowWeb()
	if UIChooseWeb.WebControls.CurWebInfo == nil then
		this:GetWebControls()
	end
	local webList = LoginData.GetLoginWebInfo()
	if webList.Server_id ~= 0 then
		
		UIChooseWeb.WebControls.CurWebInfo.text = "当前服务器     " .. webList.Name
		GameMain.OpenObj(UIChooseWeb.WebControls.CurWebInfo)
	else
		GameMain.CloseObj(UIChooseWeb.WebControls.CurWebInfo)
	end
	
	this:SetWebData()
	GameMain.OpenObj(UIChooseWeb.WebListPanel)
	this:ShowWebArenList()
end

function UIChooseWeb:SetWebData()
	local lists = LoginData.ServerList

	UIChooseWeb.WebAreanDataList = {}
	local len = math.ceil(#lists/100)
	for j=len ,1,1  do
		local start = (j-1)*100+1
		local endArean = start+99
		local webList = {}
		for i=start,100,1  do
			if LoginData.ServerList[i] ~= nil then
				table.insert(webList , #webList +1 , LoginData.ServerList[i])
			end
		end
		
		local data = 
		{
			Name = start.. "~" .. endArean .. "区" ,
			List = webList,
		}
		table.insert(UIChooseWeb.WebAreanDataList , #UIChooseWeb.WebAreanDataList + 1 , data)
	end
	
end

function UIChooseWeb:ShowWebArenList()
	UIChooseWeb.WebControls.WebRegionUIWrap.transform:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIChooseWeb.WebControls.WebRegionUIWrap.transform.localPosition = Vector3(0,0,0)
	UIChooseWeb.WebControls.WebItemUIWrap:ResetTrans(#UIChooseWeb.WebAreanDataList)

	for i=1,8,1  do
		local data = 
		{
			Index = i,
		}
		if UIChooseWeb.WebArenGodList[i] ~=nil then
			this:CreateAreanWebListCallBack(UIChooseWeb.WebArenGodList[i],data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "ChooseAreanWebItem" , UIChooseWeb.WebControls.WebRegionGrid , data , this.CreateAreanWebListCallBack , "UIChooseWeb") 
		end
	end
	
end

function UIChooseWeb:CreateAreanWebListCallBack(_God , _Info)
	local index = _Info.Index
	if index == 8 then
		UIChooseWeb.WebControls.WebRegionGrid.enabled = true
		UIChooseWeb.WebControls.WebItemGrid:Reposition()
		UIChooseWeb.WebControls.WebRegionUIWrap:SetData(#UIChooseWeb.WebAreanDataList , "UIChooseWeb")
		this:ShowClickWebAreanInfo(1)
	end
	this:ShowAreanItem(index , _God)
end

function UIChooseWeb:ShowClickWebAreanInfo(_Index)
	if UIChooseWeb.ClickWebIndex ~= 0 then
		local click = UIChooseWeb.WebArenGodList[UIChooseWeb.ClickWebIndex].transform:FindChild("choose")
		GameMain.CloseObj(click)
	end
	UIChooseWeb.ClickWebIndex = _Index
	local clickobj = UIChooseWeb.WebArenGodList[UIChooseWeb.ClickWebIndex].transform:FindChild("choose")
	GameMain.OpenObj(clickobj)
	local data = UIChooseWeb.WebAreanDataList[_Index]
	if data ~= nil then
		UIChooseWeb.WebDataList = {}
		UIChooseWeb.WebDataList = data.List
		this:ShowWebItemList()
	end

end

function UIChooseWeb:ShowWebItemList()
	UIChooseWeb.WebControls.WebItemUIWrap.transform:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UIChooseWeb.WebControls.WebItemUIWrap.transform.localPosition = Vector3(0,0,0)
	UIChooseWeb.WebControls.WebItemUIWrap:ResetTrans(#UIChooseWeb.WebDataList)
	
	for i=1,12,1 do
		local data = 
		{
			Index = i,
		}
		if UIChooseWeb.WebItemGodList[i] ~= nil then
			this:CreateWebItemListCallBack(UIChooseWeb.WebItemGodList[i],data)
		else
			MainGameUI.CreateLittleItem(tostring(i) , "WebItem" , UIChooseWeb.WebControls.WebItemGrid , data , this.CreateWebItemListCallBack , "UIChooseWeb") 
		end
	end
end


function UIChooseWeb:CreateWebItemListCallBack(_God , _Info)
	local index = _Info.Index
	if index == 12 then
		UIChooseWeb.WebControls.WebItemGrid.enabled = true
		UIChooseWeb.WebControls.WebItemGrid:Reposition()
		UIChooseWeb.WebControls.WebItemUIWrap:SetData(#UIChooseWeb.WebDataList , "UIChooseWeb")
	end
	this:ShowWebItemInfo(index , _God)
end

function UIChooseWeb:ShowWebItemInfo(_Index, _God)
	UIChooseWeb.WebItemGodList[_Index] = _God
	local data = UIChooseWeb.WebDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local name = _God.transform:FindChild("name"):GetComponent("UILabel")
	local webState = _God.transform:FindChild("state"):GetComponent("UISprite")
	name.text = data.Name
	webState.spriteName = UIstring.WebState[data.Status]
end

function UIChooseWeb:ShowAreanItem(_Index , _Gob)
	UIChooseWeb.WebArenGodList[_Index] = _Gob
	local data = UIChooseWeb.WebAreanDataList[_Index]
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	local normal = _Gob.transform:FindChild("normal")
	local click = _Gob.transform:FindChild("choose")
	local name = _Gob.transform:FindChild("Label"):GetComponent("UILabel")
	name.text = data.Name
	GameMain.OpenObj(normal)
	GameMain.CloseObj(click)
end

function UIChooseWeb:UIHand(_LuaName , _Gob)
		MusicManagerSys.ButtonClick()
	if _Gob.name == "EnterGameBtn" then
		--this:ClosePanel()
       --LoginData.Guest()
		this:ToEnterGame()
	end
	if _Gob.name == "closeWebBtn" then
		this:CloseWebListPanel()
	end
	if _Gob.name == "ConfirmBoardBtn" then
		this:CloseBoardPanel()
	end
	if _Gob.name == "closeBoardBtn" then
		this:CloseBoardPanel()
	end

	if _Gob.name == "WebName" then
		this:ShowWebInfo()
	end
	
	local parentName = _Gob.transform.parent.name
	if parentName == "BoardGrid" then
		local index = tonumber(_Gob.name)
		if index ~= nil then
			this:ShowBoardClickInfo(index)
		end
	end
	if parentName == "WebItemGrid" then
		local index = tonumber(_Gob.name)
		if index ~= nil then
			this:ShowWebItemClickInfo(index)
		end
	end
	if parentName == "RegionGrid" then
		local index = tonumber(_Gob.name)
		if index ~= nil then
			this:ShowClickWebAreanInfo(index)
		end
	end
end

function UIChooseWeb:ToEnterGame()
	if UIChooseWeb.CanEnterGame == false then
		return
	end
	local webList = LoginData.GetLoginWebInfo()
	if webList.Server_id == 0 then
		DataUIInstance.PopTip("请选择服务器")
		return
	end
	DataUIInstance.CreateLogin()
end


function UIChooseWeb:ShowWebItemClickInfo(_Index)
	if UIChooseWeb.EnterControls.ChooseWeb == nil then
		this:GetEnterControls()
	end
	local data = UIChooseWeb.WebDataList[_Index]
	UIChooseWeb.EnterControls.ChooseWeb.text = data.Name .. "（点击换区）"
	LoginData.SetChooseWebInfo(data.Name , data.Server_id , data.Url , data.Status)
	GameMain.OpenObj(UIChooseWeb.EnterControls.ChooseWebState)
	UIChooseWeb.EnterControls.ChooseWebState.spriteName = UIstring.WebState[data.Status]
	this:CloseWebListPanel()
end

function UIChooseWeb:CloseBoardPanel()
	GameMain.CloseObj(UIChooseWeb.BoardPanel)
	LoginData.GetServerList() 
end

function UIChooseWeb:GetServerListCallBack()
	local list = LoginData.GetLoginWebInfo()
	if list.Server_id ~= 0 then
		GameMain.OpenObj(UIChooseWeb.EnterControls.ChooseWebState)
		UIChooseWeb.EnterControls.ChooseWeb.text = list.Name .. "（点击换区）"
		UIChooseWeb.EnterControls.ChooseWebState.spriteName = UIstring.WebState[list.State]
	else
		UIChooseWeb.EnterControls.ChooseWeb.text = "（点击换区）"
		GameMain.CloseObj(UIChooseWeb.EnterControls.ChooseWebState)
	end
end

function UIChooseWeb:CloseWebListPanel()
	GameMain.CloseObj(UIChooseWeb.WebListPanel)
end

function UIChooseWeb:ClosePanel()
	GameMain.CloseObj(UIChooseWeb.UIChooseWebGod)
end

function UIChooseWeb:ReleasPanel()
	--UI相关
	UIChooseWeb.UIChooseWebGod = nil

	UIChooseWeb.WebListPanel = nil
	UIChooseWeb.EnterPanel = nil
	UIChooseWeb.BoardPanel = nil

	UIChooseWeb.WebControls = {}
	UIChooseWeb.EnterControls = {}
	UIChooseWeb.BoardControls = {}

	UIChooseWeb.BoardGodList = {}
	UIChooseWeb.WebArenGodList = {}
	UIChooseWeb.WebItemGodList = {}

	--Data相关
	UIChooseWeb.BoardDataList = {}
	UIChooseWeb.WebDataList = {}
	UIChooseWeb.WebAreanDataList = {}
	UIChooseWeb.ClickWebIndex = 0	--点击的网络index
	UIChooseWeb.ClickBoardIndex = 0	--点击的公告index
	UIChooseWeb.CanEnterGame = false
end

function UIChooseWeb:ReleasData()
	LoginData.LoginURL = ""
	LoginData.LoginServerId = 0
	LoginData.ServerList = {}
end

return UIChooseWeb
--endregion
