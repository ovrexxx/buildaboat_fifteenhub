-- // CONFIGURATION // --
local SECRET_SALT = "FIFTEEN_HUB_SYNCED_2025"
local KEY_RANGE = 1005 

-- !!! IMPORTANT: Create a file named 'blacklist.txt' on your GitHub !!!
-- !!! Paste the RAW link here. Add blacklisted keys to that file (one per line) !!!
local BLACKLIST_URL = "https://raw.githubusercontent.com/ovrexxx/buildaboat_fifteenhub/refs/heads/main/blacklist.txt"

-- // 1. BLACKLIST CHECKER // --
local function IsKeyBlacklisted(key)
    -- Attempt to fetch the blacklist from GitHub
    local success, response = pcall(function()
        return game:HttpGet(BLACKLIST_URL)
    end)
    
    if success then
        -- Check if the key exists in the text file
        if string.find(response, key) then
            return true -- KEY IS BANNED
        end
    end
    return false
end

-- // 2. KEY GENERATION LOGIC (Mirroring the Bot) // --
local ValidKeysTable = {}

local function GenerateKeyForOffset(offset)
    local timeBlock = math.floor(os.time() / 43200) + offset
    local rawString = SECRET_SALT .. "-" .. timeBlock
    
    local hash = 0
    for i = 1, #rawString do
        local byte = string.byte(rawString, i, i)
        hash = (hash + byte * i) % 100000007
    end
    
    local hex = string.format("%X", hash)
    while #hex < 8 do hex = "0" .. hex end
    
    return "FH-" .. string.sub(hex, 1, 4) .. "-" .. string.sub(hex, 5, 8)
end

-- Populate valid keys
for i = 0, KEY_RANGE do
    table.insert(ValidKeysTable, GenerateKeyForOffset(i))
end

-- // 3. CUSTOM AUTH UI // --
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local LoginBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "FifteenHubAuth"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

Title.Parent = Frame
Title.Text = "FIFTEEN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,0,0.05,0)
Title.Size = UDim2.new(1,0,0,30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

KeyInput.Parent = Frame
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.PlaceholderText = "FH-XXXX-XXXX"
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyInput.Font = Enum.Font.Code
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput)

LoginBtn.Parent = Frame
LoginBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
LoginBtn.Text = "VERIFY"
LoginBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
LoginBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", LoginBtn)

Status.Parent = Frame
Status.Text = ""
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0,0,0.9,0)
Status.Size = UDim2.new(1,0,0,20)
Status.TextColor3 = Color3.fromRGB(255,50,50)

-- // AUTH LOGIC // --
LoginBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    
    Status.Text = "Checking Server..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    wait(0.1)
    
    -- 1. Check if key is Blacklisted online
    if IsKeyBlacklisted(input) then
        Status.Text = "KEY BLACKLISTED"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    -- 2. Check if key matches Math
    local isValid = false
    for _, key in pairs(ValidKeysTable) do
        if key == input then
            isValid = true
            break
        end
    end
    
    if isValid then
        Status.Text = "SUCCESS"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        ScreenGui:Destroy()
        
        -- // LOAD THE ACTUAL SCRIPT CONTENT // --
        
        -- Determine Game to load correct script
        if game.PlaceId == 537413528 then -- Build A Boat
             loadstring(game:HttpGet('https://raw.githubusercontent.com/ovrexxx/buildaboat_fifteenhub/refs/heads/main/source_code.lua'))()
        elseif game.PlaceId == 8798221013 then -- Break A Bone
             -- Insert Break A Bone logic here or loadstring
             print("Loading Break A Bone...")
        else
             -- Default Loading (The Auto Miner / Forge)
             local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
             local Window = Rayfield:CreateWindow({
                Name = "Fifteen Hub",
                LoadingTitle = "Loaded",
                ConfigurationSaving = { Enabled = true, FileName = "FifteenHub" }
             })
             Rayfield:Notify({Title = "Success", Content = "Script Loaded", Duration = 5})
        end
        
    else
        Status.Text = "INVALID KEY"
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
