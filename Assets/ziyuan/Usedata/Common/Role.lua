Role = {}											--人物属性基类
Role.__index = Role

Role.roleData =	nil									--人物数据库信息
Role.Dbid = 0
Role.nickname = ""									--人物姓名
Role.AtlasName = ""                                 --头像Atlas
Role.SpriteName = ""                                --头像Sprite
Role.realId = 0										--realid
Role.isActivated = 0							    --0表示没有 1表示有 是否已经获得
Role.lvl = 0                                        --等级
Role.quality = 0                                    --品质
Role.qualityLvl = 1                                 --品阶等级
Role.Fight = 0                                      --战斗力指

Role.HorseId = 0                                    --骑行的宝宝的ID
Role.UUID = ""                                     --唯一性
Role.AttackType = nil								--攻击类型
Role.AttackRange = 0								--攻击距离
Role.ModelName = ""									--模型名字
Role.AdvanceId = 0									--进阶后的下一个ID

Role.RoleType = 0									--角色类型 1-盾,2-铁锤,3-藤甲兵,4-雪人,5-碾车,6-弓,7-炮,8-弩,9-弩车,10-投石,11-锤,12-酒鬼,13-枪兵,14-骑兵,15-野人,98-神兽,99-英雄,100-城堡
Role.Aptitude = 0									--角色资质
Role.nowsitzuoqipname = nil
Role.IsUp = false                                   --是否上阵
Role.IsGuaShuai=false                               --是否挂帅
Role.RoleSeries=0                                   --角色类别 1-弓，2-盾，3-枪，4-特殊
Role.DefaultSoldier = 0
Role.IsJieGu = false								--是否解雇 

Role.UpGradeNum = 0									--进阶需要的材料数目			
Role.UpGradeCost = 0								--进阶的花费数目

Role.SkillId = 0									--英雄技能（onely one）

Role.Exp = 0										--所有的经验总和

Role.Prop = {}
Role.EquipProp = {}

Role.Equips = {}

Role.BattlePower = 0								--武将和小兵的战斗力

Role.BeginTime = 0									--训练开始的时间
Role.EndTime = 0									--训练结束的时间
Role.TrainType = 0									--训练的类型 0 没有训练； 1 普通训练； 2 高级训练； 3 Vip训练
Role.TrainOriTime = 0								--请求后的初始时间

Role.People = 0
Role.Description = nil								
Role.Sound = ""										--播放的声音

function  Role:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Role:Init(_RoleDBdata , _QualityLvl , _UUID , _IsActive , _Exp , _BeginTime , _EndTime , _Type)
   
    if _UUID==nil then
       self.UUID = "0"
	   
    else
		self.IsUp = false 
		local pveList = TeamSys.GetPveHeros()
		for key,value1 in pairs(pveList)  do
			if _UUID == value1.UUID then
				self.IsUp = true 
			end
		end
       self.UUID = _UUID
	   self.Equips = {}
    end
	self.AdvanceId = _RoleDBdata.AdvanceId
    if _QualityLvl==nil then
       self.qualityLvl = 0
    else
       self.qualityLvl = _QualityLvl
	   self.SkillId = _RoleDBdata.Spell_Id

    end

	if _Exp~=nil then
		self.Exp = _Exp
	else
		self.Exp = 0
	end

	if _RoleDBdata.AdvancedNeed ~= 0 then
		self.UpGradeNum = tonumber(_RoleDBdata.AdvancedNeedMat)
		self.UpGradeCost = tonumber(_RoleDBdata.AdvancedNeedCost)
	end

    self.AttackType = _RoleDBdata.AttackType
	self.AttackRange =_RoleDBdata.AttackRange
	self.People = _RoleDBdata.People
	self.Description = _RoleDBdata.Description
