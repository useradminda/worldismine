roleBase = {}											--人物属性基类
--[[{
life=-1, --生命 1  string
attack =-1, --物攻	 2 string
magicattack =-1, --魔攻 3 string
phydefense=-1, -- 物防 4 string
magicdefense =-1, -- 魔防 5 string
critprob=-1, -- 暴击率 6 string
critpvalue =-1, -- 暴击伤害 7 string
realattack =-1, --8 真实伤害 string
movespeed=-1, --9 移动速度
gnumber=-1, --10 G点序列
part="", --11阶段配置
id =-1, --12 ID
name = "-1", --13 名称
realid=-1, --14 realID
roletype = -1, --15 角色类型
fbxname = -1, -- 16 模型名称
star = -1, -- 17 星级
quality = -1, -- 18	品质
race = -1, --19	种族
career = -1, -- 20	职业
shield = -1, -- 21	护盾
ailevel = -1, -- 22	ai等级
guardrange = -1, --  23	警戒范围
cdreduce = -1, -- 24	cd缩减 string
dodge = -1, -- 25	闪避 string
}
RolePropMag.BaseProp_ ={
life=-1, --生命 1
attack =-1, --物攻	 2
magicattack =-1, --魔攻 3
phydefense=-1, -- 物防 4
magicdefense =-1, -- 魔防 5
critprob=-1, -- 暴击率 6
critpvalue =-1, -- 暴击伤害 7
realattack =-1, --8 真实伤害
movespeed=-1, --9 移动速度
cdreduce = -1, -- 24	cd缩减
dodge = -1, -- 25	闪避 string
attackspeed= -1, -- 26 攻击速度 attackspeed
}--]]


local this = roleBase
roleBase.__index = roleBase

roleBase.roleData =	nil									--人物数据库信息								
roleBase.nickname = ""									--人物姓名
roleBase.AtlasName = ""                                 --头像Atlas
roleBase.SpriteName = ""                                --头像Sprite
roleBase.realId = 0										--realid
roleBase.isActivated = 0							    --0表示没有 1表示有 是否已经获得
roleBase.star = 0
roleBase.lvl = 0                                        --等级
roleBase.quality = 0                                    --品质
roleBase.qualityLvl = 1                                 --品质等级
roleBase.pos = 0									    --上阵位置
roleBase.isHorse = false								--是否被骑行
roleBase.Fight = 0                                      --战斗力指
roleBase.skill = 
{  
}
roleBase.PlayerEquip = {}                             --保存已经穿上的装备实例

roleBase.DBProp =                                       --数据库属性 
{
}
roleBase.BaseProp =                                     --基础属性                                   
{
   
}
roleBase.AddProp =                                      --额外增加的属性
{   
   
}
roleBase.Prop =                                         --总属性
{
    
}
roleBase.AnotherBabyStarAddProp =                       --星级增加的其他额外宝宝的属性 上阵之后
{

}
function  roleBase:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function roleBase:InitBabyInfo(babyinfo)
	self.nickname = self.roleData[13]

    self:SetDBProp(self.roleData)
    self:SetIcon(self.roleData)

	self.realId = babyinfo.realID
	self.star = babyinfo.star
	self.isActivated = babyinfo.isActivated
    self.qualityLvl = babyinfo.qualityLvl
	self.quality = babyinfo.quality
	self.lvl = babyinfo.level

    self:SetSkill(babyinfo.skill)
    self:SetAnotherBabyStarAddProp()
    self:SetTotalProp()

end

function roleBase:SetDBProp(_DBdata)
    self.DBProp = {}
    self.DBProp[1] = _DBdata[1]
	self.DBProp[2] = _DBdata[2]
	self.DBProp[3] = _DBdata[3]
	self.DBProp[4] = _DBdata[4]
	self.DBProp[5] = _DBdata[5]
	self.DBProp[6] = _DBdata[6]
	self.DBProp[7] = _DBdata[7]
	self.DBProp[8] = _DBdata[8]
	self.DBProp[9] = _DBdata[9]
	self.DBProp[17] = _DBdata[17]
	self.DBProp[24] = _DBdata[24]
	self.DBProp[25] = _DBdata[25]
	self.DBProp[26] = _DBdata[26]
    self.DBProp[27] = _DBdata[35]
end

function roleBase:SetIcon(_DBdata)
    local IconString = _DBdata[29]
    local Icon = GameMain.StringSplit(IconString , ",")
    self.AtlasName = Icon[1]
    self.SpriteName = Icon[2]
end

