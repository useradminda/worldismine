--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIRwdPop = {}
UIRwdPop = BasePanel:new()
local this = UIRwdPop

--UI
UIRwdPop.UIRwdPopGod = nil
UIRwdPop.Controls = {}
UIRwdPop.RwdGodList = {}

--Data
UIRwdPop.RwdType = 0	--弹框类型 1 获得奖励	2选择奖励 3 随机
UIRwdPop.RwdDataList = {}	
UIRwdPop.ClickIndex = 0	--点击选择的那个item
UIRwdPop.GiftData = nil	--操作的礼包
UIRwdPop.UseCount = 0
--event


function UIRwdPop:OpenUI(_PanelName , _LuaName , _Data)
	if UIRwdPop.UIRwdPopGod == nil then
		UIRwdPop.UIRwdPopGod = MainGameUI.FindPanel("UIRwdPop")
	end
	UIRwdPop.UseCount = _Data.Count
	UIRwdPop.GiftData = _Data.Data
	UIRwdPop.RwdType = _Data.Type
	this:ClearInitGodList()
	this:ShowInitInfo()
	
end

function UIRwdPop:ShowInitInfo()
	UIRwdPop.RwdDataList = {}	
	
	for i=1,#UIRwdPop.GiftData.TargetList,1 do
		local rewardData = RewardConfig.GetRewardConfig(tonumber(UIRwdPop.GiftData.TargetList[i]))
			
		local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
		UIRwdPop.RwdDataList[i] = jsonItems.Items[1]
	end

	if UIRwdPop.GiftData.Type == 1 then	--选择
		this:PopChoosePanel()
	else					--显示
		this:PopRwdPanel()
	end
end

function UIRwdPop:GetControls()
	UIRwdPop.Controls.RwdTitle = UIRwdPop.UIRwdPopGod.transform:FindChild("Title/own")
	UIRwdPop.Controls.ChooseTitle = UIRwdPop.UIRwdPopGod.transform:FindChild("Title/choose")
	UIRwdPop.Controls.RwdBtn = UIRwdPop.UIRwdPopGod.transform:FindChild("RecivedBtn")

	UIRwdPop.Controls.RwdList = UIRwdPop.UIRwdPopGod.transform:FindChild("List/RwdList")
	UIRwdPop.Controls.Grid = UIRwdPop.Controls.RwdList.transform:FindChild("Grid"):GetComponent("UIGrid")
end

function UIRwdPop:PopChoosePanel()		--弹选择奖励的panel 
	if UIRwdPop.Controls.RwdTitle == nil then
		this:GetControls()
	end
	UIRwdPop.ClickIndex = 0
	GameMain.CloseObj(UIRwdPop.Controls.RwdTitle)
	GameMain.OpenObj(UIRwdPop.Controls.ChooseTitle)
	GameMain.OpenObj(UIRwdPop.Controls.RwdBtn)
	this:ClearGodList()
	this:ShowList()
end

function UIRwdPop:PopRwdPanel()			--弹奖励panel
	if UIRwdPop.Controls.RwdTitle == nil then
		this:GetControls()
	end
	
	GameMain.OpenObj(UIRwdPop.Controls.RwdTitle)
	GameMain.CloseObj(UIRwdPop.Controls.ChooseTitle)
	GameMain.CloseObj(UIRwdPop.Controls.RwdBtn)
	this:ClearGodList()
	this:ShowList()
end
--初始化界面时清理一下
function UIRwdPop:ClearInitGodList()
	if #UIRwdPop.RwdGodList>0 then
		for key,value in pairs(UIRwdPop.RwdGodList) do
			GameMain.CloseObj(value)
		end
	end
end

--清理一下界面
function UIRwdPop:ClearGodList()
	if #UIRwdPop.RwdGodList>0 then
		for key,value in pairs(UIRwdPop.RwdGodList) do
			GameMain.CloseObj(value.transform:FindChild("click"))
		end
	end
	
	
