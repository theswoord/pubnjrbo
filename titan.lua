local TweenService  = game:GetService("TweenService")
local noclipE       = false
local antifall      = nil

local function getTitan()
    local dist, titan = math.huge 
    for i,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "FemaleTitan" and v:FindFirstChild("Humanoid").Health > 0 then 
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("Head").Position).magnitude
            if mag < dist then 
                dist = mag 
                titan = v 
            end
        end
    end
    return titan
end

local function noclip()
	for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide == true then
			v.CanCollide = false
		end
	end
end

local function moveto(obj, speed)
    local info = TweenInfo.new(((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude)/ speed,Enum.EasingStyle.Linear)
    local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = obj})

    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0,0,0)
        noclipE = game:GetService("RunService").Stepped:Connect(noclip)
        tween:Play()
    end
        
    tween.Completed:Connect(function()
        antifall:Destroy()
        noclipE:Disconnect()
    end)
end

while wait() do 
    if getgenv().autofarm then 
        pcall(function()
            if game.Players.LocalPlayer.Character:FindFirstChild("NameGui") then 
                game.Players.LocalPlayer.Character:FindFirstChild("NameGui"):Destroy()
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            moveto(getTitan():FindFirstChild("Head").CFrame * CFrame.new(0,0,-5), getgenv().tpseed)
            game:GetService("ReplicatedStorage").DamageEvent:FireServer(nil, getTitan():FindFirstChild("Humanoid"), "&@&*&@&", getTitan())
        end)
    end
end