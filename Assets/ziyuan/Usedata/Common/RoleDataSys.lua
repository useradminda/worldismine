RoleDataSys = {}

RoleDataSys.TrainTypeExp = 
{
	[1] = 100,
	[2] = 100,
	[3] = 200,
}

RoleDataSys.TrainTypeAllExp = 
{
	[1] = 800,
	[2] = 1200,
	[3] = 4800,
}

RoleDataSys.AddExpCDEndTime = 0						--武将士兵加经验公用CD


function RoleDataSys.SetAddExpTime(_Time)
	RoleDataSys.AddExpCDEndTime = _Time
	local curTime = ClinetInfomation.WorldTime
	if curTime <= RoleDataSys.AddExpCDEndTime then
		local delTime = RoleDataSys.AddExpCDEndTime - curTime
		TimeControl.LoginTime(delTime , "AddExpCDTime")
	else
		TimeControl.SetTime("AddExpCDTime" , 0 )
	end
end


function RoleDataSys.GetRoleById(_Id)			--通过ID得到相应的武将原始数据

   if RoleDataConfig.GetRoleById(_Id)~=nil then
      return RoleDataConfig.GetRoleById(_Id)
   end
   return nil

end

function RoleDataSys.GetRoleAtk(_RoleData , lvl)	--得到攻击值
	local atkList = _RoleData.AttackList
	return CalculateRoleProp.CalculationAttr(atkList, _RoleData.Quality ,lvl)
end

function RoleDataSys.GetRoleLife(_RoleData , lvl)	--得到生命值
	local lifeList = _RoleData.LifeList
	return CalculateRoleProp.CalculationAttr(lifeList, _RoleData.Quality ,lvl)
end

function RoleDataSys.GetRoleAtkSpeed(_RoleData , lvl)	--得到攻速
	local atkSpeedList = _RoleData.AttackSpeedList
	return CalculateRoleProp.CalculationAttr(atkSpeedList, _RoleData.Quality ,lvl)
end

function RoleDataSys.GetRoleByQuality(_Id , _Quality)
   local _RoleData = RoleDataConfig.GetRoleByQuality( _Id ,_Quality)
   if _RoleData~=nil then
      return _RoleData
   else
      return nil
   end
end

function RoleDataSys.CreateSolider(_Dbid , _QualityLvl , _IsActive , _Exp , _BeginTime , _EndTime , _Type)   --创建士兵
   local lua = GameMain.requireLuaFile("Role")
   local rolebaby = lua:new()
   local _RoleDBdata = RoleDataSys.GetRoleById(_Dbid)
   rolebaby:Init(_RoleDBdata , _QualityLvl , nil , _IsActive ,_Exp, _BeginTime , _EndTime , _Type)
   return rolebaby
end

function RoleDataSys.CreateHero(_Dbid , _UUID ,_Qvl , _Equips , _Exp , _BeginTime , _EndTime , _Type)        --创建属于我的英雄
   local lua = GameMain.requireLuaFile("Role")
   local rolebaby = lua:new()
   local _RoleDBdata = RoleDataSys.GetRoleById(_Dbid)
	
   rolebaby:Init(_RoleDBdata , _Qvl , _UUID , 1,_Exp , _BeginTime , _EndTime , _Type)
   if _Equips~=nil then
	 rolebaby:InitEquips(_Equips)
   end
   return rolebaby
end

function RoleDataSys.TempHero(_Dbid , _Lvl , _QualityLvl)           --创建临时英雄
   local lua = GameMain.requireLuaFile("Role")
   local rolebaby = lua:new()
   local _RoleDBdata = RoleDataSys.GetRoleById(_Dbid)
   rolebaby:Init(_RoleDBdata , _QualityLvl , nil , true)
   return rolebaby
end

function RoleDataSys.MyExpNeedByLvl(_Lvl)                           --获得主角要升到一下级多少经验
   local _MyNeedExp = PlayerExpConfig.GetPlayerExpConfig(_Lvl)
   if _MyNeedExp~=nil then
      return _MyNeedExp.Exp
   else
      return nil
   end
end

function RoleDataSys.GetRoleUpExp(_Lvl)                            --获得武将/士兵下一个等级需要的经验
   local _RoleExp = RoleExpConfig.GetRoleExpConfig(_Lvl)
   if _RoleExp~=nil then
      return _RoleExp.Exp
   else
      return nil
   end
end

function RoleDataSys.GetRoleTrain8(_Lvl)                            --8小时训练
   local _RoleExp = RoleExpConfig.GetRoleExpConfig(_Lvl)
   if _RoleExp~=nil then
      return _RoleExp.Train_8_need
   else
      return 0
   end
end

function RoleDataSys.GetRoleTrain12(_Lvl)                            --12小时训练
   local _RoleExp = RoleExpConfig.GetRoleExpConfig(_Lvl)
   if _RoleExp~=nil then
      return _RoleExp.Train_12_need
   else
      return 0
   end
end

function RoleDataSys.GetRoleTrain24(_Lvl)                           --24小时训练
   local _RoleExp = RoleExpConfig.GetRoleExpConfig(_Lvl)
   if _RoleExp~=nil then
      return _RoleExp.Train_24_need
   else
      return 0
   end
end

function RoleDataSys.GetRoleLvlExpByExp(_lvl , _Exp)				--根据经验得到当前的等级和经验
	local list = RoleExpConfig.GetRoleExp()
	local allExp = _Exp
	for i=_lvl,#list,1 do
		if allExp<list[i].AllExp then
			local lvl = list[i].Lvl - 1
			if lvl<=0 then
				return 1 .. "," ..allExp
			else
				return lvl .. "," .. allExp - list[i-1].AllExp
			end
		end
		
		if list[i].Exp == 0 and allExp>=list[i].AllExp then
			return list[i].Lvl .."," .. list[i].Exp	--顶级了
		end
	end
end

function RoleDataSys.GetMinLimitQuality()
   return 3
end


function RoleDataSys.GetUpGradeNeedMat()
	
end

return RoleDataSys