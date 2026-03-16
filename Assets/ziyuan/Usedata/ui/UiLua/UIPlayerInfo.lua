--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIPlayerInfo={}
UIPlayerInfo=BasePanel:new()
local this = UIPlayerInfo
--UI
UIPlayerInfo.UIPlayerInfoGod = nil
UIPlayerInfo.Controls = {}

function UIPlayerInfo:OpenUI(_PanelName , _LuaName)
	if UIPlayerInfo.UIPlayerInfoGod==nil then
		UIPlayerInfo.UIPlayerInfoGod=MainGameUI.FindPanel("UIPlayerInfo")
		this:GetControls()
	end
	this:ShowInfo()
end

function UIPlayerInfo:GetControls()
	local heroInfo = UIPlayerInfo.UIPlayerInfoGod.transform:FindChild("HeroInfo")
	UIPlayerInfo.Controls.Img = heroInfo.transform:FindChild("IMG"):GetComponent("UISprite")
	UIPlayerInfo.Controls.Quality = heroInfo.transform:FindChild("FG"):GetComponent("UISprite")
	UIPlayerInfo.Controls.CountryName = heroInfo.transform:FindChild("countryName"):GetComponent("UILabel")
	UIPlayerInfo.Controls.PlayerName = heroInfo.transform:FindChild("PlayerName"):GetComponent("UILabel")
	UIPlayerInfo.Controls.VipLvl = heroInfo.transform:FindChild("vip"):GetComponent("UILabel")
	UIPlayerInfo.Controls.Lvl = heroInfo.transform:FindChild("Lvl"):GetComponent("UILabel")
	
	local info = UIPlayerInfo.UIPlayerInfoGod.transform:FindChild("Info")
	UIPlayerInfo.Controls.LvlInfo = info.transform:FindChild("lvl"):GetComponent("UILabel")
	UIPlayerInfo.Controls.heroLimitLvl = info.transform:FindChild("heroLimitLvl"):GetComponent("UILabel")
	UIPlayerInfo.Controls.heroCount = info.transform:FindChild("heroCount"):GetComponent("UILabel")

	UIPlayerInfo.Controls.ModifyNamePanel = UIPlayerInfo.UIPlayerInfoGod.transform:FindChild("ModifyNamePanel")
	local bgMusicBtn = UIPlayerInfo.UIPlayerInfoGod.transform:FindChild("musicBtn")
	UIPlayerInfo.Controls.OpenBgMusic = bgMusicBtn.transform:FindChild("bgclick")
	UIPlayerInfo.Controls.CloseBgMusic = bgMusicBtn.transform:FindChild("bgnoclick")
	local MusicEffBtn = UIPlayerInfo.UIPlayerInfoGod.transform:FindChild("musicEffBtn")
	UIPlayerInfo.Controls.OpenClipMusic = MusicEffBtn.transform:FindChild("clipclick")
	UIPlayerInfo.Controls.CloseClipMusic = MusicEffBtn.transform:FindChild("clipnoclick")
	
end

function UIPlayerInfo:ShowInfo()
	
	local data = HeroPackageSys.GetOneHeroBy_UUID(ClinetInfomation.GuaShuaiUUID)
    if data ~=nil then
	   AtlasMsg.SetAtlas( UIPlayerInfo.Controls.Img,data.AtlasName , data.SpriteName)
	   UIPlayerInfo.Controls.Quality.spriteName = UIstring.ItemFg[data.quality]
    end
	UIPlayerInfo.Controls.CountryName.text = UIstring.Ownerships[ClinetInfomation.MyOwner]
	UIPlayerInfo.Controls.PlayerName.text = ClinetInfomation.Name
	UIPlayerInfo.Controls.VipLvl.text = "Vip" .. VipSys.VipLevel
	UIPlayerInfo.Controls.Lvl.text = "Lv" .. ClinetInfomation.Lvl
	UIPlayerInfo.Controls.LvlInfo.text = tostring(ClinetInfomation.Lvl)
	UIPlayerInfo.Controls.heroCount.text = HeroPackageSys.GetOwnHeroCount() .. "/" .. LimitDataSys.GetOwnHeroCount()
	UIPlayerInfo.Controls.heroLimitLvl.text = tostring(ClinetInfomation.Lvl)
	this:ShowMusicToggleState()
end

function UIPlayerInfo:ShowMusicToggleState()
	local isOpenBg = MusicManagerSys.GetBgToggleState()
	if isOpenBg == true then
		GameMain.OpenObj(UIPlayerInfo.Controls.CloseBgMusic)
		GameMain.CloseObj(UIPlayerInfo.Controls.OpenBgMusic)
	else
		GameMain.CloseObj(UIPlayerInfo.Controls.CloseBgMusic)
		GameMain.OpenObj(UIPlayerInfo.Controls.OpenBgMusic)
	end
	local isOpenClip = MusicManagerSys.GetClipToggleState()
	if isOpenClip == true then
		GameMain.OpenObj(UIPlayerInfo.Controls.CloseClipMusic)
		GameMain.CloseObj(UIPlayerInfo.Controls.OpenClipMusic)
	else
		GameMain.CloseObj(UIPlayerInfo.Controls.CloseClipMusic)
		GameMain.OpenObj(UIPlayerInfo.Controls.OpenClipMusic)
	end
