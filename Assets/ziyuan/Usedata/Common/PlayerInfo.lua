--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
PlayerInfo = {}
PlayerInfo.__index = PlayerInfo

PlayerInfo.Dbid = 0			--玩家的唯一ID
PlayerInfo.lvl = 0			--玩家等级
PlayerInfo.VipLvl = 0		--玩家的VIP等级
PlayerInfo.name = ""		--玩家的名字
PlayerInfo.CreateTime = 0	--玩家创建的时间戳
PlayerInfo.CommanderId = 0	--玩家的挂帅武将
PlayerInfo.Camp = 0			--玩家的所属国家
PlayerInfo.AtlasName = ""
PlayerInfo.SpriteName = "" 

PlayerInfo.SoliderList = {}	--士兵的信息
PlayerInfo.HeroList = {}	--武将的信息
PlayerInfo.Formation= {}	--布阵信息	
PlayerInfo.BattleFieldFormation= {}	--沙场点兵布阵信息
PlayerInfo.BattleHeroFormation = {} --斗将台布阵信息	
function PlayerInfo:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end
--初始化基本信息
function PlayerInfo:Init(_Player , _Army , _Hero , _Formation)
	if _Player~=nil then
		self.Dbid = tonumber(_Player["_id"])
		self.Camp = tonumber(_Player["camp"])
		self.name = tostring(_Player["name"])
		self.VipLvl = tonumber(_Player["vip"])
		self.lvl = tonumber(_Player["lv"])
		self.CommanderId = tonumber(_Player["commanderId"])
		self.CreateTime = tonumber(_Player["create_time"])
		self.AtlasName = ""
		self.SpriteName = ""
		if self.CommanderId~=0 then
			local role = RoleDataConfig.GetRoleById(self.CommanderId)
			if role ~= nil then
				self.AtlasName = role.AtlasName 
				self.SpriteName = role.SpriteName
			end
		end
	end
	
	self.SoliderList = {}
	self.HeroList = {}
	self.Formation = {}
    self.BattleFieldFormation= {}	--沙场点兵布阵信息
    self.BattleHeroFormation = {} --斗将台布阵信息
	if _Army~=nil then
		for key,value in pairs(_Army) do
			local id = tonumber(value["id"])
			local exp = tonumber(value["exp"])
			local qlv = tonumber(value["qlv"])
			local data = RoleDataSys.CreateSolider(id , qlv ,0 ,exp);
			table.insert(self.SoliderList , #self.SoliderList +1 , data)
		end
	end
	
  --  GameMain.Print(self.SoliderList)

	if _Hero~=nil then
		for key,value in pairs(_Hero) do
			local uuid = tostring(value["uuid"])
			local id = tonumber(value["id"])
			local exp = tonumber(value["exp"])
			local qlv = tonumber(value["qlv"])
			local data = RoleDataSys.CreateHero(id  , uuid , qlv , nil , exp)
			table.insert(self.HeroList , #self.HeroList+1 , data)
		end
	end
   -- GameMain.Print(self.HeroList)
	table.sort(self.HeroList , self.Comp)
	table.sort(self.SoliderList , self.Comp)
    -- GameMain.Print(self.HeroList)

  -- GameMain.Print(_Formation)
	if _Formation~=nil then
		for key , value in pairs(_Formation) do
            if key~=nil and tonumber(key) == 1 then                   --pve     

            end
            if key~=nil and tonumber(key) == 2 then                   --pvp 沙场点兵
               local _TeamInfo = GameMain.StringSplit(value , ";")
               local _ChoseTeamId = tonumber(_TeamInfo[1])
               local _TeamList = GameMain.StringSplit(_TeamInfo[2] , "#")
               for i = 1 , #_TeamList , 1 do
                   local _Team = GameMain.StringSplit(_TeamList[i] , "=")
                   local _TempTeamId = tonumber(_Team[1])
                   if _ChoseTeamId == _TempTeamId then
                      local _TeamList = GameMain.StringSplit(_Team[2] , "/")
                      for i = 1 , #_TeamList , 1 do
                          
                          local _TeamEndInfo = GameMain.StringSplit(_TeamList[i] , "_")
                          local _UUID = _TeamEndInfo[1]
                          local _SoliderId = _TeamEndInfo[2]
                          local _PosX = _TeamEndInfo[3]
                          local _PosY = _TeamEndInfo[4]
                          local data = self:GetMemberInfo(_UUID , _SoliderId , _PosX , _PosY)
                          table.insert(self.BattleFieldFormation , #self.BattleFieldFormation+1 , data)
                      end
                   end
               end
            end
            
            if key~=nil and tonumber(key) == 3 then                   --pvp 豆浆台
               local _TeamInfo = GameMain.StringSplit(value , ";")
               local _ChoseTeamId = tonumber(_TeamInfo[1])
               local _TeamList = GameMain.StringSplit(_TeamInfo[2] , "#")
               for i = 1 , #_TeamList , 1 do
                   local _Team = GameMain.StringSplit(_TeamList[i] , "=")
                   local _TempTeamId = tonumber(_Team[1])
                   if _ChoseTeamId== _TempTeamId then
                      local _TeamList = GameMain.StringSplit(_Team[2] , "/")
                      for i = 1 , #_TeamList , 1 do
                          local _TeamEndInfo = GameMain.StringSplit(_TeamList[i] , "_")
                          local _UUID = _TeamEndInfo[1]
                         -- local _SoliderId = _TeamEndInfo[2]
                          local _PosX = _TeamEndInfo[2]
                          local _PosY = _TeamEndInfo[3]
                          local data = self:GetMemberInfo(_UUID , nil , _PosX , _PosY)
                          table.insert(self.BattleHeroFormation , #self.BattleHeroFormation+1 , data)
                      end
                   end
               end
            end
        end
	end	
    
end


function PlayerInfo.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.quality > B.quality then
		return true
	end
	if A.quality<B.quality then
		return false
	end
	if A.quality == B.quality then
		if A.qualityLvl > B.qualityLvl then
			return true
		end
		if A.qualityLvl < B.qualityLvl then
			return false
		end
		if A.qualityLvl == B.qualityLvl then
			if A.lvl > B.lvl then
				return true
			end
			if A.lvl < B.lvl then
				return false
			end
			if A.lvl == B.lvl then
				if A.Dbid >B.Dbid then
					return true
				end
				if A.Dbid < B.Dbid then
					return false
				end
				if A.Dbid == B.Dbid then
					return false
				end
			end
		end
	end
end

function PlayerInfo:GetMemberInfo(_HeroUUID , _SoldierId , _PosX , _PosY)
   local _Hero = self:GetHero(_HeroUUID)
   local _UUID = _HeroUUID
   local _HeroDbid = _Hero.Dbid
   local _Herolvl = _Hero.lvl
   local _HeroQuaLvl = _Hero.qualityLvl
   local _nowsitzuoqipname = _Hero.nowsitzuoqipname

   local _Soldier = self:GetSoldier(_SoldierId)
   local _SoldierDbid = _SoldierId
   local _Soldierlvl = nil
   local _SoldierQuaLvl = nil
   local _SoldierHpList = {}

   if _Soldier==nil then
      _Soldierlvl = nil
      _SoldierQuaLvl = nil
      _SoldierHpList = nil
   else
      _Soldierlvl = _Soldier.lvl
      _SoldierQuaLvl = _Soldier.qualityLvl
      _SoldierHpList = {}
   end
   
   local data = 
   {
      HeroDbid = _HeroDbid,
      Herolvl = _Herolvl,
      Heroqulitylvl = _HeroQuaLvl,
      Herouuid = _UUID,
      Heronowsitzuoqipname = _nowsitzuoqipname,
      SoldierDbid = _SoldierDbid,
      Soldierlvl = _Soldierlvl,
      Soldierqulitylvl = _SoldierQuaLvl,
      PosX = _PosX,
      PosY = _PosY,
      HeroHp = -1,
      SoldierNum = -1,
      SoldierHpList = _SoldierHpList,
   }
   return data
end

function PlayerInfo:GetHero(_UUID)
   if _UUID==nil then
      return nil
   end
   for i =1 , #self.HeroList , 1 do
       if self.HeroList[i].UUID == _UUID then
          return self.HeroList[i]
       end
   end
end

function PlayerInfo:GetSoldier(_SoldierId)
   if _SoldierId==nil then
      return nil
   end
   for i =1 , #self.SoliderList , 1 do
       if self.SoliderList[i].Dbid == _SoldierId then
          return self.SoliderList[i]
       end
   end
end

return PlayerInfo
--endregion