--	self.IsUp = false                                   --是否上阵
	self.IsGuaShuai=false                               --是否挂帅
    self.isActivated = _IsActive
    self.lvl = 1
    self.nickname = _RoleDBdata.Name
    self.nowsitzuoqipname = ""
    self.Dbid = _RoleDBdata.Id

	self.RoleSeries=_RoleDBdata.RoleSeries				--只有小兵存在
    self.DefaultSoldier = _RoleDBdata.DefaultSoldier
	self.quality = _RoleDBdata.Quality
    self.AtlasName = _RoleDBdata.AtlasName
    self.SpriteName = _RoleDBdata.SpriteName
	self.ModelName = _RoleDBdata.FbxName
	self.RoleType = _RoleDBdata.RoleType
	self.Sound = _RoleDBdata.Sound
	self.Aptitude = _RoleDBdata.Aptitude
	self.roleData = _RoleDBdata


	if _Type~=nil then
		self.TrainType = _Type
	else
		self.TrainType = 0
	end

	if _BeginTime~=nil then
	
		self:SetInitTrainTime(_BeginTime , _EndTime)
	else
		self.TrainOriTime = 0
		self.BeginTime = 0
		self.EndTime = 0
	end
end

function Role:SetInitTrainTime(_BeginTime , _EndTime)			--设置训练的初始化时间
	self.BeginTime = _BeginTime
	self.EndTime = _EndTime
	
	local curTime = ClinetInfomation.WorldTime
	
	if self.UUID == "0" then
		--小兵
		local timeName = "Train" .. self.Dbid
		
		TimeControl.LoginTime(self.EndTime - curTime , timeName)
	else
		local timeName = "Train" .. self.UUID
		
		TimeControl.LoginTime(self.EndTime - curTime , timeName)
	end
end

function Role:IsTrain()						--是否在训练
	if self.TrainType~=0 then
		local curTime = ClinetInfomation.WorldTime
		if curTime>=self.EndTime then
			return false
		else
			return true
		end
	end
	return false
end

function Role:InitEquips(_Equips)
	if _Equips ==nil then
		return
	end
	local list = _Equips
	for key,value in pairs(list) do
		
		self.Equips[tonumber(key)] = value
		
		EquipSys.AddHeroEquip(value)
	end
     
	

end

function Role:UpPveHero()		--出战
	self.IsUp=true
    TeamSys.UpPveHero(self)
end

function Role:RePveHero()		--侯战
	self.IsUp=false
	TeamSys.RePveHero(self)
end

function Role:UpPvpHero()  --挂帅
	self.IsGuaShuai=true
	HeroPackageSys.SavePvPHeros(self.UUID)
end
function Role:DownPvpHero() --下帅
	self.IsGuaShuai=false
end

function Role:RePvpHero(uuid)  --解雇
	self.IsJieGu =true
	self.IsUp =false
	self.IsGuaShuai =false
	TeamSys.RePveHero(self)
	HeroPackageSys.FirePVPHero(self.UUID , uuid)
end

function Role:SetGuaShuaiHero(uuid)		--是否是挂帅武将
	if uuid == self.UUID then
		self.IsGuaShuai = true
	else
		self.IsGuaShuai = false
	end
end
--得到不同的成长值
function Role:GetAtkGrowStr()
	local list = self.roleData.AttackList
	if tonumber(list[4]) == 0 then
		return ""
	else
		return "("..list[4] .. ")"
	end
	
end

function Role:GetLifeGrowStr()
	local list = self.roleData.LifeList
	if tonumber(list[4]) == 0 then
		return ""
	else
		return "("..list[4] .. ")"
	end
end
function Role:GetAtkSpeedGrowStr()
	local list = self.roleData.MoveSpeedList
	if tonumber(list[4]) == 0 then
		return ""
	else
		return "("..list[4] .. ")"
	end
end

function Role:GetAtkGrowValue()
	local list = self.roleData.AttackList
	if tonumber(list[4]) == 0 then
		return 0
	else
		return tonumber(list[4])
	end
end

function Role:GetLifeGrowValue()
	local list = self.roleData.LifeList
	if tonumber(list[4]) == 0 then
		return 0
	else
		return tonumber(list[4])
	end
end

function Role:GetAtkSpeedGrowValue()
	local list = self.roleData.MoveSpeedList
	if tonumber(list[4]) == 0 then
		return 0
	else
		return tonumber(list[4])
	end

end

function Role:GetLife()			--得到生命值
	local lifeList = self.roleData.LifeList
    self.EquipProp = {}
    self.EquipProp = self:GetEquipBattleValue()
    local life = self.EquipProp["Hp"] + CalculateRoleProp.CalculationAttr(lifeList, self.qualityLvl ,self.lvl)
	return	life--CalculateRoleProp.CalculationAttr(lifeList, self.qualityLvl ,self.lvl)
