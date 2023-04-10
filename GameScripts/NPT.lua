-- libraries and window vars

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/meowman567/UILib/main/UILIBRARY_Main.lua'))()
local GuiIsActive = true
local Hidden = false

-- services and stuff

local UIS = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local mouse = game.Players.LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local ClientStorage = game:GetService("ReplicatedStorage")
local Connections = {}

-- script variables

local LayoutText = ""

-- script functions

local function GetPlayerBase()
    local TeamColor = tostring(game.Players.LocalPlayer.TeamColor)
    local Base = game:GetService("Workspace").Tycoons[TeamColor]
    return Base or false
end

local function GetGridPos(Item)
    --print(Item.Name)
    if not (Item:FindFirstChild("Build") and Item.Build:FindFirstChild("Base")) then print("Couldnt find base.") return end
    local PlayerBase = GetPlayerBase()
    local Cord = nil
    local BasePos = Item.Build:FindFirstChild("Base").Position
    if PlayerBase then
        for x,v in pairs(PlayerBase.grid:GetChildren()) do
            if math.floor(v.Position.X) == math.floor(BasePos.X) and math.floor(v.Position.Z) == math.floor(BasePos.Z) then
                Cord = v.Name
                break
            end
        end
    end
    return Cord
end

-- actual window stuff

local window = Library:CreateWindow({
	Name = "Meow Hub (NPT)",
	PColor = Color3.fromRGB(141, 47, 255),
	DestroyOtherInstances = false,
	PlayerRank = "dint",
	Vers = "v2"
})

local BaseStuff = window:CreatePage({
	Name = "Base"
})

local PlayerText = BaseStuff:CreateText({
    Name = "LayoutHeader",
    Text = "Layouts"
})

local BaseLayoutInput = BaseStuff:CreateInput({
    Name = "Layout JSON:",
    PlaceholderText = "Layout code...",
    TextChangedCallback = function(text)
        LayoutText = text
    end
})

local LoadBaseLayout = BaseStuff:CreateButton({
    Name = "Load",
	Callback = function()
		local TOC
        local success,err = pcall(function()
            TOC = http:JSONDecode(LayoutText)
        end)
        if success and TOC then
            local success2 = pcall(function()
                for x,v in next, TOC do
                    task.spawn(function()
                        local args = {
                            [1] = "BuyDone",
                            [2] = x,
                            [3] = v
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("SFunction"):InvokeServer(unpack(args)) 
                    end)       
                end
            end)
            if not success then
                window:CreateNotification({
                    ["Title"] = "Alert",
                    ["Text"] = "Failed to load layout with error message: "..err,
                    ["TitleColor"] = Color3.fromRGB(255,0,0)
                })
            end
        else
            window:CreateNotification({
                ["Title"] = "Alert",
                ["Text"] = "Invalid layout text.",
                ["TitleColor"] = Color3.fromRGB(255,0,0)
            })
        end
	end,
})

local SaveCurrentBase = BaseStuff:CreateButton({
    Name = "Save Current Base",
	Callback = function()
		local success, err = pcall(function()
            local PlrBase = GetPlayerBase()
            local TOC = {}
            for x,v in pairs(PlrBase.Build:GetChildren()) do
                --print(v.Name)
                local Pos = GetGridPos(v)
                if Pos then
                    TOC[Pos] = v.Name
                end
            end

            setclipboard(http:JSONEncode(TOC))
        end)
        if success then
            window:CreateNotification({
                ["Title"] = "Success",
                ["Text"] = "Layout code has been copied to your clipbord. Idd recomend saving this somewhere until i make it save to a file for easy loading and saving",
            })
        else
            window:CreateNotification({
                ["Title"] = "Save Failure",
                ["Text"] = "Send this error message to dint: "..err,
                ["TitleColor"] = Color3.fromRGB(255,0,0)
            })
        end
	end,
})

local PlayerText = BaseStuff:CreateText({
    Name = "OtherHeader",
    Text = "Other"
})

local LoadBaseLayout = BaseStuff:CreateButton({
    Name = "Sell all",
	Callback = function()
		local args = {
            [1] = "SellAll"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("SFunction"):InvokeServer(unpack(args))
	end,
})




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
