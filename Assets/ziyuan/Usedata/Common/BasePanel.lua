BasePanel = {}                                                                      --界面基类
BasePanel.__index = BasePanel

BasePanel.name = nil
BasePanel.NetInit = false

function  BasePanel:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function BasePanel:OpenUI(_PanelName , _LuaName)
Debug.Log(_PaenlName .. _LuaName .. "Dont Have OpenUI Event")
	
end

function BasePanel:UIHand(_LuaName , _Gob)
	Debug.Log(_LuaName .. "")
	Debug.Log("Click the" .. _Gob.name .. "Button Have No HandDle Event！！" .. _Gob.name)
end


function BasePanel:ReleasPanel()               									 --退出界面时释放和界面初始化
	Debug.Log("SomePanel Don't have RelasePanel ")
end

function BasePanel:InitMainUI()  
    MainGameUI.InitMainUI()
end

function BasePanel:InitNet()
    
end

function BasePanel:ReleasData()

end

return BasePanel