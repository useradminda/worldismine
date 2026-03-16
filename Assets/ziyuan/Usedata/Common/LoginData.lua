LoginData = {}

--local this = LoginData

--[[LoginData = {
	uuid  = nil,
	channel = nil,
	token  = nil,
	svr_id = nil, --server ID
	real_id = 0,
	player_id = 0,
	world_id = 0,
	role_list = {},	
	Email = nil,
	Password = nil,
	RegisterEmail = nil,
	RegisterPassword = nil,
    GuestEmail = nil,
    GuestPassWord = nil,
}--]]


--[[LoginData.PlatFormUrl = "http://114.215.92.238:10500/login/webroot/index.php"
LoginData.GameUrl = "http://114.215.92.238:10500/dhz/index.php?ctl=user&act=login"
LoginData.ModelUrl = "http://114.215.92.238:10500/dhz/index.php?ctl=request&act=unpack"

LoginData.ServerListUrl = "http://114.215.92.238:10500/svrList/dhz_2.0.0.html"

LoginData.LastServer = nil
LoginData.TempServer = nil
LoginData.ServerId = 0--]]

--[[function LoginData.GetServerList()                                           --获取服务器列表
   
   Debug.LogError("服务器列表 ServerListUrl".." : ".."http://114.215.92.238:10500/svrList/dhz_1.0.0.html")
   --LoadingPanel.OpenLoadingPanel()

   GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/svrList/dhz_2.0.0.html" , "LoginData.GetServerListCallBack", LoginData.GetServerListCallBack) --线下
 -- GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/svrList/dhz_2.0.0.html" , "LoginData.GetServerListCallBack", LoginData.GetServerListCallBack)  --线上
end

LoginData.ServerList = {}
function LoginData.GetServerListCallBack(data)
   --GameMain.Print(data)
   LoginData.ServerList = {}
   if data["r"]==0 then
      local ServerList = data["msg"][1]["d"]["srv"]
      local ServerCount = #ServerList
      for i = 1 , ServerCount , 1 do
          local ServerItem = ServerList[i]--
          local data =
          {
             Url = tostring(ServerItem["url"]),
             Status = tonumber(ServerItem["status"]),
             Name = tostring(ServerItem["name"]),
             Server_id = tonumber(ServerItem["server_id"])
          }
          LoginData.ServerList[i] = data
      end
      DataUIInstance.CreateLoginUI(LoginData.CreateUILoginCallBack)												--创建注册界面    
   end
   
end

function LoginData.CreateUILoginCallBack()
   LoadingPanel.StopLoadingPanel()
   local LoginTar = MainGameUI.FindPanelTarget("UILogin")
   LoginTar:SetLatestServer()                                           
   LoginData.GetBroad()                                                 --获取公告
   LoadingPanel.CloseTempLoading()                                        --清除临时界面
end

function LoginData.GetBroad()                                           --获取公告  
   Debug.LogError("公告URL".." : ".."http://114.215.92.238:10500/notice/ios_1.0.0.html")
   --LoadingPanel.OpenLoadingPanel()
   GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/notice/ios_1.0.0.html" , "LoginData.GetBroadCallBack", LoginData.GetBroadCallBack) 
end

LoginData.BroadText = 
{
}

function LoginData.GetBroadCallBack(data)
    GameMain.Print(data , "Broad")
    local Count = #data
    for i = 1 , Count , 1 do
        if LoginData.BroadText[i]==nil then
           LoginData.BroadText[i] = {}
        end
        LoginData.BroadText[i].Content = data[i].content
        LoginData.BroadText[i].Title = data[i].title
        LoginData.BroadText[i].Id = data[i].Id
    end
    local LoginTar = MainGameUI.FindPanelTarget("UILogin")
    LoginTar:SetBroad()
    LoadingPanel.StopLoadingPanel()
end

function LoginData.GetServerByServerId(_ServerId)
    for i = 1 , #LoginData.ServerList , 1 do
        if tonumber(_ServerId)==LoginData.ServerList[i].Server_id then
           return LoginData.ServerList[i]
        end
    end 
    return nil                                                                
end
--]]