function roleBase:SetSkill(_SkillInfo)                                                                  --设置宝宝拥有的技能
   self.skill = {}
   local Count = #_SkillInfo
   for i = 1 , Count , 1 do 
       local SkillData = SkillData.GetSkillDataCf(tonumber(_SkillInfo[i].id))
       local SkillLevel = _SkillInfo[i].level
       local IsActivity = _SkillInfo[i].activity
       local Icon = GameMain.StringSplit(SkillData.icon,",")
       if SkillData~=nil then
           local data =
           {
               SkillName = SkillData.name,                                                                  --技能名字
               SkillLevel  = SkillLevel,
               SpriteName = SkillData.SpriteName,                                                             --技能图标
               AtlasName = SkillData.AtlasName,
               SkillQuality = self.quality,                                                                 --技能品质
               SkillId = SkillData.id,                                                                      --技能ID
               --SkillDescrip =                                                                             --技能描述
               SkillActive = IsActivity,
           }   
           self.skill[i] = data       
       end
   end
   self:SetSkillInfo()
end

function roleBase:SetSkillInfo()
    local Count = #self.skill
    for i = 1 , Count , 1 do
        self.skill[i].SkillQuality = self.quality
    end   
end

function roleBase:GetSkillById(_SkillId) 
   for i = 1 , #self.skill , 1 do
      if self.skill[i].SkillId==_SkillId then
         return self.skill[i]
      end
   end
   return nil
end

function roleBase:SetCaption(_type , _pos , _realId)													--主坐骑
    self.pos = _pos
	TeamSys.SetCaptain(	_type , _pos , _realId)

end

function roleBase:GetUpHorse(_type , _pos , _realId)												    --上下阵
    self.pos = _pos
	TeamSys.UpRoles(_type , _pos , _realId)

end

function roleBase:GetDownHorse(_type , _pos , _realId)												   --上下阵
    self.pos = 0
	TeamSys.UpRoles(_type , _pos , 0)

end

function roleBase:UpQuality()                                                                           --升阶
    BabyActionSys.UpQuality(self.realId)
end

function roleBase:Uplvl()
    local needCoin = roleDataSys.GetUpLvlNeedCoin(self.lvl)                                                 --升级
    local nowCoin = ClinetInfomation.GetCoin()
    if nowCoin >= needCoin then                                                                                 
       BabyActionSys.UpLvl(self.realId)
    else
       DataUIInstance.PopTip("A7")
      -- Debug.LogError("金币不足")
    end
end

function roleBase:UpStar()                                                                              --升星
    BabyActionSys.UpStar(self.realId)
end

function roleBase:GetLvl_AddProp()                                                                      --等级的额外属性

    local tempProp = 
    {
       life = 0,
       n_attack = 0,
    }
    local LvlUpProp = GameMain.JsonDecode(self.roleData[27])
    for i = 1 , self.lvl , 1 do          
        if LvlUpProp[tostring(i)]~=nil then
           local Count = #LvlUpProp[tostring(i)]
           for j = 1 , Count , 1 do 
               if  LvlUpProp[tostring(i)][j]~=nil then
                   if LvlUpProp[tostring(i)][j]["life"]~=nil then
                      tempProp.life = tempProp.life + tonumber(LvlUpProp[tostring(i)][j]["life"])
                   end
                   if LvlUpProp[tostring(i)][j]["n_attack"]~=nil then
                      tempProp.n_attack = tempProp.n_attack + tonumber(LvlUpProp[tostring(i)][j]["n_attack"])
                   end
               end
           end
        end
        
    end
    return tempProp

end

function roleBase:GetStar_AddProp()                                                                 --自身星级额外加成
    local tempProp = 
    {
      life = 0,
      n_attack = 0,
    }
    local StarUpProp = GameMain.JsonDecode(self.roleData[28])
    for i = 1 , self.star , 1 do
        if StarUpProp[tostring(i)]~=nil then
           local Count = #StarUpProp[tostring(i)]
           for j = 1 , Count , 1 do 
               if  StarUpProp[tostring(i)][j]~=nil then
                   if StarUpProp[tostring(i)][j]["life"]~=nil and StarUpProp[tostring(i)][j]["tg"]==0 then
                      tempProp.life = tempProp.life + tonumber(StarUpProp[tostring(i)][j]["life"])
                   end
                   if StarUpProp[tostring(i)][j]["n_attack"]~=nil and StarUpProp[tostring(i)][j]["tg"]==0 then
                      tempProp.n_attack = tempProp.n_attack + tonumber(StarUpProp[tostring(i)][j]["n_attack"])
                   end
               end
           end
        end
    end
    return tempProp 
end

function roleBase:SetRoleBaseProp()                                                                         --设置基础属性  
   self.BaseProp = {}
   local Data = 
   {
      lvl = self.lvl,
      quality = self.quality
   }
   self.BaseProp = lgRolePopListMag.Cqbaseprop(self.DBProp , Data)
end