end

function UIRwdPop:ShowList()

	for i=1,#UIRwdPop.RwdDataList,1  do
		local data = 
		{
			Index = i,
			Len = #UIRwdPop.RwdDataList,
		}
		if UIRwdPop.RwdGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "RwdItem" , UIRwdPop.Controls.Grid , data , this.CreateListCallBack , "UIRwdPop") 
		else
			this:CreateListCallBack(UIRwdPop.RwdGodList[i],data)
		end
	end
	
end

function UIRwdPop:CreateListCallBack(_God , _Info)
	
	local index = _Info.Index
	local data = UIRwdPop.RwdDataList[index]
	UIRwdPop.RwdGodList[index] = _God
	this:ShowItemInfo(_God , data)
	if _Info.Len == index then
		UIRwdPop.Controls.Grid.enabled = true
		UIRwdPop.Controls.Grid:Reposition()
	end
	
end

function UIRwdPop:ShowItemInfo(_God , _Data)		--显示单个的item
	if _Data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	local count = _God.transform:FindChild("count"):GetComponent("UILabel")
	local img = _God.transform:FindChild("Img"):GetComponent("UISprite")
	local name = _God.transform:FindChild("Name"):GetComponent("UILabel")
	local quilityImg = _God.transform:FindChild("BG"):GetComponent("UISprite")
	if UIRwdPop.RwdType~=3 then
		count.text = tostring(_Data.Count*UIRwdPop.UseCount)
	end
	
	name.text = _Data.Name
	local iconList = GameMain.StringSplit(_Data.Icon , ",") 
	
	AtlasMsg.SetAtlas(img , iconList[1] , iconList[2])
	quilityImg.spriteName = UIstring.ItemFg[tonumber(_Data.Quality)]
end

function UIRwdPop:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
	
	if UIRwdPop.RwdType == 2 then
		local key = tonumber(_Gob.name)
		if key~=nil then
			this:ChooseRwdItem(key)
		end
	end
	if _Gob.name == "RecivedBtn" then
		this:SendWebToChooseItem()
	end
	
end

function UIRwdPop:SendWebToChooseItem()
	if UIRwdPop.ClickIndex ~=0 then
		local gift = (UIRwdPop.GiftData)
		
		local chooseId = tonumber(UIRwdPop.GiftData.TargetList[UIRwdPop.ClickIndex])
		GiftPackageSys.Use( gift, chooseId , 1)
		local list = {}
		list[1]= UIRwdPop.RwdDataList[UIRwdPop.ClickIndex]
		DataUIInstance.OpenRewards(list)
		GameMain.CloseObj(UIRwdPop.UIRwdPopGod)
	else
		DataUIInstance.PopTip("请选择相关的物品")
	end
end

--选择要领取的奖励
function UIRwdPop:ChooseRwdItem(index)
	if UIRwdPop.ClickIndex ~= 0 then
		GameMain.CloseObj(UIRwdPop.RwdGodList[UIRwdPop.ClickIndex].transform:FindChild("click"))
	end
	UIRwdPop.ClickIndex = index
	GameMain.OpenObj(UIRwdPop.RwdGodList[UIRwdPop.ClickIndex].transform:FindChild("click"))
end


function UIRwdPop:ClosePanel()
	GameMain.CloseObj(UIRwdPop.UIRwdPopGod)
end

function UIRwdPop:ReleasPanel()
	--UI
	UIRwdPop.UIRwdPopGod = nil
	UIRwdPop.Controls = {}
	UIRwdPop.RwdGodList = {}

	--Data
	UIRwdPop.RwdType = 0	--弹框类型 1 获得奖励	2选择奖励
	UIRwdPop.RwdDataList = {}	
	UIRwdPop.ClickIndex = 0	--点击选择的那个item
	UIRwdPop.ThingId = 0		--物品Id ，用于需要进一步进行操作的物品
    
end

return UIRwdPop
--endregion
