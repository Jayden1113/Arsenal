if not game:IsLoaded() then
    game.Loaded:Wait()
end
if not syn then
    game:GetService("Players").LocalPlayer:Kick("synapse only")
end
wait(1)
spawn(
    function()
        _G.gamer = true
        while _G.gamer == true do
            wait()
            if game:GetService("ReplicatedStorage").wkspc.Status.RoundOver.Value == true then
                local PlaceID = game.PlaceId
                local AllIDs = {}
                local foundAnything = ""
                local actualHour = os.date("!*t").hour
                local Deleted = false
                local File =
                    pcall(
                    function()
                        AllIDs = game:GetService("HttpService"):JSONDecode(readfile("NotSameServers.json"))
                    end
                )
                if not File then
                    table.insert(AllIDs, actualHour)
                    writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
                end
                function TPReturner()
                    local Site
                    if foundAnything == "" then
                        Site =
                            game.HttpService:JSONDecode(
                            game:HttpGet(
                                "https://games.roblox.com/v1/games/" ..
                                    PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
                            )
                        )
                    else
                        Site =
                            game.HttpService:JSONDecode(
                            game:HttpGet(
                                "https://games.roblox.com/v1/games/" ..
                                    PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything
                            )
                        )
                    end
                    local ID = ""
                    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                        foundAnything = Site.nextPageCursor
                    end
                    local num = 0
                    for i, v in pairs(Site.data) do
                        local Possible = true
                        ID = tostring(v.id)
                        if tonumber(v.maxPlayers) > tonumber(v.playing) then
                            for _, Existing in pairs(AllIDs) do
                                if num ~= 0 then
                                    if ID == tostring(Existing) then
                                        Possible = false
                                    end
                                else
                                    if tonumber(actualHour) ~= tonumber(Existing) then
                                        local delFile =
                                            pcall(
                                            function()
                                                delfile("NotSameServers.json")
                                                AllIDs = {}
                                                table.insert(AllIDs, actualHour)
                                            end
                                        )
                                    end
                                end
                                num = num + 1
                            end
                            if Possible == true then
                                table.insert(AllIDs, ID)
                                wait()
                                pcall(
                                    function()
                                        writefile(
                                            "NotSameServers.json",
                                            game:GetService("HttpService"):JSONEncode(AllIDs)
                                        )
                                        wait()
                                        game:GetService("TeleportService"):TeleportToPlaceInstance(
                                            PlaceID,
                                            ID,
                                            game.Players.LocalPlayer
                                        )
                                    end
                                )
                                wait(4)
                            end
                        end
                    end
                end

                function Teleport()
                    while wait() do
                        pcall(
                            function()
                                TPReturner()
                                if foundAnything ~= "" then
                                    TPReturner()
                                end
                            end
                        )
                    end
                end
                Teleport()
            end
        end
    end
)
spawn(
    function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        if game:GetService("ReplicatedStorage").wkspc.Status.RoundOver.Value == false then
            game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer("TRC")
            wait(0.9)
            game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer("TBC")
            wait(0.9)
            game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer("Spectator")

            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Events = ReplicatedStorage:WaitForChild("Events")
            local JoinTeam = Events:WaitForChild("JoinTeam")
            local FallDamage = Events:WaitForChild("FallDamage")
            local wkspc = game:GetService("ReplicatedStorage"):WaitForChild("wkspc")
            local FFA = wkspc:WaitForChild("FFA")
            local Status = wkspc:WaitForChild("Status")
            local Preparation = Status:WaitForChild("Preparation")
            local RunService = game:GetService("RunService")

            repeat
                for Index, Player in next, Players:GetPlayers() do
                    if Character:FindFirstChild("Spawned") then
                        Character.Spawned:Destroy()
                    end

                    pcall(
                        function()
                            if (Player.Character:FindFirstChild("Spawned")) then
                                repeat
                                    Character.HumanoidRootPart.Position = Player.Character.Hitbox.Position
                                    FallDamage:FireServer(25000, Player.Character.Hitbox)
                                    RunService.RenderStepped:Wait()
                                until not Player.Character:FindFirstChild("Spawned")
                            elseif not Player.Character:FindFirstChild("Spawned") then
                                Character.HumanoidRootPart.Position = Vector3.new(math.huge, math.huge, math.huge)
                            end
                        end
                    )
                end

                RunService.RenderStepped:Wait()
            until Preparation.Value
        end
    end
)
syn.queue_on_teleport("https://raw.githubusercontent.com/Jayden1113/Arsenal/master/Autofarm.lua")
