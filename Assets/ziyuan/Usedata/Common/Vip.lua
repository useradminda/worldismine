--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Vip = {}
Vip.__index = Vip

Vip.Lvl = 0			--VIP等级
Vip.VipExp = 0		--vip经验
Vip.HeroLimit = 0	--拥有武将个数
Vip.TrainLimit = 0	--训练队列
Vip.EngeryLimit = 0	--军令上限
Vip.VoteLimit = 0	--选票1票顶几票
Vip.ExpertTrain = 0	--专家训练
Vip.Sweep = 0		--扫荡
Vip.SeniorSmelt = 0	--高级冶炼
Vip.SeniorEnlist = 0--高级招募
Vip.BuyCall = 0		--购买征召令
Vip.ReWard = ""		--每日礼包
Vip.Description = ""--描述
Vip.CloseTime = 0
Vip.LuckLimit = 0 

function Vip:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Vip:Init(_Data)
	self.Lvl = _Data.Id
	self.VipExp = _Data.VipExp
	self.HeroLimit = _Data.HeroLimit
	self.TrainLimit = _Data.TrainLimit
	self.EngeryLimit = _Data.EngeryLimit
	self.VoteLimit = _Data.VoteLimit
	self.ExpertTrain = _Data.ExpertTrain
	self.Sweep = _Data.Sweep
	self.SeniorSmelt = _Data.SeniorSmelt
	self.SeniorEnlist = _Data.SeniorEnlist
	self.BuyCall = _Data.BuyCall
	self.ReWard = _Data.Reward
	self.Description = _Data.Description
	self.CloseTime = _Data.CloseTime
	self.LuckLimit = _Data.LuckLimit
end

return Vip
--endregion
