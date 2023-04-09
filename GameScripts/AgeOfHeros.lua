local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/meowman567/UILib/main/UILIBRARY_Main.lua'))()
local GuiIsActive = true
local Hidden = false

local UIS = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local playerhead = game.Players.LocalPlayer.Character.Head
--local VU = game:GetService("VirtualUser")
local ClientStorage = game:GetService("ReplicatedStorage")
local modules = ClientStorage:WaitForChild("Modules")
local shared = require(modules.SharedLocal)
local events = ClientStorage:WaitForChild("Events")
local Connections = {}

local Founders = {7506184,1544653468}
local Developers = {147548657,24635769,59121896,11073505,237922,30929052}
local Moderators = {1311715825,9754162,381012618}

local PlrSelCombat = game.Players.LocalPlayer
local FastLPEnabled = false
local FastHPEnabled = false
local KillEnabled = false
local OrbFarmEnabled = false
local NpcFarmEnabled = false
local LastCords
local SpectateEnabled = false
local RTE = false
local SCNum = 1

_G.AntiTele = false
if game.ClientStorage.Effects:FindFirstChild("Shield") then game.ClientStorage.Effects.Shield:Destroy() end
if game.Workspace.Ambience:FindFirstChild("cityAmbience") then game.Workspace.Ambience:FindFirstChild("cityAmbience"):Destroy() end


local BillboardGui = Instance.new("BillboardGui")
local TextLabel = Instance.new("TextLabel")



BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BillboardGui.Active = true
BillboardGui.AlwaysOnTop = true
BillboardGui.LightInfluence = 1.000
BillboardGui.Size = UDim2.new(0, 200, 0, 50)
BillboardGui.Enabled = false

TextLabel.Parent = BillboardGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.Gotham
TextLabel.Text = "Name"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 17.000

local ESPhightlight = Instance.new("Highlight") 
ESPhightlight.FillTransparency = 1 
ESPhightlight.OutlineColor = Color3.new(0.733333, 0.403922, 1)


local window = Library:CreateWindow({
	Name = "Meow Hub (AOH)",
	PColor = Color3.fromRGB(141, 47, 255),
	DestroyOtherInstances = false,
	PlayerRank = "dint",
	Vers = "v2"
})



local Combat = window:CreatePage({
	Name = "Combat"
})

local AutoFarm = window:CreatePage({
	Name = "Auto Farm"
})

local Teleports = window:CreatePage({
	Name = "Teleports"
})

local Misc = window:CreatePage({
	Name = "Misc"
})

local PlayerText = Combat:CreateText({
    Name = "PlayerSelected",
    Text = "Player: "
})


local PlayerSelInput = Combat:CreateInput({
    Name = "Player:",
    PlaceholderText = "Player...",
    TextChangedCallback = function(text)
        local name = ""
        for _,v in pairs(game:GetService("Players"):GetPlayers()) do
            if string.find(string.lower(v.Name), string.lower(text)) then 
                name = v.Name
                PlrSelCombat = v
                break
            end
        end
        
        PlayerText:ChangeText("Player: "..name)
        
        if name ~= game.Players.LocalPlayer.Name then
            TextLabel.Text = name
            BillboardGui.Enabled = true
            BillboardGui.Parent = PlrSelCombat.Character.HumanoidRootPart
            ESPhightlight.Parent = PlrSelCombat.Character
            
            local PlrSelCombatCharAddedConnection

            PlrSelCombatCharAddedConnection = PlrSelCombat.CharacterAdded:Connect(function(Char)
                if name ~= PlrSelCombat.Name then PlrSelCombatCharAddedConnection:Disconnect() return end
                TextLabel.Text = name
                BillboardGui.Enabled = true
                BillboardGui.Parent = Char
                ESPhightlight.Parent = Char
            end)
        end
    end
})

local Spectate

local TeleportToPlayer = Combat:CreateButton({
    Name = "Teleport to player",
	Callback = function()
		if PlrSelCombat and PlrSelCombat ~= game.Players.LocalPlayer then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PlrSelCombat.Character.HumanoidRootPart.CFrame
            SpectateEnabled = false
            Spectate:TurnOff()
            pcall(function() 
                Camera.CameraSubject = game.Players.LocalPlayer.Character
            end)
        end
	end,
})

