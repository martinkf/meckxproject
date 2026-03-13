local BannedCreditNames = {
    "begginer",
    "easy",
    "medium",
    "normal",
    "hard",
    "crazy",
    "challenge",
    "edit",
    "alternative",
    "another",
    "blank",
    "blanco",
    "copied",
    "single",
    "double",
    "nightmare",
    "freestyle",
    "andamiro",
    "stepmania",
    "nostep",
    "lv",
    "nivel",
    "s1",
    "s2",
    "s3",
    "s4",
    "s5",
    "sdf"
}

function Actor:easeoutquad(duration)
	self:linear((duration/3)*2):accelerate(duration/3)
    return self
end

function Actor:easeinquad(duration)
    self:linear((duration/3)*2):decelerate(duration/3)
	return self
end

function include(file)		--sirve para cargar archivos tipo scripts desde others, con la ventaja de que se pueden recargar
	if not file then return false end;
		dofile(THEME:GetPathO("", file));
	return true;
end;

function GetElement(file,folder)	--manera rapida de cargar elementos desde una carpeta especifica, es una forma de organizar archivos
	if not folder then folder = "" else folder = folder.."/" end;
		return THEME:GetPathG("","ThemeAssets/"..folder..file);
end;

local function QUESTLABEL( a,b )
	local STEP1 =string.gsub(a:GetLabelType(), "LABELTYPE_S", "");
	local STEP2 = string.gsub(b:GetLabelType(), "LABELTYPE_S", "");
	return STEP1 < STEP2;
end

function GetActiveIndex(pn)
	local _list = GetSteps();
	local curSteps = GAMESTATE:GetCurrentSteps(pn);
	if _list then
		for i=1,#_list do
			if curSteps == _list[i] then 
				return i;
			end;
		end;
	end;
	return 1;
end;

function StepTypeToMode(stype)
    local mapping = {
        ["StepsType_Pump_Single"] = "pump-single",
        ["StepsType_Pump_Double"] = "pump-double",
        ["StepsType_Pump_Halfdouble"] = "pump-half",
        ["StepsType_Pump_Single_P"] = "pump-single-p",
        ["StepsType_Pump_Double_P"] = "pump-double-p"
    }
    return mapping[stype] or ""
end

