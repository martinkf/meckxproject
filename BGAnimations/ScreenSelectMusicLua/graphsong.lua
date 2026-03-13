local t = Def.ActorFrame {};

local function round2(n)
	return math.floor(n * 100 + 0.5) / 100
end

function ProcessBPMGraph(_bpm)
    local part1, part2 = _bpm:match("([^%-]+)%-([^%-]+)")
    if part1 and part2 then
        local n1 = tonumber(part1)
        local n2 = tonumber(part2)
        if n1 and n2 then
            return math.max(n1, n2)
        end
    end

    -- Si no tiene guión o es un solo número
    local single = tonumber(_bpm)
    if single then
        return single
    end

    -- Si no es número válido, retornar nil
    return 0
end


function calcSpeed(taps,jmp,trip,songdurationseg,bpm,debugPrint)


	--nueva formula
	local stepTierNoteRatio = {
		{tier=1,notes=0,ratio=0},
		{tier=2,notes=200,ratio=0.2},
		{tier=3,notes=300,ratio=0.3},
		{tier=4,notes=400,ratio=0.4},
		{tier=5,notes=600,ratio=0.5},
		{tier=6,notes=700,ratio=0.6},
		{tier=6,notes=800,ratio=0.7},
		{tier=6,notes=900,ratio=0.8},
		{tier=7,notes=1000,ratio=0.9},
		{tier=8,notes=1250,ratio=1},
		{tier=9,notes=1500,ratio=1.25},
		{tier=10,notes=1700,ratio=1.5}
	};

	local noteRatio=0;
	local bpmRatio = 0;
	local durationRatio = 0;	
	local intensity_score = 0;

	local noteRatioW = 0.3;	
	local bpmRatioW = 0.3;
	local durationRatioW = 0.1;	
	local intensityRatioW = 0.3;

	--total notes
	local totalNotes = taps+jmp+trip;

	for i=1,10 do
		if taps > stepTierNoteRatio[i]["notes"] then
			noteRatio = stepTierNoteRatio[i]["ratio"];
		end;
	end;

	--intensidad.
	local raw_intensity = (totalNotes / songdurationseg) * (bpm / 150);
	local max_intensity = 20 ; -- 10 notas por segundo a 300 bpm es la intensidad maxima...
	local intensity_score = math.min(raw_intensity / max_intensity, 1)


	--bpm on diff
	if bpm > 0 and bpm <= 80 then
		bpmRatio = 0;
	elseif bpm > 80 and bpm <= 120 then
		bpmRatio = 0.1;		
	elseif bpm > 120 and bpm <= 140 then
		bpmRatio = 0.2;
	elseif bpm > 140 and bpm <= 150 then
		bpmRatio = 0.3;		
	elseif bpm > 150 and bpm <= 160 then
		bpmRatio = 0.4;				
	elseif bpm > 160 and bpm <= 170 then
		bpmRatio = 0.5;				
	elseif bpm > 170 and bpm <= 180 then
		bpmRatio = 0.6;			
	elseif bpm > 180 and bpm <= 190 then
		bpmRatio = 0.7;			
	elseif bpm > 190 and bpm <= 200 then
		bpmRatio = 0.8;
	elseif bpm > 200 and bpm <= 220 then
		bpmRatio = 0.9;			
	elseif bpm > 220 and bpm <= 230 then
		bpmRatio = 1;
	elseif bpm > 230 and bpm <= 240 then
		bpmRatio = 1.1;		
	elseif bpm > 240 then
		bpmRatio = 1.2;
	end;

	--seg diff
	if songdurationseg > 0 and songdurationseg <= 100 then
		durationRatio = 0.15;	
	elseif songdurationseg > 100 and songdurationseg <= 150 then
		durationRatio = 0.3;
	elseif songdurationseg > 150 and songdurationseg <= 300 then
		durationRatio = 0.6;
	elseif songdurationseg > 300 and songdurationseg <= 600 then
		durationRatio = 1;		
	elseif songdurationseg > 600 and songdurationseg <= 900 then
		durationRatio = 1.5;				
	else
		durationRatio = 2;
	end;

	local speed_score = ( (noteRatio * noteRatioW) + (bpmRatio * bpmRatioW) + (durationRatio * durationRatioW) + (intensity_score*intensityRatioW));

	if debugPrint then
		Trace("###############################");
		Trace("############ SPEED ############");
		Trace("###totalNotes ="..noteRatio .. " Ratio:"..noteRatio * noteRatioW);
		Trace("###raw_intensity ="..raw_intensity);
		Trace("###Intensity ="..intensity_score .. " Ratio:"..intensity_score*intensityRatioW);
		Trace("###bpmRatio ="..bpmRatio .. " Ratio:"..bpmRatio * bpmRatioW);
		Trace("###durationRatio ="..durationRatio .. " Ratio:"..durationRatio * durationRatio);
		Trace("###############################");
		Trace("SPEED SCORE: "..speed_score);
		Trace("###############################");
	end;

	return speed_score;

