TeamSys = {}
TeamSys.PveHeroList = {}
TeamSys.PveSoliderList = {}


function TeamSys.UpPveHero(_Role)                           --上阵英雄
	HeroPackageSys.IsSort = true
	local _Hero =
	{ 
		UUID = _Role.UUID
	}
    table.insert(TeamSys.PveHeroList , #TeamSys.PveHeroList + 1 , _Hero) 
end

function TeamSys.RePveHero(_Role)
	HeroPackageSys.IsSort = true
	local Hero = 
	{
		UUID = _Role.UUID
	}
	local index=TeamMakeSys.GetPveHeroIndex(Hero)
	if index~=nil then
		table.remove(TeamSys.PveHeroList , index)
	else
		Debug.Log("出战列表中不含有该武将")
	end
end

function TeamMakeSys.GetPveHeroIndex(_Role)
	for key,value in pairs(TeamSys.PveHeroList) do
		if value.UUID == _Role.UUID then
			return key
		end
	end
	return nil
end

function TeamSys.SaveThePveTeam()
   local Pos = ""
   for i = 1 , #TeamSys.PveHeroList , 1 do
       if i==1 then
          Pos = tostring(i).."_"..TeamSys.PveHeroList[i].UUID
       else
          Pos = Pos.."/"..tostring(i).."_"..TeamSys.PveHeroList[i].UUID
       end     
   end
   local info = "1,"..Pos
   WebEvent.SavePveHeros(info , "TeamSys.SavePveHerosCallBack" , TeamSys.SavePveHerosCallBack)
end

function TeamSys.SavePveHerosCallBack(data , _returnId)
    if _returnId==0 then
      
    elseif _returnId==1 then

    end
end

function TeamSys.ComminfoCallBack(_data)
   TeamSys.PveHeroList = {}
   for key , value in pairs(_data) do
        local ID = tonumber(key)
        if ID~=nil then
           local _Type = tonumber(value["type"])
           local _TeamInfo = tostring(value["value"])
           if _TeamInfo~="" then            
               if _Type==1 then
                  TeamSys.AnalyzePve(_TeamInfo)
               end

               if _Type==2 then
                  TeamSys.AnalyzePvp(_TeamInfo)
               end 

               if _Type == 3 then
                  TeamSys.AnalyzeJJC(_TeamInfo)
               end
           end
        end
    end
end



function TeamSys.AnalyzePve(_TeamInfo)  --解析pve
    TeamSys.PveHeroList = {}
    local _TeamInfoList = GameMain.StringSplit(_TeamInfo , "/") 
    for i = 1 , #_TeamInfoList , 1 do
        local _Team = GameMain.StringSplit(_TeamInfoList[i] , "_")
        local _Pos = tonumber(_Team[1])
        local _UUID = tostring(_Team[2])
        local _Hero =
		{
			UUID = _UUID,
		} --HeroPackageSys.GetOneHeroBy_UUID(_UUID)
--		if _Hero ~= nil then
--		   _Hero.IsUp = true
--		end
        table.insert(TeamSys.PveHeroList , #TeamSys.PveHeroList + 1 , _Hero) 
    end
end

function TeamSys.AnalyzePvp(_TeamInfo)  --解析pvp
    TeamSys.PvpTeamInfo = {}
    local _TT = GameMain.StringSplit(_TeamInfo , ";")
    local _NowTeamType = tonumber(_TT[1])
    TeamSys.SetPvpTeamType(_NowTeamType)
    local _TeamInfoList = GameMain.StringSplit(_TT[2] , "#")
  
    for i = 1 , #_TeamInfoList , 1 do
        local _Team = _TeamInfoList[i]
        if _Team~="" then      
            local _TempTeam = GameMain.StringSplit(_Team , "=")
            local _TeamId = tonumber(_TempTeam[1])
            local _TempTeamList = _TempTeam[2]
            if TeamSys.PvpTeamInfo[_TeamId]==nil then
               TeamSys.PvpTeamInfo[_TeamId] = {}
            end
            local _TeamList = GameMain.StringSplit(_TempTeamList , "/")
            for i = 1 , #_TeamList , 1 do
                local _T = _TeamList[i]
                local _TT = GameMain.StringSplit(_T , "_")
                local _UUID = _TT[1]
                local _SoldierID = tonumber(_TT[2])
                local _X = tonumber(_TT[3])
                local _Y = tonumber(_TT[4])
                local data = 
                {
                   PvpHeroUUID = _UUID,
                   PvpSoldierId = _SoldierID,
                   PosX = _X,
                   PosY = _Y,
                }
                table.insert(TeamSys.PvpTeamInfo[_TeamId] , #TeamSys.PvpTeamInfo[_TeamId] + 1 , data)  

            end
        end
    end
end

function TeamSys.AnalyzeJJC(_TeamInfo) --解析jjc
    TeamSys.JJCTeamInfo = {}
    local _TT = GameMain.StringSplit(_TeamInfo , ";")
    local _NowTeamType = tonumber(_TT[1])
    TeamSys.SetJJCTeamType(_NowTeamType)
    local _TeamInfoList = GameMain.StringSplit(_TT[2] , "#")
    
    for i = 1 , #_TeamInfoList , 1 do
        local _Team = _TeamInfoList[i]
        local _TempTeam = GameMain.StringSplit(_Team , "=")
        local _TeamId = tonumber(_TempTeam[1])
        local _TempTeamList = _TempTeam[2]
        if TeamSys.JJCTeamInfo[_TeamId]==nil then
           TeamSys.JJCTeamInfo[_TeamId] = {}
        end
        local _TeamList = GameMain.StringSplit(_TempTeamList , "/")
        for i = 1 , #_TeamList , 1 do
            local _T = _TeamList[i]
            local _TT = GameMain.StringSplit(_T , "_")
            local _UUID = _TT[1]
            local _X = tonumber(_TT[2])
            local _Y = tonumber(_TT[3])
            local data = 
            {
               PvpHeroUUID = _UUID,
               PosX = _X,
               PosY = _Y,
            }
            table.insert(TeamSys.JJCTeamInfo[_TeamId] , #TeamSys.JJCTeamInfo[_TeamId] + 1 , data)  

        end
    end
end

function TeamSys.GetPveHeros()
    return TeamSys.PveHeroList
end

function TeamSys.GetPveSoliders()
    TeamSys.PveSoliderList = {}
    for i = 1 , #SoliderPackageSys.Soliders , 1 do
        if SoliderPackageSys.Soliders[i].isActivated==1 then
           table.insert(TeamSys.PveSoliderList , #TeamSys.PveSoliderList + 1 , SoliderPackageSys.Soliders[i])  
        end
    end
    return TeamSys.PveSoliderList
end

TeamSys.PvpTeamInfo = {}
TeamSys.NowTeamPvp = 0
TeamSys.TeamSysType = 1 --1 pvp 2 JJC
function TeamSys.SetPvpHeroInfo(_UpHeros , _TypeTeam)
   if _TypeTeam==0 then
      return
   end
   if TeamSys.PvpTeamInfo[_TypeTeam]==nil then
      TeamSys.PvpTeamInfo[_TypeTeam] = {}     
   end
   TeamSys.PvpTeamInfo[_TypeTeam] = {}

   for key , value in pairs(_UpHeros) do
       local data = 
       {
          PvpHeroUUID = value.HeroData.UUID,
          PvpSoldierId = value.SoldierId,
          PosX = value.X,
          PosY = value.Y,
       }
       table.insert(TeamSys.PvpTeamInfo[_TypeTeam] , #TeamSys.PvpTeamInfo[_TypeTeam] + 1 , data)  
   end
   
end

function TeamSys.SetPvpTeamType(_TeamType)
   TeamSys.NowTeamPvp = _TeamType
end

function TeamSys.SavePvpTeam()
   local Pos = ""
   local Count = 0
   for key , value in pairs(TeamSys.PvpTeamInfo) do
       if #value~=0 then
           Count = Count + 1
       
           if Count > 1 then
              Pos = Pos.."#"
           end
           for i = 1 , #value , 1 do      
               if i == 1 then
                  Pos =Pos..tostring(key).."="..tostring(value[i].PvpHeroUUID).."_"..tostring(value[i].PvpSoldierId).."_"..tostring(value[i].PosX).."_"..tostring(value[i].PosY)
               else
                  Pos = Pos.."/"..tostring(value[i].PvpHeroUUID).."_"..tostring(value[i].PvpSoldierId).."_"..tostring(value[i].PosX).."_"..tostring(value[i].PosY)
               end          
           end
       end
   end

   local info = "2,"..tostring(TeamSys.NowTeamPvp)..";"..Pos
   WebEvent.SavePveHeros(info , "TeamSys.SavePvpTeamCallBack" , TeamSys.SavePvpTeamCallBack)
end

function TeamSys.SavePvpTeamCallBack(data , _returnId)
    if _returnId==0 then
       GameVersion.ChangeTeamVersion()
    end
end

TeamSys.PvpTeamList = {}
function TeamSys.GetPvpTeam()
   TeamSys.PvpTeamList = {} 
   if TeamSys.PvpTeamInfo[TeamSys.NowTeamPvp]~=nil then
       local _PvpTeam = TeamSys.PvpTeamInfo[TeamSys.NowTeamPvp]
       for i = 1 , #_PvpTeam , 1 do
           local _PvpHeroInfo = _PvpTeam[i]
           local _Member = TeamSys.GetMemberInfo(_PvpHeroInfo.PvpHeroUUID , _PvpHeroInfo.PvpSoldierId , _PvpHeroInfo.PosX , _PvpHeroInfo.PosY)
           table.insert(TeamSys.PvpTeamList , #TeamSys.PvpTeamList + 1 , _Member)         
       end
       if #_PvpTeam == 0 then
          local _tempHero = HeroPackageSys.Heros[1]
          local _tempSoldier = SoliderPackageSys.Soliders[1]
          local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , _tempSoldier.Dbid , 10 , 10)    
           table.insert(TeamSys.PvpTeamList , #TeamSys.PvpTeamList + 1 , _Member)
       end
   else
      local _tempHero = HeroPackageSys.Heros[1]
      local _tempSoldier = SoliderPackageSys.Soliders[1]
      local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , _tempSoldier.Dbid , 10 , 10)    
      table.insert(TeamSys.PvpTeamList , #TeamSys.PvpTeamList + 1 , _Member)
   end

   return TeamSys.PvpTeamList
end

function TeamSys.GetPVPDefaltTeam()
   local data = {}
   local _tempHero = HeroPackageSys.Heros[1]
   local _tempSoldier = SoliderPackageSys.Soliders[1]
   local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , _tempSoldier.Dbid , 10 , 10)    
   table.insert(data , #data + 1 , _Member)
   return data
end

function TeamSys.GetTeamInfoByType(_TeamType)
   if TeamSys.PvpTeamInfo[_TeamType]~=nil then
      return TeamSys.PvpTeamInfo[_TeamType]
   end
end

function TeamSys.GetMemberInfo(_HeroUUID , _SoldierId , _PosX , _PosY)
   local _Hero = HeroPackageSys.GetOneHeroBy_UUID(_HeroUUID)

   local _UUID = _HeroUUID
   local _HeroDbid = _Hero.Dbid
   local _Herolvl = _Hero.lvl
   local _HeroQuaLvl = _Hero.qualityLvl
   local _nowsitzuoqipname = _Hero.nowsitzuoqipname

   local _Soldier = nil
   local _SoldierDbid = 0
   local _Soldierlvl = 0
   local _SoldierQuaLvl = 0
   local _SoldierHpList = {}

   if _SoldierId~=nil then
      _Soldier = SoliderPackageSys.GetOneSolider(_SoldierId)
      _SoldierDbid = _SoldierId
      _Soldierlvl = _Soldier.lvl
      _SoldierQuaLvl = _Soldier.qualityLvl
   else

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


function TeamSys.GetPvpTeamUpInfo()
   local _data = {}
   for i = 1 , 4 , 1 do
       if TeamSys.PvpTeamInfo[i]==nil then
          table.insert(_data , #_data + 1 , 0)
       else
          if #TeamSys.PvpTeamInfo[i]==0 then
             table.insert(_data , #_data + 1 , 0)
          else
             table.insert(_data , #_data + 1 , 1)
          end
       end
   end
   return _data
end

function TeamSys.GetBossMapTeam()
   local _MapInfo = GameMain.JsonDecode(MapSys.Map.MapData.Config)
   local _data = {}
   _data = _MapInfo[1]  
   local _SoldierHpList = {}
   _data.Herouuid = nil
   _data.HeroHp = -1
   _data.SoldierNum = -1
   _data._SoldierHpList = _SoldierHpList
    GameMain.Print(_data)
   return _data
  
end


--[[function TeamSys.GetPvpHeroPos(_PosX , _PosY)
   local HeroPos = 
   {
      X = _PosX + 2,
      Y = _PosY - 1,
   }
   return HeroPos
end--]]

--[[function TeamSys.GetSoldiersPos(_PosX , _PosY , _SoldierNum)
   local SoldiersPos = 
   {

   }
  Debug.LogError(_SoldierNum)
   if _SoldierNum==1 then                               --英雄
      SoldiersPos[1] = {}
      SoldiersPos[1] = 
      {
        X = _PosX + 2,
        Y = _PosY - 1,
      }
   elseif _SoldierNum==2 then
      for i = 1 , _SoldierNum , 1 do
          SoldiersPos[i] = {}
      end
      SoldiersPos[1] = 
      {
          X = _PosX - 3,
          Y = _PosY,
      }
      SoldiersPos[2]  =
      {
          X = _PosX - 3,
          Y = _PosY - 2,
      } 
   elseif _SoldierNum==4 then
      for i = 1 , _SoldierNum , 1 do
          SoldiersPos[i] = {}
      end
      SoldiersPos[1] = 
      {
          X = _PosX - 1,
          Y = _PosY,
      }
      SoldiersPos[2]  =
      {
          X = _PosX - 1,
          Y = _PosY - 2,
      }
      SoldiersPos[3]  =
      {
          X = _PosX - 3,
          Y = _PosY ,
      }
      SoldiersPos[4]  =
      {
          X = _PosX - 3,
          Y = _PosY - 2,
      }
   elseif _SoldierNum==8 then
      for i = 1 , _SoldierNum , 1 do
          SoldiersPos[i] = {}
      end
      SoldiersPos[1] = 
      {
          X = _PosX,
          Y = _PosY + 1,
      }
      SoldiersPos[2]  =
      {
          X = _PosX,
          Y = _PosY,
      }
      SoldiersPos[3]  =
      {
          X = _PosX,
          Y = _PosY - 1,
      }
      SoldiersPos[4]  =
      {
          X = _PosX,
          Y = _PosY - 2,
      }
      SoldiersPos[5] = 
      {
          X = _PosX - 2,
          Y = _PosY + 1,
      }
      SoldiersPos[6]  =
      {
          X = _PosX - 2,
          Y = _PosY,
      }
      SoldiersPos[7]  =
      {
          X = _PosX - 2,
          Y = _PosY - 1,
      }
      SoldiersPos[8]  =
      {
          X = _PosX - 2,
          Y = _PosY - 2,
      }
   end
   return SoldiersPos
end--]]

TeamSys.JJCTeamInfo = {}
function TeamSys.SetJJCHeroInfo(_UpHeros , _TypeTeam)
    if _TypeTeam==0 then
      return
   end
   if TeamSys.JJCTeamInfo[_TypeTeam]==nil then
      TeamSys.JJCTeamInfo[_TypeTeam] = {}     
   end
   TeamSys.JJCTeamInfo[_TypeTeam] = {}

   for key , value in pairs(_UpHeros) do
       local data = 
       {
          PvpHeroUUID = value.HeroData.UUID,
          --PvpSoldierId = value.SoldierId,
          PosX = value.X,
          PosY = value.Y,
       }
       table.insert(TeamSys.JJCTeamInfo[_TypeTeam] , #TeamSys.JJCTeamInfo[_TypeTeam] + 1 , data)  
   end   
end

TeamSys.NowTeamJJC = 0
function TeamSys.SetJJCTeamType(_TeamType)
   TeamSys.NowTeamJJC = _TeamType
end

function TeamSys.GetJJCTeamInfoByType(_TeamType)
   if TeamSys.JJCTeamInfo[_TeamType]~=nil then
      return TeamSys.JJCTeamInfo[_TeamType]
   else
      return nil
   end
end

TeamSys.JJCTeamList = {}
function TeamSys.GetJJCTeam()
   TeamSys.JJCTeamList = {} 
   if TeamSys.JJCTeamInfo[TeamSys.NowTeamJJC]~=nil then
       local _JJCTeam = TeamSys.JJCTeamInfo[TeamSys.NowTeamJJC]
       for i = 1 , #_JJCTeam , 1 do
           local _JJCHeroInfo = _JJCTeam[i]
           local _Member = TeamSys.GetMemberInfo(_JJCHeroInfo.PvpHeroUUID , nil , _JJCHeroInfo.PosX , _JJCHeroInfo.PosY)
           table.insert(TeamSys.JJCTeamList , #TeamSys.JJCTeamList + 1 , _Member)         
       end
       if #_JJCTeam == 0 then
          local _tempHero = HeroPackageSys.Heros[1]
          local _tempSoldier = SoliderPackageSys.Soliders[1]
          local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , nil , 10 , 10)    
           table.insert(TeamSys.JJCTeamList , #TeamSys.JJCTeamList + 1 , _Member)
       end
   else
      local _tempHero = HeroPackageSys.Heros[1]
      local _tempSoldier = SoliderPackageSys.Soliders[1]
      local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , nil , 10 , 10)    
      table.insert(TeamSys.JJCTeamList , #TeamSys.JJCTeamList + 1 , _Member)
   end

   return TeamSys.JJCTeamList
end

function TeamSys.GetJJCDefaltTeam()
   local data = {}
   local _tempHero = HeroPackageSys.Heros[1]
   local _Member = TeamSys.GetMemberInfo(_tempHero.UUID , nil , 10 , 10)    
   table.insert(data , #data + 1 , _Member)
   return data
end

function TeamSys.SaveJJCTeam()
   local Pos = ""
   local Count = 0
   for key , value in pairs(TeamSys.JJCTeamInfo) do
       if #value~=0 then
           Count = Count + 1
       
           if Count > 1 then
              Pos = Pos.."#"
           end
           for i = 1 , #value , 1 do      
               if i == 1 then
                  Pos =Pos..tostring(key).."="..tostring(value[i].PvpHeroUUID).."_"..tostring(value[i].PosX).."_"..tostring(value[i].PosY)
               else
                  Pos = Pos.."/"..tostring(value[i].PvpHeroUUID).."_"..tostring(value[i].PosX).."_"..tostring(value[i].PosY)
               end          
           end
       end
   end

   local info = "3,".. tostring(TeamSys.NowTeamPvp)..";".. Pos
   WebEvent.SavePveHeros(info , "TeamSys.SaveJJCTeamCallBack" , TeamSys.SaveJJCTeamCallBack)
end

function TeamSys.SaveJJCTeamCallBack(data , _returnId)
    if _returnId==0 then
       GameVersion.ChangeTeamVersion()
    end
end

function TeamSys.GetJJCTeamUpInfo()
   local _data = {}
   for i = 1 , 4 , 1 do
       if TeamSys.JJCTeamInfo[i]==nil then
          table.insert(_data , #_data + 1 , 0)
       else
          if #TeamSys.JJCTeamInfo[i]==0 then
             table.insert(_data , #_data + 1 , 0)
          else
             table.insert(_data , #_data + 1 , 1)
          end
       end
   end
   return _data
end

function TeamSys.GetUpTeams(_UUID)

   for i = 1 , #TeamSys.PveHeroList , 1 do
       if _UUID == TeamSys.PveHeroList[i].UUID then
          return false
       end
   end

   for key , value in pairs(TeamSys.PvpTeamInfo) do
       for i = 1 , #value , 1 do
           if _UUID == value[i].PvpHeroUUID then
              return false
           end
       end
   end

   for key , value in pairs(TeamSys.JJCTeamInfo) do
       for i = 1 , #value , 1 do
           if _UUID == value[i].PvpHeroUUID then
              return false
           end
       end
   end

   return true
end

function TeamSys.ReSetHeroUUID(_OldUUID , _NewUUID)

   for i = 1 , #TeamSys.PveHeroList , 1 do
       if _OldUUID == TeamSys.PveHeroList[i].UUID then
          TeamSys.PveHeroList[i].UUID = _NewUUID
       end
   end

   for key , value in pairs(TeamSys.PvpTeamInfo) do
       for i = 1 , #value , 1 do
           if _OldUUID == value[i].PvpHeroUUID then
              value[i].PvpHeroUUID = _NewUUID
           end
       end
   end

   for key , value in pairs(TeamSys.JJCTeamInfo) do
       for i = 1 , #value , 1 do
           if _OldUUID == value[i].PvpHeroUUID then
              value[i].PvpHeroUUID = _NewUUID
           end
       end
   end
   
end



function TeamSys.ReSetSoldierID(_OldID , _NewID)
   for key , value in pairs(TeamSys.PvpTeamInfo) do
       for i = 1 , #value , 1 do
           if _OldID == value[i].PvpSoldierId then
              value[i].PvpSoldierId = _NewID
           end
       end
   end
end

function TeamSys.ClearData()
   
   TeamSys.PveHeroList = {}
   TeamSys.PveSoliderList = {}

end

return TeamSys