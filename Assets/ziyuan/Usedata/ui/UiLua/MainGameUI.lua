
MainGameUI = {}													--界面管理器 总控制 记录当前打开哪个界面状态

local this = MainGameUI

MainGameUI["InitLoadUI"] = {"UIControl" , "UILogin"}


MainGameUI["UIEvent"] = {}										 --存储生成的Lua界面的生成类对象的UI事件的方法
MainGameUI["UIDragUpEvent"] = {}							     --存储生成的Lua界面的生成类对象的UI拖动抬起事件的方法
MainGameUI["UIDragEvent"] = {}                                   --存储生成的Lua界面的生成类对象的UI拖动事件的方法
MainGameUI["UIOnPress"] = {}                                     --存储生成的Lua界面的生成类对象的UI按下抬起事件
MainGameUI["target"] = {}										 --存储生成的Lua界面的生成类的对象 可以通过LUA脚本名称搜索 Lua对象 调用对象方法z
MainGameUI["GameObject"] ={}									 --存储生成的实体的界面GOB 可以通过调用界面名称获取GOB 可以通过GETComponent获取物体上面的组件（basepanel）

MainGameUI.LastPanelTar = nil
MainGameUI.NowPanelTarget = nil										--保存当前打开界面的对应的lua的类对象
MainGameUI.PanelOpenName = "null"                                     --当前开启界面的名字 状态
MainGameUI.PanelOpenGob = nil                                       	 --当前开启的界面 可Get所有脚本

function MainGameUI.OpenOnePanel(_LuaName , _PanelName , _PrefabName , _father , _Cb ,_data)				--切换大界面（如果场景只允许存在一个大界面，重叠在上面的都是小界面） 处理界面事件的LUA名称 ，创建的界面名称 ， 创建界面的prefab ， 界面挂载的父亲 创建某个界面的函数
    
	local data =
	{
		LuaName = _LuaName,
		PanelName = _PanelName,
		Father = _father,
		CallBack = _Cb,
		data = _data,
	}
	--LoadingPanel.OpenLoadingBigPanel()
    if MainGameUI["GameObject"][_PanelName]==nil then
	   ResourceManager.LoadAssetByObjectUI(data , _PrefabName , MainGameUI.OpenOnePanelCallback)
    else
       MainGameUI.OpenOnePanelCallback(data , nil)
    end	
end

function MainGameUI.OpenOnePanelCallback(data , prefab)
    --GameMain.Print(data , "OpenOnePanelCallback")
	local _LuaName = data.LuaName
	local _PanelName = data.PanelName
	local _father = data.Father
	local _CallBack = data.CallBack
	local _data = data.data
	
	if MainGameUI.GameObject[_PanelName]==nil then										--表内没有界面的GOB 生成并储存z
	   if prefab==nil then
          Debug.LogError(_PanelName)
	   	  return
	   end
	   local Gob = GameObject.Instantiate(prefab,Vector3.zero,Quaternion.identity)
	   if _father~=nil	then
       	  Gob.transform.parent = _father.transform
       end
       Gob.transform.localPosition = Vector3(0 , 0 , -100)
       Gob.transform.localScale = Vector3.one
       Gob.name = _PanelName
	   MainGameUI.GameObject[_PanelName] = Gob
	end	
	
	if MainGameUI["target"][_LuaName]==nil then
		local lua = GameMain.requireLuaFile(_LuaName)
		local obj1 = lua:new()
	   	MainGameUI["target"][_LuaName] = obj1
        if _LuaName~="UIPopPanel" then
           if MainGameUI.NowPanelTarget~=nil then
              MainGameUI.LastPanelTar = MainGameUI.NowPanelTarget
           end
	       MainGameUI.NowPanelTarget = obj1
        end
	else
        if _LuaName~="UIPopPanel" then
           if MainGameUI.NowPanelTarget~=nil then
              MainGameUI.LastPanelTar = MainGameUI.NowPanelTarget
           end
		   MainGameUI.NowPanelTarget = MainGameUI["target"][_LuaName]
        end
	end
	
	local tempGob = MainGameUI.GameObject[_PanelName]
  	tempGob:SetActive(true)																--打开新界面
    local target = MainGameUI["target"][_LuaName]	
    target:OpenUI(_PanelName , _LuaName , _data)												--调用打开界面的OpenUI方法						

    if _LuaName~="UIPopPanel" then
	   MainGameUI.PanelOpenName = _PanelName															--记录打开界面的名字z
	end
	
	if _CallBack~=nil then
		_CallBack(_data)
	end

    --LoadingPanel.StopLoadingBigPanel()