function getTrainProgresiveInfoLess(currentSong)
	currentSong = currentSong or GAMESTATE:GetCurrentSong()
    if not currentSong then return {duration=10,bpm="???"} end
    local vpSteps;
    if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
		local vpSongs, vpTemp = GAMESTATE:GetTrainInfo(GAMESTATE:GetCurrentSong(),false);
		vpSteps = vpTemp;

		local totalDuration = 0;
		local bpmText="";
		local bpmList = {};

		for i=1 ,#vpSteps do
			local songData = SONGMAN:GetSongFromSteps(vpSteps[i]);
			totalDuration = totalDuration + songData:MusicLengthSeconds();

			local customBpm = songData:GetCustomBPM();

			--trabajamos el bpm, probablemente
			if customBpm ~= "???" then
				if string.find(customBpm, "-") then
				    local partes = split(customBpm, "-")
				    for i, v in ipairs(partes) do
				    	--Trace("#Parts bpm="..v);
				        table.insert(bpmList,v);
				    end
				else
					table.insert(bpmList,customBpm);
				end
			end;
		end;

		if #bpmList > 1 then
			table.sort(bpmList)
			bpmText =bpmList[1].."-"..bpmList[#bpmList];
		elseif #bpmList == 1 then
			bpmText =bpmList[0];
		elseif #bpmList == 0 then
			bpmText = "???";
		end;
		return {duration=totalDuration,bpm=bpmText}
	end;
	return {duration=10,bpm="???"}
end;



function GetSteps(currentSong)
	currentSong = currentSong or GAMESTATE:GetCurrentSong()
    if not currentSong then return nil end

    local vpSteps;
	local isCustom = false;		--con este determinamos el tipo de tabla a returnar
    if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
		local vpSongs, vpTemp = GAMESTATE:GetTrainInfo(GAMESTATE:GetCurrentSong(),false);
		
		vpSteps = vpTemp;	
		local auxSteps={};
		for i=1 ,#vpSteps do

			local numPlayersSteps = 1;
			if vpSteps[i]:GetPlayers() ~= nil then
				numPlayersSteps = vpSteps[i]:GetPlayers();
			end;

			auxSteps[i] = {};
			auxSteps[i].meter = vpSteps[i]:GetMeter();
			auxSteps[i].modes = StepTypeToMode(vpSteps[i]:GetStepsType());
			auxSteps[i].stepType = vpSteps[i]:GetStepsType();
			auxSteps[i].players = numPlayersSteps;
			auxSteps[i].label = "normal";
			auxSteps[i].realstep = null;
			auxSteps[i].cuslabel = "";
			
		end;
		vpSteps = auxSteps;
		isCustom = true;
    elseif GAMESTATE:GetQuestZoneChannel() then

        vpSteps = currentSong:GetAllSteps()
		table.sort(vpSteps, QUESTLABEL)
		isCustom = false;
		--[[	--se puede ir directo
		local auxSteps={};
		for i=1 ,#vpSteps ,1 do
				auxSteps[#auxSteps+1] = {};
				auxSteps[#auxSteps].meter = vpSteps[i]:GetMeter();
				auxSteps[#auxSteps].modes = StepTypeToMode(vpSteps[i]:GetStepsType());
				auxSteps[#auxSteps].players = vpSteps[i]:GetPlayers();
				auxSteps[#auxSteps].label = LabelTypeToMode(vpSteps[i]:GetLabelType());
				auxSteps[#auxSteps].difficulty = vpSteps[i]:GetDifficulty();
				auxSteps[#auxSteps].realstep = vpSteps[i];
				auxSteps[#auxSteps].cuslabel = DesCustomLabel(vpSteps[i]:GetDescription());
		end;
		return auxSteps;
		--]]
	--	return vpSteps,isCustom;
    else
        vpSteps = SongUtil.GetCurrentPlayableSteps(currentSong)
		isCustom = false;
    end

    if GAMESTATE:GetNumPlayersEnabled() == 2 then

		if GAMESTATE:GetMusicTrainChannel() then
			--Aca hacer algo cuando es train.
		else
	        for i = #vpSteps, 1, -1 do
	            local mode = StepTypeToMode(vpSteps[i]:GetStepsType())
	            if mode == "pump-half" or mode == "pump-double" or mode == "pump-double-p" then
	                table.remove(vpSteps, i)
	            end
	        end
		end;


    end

    return vpSteps,isCustom;
end

local function GRAY(songSteps, player, lfloor)
	if not GAMESTATE:GetQuestZoneChannel() then return false end

	local profile = PROFILEMAN:GetProfile(player)
	local currentSong = GAMESTATE:GetCurrentSong()
	if not profile or not currentSong then return false end

	for _, step in ipairs(songSteps) do
		local hsList = profile:GetHighScoreList(currentSong, step.realstep):GetHighScores()
		for _, score in ipairs(hsList) do
			if score:GetLabelType() == lfloor and score:GetSuccess() then
				return false
			end
		end
	end

	return true
end

function GetCurrentStepfromList(n)
	local steps = GetSteps();
	if not steps then return nil end;
	if n > 0 and n <= #steps then
		return steps[n];
	end;
	return nil;
end;

function DirectIconLayer(step)	--lo dejo solo por si necesitamos una tabla de estados para un sprite
	local stepMapping = {
		["Pump_Single"] = 0,
		["Pump_Double"] = 1,
		["Pump_Single_P"] = 2,
		["Pump_Double_P"] = 3,
		["Pump_Routine"] = 4,
		["Pump_Halfdouble"] = 5,
		["Dance_Single"] = 2,
		["Dance_Solo"] = 5,
		["Dance_Double"] = 2,
		["Dance_Couple"] = 4,
		["Dance_Routine"] = 4,
		["Dance_Threepanel"] = 3,
		["Dance_Sixpanel"] = 1
	}
	return stepMapping[ToEnumShortString(step:GetStepsType())] or 7
end

function DirectIconLayerStepType(stepType)	--lo dejo solo por si necesitamos una tabla de estados para un sprite
	local stepMapping = {
		["Pump_Single"] = 0,
		["Pump_Double"] = 1,
		["Pump_Single_P"] = 2,
		["Pump_Double_P"] = 3,
		["Pump_Routine"] = 4,
		["Pump_Halfdouble"] = 5,
		["Dance_Single"] = 2,
		["Dance_Solo"] = 5,
		["Dance_Double"] = 2,
		["Dance_Couple"] = 4,
		["Dance_Routine"] = 4,
		["Dance_Threepanel"] = 3,
		["Dance_Sixpanel"] = 1
	}
	return stepMapping[ToEnumShortString(stepType)] or 7
end


function GetIconLayer(n,_list)
	if not n or not _list then return nil end;
	if n >#_list then return false end;
		return DirectIconLayer(_list[n])
end;

function GetIconLayerStepType(n,_list)
	if not n or not _list then return nil end;
	if n >#_list then return false end;
		return DirectIconLayerStepType(_list[n].stepType)
end;


function LabelTypeToMode(ltype)
    local mapping = {
        ["LABELTYPE_S1"] = "s1",
        ["LABELTYPE_S2"] = "s2",
        ["LABELTYPE_S3"] = "s3",
        ["LABELTYPE_S4"] = "s4",
        ["LABELTYPE_ANOTHER"] = "another",
        ["LABELTYPE_NEW"] = "new",
        ["LABELTYPE_UCS"] = "ucs",
        ["LABELTYPE_UCQ"] = "ucq",
        ["LABELTYPE_NORMAL"] = "normal",
        ["LABELTYPE_QUEST"] = "quest",
        ["LABELTYPE_PRO"] = "pro",
        ["LABELTYPE_INFINITY"] = "infinity",
        ["LABELTYPE_JUMP"] = "jump",
        ["LABELTYPE_HIDDEN"] = "hidden",
        ["LABELTYPE_TRAIN"] = "train"
    }
    return mapping[ltype] or ""
end

function DesCustomLabel(ltype)
    local fxlb = string.upper(ltype)
    if string.find(fxlb, "QUEST") then
        return "quest"
    elseif string.find(fxlb, "ANOTHER") then
        return "another"
    elseif string.find(fxlb, "PRO") then
        return "pro"
    elseif string.find(fxlb, "INFINITY") then
        return "infinity"
    elseif string.find(fxlb, "JUMP") then
        return "jump"
    elseif string.find(fxlb, "HIDDEN") then
        return "hidden"
    elseif string.find(fxlb, "TRAIN") then
        return "train"
    elseif string.find(fxlb, "BOSS") then
        return "boss"
    elseif string.find(fxlb, "KEYBOARD") then
        return "keyboard"
    elseif string.find(fxlb, "KB") then
        return "keyboard"
    else
        return "normal"
    end
end

function Actor:wag(magnitude, period)
		magnitude = magnitude or 10;
		period = period or 1;
    self:stoptweening()
    self:linear(period / 2)
    self:addx(magnitude)
    self:linear(period / 2)
    self:addx(-magnitude)
    self:queuecommand("Wag")
    return self
end;

function setNormalLabelState(label, cuslabel)
	
    local states = {
        quest = 1, another = 2, pro = 3, infinity = 4,
        hidden = 5, jump = 6, train = 7, ucq = 8 , keyboard = 9, kb = 9, boss = 10
    }

    local state = states[label] or states[cuslabel]
    if state then
        return state
    end
	return 0;
end

function FixedChartCreditNames(value) -- valida y depura nombres no válidos, se basa en la tabla BannedCreditNames
    if not value or value == "" then return "" end

    local standardizedValue = StandarizedString(value)
    for _, bannedName in ipairs(BannedCreditNames) do
        if standardizedValue == StandarizedString(bannedName) then
            return ""
        end
    end
    for _, bannedName in ipairs(BannedCreditNames) do
        if string.find(standardizedValue, StandarizedString(bannedName), 1, true) then
            return ""
        end
    end
    return value
end

function DisplayLV(n)
	if n == 51 then
		return "!!";
	end;
	return n >= 31 and "??" or string.format("%02i",n);
end;

function StandarizedString(value)	--depura strings
    if not value or value == "" then return "" end
    local normalized = string.lower(value)
		normalized = string.gsub(normalized, "[^a-z0-9]", "")
		normalized = string.gsub(normalized, "^%s*(.-)%s*$", "%1")
    return string.upper(normalized)
end

--[[

function DirectIconLayer2(step)

	local stepMapping = {
		["Pump_Single"] = 2,
		["Pump_Double"] = 1,
		["Pump_Double_P"] = 6,
		["Pump_Routine"] = 6,
		["Pump_Single_P"] = 4,
		["Pump_Halfdouble"] = 7
	}
	return stepMapping[ToEnumShortString(step:GetStepsType())] or 0
end
--]]

function CheckLock(lfloor, pn, song)
	if not GAMESTATE:GetQuestZoneChannel() then return false end

	local profile = PROFILEMAN:GetProfile(pn)
		if not profile then return false end;
	song = song or GAMESTATE:GetCurrentSong();
		if not song then return false end;
	local steps = GetSteps(song)
		if not steps then return false end;
		if #steps < 1 then return false end

	for _, curstep in ipairs(steps) do
		local hsList = profile:GetHighScoreList(song, curstep):GetHighScores()
		if not hsList then return false end;
		for _, score in ipairs(hsList) do
			if string.lower(score:GetLabelType()) == string.lower(lfloor) and score:GetSuccess() then
				return false
			end
		end
	end

	return true
end