end;


function getTec(taps,jmp,trip,songdurationseg,bpm,debugPrint)
	local bpmRatio = 0;
	local durationRatio = 0;
	local tecRatioFinal = 0;
	local jmpRatioFinal = 0;
	local tripRatioFinal = 0;

	local intensityRatioW = 0.2;
	local bpmRatioW = 0.2;
	local tecRatioW = 0.2;
	local jmpRatioW = 0.2;
	local trplRatioW = 0.2;



	--total notes
	local totalNotes = taps+jmp+trip;
	local noteRatio = taps / totalNotes;
	local tecRatio = (jmp + trip) / totalNotes;

	if tecRatio == 0 then
		return 0;
	end;	

	if tecRatio > 0 and tecRatio <= 0.01 then
		tecRatioFinal = 0.05;
	elseif tecRatio > 0.01 and tecRatio <= 0.02 then
		tecRatioFinal = 0.1;
	elseif tecRatio > 0.02 and tecRatio <= 0.03 then
		tecRatioFinal = 0.15;		
	elseif tecRatio > 0.03 and tecRatio <= 0.05 then
		tecRatioFinal = 0.2;
	elseif tecRatio > 0.05 and tecRatio <= 0.06 then
		tecRatioFinal = 0.25;
	elseif tecRatio > 0.06 and tecRatio <= 0.08 then
		tecRatioFinal = 0.3;
	elseif tecRatio > 0.08 and tecRatio <= 0.1 then
		tecRatioFinal = 0.45;
	elseif tecRatio > 0.1 and tecRatio <= 0.15 then
		tecRatioFinal = 0.55;
	elseif tecRatio > 0.15 and tecRatio <= 0.2 then
		tecRatioFinal = 0.7;
	elseif tecRatio > 0.2 and tecRatio <= 0.3 then
		tecRatioFinal = 1;
	elseif tecRatio > 0.3 then
		tecRatioFinal = 3;				
	end;

	--triple and jump ratio
	local jmpRatio = jmp / totalNotes;
	local tripleRatio = trip / totalNotes;

	if jmpRatio > 0 and jmpRatio <= 0.0025 then
		jmpRatioFinal = 0.05;
	elseif jmpRatio > 0.0025 and jmpRatio <= 0.005 then
		jmpRatioFinal = 0.1;	
	elseif jmpRatio > 0.005 and jmpRatio <= 0.0075 then
		jmpRatioFinal = 0.15;	
	elseif jmpRatio > 0.01 and jmpRatio <= 0.04 then
		jmpRatioFinal = 0.2;	
	elseif jmpRatio > 0.04 and jmpRatio <= 0.06 then
		jmpRatioFinal = 0.35;
	elseif jmpRatio > 0.06 and jmpRatio <= 0.08 then
		jmpRatioFinal = 0.4;
	elseif jmpRatio > 0.08 and jmpRatio <= 0.1 then
		jmpRatioFinal = 0.5;
	elseif jmpRatio > 0.1 and jmpRatio <= 0.2 then
		jmpRatioFinal = 0.7;
	elseif jmpRatio > 0.2 and jmpRatio <= 0.3 then
		jmpRatioFinal = 1.5;	
	elseif jmpRatio > 0.3 and jmpRatio <= 0.4 then
		jmpRatioFinal = 2;		
	elseif jmpRatio > 0.4 then
		jmpRatioFinal = 3;
	end;

	if tripleRatio > 0 and tripleRatio <= 0.0025 then
		tripRatioFinal = 0;
	elseif tripleRatio > 0.0025 and tripleRatio <= 0.005 then
		tripRatioFinal = 0.1;	
	elseif tripleRatio > 0.005 and tripleRatio <= 0.01 then
		tripRatioFinal = 0.15;	
	elseif tripleRatio > 0.01 and tripleRatio <= 0.05 then
		tripRatioFinal = 0.3;
	elseif tripleRatio > 0.05 and tripleRatio <= 0.07 then
		tripRatioFinal = 0.55;
	elseif tripleRatio > 0.07 and tripleRatio <= 0.08 then
		tripRatioFinal = 0.65;		
	elseif tripleRatio > 0.08 and tripleRatio <= 0.09 then
		tripRatioFinal = 0.75;
	elseif tripleRatio > 0.09 and tripleRatio <= 0.1 then
		tripRatioFinal = 0.9;				
	elseif tripleRatio > 0.1 then
		tripRatioFinal = 1.2;
	end;	

	--intensidad.
	local raw_intensity = (totalNotes / songdurationseg) * (bpm / 130);
	local max_intensity = 20 ; -- 10 notas por segundo a 300 bpm es la intensidad maxima...
	local intensity_score = math.min(raw_intensity / max_intensity, 1)

	if bpm > 0 and bpm <= 60 then
		bpmRatio = 0;
	elseif bpm > 60 and bpm <= 80 then
		bpmRatio = 0.1;
	elseif bpm > 80 and bpm <= 120 then
		bpmRatio = 0.2;		
	elseif bpm > 120 and bpm <= 140 then
		bpmRatio = 0.25;
	elseif bpm > 140 and bpm <= 150 then
		bpmRatio = 0.3;		
	elseif bpm > 150 and bpm <= 160 then
		bpmRatio = 0.5;				
	elseif bpm > 160 and bpm <= 170 then
		bpmRatio = 0.7;				
	elseif bpm > 170 and bpm <= 190 then
		bpmRatio = 0.8;						
	elseif bpm > 190 and bpm <= 210 then
		bpmRatio = 0.9;
	elseif bpm > 210 then
		bpmRatio = 1;
	end;

	local tec_score = ((bpmRatio * bpmRatioW) + (intensity_score * intensityRatioW)+(tecRatioFinal * tecRatioW)+(jmpRatioFinal *jmpRatioW)+(tripRatioFinal*trplRatioW));

	if debugPrint then
		Trace("###############################");
		Trace("############ TEC ############");
		Trace("###bpmRatios ="..bpmRatio .. " Ratio:"..bpmRatio * bpmRatioW);
		Trace("###Intensity ="..intensity_score .. " Ratio:"..intensity_score * intensityRatioW);
		Trace("###tecRatio ="..tecRatioFinal .. " Ratio:"..tecRatioFinal * tecRatioW);
		Trace("###jmpRatio ="..jmpRatioFinal .. " Ratio:"..jmpRatioFinal * jmpRatioW);
		Trace("###TrplRatio ="..tripRatioFinal .. " Ratio:"..tripRatioFinal * trplRatioW);
		Trace("###############################");
		Trace("TEC SCORE: "..tec_score);
		Trace("###############################");
	end;

	return tec_score;


