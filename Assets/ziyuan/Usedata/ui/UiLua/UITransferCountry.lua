--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UITransferCountry = {}
UITransferCountry = BasePanel:new()
local this = UITransferCountry

--UI
UITransferCountry.UITransferCountryGod = nil

function UITransferCountry:OpenUI(_PanelName , _LuaName)
	if UITransferCountry.UITransferCountryGod == nil then
		UITransferCountry.UITransferCountryGod = MainGameUI.FindPanel("UITransferCountry")
	end
	

end
function UITransferCountry:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		this:ClosePanel()
	end
	if _Gob.name == "weibtn" then
		this:ChooseCamp(2)
	end
	if _Gob.name == "wubtn" then
		this:ChooseCamp(3)
	end
	if _Gob.name == "shubtn" then
		this:ChooseCamp(1)
	end
	if _Gob.name == "randombtn" then
		this:ChooseCamp(0)
	end
end

function UITransferCountry:ChooseCamp(Num)
	--蜀魏吴
	TransferCountrySys.ChooseCamp(Num)
	this:ClosePanel()
end


function UITransferCountry:ClosePanel()
	GameMain.CloseObj(UITransferCountry.UITransferCountryGod)
end

function UITransferCountry:ReleasPanel()
	UITransferCountry.UITransferCountryGod = nil
end

return UITransferCountry
--endregion