--[[function LoginData.SetTempServer(_Server)
	Debug.Log("set TempServer")
   LoginData.TempServer = _Server
   LoginData.PlatFormUrl = "http://114.215.92.238:10500/login/webroot/index.php"
   LoginData.GameUrl = LoginData.TempServer.Url.."?ctl=user&act=login"
   LoginData.ModelUrl =  LoginData.TempServer.Url.."?ctl=request&act=unpack"
end

function LoginData.ApplicationGuest()
   Debug.LogError("游客登录".." : ".."http://114.215.92.238:10500/login/webroot/index.php?ctl=user&act=guestRegister")
--   LoadingPanel.OpenLoadingPanel()

   GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/login/webroot/index.php?ctl=user&act=guestRegister" , "LoginData.ApplicationGuestCallBack", LoginData.ApplicationGuestCallBack)
end

function LoginData.ApplicationGuestCallBack(data)
   --GameMain.Print(data) 
   if data["result"]==0 then
      local guestData = data["data"]
      local Guest_Mail = tostring(guestData["guest"])
      local Guest_Word = tostring(guestData["guest_pwd"])     
      LoginData.LoginGuest(Guest_Mail , Guest_Word)
   else
      DataUIInstance.PopTip("P9")
   end
end--]]

--[[function LoginData.LoginGuest(_Email , _PassWord)
   LoginData.channel = "channel"

   PlayerPrefs.SetString("GuestEmail" , _Email)
   PlayerPrefs.SetString("GuestPassWord" , _PassWord)

   LoginData.GuestEmail = _Email
   LoginData.GuestPassWord = _PassWord

   local action = "guestLogin"
   LoginData.LoginGuestPlatformNet(action)

end

function LoginData.LoginGuestPlatformNet(action)

	local data = {
		--uuid = LoginData.uuid,
		channel = LoginData.channel,
		ctl = "user",
		act = action,
		guest = LoginData.GuestEmail,
		guest_pwd = LoginData.GuestPassWord,
	}
    GameMain.Print(data)
	Debug.LogError("平台url PlatFormUrl".." : "..LoginData.PlatFormUrl)
--    LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.LoginPlatformCallBack", LoginData.LoginPlatformCallBack)
end--]]

--[[function LoginData.LoginPlatform(_Email , _Password)						--登陆游戏平台 返回Token
	
	LoginData.channel = "channel"
	LoginData.uuid = PlayerPrefs.GetString("tmpuuid3");
	
	PlayerPrefs.SetString("LastEmail" , _Email)
	PlayerPrefs.SetString("LastPassword" , _Password)
	
	LoginData.RegisterEmail = _Email
	LoginData.RegisterPassword = _Password
	
	if LoginData.uuid == "" then
		LoginData.uuid = os.date("1%M%H%S")
		PlayerPrefs.SetString("tmpuuid3", LoginData.uuid)
	end
	
	local action = "login"
	LoginData.LoginPlatformNet(action)

   
end

function LoginData.LoginPlatformNet(action)

	local data = {
		--uuid = LoginData.uuid,
		channel = LoginData.channel,
		ctl = "user",
		act = action,
		email = LoginData.RegisterEmail,
		password = LoginData.RegisterPassword,
	}
    GameMain.Print(data)
	Debug.LogError("平台url PlatFormUrl".." : "..LoginData.PlatFormUrl)
--    LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.LoginPlatformCallBack", LoginData.LoginPlatformCallBack)
end
--]]
function LoginData.LoginPlatformCallBack(data , returnId)
    --LoadingPanel.StopLoadingPanel()
	GameMain.Print(data, returnId);
	--[[
	
	local t = data			
	local result = t["result"]

	if result~=nil then	
	   if result==0 then
			local token = t["data"]["token"]
			if token~=nil then
			   LoginData.token = token
			   AccountInfo.token = token
			end
			
			local uuid = t["data"]["uuid"]
			if uuid~=nil then
				LoginData.uuid = uuid
			end		
			LoginData.LoginGame()		
	  end
       if result==1 or result==1110 then
          DataUIInstance.PopTip("P4")
       end
       if result==1108 then
          DataUIInstance.PopTip("J2")
       end
       if result==1105 then
          DataUIInstance.PopTip("J3")
       end
	end
	]]--