end
--移速，攻速，防御
function Role:GetAtk()			--得到攻击值
	local atkList = self.roleData.AttackList
    self.EquipProp = {}
    self.EquipProp = self:GetEquipBattleValue()
    local attack = self.EquipProp["Atk"] + CalculateRoleProp.CalculationAttr(atkList, self.qualityLvl ,self.lvl)
	return attack--CalculateRoleProp.CalculationAttr(atkList, self.qualityLvl ,self.lvl)
end

function Role:GetMoveSpeed()	--得到移动速度 
	local moveSpeedList = self.roleData.MoveSpeedList
    
	return CalculateRoleProp.CalculationAttr(moveSpeedList, self.qualityLvl ,self.lvl)
end

function Role:GetAtkSpeed()		--得到攻击速度
	local attackSpeedList = self.roleData.AttackSpeedList
    self.EquipProp = {}
    self.EquipProp = self:GetEquipBattleValue()
    local AtkSpeed = self.EquipProp["AtkSpeed"] + CalculateRoleProp.CalculationAttr(attackSpeedList, self.qualityLvl ,self.lvl)
	return AtkSpeed--CalculateRoleProp.CalculationAttr(attackSpeedList , self.qualityLvl ,self.lvl)
end

function Role:GetDefence()		--得到防御值
	local defenceList = self.roleData.DefenceList
	return CalculateRoleProp.CalculationAttr(defenceList , self.qualityLvl ,self.lvl)
end

function Role:GetBattlePower()		--得到武将(包括身上的装备)或者小兵的战斗力
	if self.UUID == "0" then
		--小兵
		self.BattlePower = CalculateRoleProp.FightTypes.SoliderBasicValue[self.RoleType]*self.lvl
	else
		--武将
		if #self.Equips ~=0 then
			for key,value in pairs(self.Equips) do
				local equip =  EquipSys.FindEquipByUUID(value)
				if equip~=nil then
					self.BattlePower = self.BattlePower +equip:GetBattlePower()
				end
			end
		end
		self.BattlePower = CalculateRoleProp.FightTypes.HeroBasicValue[self.quality]*self.lvl
	end
	return self.BattlePower
end

function Role:GetNextAtkSpeed()		--得到下一个品阶攻击速度
	local attackSpeedList = self.roleData.AttackSpeedList
	return CalculateRoleProp.CalculationAttr(attackSpeedList , self.qualityLvl+1 ,self.lvl)
end

function Role:GetNextLife()			--得到下一个生命值
	local lifeList = self.roleData.LifeList
	return	CalculateRoleProp.CalculationAttr(lifeList, self.qualityLvl+1 ,self.lvl)
end
--移速，攻速，防御
function Role:GetNextAtk()			--得到下一个攻击值
	local atkList = self.roleData.AttackList
	return CalculateRoleProp.CalculationAttr(atkList, self.qualityLvl+1 ,self.lvl)
end


function Role:UpandDownEquip()				--穿卸装备与服务器交互
    EquipSys.UpDownEquip(self)
end

function Role:DressUpEquip(_UUID , _Type , _IsDress)    --本地穿卸装备数据，用来显示用 _IsDress 是否穿戴 0穿戴 1卸载
	if _IsDress == 0 then
		self.Equips[_Type] = _UUID

	else
		self.Equips[_Type] = nil
	end
end	


function Role:GetEquipBattleValue()	--得到穿戴装备的属性值
	local list = 
	{
		["Atk"] = 0,
		["Hp"] = 0,
		["AtkSpeed"] =0,
	}
	local atk = 0
	local hp = 0
	local atkSpeed = 0
	for key,value in pairs(self.Equips) do
		local equip = EquipSys.FindEquipByUUID(value)
		if equip~=nil then
			atk = atk +equip:GetAtk()
			hp = hp +equip:GetHp()
			atkSpeed = atkSpeed +equip:GetAtkSpeed()
		end
	end
	list.Atk = atk
	list.Hp = hp
	list.AtkSpeed = atkSpeed
	return list
end

function Role:GetEquipUUIDs()			--得到穿戴装备的所有的UUID 
	if self.Equips == nil then
		return nil
	end
	local list ={}
	for key,value in pairs(self.Equips) do
		table.insert(list,key,value)
	end
	
	return list
end	


