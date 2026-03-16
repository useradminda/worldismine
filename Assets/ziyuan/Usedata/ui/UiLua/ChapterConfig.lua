ChapterConfig = {}                                                            
ChapterConfig.ChapterConfig = {}
ChapterConfig.Number = 0
function ChapterConfig.IniSome()
    ChapterConfig.Number = 1
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("LevelChapter")
	while (sqReader:Read() ~= false) 
	do          
		 local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
        ChapterConfig.ChapterConfig[ChapterConfig.Number] = {        
            DbId = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),                      --ID                                  
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),                   --名字  
            Count = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),                   --模型名字
            Type = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                    --生命
            Descrip = tostring(ObjectInfo[4]),--sqReader:GetString(4),                --攻击参数
            Icon = tostring(ObjectInfo[5]),--sqReader:GetString(5),                   --攻击参数 
            Turn = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),                    --攻击速度
            Pos = tostring(ObjectInfo[7]),--sqReader:GetString(7),                    --位置信息
		}
        local _PosList = GameMain.StringSplit(ChapterConfig.ChapterConfig[ChapterConfig.Number].Pos , ",")
        ChapterConfig.ChapterConfig[ChapterConfig.Number].PosX = tonumber(_PosList[1]) * 22
        ChapterConfig.ChapterConfig[ChapterConfig.Number].PosY = tonumber(_PosList[2]) * 15
        ChapterConfig.Number = ChapterConfig.Number + 1
    end
end

function ChapterConfig.GetChapterConfigById(_Id)
    for i = 1 , #ChapterConfig.ChapterConfig , 1 do
        if ChapterConfig.ChapterConfig[i]~=nil then
           if ChapterConfig.ChapterConfig[i].DbId == _Id then
              return ChapterConfig.ChapterConfig[i]
           end
        end
    end
   -- Debug.LogError("数据库LevelChapter配置错误id:")
   -- Debug.LogError(_Id)
    return nil
end

function ChapterConfig.GetChapterConfigData()
    
    return ChapterConfig.ChapterConfig

end

return ChapterConfig