end



--[[function LoginData.LoginGame()														--登陆游戏服务器	
	LoginData.LoginGameNet()
end

function LoginData.LoginGameNet()

	local data =
	{
		channel = LoginData.channel,
		token = LoginData.token,
		user_id = LoginData.player_id,
		sig = 1,
		version = "2.0.0",
		plat = "ohter",
		uuid = LoginData.uuid,
	}
	Debug.LogError("游戏url GameUrl".." : "..LoginData.GameUrl)
    --LoadingPanel.OpenLoadingPanel()	
	GameMain.SendHttpRequest(LoginData.GameUrl, data, "LoginData.LoginGameCallBack", LoginData.LoginGameCallBack)
end--]]

--[[LoginData.LoginSuccess = false
LoginData.Token360 = ""
LoginData.Channel360 = ""
function LoginData.LoginGameNet360(_Token , _Channel)                           --360平台返回  
    LoginData.LoginSuccess = false
    if _Token=="0" then
       LoginData.LoginSuccess = false
    else    
       LoginData.LoginSuccess = true
       LoginData.token = _Token
       AccountInfo.token = _Token
       LoginData.Token360 = _Token
       LoginData.Channel360 = _Channel
    end	
end

function LoginData.LoginGame_360()
    local data =
	{
		channel = LoginData.Channel360,
		token = LoginData.Token360,
		user_id = LoginData.player_id,
		sig = 1,
		version = "2.0.0",
		plat = "360",
		uuid = "",
	}
	
	Debug.LogError("游戏url GameUrl".." : "..LoginData.GameUrl)
--    LoadingPanel.OpenLoadingPanel()	
	GameMain.SendHttpRequest(LoginData.GameUrl, data, "LoginData.LoginGameCallBack", LoginData.LoginGameCallBack)
end
--]]
--[[function LoginData.LoginGameCallBack(data , returnId)
    LoadingPanel.StopLoadingPanel()
   
    
	local t = data
				
	local result = t["result"]
	local player_id = t["d"]["player_id"]
		if player_id~=nil then
			LoginData.player_id = player_id
			AccountInfo.player_id = player_id
		end
	local world_id = t["d"]["world_id"]
		if world_id~=nil then
			LoginData.world_id = world_id
			AccountInfo.world_id = world_id
            TalkingDataDemoScript.Ins:SetAccount(LoginData.world_id)
		end

    local Is_Create = t["d"]["is_create"]                                 --已经创建0 没创建1
    if Is_Create~=nil then
       CreatePlayerSys.Is_Create = Is_Create
    end
	--local world_id = t["d"]["player_id"]
		--AccountInfo.world_id	
	--GameMain.QuitLogin()

    LoginData.SetServerInfo() 
	GameMain.EnterCreatePlayer()
end--]]

--[[function LoginData.SetServerInfo()
     if LoginData.TempServer==nil then
        DataUIInstance.PopTip("K8")
        return
     end
     SocketClient.serverId =  LoginData.TempServer.Server_id
     PlayerPrefs.SetString("LasterServerId" , tostring(SocketClient.serverId))
     local LoginTar = MainGameUI.FindPanelTarget("UILogin")
     LoginTar:SetLatestServer()
end--]]