end

function MainGameUI.InitMainUI()
    if MainGameUI.PanelOpenName=="UILogin" then
       return
    end
    if MainGameUI.PanelOpenName=="UICreatePlayer" then
       return
    end
    if MainGameUI.PanelOpenName=="UIBattle" then
       return
    end
    if MainGameUI.PanelOpenName=="UIControl" then
       return
    end
    local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
    if UIControlTar~=nil then
       MainGameUI.NowPanelTarget = UIControlTar										--保存当前打开界面的对应的lua的类对象
       MainGameUI.PanelOpenName = "UIControl"                                     --当前开启界面的名字 状态
    end
end

function MainGameUI.ReleaseAllPanel()													--释放所有界面 和初始化界面 删除界面OBJz 释放主城所有实例
    if lgChatMag.Ins~=nil then
       lgChatMag.Ins:CloseChat(true)
    end
    GameMain.Release()
    AtlasMsg.Rlease()
    WorldMapSys.Release()
    PlayerControl.ReleaseMyCharacter()
    PlayerControl.Release()
    WorldMapEventSys.Release()
    MainGameUI.UIBattleCamera = nil
    MainGameUI.UIMainCityCamera = nil
    MainGameUI.MainCity = nil
	LoadingPanel.Release()
	for key, value in pairs(MainGameUI["target"]) do
        if value~=nil then         
          -- value:InitNet()
           value:ReleasPanel()
        end
        MainGameUI["target"][key] = nil      
	end

    MainGameUI["target"] = {}									


	for key , value in pairs(MainGameUI.GameObject) do
        GameObject.Destroy(MainGameUI.GameObject[key])
        MainGameUI.GameObject[key] = nil     
	end

    MainGameUI["UIEvent"] =											
    {
    }

    MainGameUI["UIDragUpEvent"] =										
    {
    }

    MainGameUI["UIDragEvent"] =                                   
    {   
    }

    MainGameUI["UIOnPress"] =                                     
    {   
    }

    MainGameUI["GameObject"] = 
    {
    }
   
	MainGameUI.PanelOpenName = "null"
    MainGameUI.NowPanelTarget = nil
    MainGameUI.PanelOpenGob = nil
    Create3DModel.Rlease()
    --LoadingPanel.RleasePanel()
    
    --PlayerControl.Release()

   -- DataUIInstance.CreateBattleUIOn = false

end

function MainGameUI.InitPanelNet()          --初始化界面的网络事件
    for key, value in pairs(MainGameUI["target"]) do
        if value~=nil then
           value:InitNet()
        end  
	end

	local ChatPanel = MainGameUI.FindPanelTarget("UIChat") 
    if ChatPanel~=nil then
	   ChatPanel:SwitchAccount()
    end
end

--参数含义 生成的物体的名字 prefab名字 父亲级 生成WWW的回调 生成物体字级是否有BOX自动添加某个脚本的事件
function MainGameUI.CreateLittleItem(_ItemName , _prefabName , _father , _data , _Cb , _panelName)					--创建普通的Gob 返回长剑GOB 如果参数有误再自行调整
    --LoadingPanel.OpenLoadingPanel()   
    local datainfo =
	{
		ItemName = _ItemName,
		Father = _father,
		Info = _data,
		Cb = _Cb,
		PanelName= _panelName,
        PrefabName = _prefabName,
	}
	ResourceManager.LoadAssetByObjectUI(datainfo , _prefabName , MainGameUI.CreateLittleItemCallback)
end

