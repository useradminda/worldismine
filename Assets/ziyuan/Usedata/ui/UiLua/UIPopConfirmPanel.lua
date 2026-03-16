--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIPopConfirmPanel = {}
UIPopConfirmPanel = BasePanel:new()
local this = UIPopConfirmPanel
--UI
UIPopConfirmPanel.UIPopConfirmPanelGod = nil
UIPopConfirmPanel.Controls = {}
UIPopConfirmPanel.Msg = nil
--Data
UIPopConfirmPanel.ConfirmData = nil
UIPopConfirmPanel.CanCelData = nil
--Event
UIPopConfirmPanel.ConfirmEvent = nil		--确认回调
UIPopConfirmPanel.CanCelEvent = nil			--取消回调

function UIPopConfirmPanel:OpenUI(_PanelName , _LuaName , _Data)
	if UIPopConfirmPanel.UIPopConfirmPanelGod == nil then
		UIPopConfirmPanel.UIPopConfirmPanelGod = MainGameUI.FindPanel("UIPopConfirmPanel")
		this:GetControls()
	end
	this:SetInitData(_Data)
	
	this:ShowInfo()
end

function UIPopConfirmPanel:GetControls()
	UIPopConfirmPanel.Controls.Info = UIPopConfirmPanel.UIPopConfirmPanelGod.transform:FindChild("info"):GetComponent("UILabel")
end

function UIPopConfirmPanel:SetInitData(_Data)
	UIPopConfirmPanel.ConfirmData = _Data.ConfrimData
	UIPopConfirmPanel.CanCelData = _Data.CancelData
	UIPopConfirmPanel.ConfirmEvent = _Data.ConfirmEvent
	UIPopConfirmPanel.CanCelEvent = _Data.CanCelEvent
	UIPopConfirmPanel.Msg = _Data.Msg
end

function UIPopConfirmPanel:ShowInfo()
	UIPopConfirmPanel.UIPopConfirmPanelGod.transform.localPosition = Vector3(0 , 0 , -700)
	if UIPopConfirmPanel.Msg ~=nil then
		UIPopConfirmPanel.Controls.Info.text = UIPopConfirmPanel.Msg
	else
		UIPopConfirmPanel.Controls.Info.text = ""
	end
	
end

function UIPopConfirmPanel:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "ConfirmBtn" then
		this:ShowConfirmEvent()
	end
	if _Gob.name == "CancelBtn" then
		this:ShowCancelEvent()
	end
end


function UIPopConfirmPanel:ShowConfirmEvent()
	if UIPopConfirmPanel.ConfirmEvent~=nil then
		if UIPopConfirmPanel.ConfirmData~=nil then
			UIPopConfirmPanel.ConfirmEvent(UIPopConfirmPanel.ConfirmData)
		else
			UIPopConfirmPanel.ConfirmEvent()
		end
	end
	UIPopConfirmPanel.ConfirmEvent = nil
	this:ClosePanel()
end

function UIPopConfirmPanel:ShowCancelEvent()
	if UIPopConfirmPanel.CanCelEvent~=nil then
		if UIPopConfirmPanel.CanCelData~=nil then
			UIPopConfirmPanel.CanCelEvent(UIPopConfirmPanel.CanCelData)
		else
			UIPopConfirmPanel.CanCelEvent()
		end
	end
	UIPopConfirmPanel.CanCelEvent = nil
	this:ClosePanel()
end

function UIPopConfirmPanel:ClosePanel()
	GameMain.CloseObj(UIPopConfirmPanel.UIPopConfirmPanelGod)
end

function UIPopConfirmPanel:ReleasPanel()
	--UI
	UIPopConfirmPanel.UIPopConfirmPanelGod = nil
	UIPopConfirmPanel.Controls = {}
	UIPopConfirmPanel.Msg = nil
	--Data
	UIPopConfirmPanel.ConfirmData = nil
	UIPopConfirmPanel.CanCelData = nil
	--Event
	UIPopConfirmPanel.ConfirmEvent = nil		--确认回调
	UIPopConfirmPanel.CanCelEvent = nil			--取消回调
    
end

return UIPopConfirmPanel