end;


function calculatePercentEffect(dataArray,totalBeatSongBySongDuration,nameDebug)
	local numBeatsLimitEffect = 1;

	local validEffectList = {};
	local beatAffected = 0;
	local percentBeatsAffected = 0;

	if #dataArray > 1 then
		for i=1,#dataArray do			
			if dataArray[i+1] then
				--Tiene uno siguiente revisamos si estamos en un efecto o no.
				--Consideremos que mas de 1 beats adelante no es un efecto, cualquier cosa entre 0 y 1 es parte de un efecto.
				--agregamos solo el bpm que no es parte de un efecto, el fin del mismo.
				local beatActual = dataArray[i][1];
				local beatSiguinte = dataArray[i+1][1];
				local difBeats = beatSiguinte - beatActual;
				--si hay mas de 1 beat de diferencia, lo consideramos "valido" y lo guardamos, si no, vamos al siguiente.
				if difBeats >= numBeatsLimitEffect then				
					--cortamos para un nuevo segmento de efectos.
					if #validEffectList == 0 then
						beatAffected = beatAffected+1;
						validEffectList = {};
					else
						local beatInit = validEffectList[1][1];
						local beatEnd = validEffectList[#validEffectList][1];
						local beatsAffected = beatEnd - beatInit;
						beatAffected = beatAffected + beatsAffected;
						validEffectList = {}; -- Reset
					end;
				else
					table.insert(validEffectList, {dataArray[i][1],dataArray[i][2]});	
				end;
			else
				if #validEffectList == 0 then
					beatAffected = beatAffected+1;
					validEffectList = {};
				else
					local beatInit = validEffectList[1][1];
					local beatEnd = validEffectList[#validEffectList][1];
					local beatsAffected = beatEnd - beatInit;
					beatAffected = beatAffected + beatsAffected;
					validEffectList = {}; -- Reset
				end;
			end;
		end;
	else
		beatAffected = beatAffected + 1;
	end;

	percentBeatsAffected = round2(beatAffected * 100 / totalBeatSongBySongDuration);

	--PLUS DIFFICULT
	--BPM: We need to check if the changes are to abrupt or too different from the base bpm
	--ex: bpm 130 60%, bpm 200 40%
	-- 40% of the song with 200 bpm it's a fucking huge jump on difficulty when 60% of the song is 130 bpm.


	--[[
	Trace("##########"..nameDebug.."############");
	Trace("Total Beats Song: "..round2(totalBeatSongBySongDuration).." :: Affected: "..beatAffected);
	Trace("% of Song Beats affected: "..percentBeatsAffected);
	Trace("##########################");
	]]


	return percentBeatsAffected;
end;

function checkBpmDifficult()

end;


function getGimmick(player,debugPrint)
	local graphLimit = 1.2;
	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(player);
	local tdatasong = steps:GetTimingData();
	
	--get last beat ... doesn't work properly :( it just return -1 or -2 on too much songs.
	local totalBeatsSong = song:GetLastBeat();

	--intentamos obtener los beats de otra manera
	local songduration = GAMESTATE:GetCurrentSong():MusicLengthSeconds();
	local totalBeatSongBySongDuration = tdatasong:GetBeatFromElapsedTime(songduration);


	--obtenemos todos los datos de efectos y cambios de bpm.

	local gimmickRatio = 0;
	local effectRatio = 0;

	local gimmickRatioW = 0.1;
	local effectRatioW = 0.9;

	--gimmick Calc
	--si tiene todos los tipos de gimmick esto seria 1.0 si no, vamos bajando
	local bpms_and_times = tdatasong:GetBPMsAndTimes(true);--2 
	local allScrolls = tdatasong:GetScrolls(true); --2
	local allDelays = tdatasong:GetDelays(true); --2
	local allSpeeds = tdatasong:GetSpeeds(true); --2	

	local allFakes = tdatasong:GetFakes(true); --0.5
	local allStops = tdatasong:GetStops(true);--1
	local allWarps = tdatasong:GetWarps(true);--0.5

	--ratio from only have present things.
	if #bpms_and_times > 1 then gimmickRatio = gimmickRatio + 0.2; end;
	if #allScrolls > 1 then gimmickRatio = gimmickRatio + 0.2; end;
	if #allDelays > 1 then gimmickRatio = gimmickRatio + 0.2; end;
	if #allSpeeds > 1 then gimmickRatio = gimmickRatio + 0.2; end;

	if #allFakes > 1 then gimmickRatio = gimmickRatio + 0.05; end;
	if #allStops > 1 then gimmickRatio = gimmickRatio + 0.1; end;
	if #allWarps > 1 then gimmickRatio = gimmickRatio + 0.05; end;

	--we'll use the higher % to make the graph, every other effect will be consider companions effect to
	--the prevalent effect.
	local percentageBeatsAffectedBpm = calculatePercentEffect(bpms_and_times,totalBeatSongBySongDuration,"bpm");
	local percentageBeatsAffectedScroll = calculatePercentEffect(allScrolls,totalBeatSongBySongDuration,"scroll");	
	local percentageBeatsAffectedDelays = calculatePercentEffect(allDelays,totalBeatSongBySongDuration,"delays");	
	local percentageBeatsAffectedSpeeds = calculatePercentEffect(allSpeeds,totalBeatSongBySongDuration,"speeds");
	local percentageBeatsAffectedFakes = calculatePercentEffect(allFakes,totalBeatSongBySongDuration,"fakes");
	local percentageBeatsAffectedStops = calculatePercentEffect(allStops,totalBeatSongBySongDuration,"stops");
	local percentageBeatsAffectedWarps = calculatePercentEffect(allWarps,totalBeatSongBySongDuration,"warps");

	--order by DESC
	local allDataPercent = {};
	table.insert(allDataPercent,round2(percentageBeatsAffectedBpm));
	table.insert(allDataPercent,round2(percentageBeatsAffectedScroll));
	table.insert(allDataPercent,round2(percentageBeatsAffectedDelays));
	table.insert(allDataPercent,round2(percentageBeatsAffectedSpeeds));
	table.insert(allDataPercent,round2(percentageBeatsAffectedFakes));
	table.insert(allDataPercent,round2(percentageBeatsAffectedStops));
	table.insert(allDataPercent,round2(percentageBeatsAffectedWarps));

	local function sortDesc(a,b)
		return a > b;
	end;
	table.sort(allDataPercent,sortDesc);
	if #allDataPercent > 0 then
		if allDataPercent[1] > 0 then
			effectRatio = allDataPercent[1] / 100;
		else
			effectRatio = 0.01;
		end;
	end;

	local effectFinalRatio = ( (gimmickRatio*gimmickRatioW) + ((effectRatio*effectRatioW)) );

	--if 60% or more, it's a full blast of things so we will be pushing that graph a little more, 
	local bonusDiff=0;
	if effectFinalRatio >= 0 and effectFinalRatio < 0.15 then bonusDiff = 0.05;
	elseif effectFinalRatio >= 0.15 and effectFinalRatio < 0.20 then bonusDiff = 0.15;
	elseif effectFinalRatio >= 0.20 and effectFinalRatio < 0.35 then bonusDiff = 0.2;
	elseif effectFinalRatio >= 0.35 and effectFinalRatio < 0.5 then bonusDiff = 0.4;
	elseif effectFinalRatio >= 0.5 and effectFinalRatio < 0.9 then bonusDiff = 0.5;
	elseif effectFinalRatio >= 0.9 then bonusDiff = 1; end;

	effectFinalRatio = round2(effectFinalRatio + bonusDiff);

	if debugPrint then
	Trace("##########################");
	Trace("GimmickBaseRatio:"..round2((gimmickRatio*gimmickRatioW)));	
	Trace("EffectBaseRatio:"..round2((effectRatio*effectRatioW)));	
	Trace("Bonus Difficulty:"..bonusDiff);	
	Trace("##########################");
	Trace("Effect Ratio Final:"..effectFinalRatio);
	end;
	
	return effectFinalRatio;

end;

function Triangulo(x, y, player)
	local size = 82;
	local angle_offset = math.pi / 2  -- vértice superior apuntando hacia arriba

	local paneCategories = {
        { Category = 'RadarCategory_TapsAndHolds', Text = "STP", Color = color("1,1,1,1") },
        { Category = 'RadarCategory_Holds',        Text = "HLD", Color = color("0.75,0.75,1,1") },
        { Category = 'RadarCategory_Mines',        Text = "MNS", Color = color("1,0.75,0.75,1") },
        { Category = 'RadarCategory_Jumps',        Text = "JMP", Color = color("1,1,0.75,1") },
        { Category = 'RadarCategory_Hands',        Text = "TPL", Color = color("0.75,1,1,1") },
        { Category = 'RadarCategory_Rolls',        Text = "RLL", Color = color("0.75,1,0.75,1") }
    }


	-- Convierte ángulo y escala en coordenadas
	local function polarToXY(scale, angle)
		local r = scale * size
		return {
			x + math.cos(angle) * r,
			y - math.sin(angle) * r,
			0
		}
	end

	local taps = 1;
	local jumps = 0;
	local tripl = 0;
	local songduration = 60;
	local bpm = 100;

	local speedResp = calcSpeed(taps,jumps,tripl,songduration,bpm,false);
	local tecResp = getTec(taps,jumps,tripl,songduration,bpm,false);

	local speed = 0.1;
	local tec = 0.1;
	local gimmick = 0.1;

	speed = 0.9;
	tec = 0.7;
	gimmick = 0;	

	if speed < 0.1 then speed = 0.1; end;
	if tec < 0.1 then tec = 0.1; end;

	-- Calcula las 3 puntas según su parámetro
	local v1 = polarToXY(speed, angle_offset)                     -- speed: punta arriba
	local v2 = polarToXY(tec, angle_offset + 2*math.pi/3)     -- gimmick: punta izquierda-abajo
	local v3 = polarToXY(gimmick, angle_offset + 4*math.pi/3)         -- tec: punta derecha-abajo


	return Def.ActorFrame {

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/GRAPH"))..{
					Name="baseChannel";
					InitCommand=cmd(xy,x+11,SCREEN_CENTER_Y-75;zoom,0.81;zoomy,0.73;visible,false);
					changeCommand=function(self)
						local steps = GAMESTATE:GetCurrentSteps(player)
						if not steps then 
							self:visible(false);
						else
							self:visible(true); 
						end
					end;	

					SongChosenMessageCommand=function(self)
						self:stoptweening();
						self:queuecommand("change");
					end;

					SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

		};

		Def.ActorMultiVertex {
			InitCommand = function(self)
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{ v1, {0, 1, 0, 0.7}, {0, 0} },  -- rojo para speed
					{ v2, {0, 1, 0, 0.7}, {0, 0} },  -- verde para tec
					{ v3, {0, 1, 0, 0.7}, {0, 0} },  -- azul para gimmick
				})
				self:SetNumVertices(3)
				self:visible(false);
			end;

			ChangeStepsMessageCommand=function(self,param)
				local topScreen = SCREENMAN:GetTopScreen();
				if topScreen:GetSelectionState() ~= "SelectingSong" then
					if param.Player == player then						
						self:queuecommand("change");
					end;
				end;
			end;
			StepsUnchosenMessageCommand=function(self,param)
				self:stoptweening();
				local topScreen = SCREENMAN:GetTopScreen();
				if topScreen:GetSelectionState() ~= "SelectingSong" then
					if param.Player == player then						
						self:queuecommand("change");
					end;
				end;
			end;
			SongChosenMessageCommand=function(self)
				self:stoptweening();
				self:queuecommand("change");
			end;

			SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

			changeCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				local steps = GAMESTATE:GetCurrentSteps(player)
				if not steps then 
					self:visible(false); 
				else
					self:visible(true); 
					self:stoptweening();
					--obtenemos todos los datos
					local radar = steps:GetRadarValues(player);

					local taps = radar:GetValue(paneCategories[1]["Category"]);
					local jumps = radar:GetValue(paneCategories[4]["Category"]);
					local tripl = radar:GetValue(paneCategories[5]["Category"]);
					local songduration = GAMESTATE:GetCurrentSong():MusicLengthSeconds();
					local bpm = ProcessBPMGraph(GAMESTATE:GetCurrentSong():GetCustomBPM());

					--[[
					Trace("#######SONG DATA#######");
					Trace("TAPS:"..taps);
					Trace("jumps:"..jumps);
					Trace("tripl:"..tripl);
					Trace("songduration:"..songduration);
					Trace("bpm:"..bpm);
					Trace("##############");
					]]

					local colorGreen = {0, 1, 0, 0.85};
					local colorRed={1, 0, 0, 0.85};
					local colorCeleste={0, 1, 1, 0.85};
					local colorAmarillo={1, 1, 0, 0.85};


					local speedData = calcSpeed(taps,jumps,tripl,songduration,bpm,false);
					local tecData = getTec(taps,jumps,tripl,songduration,bpm,false);
					local getGimmick = getGimmick(player,false);

					local speed = round2(speedData);
					if speed <= 0.1 then
						speed = 0.1;
					end;

					local tec = round2(tecData);
					if tec <= 0.1 then
						tec = 0.1;
					end;
					local gimmick =getGimmick;
					if gimmick <= 0.1 then
						gimmick = 0.1;
					end;

					local colorSpeed=colorCeleste;
					local colorTec=colorCeleste;
					local colorGimmick=colorCeleste;

					if speed < 0.45 then colorSpeed = colorCeleste; end;
					if tec < 0.45 then colorTec = colorCeleste; end;
					if gimmick < 0.3 then colorGimmick = colorCeleste; end;

					if speed >= 0.45 and speed < 0.7 then colorSpeed = colorAmarillo; end;
					if tec >= 0.45 and tec < 0.7 then colorTec = colorAmarillo; end;
					if gimmick >= 0.3 and gimmick < 0.5 then colorGimmick = colorAmarillo; end;					

					if speed >= 0.7 then colorSpeed = colorRed; end;
					if tec >= 0.7 then colorTec = colorRed; end;
					if gimmick >= 0.5 then colorGimmick = colorRed; end;

					local v1 = polarToXY(speed, angle_offset)                     -- speed: punta arriba
					local v2 = polarToXY(tec, angle_offset + 2*math.pi/3)     -- gimmick: punta izquierda-abajo
					local v3 = polarToXY(gimmick, angle_offset + 4*math.pi/3)         -- tec: punta derecha-abajo	
					self:linear(0.1);				
					self:SetVertices({
						{ v1, colorSpeed, {0, 0} },  -- rojo para speed
						{ v2, colorTec, {0, 0} },  -- verde para tec
						{ v3, colorGimmick, {0, 0} },  -- azul para gimmick
					});

				end
			end;			

		};
	};

end

t[#t+1] =  Triangulo(SCREEN_CENTER_X-450,SCREEN_CENTER_Y-60,PLAYER_1)..{
			CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:stoptweening();
				self:linear(0.05);
				self:diffusealpha(0);
			end;			
		end;
		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(1);
			end;
		end;
};

t[#t+1] =  Triangulo(SCREEN_CENTER_X+450,SCREEN_CENTER_Y-60,PLAYER_2)..{
			CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:stoptweening();
				self:linear(0.05);
				self:diffusealpha(0);
			end;
		
		end;
		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(1);
			end;
		end;
};



return t;