--[[function LoginData.RegistGame(_Email , _Password)							--注册账户事件请求z

--	LoginData.channel = "channel"
--	LoginData.uuid = PlayerPrefs.GetString("tmpuuid3");
	
	local _email=_Email
	local _passWord=_Password

	LoginData.RegisterEmail = _email
	LoginData.RegisterPassword = _passWord

	PlayerPrefs.SetString("UserName" , _email)
	PlayerPrefs.SetString("PassWord" , _passWord)
	
--	if LoginData.uuid == "" then
--		LoginData.uuid = os.date("1%M%H%S")
--		PlayerPrefs.SetString("tmpuuid3", LoginData.uuid)	
--	end

--	local action = "register"
--	LoginData.RegistNet(action)
end
function LoginData.RegistNet(action)												--注册账户的网络事件

	local data = {
		--uuid = LoginData.uuid,
		channel = LoginData.channel,
		ctl = "user",
		act = action,
		email = LoginData.RegisterEmail,
		password = LoginData.RegisterPassword,
	}
	--GameMain.Print(data, "login");
--     LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.RegistNetCallBack", LoginData.RegistNetCallBack)
	
end

function LoginData.RegistNetCallBack(data , returnId)							--注册账户的网络事件回调
    GameMain.Print(data)
	local t = data
--	LoadingPanel.StopLoadingPanel()
	local result = t["result"]
	if result~=nil then
	
	   if result==0 then
	        DataUIInstance.PopTip("J4")
			local token = t["data"]["token"]
			if token~=nil then
			   LoginData.token = token
			end
			
			local player_id = t["data"]["player_id"]
			if player_id~=nil then
				LoginData.player_id = player_id
			end

            LoginData.LoginPlatform(LoginData.RegisterEmail , LoginData.RegisterPassword)
		end
	   
	   if result==1106 then												--UUID错误
	   	
	   	  local data = {
				--uuid = LoginData.uuid .. "1",
				channel = LoginData.channel,
				ctl = "user",
				act = "register",
				email = LoginData.RegisterEmail,
				password = LoginData.RegisterPassword,
			}
		  PlayerPrefs.SetString("tmpuuid3", data.uuid)	
		  GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.RegistNetCallBack", LoginData.RegistNetCallBack)
	   	
	   end
       if result==1108 then
--          DataUIInstance.PopTip("J2")
       end
       if result==1105 then
--          DataUIInstance.PopTip("J3")
       end
	end
end--]]

LoginData.ZQPlayerId = "11111111111111111111"
LoginData = 
{
   ["ModelUrl"] = "http://114.215.92.238:10500/zqsg/app/index.php?ctl=request&act=unpack",
   ["PlatFormUrl"] = "http://114.215.92.238:10500/login/webroot/index.php",
   ["GameUrl"] = "http://114.215.92.238:10500/dhz/index.php?ctl=user&act=login"
}

--*****游客登录
--[[function LoginData.Guest()
   Debug.LogError("游客登录".." : ".."http://114.215.92.238:10500/login/webroot/index.php?ctl=user&act=guestRegister")
--   LoadingPanel.OpenLoadingPanel()

   GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/login/webroot/index.php?ctl=user&act=guestRegister" , "LoginData.ApplicationGuestCallBack", LoginData.ApplicationGuestCallBack)
end

function LoginData.ApplicationGuestCallBack(data)
   --GameMain.Print(data) 
   if data["result"]==0 then
      local guestData = data["data"]
      local Guest_Mail = tostring(guestData["guest"])
      local Guest_Word = tostring(guestData["guest_pwd"])     
      LoginData.LoginGuest(Guest_Mail , Guest_Word)
   else
      DataUIInstance.PopTip("P9")
   end
end
--]]
--[[function LoginData.LoginGuest(_Email , _PassWord)
   LoginData.channel = "channel"

   PlayerPrefs.SetString("GuestEmail" , _Email)
   PlayerPrefs.SetString("GuestPassWord" , _PassWord)

   LoginData.GuestEmail = _Email
   LoginData.GuestPassWord = _PassWord

   local action = "guestLogin"
   LoginData.LoginGuestPlatformNet(action)

end

function LoginData.LoginGuestPlatformNet(action)

	local data = {
		--uuid = LoginData.uuid,
		channel = LoginData.channel,
		ctl = "user",
		act = action,
		guest = LoginData.GuestEmail,
		guest_pwd = LoginData.GuestPassWord,
	}
   -- GameMain.Print(data)
	Debug.LogError("平台url PlatFormUrl".." : "..LoginData.PlatFormUrl)
--    LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.LoginZQPlatformNetCallBack", LoginData.LoginZQPlatformNetCallBack)
end
--]]

