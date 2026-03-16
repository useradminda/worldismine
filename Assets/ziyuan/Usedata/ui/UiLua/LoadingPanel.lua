--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

LoadingPanel = {}
LoadingPanel.loadingGod = nil
LoadingPanel.loadingModel = nil
LoadingPanel.loadingChangeScene = nil

function LoadingPanel.OpenLoading()
	local uicontrol = MainGameUI.FindPanelTarget("UIControl")
	if uicontrol~=nil then
		if LoadingPanel.loadingGod == nil then
			LoadingPanel.loadingGod = MainGameUI.FindPanelTarget("UIControl").AnchorCenter.transform:FindChild("LoadingPanel")
		end
		GameMain.OpenObj(LoadingPanel.loadingGod)
	end
end

function LoadingPanel.OpenModelLoading()
	local uicontrol = MainGameUI.FindPanelTarget("UIControl")
	if uicontrol~=nil then
		if LoadingPanel.loadingModel == nil then
			LoadingPanel.loadingModel = MainGameUI.FindPanelTarget("UIControl").AnchorCenter.transform:FindChild("LoadingModelPanel")
		end
		GameMain.OpenObj(LoadingPanel.loadingModel)
	end
end

function LoadingPanel.StopLoading()
	GameMain.CloseObj(LoadingPanel.loadingGod)
end

function LoadingPanel.StopLoadingModel()
	GameMain.CloseObj(LoadingPanel.loadingModel)
end

function LoadingPanel.GetControls()

end

function LoadingPanel.OpenChangeScenePanel()
   local uicontrol = MainGameUI.FindPanelTarget("UIControl")
	if uicontrol~=nil then
		if LoadingPanel.loadingChangeScene == nil then
			LoadingPanel.loadingChangeScene = MainGameUI.FindPanelTarget("UIControl").AnchorCenter.transform:FindChild("ChangeScenePanel")
		end
		GameMain.OpenObj(LoadingPanel.loadingChangeScene)
	end
end

function LoadingPanel.StopChangeScenePanel()
   GameMain.CloseObj(LoadingPanel.loadingChangeScene)
end

function LoadingPanel.Release()
	LoadingPanel.loadingGod = nil
	LoadingPanel.loadingModel = nil
    LoadingPanel.loadingChangeScene = nil
end

return LoadingPanel
--endregion
