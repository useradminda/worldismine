HeartJump = {}                                      --心跳包
HeartJump.HJtime = 30
HeartJump.NowTime = 0

function HeartJump.Init()
   GameMain.AddUpdateLua(HeartJump.UpdateHeartJump)
end

function HeartJump.SendHeartJump()
    local _Info = nil
    WebEvent.HeartJump(_Info , "HeartJump.SendHeartJumpCallBack" , HeartJump.SendHeartJumpCallBack)
end

function HeartJump.SendHeartJumpCallBack(data , _returnId)
    
end

function HeartJump.ResetHeartJump()
   HeartJump.NowTime = 0
end

function HeartJump.SavePower()                      --定时发送战斗力
   local _info = ClinetInfomation.Fight
   WebEvent.SavePower(_info , "HeartJump.SavePowerCallBack" , HeartJump.SavePowerCallBack)
end

function HeartJump.SavePowerCallBack(data , _returnId)
    
end

function HeartJump.UpdateHeartJump(dt)
   HeartJump.NowTime = HeartJump.NowTime + dt
   if HeartJump.NowTime > HeartJump.HJtime then
      HeartJump.NowTime = 0
      HeartJump.SendHeartJump()
      HeartJump.SavePower()
   end  
end

function HeartJump.Release()
   HeartJump.NowTime = 0
   GameMain.DelUpdateLua(HeartJump.UpdateHeartJump)
end

return HeartJump