local KillPlayer = Combat:CreateToggle({
    Name = "Kill",
    Callback = function(mode)
        
        if mode == "Enable" then 
            if PlrSelCombat then
                LastCords = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                KillEnabled = true
                while KillEnabled == true do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PlrSelCombat.Character.HumanoidRootPart.CFrame
                    local args = {
                        [1] = 0,
                        [2] = 0.1,
                        [3] = 1
                    }
                    
                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
                    wait()
                end
            end
        else
            KillEnabled = false
            if LastCords then
                game.Players.LocalPlayer.Character:MoveTo(LastCords)
            end
        end
    end
})

Spectate = Combat:CreateToggle({
    Name = "Spectate",
    Callback = function(mode)
        if mode == "Enable" then 
            SpectateEnabled = true
            if PlrSelCombat then
                pcall(function() 
                    Camera.CameraSubject = PlrSelCombat.Character
                end)
            end
        else
            SpectateEnabled = false
            pcall(function() 
                Camera.CameraSubject = game.Players.LocalPlayer.Character
            end)
        end
    end
})

Combat:SetActivePage()

local UntelekinisisPlrCombat = Combat:CreateButton({
    Name = "Untelekinesis",
    Callback = function()
        local args = {
            [1] = Vector3.new(0,0,0),
            [2] = false,
            [3] = PlrSelCombat.Character
        }
        
        game:GetService("ReplicatedStorage").Events.ToggleTelekinesis:InvokeServer(unpack(args))
    end
})


local OtherText = Combat:CreateText({
    Name = "OtherText",
    Text = "Other"
})

local FastPunchLight = Combat:CreateToggle({
    Name = "Fast light punch",
    Callback = function(mode)
        if mode == "Enable" then 
            FastLPEnabled = true
            while FastLPEnabled == true do
                local args = {
                    [1] = 0,
                    [2] = 0.1,
                    [3] = 1
                }
                
                game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
                
    
                wait()
            end
        else
            FastLPEnabled = false
        end
    end
})

local FastPunchHeavy = Combat:CreateToggle({
    Name = "Fast heavy punch",
    Callback = function(mode)
        if mode == "Enable" then 
            FastHPEnabled = true
            while FastHPEnabled == true do
                local args = {
                    [1] = 0.3,
                    [2] = 0.1,
                    [3] = 1
                }
    
                game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
    
                wait()
            end
        else
            FastHPEnabled = false
        end
    end
})


local ToFMF =  Teleports:CreateButton({
    Name = "To FMF",
	Callback = function()
        if game.Players:FindFirstChild("friendlymasonfries") then
            game.Players.LocalPlayer.Character:MoveTo(game.Players.friendlymasonfries.Character.HumanoidRootPart.Position)
        end
	end,
})

local ToPFT =  Teleports:CreateButton({
    Name = "To PFT",
	Callback = function()
        if game.Players:FindFirstChild("pftrickshoteasy") then
            game.Players.LocalPlayer.Character:MoveTo(game.Players.pftrickshoteasy.Character.HumanoidRootPart.Position)
        end
	end,
})

local ToHideout = Teleports:CreateButton({
    Name = "To Hideout",
	Callback = function()
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(1139.334228515625, 120.52025604248047, 2286.689697265625))
	end,
})

local ToCent =  Teleports:CreateButton({
    Name = "To center",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-392.3270568847656, 85.61033630371094, 264.94403076171875))
	end,
})

local ToGH =  Teleports:CreateButton({
    Name = 'To "gangster hideout"',
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1688.51171875, 94.35016632080078, -1296.6011962890625))
	end,
})

local ToBunker =  Teleports:CreateButton({
    Name = "To bunker",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-887.03857421875, 30.93828773498535, -1128.0125732421875))
	end,
})

local ToITower =  Teleports:CreateButton({
    Name = "To ignite tower",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-74.70062255859375, 616.3413696289062, -241.7279815673828))
	end,
})

local ToSpawnTower =  Teleports:CreateButton({
    Name = "To elev. park",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1781.3507080078125, 442.85205078125, 1289.9066162109375))
	end,
})

local PartyGangCuh =  Teleports:CreateButton({
    Name = "To party gang cuh",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-1330.8551025390625, 197.87322998046875, 136.35740661621094))
	end,
})

local dumbcave =  Teleports:CreateButton({
    Name = "To dumb cave",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(2123.288818359375, 49.65060043334961, -2055.68798828125))
	end,
})

local footballfield =  Teleports:CreateButton({
    Name = "To football field",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(2186.802490234375, 107.1019058227539, 41.05110168457031))
	end,
})


local Mountian =  Teleports:CreateButton({
    Name = "To mountian spawn",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-2230.237548828125, 818.749755859375, -2275.942138671875))
	end,
})

