local Whitelist = loadstring(game:HttpGet('https://raw.githubusercontent.com/meowman567/MeowHub/main/Whitelist.lua'))()
local CHWID = game:GetService("RbxAnalyticsService"):GetClientId()

local Games = {
    [4866692557] = "https://raw.githubusercontent.com/meowman567/MeowHub/main/GameScripts/AgeOfHeros.lua",
    [1012555741] = "https://raw.githubusercontent.com/meowman567/MeowHub/main/GameScripts/NPT.lua"
}

if Whitelist["Whitelisted"][CHWID] then
    local PLID = game.PlaceId
    if Games[PLID] then
        loadstring(game:HttpGet(Games[PLID]))()
    end
else
    print("You aint whitelisted gangy")
end
