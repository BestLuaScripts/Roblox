if "nazi" then
    local v3_net, v3_808 = Vector3.new(0, 25.1, 0), Vector3.new(8, 0, 8)
    local function getNetlessVelocity(realPartVelocity)
        local mag = realPartVelocity.Magnitude
        if mag > 1 then
            local unit = realPartVelocity.Unit
            if (unit.Y > 0.25) or (unit.Y < -0.75) then
                return unit * (100.1 / unit.Y)
            end
        end
        return v3_net + realPartVelocity * v3_808
    end
    local simradius = "shp"
    local simrad = 1500
    local healthHide = false
    local reclaim = true
    local novoid = true
    local physp = nil
    local noclipAllParts = false
    local antiragdoll = true
    local newanimate = true
    local discharscripts = true
    local R15toR6 = true
    local hatcollide = false
    local humState16 = true
    local addtools = false
    local hedafterneck = true
    local loadtime = game:GetService("Players").RespawnTime + 0.5
    local method = 0
    local alignmode = 4
    local flingpart = ""
    
    local lp = game:GetService("Players").LocalPlayer
    local rs, ws, sg = game:GetService("RunService"), game:GetService("Workspace"), game:GetService("StarterGui")
    local stepped, heartbeat, renderstepped = rs.Stepped, rs.Heartbeat, rs.RenderStepped
    local twait, tdelay, rad, inf, abs, clamp = task.wait, task.delay, math.rad, math.huge, math.abs, math.clamp
    local cf, v3 = CFrame.new, Vector3.new
    local angles = CFrame.Angles
    local v3_0, cf_0 = v3(0, 0, 0), cf(0, 0, 0)
    
    local c = lp.Character
    if not (c and c.Parent) then
        return
    end
    
    c:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (c and c.Parent) then
            c = nil
        end
    end)
    
    local clone, destroy, getchildren, getdescendants, isa = c.Clone, c.Destroy, c.GetChildren, c.GetDescendants, c.IsA
    
    local function gp(parent, name, className)
        if typeof(parent) == "Instance" then
            for i, v in pairs(getchildren(parent)) do
                if (v.Name == name) and isa(v, className) then
                    return v
                end
            end
        end
        return nil
    end
    
    local fenv = getfenv()
    
    local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
    local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.setsimrad or fenv.set_sim_rad
    
    healthHide = healthHide and ((method == 0) or (method == 3)) and gp(c, "Head", "BasePart")
    
    local reclaim, lostpart = reclaim and c.PrimaryPart, nil
    
    local function align(Part0, Part1)
        
        local att0 = Instance.new("Attachment")
        att0.Position, att0.Orientation, att0.Name = v3_0, v3_0, "att0_" .. Part0.Name
        local att1 = Instance.new("Attachment")
        att1.Position, att1.Orientation, att1.Name = v3_0, v3_0, "att1_" .. Part1.Name
    
        if alignmode == 4 then
        
            local hide = false
            if Part0 == healthHide then
                healthHide = false
                tdelay(0, function()
                    while twait(2.9) and Part0 and c do
                        hide = #Part0:GetConnectedParts() == 1
                        twait(0.1)
                        hide = false
                    end
                end)
            end
            
            local rot = rad(0.05)
            local con0, con1 = nil, nil
            con0 = stepped:Connect(function()
                if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
                Part0.RotVelocity = Part1.RotVelocity
            end)
            local lastpos = Part0.Position
            con1 = heartbeat:Connect(function(delta)
                if not (Part0 and Part1 and att1) then return con0:Disconnect() and con1:Disconnect() end
                if (not Part0.Anchored) and (Part0.ReceiveAge == 0) then
                    if lostpart == Part0 then
                        lostpart = nil
                    end
                    rot = -rot
                    local newcf = Part1.CFrame * att1.CFrame * angles(0, 0, rot)
                    if Part1.Velocity.Magnitude > 0.01 then
                        Part0.Velocity = getNetlessVelocity(Part1.Velocity)
                    else
                        Part0.Velocity = getNetlessVelocity((newcf.Position - lastpos) / delta)
                    end
                    lastpos = newcf.Position
                    if lostpart and (Part0 == reclaim) then
                        newcf = lostpart.CFrame
                    elseif hide then
                        newcf += v3(0, 3000, 0)
                    end
                    if novoid and (newcf.Y < ws.FallenPartsDestroyHeight + 0.1) then
                        newcf += v3(0, ws.FallenPartsDestroyHeight + 0.1 - newcf.Y, 0)
                    end
                    Part0.CFrame = newcf
                elseif (not Part0.Anchored) and (abs(Part0.Velocity.X) < 45) and (abs(Part0.Velocity.Y) < 25) and (abs(Part0.Velocity.Z) < 45) then
                    lostpart = Part0
                end
            end)
        
        else
            
            Part0.CustomPhysicalProperties = physp
            if (alignmode == 1) or (alignmode == 2) then
                local ape = Instance.new("AlignPosition")
                ape.MaxForce, ape.MaxVelocity, ape.Responsiveness = inf, inf, inf
                ape.ReactionForceEnabled, ape.RigidityEnabled, ape.ApplyAtCenterOfMass = false, true, false
                ape.Attachment0, ape.Attachment1, ape.Name = att0, att1, "AlignPositionRtrue"
                ape.Parent = att0
            end
            
            if (alignmode == 2) or (alignmode == 3) then
                local apd = Instance.new("AlignPosition")
                apd.MaxForce, apd.MaxVelocity, apd.Responsiveness = inf, inf, inf
                apd.ReactionForceEnabled, apd.RigidityEnabled, apd.ApplyAtCenterOfMass = false, false, false
                apd.Attachment0, apd.Attachment1, apd.Name = att0, att1, "AlignPositionRfalse"
                apd.Parent = att0
            end
            
            local ao = Instance.new("AlignOrientation")
            ao.MaxAngularVelocity, ao.MaxTorque, ao.Responsiveness = inf, inf, inf
            ao.PrimaryAxisOnly, ao.ReactionTorqueEnabled, ao.RigidityEnabled = false, false, false
            ao.Attachment0, ao.Attachment1 = att0, att1
            ao.Parent = att0
            
            local con0, con1 = nil, nil
            local vel = Part0.Velocity
            con0 = renderstepped:Connect(function()
                if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
                Part0.Velocity = vel
            end)
            local lastpos = Part0.Position
            con1 = heartbeat:Connect(function(delta)
                if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
                vel = Part0.Velocity
                if Part1.Velocity.Magnitude > 0.01 then
                    Part0.Velocity = getNetlessVelocity(Part1.Velocity)
                else
                    Part0.Velocity = getNetlessVelocity((Part0.Position - lastpos) / delta)
                end
                lastpos = Part0.Position
            end)
        
        end
    
        att0:GetPropertyChangedSignal("Parent"):Connect(function()
            Part0 = att0.Parent
            if not isa(Part0, "BasePart") then
                att0 = nil
                if lostpart == Part0 then
                    lostpart = nil
                end
                Part0 = nil
            end
        end)
        att0.Parent = Part0
        
        att1:GetPropertyChangedSignal("Parent"):Connect(function()
            Part1 = att1.Parent
            if not isa(Part1, "BasePart") then
                att1 = nil
                Part1 = nil
            end
        end)
        att1.Parent = Part1
    end
    
    local function respawnrequest()
        local ccfr, c = ws.CurrentCamera.CFrame, lp.Character
        lp.Character = nil
        lp.Character = c
        local con = nil
        con = ws.CurrentCamera.Changed:Connect(function(prop)
            if (prop ~= "Parent") and (prop ~= "CFrame") then
                return
            end
            ws.CurrentCamera.CFrame = ccfr
            con:Disconnect()
        end)
    end
    
    local destroyhum = (method == 4) or (method == 5)
    local breakjoints = (method == 0) or (method == 4)
    local antirespawn = (method == 0) or (method == 2) or (method == 3)
    
    hatcollide = hatcollide and (method == 0)
    
    addtools = addtools and lp:FindFirstChildOfClass("Backpack")
    
    if type(simrad) ~= "number" then simrad = 1000 end
    if shp and (simradius == "shp") then
        tdelay(0, function()
            while c do
                shp(lp, "SimulationRadius", simrad)
                heartbeat:Wait()
            end
        end)
    elseif ssr and (simradius == "ssr") then
        tdelay(0, function()
            while c do
                ssr(simrad)
                heartbeat:Wait()
            end
        end)
    end
    
    if antiragdoll then
        antiragdoll = function(v)
            if isa(v, "HingeConstraint") or isa(v, "BallSocketConstraint") then
                v.Parent = nil
            end
        end
        for i, v in pairs(getdescendants(c)) do
            antiragdoll(v)
        end
        c.DescendantAdded:Connect(antiragdoll)
    end
    
    if antirespawn then
        respawnrequest()
    end
    
    if method == 0 then
        twait(loadtime)
        if not c then
            return
        end
    end
    
    if discharscripts then
        for i, v in pairs(getdescendants(c)) do
            if isa(v, "LocalScript") then
                v.Disabled = true
            end
        end
    elseif newanimate then
        local animate = gp(c, "Animate", "LocalScript")
        if animate and (not animate.Disabled) then
            animate.Disabled = true
        else
            newanimate = false
        end
    end
    
    if addtools then
        for i, v in pairs(getchildren(addtools)) do
            if isa(v, "Tool") then
                v.Parent = c
            end
        end
    end
    
    pcall(function()
        settings().Physics.AllowSleep = false
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    end)
    
    local OLDscripts = {}
    
    for i, v in pairs(getdescendants(c)) do
        if v.ClassName == "Script" then
            OLDscripts[v.Name] = true
        end
    end
    
    local scriptNames = {}
    
    for i, v in pairs(getdescendants(c)) do
        if isa(v, "BasePart") then
            local newName, exists = tostring(i), true
            while exists do
                exists = OLDscripts[newName]
                if exists then
                    newName = newName .. "_"    
                end
            end
            table.insert(scriptNames, newName)
            Instance.new("Script", v).Name = newName
        end
    end
    
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for i, v in pairs(hum:GetPlayingAnimationTracks()) do
            v:Stop()
        end
    end
    c.Archivable = true
    local cl = clone(c)
    if hum and humState16 then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        if destroyhum then
            twait(1.6)
        end
    end
    if destroyhum then
        pcall(destroy, hum)
    end
    
    if not c then
        return
    end
    
    local head, torso, root = gp(c, "Head", "BasePart"), gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart"), gp(c, "HumanoidRootPart", "BasePart")
    if hatcollide then
        pcall(destroy, torso)
        pcall(destroy, root)
        pcall(destroy, c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script"))
    end
    
    local model = Instance.new("Model", c)
    model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (model and model.Parent) then
            model = nil
        end
    end)
    
    for i, v in pairs(getchildren(c)) do
        if v ~= model then
            if addtools and isa(v, "Tool") then
                for i1, v1 in pairs(getdescendants(v)) do
                    if v1 and v1.Parent and isa(v1, "BasePart") then
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity, bv.MaxForce, bv.P, bv.Name = v3_0, v3(1000, 1000, 1000), 1250, "bv_" .. v.Name
                        bv.Parent = v1
                    end
                end
            end
            v.Parent = model
        end
    end
    
    if breakjoints then
        model:BreakJoints()
    else
        if head and torso then
            for i, v in pairs(getdescendants(model)) do
                if isa(v, "JointInstance") then
                    local save = false
                    if (v.Part0 == torso) and (v.Part1 == head) then
                        save = true
                    end
                    if (v.Part0 == head) and (v.Part1 == torso) then
                        save = true
                    end
                    if save then
                        if hedafterneck then
                            hedafterneck = v
                        end
                    else
                        pcall(destroy, v)
                    end
                end
            end
        end
        if method == 3 then
            task.delay(loadtime, pcall, model.BreakJoints, model)
        end
    end
    
    cl.Parent = ws
    for i, v in pairs(getchildren(cl)) do
        v.Parent = c
    end
    pcall(destroy, cl)
    
    local uncollide, noclipcon = nil, nil
    if noclipAllParts then
        uncollide = function()
            if c then
                for i, v in pairs(getdescendants(c)) do
                    if isa(v, "BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                noclipcon:Disconnect()
            end
        end
    else
        uncollide = function()
            if model then
                for i, v in pairs(getdescendants(model)) do
                    if isa(v, "BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                noclipcon:Disconnect()
            end
        end
    end
    noclipcon = stepped:Connect(uncollide)
    uncollide()
    
    for i, scr in pairs(getdescendants(model)) do
        if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
            local Part0 = scr.Parent
            if isa(Part0, "BasePart") then
                for i1, scr1 in pairs(getdescendants(c)) do
                    if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
                        local Part1 = scr1.Parent
                        if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
                            align(Part0, Part1)
                            pcall(destroy, scr)
                            pcall(destroy, scr1)
                            break
                        end
                    end
                end
            end
        end
    end
    
    for i, v in pairs(getdescendants(c)) do
        if v and v.Parent and (not v:IsDescendantOf(model)) then
            if isa(v, "Decal") then
                v.Transparency = 1
            elseif isa(v, "BasePart") then
                v.Transparency = 1
                v.Anchored = false
            elseif isa(v, "ForceField") then
                v.Visible = false
            elseif isa(v, "Sound") then
                v.Playing = false
            elseif isa(v, "BillboardGui") or isa(v, "SurfaceGui") or isa(v, "ParticleEmitter") or isa(v, "Fire") or isa(v, "Smoke") or isa(v, "Sparkles") then
                v.Enabled = false
            end
        end
    end
    
    if newanimate then
        local animate = gp(c, "Animate", "LocalScript")
        if animate then
            animate.Disabled = false
        end
    end
    
    if addtools then
        for i, v in pairs(getchildren(c)) do
            if isa(v, "Tool") then
                v.Parent = addtools
            end
        end
    end
    
    local hum0, hum1 = model:FindFirstChildOfClass("Humanoid"), c:FindFirstChildOfClass("Humanoid")
    if hum0 then
        hum0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (hum0 and hum0.Parent) then
                hum0 = nil
            end
        end)
    end
    if hum1 then
        hum1:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (hum1 and hum1.Parent) then
                hum1 = nil
            end
        end)
    
        ws.CurrentCamera.CameraSubject = hum1
        local camSubCon = nil
        local function camSubFunc()
            camSubCon:Disconnect()
            if c and hum1 then
                ws.CurrentCamera.CameraSubject = hum1
            end
        end
        camSubCon = renderstepped:Connect(camSubFunc)
        if hum0 then
            hum0:GetPropertyChangedSignal("Jump"):Connect(function()
                if hum1 then
                    hum1.Jump = hum0.Jump
                end
            end)
        else
            respawnrequest()
        end
    end
    
    local rb = Instance.new("BindableEvent", c)
    rb.Event:Connect(function()
        pcall(destroy, rb)
        sg:SetCore("ResetButtonCallback", true)
        if destroyhum then
            if c then c:BreakJoints() end
            return
        end
        if model and hum0 and (hum0.Health > 0) then
            model:BreakJoints()
            hum0.Health = 0
        end
        if antirespawn then
            respawnrequest()
        end
    end)
    sg:SetCore("ResetButtonCallback", rb)
    
    tdelay(0, function()
        while c do
            if hum0 and hum1 then
                hum1.Jump = hum0.Jump
            end
            wait()
        end
        sg:SetCore("ResetButtonCallback", true)
    end)
    
    R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
    if R15toR6 then
        local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
        if part then
            local cfr = part.CFrame
            local R6parts = { 
                head = {
                    Name = "Head",
                    Size = v3(2, 1, 1),
                    R15 = {
                        Head = 0
                    }
                },
                torso = {
                    Name = "Torso",
                    Size = v3(2, 2, 1),
                    R15 = {
                        UpperTorso = 0.2,
                        LowerTorso = -0.8
                    }
                },
                root = {
                    Name = "HumanoidRootPart",
                    Size = v3(2, 2, 1),
                    R15 = {
                        HumanoidRootPart = 0
                    }
                },
                leftArm = {
                    Name = "Left Arm",
                    Size = v3(1, 2, 1),
                    R15 = {
                        LeftHand = -0.849,
                        LeftLowerArm = -0.174,
                        LeftUpperArm = 0.415
                    }
                },
                rightArm = {
                    Name = "Right Arm",
                    Size = v3(1, 2, 1),
                    R15 = {
                        RightHand = -0.849,
                        RightLowerArm = -0.174,
                        RightUpperArm = 0.415
                    }
                },
                leftLeg = {
                    Name = "Left Leg",
                    Size = v3(1, 2, 1),
                    R15 = {
                        LeftFoot = -0.85,
                        LeftLowerLeg = -0.29,
                        LeftUpperLeg = 0.49
                    }
                },
                rightLeg = {
                    Name = "Right Leg",
                    Size = v3(1, 2, 1),
                    R15 = {
                        RightFoot = -0.85,
                        RightLowerLeg = -0.29,
                        RightUpperLeg = 0.49
                    }
                }
            }
            for i, v in pairs(getchildren(c)) do
                if isa(v, "BasePart") then
                    for i1, v1 in pairs(getchildren(v)) do
                        if isa(v1, "Motor6D") then
                            v1.Part0 = nil
                        end
                    end
                end
            end
            part.Archivable = true
            for i, v in pairs(R6parts) do
                local part = clone(part)
                part:ClearAllChildren()
                part.Name, part.Size, part.CFrame, part.Anchored, part.Transparency, part.CanCollide = v.Name, v.Size, cfr, false, 1, false
                for i1, v1 in pairs(v.R15) do
                    local R15part = gp(c, i1, "BasePart")
                    local att = gp(R15part, "att1_" .. i1, "Attachment")
                    if R15part then
                        local weld = Instance.new("Weld")
                        weld.Part0, weld.Part1, weld.C0, weld.C1, weld.Name = part, R15part, cf(0, v1, 0), cf_0, "Weld_" .. i1
                        weld.Parent = R15part
                        R15part.Massless, R15part.Name = true, "R15_" .. i1
                        R15part.Parent = part
                        if att then
                            att.Position = v3(0, v1, 0)
                            att.Parent = part
                        end
                    end
                end
                part.Parent = c
                R6parts[i] = part
            end
            local R6joints = {
                neck = {
                    Parent = R6parts.torso,
                    Name = "Neck",
                    Part0 = R6parts.torso,
                    Part1 = R6parts.head,
                    C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
                    C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
                },
                rootJoint = {
                    Parent = R6parts.root,
                    Name = "RootJoint" ,
                    Part0 = R6parts.root,
                    Part1 = R6parts.torso,
                    C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
                    C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
                },
                rightShoulder = {
                    Parent = R6parts.torso,
                    Name = "Right Shoulder",
                    Part0 = R6parts.torso,
                    Part1 = R6parts.rightArm,
                    C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
                    C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                },
                leftShoulder = {
                    Parent = R6parts.torso,
                    Name = "Left Shoulder",
                    Part0 = R6parts.torso,
                    Part1 = R6parts.leftArm,
                    C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
                    C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                },
                rightHip = {
                    Parent = R6parts.torso,
                    Name = "Right Hip",
                    Part0 = R6parts.torso,
                    Part1 = R6parts.rightLeg,
                    C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
                    C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                },
                leftHip = {
                    Parent = R6parts.torso,
                    Name = "Left Hip" ,
                    Part0 = R6parts.torso,
                    Part1 = R6parts.leftLeg,
                    C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
                    C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
                }
            }
            for i, v in pairs(R6joints) do
                local joint = Instance.new("Motor6D")
                for prop, val in pairs(v) do
                    joint[prop] = val
                end
                R6joints[i] = joint
            end
            if hum1 then
                hum1.RigType, hum1.HipHeight = Enum.HumanoidRigType.R6, 0
            end
        end
    end
    
    local torso1 = torso
    torso = gp(c, "Torso", "BasePart") or ((not R15toR6) and gp(c, torso.Name, "BasePart"))
    if (typeof(hedafterneck) == "Instance") and head and torso and torso1 then
        local conNeck, conTorso, conTorso1 = nil, nil, nil
        local aligns = {}
        local function enableAligns()
            conNeck:Disconnect()
            conTorso:Disconnect()
            conTorso1:Disconnect()
            for i, v in pairs(aligns) do
                v.Enabled = true
            end
        end
        conNeck = hedafterneck.Changed:Connect(function(prop)
            if table.find({"Part0", "Part1", "Parent"}, prop) then
                enableAligns()
            end
        end)
        conTorso = torso:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
        conTorso1 = torso1:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
        for i, v in pairs(getdescendants(head)) do
            if isa(v, "AlignPosition") or isa(v, "AlignOrientation") then
                i = tostring(i)
                aligns[i] = v
                v:GetPropertyChangedSignal("Parent"):Connect(function()
                    aligns[i] = nil
                end)
                v.Enabled = false
            end
        end
    end
    
    local flingpart0 = gp(model, flingpart, "BasePart") or gp(gp(model, flingpart, "Accessory"), "Handle", "BasePart")
    local flingpart1 = gp(c, flingpart, "BasePart") or gp(gp(c, flingpart, "Accessory"), "Handle", "BasePart")
    
    local fling = function() end
    if flingpart0 and flingpart1 then
        flingpart0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (flingpart0 and flingpart0.Parent) then
                flingpart0 = nil
                fling = function() end
            end
        end)
        flingpart0.Archivable = true
        flingpart1:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (flingpart1 and flingpart1.Parent) then
                flingpart1 = nil
                fling = function() end
            end
        end)
        local att0 = gp(flingpart0, "att0_" .. flingpart0.Name, "Attachment")
        local att1 = gp(flingpart1, "att1_" .. flingpart1.Name, "Attachment")
        if att0 and att1 then
            att0:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (att0 and att0.Parent) then
                    att0 = nil
                    fling = function() end
                end
            end)
            att1:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (att1 and att1.Parent) then
                    att1 = nil
                    fling = function() end
                end
            end)
            local lastfling = nil
            local mouse = lp:GetMouse()
            fling = function(target, duration, rotVelocity)
                if typeof(target) == "Instance" then
                    if isa(target, "BasePart") then
                        target = target.Position
                    elseif isa(target, "Model") then
                        target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                        if target then
                            target = target.Position
                        else
                            return
                        end
                    elseif isa(target, "Humanoid") then
                        target = target.Parent
                        if not (target and isa(target, "Model")) then
                            return
                        end
                        target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                        if target then
                            target = target.Position
                        else
                            return
                        end
                    else
                        return
                    end
                elseif typeof(target) == "CFrame" then
                    target = target.Position
                elseif typeof(target) ~= "Vector3" then
                    target = mouse.Hit
                    if target then
                        target = target.Position
                    else
                        return
                    end
                end
                if target.Y < ws.FallenPartsDestroyHeight + 5 then
                    target = v3(target.X, ws.FallenPartsDestroyHeight + 5, target.Z)
                end
                lastfling = target
                if type(duration) ~= "number" then
                    duration = tonumber(duration) or 0.5
                end
                if typeof(rotVelocity) ~= "Vector3" then
                    rotVelocity = v3(20000, 20000, 20000)
                end
                if not (target and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                flingpart0.Archivable = true
                local flingpart = clone(flingpart0)
                flingpart.Transparency = 1
                flingpart.CanCollide = false
                flingpart.Name = "flingpart_" .. flingpart0.Name
                flingpart.Anchored = true
                flingpart.Velocity = v3_0
                flingpart.RotVelocity = v3_0
                flingpart.Position = target
                flingpart:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not (flingpart and flingpart.Parent) then
                        flingpart = nil
                    end
                end)
                flingpart.Parent = flingpart1
                if flingpart0.Transparency > 0.5 then
                    flingpart0.Transparency = 0.5
                end
                att1.Parent = flingpart
                local con = nil
                local rotchg = v3(0, rotVelocity.Unit.Y * -1000, 0)
                con = heartbeat:Connect(function(delta)
                    if target and (lastfling == target) and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                        flingpart.Orientation += rotchg * delta
                        flingpart0.RotVelocity = rotVelocity
                    else
                        con:Disconnect()
                    end
                end)
                if alignmode ~= 4 then
                    local con = nil
                    con = renderstepped:Connect(function()
                        if flingpart0 and target then
                            flingpart0.RotVelocity = v3_0
                        else
                            con:Disconnect()
                        end
                    end)
                end
                twait(duration)
                if lastfling ~= target then
                    if flingpart then
                        if att1 and (att1.Parent == flingpart) then
                            att1.Parent = flingpart1
                        end
                        pcall(destroy, flingpart)
                    end
                    return
                end
                target = nil
                if not (flingpart and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                flingpart0.RotVelocity = v3_0
                att1.Parent = flingpart1
                pcall(destroy, flingpart)
            end
        end
    end
    
    lp:GetMouse().Button1Down:Connect(fling)
end

local walkSpeed, jumpPower = 20, 50

local plrs = game:GetService("Players")
local c = plrs.LocalPlayer.Character
if not c then return end
local ws = game:GetService("Workspace")
local raycast = ws.Raycast
c.AncestryChanged:Connect(function()
    if not c:IsDescendantOf(ws) then
        c = nil
    end
end)
local rs = game:GetService("RunService")
local stepped, renderstepped, heartbeat = rs.Stepped, rs.RenderStepped, rs.Heartbeat
local function gp(parent, name, classname)
    if typeof(parent) == "Instance" then
        for i, v in pairs(parent:GetChildren()) do
            if (v.Name == name) and v:IsA(classname) then
                return v
            end
        end
    end
    return nil
end

local mrandom, schar, supper = math.random, string.char, string.upper
local function randomstring(length)
    if type(length) ~= "number" then
        length = mrandom(8, 15)
    end
    local ret = ""
    for i=1, length do
        if mrandom(1, 2) == 1 then
            ret = ret .. schar(mrandom(97, 122))
        else
            ret = ret .. supper(schar(mrandom(97, 122)))
        end
    end
    return ret
end

local staticjoints = {}
local function animjoint(name, parent, Part0, Part1, fakejoint)
    fakejoint.C0 = CFrame.new()
    fakejoint.C1 = CFrame.new()
    local joint = gp(parent, name, "Motor6D")
    if joint then
        for i, v in pairs(staticjoints) do
            if (v.Part0 == Part0) and (v.Part1 == Part1) then
                staticjoints[i] = nil
                break
            end
        end
        fakejoint.C0 = joint.C0
        fakejoint.C1 = joint.C1
        joint:Destroy()
        joint = nil
    end
    name = randomstring()
    local fix = nil
    local con = nil
    fix = function()
        if not c then
            return con:Disconnect()
        end
        if not joint then 
            joint = Instance.new("Weld")
            name = randomstring()
            joint.Changed:Connect(fix)
            joint.Destroying:Connect(function() joint = nil fix() end)
        end
        if joint.Part0 ~= Part0 then
            joint.Part0 = Part0
        end
        if joint.Part1 ~= Part1 then
            joint.Part1 = Part1
        end
        if joint.C0 ~= fakejoint.C0 then
            joint.C0 = fakejoint.C0
        end
        if joint.C1 ~= fakejoint.C1 then
            joint.C1 = fakejoint.C1
        end
        if joint.Name ~= name then
            name = randomstring()
            joint.Name = name
        end
        if joint.Parent ~= parent then
            joint.Parent = parent
        end
    end
    con = stepped:Connect(fix)
end

local function part(name, main)
    local part = gp(c, name, "BasePart")
    if not part then
        part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
    end
    local size = part.Size
    part.Destroying:Connect(function()
        part = nil
        c = nil
    end)
    if not main then
        name = randomstring()
    end
    local con = nil
    con = stepped:Connect(function()
        if not part then
            return con:Disconnect()
        end
        part.Transparency = 1
        part.Name = name
        part.Size = size
        part.CanCollide = true
        part.Anchored = main
        part.Parent = c
    end)
    return part
end

local function addjoint(v)
    table.insert(staticjoints, {C0 = v.C0, C1 = v.C1, Part0 = v.Part0, Part1 = v.Part1})
end
for i, v in pairs(c:GetDescendants()) do
    if v:IsA("JointInstance") then 
        pcall(addjoint, v)
    end
end

for i, v in pairs(c:GetChildren()) do
    if v:IsA("Accessory") then
        local handle = gp(v, "Handle", "BasePart")
        handle.Name = randomstring()
        handle.Parent = c
        v:Destroy()
    end
end

local Torso = part("Torso", false)
local RightArm = part("Right Arm", false)
local LeftArm = part("Left Arm", false)
local LeftLeg = part("Left Leg", false)
local RightLeg = part("Right Leg", false)
local Head = part("Head", false)
local HumanoidRootPart = part("HumanoidRootPart", true)

local RootJoint = {}
local RightShoulder = {}
local LeftShoulder = {}
local RightHip = {}
local LeftHip = {}
local Neck = {}

animjoint("Neck", Torso, Torso, Head, Neck)
animjoint("RootJoint", HumanoidRootPart, HumanoidRootPart, Torso, RootJoint)
animjoint("Right Shoulder", Torso, Torso, RightArm, RightShoulder)
animjoint("Left Shoulder", Torso, Torso, LeftArm, LeftShoulder)
animjoint("Right Hip", Torso, Torso, RightLeg, RightHip)
animjoint("Left Hip", Torso, Torso, LeftLeg, LeftHip)

for i, v in pairs(c:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
        for i, v in pairs(v:GetDescendants()) do
            if v:IsA("JointInstance") then
                for i, v1 in pairs(staticjoints) do
                    if (v.Part0 == v1.Part0) and (v.Part1 == v1.Part1) then
                        staticjoints[i] = nil
                    end
                end
            end
        end
    end
end

local hum = c:FindFirstChildOfClass("Humanoid")
if hum then 
    hum:Destroy()
end

for i, v in pairs(staticjoints) do
    local Part0, Part1, C0, C1 = v.Part0, v.Part1, v.C0, v.C1
    local fix, con, joint, name = nil, nil, nil, randomstring()
    fix = function()
        if not c then
            return con:Disconnect()
        end
        if not joint then 
            joint = Instance.new("Weld")
            name = randomstring()
            joint.Changed:Connect(fix)
            joint.Destroying:Connect(function() joint = nil fix() end)
        end
        if joint.Part0 ~= Part0 then
            joint.Part0 = Part0
        end
        if joint.Part1 ~= Part1 then
            joint.Part1 = Part1
        end
        if joint.C0 ~= C0 then
            joint.C0 = C0
        end
        if joint.C1 ~= C1 then
            joint.C1 = C1
        end
        if joint.Name ~= name then
            name = randomstring()
            joint.Name = name
        end
        if joint.Parent ~= c then
            joint.Parent = c
        end
    end
    con = stepped:Connect(fix)
end

local animate = gp(a, "Animate", "LocalScript")
if animate then animate:Destroy() end 

local modes = {
    [Enum.KeyCode.Q] = "nazi"
}
local uis, mode = game:GetService("UserInputService"), ""
local movementkeys = {
    [Enum.KeyCode.W] = false,
    [Enum.KeyCode.A] = false,
    [Enum.KeyCode.S] = false,
    [Enum.KeyCode.D] = false,
    [Enum.KeyCode.Space] = false
}
uis.InputBegan:Connect(function(a, b)
    if b then return end
    a = a.KeyCode
    if movementkeys[a] == false then
        movementkeys[a] = true
        return
    end
    if mode == modes[a] then
        mode = ""
    else
        mode = modes[a] or mode
    end
end)
uis.InputEnded:Connect(function(a)
    if movementkeys[a.KeyCode] == true then
        movementkeys[a.KeyCode] = false
    end
end)

local cf, v3 = CFrame.new, Vector3.new
local v3_0, v3_101, v3_010, v3_d, v3_u = v3(0, 0, 0), v3(1, 0, 1), v3(0, 1, 0), v3(0, -10000, 0), v3(0, 10000, 0)
local vel, cfr, raycastresult, onground = v3_0, HumanoidRootPart.CFrame, nil, true

local raycastparams = RaycastParams.new()
raycastparams.FilterType = Enum.RaycastFilterType.Blacklist
local rayfilter = {}
local characters = {}
local function refreshrayfilter()
    for i, v in pairs(rayfilter) do
        if not table.find(characters, v) then
            rayfilter[i] = nil
        end
    end
    for i, v in pairs(characters) do
        if not table.find(rayfilter, v) then
            table.insert(rayfilter, v)
        end
    end
    raycastparams.FilterDescendantsInstances = rayfilter
end
local function oncharacter(plr, c)
    characters[plr] = c
    refreshrayfilter()
end
local function onplayer(v)
    oncharacter(v, v.Character)
    v.CharacterAdded:Connect(function(c)
        oncharacter(v, c)
    end)
end
for i, v in pairs(plrs:GetPlayers()) do onplayer(v) end
plrs.PlayerAdded:Connect(onplayer)
plrs.PlayerRemoving:Connect(function(v)
    oncharacter(v, nil)
end)

local legcfR, legcfL, legvec = cf(1, -1.5, 0), cf(-1, -1.5, 0), v3(0, -1.5, 0)
local function raycastlegs()
    local rY, lY = raycast(ws, (cfr * legcfR).Position, legvec, raycastparams), raycast(ws, (cfr * legcfL).Position, legvec, raycastparams)
    return rY and (rY.Position.Y - (cfr.Y - 3)) or 0, lY and (lY.Position.Y - (cfr.Y - 3)) or 0
end

local euler, sin, sine, abs, clamp = CFrame.fromEulerAnglesXYZ, math.sin, 0, math.abs, math.clamp
local con = nil
con = renderstepped:Connect(function(deltaTime)
    if not c then
        return con:Disconnect()
    end
    raycastresult = raycast(ws, cfr.Position, v3_d, raycastparams)
    if raycastresult then
        onground = (cfr.Y - raycastresult.Position.Y) < 3.01
        if onground then
            vel = v3(0, (raycastresult.Position.Y + 3 - cfr.Y) * 0.5 / deltaTime, 0)
            if cfr.Y + vel.Y * deltaTime > raycastresult.Position.Y + 3 then
                vel = v3_0
                cfr += v3(0, raycastresult.Position.Y + 3 - cfr.Y, 0)
            end
            if movementkeys[Enum.KeyCode.Space] then
                vel = v3(0, jumpPower, 0)
            end
        else
            vel -= v3_010 * deltaTime * 196.2
            if cfr.Y + vel.Y * deltaTime < raycastresult.Position.Y then
                vel = v3(0, (raycastresult.Position.Y + 3 - cfr.Y) / deltaTime, 0)
            end
        end
    else
        onground = false
        raycastresult = raycast(ws, cfr.Position + v3_u, v3_d, raycastparams)
        if raycastresult then
            vel = v3(0, 65, 0)
            cfr += v3(0, raycastresult.Position.Y + 3 - cfr.Y, 0)
        else
            vel += v3_010 * deltaTime * 50
        end
    end
    vel *= v3_010
    local xzvel, camcf = v3_0, ws.CurrentCamera.CFrame
    if movementkeys[Enum.KeyCode.W] then
        xzvel += (camcf.LookVector * v3_101).Unit
    end
    if movementkeys[Enum.KeyCode.S] then
        xzvel -= (camcf.LookVector * v3_101).Unit
    end
    if movementkeys[Enum.KeyCode.A] then
        xzvel -= (camcf.RightVector * v3_101).Unit
    end
    if movementkeys[Enum.KeyCode.D] then
        xzvel += (camcf.RightVector * v3_101).Unit
    end
    if xzvel.Magnitude ~= 0 then
        cfr = cfr:Lerp(cf(cfr.Position, cfr.Position + xzvel), deltaTime * 10)
        xzvel = xzvel.Unit * walkSpeed
    end
    if uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
        cfr = cf(cfr.Position, cfr.Position + camcf.LookVector * v3_101)
    end
    vel += xzvel
    cfr += vel * deltaTime
    HumanoidRootPart.CFrame, HumanoidRootPart.Velocity, HumanoidRootPart.RotVelocity, HumanoidRootPart.Anchored = cfr, vel, v3_0, true
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum then 
        hum = Instance.new("Humanoid")
        for i, v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            pcall(hum.SetStateEnabled, v, false)
        end
        hum.Name = randomstring()
        hum.Parent = c
    end
    for i, v in pairs(hum:GetPlayingAnimationTracks()) do v:Stop() end
    ws.CurrentCamera.CameraSubject = hum
    sine += deltaTime
    deltaTime = clamp(deltaTime * 10, 0, 1)
    if vel.Magnitude < 0.01 then --idle
        
        if mode == "" then

            local rY, lY = raycastlegs()

            local cf, euler, sin = CFrame.new, CFrame.fromEulerAnglesXYZ, math.sin 
            RightHip.C0 = RightHip.C0:Lerp(cf(0, -1.5, 0.5) * euler(0, 0, 1.5707963267948966), deltaTime) 
            RootJoint.C0 = RootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.5707963267948966, 0.6981317007977318, 3.141592653589793), deltaTime) 
            LeftShoulder.C0 = LeftShoulder.C0:Lerp(cf(-0.5, 1.5, 0.5) * euler(0, -3.141592653589793, 1.5707963267948966), deltaTime) 
            RightShoulder.C0 = RightShoulder.C0:Lerp(cf(1, 1.5, 0) * euler(0, 1.5707963267948966, 0), deltaTime) 
            LeftHip.C0 = LeftHip.C0:Lerp(cf(-2, 0, 0) * euler(0, -1.5707963267948966, 0), deltaTime) 
            Neck.C0 = Neck.C0:Lerp(cf(0, -0.5, 0) * euler(-1.5707963267948966, 0, 3.141592653589793), deltaTime) 
            --RightLeg,0,0,0,1,0,0,0,1,-1.5,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,40,0,0,0.04,0,0,0,1,180,0,0,1,LeftArm,-0.5,0,0,1,-0,0,0,1,1.5,0,0,1,-180,0,0,1,0.5,0,0,1,90,0,0,1,RightArm,1,0,0,1,0,0,0,1,1.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-2,0,0,1,-0,0,0,1,-0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,-0.5,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1
            
            elseif mode == "nazi" then
            
            local cf, euler, sin = CFrame.new, CFrame.fromEulerAnglesXYZ, math.sin 
            RightHip.C0 = RightHip.C0:Lerp(cf(0, -1.5, 0.5) * euler(0, 0, 1.5707963267948966), deltaTime) 
            RootJoint.C0 = RootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.5707963267948966, 0.6981317007977318 + 5.235987755982989 * sin(sine * 0.5), 3.141592653589793), deltaTime) 
            LeftShoulder.C0 = LeftShoulder.C0:Lerp(cf(-0.5, 1.5, 0.5) * euler(0, -3.141592653589793, 1.5707963267948966), deltaTime) 
            RightShoulder.C0 = RightShoulder.C0:Lerp(cf(1, 1.5, 0) * euler(0, 1.5707963267948966, 0), deltaTime) 
            LeftHip.C0 = LeftHip.C0:Lerp(cf(-2, 0, 0) * euler(0, -1.5707963267948966, 0), deltaTime) 
            Neck.C0 = Neck.C0:Lerp(cf(0, -0.5, 0) * euler(-1.5707963267948966, 0, 3.141592653589793), deltaTime) 
            --RightLeg,0,0,0,1,0,0,0,1,-1.5,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,40,300,0,0.5,0,0,0,1,180,0,0,1,LeftArm,-0.5,0,0,1,-0,0,0,1,1.5,0,0,1,-180,0,0,1,0.5,0,0,1,90,0,0,1,RightArm,1,0,0,1,0,0,0,1,1.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-2,0,0,1,-0,0,0,1,-0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,-0.5,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1

        end
        
    else
        
        local fw, rt = cfr.LookVector * vel / walkSpeed, cfr.RightVector * vel / walkSpeed
        fw, rt = fw.X + fw.Z, rt.X + rt.Z
        
        if onground and ((vel * v3_101).Magnitude > 0) then -- walk
            
            local rY, lY = raycastlegs()
            
            local cf, euler, sin = CFrame.new, CFrame.fromEulerAnglesXYZ, math.sin 
            RightHip.C0 = RightHip.C0:Lerp(cf(0, -1.5, 0.5) * euler(0, 0, 1.5707963267948966), deltaTime) 
            RootJoint.C0 = RootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.5707963267948966, 0.6981317007977318, 3.141592653589793), deltaTime) 
            LeftShoulder.C0 = LeftShoulder.C0:Lerp(cf(-0.5, 1.5, 0.5) * euler(0, -3.141592653589793, 1.5707963267948966), deltaTime) 
            RightShoulder.C0 = RightShoulder.C0:Lerp(cf(1, 1.5, 0) * euler(0, 1.5707963267948966, 0), deltaTime) 
            LeftHip.C0 = LeftHip.C0:Lerp(cf(-2, 0, 0) * euler(0, -1.5707963267948966, 0), deltaTime) 
            Neck.C0 = Neck.C0:Lerp(cf(0, -0.5, 0) * euler(-1.5707963267948966, 0, 3.141592653589793), deltaTime) 
            --RightLeg,0,0,0,1,0,0,0,1,-1.5,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,40,0,0,0.04,0,0,0,1,180,0,0,1,LeftArm,-0.5,0,0,1,-0,0,0,1,1.5,0,0,1,-180,0,0,1,0.5,0,0,1,90,0,0,1,RightArm,1,0,0,1,0,0,0,1,1.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-2,0,0,1,-0,0,0,1,-0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,-0.5,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1

        elseif vel.Y > 0 then -- jump
            
            local cf, euler, sin = CFrame.new, CFrame.fromEulerAnglesXYZ, math.sin 
            RightHip.C0 = RightHip.C0:Lerp(cf(0, -1.5, 0.5) * euler(0, 0, 1.5707963267948966), deltaTime) 
            RootJoint.C0 = RootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.5707963267948966, 0.6981317007977318, 3.141592653589793), deltaTime) 
            LeftShoulder.C0 = LeftShoulder.C0:Lerp(cf(-0.5, 1.5, 0.5) * euler(0, -3.141592653589793, 1.5707963267948966), deltaTime) 
            RightShoulder.C0 = RightShoulder.C0:Lerp(cf(1, 1.5, 0) * euler(0, 1.5707963267948966, 0), deltaTime) 
            LeftHip.C0 = LeftHip.C0:Lerp(cf(-2, 0, 0) * euler(0, -1.5707963267948966, 0), deltaTime) 
            Neck.C0 = Neck.C0:Lerp(cf(0, -0.5, 0) * euler(-1.5707963267948966, 0, 3.141592653589793), deltaTime) 
            --RightLeg,0,0,0,1,0,0,0,1,-1.5,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,40,0,0,0.04,0,0,0,1,180,0,0,1,LeftArm,-0.5,0,0,1,-0,0,0,1,1.5,0,0,1,-180,0,0,1,0.5,0,0,1,90,0,0,1,RightArm,1,0,0,1,0,0,0,1,1.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-2,0,0,1,-0,0,0,1,-0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,-0.5,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1
            
        else -- fall
            
            local cf, euler, sin = CFrame.new, CFrame.fromEulerAnglesXYZ, math.sin 
            RightHip.C0 = RightHip.C0:Lerp(cf(0, -1.5, 0.5) * euler(0, 0, 1.5707963267948966), deltaTime) 
            RootJoint.C0 = RootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.5707963267948966, 0.6981317007977318, 3.141592653589793), deltaTime) 
            LeftShoulder.C0 = LeftShoulder.C0:Lerp(cf(-0.5, 1.5, 0.5) * euler(0, -3.141592653589793, 1.5707963267948966), deltaTime) 
            RightShoulder.C0 = RightShoulder.C0:Lerp(cf(1, 1.5, 0) * euler(0, 1.5707963267948966, 0), deltaTime) 
            LeftHip.C0 = LeftHip.C0:Lerp(cf(-2, 0, 0) * euler(0, -1.5707963267948966, 0), deltaTime) 
            Neck.C0 = Neck.C0:Lerp(cf(0, -0.5, 0) * euler(-1.5707963267948966, 0, 3.141592653589793), deltaTime) 
            --RightLeg,0,0,0,1,0,0,0,1,-1.5,0,0,1,0,0,0,1,0.5,0,0,1,90,0,0,1,Torso,0,0,0,1,-90,0,0,1,0,0,0,1,40,0,0,0.04,0,0,0,1,180,0,0,1,LeftArm,-0.5,0,0,1,-0,0,0,1,1.5,0,0,1,-180,0,0,1,0.5,0,0,1,90,0,0,1,RightArm,1,0,0,1,0,0,0,1,1.5,0,0,1,90,0,0,1,0,0,0,1,0,0,0,1,LeftLeg,-2,0,0,1,-0,0,0,1,-0,0,0,1,-90,0,0,1,0,0,0,1,0,0,0,1,Head,0,0,0,1,-90,0,0,1,-0.5,0,0,1,-0,0,0,1,0,0,0,1,180,0,0,1
            
        end
        
    end
end)