local Castle =  Teleports:CreateButton({
    Name = "To Castle",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-989.0612182617188, 329.7601623535156, -2577.319580078125))
	end,
})


local ClickTP =  Misc:CreateButton({
    Name = "Click TP",
	Callback = function()
		local tool = Instance.new("Tool")
	    tool.RequiresHandle = false
	    tool.Name = "Click Teleport"
	    tool.Activated:connect(function()
		    local pos = mouse.Hit+Vector3.new(0,2.5,0)
		    pos = CFrame.new(pos.X,pos.Y,pos.Z)
		    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
	    end)
	    tool.Parent = game.Players.LocalPlayer.Backpack
	end,
})

local God = Combat:CreateButton({
    Name = "God",
	Callback = function()
		
        game.Workspace[game.Players.LocalPlayer.Name].LowerTorso.Root:Destroy()
        
        for x,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart.titleGui:GetChildren()) do
            v:Destroy()
            
        end        
	end,
})

local RepeatTele = Combat:CreateToggle({
    Name = "Spam Tele",
    Callback = function(mode)
        if mode == "Enable" then
            RTE = trueee
            repeat
                local v3 = shared.GetCamDirection()
                events.ToggleTelekinesis:InvokeServer(v3, true)

                local v3 = shared.GetCamDirection()
                events.ToggleTelekinesis:InvokeServer(v3, false)

                wait(0.05)
            until RTE == false
        else
            RTE = false
        end
    end
})

local AntiTele = Combat:CreateToggle({
    Name = "Anti Telekenisis",
    Callback = function(mode)
        if mode == "Enable" then
            _G.AntiTele = true
            local connection
            Connections["AntiTele1"] = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
                if _G.AntiTele == false then return end
                if child.Name == "telekinesisGyro" then
                    
                    local v3 = shared.GetCamDirection()
                    events.ToggleTelekinesis:InvokeServer(v3, false, game.Players.LocalPlayer.Character)
                end
            end)
        else
            _G.AntiTele = false
        end
    end
})

local removeTele = Misc:CreateButton({
    Name = "Untelekinisis",
	Callback = function()
        local v3 = shared.GetCamDirection()
        events.ToggleTelekinesis:InvokeServer(v3, false, game.Players.LocalPlayer.Character)
    end
})


local OrbFarm = AutoFarm:CreateToggle({
    Name = "Orb Farm",
    Callback = function(mode)
        if mode == "Enable" then 
            OrbFarmEnabled = true
            for i,v in pairs(game.Workspace.ExperienceOrbs:GetChildren()) do
                firetouchinterest(playerhead,v,0)

                firetouchinterest(playerhead,v,1)
                
            end
            while OrbFarmEnabled == true do
                --VU:CaptureController()VU:ClickButton2(Vector2.new())
                wait(01)
                

            end
        else
            OrbFarmEnabled = false
        end
    end
})

local NpcFarm = AutoFarm:CreateToggle({
    Name = "NPC Farm",
    Callback = function(mode)
        if mode == "Enable" then 
            NpcFarmEnabled = true
            for x,v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "Thug" or v.Name == "Civilian" or v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 1 then
                    
                    
            
                    repeat 
                    pcall(function()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                    local args = {
                        [1] = 0,
                        [2] = 0.1,
                        [3] = 1
                    }
                    
                    game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
                    wait(0.05)
                end)
                    until v:FindFirstChild("Humanoid") == nil or v.Humanoid.Health < 1
                end
            end
        else
            NpcFarmEnabled = false
        end
    end
})

local CrashAmmount = Misc:CreateInput({
    Name = "Amount",
    PlaceholderText = "Number",
    TextChangedCallback = function(text)
        if tonumber(text) then SCNum = tonumber(text) end
    end
})

local DoCrash = Misc:CreateButton({
    Name = "Do crash lol",
    Callback = function()
        for x = 1, SCNum do
            game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(true)
        end
        game:GetService("ReplicatedStorage").Events.ToggleBlocking:FireServer(false)
    end
})



