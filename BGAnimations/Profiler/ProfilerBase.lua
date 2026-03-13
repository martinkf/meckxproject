-- Performance Profiler para StepMania 5 - Optimización
local updateInterval = 0.1
local timeSinceUpdate = 0

-- Históricos para promedios
local fpsHistory = {}
local frameTimeHistory = {}
local maxHistorySize = 100

-- Estadísticas
local stats = {
    fps = {current = 0, min = 999, max = 0, avg = 0},
    frameTime = {current = 0, min = 999, max = 0, avg = 0},
    actors = 0,
    memory = 0,
    gcCount = 0,
    lastGC = 0,
    totalTime = 0
}

-- Referencias a los textos
local textRefs = {}

-- Colores
local colorGood = color("#00FF00")
local colorWarning = color("#FFAA00")
local colorBad = color("#FF0000")
local colorInfo = color("#00AAFF")

return Def.ActorFrame {
    Name = "PerformanceProfiler",
    InitCommand = function(self)
        self:Center()
        
        -- Inicializar históricos
        for i = 1, maxHistorySize do
            fpsHistory[i] = 60
            frameTimeHistory[i] = 16.67
        end
    end,
    
    -- Panel de fondo
    Def.Quad {
        InitCommand = function(self)
            self:setsize(400, 480)
            self:diffuse(0, 0, 0, 0.9)
        end
    },
    
    -- Borde
    Def.Quad {
        InitCommand = function(self)
            self:setsize(404, 484)
            self:diffuse(0.2, 0.5, 0.8, 1)
            self:draworder(-1)
        end
    },
    
    -- Título
    Def.BitmapText {
        Font = "Common Normal",
        Text = "PERFORMANCE PROFILER",
        InitCommand = function(self)
            self:y(-230)
            self:zoom(0.8)
            self:diffuse(1, 1, 1, 1)
            self:shadowlength(2)
        end
    },
    
    -- Separador 1
    Def.Quad {
        InitCommand = function(self)
            self:setsize(380, 2)
            self:y(-205)
            self:diffuse(0.3, 0.6, 0.9, 0.5)
        end
    },
    
    -- === SECCIÓN FPS ===
    Def.BitmapText {
        Font = "Common Normal",
        Text = "FRAME RATE",
        InitCommand = function(self)
            self:y(-185)
            self:zoom(0.6)
            self:diffuse(0.7, 0.7, 0.7, 1)
        end
    },
    
    -- FPS Current Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Current:",
        InitCommand = function(self)
            self:xy(-150, -160)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- FPS Current Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.0 FPS",
        InitCommand = function(self)
            self:xy(10, -160)
            self:zoom(0.6)
            self:halign(0)
            textRefs.fpsCurrent = self
        end
    },
    
    -- FPS Average Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Average:",
        InitCommand = function(self)
            self:xy(-150, -135)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- FPS Average Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.0 FPS",
        InitCommand = function(self)
            self:xy(10, -135)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorInfo)
            textRefs.fpsAvg = self
        end
    },
    
    -- FPS Min/Max Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Min / Max:",
        InitCommand = function(self)
            self:xy(-150, -110)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- FPS Min/Max Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.0 / 0.0",
        InitCommand = function(self)
            self:xy(10, -110)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorWarning)
            textRefs.fpsMinMax = self
        end
    },
    
    -- FPS Status
    Def.BitmapText {
        Font = "Common Normal",
        Text = "● Status: INITIALIZING",
        InitCommand = function(self)
            self:y(-85)
            self:zoom(0.5)
            self:diffuse(colorInfo)
            textRefs.fpsStatus = self
        end
    },
    
    -- Separador 2
    Def.Quad {
        InitCommand = function(self)
            self:setsize(380, 2)
            self:y(-60)
            self:diffuse(0.3, 0.6, 0.9, 0.5)
        end
    },
    
    -- === SECCIÓN FRAME TIME ===
    Def.BitmapText {
        Font = "Common Normal",
        Text = "FRAME TIME",
        InitCommand = function(self)
            self:y(-40)
            self:zoom(0.6)
            self:diffuse(0.7, 0.7, 0.7, 1)
        end
    },
    
    -- Frame Time Current Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Current:",
        InitCommand = function(self)
            self:xy(-150, -15)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Frame Time Current Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.00 ms",
        InitCommand = function(self)
            self:xy(10, -15)
            self:zoom(0.6)
            self:halign(0)
            textRefs.ftCurrent = self
        end
    },
    
    -- Frame Time Average Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Average:",
        InitCommand = function(self)
            self:xy(-150, 10)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Frame Time Average Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.00 ms",
        InitCommand = function(self)
            self:xy(10, 10)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorInfo)
            textRefs.ftAvg = self
        end
    },
    
    -- Frame Time Min/Max Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Min / Max:",
        InitCommand = function(self)
            self:xy(-150, 35)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Frame Time Min/Max Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.00 / 0.00 ms",
        InitCommand = function(self)
            self:xy(10, 35)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorGood)
            textRefs.ftMinMax = self
        end
    },
    
    -- Separador 3
    Def.Quad {
        InitCommand = function(self)
            self:setsize(380, 2)
            self:y(60)
            self:diffuse(0.3, 0.6, 0.9, 0.5)
        end
    },
    
    -- === SECCIÓN MEMORIA ===
    Def.BitmapText {
        Font = "Common Normal",
        Text = "MEMORY & GARBAGE COLLECTION",
        InitCommand = function(self)
            self:y(80)
            self:zoom(0.6)
            self:diffuse(0.7, 0.7, 0.7, 1)
        end
    },
    
    -- Lua Memory Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Lua Memory:",
        InitCommand = function(self)
            self:xy(-150, 105)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Lua Memory Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.00 MB",
        InitCommand = function(self)
            self:xy(10, 105)
            self:zoom(0.5)
            self:halign(0)
            textRefs.memory = self
        end
    },
    
    -- GC Count Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "GC Count:",
        InitCommand = function(self)
            self:xy(-150, 130)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- GC Count Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0 collections",
        InitCommand = function(self)
            self:xy(10, 130)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorInfo)
            textRefs.gcCount = self
        end
    },
    
    -- Last GC Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Last GC:",
        InitCommand = function(self)
            self:xy(-150, 155)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Last GC Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0.0 sec ago",
        InitCommand = function(self)
            self:xy(10, 155)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(colorInfo)
            textRefs.lastGC = self
        end
    },
    
    -- Separador 4
    Def.Quad {
        InitCommand = function(self)
            self:setsize(380, 2)
            self:y(180)
            self:diffuse(0.3, 0.6, 0.9, 0.5)
        end
    },
    
    -- === SECCIÓN ACTORS ===
    Def.BitmapText {
        Font = "Common Normal",
        Text = "SCENE COMPLEXITY",
        InitCommand = function(self)
            self:y(200)
            self:zoom(0.6)
            self:diffuse(0.7, 0.7, 0.7, 1)
        end
    },
    
    -- Active Actors Label
    Def.BitmapText {
        Font = "Common Normal",
        Text = "Active Actors:",
        InitCommand = function(self)
            self:xy(-150, 225)
            self:zoom(0.5)
            self:halign(0)
            self:diffuse(0.8, 0.8, 0.8, 1)
        end
    },
    
    -- Active Actors Value
    Def.BitmapText {
        Font = "Common Normal",
        Text = "0 actors",
        InitCommand = function(self)
            self:xy(10, 225)
            self:zoom(0.5)
            self:halign(0)
            textRefs.actors = self
        end
    },
    
    -- Update loop
    OnCommand = function(self)
        local gcTimeSinceReset = 0
        local lastGCCount = collectgarbage("count")
        
        self:SetUpdateFunction(function(self, delta)
            timeSinceUpdate = timeSinceUpdate + delta
            stats.totalTime = stats.totalTime + delta
            gcTimeSinceReset = gcTimeSinceReset + delta
            
            if timeSinceUpdate >= updateInterval then
                -- FPS
                local fps = DISPLAY:GetFPS()
                table.remove(fpsHistory, 1)
                table.insert(fpsHistory, fps)
                
                stats.fps.current = fps
                if fps < stats.fps.min then stats.fps.min = fps end
                if fps > stats.fps.max then stats.fps.max = fps end
                
                local fpsSum = 0
                for i = 1, #fpsHistory do
                    fpsSum = fpsSum + fpsHistory[i]
                end
                stats.fps.avg = fpsSum / #fpsHistory
                
                -- Frame Time
                local frameTime = (1 / math.max(fps, 1)) * 1000
                table.remove(frameTimeHistory, 1)
                table.insert(frameTimeHistory, frameTime)
                
                stats.frameTime.current = frameTime
                if frameTime < stats.frameTime.min then stats.frameTime.min = frameTime end
                if frameTime > stats.frameTime.max then stats.frameTime.max = frameTime end
                
                local ftSum = 0
                for i = 1, #frameTimeHistory do
                    ftSum = ftSum + frameTimeHistory[i]
                end
                stats.frameTime.avg = ftSum / #frameTimeHistory
                
                -- Memoria Lua (en MB)
                local memKB = collectgarbage("count")
                stats.memory = memKB / 1024
                
                -- Garbage Collection - detectar cuando la memoria baja
                local currentGCCount = collectgarbage("count")
                if currentGCCount < lastGCCount then
                    stats.gcCount = stats.gcCount + 1
                    gcTimeSinceReset = 0  -- Reset del timer
                end
                lastGCCount = currentGCCount
                stats.lastGC = gcTimeSinceReset
                
                -- Contar actors
                stats.actors = self:GetParent():GetNumChildren()
                
                -- Actualizar textos
                if textRefs.fpsCurrent then
                    textRefs.fpsCurrent:settext(string.format("%.1f FPS", stats.fps.current))
                    if stats.fps.current >= 55 then
                        textRefs.fpsCurrent:diffuse(colorGood)
                    elseif stats.fps.current >= 30 then
                        textRefs.fpsCurrent:diffuse(colorWarning)
                    else
                        textRefs.fpsCurrent:diffuse(colorBad)
                    end
                end
                
                if textRefs.fpsAvg then
                    textRefs.fpsAvg:settext(string.format("%.1f FPS", stats.fps.avg))
                end
                
                if textRefs.fpsMinMax then
                    textRefs.fpsMinMax:settext(string.format("%.1f / %.1f", stats.fps.min, stats.fps.max))
                end
                
                if textRefs.fpsStatus then
                    local fps = stats.fps.current
                    if fps >= 60 then
                        textRefs.fpsStatus:settext("Status: EXCELLENT")
                        textRefs.fpsStatus:diffuse(colorGood)
                    elseif fps >= 45 then
                        textRefs.fpsStatus:settext("Status: GOOD")
                        textRefs.fpsStatus:diffuse(colorGood)
                    elseif fps >= 30 then
                        textRefs.fpsStatus:settext("Status: UNSTABLE")
                        textRefs.fpsStatus:diffuse(colorWarning)
                    else
                        textRefs.fpsStatus:settext("Status: CRITICAL")
                        textRefs.fpsStatus:diffuse(colorBad)
                    end
                end
                
                if textRefs.ftCurrent then
                    textRefs.ftCurrent:settext(string.format("%.2f ms", stats.frameTime.current))
                    if stats.frameTime.current <= 16.67 then
                        textRefs.ftCurrent:diffuse(colorGood)
                    elseif stats.frameTime.current <= 33.33 then
                        textRefs.ftCurrent:diffuse(colorWarning)
                    else
                        textRefs.ftCurrent:diffuse(colorBad)
                    end
                end
                
                if textRefs.ftAvg then
                    textRefs.ftAvg:settext(string.format("%.2f ms", stats.frameTime.avg))
                end
                
                if textRefs.ftMinMax then
                    textRefs.ftMinMax:settext(string.format("%.2f / %.2f ms", stats.frameTime.min, stats.frameTime.max))
                end
                
                if textRefs.memory then
                    textRefs.memory:settext(string.format("%.2f MB", stats.memory))
                    if stats.memory < 50 then
                        textRefs.memory:diffuse(colorGood)
                    elseif stats.memory < 100 then
                        textRefs.memory:diffuse(colorWarning)
                    else
                        textRefs.memory:diffuse(colorBad)
                    end
                end
                
                if textRefs.gcCount then
                    textRefs.gcCount:settext(string.format("%d collections", stats.gcCount))
                end
                
                if textRefs.lastGC then
                    textRefs.lastGC:settext(string.format("%.1f sec ago", stats.lastGC))
                end
                
                if textRefs.actors then
                    textRefs.actors:settext(string.format("%d actors", stats.actors))
                    if stats.actors < 200 then
                        textRefs.actors:diffuse(colorGood)
                    elseif stats.actors < 500 then
                        textRefs.actors:diffuse(colorWarning)
                    else
                        textRefs.actors:diffuse(colorBad)
                    end
                end
                
                timeSinceUpdate = 0
            end
        end)
    end
}