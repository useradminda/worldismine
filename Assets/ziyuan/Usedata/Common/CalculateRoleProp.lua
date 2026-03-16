CalculateRoleProp = {}

CalculateRoleProp.Prop =
{
    Life = 0,
    Attack = 0,
    AttackSpeed = 0,
    MoveSpeed = 0,
    Defence = 0,
}

function CalculateRoleProp.CalculatProp(_Id , _Lvl , _QualityLvl)
    
    local data = 
    {    
    }
    local _RoleProp = RoleDataSys.GetRoleById(_Id)
    local _AddHP = 0
    local _AddAttack = 0
   
    local _life = tonumber(_RoleProp.LifeList[1]) + _QualityLvl*tonumber(_RoleProp.LifeList[2]) + tonumber(_RoleProp.LifeList[3]) + _Lvl*tonumber(_RoleProp.LifeList[4])
    local _Attack = tonumber(_RoleProp.AttackList[1]) + _QualityLvl*tonumber(_RoleProp.AttackList[2]) + tonumber(_RoleProp.AttackList[3]) + _Lvl*tonumber(_RoleProp.AttackList[4])   
    local TempAttackSpeed = tonumber(_RoleProp.AttackSpeedList[1]) + _QualityLvl*tonumber(_RoleProp.AttackSpeedList[2]) + tonumber(_RoleProp.AttackSpeedList[3]) + _Lvl*tonumber(_RoleProp.AttackSpeedList[4])
    local _AttackSpeed = 0
    if TempAttackSpeed==0 then
       _AttackSpeed = 0
    else
       _AttackSpeed = TempAttackSpeed
    end
    local _MoveSpeed = tonumber(_RoleProp.MoveSpeedList[1]) + _QualityLvl*tonumber(_RoleProp.MoveSpeedList[2]) + tonumber(_RoleProp.MoveSpeedList[3]) + _Lvl*tonumber(_RoleProp.MoveSpeedList[4])
    local _Defence = tonumber(_RoleProp.DefenceList[1]) + _QualityLvl*tonumber(_RoleProp.DefenceList[2]) + tonumber(_RoleProp.DefenceList[3]) + _Lvl*tonumber(_RoleProp.DefenceList[4])
    data.life = _life * (1 + _AddHP)
    data.Attack = _Attack * (1 + _AddAttack)
    data.AttackSpeed = _AttackSpeed
    data.MoveSpeed = _MoveSpeed
    data.Defence = _Defence
    return data
end

function CalculateRoleProp.GetHeroProp(_Type , _Camp , _UUId)   --
   local _HeroInfo = HeroPackageSys.GetOneHeroBy_UUID(_UUId)
   local _Life = _HeroInfo:GetLife()
   local _Attack = _HeroInfo:GetAtk()
   local _AttackSpeed = _HeroInfo:GetAtkSpeed()
   local _MoveSpeed = _HeroInfo:GetMoveSpeed()
   local _Defence = _HeroInfo:GetDefence()
   
   local data = 
   {   
    
   }
   data.life = _Life
   data.Attack = _Attack
   data.AttackSpeed = _AttackSpeed
   data.MoveSpeed = _MoveSpeed
   data.Defence = _Defence
   return data
end


function CalculateRoleProp.CalculationAttr(list ,qualityLvl , lvl)
	local value = 0
	if #list==4 then
		value = tonumber(list[1]) + qualityLvl * tonumber(list[2]) + tonumber(list[3]) +lvl *tonumber(list[4])
	end
	return value
end