local circlecords = {
    [1] = Vector3.new(1493.1510009765625, 94.1001968383789, 42.777618408203125), 
    [2] = Vector3.new(1487.2139892578125, 94.09964752197266, -71.85914611816406), 
    [3] = Vector3.new(1489.2486572265625, 94.0999526977539, -391.72412109375), 
    [4] = Vector3.new(1492.8558349609375, 94.0999526977539, -651.07470703125), 
    [5] = Vector3.new(1496.340576171875, 94.0999526977539, -919.0726318359375), 
    [6] = Vector3.new(1497.0404052734375, 94.0999526977539, -1121.384033203125), 
    [7] = Vector3.new(1495.4608154296875, 94.0999526977539, -1327.1373291015625), 
    [8] = Vector3.new(1445.874267578125, 94.1001968383789, -1495.4305419921875), 
    [9] = Vector3.new(1282.0535888671875, 94.1001968383789, -1512.3060302734375), 
    [10] = Vector3.new(987.1604614257812, 94.1001968383789, -1491.9844970703125), 
    [11] = Vector3.new(881.7656860351562, 94.1001968383789, -1487.74755859375), 
    [12] = Vector3.new(669.2483520507812, 94.1001968383789, -1479.2042236328125), 
    [13] = Vector3.new(420.44757080078125, 94.1001968383789, -1469.2022705078125), 
    [14] = Vector3.new(213.1139678955078, 94.1001968383789, -1460.8673095703125), 
    [15] = Vector3.new(69.709228515625, 94.1001968383789, -1455.102294921875), 
    [16] = Vector3.new(-201.55055236816406, 94.1001968383789, -1444.1973876953125), 
    [17] = Vector3.new(-585.2322387695312, 94.1001968383789, -1437.3037109375), 
    [18] = Vector3.new(-804.79248046875, 94.1001968383789, -1441.5050048828125), 
    [19] = Vector3.new(-1067.5748291015625, 94.1001968383789, -1446.5333251953125), 
    [20] = Vector3.new(-1423.7244873046875, 94.1001968383789, -1453.3480224609375), 
    [21] = Vector3.new(-1689.9722900390625, 94.09994506835938, -1458.4425048828125), 
    [22] = Vector3.new(-1841.7183837890625, 94.0999526977539, -1445.475830078125), 
    [23] = Vector3.new(-1885.5421142578125, 94.32495880126953, -1220.6575927734375), 
    [24] = Vector3.new(-1886.4697265625, 94.32495880126953, -760.74658203125), 
    [25] = Vector3.new(-1883.654296875, 94.32495880126953, -439.1304626464844), 
    [26] = Vector3.new(-1880.94482421875, 95.09989166259766, -129.62237548828125), 
    [27] = Vector3.new(-1878.67431640625, 94.0971450805664, 129.7428436279297), 
    [28] = Vector3.new(-1876.16162109375, 94.0999526977539, 416.772705078125), 
    [29] = Vector3.new(-1874.58740234375, 94.0999526977539, 596.60009765625), 
    [30] = Vector3.new(-1872.150390625, 94.0999526977539, 874.9893798828125), 
    [31] = Vector3.new(-1870.39453125, 94.0999526977539, 1075.5679931640625), 
    [32] = Vector3.new(-1868.32080078125, 94.0999526977539, 1312.458251953125), 
    [33] = Vector3.new(-1847.7164306640625, 94.0999526977539, 1432.3079833984375), 
    [34] = Vector3.new(-1589.0340576171875, 94.1001968383789, 1530.6817626953125), 
    [35] = Vector3.new(-1151.7930908203125, 94.1001968383789, 1535.228515625), 
    [36] = Vector3.new(-847.4606323242188, 94.1001968383789, 1534.69140625), 
    [37] = Vector3.new(-560.4155883789062, 94.1001968383789, 1534.184814453125), 
    [38] = Vector3.new(-288.93719482421875, 94.1001968383789, 1533.7056884765625), 
    [39] = Vector3.new(15.394983291625977, 94.1001968383789, 1533.1685791015625), 
    [40] = Vector3.new(247.10244750976562, 94.1001968383789, 1532.7596435546875), 
    [41] = Vector3.new(473.6219482421875, 94.1001968383789, 1532.35986328125), 
    [42] = Vector3.new(729.5409545898438, 94.1001968383789, 1531.908203125), 
    [43] = Vector3.new(987.1898193359375, 94.1001968383789, 1531.4534912109375), 
    [44] = Vector3.new(1211.9775390625, 94.1001968383789, 1531.0567626953125), 
    [45] = Vector3.new(1441.6226806640625, 94.1001968383789, 1525.4366455078125), 
    [46] = Vector3.new(1541.465576171875, 94.32463836669922, 1340.1419677734375), 
    [47] = Vector3.new(1520.728515625, 94.0999526977539, 1093.7928466796875), 
    [48] = Vector3.new(1504.9423828125, 94.0999526977539, 831.4527587890625), 
    [49] = Vector3.new(1503.15625, 94.1001968383789, 515.0509643554688), 
    [50] = Vector3.new(1502.8846435546875, 94.0999526977539, 361.156005859375), 
    [51] = Vector3.new(1502.38720703125, 94.0999526977539, 79.3021469116211), 
}