-----------------游客登录end

function LoginData.LoginZQPlatform(_Email , _Password)						--登陆游戏平台 返回Token uuid
	
	LoginData.channel = "channel"

	PlayerPrefs.SetString("LastEmail" , _Email)
	PlayerPrefs.SetString("LastPassword" , _Password)
	
	--[[LoginData.RegisterEmail = _Email
	LoginData.RegisterPassword = _Password--]]
	
	--[[if LoginData.uuid == "" then
		LoginData.uuid = os.date("1%M%H%S")
		PlayerPrefs.SetString("tmpuuid3", LoginData.uuid)
	end--]]
	
	local action = "login"
	LoginData.LoginZQPlatformNet(action , _Email , _Password)

end

function LoginData.LoginZQPlatformNet(action , _Email , _Password)

	local data = {
		channel = LoginData.channel,
		ctl = "user",
		act = action,
		email = _Email ,  --LoginData.RegisterEmail,
		password = _Password , -- LoginData.RegisterPassword,
	}

    
 --  GameMain.Print(data , "登陆游戏平台 返回Token uuid")
	Debug.LogError("平台url PlatFormUrl".." : "..LoginData.PlatFormUrl)
--    LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.LoginZQPlatformNetCallBack", LoginData.LoginZQPlatformNetCallBack)
end

function LoginData.LoginZQPlatformNetCallBack(data)
   -- GameMain.Print(data , "登陆返回的UUID")
    local result = data["result"]
	if result~=nil then	
		 if result==1  then
          DataUIInstance.PopTip("P4")
			return
       end
		if  result==1110 then
			DataUIInstance.PopTip("P4")
			return
		end
       if result==1108 then
          DataUIInstance.PopTip("J2")
			return
       end
       if result==1105 then
          DataUIInstance.PopTip("J3")
			return
       end
	   if result==0 then
	       -- DataUIInstance.PopTip("R6")
			local _token = data["data"]["token"]
			if _token~=nil then
			   LoginData.token = _token
			end
			
			local _uuid = data["data"]["uuid"]
			if _uuid~=nil then
				LoginData.uuid = _uuid
                --Debug.LogError("登陆返回的UUID")
                --Debug.LogError(_uuid)
			end
            LoginData.LoginZQ()       
		end
    end
end

function LoginData.LoginZQ()                            --登录游戏服务器

    local data = {
		channel ="channel",
		ctl = "user",
		act = "login",
		uuid = LoginData.uuid,	
        token = LoginData.token,
	}
   
	--Debug.LogError("平台url PlatFormUrl".." : "..LoginData.PlatFormUrl)
   -- LoadingPanel.OpenLoadingPanel()
   --GameMain.Print(data)
	local webInfo = LoginData.GetLoginWebInfo()
	Debug.LogError("登录游戏服务器"..webInfo.Url)
	GameMain.SendHttpRequest(webInfo.Url, data, "LoginData.LoginZQCallBack", LoginData.LoginZQCallBack)
end

