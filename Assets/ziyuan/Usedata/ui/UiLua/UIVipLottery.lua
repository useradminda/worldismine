--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIVipLottery = {}
UIVipLottery=BasePanel:new()
local this = UIVipLottery

--UI
UIVipLottery.UIVipLotteryGod = nil
UIVipLottery.Controls = {}

--Data
UIVipLottery.RotateAngle = 
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
UIVipLottery.DataList = {}

UIVipLottery.ChooseIndex = 0	--当前抽到的奖励
UIVipLottery.ChooseID = 0

function UIVipLottery:OpenUI(_PanelName , _LuaName , _Data)
	if UIVipLottery.UIVipLotteryGod==nil then
		UIVipLottery.UIVipLotteryGod=MainGameUI.FindPanel("UIVipLottery")
		this:GetControls()
		
	end
	local list = VipBuyDiscConfig.GetAllListById(_Data.UseId)
	this:ShowList(list)
	UIVipLottery.ChooseID = _Data.UseId
end

function UIVipLottery:GetControls()
	local list = UIVipLottery.UIVipLotteryGod.transform:FindChild("Lists")
	UIVipLottery.Controls.GodList = {}
	for i=1,12,1 do
		UIVipLottery.Controls.GodList[i] = list.transform:FindChild(tostring(i))
	end	

	UIVipLottery.Controls.RotateImg = UIVipLottery.UIVipLotteryGod.transform:FindChild("jiantou")
	UIVipLottery.Controls.TweenRotate = UIVipLottery.Controls.RotateImg.transform:GetComponent("TweenRotation")
end

function UIVipLottery:ShowList(_List)

	for i=1,#_List,1 do
		local rewardData = RoleDataConfig.GetRoleById(tonumber( _List[i]))
		UIVipLottery.DataList[i] = rewardData
	end
	
	for j=1,#UIVipLottery.DataList ,1 do
		this:ShowItem(j)
	end
	
end

function UIVipLottery:ShowItem(_Index)
	local data = UIVipLottery.DataList[_Index]
	local god = UIVipLottery.Controls.GodList[_Index]
	if data == nil then
		GameMain.CloseObj(god)
		return
	end
	GameMain.OpenObj(god)
	local img = god.transform:FindChild("IMG"):GetComponent("UISprite")
	local quality = god.transform:FindChild("FG"):GetComponent("UISprite")
	local fg = god.transform:FindChild("bgFg"):GetComponent("UISprite")
	AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
	quality.spriteName = UIstring.ItemFg[data.Quality]
	fg.spriteName = UIstring.ItemFg[data.Quality] 
end


function UIVipLottery:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseHireRotate" then
		this:ClosePanel()
	end
	if _Gob.name == "RotateChooseBtn" then
		this:ToChooseGift()
	end
end

function UIVipLottery:ToChooseGift()
	VipSys.Lottery(UIVipLottery.ChooseID)
end

function UIVipLottery:ToChooseGiftCallBack(_ID)
	local UIVipTar = MainGameUI.FindPanelTarget("UIVip")
	if UIVipTar ~= nil then
		UIVipTar:ShowUseLotteryInfo()
	end
	UIVipLottery.ChooseIndex = 0
	local index = this:GetIndexById(tonumber( _ID))
	if index ~=nil then
		UIVipLottery.ChooseIndex = index
		local curRotate = UIVipLottery.Controls.RotateImg.transform.localEulerAngles
		UIVipLottery.Controls.TweenRotate.from = curRotate 
		UIVipLottery.Controls.TweenRotate.to = Vector3(0,0,-1080+UIVipLottery.RotateAngle[index])
		UIVipLottery.Controls.TweenRotate.enabled = true
		UIVipLottery.Controls.TweenRotate:ResetToBeginning()
		UIVipLottery.Controls.TweenRotate:Play()
		
		local rotateTime = UIVipLottery.Controls.TweenRotate.duration + 0.3
		local time = TimeControl.GetTime("VipBuyRotate")
		if time == nil then
			time = TimeControl.LoginTime(rotateTime,"VipBuyRotate")
		else
			TimeControl.SetTime("VipBuyRotate", rotateTime)
		end
		GameMain.AddUpdateLua(this.UpdateRoateTime)
	end
end

function UIVipLottery:UpdateRoateTime()
	local time = TimeControl.GetTime("VipBuyRotate")
	if time<=0 then
		this:ShowPopRwd(UIVipLottery.ChooseIndex)
		GameMain.DelUpdateLua(this.UpdateRoateTime)
	end
end

function UIVipLottery:ShowPopRwd(_Index)
	local list = 
	{
		[1] = UIVipLottery.DataList[_Index]
	}
	list[1].Count = 1
	DataUIInstance.OpenRewards(list)
	this:ClosePanel()
end

function UIVipLottery:GetIndexById(_ID)
	for key,value in pairs(UIVipLottery.DataList) do
		if value.Id == _ID then
			return key
		end
	end
	return nil
end

function UIVipLottery:ClosePanel()
	GameMain.CloseObj(UIVipLottery.UIVipLotteryGod)
end

function UIVipLottery:ReleasPanel()
	--UI
	UIVipLottery.UIVipLotteryGod = nil
	UIVipLottery.Controls = {}

	--Data
	UIVipLottery.RotateAngle = 
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
	UIVipLottery.DataList = {}

	UIVipLottery.ChooseIndex = 0	--当前抽到的奖励

	GameMain.DelUpdateLua(this.UpdateRoateTime)
end

return UIVipLottery
--endregion