Connections["OrbFarm"] = game.Workspace.ExperienceOrbs.ChildAdded:Connect(function(Child)
    wait(0.05)
    if OrbFarmEnabled == true then
        firetouchinterest(playerhead,Child,0)
        firetouchinterest(playerhead,Child,1)
    end
end)

Connections["LocalPlayerChar"] = game.Players.LocalPlayer.CharacterAdded:Connect(function(Char)
    Connections["AntiTele"] = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(Child)
        if _G.AntiTele == true then
            print(Child.Name)
            if Child.Name == "telekinesisGyro" then       
                local v3 = shared.GetCamDirection()
                events.ToggleTelekinesis:InvokeServer(v3, false, game.Players.LocalPlayer.Character)
            end
        end
    end)
end)

Connections["NPCFarm"] = game.Workspace.ChildAdded:Connect(function(v)
    if NpcFarmEnabled == true then
        wait(0.1)
        if v.Name == "Thug" or v.Name == "Civilian" or v.Name == "Police" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 1 then
                    
                    
            
            repeat 
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
            local args = {
                [1] = 0,
                [2] = 0.1,
                [3] = 1
            }
            
            game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
            wait(0.05)
        end)
            until v:FindFirstChild("Humanoid") == nil or v.Humanoid.Health < 1
        end
    end
end)


Connections["PersonJoin"] = game.Players.PlayerAdded:Connect(function(Player)
    if table.find(Founders,Player.UserId) then
        window:CreateNotification({
            ["Title"] = "Join Alert",
            ["Text"] = "Founder "..Player.Name.." has joined the game.",
            ["TitleColor"] = Color3.fromRGB(255,0,0)
        })
    elseif table.find(Developers,Player.UserId) then
        window:CreateNotification({
            ["Title"] = "Join Alert",
            ["Text"] = "Developer "..Player.Name.." has joined the game.",
            ["TitleColor"] = Color3.fromRGB(255,0,0)
        })
    elseif table.find(Moderators,Player.UserId) then
        window:CreateNotification({
            ["Title"] = "Join Alert",
            ["Text"] = "Moderator "..Player.Name.." has joined the game.",
            ["TitleColor"] = Color3.fromRGB(255,0,0)
        })
    end
end)

Connections["PersonLeave"] = game.Players.PlayerRemoving:Connect(function(Player)
    if Player == PlrSelCombat then
        window:CreateNotification({
            ["Title"] = "Selected Player Leaving",
            ["Text"] = Player.Name.." has left the game.",
        })
    end
end)


Connections["InputConnectionis"] = UIS.InputBegan:Connect(function(input, chatting)
    if chatting == false and GuiIsActive == true then
        if input.KeyCode == Enum.KeyCode.Home then
            window:ReturnToScreen()
        elseif input.KeyCode == Enum.KeyCode.PageUp then
            GuiIsActive = false
            for x,v in next, Connections do
                pcall(function()
                    v:Disconnect()
                end)
            end
            window:DestroyGui()
        elseif input.KeyCode == Enum.KeyCode.G then
            if FastLPEnabled == false then
                FastPunchLight:TurnOn()
                FastLPEnabled = true
                FastPunchHeavy:TurnOn()
                FastHPEnabled = true
                task.spawn(function()
                    while FastLPEnabled == true do
                        local args = {
                            [1] = 0,
                            [2] = 0.1,
                            [3] = 1
                        }
                        
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
                        
            
                        wait()
                    end
                end)
                task.spawn(function()
                    while FastHPEnabled == true do
                        local args = {
                            [1] = 0.3,
                            [2] = 0.1,
                            [3] = 1
                        }
            
                        game:GetService("ReplicatedStorage").Events.Punch:FireServer(unpack(args))
            
                        wait()
                    end
                end)
            else
                FastLPEnabled = false
                FastPunchLight:TurnOff()
                FastPunchHeavy:TurnOff()
                FastHPEnabled = false
            end
        elseif input.KeyCode == Enum.KeyCode.H then
            local v3 = shared.GetCamDirection()
            events.ToggleTelekinesis:InvokeServer(v3, true)
            
            
            events.ToggleTelekinesis:InvokeServer(v3, false)
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            if Hidden == false then
                window:Hide()
                Hidden = true
            else
                window:Show()
                Hidden = false
            end
        end
    end
end)