CalculateRoleProp.FightTypes = 
{
    ["CorrectValue"] = 10000,                   --修正值
    ["RoleLvlBaseProp"] = 1000,                 --角色等级值
    ["Flag"] = 
    {
        [1] = 14880,
        [2] = 20760,
        [3] = 38820,
        [4] = 48480,
        [5] = 146480,
        [6] = 244480,
        [7] = 342480,
        [8] = 440480,
        [9] = 538480,
        [10] = 636480,
    },
    ["TotalFlag"] =
    {
        [0] = 0,
        [1] = 14880,
        [2] = 20760,
        [3] = 38820,
        [4] = 48480,
        [5] = 146480,
        [6] = 244480,
        [7] = 342480,
        [8] = 440480,
        [9] = 538480,
        [10] = 636480,
    },
	["HeroBasicValue"] = 
	{
		[1] = 0,		--白色
        [2] = 0,		--绿色
        [3] = 0,		--蓝色
        [4] = 300,		--青色
        [5] = 1600,		--紫色
        [6] = 2400,		--金色
        [7] = 2800,		--橙色
        [8] = 4600,		--红色
	},
	["SoliderBasicValue"] = 
	{
		[6] = 100,		--弓兵
		[11] = 100,		--锤兵
		[1] = 100,		--盾兵
		[7] = 200,		--炮兵
		[12] = 200,		--酒鬼
		[2] = 200,		--铁甲兵
		[8] = 300,		--弩兵
		[13] = 300,		--枪兵
		[3] = 300,		--藤甲兵
		[9] = 400,		--弩车
		[14] = 400,		--骑兵
		[4] = 400,		--雪人
		[10] = 500,		--投石车
		[15] = 500,		--野人
		[5] = 500,		--碾车
	},
	["EquipBasicValue"] = 
	{
		[1] = 10,		--白色
        [2] = 20,		--绿色
        [3] = 0,		--蓝色
        [4] = 30,		--青色
        [5] = 40,		--紫色
        [6] = 50,		--金色
        [7] = 60,		--橙色
        [8] = 70,		--红色
	}
        
}
CalculateRoleProp.TotalFight = 0
CalculateRoleProp.Fight =
{
   ["LvlFight"] = 0,
   ["FlagFight"] =  0,
   ["HeroFight"] =  0,
   ["SoldierFight"] = 0 ,
}
function CalculateRoleProp.CalculateFight(_Type)
   local _Fight = 0
   if _Type==4 then
      _Fight = 0
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight - CalculateRoleProp.Fight.LvlFight  
      _Fight = CalculateRoleProp.FightTypes.CorrectValue + CalculateRoleProp.FightTypes.RoleLvlBaseProp * ClinetInfomation.Lvl
      CalculateRoleProp.Fight.LvlFight = _Fight
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight + CalculateRoleProp.Fight.LvlFight
   end

   
   if _Type==3 then             --战旗战斗力变更
       _Fight = 0
       CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight - CalculateRoleProp.Fight.FlagFight
       
       for key , value in pairs(BattleFlagSys.UpBattleFlags) do 
           local _F = CalculateRoleProp.FightTypes.Flag[value.FlagData.Lvl]
           _Fight = _Fight + _F
       end
       _Fight = _Fight +  CalculateRoleProp.FightTypes.TotalFlag[BattleFlagSys.TotalFlag]
       CalculateRoleProp.Fight.FlagFight = _Fight
       CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight + CalculateRoleProp.Fight.FlagFight
   end

   if _Type==1 then             --英雄战斗力变更
      _Fight = 0
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight - CalculateRoleProp.Fight.HeroFight     
      for key , value in pairs(HeroPackageSys.Heros) do
          _Fight = _Fight + value:GetBattlePower()
      end  
      CalculateRoleProp.Fight.HeroFight = _Fight
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight + CalculateRoleProp.Fight.HeroFight
   end

   if _Type==2 then             --士兵战斗力变更
      _Fight = 0
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight - CalculateRoleProp.Fight.SoldierFight
      for key , value in pairs(SoliderPackageSys.Soliders) do
          _Fight = _Fight + value:GetBattlePower()
      end
      CalculateRoleProp.Fight.SoldierFight = _Fight
      CalculateRoleProp.TotalFight = CalculateRoleProp.TotalFight + CalculateRoleProp.Fight.SoldierFight
   end

   ClinetInfomation.Fight = CalculateRoleProp.TotalFight

   local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if UIControlTar~=nil then
      UIControlTar:SetFight(CalculateRoleProp.TotalFight)
   end
   
end

function CalculateRoleProp.GetSkillPower(_BuffId1 ,_BuffId2 , _HeroValue , _Lvl , _Qlvl)
	local power = CalculateRoleProp.GetBuffPowerValue(_BuffId1 , _HeroValue , _Lvl , _Qlvl)
	local power2 = CalculateRoleProp.GetBuffPowerValue(_BuffId2 , _HeroValue , _Lvl , _Qlvl)
	return math.ceil(power + power2)
end

function CalculateRoleProp.GetBuffPowerValue(_BuffId , _HeroValue , _Lvl , _Qlvl)
	local buffData = BuffConfig.GetBuffById(_BuffId)
	if buffData ~= nil then
		local powerValue = 0
		if buffData.PropertyId == 1 then
			powerValue = _HeroValue["hp"]
		end
		if buffData.PropertyId == 2 then
			powerValue = _HeroValue["atk"]
		end
		local basicList = GameMain.StringSplit(buffData.LvlModify , ",")
		local repairList = GameMain.StringSplit(buffData.SpellModify , ",")
		local basic = basicList[1] +_Qlvl*basicList[2] + basicList[3] +basicList[4]*_Lvl
		local repair = powerValue*(repairList[1] +_Qlvl*repairList[2] + repairList[3] +repairList[4]*_Lvl) / 100
		return basic + repair
	end
	return 0
end

return CalculateRoleProp