function LoginData.LoginZQCallBack(data)
    local result = data
    --GameMain.Print(data , "LoginZQCallBack")
    local r = result["r"]
    if r==0 then
      
    end
    local d = result["d"]
    local Player_Id = d["player_id"]
    Debug.LogError(Player_Id)
    LoginData.PlayerID = Player_Id
    local Is_Created = d["is_create"]
    if Is_Created==0 then
       handleNet_Game.RequestPlayerInfo(nil)
    else
       ClinetSys.CreatePlayer()
    end
    --GameMain.Print(data , "LoginZQCallBack")
    
	
end
function LoginData.GetOwnName()				--获得已有账号的名字
    return PlayerPrefs.GetString("LastEmail")
	--LoginData.RegisterEmail = 
	--return LoginData.RegisterEmail
end

function LoginData.GetOwnPassWord()        --获得玩家账号密码
    return  PlayerPrefs.GetString("LastPassword")
	--LoginData.RegisterPassword =
	--return LoginData.RegisterPassword
end
LoginData.LoginURL = ""
LoginData.LoginServerId = 0
function LoginData.GetLoginWebInfo()		--得到上次登录的serverid
--      Url = tostring(ServerItem["url"]),
--      Status = tonumber(ServerItem["status"]),--1 正常 2 流程 3 爆满 4 维护
--      Name = tostring(ServerItem["name"]),
--      Server_id = tonumber(ServerItem["server_id"])
		local url = PlayerPrefs.GetString("LastLoginServerUrl")
		local status = PlayerPrefs.GetInt("LastLoginServerState")
		local name =  PlayerPrefs.GetString("LastLoginServerName")
		local id =  PlayerPrefs.GetInt("LastLoginServerId")
		local list = 
		{
			Name = name,
			Server_id = id,
			State = status,
			Url = url,
		}
		LoginData.LoginURL = url
		LoginData.LoginServerId = id
	
		return  list
	
end
function LoginData.RegistZQ(_Email , _Password)							--注册账户事件请求z

	LoginData.RegisterEmail = _Email
	LoginData.RegisterPassword = _Password

    PlayerPrefs.SetString("LastEmail" , _Email)
	PlayerPrefs.SetString("LastPassword" , _Password)

	--PlayerPrefs.SetString("UserName" , _Email)
	--PlayerPrefs.SetString("PassWord" , _Password)
	
	local action = "register"
	LoginData.RegistZQNet(action)

end

function LoginData.RegistZQNet(action)												--注册账户的网络事件

	local data = {
		--uuid = LoginData.uuid,
		channel = "channel",
		ctl = "user",
		act = action,
		email = LoginData.RegisterEmail,
		password = LoginData.RegisterPassword,
	}
	--GameMain.Print(data, "注册账号信息");
--     LoadingPanel.OpenLoadingPanel()
	GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.RegistZQNetCallBack", LoginData.RegistZQNetCallBack)
	
end

function LoginData.SetChooseWebInfo(Name , _Id , url , state)
	PlayerPrefs.SetString("LastLoginServerUrl" , url)
	PlayerPrefs.SetInt("LastLoginServerState" , state)
	PlayerPrefs.SetString("LastLoginServerName" , Name)
	PlayerPrefs.SetInt("LastLoginServerId" , _Id)
end

function LoginData.RegistZQNetCallBack(data , returnId)							--注册账户的网络事件回调
   -- GameMain.Print(data , "注册返回uuid")
	local t = data