end

function UIPlayerInfo:ShowSetNameAfter(_IsSuccess)
	if _IsSuccess == 0 then
		this:ShowInfo()
		DataUIInstance.PopTip("更改成功")
	else
		DataUIInstance.PopTip("用户名已经被使用")
	end
end

function UIPlayerInfo:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "modifyNameBtn" then
		this:OpenModifyNamePanel()
	end
	if _Gob.name == "ConfirmBtn" then
		this:ToModifyName()
	end
	if _Gob.name == "CancelBtn" then
		this:CloseModifyNamePanel()
	end
	if _Gob.name == "closeModifyBtn" then
		this:CloseModifyNamePanel()
	end
	if _Gob.name == "closeBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "bgclick" then
		this:SetBgMusicState(true)
	end
	if _Gob.name == "bgnoclick" then
		this:SetBgMusicState(false)
	end
    if _Gob.name == "RandonButton" then
		this:SetRandomName()
	end
	if _Gob.name == "clipclick" then
		
		this:SetClipMusicState(true)
	end
	if _Gob.name == "clipnoclick" then
		this:SetClipMusicState(false)
	end
    if _Gob.name == "ReLoginBtn" then
       
	   this:ClosePanel()
		GameMain.LoginOutGame()
	end
end

function UIPlayerInfo:SetBgMusicState(_IsOpen)
	MusicManagerSys.ToggleBg(_IsOpen)
	this:ShowMusicToggleState()
end

function UIPlayerInfo:SetClipMusicState(_IsOpen)
	MusicManagerSys.ToggleClip(_IsOpen)
	this:ShowMusicToggleState()
end

function UIPlayerInfo:SetRandomName()
   UIPlayerInfo.Controls.InputName.value = ClinetSys.GetMing()..ClinetSys.GetXing()
end

function UIPlayerInfo:ToModifyName()
	local name = UIPlayerInfo.Controls.InputName.value
	
	if name == "" then
		DataUIInstance.PopTip("Y7")
		return
	end
	local isHasKey = lgNoDelCsFun.Ins:JudgeName(name)
	if isHasKey == false then
		DataUIInstance.PopTip("Y5")
		return
	end
    local isPass = lgNoDelCsFun.Ins:CheckBanWord(name , UIstring.Banwords)
    if isPass==false then
       DataUIInstance.PopTip("Y6")
       return 
    end

    local count = GameMain.GetStrByteCount(name)
	if count>14 then
		DataUIInstance.PopTip("X4")
		return
	end


	if ClinetInfomation.Diamond< ConstConfig.GetSetNameNeedMoney() then
		DataUIInstance.PopTip("W2")
		DataUIInstance.OpenRecharge()
		return
	end
	
   

	PlayerInfoSys.SetName(name)
	this:CloseModifyNamePanel()

end

function UIPlayerInfo:CloseModifyNamePanel()
	if UIPlayerInfo.Controls.ModifyNamePanel ~= nil then
		GameMain.CloseObj(UIPlayerInfo.Controls.ModifyNamePanel)
	end
end

function UIPlayerInfo:OpenModifyNamePanel()
	if UIPlayerInfo.Controls.ModifyNamePanel ~= nil then
		GameMain.OpenObj(UIPlayerInfo.Controls.ModifyNamePanel)
	end
	if UIPlayerInfo.Controls.InputName == nil then
		UIPlayerInfo.Controls.InputName = UIPlayerInfo.Controls.ModifyNamePanel.transform:FindChild("input/Label"):GetComponent("UIInput")
	end
	if UIPlayerInfo.Controls.NeedMoney == nil then
		UIPlayerInfo.Controls.NeedMoney = UIPlayerInfo.Controls.ModifyNamePanel.transform:FindChild("money/needMoney"):GetComponent("UILabel")
	end
	UIPlayerInfo.Controls.InputName.value = ""
	UIPlayerInfo.Controls.NeedMoney.text = tostring(ConstConfig.GetSetNameNeedMoney())
end

function UIPlayerInfo:ClosePanel()
	GameMain.CloseObj(UIPlayerInfo.UIPlayerInfoGod)
end

function UIPlayerInfo:ReleasPanel()
	--UI
	UIPlayerInfo.UIPlayerInfoGod = nil
	UIPlayerInfo.Controls = {}
end

return UIPlayerInfo
--endregion
