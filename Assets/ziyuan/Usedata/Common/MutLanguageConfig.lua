MutLanguageConfig = {}

MutLanguageConfig.MutLanguage = {}  
function MutLanguageConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Multiplex_Language")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local Key = tostring(ObjectInfo[0])-- sqReader:GetString(0)
        local Word = tostring(ObjectInfo[1])-- sqReader:GetString(1)
		MutLanguageConfig.MutLanguage[Key] = {                            
            MutWord = Word,
		}
	end
	
end

function MutLanguageConfig.GetStringWord(_Key)
    

	
end

return MutLanguageConfig