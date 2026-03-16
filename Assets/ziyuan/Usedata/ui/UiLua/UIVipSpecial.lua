--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIVipSpecial = {}
UIVipSpecial = BasePanel:new()
local this = UIVipSpecial
--UI
UIVipSpecial.UIVipSpecialGod = nil
UIVipSpecial.Controls = {}
--Data
UIVipSpecial.CurShowId = ""

UIVipSpecial.ClickBuyData = nil

function UIVipSpecial:OpenUI(_PanelName , _LuaName , _Data)
	if UIVipSpecial.UIVipSpecialGod == nil then
		UIVipSpecial.UIVipSpecialGod = MainGameUI.FindPanel("UIVipSpecial")
		this:GetControls()
	end
	this:ShowInfo(_Data)
end

function UIVipSpecial:GetControls()
	local vipInfo = UIVipSpecial.UIVipSpecialGod.transform:FindChild("VipSpecial")
	UIVipSpecial.Controls.VipLabel = vipInfo.transform:FindChild("VipIcon/vipExp"):GetComponent("UILabel")
	UIVipSpecial.Controls.DiamonedLabel = vipInfo.transform:FindChild("itemIcon/diamonedLabel"):GetComponent("UILabel")
	
	UIVipSpecial.Controls.VipLevel = UIVipSpecial.UIVipSpecialGod.transform:FindChild("VipNumber"):GetComponent("UILabel")
	UIVipSpecial.Controls.MoneyNum = UIVipSpecial.UIVipSpecialGod.transform:FindChild("MoneyNumber"):GetComponent("UILabel")
	if GameMain.IOSTest == true then
		local limit = UIVipSpecial.UIVipSpecialGod.transform:FindChild("Limit")
		GameMain.CloseObj(limit)
	end
end

function UIVipSpecial:ShowInfo(_Vip)
	UIVipSpecial.ClickBuyData = nil
	if _Vip~=0 then
		local testData = VipSpecailSys.GetDataByVipLvlTest(_Vip)
		if testData ~= nil then
			UIVipSpecial.ClickBuyData = testData
			UIVipSpecial.CurShowId = testData.AppStoreId
			local reward = RewardConfig.GetRewardConfig(testData.Reward)
	
			local jsons = RewardContentSys.GetRewardStringType(reward.RewardString)
			UIVipSpecial.Controls.VipLabel.text = tostring(jsons["vipExp"])
			UIVipSpecial.Controls.DiamonedLabel.text = tostring(jsons["diamond"])

			UIVipSpecial.Controls.VipLevel.text = "Vip" .. testData.VipLevel
			UIVipSpecial.Controls.MoneyNum.text = testData.NeedRmb .. "元"
		end
		return
	end
	local data = this:GetNeedShowData()
	UIVipSpecial.CurShowId = data.AppStoreId
	UIVipSpecial.ClickBuyData = data
	local reward = RewardConfig.GetRewardConfig(data.Reward)

	local jsons = RewardContentSys.GetRewardStringType(reward.RewardString)
	UIVipSpecial.Controls.VipLabel.text = tostring(jsons["vipExp"])
	UIVipSpecial.Controls.DiamonedLabel.text = tostring(jsons["diamond"])

	UIVipSpecial.Controls.VipLevel.text = "Vip" .. data.VipLevel
	UIVipSpecial.Controls.MoneyNum.text = data.NeedRmb .. "元"
end

function UIVipSpecial:GetNeedShowData()
	local data = VipSpecailSys.GetDataByVipLvl()
	
	local lvl = ClinetInfomation.Lvl
	if lvl >=data.NeedLevel then
		return data
	end
end

function UIVipSpecial:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "closeBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "BuyButton" then
		this:ToBuyRec()
	end
end

function UIVipSpecial:ToBuyRec()
	VipSpecailSys.ReciveRwd(UIVipSpecial.CurShowId)
--	this:ClosePanel()
end

function UIVipSpecial:ShowBuyAfter()
	local reward = RewardConfig.GetRewardConfig(UIVipSpecial.ClickBuyData.Reward)
	local jsons = RewardContentSys.GetRewardResourceString(reward.RewardString)
	local list = jsons.Items
	DataUIInstance.OpenRewards(list)
	this:ClosePanel()
end

function UIVipSpecial:ClosePanel()
	GameMain.CloseObj(UIVipSpecial.UIVipSpecialGod)
end

function UIVipSpecial:ReleasPanel()
	UIVipSpecial.UIVipSpecialGod = nil
	UIVipSpecial.Controls = {}
	--Data
	UIVipSpecial.CurShowId = ""
	UIVipSpecial.ClickBuyData = nil
end

function UIVipSpecial:ReleasData()
	VipSpecailSys.DataList = {}				
	VipSpecailSys.RecDataList = {}			--已经购买的数据
end

return UIVipSpecial
--endregion
