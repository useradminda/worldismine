GameVersion = {}
GameVersion.TeamVersion = 1

function GameVersion.InitVersion()
   GameVersion.TeamVersion = 1
end

function GameVersion.ChangeTeamVersion()
   GameVersion.TeamVersion = GameVersion.TeamVersion + 1
end

return GameVersion