Technology = {}											
Technology.__index = Technology

Technology.Dbid = 0
Technology.Name = ""
Technology.DesCription = ""
Technology.Type = 0			--1武将 2小兵
Technology.Class = 0		--1 PVE武将出战人数 2 pvp武将出站人数 3 国战移动速度 4 武将训练位置 5 士兵进阶
Technology.Next_Id = 0		--下一个激活的Id
Technology.PreId = 0		--上一个已经完成的id
Technology.Show_Lvl = 0		--显示的等级
Technology.Learn_Lvl = 0	--研究的等级
Technology.Need_Money = 0	--需要花费的money
Technology.Times = 0		--需要的次数
Technology.LearnTime = 0	--研究需要的总时间
Technology.LimitNum = 0		--限制的数目
Technology.AtlasName = ""
Technology.SpriteName = ""

Technology.EndTime = 0		--当前研究结束的时间戳
Technology.PourTime = 0		--注资的当前次数

Technology.State = 0		--初始状态 0不相关，1 下一个操作的对象

function  Technology:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Technology:Init(_Data , _Progress , _EndTime)
   self.Dbid = _Data.Id
   self.Name = _Data.Name
   self.Class = _Data.Class
   self.Next_Id = _Data.Next_Id
   self.Show_Lvl = _Data.Show_Lvl
   self.Learn_Lvl = _Data.Learn_Lvl
   self.Need_Money = _Data.Need_Money
   self.Times = _Data.Times
   self.LearnTime = _Data.Need_Time
   self.DesCription = _Data.Description
   self.Type = _Data.Type
   self.LimitNum = tonumber(_Data.Result)
   self.AtlasName = _Data.AtlasName
   self.SpriteName = _Data.SpriteName
   self.PreId = _Data.PreId

   self.EndTime = _EndTime 
   self.PourTime = _Progress
   self.State = 0
   self:SetInfo(self.PourTime , self.EndTime)
end

function Technology:SetInfo(_PourTimes , _EndTime)
   self.EndTime = _EndTime
   self.PourTime = _PourTimes
 
   if _EndTime ~=0 then
	  self:SetTime()
   end
end

function Technology:SetTime()
	local CurTime = ClinetInfomation.WorldTime
	local endTime = self.EndTime

	if  CurTime <endTime then
		local timeName = "TechStudyTime" .. tostring(self.Dbid)
		
		TimeControl.LoginTime(endTime-CurTime, timeName)
		self.State =3
	end
end

function Technology:SetState()
	self.State = 1
end

--初始状态 1可投资 2 可研究 3研究中 4 研究完成
function Technology:GetState()				--得到它的状态
	if self.State == 1 and self.PourTime == 0 then
		return 1
	end
	if self.PourTime == 0 then
		self.State =0 
		return 0
	end
	if self.PourTime<self.Times then
		self.State =1 
		
		return	1
	end
	if self.PourTime == self.Times then
		if self.EndTime == 0 then
			self.State =2 
			return 2
		end
		local curTime = ClinetInfomation.WorldTime
		if curTime>=self.EndTime then
			if self.Next_Id ~=0 then
				TechnologyDataSys.SetNextDataState(self.Next_Id , self.Class)
			end
			self.State =4 
			return 4
		end

		if  curTime<self.EndTime then
			self.State =3
			return 3
		end
	end
end

--是否研究结束
function Technology:IsComplete()
	local curTime = ClinetInfomation.WorldTime
	if self.PourTime>= self.Times and curTime>=self.EndTime then
		return true
	end
	return false
end

function Technology:PourMoney()			--投资
	TechnologySys.PourMoneyToTech(self)
end

function Technology:StudyTech()			--研究
	TechnologySys.StudyTech(self.Dbid)
end
return Technology