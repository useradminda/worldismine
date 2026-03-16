ClinetSys = {}
ClinetSys.Xing = {}
ClinetSys.Ming = {}

function ClinetSys.CreatePlayer()  
   WebEvent.CreatePlayer(tostring(LoginData.PlayerID) , "ClinetSys.CreatePlayerCallBack" , ClinetSys.CreatePlayerCallBack)
end

function ClinetSys.CreatePlayerCallBack(_data , _returnId)
   handleNet_Game.RequestPlayerInfo(nil)
end

ClinetSys.CreateNameCB = nil
function ClinetSys.CreateNameGuide(_Name , _CB) 
   ClinetSys.CreateNameCB = _CB
   WebEvent.SetNamePlayer(_Name , "ClinetSys.CreateNameGuideCallBack" , ClinetSys.CreateNameGuideCallBack)
end

function ClinetSys.CreateNameGuideCallBack(_data , _returnId) 
   
   if _returnId==0 then
      ClinetSys.CreateNameCB()
      ClinetSys.CreateNameCB = nil
      local UIPlayerInfoTar = MainGameUI.FindPanelTarget("UIPlayerInfo")
      if UIPlayerInfo ~= nil then
	     UIPlayerInfo:ShowSetNameAfter(_returnId)
      end
   elseif _returnId==3 then
      DataUIInstance.PopTip("W2")
   end
end

function ClinetSys.JudgeName(Name)
    if Name == "" then
		DataUIInstance.PopTip("X3")
		return false
	end

    local count = GameMain.GetStrByteCount(Name)
	if count>14 then
		DataUIInstance.PopTip("X4")
		return false
	end

    local isHasKey = lgNoDelCsFun.Ins:JudgeName(Name)
    if isHasKey==false then
       DataUIInstance.PopTip("Y5")
       return false
    end

    local isPass = lgNoDelCsFun.Ins:CheckBanWord(Name , UIstring.Banwords)
    if isPass==false then
       DataUIInstance.PopTip("Y6")
       return false
    end

    return true
end

function ClinetSys.GetXing()
    if #ClinetSys.Xing ==0 then
       ClinetSys.Xing = GameMain.StringSplit(UIstring.Xing1 , ",")
    end
    math.randomseed(os.time())
    local _Xing = math.random(1 , #ClinetSys.Xing)

    return ClinetSys.Xing[_Xing]
end

function ClinetSys.GetMing()
    if #ClinetSys.Ming ==0 then
       ClinetSys.Ming = GameMain.StringSplit(UIstring.Ming1 , ",")
    end
    math.randomseed(os.time())
    local _Ming = math.random(1 , #ClinetSys.Ming)
    return ClinetSys.Ming[_Ming]
end

return ClinetSys