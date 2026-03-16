--[[登录界面 缺更新界面，服务器列表，公告。。。--]]
UILogin = {}

local UILogin = BasePanel:new()     
local this = UILogin
UILogin.UILoginGob = nil

UILogin.RegistName=nil
UILogin.RegistPassWord=nil
UILogin.RegistePanel = nil

UILogin.LoginPanel = nil
UILogin.LoginName=nil
UILogin.LoginPassWord=nil

function UILogin:OpenUI(_PanelName , _LuaName)
	if UILogin.UILoginGob == nil then
		UILogin.UILoginGob=MainGameUI.FindPanel("UILogin")
		UILogin.LoginPanel = UILogin.UILoginGob.transform:FindChild("LoginPanel")
		UILogin.LoginName=UILogin.LoginPanel.transform:FindChild("LoginName"):GetComponent("UIInput")
		UILogin.LoginPassWord=UILogin.LoginPanel.transform:FindChild("LoginPassWord"):GetComponent("UIInput")

		UILogin.RegistePanel = UILogin.UILoginGob.transform:FindChild("RegistePanel")
		UILogin.RegistPassWord=UILogin.RegistePanel.transform:FindChild("registerPassWord"):GetComponent("UIInput")
		UILogin.RegistName=UILogin.RegistePanel.transform:FindChild("registerName"):GetComponent("UIInput")
	end

	this:SetLoginInfo()
end

function UILogin:SetLoginInfo()--设置登录信息
	local name = LoginData.GetOwnName()	
	local passWord = LoginData.GetOwnPassWord()
   
	if name~=nil then 
		this:ClosePanel(UILogin.RegistePanel)
		this:OpenPanel(UILogin.LoginPanel)  
		UILogin.LoginName.value=tostring(name)
		--if LoginData.RegisterPassword~=nil then
			UILogin.LoginPassWord.value=tostring(passWord)
		--end
	else
		this:OpenPanel(UILogin.RegistePanel)
		this:ClosePanel(UILogin.LoginPanel)
	end
end

function UILogin:UIHand(_LuaName , _Gob)
MusicManagerSys.ButtonClick()
    if _Gob.name=="LoginBtn" then
		this:EnterGame()
    end

	if _Gob.name=="LoginRegistBtn" then
		this:ClosePanel(UILogin.LoginPanel)
		this:OpenPanel(UILogin.RegistePanel)
	end

	if _Gob.name == "RegistBtn" then     
       	this:RegistGame()
	end 
	if _Gob.name=="RegisterCloseBtn" then
--		this:ClosePanel(UILogin.RegistePanel)
		this:SetLoginInfo()
	end
	if _Gob.name=="LoginCloseBtn" then
		this:ClosePanel(UILogin.UILoginGob)
	end            
end

function UILogin:EnterGame()	--登录游戏(后续调整)
--	if UILogin.LoginName.value ~= tostring(LoginData.RegisterEmail) then
--		return
--	end
--	if UILogin.LoginPassWord.value ~= tostring(LoginData.RegisterPassword) then
--		return
--	end
	 LoginData.LoginZQPlatform(UILogin.LoginName.value , UILogin.LoginPassWord.value)
	MusicManagerSys.CastleMusic()
end

function UILogin:RegistGame()	--注册游戏账号
	if UILogin.RegistName.value=="" then
		DataUIInstance.PopTip(UIstring.LoginPutName)
		return
	end
	
	if UILogin.RegistPassWord.value=="" then
		DataUIInstance.PopTip(UIstring.LoginPutPassWord)
		return
	end
	local account = UILogin.RegistName.value
	local code = UILogin.RegistPassWord.value
	local accountIsHasKey = lgNoDelCsFun.Ins:JudgeAccount(account)
	if accountIsHasKey == false then
		DataUIInstance.PopTip(UIstring.CanNotHasKey)
		UILogin.RegistName.value=""
		UILogin.RegistPassWord.value=""
		return
	end
	local codeIsHasKey = lgNoDelCsFun.Ins:JudgeCode(code)
	if codeIsHasKey == false then
		DataUIInstance.PopTip(UIstring.CanNotHasKey)
		UILogin.RegistPassWord.value=""
		return
	end
	
	LoginData.RegistZQ(UILogin.RegistName.value,UILogin.RegistPassWord.value)
		
	UILogin.RegistName.value=""
	UILogin.RegistPassWord.value=""
end

function UILogin:ClosePanel(PanelObj)
	if PanelObj ~= nil then
		PanelObj.gameObject:SetActive(false)
	end
	
end

function UILogin:OpenPanel(PanelObj)
	if PanelObj ~= nil then
		PanelObj.gameObject:SetActive(true)
	end
	
end

function UILogin:CloseChooseWeb()
	local uiHireHeroTar = MainGameUI.FindPanelTarget("UIChooseWeb")
	if uiHireHeroTar ~=nil then
		GameMain.CloseObj(uiHireHeroTar.UIChooseWebGod)
	end
end

function UILogin:CloseUILogin()
	this:ClosePanel(UILogin.UILoginGob)
		this:CloseChooseWeb()
	local UIControlTar =  MainGameUI.FindPanelTarget("UIControl")
	if UIControlTar~=nil then
		if UIControlTar.InitPanel ~= nil then
			GameObject.Destroy(UIControlTar.InitPanel.gameObject)
		end
	end
end

function UILogin:ReleasPanel()
    
    UILogin.UILoginGob = nil

	UILogin.RegistName=nil
	UILogin.RegistPassWord=nil
	UILogin.RegistePanel = nil
	
	UILogin.LoginPanel = nil
	UILogin.LoginName=nil
	UILogin.LoginPassWord=nil

end

function UILogin:ReleasData()
	ClinetInfomation.World_id = nil										--主角
	ClinetInfomation.Name = "nil"                                       
	ClinetInfomation.MyOwner = 1                                        --1 ， 2 ，3 ，4 蜀 魏 吴 中立
	ClinetInfomation.PlayerId = nil
	ClinetInfomation.WorldTime = 0
	ClinetInfomation.GuaShuaiUUID = nil									--挂帅武将的UUID
	ClinetInfomation.Player_id = nil									--玩家ID
	ClinetInfomation.Lvl = 0											--玩家等级
	ClinetInfomation.VipExp = 0											--vip经验
	ClinetInfomation.VipLevel = 0											--vip等级
	ClinetInfomation.Fight = 0                                          --战斗力
	ClinetInfomation.Honour = 0											--荣誉
	ClinetInfomation.Feats = 0											--功勋
	ClinetInfomation.Reputation = 0										--声望
	ClinetInfomation.Exp = 0											--主角经验
	ClinetInfomation.powerRank = 0										--战斗力排名
	ClinetInfomation.compRank = 0										--综合排名
	ClinetInfomation.featsRewardTimes = 0       
	ClinetInfomation.goldticket = 0										--金券（用于寄售行）       
	ClinetInfomation.BuyArmyTime = 0
	ClinetInfomation.ServeID = "10003"
	ClinetInfomation.Ip = ""
	ClinetInfomation.Port = 0
end

return UILogin