--	LoadingPanel.StopLoadingPanel()
	local result = t["result"]
	if result~=nil then
	   if result==0 then
	        --DataUIInstance.PopTip("J4")
			local _token = t["data"]["token"]
			if _token~=nil then
			   LoginData.token = _token
               
			end
			
			local _uuid = t["data"]["uuid"]
			if _uuid~=nil then
				LoginData.uuid = _uuid
               -- Debug.LogError("注册返回的uuid")
                --Debug.LogError(_uuid)
			end
            LoginData.LoginZQ()                                         --注册成功 直接登录游戏服务器
			return
		end
	   
	   if result==1106 then												--UUID错误
	   	
	   	  local data = {
				--uuid = LoginData.uuid .. "1",
				channel = LoginData.channel,
				ctl = "user",
				act = "register",
				email = LoginData.RegisterEmail,
				password = LoginData.RegisterPassword,
			}
		  PlayerPrefs.SetString("tmpuuid3", data.uuid)	
		  GameMain.SendHttpRequest(LoginData.PlatFormUrl, data, "LoginData.RegistZQNetCallBack", LoginData.RegistZQNetCallBack)
			return
	   end
		
    
		 if result==1  then
          DataUIInstance.PopTip("P4")
			return
       end
		if  result==1110 then
			DataUIInstance.PopTip("P4")
			return
		end
       if result==1108 then
          DataUIInstance.PopTip("J2")
			return
       end
       if result==1105 then
          DataUIInstance.PopTip("J3")
			return
       end
		DataUIInstance.PopTip("用户名长度为6～16字符")
	end
end


function LoginData.GetBroad()
	 Debug.LogError("公告URL".." : ".."http://114.215.92.238:10500/notice/zqtx/0.8.5.html")
   LoadingPanel.OpenLoading()
   GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/notice/zqtx/0.8.5.html" , "LoginData.GetBroadCallBack", LoginData.GetBroadCallBack) 
end
LoginData.BroadText = 
{
}

function LoginData.GetBroadCallBack(data)
  --  GameMain.Print(data , "Broad")
    local Count = #data
    for i = Count , 1 , -1 do
        if LoginData.BroadText[i]==nil then
           LoginData.BroadText[i] = {}
        end
        LoginData.BroadText[i].Content = data[i].content
        LoginData.BroadText[i].Title = data[i].title
        LoginData.BroadText[i].Id = data[i].Id
    end
    local UIChooseWebTar = MainGameUI.FindPanelTarget("UIChooseWeb")
    UIChooseWebTar:SetBroad()
    LoadingPanel.StopLoading()
end


function LoginData.GetServerList()                                           --获取服务器列表
   if #LoginData.ServerList >0 then
	 local UIChooseWebTar = MainGameUI.FindPanelTarget("UIChooseWeb")
		UIChooseWebTar:ShowWeb()
	return
   end  

   Debug.LogError("服务器列表 ServerListUrl".." : ".."http://114.215.92.238:10500/svrList/zqtx_0.8.5.html")
   LoadingPanel.OpenLoading()


  GameMain.SendHttpRequestNormal("http://114.215.92.238:10500/svrList/zqtx_0.8.5.html" , "LoginData.GetServerListCallBack", LoginData.GetServerListCallBack)  --线上
end

LoginData.ServerList = {}
function LoginData.GetServerListCallBack(data)
   GameMain.Print(data)
   LoginData.ServerList = {}
   if data["r"]==0 then
      local ServerList = data["msg"][1]["d"]["srv"]
      local ServerCount = #ServerList
      for i = ServerCount , 1 , -1 do
          local ServerItem = ServerList[i]
          local data =
          {
             Url = tostring(ServerItem["url"]),
             Status = tonumber(ServerItem["status"]),--1 正常 2 流程 3 爆满 4 维护
             Name = tostring(ServerItem["name"]),
             Server_id = tonumber(ServerItem["server_id"])
          }
          LoginData.ServerList[i] = data
      end
		local list = LoginData.GetLoginWebInfo()
		if list.Server_id == 0 then
			local initShowWebInfo = LoginData.ServerList[1]
			LoginData.SetChooseWebInfo(initShowWebInfo.Name , initShowWebInfo.Server_id , initShowWebInfo.Url , initShowWebInfo.Status)
		end
--      DataUIInstance.CreateLoginUI(LoginData.CreateUILoginCallBack)												--创建注册界面    
		local UIChooseWebTar = MainGameUI.FindPanelTarget("UIChooseWeb")
		UIChooseWebTar:GetServerListCallBack()
   end
end

return LoginData