--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SoundConfig = {}
SoundConfig.SoundData = {}

function SoundConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Sound_Effect")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        local _Id = tostring(ObjectInfo[0])--sqReader:GetString(0)
        SoundConfig.SoundData[_Id] = 
        {         
            Id = _Id,                                    --Name 
            Name =  tostring(ObjectInfo[1]),--sqReader:GetString(1),      
            Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),          --exp         
			Type = tonumber(ObjectInfo[3]),--1loop 2click
		} 
        
    end
end


function SoundConfig.GetClipByKey(_Name)--根据名字得到播放的音乐
	if SoundConfig.SoundData[_Name]~= nil then
		return SoundConfig.SoundData[_Name]
	end
	Debug.LogError("数据库Sound_Effect等级配置错误_Id:")
    Debug.LogError(_Name)
	return nil
end


return SoundConfig
--endregion
