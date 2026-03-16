--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
MusicManagerSys = {}


function MusicManagerSys.LoginMusic()		--登录背景音乐
	local clipInfo = SoundConfig.GetClipByKey("Login")
	if clipInfo ~= nil then
		MusicManagerSys.PlayBGMusic(clipInfo.Name)
	end
	
end

function MusicManagerSys.CastleMusic()		--主城背景音乐
	local clipInfo = SoundConfig.GetClipByKey("Castle")
	if clipInfo ~= nil then
		MusicManagerSys.PlayBGMusic(clipInfo.Name)
	end
	
end

function MusicManagerSys.ControyBattleMusic()		--攻城略地背景
	local clipInfo = SoundConfig.GetClipByKey("GongChengLueDi")
	if clipInfo ~= nil then
		MusicManagerSys.PlayBGMusic(clipInfo.Name)
	end
	
end

function MusicManagerSys.PvpBattleMusic()		--沙场点兵、斗将台、国战战斗通用音效
	local clipInfo = SoundConfig.GetClipByKey("Battle")
	if clipInfo ~= nil then
		MusicManagerSys.PlayBGMusic(clipInfo.Name)
	end
	
end

function MusicManagerSys.ButtonClick()		--点击音效
	local clipInfo = SoundConfig.GetClipByKey("Button_Click")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
	
end

function MusicManagerSys.GuideSound( _soundName)		--播放引导声音
	if _soundName ~= nil then
		return MusicManagerSys.PlayMusic(_soundName , false)
	end
	return nil
end

function MusicManagerSys.BattleBg(_Id)
	local mapData =  MapConfig.GetMapConfigById(_Id)
	if mapData ~= nil then
		MusicManagerSys.PlayBGMusic(mapData.Music)
	end
end

function MusicManagerSys.HireHeroMusic()		--招募音效
	local clipInfo = SoundConfig.GetClipByKey("Enlist")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.HireHeroSuccessMusic()		--招募成功
	local clipInfo = SoundConfig.GetClipByKey("Enlist_Success")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.Raffle()		--抽奖
	local clipInfo = SoundConfig.GetClipByKey("Raffle")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.Reward()		--获得奖励
	local clipInfo = SoundConfig.GetClipByKey("Gain_Reward")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.BattleAfter(_Win)
	if _Win == 1 then
		MusicManagerSys.BattleWin()
	else
		MusicManagerSys.BattleError()
	end
end

function MusicManagerSys.BattleWin()	--战斗胜利
	local clipInfo = SoundConfig.GetClipByKey("Battle_Win")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.BattleError()	--战斗失败
	local clipInfo = SoundConfig.GetClipByKey("Battle_Lose")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.DressEquip()	--穿戴装备
	local clipInfo = SoundConfig.GetClipByKey("Equip_Up")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.DressUpEquip()	--卸载装备
	local clipInfo = SoundConfig.GetClipByKey("Equip_Down")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.HeroCommand()	--武将挂帅
	local clipInfo = SoundConfig.GetClipByKey("Hero_Command")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.HeroFire()	--武将解雇
	local clipInfo = SoundConfig.GetClipByKey("Hero_Fire")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.HeroAtkOrStop()	--武将出战，侯战
	local clipInfo = SoundConfig.GetClipByKey("Hero_Up")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.Train()	--训练
	local clipInfo = SoundConfig.GetClipByKey("Train")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.HeroTransfer()	--武将转生
	local clipInfo = SoundConfig.GetClipByKey("Hero_Transmigration")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.SoliderUpGrade()	--士兵进阶
	local clipInfo = SoundConfig.GetClipByKey("Soldier_Advanced")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.EquipSmelt()	--冶炼
	local clipInfo = SoundConfig.GetClipByKey("Equip_Smelt")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.StrengthSuccess()	--强化成功
	local clipInfo = SoundConfig.GetClipByKey("Strengthen_Success")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.StrengthFail()	--强化失败
	local clipInfo = SoundConfig.GetClipByKey("Strengthen_Fail")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.EquipRecast()	--重铸
	local clipInfo = SoundConfig.GetClipByKey("Equip_Recast")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.EquipWash()	--洗炼
	local clipInfo = SoundConfig.GetClipByKey("Equip_Wash")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.TechnologyInjection()	--科技注资 ， 研究
	local clipInfo = SoundConfig.GetClipByKey("Technology_Injection")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.AtkCountryBg()	--攻城略地背景音乐
	local clipInfo = SoundConfig.GetClipByKey("GongChengLueDi")
	MusicManagerSys.PlayBGMusic(clipInfo.Name)
end

function MusicManagerSys.Collect()	--征收
	local clipInfo = SoundConfig.GetClipByKey("Collection")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
	
end

function MusicManagerSys.PalaceBg()	--王宫
	local clipInfo = SoundConfig.GetClipByKey("WangGong")
	if clipInfo~= nil then
		MusicManagerSys.PlayBGMusic(clipInfo.Name)
	end
	
end

function MusicManagerSys.PlayerUpLvl()	--玩家升级
	local clipInfo = SoundConfig.GetClipByKey("Level_Up")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.SellItem()	--出售道具
	local clipInfo = SoundConfig.GetClipByKey("Item_Sell")
	if clipInfo ~= nil then
		MusicManagerSys.PlayMusic(clipInfo.Name , false)
	end
end

function MusicManagerSys.PlayHeroSound(_SoundName)		--武将声音
	return MusicManagerSys.PlayMusic(_SoundName , false)
end

function MusicManagerSys.GetBgToggleState()
	local isOpen = AudioManager.Instance:GetBgToggleState()
	return isOpen
end

function MusicManagerSys.GetClipToggleState()
	local isOpen = AudioManager.Instance:GetClipToggleState()
	return isOpen
end

function MusicManagerSys.ToggleBg(_IsOpen)
	 AudioManager.Instance:ToggleBG(_IsOpen)
end

function MusicManagerSys.ToggleClip(_IsOpen)
	 AudioManager.Instance:ToggleClip(_IsOpen)
end

function MusicManagerSys.StopSomeMusic(_Music)
--	GameMain.Print("_Music" .. _Music)
	--Debug.LogError(_Music)
   AudioManager.Instance:Stop(_Music)
end

function MusicManagerSys.PlayMusic(_MusicName , _bool)
   if _MusicName=="" then
      return
   end

   return AudioManager.Instance:Play(_MusicName , _bool , 0)
end

function MusicManagerSys.PlayBGMusic(_MusicName)
	if _MusicName=="" then
      return
   end

  AudioManager.Instance:PlayBG(_MusicName)
end

return MusicManagerSys
--endregion
