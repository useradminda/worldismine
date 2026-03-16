--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIPlayerUpLvl = {}
UIPlayerUpLvl = BasePanel:new()
local this = UIPlayerUpLvl
--UI相关
UIPlayerUpLvl.UIPlayerUpLvlGod = nil
UIPlayerUpLvl.Controls = {}

function UIPlayerUpLvl:OpenUI(_PanelName , _LuaName)
	if UIPlayerUpLvl.UIPlayerUpLvlGod == nil then
		UIPlayerUpLvl.UIPlayerUpLvlGod = MainGameUI.FindPanel("UIPlayerUpLvl")
		this:GetControls()
	end
	MusicManagerSys.PlayerUpLvl()
	this:ShowInfo()
end

function UIPlayerUpLvl:GetControls()
	UIPlayerUpLvl.Controls.BeforeLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/lvl/before"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.UpLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/lvl/up"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.BeforeHeroLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/hero/before"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.UpHeroLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/hero/up"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.BeforeStrengthLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/strength/before"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.UpStrengthLvl = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info/strength/up"):GetComponent("UILabel")
	UIPlayerUpLvl.Controls.Info = UIPlayerUpLvl.UIPlayerUpLvlGod.transform:FindChild("info")
	UIPlayerUpLvl.Controls.Tween = UIPlayerUpLvl.Controls.Info:GetComponent("TweenScale")
end

function UIPlayerUpLvl:ShowInfo()
	GameMain.CloseObj(UIPlayerUpLvl.Controls.Info)
	GameMain.OpenObj(UIPlayerUpLvl.Controls.Info)
	
	UIPlayerUpLvl.Controls.Tween.enabled = true
	UIPlayerUpLvl.Controls.Tween:ResetToBeginning()
	UIPlayerUpLvl.Controls.Tween:Play()
	
	local beforelvl = ClinetInfomation.Lvl - 1
	local Uplvl = ClinetInfomation.Lvl
	
	UIPlayerUpLvl.Controls.BeforeLvl.text = "Lv" .. beforelvl
	UIPlayerUpLvl.Controls.UpLvl.text = "Lv" .. Uplvl
	UIPlayerUpLvl.Controls.BeforeHeroLvl.text = "Lv" .. beforelvl
	UIPlayerUpLvl.Controls.UpHeroLvl.text = "Lv" .. Uplvl
	UIPlayerUpLvl.Controls.BeforeStrengthLvl.text = "Lv" .. beforelvl
	UIPlayerUpLvl.Controls.UpStrengthLvl.text = "Lv" .. Uplvl
end

function UIPlayerUpLvl:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name =="CloseBtn" then
		this:ClosePanel()
	end
end

function UIPlayerUpLvl:ClosePanel()
	GameMain.CloseObj(UIPlayerUpLvl.UIPlayerUpLvlGod)
end

function UIPlayerUpLvl:ReleasPanel()
	--UI相关
	UIPlayerUpLvl.UIPlayerUpLvlGod = nil
	UIPlayerUpLvl.Controls = {}
end

return UIPlayerUpLvl
--endregion