function MainGameUI.CreateLittleItemCallback(data , prefab)

	   local ItemName = data.ItemName
	   local father = data.Father
	   local Info = data.Info
       
       if prefab==nil then
          Debug.LogError("prefab为空 名字为:")
          Debug.LogError(data.PrefabName)
          return
       end

	   local Gob = GameObject.Instantiate(prefab,Vector3.zero,Quaternion.identity)

	   if father~=nil and lgNoDelCsFun.Ins:CheckObjIsNull(father.gameObject)==false then        
       	  Gob.transform.parent = father.transform
       end

       Gob.transform.localPosition = Vector3.zero
       Gob.transform.localScale = Vector3.one
       Gob.name = ItemName
       
       if data.PanelName~=nil then
	       local PanelName = MainGameUI.FindPanel(data.PanelName)
	       if PanelName~=nil then
			  local basePanel = PanelName:GetComponent("BasePanel")
--				if basePanel ~= nil then
					basePanel:AddUIEvent(Gob.transform)
--				end
			  
		   end
	   end
       
       if data.Cb~=nil then
       	  data.Cb(nil , Gob , Info)
       end
       --LoadingPanel.StopLoadingPanel()
end



function MainGameUI.FindPanel(PanelName)												--返回保存的界面GameObject
	if MainGameUI["GameObject"][PanelName]~=nil then
	   return MainGameUI["GameObject"][PanelName]

	end
	return nil
end

function MainGameUI.FindPanelTarget(PanelTarget)										--返回保存的继承BasePanel类对象z
	if MainGameUI["target"][PanelTarget]~=nil then
	   return MainGameUI["target"][PanelTarget]
	end
	return nil
end



MainGameUI.UIBattleCamera = nil
function MainGameUI.GetUICameraInBattle()												--找寻战斗场景的UIcamera
	local BattlePanel = this.FindPanel("UIBattle")
    if MainGameUI.UIBattleCamera==nil then
	    if BattlePanel~=nil then
		    local UIcamera = BattlePanel.transform:FindChild("Camera"):GetComponent("UICamera")
            MainGameUI.UIBattleCamera = UIcamera
		    return MainGameUI.UIBattleCamera
	    else
		    return nil
	    end
    else
       return MainGameUI.UIBattleCamera
    end
end

MainGameUI.UIMainCityCamera = nil
function MainGameUI.GetUICameraInMainCity()												--找寻主城场景的UIcamera
	local MainCityPanel = this.FindPanel("UIControl")
    if MainGameUI.UIMainCityCamera==nil then
	    if MainCityPanel~=nil then
		    local UIcamera = MainCityPanel.transform:FindChild("Camera"):GetComponent("UICamera")
            MainGameUI.UIMainCityCamera = UIcamera
		    return MainGameUI.UIMainCityCamera
	    else
		    return nil
	    end
    else
       return MainGameUI.UIMainCityCamera
    end
end

MainGameUI.MainCity = nil
function MainGameUI.GetMainCameraInUICity()
   if MainGameUI.MainCity==nil then
      MainGameUI.MainCity = GameObject.Find("Main Camera").gameObject
   end
   return  MainGameUI.MainCity
end

function MainGameUI.InitUIPanel()

   if MainGameUI["target"]["UIControl"]==nil then
		local lua = GameMain.requireLuaFile("UIControl")
		local obj1 = lua:new()
	   	MainGameUI["target"]["UIControl"] = obj1      
   end
   if MainGameUI["GameObject"]["UIControl"]==nil then
      MainGameUI["GameObject"]["UIControl"] = GameObject.Find("UIControl").gameObject
   end
   MainGameUI["target"]["UIControl"]:OpenUI()

   local UIControl = MainGameUI.FindPanelTarget("UIControl")

   if MainGameUI["target"]["UILogin"]==nil then
		local lua = GameMain.requireLuaFile("UILogin")
		local obj1 = lua:new()
	   	MainGameUI["target"]["UILogin"] = obj1      
   end
   if MainGameUI["GameObject"]["UILogin"]==nil then    
      MainGameUI["GameObject"]["UILogin"] = UIControl.AnchorCenter:FindChild("UILogin").gameObject
   end


end

return MainGameUI