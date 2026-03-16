--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIConsumpGift = {}
UIConsumpGift=BasePanel:new()
local this = UIConsumpGift

--UI
UIConsumpGift.UIConsumpGiftGod = nil
UIConsumpGift.Controls = {}

--Data
UIConsumpGift.RotateAngle = 
{
	[1] = 120,
	[2] = 88, 
	[3] = 40,
	[4] = 16,
	[5] = -6, 
	[6] = -40,
	[7] = -60,
	[8] = -80, 
	[9] = -126,
	[10] = -150,
	[11] = -176, 
	[12] = 140,
}

UIConsumpGift.DataList = {}
UIConsumpGift.ConsumeList = {}
UIConsumpGift.lotoTicket = 0
UIConsumpGift.ChooseIndex = 0	--抽中的那个奖

function UIConsumpGift:OpenUI(_PanelName , _LuaName)
	if UIConsumpGift.UIConsumpGiftGod==nil then
		UIConsumpGift.UIConsumpGiftGod=MainGameUI.FindPanel("UIConsumpGift")
		this:GetControls()
		this:SetData()
	end
	this:ShowInfo()
end

function UIConsumpGift:SetData()
	UIConsumpGift.lotoTicket = ConsumeRaffleSys.lotoUsed
	local list = ConsumeRaffleSys.GetAllData()
	for i=1,#list,1  do
		UIConsumpGift.ConsumeList[i] = list[i]
		local rewardData = RewardConfig.GetRewardConfig(tonumber(list[i].Reward_Id))
			
		local jsonItems = RewardContentSys.GetRewardListString(rewardData.RewardString)
		
		UIConsumpGift.DataList[i] = jsonItems.Items[1]
		
	end
	
end

function  UIConsumpGift:GetControls()
	UIConsumpGift.Controls.PlusCount = UIConsumpGift.UIConsumpGiftGod.transform:FindChild("PlusCount/Label"):GetComponent("UILabel")
	UIConsumpGift.Controls.HasCost = UIConsumpGift.UIConsumpGiftGod.transform:FindChild("HasCost/Label"):GetComponent("UILabel")

	UIConsumpGift.Controls.RotateImg = UIConsumpGift.UIConsumpGiftGod.transform:FindChild("jiantou")
	UIConsumpGift.Controls.TweenRotate = UIConsumpGift.Controls.RotateImg.transform:GetComponent("TweenRotation")
	local list = UIConsumpGift.UIConsumpGiftGod.transform:FindChild("Lists")
	UIConsumpGift.Controls.GridList = {}
	for i=1,12,1 do
		UIConsumpGift.Controls.GridList[i] = list.transform:FindChild(tostring(i))
	end
	
end

function UIConsumpGift:ShowInfo()
	UIConsumpGift.Controls.HasCost.text = ConsumeRaffleSys.CostDiamoned
	UIConsumpGift.Controls.PlusCount.text =	ConsumeRaffleSys.GetCount()
	for i=1,12,1 do
		this:ShowItem(i)
	end
end

function UIConsumpGift:ShowItem(Index)
	local data = UIConsumpGift.DataList[Index]
	if data ~= nil then
		local img = UIConsumpGift.Controls.GridList[Index].transform:FindChild("IMG"):GetComponent("UISprite")
		
		AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)

		local qulity = UIConsumpGift.Controls.GridList[Index].transform:FindChild("FG"):GetComponent("UISprite")
		qulity.spriteName = UIstring.ItemFg[data.Quality]

		local bg = UIConsumpGift.Controls.GridList[Index].transform:FindChild("BG"):GetComponent("UISprite")
		bg.spriteName = UIstring.ItemFg[data.Quality]

		local count = UIConsumpGift.Controls.GridList[Index].transform:FindChild("Count"):GetComponent("UILabel")
		count.text = tostring(data.Count)
	end
end

function UIConsumpGift:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
	
	if _Gob.name == "RotateChooseBtn" then
		this:ToChooseGift()
	end

	if _Gob.name == "ToCost" then
		this:OpenRecharge()
	end
end

function UIConsumpGift:OpenRecharge()
	DataUIInstance.OpenShop()
end

function UIConsumpGift:ToChooseGift()
	local count = ConsumeRaffleSys.GetCount()
	if count<=0  then
		DataUIInstance.PopTip("次数不足")
		return
	end
	MusicManagerSys.Raffle()
	ConsumeRaffleSys.lottery()
end

function UIConsumpGift:ToChooseGiftCallBack(_ID)
	UIConsumpGift.ChooseIndex = 0
	local index = this:GetIndexById(tonumber(_ID))
	if index~=nil then
		
		UIConsumpGift.ChooseIndex = index
		local curRotate = UIConsumpGift.Controls.RotateImg.transform.localEulerAngles
		UIConsumpGift.Controls.TweenRotate.from = curRotate 
		UIConsumpGift.Controls.TweenRotate.to = Vector3(0,0,-1080+UIConsumpGift.RotateAngle[index])
		UIConsumpGift.Controls.TweenRotate.enabled = true
		UIConsumpGift.Controls.TweenRotate:ResetToBeginning()
		UIConsumpGift.Controls.TweenRotate:Play()

		UIConsumpGift.lotoTicket = ConsumeRaffleSys.lotoUsed
		UIConsumpGift.Controls.PlusCount.text =	ConsumeRaffleSys.GetCount()
		local rotateTime = UIConsumpGift.Controls.TweenRotate.duration + 0.3
		local time = TimeControl.GetTime("ConsumpRotate")
		if time == nil then
			time = TimeControl.LoginTime(rotateTime,"ConsumpRotate")
		else
			TimeControl.SetTime("ConsumpRotate", rotateTime)
		end
		GameMain.AddUpdateLua(this.UpdateRoateTime)
	end
	
end

function UIConsumpGift:UpdateRoateTime()
	local time = TimeControl.GetTime("ConsumpRotate")
	if time<=0 then
		this:ShowPopRwd(UIConsumpGift.ChooseIndex)
		GameMain.DelUpdateLua(this.UpdateRoateTime)
	end
end

function UIConsumpGift:ShowPopRwd(_Index)
	local list = 
	{
		[1] = UIConsumpGift.DataList[_Index]
	}
	DataUIInstance.OpenRewards(list)
end

function UIConsumpGift:GetIndexById(_ID)
	for key,value in pairs(UIConsumpGift.ConsumeList) do
		if value.Id == _ID then
			return key
		end
	end
	return nil	
end


function UIConsumpGift:ClosePanel()
	GameMain.CloseObj(UIConsumpGift.UIConsumpGiftGod)
end

function UIConsumpGift:ReleasPanel()
	--UI
	UIConsumpGift.UIConsumpGiftGod = nil
	UIConsumpGift.Controls = {}

	--Data
	UIConsumpGift.RotateAngle = 
	{
		[1] = 120,
		[2] = 88, 
		[3] = 40,
		[4] = 16,
		[5] = -6, 
		[6] = -40,
		[7] = -60,
		[8] = -80, 
		[9] = -126,
		[10] = -150,
		[11] = -176, 
		[12] = 140,
	}

	UIConsumpGift.DataList = {}
	UIConsumpGift.ConsumeList = {}
	UIConsumpGift.lotoTicket = 0
	UIConsumpGift.ChooseIndex = 0	--抽中的那个奖
end

function UIConsumpGift:ReleasData()
	
end


return UIConsumpGift
--endregion
