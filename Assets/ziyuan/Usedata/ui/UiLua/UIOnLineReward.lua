UIOnLineReward = {}
local UIOnLineReward = BasePanel:new()     
local this = UIOnLineReward
--UI
UIOnLineReward.UIOnLineRewardGob = nil
UIOnLineReward.Controls = {}

--Data
UIOnLineReward.ItemDataList = {}

function UIOnLineReward:OpenUI()
	if UIOnLineReward.UIOnLineRewardGob == nil then
		UIOnLineReward.UIOnLineRewardGob=MainGameUI.FindPanel("UIOnLineReward")
		this:GetControls()
	end
	this:ShowInfo()
    local _UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if _UIControlTar~=nil then
       _UIControlTar:OpenTip(false , "Time")
    end
end

function UIOnLineReward:GetControls()
	UIOnLineReward.Controls.EqulsRecCount = UIOnLineReward.UIOnLineRewardGob.transform:FindChild("HaveGet/Time"):GetComponent("UILabel")
	UIOnLineReward.Controls.NextRecTime = UIOnLineReward.UIOnLineRewardGob.transform:FindChild("NextTime/Time"):GetComponent("UILabel")
	UIOnLineReward.Controls.BtnTxt = UIOnLineReward.UIOnLineRewardGob.transform:FindChild("GetButton/Word"):GetComponent("UILabel")
	UIOnLineReward.Controls.Grid = UIOnLineReward.UIOnLineRewardGob.transform:FindChild("Reward/Grid"):GetComponent("UIGrid")
	UIOnLineReward.Controls.ItemGodList = {}
	for i=1,5,1  do
		UIOnLineReward.Controls.ItemGodList[i] = UIOnLineReward.Controls.Grid.transform:FindChild(tostring(i))
	end
end

function UIOnLineReward:ShowInfo()
	this:ShowTimeInfo()
	this:ShowItemListInfo()
end

function UIOnLineReward:ShowTimeInfo()
	UIOnLineReward.Controls.EqulsRecCount.text = OnlineRwdSys.GetRecCountStr()
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time~=nil then
		GameMain.AddUpdateLua(this.UpdateTime)
	end
end

function UIOnLineReward:UpdateTime()
	local time = TimeControl.GetTime("OnLineTimeDel")
	if time == nil then
		GameMain.DelUpdateLua(this.UpdateTime)
		return
	end
	if time==0 then
		GameMain.DelUpdateLua(this.UpdateTime)
		UIOnLineReward.Controls.NextRecTime.text = TimeControl.GetTimeString(0)
		UIOnLineReward.Controls.BtnTxt .text = "领取"
	else
		UIOnLineReward.Controls.NextRecTime.text = TimeControl.GetTimeString(time)
		UIOnLineReward.Controls.BtnTxt .text = "离开"
	end
end

function UIOnLineReward:ShowItemListInfo()
	UIOnLineReward.ItemDataList = {}
	local list = OnlineRwdSys.GetCurRecItemList()
	for i=1,#list,1  do
		UIOnLineReward.ItemDataList[i] =list[i]
	end

	for i=1,5,1  do
		local data = UIOnLineReward.ItemDataList[i]
		local God = UIOnLineReward.Controls.ItemGodList[i]
		this:ShowItem(data , God)
	end
	UIOnLineReward.Controls.Grid.enabled = true
	UIOnLineReward.Controls.Grid:Reposition()
end

function UIOnLineReward:ShowItem(_Data , _God)
	if _Data == nil then
		GameMain.CloseObj(_God)
	else
		GameMain.OpenObj(_God)
		local Img = _God.transform:FindChild("Img"):GetComponent("UISprite")
		local Quality = _God.transform:FindChild("Quality"):GetComponent("UISprite")
		local CountTxt = _God.transform:FindChild("Label"):GetComponent("UILabel")
		local Bg = _God.transform:FindChild("BG"):GetComponent("UISprite")
		Bg.spriteName = UIstring.ItemFg[_Data.Quality]
		AtlasMsg.SetAtlas(Img , _Data.AtlasName , _Data.SpriteName)
		Quality.spriteName = UIstring.ItemFg[_Data.Quality]
		CountTxt.text = _Data.Count
	end
end


function UIOnLineReward:UIHand(_LuaName , _Gob)
  MusicManagerSys.ButtonClick()
	 if _Gob.name=="CloseBtn" then
      this:ClosePanel()
   end

	if _Gob.name == "GetButton" then
		this:SendWebRecLineRwd()
	end
end

function UIOnLineReward:SendWebRecLineRwd()
	local isCanRec = OnlineRwdSys.IsCanRecRwd()
	if isCanRec == true then
		OnlineRwdSys.ReceiveOnlineReward()
		DataUIInstance.OpenRewards(UIOnLineReward.ItemDataList)	
	end
	this:ClosePanel()
end

function UIOnLineReward:ClosePanel()
   UIOnLineReward.UIOnLineRewardGob.gameObject:SetActive(false)
end

function UIOnLineReward:ReleasPanel()
	--UI
	UIOnLineReward.UIOnLineRewardGob = nil
	UIOnLineReward.Controls = {}

	--Data
	UIOnLineReward.ItemDataList = {}
	GameMain.DelUpdateLua(this.UpdateTime)
end

function UIOnLineReward:ReleasData()
	OnlineRwdSys.OnlineBeginTime = 0					--当天登录的时间
	OnlineRwdSys.OnlineRwdId = 0						--上次领取的ID
end

return UIOnLineReward