function Role:GetEquipLen()
	if self.Equips == nil then
		return 0
	end
	local num = 0
	for key,value in pairs(self.Equips) do
		num = num + 1
	end
	return num
	
end

function Role:UpGrade()			--小兵升阶
	SoliderPackageSys.UpQuality(self.Dbid , self.RoleSeries)
end

function Role:ChangeGrade(HeroMats , _UUID)	--武将转生
	HeroPackageSys.HeroUpGrade(self , HeroMats , _UUID) 
end

function Role:HeroTrain(_Type)		--武将训练
	self.TrainType = _Type
	HeroPackageSys.HeroTrain(self.UUID , _Type)
end

function Role:StopHeroTrain()		--武将训练停止
	HeroPackageSys.HeroStopTrain(self.UUID)
end

function Role:SoliderTrain(_Type)			--士兵训练
	self.TrainType = _Type
	SoliderPackageSys.Train(self.Dbid, _Type)
end


function Role:StopSoliderTrain()
	SoliderPackageSys.StopTrain(self.Dbid)
end

function Role:AddExpByItem(_Type)
	if self.UUID == "0" then
		--小兵
		SoliderPackageSys.AddExpWithItem(self.Dbid , _Type)
	else
		HeroPackageSys.AddExpWithItem(self.UUID , _Type)
	end
end

function Role:AddExp()					--加经验值
	local allExp = self.Exp + RoleDataSys.TrainTypeExp[self.TrainType]
	local list = GameMain.StringSplit(RoleDataSys.GetRoleLvlExpByExp(self.lvl , allExp) , ",")
	self.Exp = tonumber(list[1])
	self.lvl = tonumber(list[2])
end

function Role:GetExp()					--得到当前的经验
	
	local list = self:GetLvlAndExp()
	self.Exp = tonumber(list[2])
	return tonumber(list[2])
	
end

function Role:GetLvl()					--得到当前的等级
	local list = self:GetLvlAndExp()
	self.lvl = tonumber(list[1])
	return tonumber(list[1])

end


function Role:GetLvlAndExp()				--得到当前的经验和等级list[1] lvl , list[2] Exp
	if self.TrainType == 0 then
		local dataLists = RoleDataSys.GetRoleLvlExpByExp(self.lvl , self.Exp)
		return	GameMain.StringSplit(dataLists, ",")
	end
	local curTime = ClinetInfomation.WorldTime
	if curTime>=self.EndTime then
		local allExp = self.Exp+RoleDataSys.TrainTypeAllExp[self.TrainType]
		local list = GameMain.StringSplit(RoleDataSys.GetRoleLvlExpByExp(self.lvl , allExp) , ",")
		self.TrainType = 0
		return list
	else
		local allExp = self:CalCulateExpByTime(curTime)
		local list = GameMain.StringSplit(RoleDataSys.GetRoleLvlExpByExp(self.lvl , allExp) , ",")
		return list
	end
	
end

function Role:CalCulateExpByTime(_Time)
	local delTime = _Time - self.BeginTime
	local addCount = GameMain.ConvertToInt(delTime/(60*60))
	local exp = self.Exp + RoleDataSys.TrainTypeExp[self.TrainType]*addCount
	return exp
end


function Role:GetAddExpItemCount()				--得到加经验消耗的道具，1 突飞令， 2 加速符
	local lvl = ClinetInfomation.Lvl
	local curlvl = self:GetLvl()
	local roleExp = RoleExpConfig.GetRoleExpConfig(lvl+1)
	if roleExp~=nil then
		local list = {}
		local delExp = (roleExp.AllExp - 1) - self.Exp
		if delExp>=10000 then
			list[1] =100
			list[2] = 14
			return list
		end
		local num1 =  math.ceil(delExp/100)
		local num2 = math.ceil( num1*14/100)
		list[1] = num1
		list[2] = num2
		return list
	end
end

function Role:IsCanAddExp()						--是否可以突飞和猛进
	local lvl = ClinetInfomation.Lvl
	if self:GetLvl() >=lvl then
		return false
	end
	local roleExp = RoleExpConfig.GetRoleExpConfig(lvl)
	local upRoleExp = RoleExpConfig.GetRoleExpConfig(lvl+1)
	if upRoleExp~=nil then
		if self.Exp>= upRoleExp.AllExp - 1 then
			return false
		else
			return true
		end
	end
	return false
end

return Role