function roleBase:SetRoleAddProp()                                                                          --设置额外总加成属性
   self.AddProp = 
   {
        [1] = 0,
        [2] = 0,
   }
   local Lvl_AddProp = self:GetLvl_AddProp()
   if Lvl_AddProp.life~=nil then                                                                            --生命
      self.AddProp[1] = self.AddProp[1] + Lvl_AddProp.life
   end
   if Lvl_AddProp.n_attack~=nil then                                                                        --物攻
      self.AddProp[2] = self.AddProp[2] + Lvl_AddProp.n_attack
   end
   
   local Star_AddProp = self:GetStar_AddProp()
    if Star_AddProp.life~=nil then                                                                            --生命
       self.AddProp[1] = self.AddProp[1] + Star_AddProp.life
   end
   if Star_AddProp.n_attack~=nil then                                                                        --物攻
      self.AddProp[2] = self.AddProp[2] + Star_AddProp.n_attack
   end                                                                             
end

function roleBase:SetAnotherBabyStarAddProp()
   self.AnotherBabyStarAddProp = {}
   local StarUpProp = GameMain.JsonDecode(self.roleData[28])
    for i = 1 , self.star , 1 do
        if StarUpProp[tostring(i)]~=nil then
           local Count = #StarUpProp[tostring(i)]
           for j = 1 , Count , 1 do 
               if  StarUpProp[tostring(i)][j]~=nil then
                   if StarUpProp[tostring(i)][j]["life"]~=nil and StarUpProp[tostring(i)][j]["tg"]~=0 then
                      TarRealId = StarUpProp[tostring(i)][j]["tg"]
                      lifeAddNum = StarUpProp[tostring(i)][j]["life"]
                      if self.AnotherBabyStarAddProp[TarRealId]==nil then
                         self.AnotherBabyStarAddProp[TarRealId] = {}
                      end
                      if self.AnotherBabyStarAddProp[TarRealId][1]==nil then
                         self.AnotherBabyStarAddProp[TarRealId][1] = lifeAddNum
                      else
                         self.AnotherBabyStarAddProp[TarRealId][1] = self.AnotherBabyStarAddProp[TarRealId][1] + lifeAddNum
                      end                  
                   end
                   if StarUpProp[tostring(i)][j]["n_attack"]~=nil and StarUpProp[tostring(i)][j]["tg"]~=0 then
                      TarRealId = StarUpProp[tostring(i)][j]["tg"]
                      n_attackAddNum = StarUpProp[tostring(i)][j]["n_attack"]
                      if self.AnotherBabyStarAddProp[TarRealId]==nil then
                         self.AnotherBabyStarAddProp[TarRealId] = {}
                      end
                      if self.AnotherBabyStarAddProp[TarRealId][2]==nil then
                         self.AnotherBabyStarAddProp[TarRealId][2] = n_attackAddNum
                      else
                         self.AnotherBabyStarAddProp[TarRealId][2] = self.AnotherBabyStarAddProp[TarRealId][2] + n_attackAddNum
                      end                  
                   end
               end
           end
        end
    end
end

function roleBase:SetTotalProp()                                 --计算总属性 基础+额外总加成+装备属性加成+上阵宝宝加成属性
   
   if self~=ClinetInfomation.theMe and self.realId~=111001 and self.realId~=111002  then
       self.Prop = {}
       self:SetRoleBaseProp()
       self:SetRoleAddProp()
       for key , value in pairs(self.BaseProp) do                                           --额外属性加成      
           if self.AddProp[key]~=nil then        
              self.Prop[key] = self.BaseProp[key] + self.AddProp[key]
           else 
              self.Prop[key] = self.BaseProp[key]
           end
       end
   elseif self==ClinetInfomation.theMe or self.realId==111001 or self.realId==111002 then
      self.Prop = {}
      self:SetRoleBaseProp()
      for key , value in pairs(self.BaseProp) do                                                     
          self.Prop[key] = self.BaseProp[key]
      end
      self.Prop[1] = roleDataSys.GetTheMeLifeData(self.lvl)
      self.Prop[2] = roleDataSys.GetTheMeAttackData(self.lvl)
   end
    for key , value in pairs(self.PlayerEquip) do                                       --装备属性加成      
       if value~=nil then
          for key , value in pairs(value.Prop) do
              if self.Prop[key]~=nil then
                 self.Prop[key] = self.Prop[key] + value
              end
          end
       end
   end
   self.Fight = RolePropCalculate.CalculateFight(self.Prop)
end

function roleBase:TeamTotalProp(_UpRoles)                                                 --加成队伍传进去
   self:SetTotalProp()
   local UpRoles = _UpRoles
   for key , value in pairs(UpRoles) do      
       local TeamBabyAnother = UpRoles[key].AnotherBabyStarAddProp
       for key , value in pairs(TeamBabyAnother) do
           if self.realId==key then              
              for key , value in pairs(TeamBabyAnother[key]) do                
                  if self.Prop[key]~=nil then                     
                     self.Prop[key] = self.Prop[key] + value
                  end
              end
           end
       end
   end
   local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
   if UIControlTar~=nil then
      UIControlTar:SetTopLeftFight()
   end
end

function roleBase:GetStarUpPropInfo() 
    local StarUpProp = GameMain.JsonDecode(self.roleData[28])
    return StarUpProp
end

return roleBase