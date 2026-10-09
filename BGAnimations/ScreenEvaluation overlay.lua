local vStats = STATSMAN:GetCurStageStats();
local iGrade = 8;
local iGradeAnnouncer = 0;
local pnStats1 = vStats:GetPlayerStageStats( PLAYER_1 );
local pnStats2 = vStats:GetPlayerStageStats( PLAYER_2 );
local extraJudgment = GAMESTATE:GetExtraJudgment();

local xTnsPlace = -30;
local yTnsPlace = -28;
local zoomTnsPlace = 1.05;


--### TIMING ADDON ###---
local timingP1={};
local timingP2={};

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	if GAMESTATE:Env()["timingP1"] ~= nil then
		timingP1 = GAMESTATE:Env()["timingP1"];
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	if GAMESTATE:Env()["timingP2"] ~= nil then
		timingP2 = GAMESTATE:Env()["timingP2"];
	end;
end;

--### VS ###
function pushVsItem(gameList, newGame, maxSize)
    table.insert(gameList, newGame)
    if #gameList > maxSize then
        table.remove(gameList, 1) -- elimina el primero
    end
end

function setVsCount(scorep1,scorep2)

	--we add the data of this gameplay, we will only have 5 at maximum, so we delete the last one if there is more xD
	local songName = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
	--local getFolderSong = GAMESTATE:GetChannelName();
	local CurrentStepP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
	local CurrentStepP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
	local meterP1 = CurrentStepP1:GetMeter();	
	local meterP2 = CurrentStepP2:GetMeter();	
	local failedP1=false;
	local failedP2=false;
	local winP1=false;
	local winP2=false;
	local drawGame=false;

	local statsp1 = STATSMAN:GetCurStageStats():GetPlayerStageStats( PLAYER_1 );
	local statsp2 = STATSMAN:GetCurStageStats():GetPlayerStageStats( PLAYER_2 );
	failedP1 = statsp1:GetFailedAux();
	failedP2 = statsp2:GetFailedAux();


	local actualCountP1 = 0;
	local actualCountP2 = 0;

	if GAMESTATE:Env()["p1vsCount"] == nil and GAMESTATE:Env()["p2vsCount"] == nil then		
		GAMESTATE:Env()["p1vsCount"] = 0;
		GAMESTATE:Env()["p2vsCount"] = 0;
	else
		actualCountP1 = GAMESTATE:Env()["p1vsCount"];
		actualCountP2 = GAMESTATE:Env()["p2vsCount"];
	end;

	if scorep1 > scorep2 then
		actualCountP1 = actualCountP1 + 1;
		winP1=true;
	elseif scorep2 > scorep1 then
		actualCountP2 = actualCountP2 + 1;
		winP2=true;
	elseif scorep2 == scorep1 then
		drawGame=true;
	end;

	GAMESTATE:Env()["p1vsCount"] = actualCountP1;
	GAMESTATE:Env()["p2vsCount"] = actualCountP2;

	--we add this gameplay.
	local gameDetails = { 
		song=songName,
		levelp1=meterP1,
		levelp2=meterP2,
		failedP1=failedP1,
		failedP2=failedP2,
		winP1=winP1,
		winP2=winP2,
		draw=drawGame,
		scoreP1=scorep1,
		scoreP2=scorep2
	};

	pushVsItem(GAMESTATE:Env()["vsModeHistory"],gameDetails,6);


end;

--### FIN VS ###

iGrade = TierToState(vStats:GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetGrade()) ;
iGradeAnnouncer = gradeTransformAnnouncer(vStats:GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetPhoenixScore());

local bFailedAux = false;

if GAMESTATE:GetNumPlayersEnabled() > 1 then
	if pnStats2:GetPhoenixScore() > pnStats1:GetPhoenixScore() then
		iGrade = TierToState(pnStats2:GetGrade());
		iGradeAnnouncer =  gradeTransformAnnouncer(pnStats2:GetPhoenixScore());
		if (pnStats2:GetFailedAux()) then bFailedAux = true; end;
	else
		iGrade = TierToState(pnStats1:GetGrade());
		iGradeAnnouncer =  gradeTransformAnnouncer(pnStats1:GetPhoenixScore());
		if (pnStats1:GetFailedAux()) then bFailedAux = true; end;
	end;
else
	bFailedAux = vStats:GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetFailedAux();
end;

local DelayGradeShow = 3.1;
local WaitUntilDrum = 1.1;
local DelayNewRecord = 8.55;
local DelayDrum = 0.08;
local DrumGonnaEnd = false;
local LenFinal = "000";
local function GetCustomY(object)
	local sMach = GetMachineName();
	-- 1 : white belt
	-- 0 : black belt
	if sMach ~= "UNKNOWN" then
		if object == 1 then
			return -218;
		else
			return -190;
		end;
	else
		
		if object == 1 then
			return -218;
		else
			return -190;
		end;
	end;
end;

local function EvalRollingNumbers(text, del_text, xlim, ylim, horiza, final, highscore)
	local r = Def.ActorFrame {};
	local dir;
	if (horiza=='HorizAlign_Left') then dir = 1; else dir = -1; end;
	
	if final then
		if #LenFinal < #text then
			LenFinal = text;
		end;
	end;
	
	local cur={};
	local xx= 17;
	
	if (highscore) then xx = 13 end; 

	for i=1,#text do
		cur[i]=0;
		r[#r+1] = Def.RollingNumbers {
			File = THEME:GetPathF("","xolonium 20px");
			OnCommand=cmd(Load,"RollingNumbers";horizalign,horiza;settext,"";sleep,WaitUntilDrum;x,xlim+dir*(i-1)*xx;y,ylim;zoom,1.2;diffusealpha,1;sleep,del_text+(i-1)*(.2);queuecommand,'Lot');
			LotCommand=function(self)
			
				if (highscore) then
					self:diffuse(color("#33fafe"));
					self:zoom(1);
				end;
				
				self:sleep(0.03);
				self:settext(math.random(0,9));
				cur[i]=cur[i]+1;
				if cur[i] < 10 then
					self:queuecommand("Lot");
				else
					if dir == -1 then
						self:settext(string.sub(text,#text-(i-1),#text-(i-1)));
					else
						self:settext(string.sub(text,i,i));
					end;
					
					if final and i == #LenFinal then
						DrumGonnaEnd = true;
					end;
					
				end;
			end;
		};
	end;
	return r;
end;

local function Drum(wait,delay)
	local r = Def.ActorFrame {};
	
	local bOffScreen = false;
	
	for i=0,15 do
		r[#r+1] = Def.Sound {
			OnCommand=cmd(sleep,wait + (delay*i);queuecommand,'Lot');
			LotCommand=function(self)
				if not bOffScreen then
					if not DrumGonnaEnd then
						SOUND:PlayOnce(THEME:GetPathS("","EVAL_DRUM")); 
						self:sleep(delay);
					end;
				end;
			end;
			OffCommand=function(self)
				bOffScreen = true;
			end;
		};
	end;
	return r;
end;

--arka
function DrawRollingScoreNew( x, y, score, horizalign, delay,font )
local score_s = string.format("%01d",score);
local digits = {};
local len = string.len(score_s);
local extra="";

if len == 6 then
	extra = "?";
elseif len == 5 then
	extra = "??";
elseif len == 4 then
	extra = "???";
elseif len == 3 then
	extra = "????";
elseif len == 2 then
	extra = "?????";
elseif len == 1 then
	extra = "??????";		
elseif len == 0 then
	extra = "???????";	
end;


for i=1,len do
	digits[#digits+1]=string.sub(score_s,i,i);
end;

local cur_text = "";
local cur_text_digits = "";
local cur_digit = 1;
local cur_loop_digit = 0;

return LoadFont(font)..{
	OnCommand=function(self)
		self:x(x);
		self:y(y);
		self:horizalign(horizalign);
		self:sleep(delay);
		self:queuecommand('Update');
	end;
	UpdateCommand=function(self)
		
		if( cur_loop_digit == 5 ) then
			cur_loop_digit = 0;
			cur_text_digits = cur_text_digits..digits[cur_digit];
			cur_digit = cur_digit + 1;
			
			if( cur_digit > #digits ) then
				self:settext(extra..""..cur_text_digits);
				return;
			end;
		end;

		
		cur_text = cur_text_digits..tostring(cur_loop_digit*2+1);

		local cur_text_tamanho = string.len(score_s);
		if cur_text_tamanho == 6 then
			cur_text = "?"..cur_text;
		elseif cur_text_tamanho == 5 then
			cur_text = "??"..cur_text;
		elseif cur_text_tamanho == 4 then
			cur_text = "???"..cur_text;
		elseif cur_text_tamanho == 3 then
			cur_text = "????"..cur_text;
		elseif cur_text_tamanho == 2 then
			cur_text = "?????"..cur_text;
		elseif cur_text_tamanho == 1 then
			cur_text = "??????"..cur_text;
		elseif cur_text_tamanho == 0 then
			cur_text = "????????"..cur_text;
		end;

		self:settext(cur_text);
		cur_loop_digit = cur_loop_digit +1;
		
		self:sleep(.03);
		self:queuecommand('Update');
	end;
	OffCommand=cmd(stoptweening;visible,false);
}
end;


local tStatsGlobal ={};


--GoodTierFix JNC
local bTier = 0;
local numberTier={7,7};

local norecord = false;
local rush = false;
local machine = false;
local bOffScreen = false;


local yStatPos = 120;
local xStatPos = 370;
local xRollPos = 180;

local SnapDistance = 35;
local bBrokenGrade = {false, false};


-- Una vrgaaaaaaaaa
local function GetHighScoreDifference(PLAYERNUM)

	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(PLAYERNUM);			
	local scorelist;
	
	
	if song and steps then
		scorelist = PROFILEMAN:GetProfile(PLAYERNUM):GetHighScoreList(song,steps);
		assert(scorelist)
		local scores = scorelist:GetHighScores();
		
		local low;
		
		if (scores[1] == nil ) then return 0 end;
		
		local high = scores[1]:GetPhoenixScore();

		if ( scores[2] == nil) then 
			low = 0;
		else
			low = scores[2]:GetPhoenixScore();
		end;

		local result = high - low;
		
		if (result > 0) then return result; end;
		
	end;
	
	return 0;
end;

function getFirstRecordPlayer(player)
	local returnArray = {score=0,isNewRecord=false};
	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(player);
	if steps == nil then
		return returnArray;
	end;

	scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(song,steps);
	if scorelist == nil then
		return returnArray;
	end;

	local scores = scorelist:GetHighScores();
	if #scores > 0 then
		returnArray["score"] = scores[1]:GetPhoenixScore();
		return returnArray;
	else
		return returnArray;
	end;
end;

--Si existio un newscore, esto deberia obtener si subio o bajo el stat desde el record anterior
--con esto podemos ponerle la flechita al lado del stat :) arka
local function getDifferenceBetweenRecordStats(PLAYER)
	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(PLAYER);			
	local scorelist;

	local statusTns = {
		MPerfect = -1,
		Perfect = -1,
		Great = -1,
		Good = -1,
		Bad = -1,
		Miss = -1,
		Combo = -1,
	};	
	
	local paraUnFuturo=false;
	if paraUnFuturo then
		return statusTns;
	end;

	if song and steps then

		-- -1 off 0 upg 1 upr 2 downg 3 downr
		scorelist = PROFILEMAN:GetProfile(PLAYER):GetHighScoreList(song,steps);
		assert(scorelist)
		local scores = scorelist:GetHighScores();		
		local extraJudgmentSetted = GAMESTATE:GetExtraJudgment();
		local statPlayer = vStats:GetPlayerStageStats(PLAYER);

		if #scores == 1 then
			--here we want the actual gameplay rather the hs because it's the highscore lol


			local plStats = {
				Perfect 	= statPlayer:GetTapNoteScores("TapNoteScore_W1") +
							  statPlayer:GetTapNoteScores("TapNoteScore_W2") +
							  statPlayer:GetTapNoteScores("TapNoteScore_CheckpointHit");		
				Great		= statPlayer:GetTapNoteScores('TapNoteScore_W3');
				Good		= statPlayer:GetTapNoteScores('TapNoteScore_W4');
				Bad			= statPlayer:GetTapNoteScores('TapNoteScore_W5');
				Miss		= statPlayer:GetTapNoteScores("TapNoteScore_Miss") +
							  statPlayer:GetTapNoteScores("TapNoteScore_CheckpointMiss");
				MaxCombo 	= statPlayer:MaxCombo();
				Score		= statPlayer:GetPhoenixScore();
			};

			local plStatsExtraJudg = {
				MPerfectExtraJudg = statPlayer:GetTapNoteScores("TapNoteScore_W1") + statPlayer:GetTapNoteScores("TapNoteScore_CheckpointHit"); --1
				PerfectExtraJudg = statPlayer:GetTapNoteScores("TapNoteScore_W2"); --2
			};



			local Hs = scores[1];

			--revisamos que cambiaron de 0. 
			local mperf = 0;
			local perf = 0;
			local gr = plStats["Great"];
			local gd = plStats["Good"];
			local bd = plStats["Bad"];
			local miss = plStats["Miss"];
			local combo = plStats["MaxCombo"];
			local score = plStats["Score"];

			if extraJudgmentSetted then
				mperf= plStatsExtraJudg["MPerfectExtraJudg"];
				perf = plStatsExtraJudg["PerfectExtraJudg"];		
			else
				perf = plStats["Perfect"];
			end;

			if mperf > 0 then
				statusTns["MPerfect"] = 0;
			end;
			if perf > 0 then
				statusTns["Perfect"] = 0;
			end;			
			if gr > 0 then
				statusTns["Great"] = 1;
			end;						
			if gd > 0 then
				statusTns["Good"] = 1;
			end;	
			if bd > 0 then
				statusTns["Bad"] = 1;
			end;
			if miss > 0 then
				statusTns["Miss"] = 1;
			end;
			if combo > 0 then
				statusTns["Combo"] = 0;
			end;	

			return statusTns;
		end;


		if #scores >= 2 then
			if statPlayer:GetPhoenixScore() ~= scores[1] then
				return statusTns;
			end;
			local Hs = scores[1];
			local PreHs = scores[2];			
			--trabajamos los records los records.

			local hsDataNew = {
				mperf = Hs:GetTapNoteScore("TapNoteScore_W1") + Hs:GetTapNoteScore("TapNoteScore_CheckpointHit");
				perf = Hs:GetTapNoteScore("TapNoteScore_W2");
				great = Hs:GetTapNoteScore("TapNoteScore_W3");
				good = Hs:GetTapNoteScore("TapNoteScore_W4");
				bad = Hs:GetTapNoteScore("TapNoteScore_W5");
				miss = Hs:GetTapNoteScore("TapNoteScore_Miss") + Hs:GetTapNoteScore("TapNoteScore_CheckpointMiss");
				combo = Hs:GetMaxCombo();
			}

			local hsDataOld = {
				mperf = PreHs:GetTapNoteScore("TapNoteScore_W1") + Hs:GetTapNoteScore("TapNoteScore_CheckpointHit");
				perf = PreHs:GetTapNoteScore("TapNoteScore_W2");
				great = PreHs:GetTapNoteScore("TapNoteScore_W3");
				good = PreHs:GetTapNoteScore("TapNoteScore_W4");
				bad = PreHs:GetTapNoteScore("TapNoteScore_W5");
				miss = PreHs:GetTapNoteScore("TapNoteScore_Miss") + Hs:GetTapNoteScore("TapNoteScore_CheckpointMiss");
				combo = PreHs:GetMaxCombo();
			}

			if extraJudgmentSetted then
				if hsDataNew["mperf"] > hsDataOld["mperf"] then
					statusTns["MPerfect"] = 0;
				end;
				if hsDataNew["mperf"] < hsDataOld["mperf"] then
					statusTns["MPerfect"] = 3;
				end;

				if hsDataNew["perf"] > hsDataOld["perf"] then
					statusTns["Perfect"] = 0;
				end;
				if hsDataNew["perf"] < hsDataOld["perf"] then
					statusTns["Perfect"] = 3;
				end;
			else
				local pfnoextraNew = hsDataNew["mperf"] + hsDataNew["perf"];
				local pfnoextraOld = hsDataOld["mperf"] + hsDataOld["perf"];

				if pfnoextraNew > pfnoextraOld then
					statusTns["Perfect"] = 0;
				end;

				if pfnoextraNew < pfnoextraOld then
					statusTns["Perfect"] = 3;
				end;
			end;

			if hsDataNew["great"] > hsDataOld["great"] then
				statusTns["Great"] = 1;
			end;			

			if hsDataNew["great"] < hsDataOld["great"] then
				statusTns["Great"] = 2;
			end;						


			if hsDataNew["good"] > hsDataOld["good"] then
				statusTns["Good"] = 1;
			end;			

			if hsDataNew["good"] < hsDataOld["good"] then
				statusTns["Good"] = 2;
			end;	

			if hsDataNew["bad"] > hsDataOld["bad"] then
				statusTns["Bad"] = 1;
			end;			

			if hsDataNew["bad"] < hsDataOld["bad"] then
				statusTns["Bad"] = 2;
			end;		

			if hsDataNew["miss"] > hsDataOld["miss"] then
				statusTns["Miss"] = 1;
			end;			

			if hsDataNew["miss"] < hsDataOld["miss"] then
				statusTns["Miss"] = 2;
			end;	

			if hsDataNew["combo"] > hsDataOld["combo"] then
				statusTns["Combo"] = 0;
			end;
			if hsDataNew["combo"] < hsDataOld["combo"] then
				statusTns["Combo"] = 3;
			end;	

			return statusTns;
		end;

	end;

end;

local function CreateStats( pnPlayer )
	-- Actor Templates
	local aLabel = LoadFont("Common Normal") .. { InitCommand=cmd(shadowlength,1;horizalign,left); };
	local aText = LoadFont("Common Normal") .. { InitCommand=cmd(shadowlength,1;horizalign,left); };
	-- DA STATS, JIM!!
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );


	local bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
	local songartist = GAMESTATE:GetCurrentSong():GetDisplayArtist();
	--local getFolderSong = GAMESTATE:GetChannelName();
	local getFolderSong = GAMESTATE:GetCurrentSong():GetGroupName();
	local MusicLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() or 0;
	local durationSong = MusicLength > 0 and SecondsToMMSS(MusicLength) or "";

	if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
		local dataTrain = getTrainProgresiveInfoLess();
		if dataTrain.bpm == nil then
			bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
		else
			bpmActual = "BPM " .. ProcessBPM(dataTrain.bpm);	
		end;
		
		songartist = "V.A";
		durationSong = dataTrain.duration > 0 and SecondsToMMSS(dataTrain.duration) or "";
	end;

	local ftext = songartist .."  •  "..bpmActual.."  •  "..durationSong;


	-- Organized Stats.
	tStatsGlobal = {		
		Title		 = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
		fulltextData = ftext;
		folder = getFolderSong;
	};	
	
	local tStats = {
		Perfect 	= pnStageStats:GetTapNoteScores("TapNoteScore_W1") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_W2") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointHit");		
		Great		= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		Good		= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		Bad			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores("TapNoteScore_Miss") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
		MaxCombo 	= pnStageStats:MaxCombo();
		Score		= pnStageStats:GetPhoenixScore();
		LegacyScore = pnStageStats:GetOldScore();
		Kcal		= pnStageStats:GetCaloriesBurned();
		Grade		= pnStageStats:GetGrade();
		
		MyBest;
		MachineBest={};		
		Failed		= pnStageStats:GetFailedAux();
	};

	local tStatsExtraJudg = {
		MPerfectExtraJudg = pnStageStats:GetTapNoteScores("TapNoteScore_W1") + pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointHit"); --1
		PerfectExtraJudg = pnStageStats:GetTapNoteScores("TapNoteScore_W2"); --2
	};

	if GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
		tStats["Kcal"] = STATSMAN:GetAccumPlayedStageStats():GetPlayerStageStats(pnPlayer):GetCaloriesBurned();
	end;
	-- Coop Calories - Coop Fatigue
	--local cals    = pnStageStats:GetCaloriesBurnedCoop()   -- {p1, p2, etc }
	--local fatigue = pnStageStats:GetFatigueCoop()          -- {p1, p2, etc }
	--
	--for i = 1, #cals do
	--	Trace( ("Jugador %d: %.1f kcal, fatiga %.2f"):format(i, cals[i], fatigue[i]) )
	--end


	--Generamos la letra nueva
	local scorePlayer = pnStageStats:GetPhoenixScore();
	local stateLetterSprite = gradeTransformState(scorePlayer);

    --obtenemos el ClearStatus
    local clearStatus = -1;

    --RG
    if tStats["Miss"] > 20 then
    	clearStatus = 7;
    end; 

    --FG
    if tStats["Miss"] <= 20 then
    	clearStatus = 6;
    end; 

    --TG
    if tStats["Miss"] <= 10 then
    	clearStatus = 5;
    end;    

    --MG
    if tStats["Miss"] <= 5 then
    	clearStatus = 4;
    end;

    --ap
    if tStats["Perfect"] > 0 and tStats["Great"] == 0 and tStats["Good"] == 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
    	clearStatus = 0;
    end;

    --UG
    if tStats["Perfect"] > 0 and tStats["Great"] > 0 and tStats["Good"] == 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
    	clearStatus = 1;
    end;

    --EG
    if tStats["Perfect"] > 0 and tStats["Great"] > 0 and tStats["Good"] > 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
    	clearStatus = 2;
    end;

    --superb
    if tStats["Perfect"] > 0 and tStats["Great"] > 0 and tStats["Good"] > 0 and tStats["Bad"] > 0 and tStats["Miss"] == 0 then
    	clearStatus = 3;
    end;




	local besto;
	if (numberTier[2] <= numberTier[1]) then
		besto = PLAYER_2;
	else
		besto = PLAYER_1;
	end;
	bTier = TierToState(tStats["Grade"]);
	
	-- Organized Equation Values
	local tValues = {
		CURRENT	= ( tStats["Perfect"]*10 + tStats["Great"]*5 + tStats["Good"]*1 + tStats["Bad"]*-2 + tStats["Miss"]*-5), 
		MAX		= ( tStats["Perfect"] + tStats["Great"] + tStats["Good"] + tStats["Bad"] + tStats["Miss"] )*10,
	};
	
	
	local scorelist = PROFILEMAN:GetProfile(pnPlayer):GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pnPlayer));
	assert(scorelist)
	local topscore = scorelist:GetHighScores()[1];
	
	-- Si hay rush o perfil maquina gano
	if (GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate() ~= 1 and GAMESTATE:GetGameMode() ~= 'Rank') then
		rush = true
	end;
	if not PROFILEMAN:IsPersistentProfile(besto) then
		machine = true;
	end;
	if machine or rush or tStats["Score"] == 0 or tStats["Failed"] then	-- xx failed aux means no new record 
		norecord = true;
	end;
	--


	if topscore and topscore:GetPhoenixScore() > 0 then
		tStats["MyBest"]= topscore:GetPhoenixScore();
	else
		tStats["MyBest"]= 0;
	end

	
	
	local scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pnPlayer));
	assert(scorelist)
	local topscore = scorelist:GetHighScores()[1];
	if topscore then
		tStats["MachineBest"].Score = topscore:GetPhoenixScore();
	else
		tStats["MachineBest"].Name = "";
		tStats["MachineBest"].Score = 0;
	end;
			
	tValues["CURRENT"] = (100*tValues["CURRENT"])/tValues["MAX"];
	if tValues["CURRENT"] <= 0 then
		tValues["CURRENT"] = 0;
	end;
	tValues["MAX"] = 100;	
	
	-- Fix Calories in COOP MODE
	if GAMESTATE:GetCurrentSteps(pnPlayer):GetPlayers() >= 2 then
		tStats["Kcal"]= 0;
	end;
	
	
	local statsAux={};
	statsAux[1] ="Perfect";
	statsAux[2] ="Great";
	statsAux[3] ="Good";
	statsAux[4] ="Bad";
	statsAux[5] ="Miss";
	statsAux[6] ="MaxCombo";
	statsAux[7] ="Score";
	statsAux[8] ="Kcal";
	tStats["Kcal"] = round(tStats["Kcal"], 1)
	
	local statsAuxExtraJudg = {};
	statsAuxExtraJudg[1] = "MPerfectExtraJudg";
	statsAuxExtraJudg[2] = "PerfectExtraJudg";	
	
	local xSide;
	local xAlign;
	local hsAlign;
	local xAuxX;
	if pnPlayer == PLAYER_1 then
		xSide = -1;
		xAlign = 'HorizAlign_Left';
		hsAlign = 'HorizAlign_Right';
		xAuxX=6;
	end;
	if pnPlayer == PLAYER_2 then
		xSide = 1;
		xAlign = 'HorizAlign_Right';
		hsAlign = 'HorizAlign_Left';
		xAuxX=2;
	end;
	
	local t = Def.ActorFrame {};

	
	local evaluationSkinData = GetEvaluationSkinDataFromPlayer(pnPlayer);
	local gradeLetterFunc = LoadActor(evaluationSkinData["grade_lua"]);
	t[#t+1] = gradeLetterFunc(evaluationSkinData["path_skin"],pnPlayer,stateLetterSprite,tStats,tStatsExtraJudg);


	--[[

	if tStats["Failed"] then
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			OnCommand=cmd(Center;addx,375*xSide;addy,0;animate,false;setstate,stateLetterSprite;zoom,1.2;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.95;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	else
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			OnCommand=cmd(Center;addx,375*xSide;addy,0;animate,false;setstate,stateLetterSprite;zoom,1.4;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.85);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			OnCommand=cmd(Center;addx,375*xSide;addy,0;animate,false;setstate,stateLetterSprite;zoom,0.4325;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.2;diffusealpha,1;zoom,0.95;linear,0.4;zoom,1.8;diffusealpha,0;blend,Blend.Add);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/ac_play"))..{
			OnCommand=cmd(Center;addx,375*xSide;addy,110;animate,false;setstate,clearStatus;zoom,1.4;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.65);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};		
	end;
	]]

	--we build the score box (refactoring my shitty code)
	local posP1ScoreFrameBase=SCREEN_CENTER_X-366; --p1
	local posP2ScoreFrameBase=SCREEN_CENTER_X+372; --p2
	local posScoreFrameBase=SCREEN_CENTER_Y-150;
	local posScoreZoomBase=0.9;
	t[#t+1] = Def.ActorFrame {

		OnCommand=function(self)
			if xSide > 0 then
				self:x(posP2ScoreFrameBase);
			else
				self:x(posP1ScoreFrameBase);
			end;
			
			self:y(posScoreFrameBase);


			if SCREENMAN:GetTopScreen():IsNewRecordPersonal(pnPlayer) then
				local ScoreDiff = GetHighScoreDifference(pnPlayer);
				self:GetChild("nRecord"):settext( "+"..ScoreDiff );
				self:visible(true);
			else
				if GAMESTATE:IsHumanPlayer(pnPlayer) then
					self:GetChild("nRecord"):settext( "");					
				end;
			end;

			self:zoom(posScoreZoomBase);

			-- we check for fullcombo
			local tnsgreat = pnStageStats:GetTapNoteScores('TapNoteScore_W3');
			local tnsgood = pnStageStats:GetTapNoteScores('TapNoteScore_W4');
			local tnsbadmiss 	= pnStageStats:GetTapNoteScores('TapNoteScore_W5') +
						  pnStageStats:GetTapNoteScores("TapNoteScore_Miss") +
						  pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointMiss");

			
		    if tnsbadmiss == 0 and tnsgood > 0  and pnStageStats:GetPhoenixScore() <= 999999 then
				self:GetChild("nmPlayerBg"):queuecommand("Ani");
				self:GetChild("nmPlayerBgGlow"):queuecommand("Ani");
		    elseif tnsbadmiss == 0 and tnsgood == 0  and pnStageStats:GetPhoenixScore() <= 999999 then
				self:GetChild("fcPlayerBg"):queuecommand("Ani");
				self:GetChild("fcPlayerBgGlow"):queuecommand("Ani");
			elseif pnStageStats:GetPhoenixScore() > 999999 and tnsgreat == 0 and tnsgood == 0 and tnsbadmiss == 0 then
				self:GetChild("PfcPlayerBg"):queuecommand("Ani");
				self:GetChild("PfcPlayerBgGlow"):queuecommand("Ani");
				self:GetChild("starPFCAni"):visible(true);
			end;
		end;

		FinalizedMessageCommand=cmd(finishtweening;visible,false);

		LoadActor(THEME:GetPathG("","ScreenEvaluation/score_bg"))..{
			Name="scoreBg";
			OnCommand=cmd(zoom,0.65;zoomx,0.6;zoomy,0.625;diffusealpha,0.4);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};



		LoadActor(THEME:GetPathG("","ScreenEvaluation/texto-score"))..{
			Name="ScorePlayerBg";
			OnCommand=cmd(zoom,0.35;diffusealpha,1;y,-36);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		DrawRollingScoreNew(0, -12, pnStageStats:GetPhoenixScore(), 'HorizAlign_Center', 1 ,"scorebg")..{
			Name="RollScoreNumber";
			OnCommand=function(self)
				self:zoom(1.1);
			end;
		};

		LoadFont("MenuTimer numbers")..{	
			Name="percentageBg";
			OnCommand=cmd(diffusealpha,1;y,21;x,146;settext,string.format("%.2f%%", pnStageStats:GetPercentScore());zoom,0.33;horizalign,"right");
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("xolonium 20px")..{
				Name="nRecord";	
				OnCommand=cmd(zoom,0.8;y,32;x,-136;horizalign,left;shadowlength,1;shadowcolor,color("#191919");diffuse,color("#00fc1e");sleep,0;visible,GAMESTATE:IsHumanPlayer(pnPlayer);horizalign,"left");
				SetCommand=function(self)

					if SCREENMAN:GetTopScreen():IsNewRecordPersonal(pnPlayer) then
						local ScoreDiff = GetHighScoreDifference(pnPlayer);
						self:settext( "+"..ScoreDiff );
						self:visible(true);
					else
						if GAMESTATE:IsHumanPlayer(pnPlayer) then
								self:settext( "" );
						end;
					end;
					
				end;
				FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
			};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/pfg"))..{
			Name="PfcPlayerBg";
			OnCommand=cmd(zoom,0.8;cropright,1;diffusealpha,1;y,40);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/pfg"))..{
			Name="PfcPlayerBgGlow";
			OnCommand=cmd(zoom,0.8;diffusealpha,0;y,40;blend,"BlendMode_Add");
			AniCommand=function(self)
				self:sleep(0.5);
				self:diffusealpha(0.6);
				self:linear(0.1);
				self:diffusealpha(0);
				self:zoom(1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullcombo"))..{
			Name="fcPlayerBg";
			OnCommand=cmd(zoom,0.8;cropright,1;diffusealpha,1;y,40);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullcombo"))..{
			Name="fcPlayerBgGlow";
			OnCommand=cmd(zoom,0.8;diffusealpha,0;y,40;blend,"BlendMode_Add");
			AniCommand=function(self)
				self:sleep(0.5);
				self:diffusealpha(0.6);
				self:linear(0.1);
				self:diffusealpha(0);
				self:zoom(1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/nomiss"))..{
			Name="nmPlayerBg";
			OnCommand=cmd(zoom,0.8;cropright,1;diffusealpha,1;y,40);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/nomiss"))..{
			Name="nmPlayerBgGlow";
			OnCommand=cmd(zoom,0.8;diffusealpha,0;y,40;blend,"BlendMode_Add");
			AniCommand=function(self)
				self:sleep(0.5);
				self:diffusealpha(0.6);
				self:linear(0.1);
				self:diffusealpha(0);
				self:zoom(1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		generarEstrellaBoom(0.5,20,0,35,"default")..{
			Name="starPFCAni";
			InitCommand=function(self)	
				self:zoom(0.65);
				self:visible(false);
			end;
		};

	};


	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)

			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
				return;
			end;

			self:visible(false);
			if xSide < 0 then
				self:x(SCREEN_CENTER_X-110);					
			else
				self:x(SCREEN_CENTER_X+110);
			end;
			self:y(SCREEN_CENTER_Y+183);
			
			self:GetChild("fastjudg"):settext("0");
			self:GetChild("slowjudg"):settext("0");
			local extraJudgment = GAMESTATE:GetExtraJudgment();
			self:visible(true);					
			if pnPlayer == PLAYER_1 then
				self:GetChild("fastjudg"):settext(GAMESTATE:Env()["fastp1"]);
				self:GetChild("slowjudg"):settext(GAMESTATE:Env()["slowp1"]);
			end;

			if pnPlayer == PLAYER_2 then
				self:GetChild("fastjudg"):settext(GAMESTATE:Env()["fastp2"]);
				self:GetChild("slowjudg"):settext(GAMESTATE:Env()["slowp2"]);
			end;

		end;

		LoadActor(THEME:GetPathG("","ScreenEvaluation/fastslow"))..{
			OnCommand=cmd(zoom,0.7;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		

		LoadFont("smallscore")..{
					OnCommand=cmd(zoom,0.7;y,-12;shadowlength,1;shadowcolor,color("#191919");horizalign,"left");
					Name = "fastjudg";
					FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
		};		

		LoadFont("smallscore")..{
					OnCommand=cmd(zoom,0.7;y,9;shadowlength,1;shadowcolor,color("#191919");horizalign,"left");
					Name = "slowjudg";
					FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
		};	
		
	}

	--KCAL
	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)
				
				if xSide < 0 then
					self:x(SCREEN_CENTER_X-110);					
				else
					self:x(SCREEN_CENTER_X+110);
				end;


				if GAMESTATE:GetGameMode() == 'Basic' then					
					self:y(SCREEN_CENTER_Y+183);
				else
					self:y(SCREEN_CENTER_Y+230);
				end;

				self:visible(true);
				
				if GAMESTATE:GetNumSidesJoined() == 2 and checkVsMode() then
					self:visible(false);
				else
					self:GetChild("kcalText"):settext(tStats["Kcal"]);
					self:visible(true);	
					self:GetChild("kcalText"):zoom(0.8):linear(0.05):diffusealpha(1):zoom(0.76);
				end;
		end;

		LoadActor(THEME:GetPathG("","ScreenEvaluation/kcal"))..{
			OnCommand=cmd(zoom,0.67;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.15;diffusealpha,0);
		};
		

		LoadFont("smallscore")..{
					OnCommand=cmd(diffusealpha,1;zoom,0.76;y,6;x,0;shadowlength,1;shadowcolor,color("#191919");horizalign,"center");
					Name = "kcalText";
					FinalizedMessageCommand=cmd(finishtweening;linear,0.15;diffusealpha,0);
		};	
		
	}

	--legacy score
	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)
				
				if xSide < 0 then
					self:x(SCREEN_CENTER_X-110);					
				else
					self:x(SCREEN_CENTER_X+110);
				end;


				if GAMESTATE:GetGameMode() == 'Basic' then					
					self:visible(false);
				else
					if GAMESTATE:GetNumSidesJoined() == 2 and checkVsMode() then
						self:visible(false);
					else
						self:y(SCREEN_CENTER_Y+273);
						self:GetChild("legacyScoreTxt"):settext(formatNumberWithDots(tStats["LegacyScore"]));
						self:GetChild("legacyScoreTxt"):zoom(0.8):linear(0.05):diffusealpha(1):zoom(0.65);
						self:visible(true);					
						self:GetChild("legacyScoreTxt"):maxwidth(120);
					end;


				end;


		end;

		LoadActor(THEME:GetPathG("","ScreenEvaluation/lscore_back"))..{
			OnCommand=cmd(zoom,0.67;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.15;diffusealpha,0);
		};
		LoadActor(THEME:GetPathG("","ScreenEvaluation/lscore_text"))..{
			OnCommand=cmd(zoom,0.67;diffusealpha,1;y,-10);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.15;diffusealpha,0);
		};

		LoadFont("smallscore")..{
			OnCommand=cmd(diffusealpha,1;zoom,0.7;y,5;x,0;shadowlength,1;shadowcolor,color("#191919");horizalign,"center");
			Name = "legacyScoreTxt";
			FinalizedMessageCommand=cmd(finishtweening;linear,0.15;diffusealpha,0);
		};	
		
	}

	--[[

	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/texto-score"))..{
		OnCommand=cmd(Center;addy,-207;zoom,0.35;diffusealpha,1;queuecommand,"SetPos");
		SetPosCommand=function(self)
			if xSide < 0 then
				self:x(SCREEN_CENTER_X-360);
			else
				self:x(SCREEN_CENTER_X+360);
			end;
		end;
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};	


	local rollnumberScorex=365;
	if xSide > 0 then 
		rollnumberScorex = 358;
	end;

	t[#t+1] = DrawRollingScoreNew(SCREEN_CENTER_X+rollnumberScorex*xSide, SCREEN_CENTER_Y-180, pnStageStats:GetPhoenixScore(), 'HorizAlign_Center', 1 ,"scorebg")..{
		OnCommand=function(self)
			self:zoom(1.1);
		end;
	};

	t[#t+1] = LoadFont("MenuTimer numbers")..{	
		OnCommand=cmd(diffusealpha,0;Center;x,SCREEN_CENTER_X+400*xSide;y,SCREEN_CENTER_Y-145;settext,string.format("%.2f%%", pnStageStats:GetPercentScore());zoom,0.40;queuecommand,"SetPos");
		SetPosCommand=function(self)
			if xSide < 0 then
				self:x(SCREEN_CENTER_X-202);
				self:horizalign("right");
			else
				self:x(SCREEN_CENTER_X+522);
				self:horizalign("right");
			end;
			self:sleep(1.8);
			self:diffusealpha(1);
		end;

		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};

	t[#t+1] = LoadFont("xolonium 20px")..{
				OnCommand=cmd(xy,SCREEN_CENTER_X+415*xSide,228;zoom,1;horizalign,left;shadowlength,1;shadowcolor,color("#191919");sleep,0;visible,GAMESTATE:IsHumanPlayer(pnPlayer);queuecommand,"Set");
				SetCommand=function(self)

					if xSide < 0 then
						self:x(SCREEN_CENTER_X-528);
						self:horizalign("left");
					else
						self:x(SCREEN_CENTER_X+195);
						self:horizalign("left");
					end;

					if SCREENMAN:GetTopScreen():IsNewRecordPersonal(pnPlayer) then
						local ScoreDiff = GetHighScoreDifference(pnPlayer);
						self:settext( "+"..ScoreDiff );
						self:visible(true);
					else
						if GAMESTATE:IsHumanPlayer(pnPlayer) then
								self:settext( "" );
						end;
					end;
					
				end;
				FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
	};

	]]

	local isNewHSForPlayer = false;
	local diffOnRecords = {};

	local FirstHsRecord = getFirstRecordPlayer(pnPlayer);
	if vStats:PlayerHasHighScore(pnPlayer) then
		if FirstHsRecord["score"] > 0 and FirstHsRecord["score"] == pnStageStats:GetPhoenixScore() then
			isNewHSForPlayer= true;
			diffOnRecords = getDifferenceBetweenRecordStats(pnPlayer);
		end;
	end;

	if isNewHSForPlayer then
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/nrecord_label"))..{
			OnCommand=cmd(Center;addy,-207;zoom,0.7;diffusealpha,1;queuecommand,"SetPos");
			SetPosCommand=function(self)
				if xSide < 0 then
					self:x(SCREEN_CENTER_X-365);
				else
					self:x(SCREEN_CENTER_X+373);
				end;
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/nrecord_label"))..{
			OnCommand=cmd(Center;addy,-207;zoom,0.7;diffusealpha,0.8;blend,"BlendMode_Add";queuecommand,"SetPos");
			SetPosCommand=function(self)
				if xSide < 0 then
					self:x(SCREEN_CENTER_X-365);
				else
					self:x(SCREEN_CENTER_X+373);
				end;
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:linear(1);
				self:fadeleft(0);
				self:linear(1);
				self:faderight(1);
				self:linear(1);
				self:faderight(0);
				self:linear(1);
				self:fadeleft(1);
				self:queuecommand("Ani");
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

	end;



	--##### STATS GAMEPLAY ####----
	-- total de p,g,g,b,m,c etc
	local judgmentActor = Def.ActorFrame{};
	local xRollPosArrowJudg = 0;
	if xSide == -1 then
		xRollPosArrowJudg = xRollPos + 30;
	else
		xRollPosArrowJudg = xRollPos;
	end;

	if extraJudgment then
		local extraYfix=50;	
		for i=1,2,1 do	-- extraJudg

			judgmentActor[#judgmentActor+1] = EvalRollingNumbers(tostring(string.rep("0",3-string.len( split('%.',tStatsExtraJudg[statsAuxExtraJudg[i]] )[1] ) ).. tStatsExtraJudg[statsAuxExtraJudg[i]]),0.1*i,SCREEN_CENTER_X+xRollPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign,  i == 7 and true or false )..{
				OnCommand=function(self)
					self:addy(8);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};

			if isNewHSForPlayer then
				--acá va si subio o bajo en el record con una flechita.
				local arrayName = "";
				if i == 1 then arrayName = "MPerfect" end;
				if i == 2 then arrayName = "Perfect" end;

				if diffOnRecords[arrayName] > -1 then
					judgmentActor[#judgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/arr_hs"))..{
						InitCommand=cmd(xy,(SCREEN_CENTER_X+15)+xRollPosArrowJudg*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i;diffusealpha,1;animate,false;setstate,diffOnRecords[arrayName];zoom,0.4);
						OnCommand=function(self)
							self:addy(8);
						end;
						FinalizedMessageCommand=cmd(finishtweening;visible,false);
					};
				end;			
			end;

		end;

		--scores, el 7 es el puntaje
		for i=2,6,1 do	-- Texto, Delay, Xlim_left, YLim_center, Horizaling
			judgmentActor[#judgmentActor+1] = EvalRollingNumbers(tostring(string.rep("0",3-string.len( split('%.',tStats[statsAux[i]] )[1] ) ).. tStats[statsAux[i]]),0.1*i,SCREEN_CENTER_X+xRollPos*xSide,(SCREEN_CENTER_Y+35)-yStatPos+SnapDistance*i,xAlign,  i == 7 and true or false )..{
				OnCommand=function(self)
					self:addy(8);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};

			if isNewHSForPlayer and i < 7 then
				--acá va si subio o bajo en el record con una flechita.
				local arrayName = "";
				if i == 2 then arrayName = "Great" end;
				if i == 3 then arrayName = "Good" end;
				if i == 4 then arrayName = "Bad" end;
				if i == 5 then arrayName = "Miss" end;
				if i == 6 then arrayName = "Combo" end;

				if diffOnRecords[arrayName] > -1 then
					judgmentActor[#judgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/arr_hs"))..{
						InitCommand=cmd(xy,(SCREEN_CENTER_X+15)+xRollPosArrowJudg*xSide,(SCREEN_CENTER_Y+35)-yStatPos+SnapDistance*i;diffusealpha,1;animate,false;setstate,diffOnRecords[arrayName];zoom,0.4);
						OnCommand=function(self)
							self:addy(8);
						end;
						FinalizedMessageCommand=cmd(finishtweening;visible,false);
					};
				end;

			end;

		end;	

	else
		--scores, el 7 es el puntaje
		for i=1,6,1 do	-- Texto, Delay, Xlim_left, YLim_center, Horizaling
			judgmentActor[#judgmentActor+1] = EvalRollingNumbers(tostring(string.rep("0",3-string.len( split('%.',tStats[statsAux[i]] )[1] ) ).. tStats[statsAux[i]]),0.1*i,SCREEN_CENTER_X+xRollPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign,  i == 7 and true or false )..{
				OnCommand=function(self)
					self:addy(28);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};

			if isNewHSForPlayer and i < 7 then
				local arrayName = "";
				if i == 1 then arrayName = "Perfect" end;
				if i == 2 then arrayName = "Great" end;
				if i == 3 then arrayName = "Good" end;
				if i == 4 then arrayName = "Bad" end;
				if i == 5 then arrayName = "Miss" end;
				if i == 6 then arrayName = "Combo" end;

				if diffOnRecords[arrayName] > -1 then
					judgmentActor[#judgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/arr_hs"))..{
						InitCommand=cmd(xy,(SCREEN_CENTER_X+15)+xRollPosArrowJudg*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i;diffusealpha,1;animate,false;setstate,0;zoom,0.5);
						OnCommand=function(self)
							self:addy(28);
						end;
						FinalizedMessageCommand=cmd(finishtweening;visible,false);
					};
				end;

			end;
			--acá va si subio o bajo en el record con una flechita.

		end;	
	end;


	judgmentActor.InitCommand = function(self)
		self:zoom(zoomTnsPlace);
		self:x(xTnsPlace);
		self:y(yTnsPlace);
	end

	t[#t+1] = judgmentActor;
	


	if not GAMESTATE:GetRandomTrainChannel() and not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then

		--  HighScore XX diferencia
		--[[
		local ScoreDiff = GetHighScoreDifference(pnPlayer);
		if (ScoreDiff > 0) then
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-RECORD-ARROW"))..{
				InitCommand=cmd(diffusealpha,0);
				OnCommand=cmd(Center;addx,260*xSide;addy,47;zoom,.6;sleep,1.8;queuecommand,"Trigger");
				TriggerCommand=function(self)
					if SCREENMAN:GetTopScreen():IsNewRecordPersonal(pnPlayer) then
						self:diffusealpha(1);
					end;
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
			
			t[#t+1] = EvalRollingNumbers(tostring(ScoreDiff),"0.6",SCREEN_CENTER_X+100*xSide,SCREEN_CENTER_Y+45,hsAlign, false , true )..{
				OnCommand=cmd(visible,false;queuecommand,"Trigger");
				TriggerCommand=function(self)
					if SCREENMAN:GetTopScreen():IsNewRecordPersonal(pnPlayer) then
						self:visible(true);
					end;
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
		]]
	end;
	
	pnStageStats:FailPlayer();

	return t
end;

local sMachine = GetMachineName();
sMachine = sMachine:gsub("UNKNOWN", "SANITY");

--we need to acomodate the sounds to the SSS-f
iGrade = iGradeAnnouncer;
local sGradeAnnouncer = "RANK_" .. iGrade;
if bFailedAux then
	sGradeAnnouncer = "BROKEN_" .. iGrade;
end;

--here we check for the external announcer
local externalAnnouncerPath = getExternalAnnouncerPath();
local announcerGradePath = "";
local announcerGigglePath = "";
local announcerFXPath = "";

if #externalAnnouncerPath > 0 then				
	local gradePathSound = checkIfAnnouncerSoundExists(externalAnnouncerPath.."/RANK/",sGradeAnnouncer);
	if #gradePathSound > 0 then
		announcerGradePath = gradePathSound;
	else
		announcerGradePath = THEME:GetPathS("","NEW_RANK/" .. sGradeAnnouncer );
	end;
	
	local gigglePathSound = checkIfAnnouncerSoundExists(externalAnnouncerPath.."/RANK/","GIGGLE");
	if #gigglePathSound > 0 then
		announcerGigglePath = gigglePathSound;
	else
		announcerGigglePath = THEME:GetPathS("","NEW_RANK/GIGGLE");
	end;

	local FXPathSound = checkIfAnnouncerSoundExists(externalAnnouncerPath.."/RANK/","FXRANK_" .. iGrade);
	if #FXPathSound > 0 then
		announcerFXPath = FXPathSound;
	else
		announcerFXPath = THEME:GetPathS("","NEW_RANK/FXRANK_" .. iGrade);
	end;

else
	announcerGradePath = THEME:GetPathS("","NEW_RANK/" .. sGradeAnnouncer );
	announcerGigglePath = THEME:GetPathS("","NEW_RANK/GIGGLE");
	announcerFXPath = THEME:GetPathS("","NEW_RANK/FXRANK_" .. iGrade);
end;



--					 SSS,	SS,	  S,   A ,    B,    C ,    D,     F
local GiggleDelay={ "2.2", "2.2", "2", "2.8", "2.2", "2", "1.5", "1.5" };

local t = Def.ActorFrame {
	
	--[[
	LoadActor( THEME:GetPathG("","Evaluation_Top label") ) .. {
		OnCommand=cmd(Center;addy,-233;diffusealpha,.8;animate,false;setstate,0;zoomy,0;sleep,0.125;linear,0.125;zoomy,.7);
		FinalizedMessageCommand=cmd(finishtweening;linear,0.3;zoomy,0)
	};

	LoadFont("_mainfont")..{
		OnCommand=cmd(Center;addy,-232;settext,sMachine;zoomy,0;sleep,0.5;linear,0.125;zoom,.9);
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};
	]]

	Def.ActorFrame {

		OnCommand=function(self)
			if isAspectRatio1610() then
				self:addy(-40);
			end;
		end;

		LoadActor( THEME:GetPathG("","ScreenEvaluation/EvalTopFrame") ) .. {
			OnCommand=cmd(fadeleft,0.8;faderight,0.8;Center;diffusealpha,.9;addy,-253;zoomy,0;sleep,0.125;linear,0.125;zoomy,0.8;);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};

		LoadActor( THEME:GetPathG("","ScreenEvaluation/EvalTopFrame") ) .. {
			OnCommand=cmd(blend,"BlendMode_Add";Center;diffusealpha,0;addy,-253;zoomy,0;sleep,0.125;linear,0.085;zoomy,0.8;diffusealpha,1;linear,0.4;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};	

		LoadFont("_TitleXolonium 30px")..{
			OnCommand=cmd(Center;addy,-262;settext,tStatsGlobal["Title"];zoomy,0;sleep,0.5;linear,0.125;zoom,0.9);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("_TitleXolonium 30px")..{
			OnCommand=cmd(Center;addy,-238;settext,tStatsGlobal["fulltextData"];zoomy,0;sleep,0.5;linear,0.125;zoom,0.35);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("_TitleXolonium 30px")..{
			OnCommand=cmd(Center;addy,-290;settext,tStatsGlobal["folder"];zoomy,0;sleep,0.5;linear,0.125;zoom,0.3);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

	};



	--[[
	--OBTENER EL USB
	GetUsb()..{
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= 'Basic');
	};
	]]
	LoadActor("profile/default")..{
	    InitCommand = function(self)
	        self:playcommand("modifyForResult");
	    end
	};
	
	Drum(WaitUntilDrum - 0.2, DelayDrum);
	
	-- Usar GetTopScreen con callers siempre causa 'cierto' retraso, nocxq, solo dejare un boolean ahora
	--[[
	LoadActor(THEME:GetPathS("","NEW_RECORD")) .. {
		OnCommand=cmd(queuecommand,"Lot");
		LotCommand=function(self)
			if not bFailedAux and SCREENMAN:GetTopScreen():IsNewRecord() then
				self:play();
			end;
		end;
		OffCommand=function(self)
			self:stop()
		end;
	};
	]]
	
	-------------------------------------------MOD ICONS-----------------------------------------------
	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_1);
		InitCommand=cmd(xy,SCREEN_CENTER_X-608,SCREEN_CENTER_Y-257);
		PlayerJoinedMessageCommand=cmd(queuecommand,"On");
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
	};
	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_2);
		InitCommand=cmd(xy,SCREEN_CENTER_X+610,SCREEN_CENTER_Y-257);
		PlayerJoinedMessageCommand=cmd(queuecommand,"On");
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
	};

};

--AUDIO.
--Here if the EvaluationSkin mod has their own grade_soundsfx.lua we don't play this
--and use the logic of that MOD
local useMODAudio=false;
local actorAudioMod;

if GAMESTATE:GetNumPlayersEnabled() > 1 then


	--if both players uses the same skin, we just use that.
	local evaluationSkinDataP1 = GetEvaluationSkinDataFromPlayer(PLAYER_1);
	local evaluationSkinDataP2 = GetEvaluationSkinDataFromPlayer(PLAYER_2);



	if pnStats1:GetPhoenixScore() > pnStats2:GetPhoenixScore() then

		local failedPlayer = pnStats1:GetFailedAux();
		if #evaluationSkinDataP1["screen_sound"] > 0 then
			useMODAudio = true;
			local audioFunc = LoadActor(evaluationSkinDataP1["screen_sound"]);
			actorAudioMod = audioFunc(evaluationSkinDataP1["path_skin"],PLAYER_1,pnStats1:GetPhoenixScore(),failedPlayer);
		end;

	elseif pnStats2:GetPhoenixScore() > pnStats1:GetPhoenixScore() then

		local failedPlayer = pnStats2:GetFailedAux();
		if #evaluationSkinDataP2["screen_sound"] > 0 then
			useMODAudio = true;
			local audioFunc = LoadActor(evaluationSkinDataP2["screen_sound"]);
			actorAudioMod = audioFunc(evaluationSkinDataP2["path_skin"],PLAYER_2,pnStats2:GetPhoenixScore(),failedPlayer);
		end;

	else -- draw
		--default because none win lol.
		useMODAudio=false;
	end;

else
	local failedPlayer;
	local masterPlayer;
	local scorePlayer = 0;

	if GAMESTATE:IsSideJoined(PLAYER_1) then
		failedPlayer = pnStats1:GetFailedAux();
		masterPlayer = PLAYER_1;
		scorePlayer = pnStats1:GetPhoenixScore();
	elseif GAMESTATE:IsSideJoined(PLAYER_2) then
		failedPlayer = pnStats2:GetFailedAux();
		masterPlayer = PLAYER_2;
		scorePlayer = pnStats2:GetPhoenixScore();
	end;
	
	local evaluationSkinData = GetEvaluationSkinDataFromPlayer(masterPlayer);
	if #evaluationSkinData["screen_sound"] > 0 then
		useMODAudio = true;
		local audioFunc = LoadActor(evaluationSkinData["screen_sound"]);
		actorAudioMod = audioFunc(evaluationSkinData["path_skin"],masterPlayer,scorePlayer,failedPlayer);
	end;
end;

if useMODAudio then
	t[#t+1] = actorAudioMod;

else

	t[#t+1] = Def.ActorFrame{

		LoadActor(THEME:GetPathS("","xsanity/eval/eval_song")) .. {
			OnCommand=cmd(queuecommand,"Lot");
			LotCommand=function(self)
					self:play();
			end;
			FinalizedMessageCommand=function(self)
				self:stop()
			end;		
			OffCommand=function(self)
				self:stop()
			end;
		};

		LoadActor(announcerGigglePath) .. {
			OnCommand=cmd(sleep,DelayGradeShow + GiggleDelay[iGrade + 1];queuecommand,"Lot");
			LotCommand=function(self)
				if bFailedAux then
					self:play();
				end;
			end;
			OffCommand=function(self)
				self:stop()
			end;
		};
		
		
		Def.Sound {	--GRADE
			OnCommand=cmd(sleep,DelayGradeShow - 0.1;queuecommand,"Lot");
			LotCommand=function(self)
				SOUND:PlayOnce(THEME:GetPathS("","NEW_RANK/NUC"));
			end;
		};
		
		-- JNC New Sounds -- AWFUL CODE
		LoadActor(announcerGradePath) .. {
			OnCommand=cmd(sleep,DelayGradeShow;queuecommand,"Lot");
			LotCommand=cmd(play);
			OffCommand=cmd(stop);
		};
		
		LoadActor(announcerFXPath) .. {
			OnCommand=cmd(sleep,DelayGradeShow;queuecommand,"Lot");
			LotCommand=cmd(play);
			OffCommand=cmd(stop);
		};
	};

end;






--[[
local baseJudgmentActor = Def.ActorFrame{};
if extraJudgment then
	for i=1,2,1 do	-- extraJudg
		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/extrajudg_evalab"))..{
			OnCommand=cmd(Center;zoom,0.6;y,SCREEN_CENTER_Y-110+35*i;animate,false;setstate,0;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};

		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/extrajudg_text_evalab"))..{
			OnCommand=cmd(Center;zoom,0.6;addx,4;y,SCREEN_CENTER_Y-110+35*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};	
	end;
	for i=2,6 do
		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/Evalab_full"))..{
			OnCommand=cmd(Center;zoom,0.6;y,(SCREEN_CENTER_Y+35)-110+35*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};

		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/text_Evalab_full"))..{
			OnCommand=cmd(Center;zoom,0.6;y,(SCREEN_CENTER_Y+33)-110+35*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};	
	end;
else
	for i=1,6 do
		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/Evalab_full"))..{
			OnCommand=cmd(Center;zoom,0.6;y,SCREEN_CENTER_Y-92+35*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};

		baseJudgmentActor[#baseJudgmentActor+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/text_Evalab_full"))..{
			OnCommand=cmd(Center;zoom,0.6;y,SCREEN_CENTER_Y-95+35*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
		};	
	end;
end;


baseJudgmentActor.InitCommand = function(self)
	self:zoom(zoomTnsPlace);
	self:x(xTnsPlace);
	self:y(yTnsPlace);
end;
t[#t+1] = baseJudgmentActor;
]]

--#### BASE STATS GAMEPLAY ####---


if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then

	local evaluationSkinDataP1 = GetEvaluationSkinDataFromPlayer(PLAYER_1);
	local evaluationSkinDataP2 = GetEvaluationSkinDataFromPlayer(PLAYER_2);

	--ONLY if the 2 players has the same skin we will use thatskin.
	-- if not, we'll be using the default one.
	if evaluationSkinDataP1["skin_name"] == evaluationSkinDataP2["skin_name"] then
		--here we will be taking the player 1 option, can be player 2 too.
		local textGradeFunc = LoadActor(evaluationSkinDataP1["text_lua"]);
		t[#t+1] = textGradeFunc(evaluationSkinDataP1["path_skin"],PLAYER_1);
	else
		--here who won the battle get the evaluation skin XD

		if pnStats1:GetPhoenixScore() > pnStats2:GetPhoenixScore() then
			local textGradeFunc = LoadActor(evaluationSkinDataP1["text_lua"]);
			t[#t+1] = textGradeFunc(evaluationSkinDataP1["path_skin"],PLAYER_1);

		elseif pnStats2:GetPhoenixScore() > pnStats1:GetPhoenixScore() then
			local textGradeFunc = LoadActor(evaluationSkinDataP2["text_lua"]);
			t[#t+1] = textGradeFunc(evaluationSkinDataP2["path_skin"],PLAYER_2);
		else -- draw
			--default because none win lol.
			local defaultEvaluationSkin = GetDefaultEvaluationSkin();
			local textGradeFunc = LoadActor(defaultEvaluationSkin["text_lua"]);
			t[#t+1] = textGradeFunc(defaultEvaluationSkin["path_skin"],PLAYER_1);
		end;


	end;

elseif GAMESTATE:IsPlayerEnabled(PLAYER_1) then

	local evaluationSkinData = GetEvaluationSkinDataFromPlayer(PLAYER_1);
	local textGradeFunc = LoadActor(evaluationSkinData["text_lua"]);
	t[#t+1] = textGradeFunc(evaluationSkinData["path_skin"],PLAYER_1);

elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) then

	local evaluationSkinData = GetEvaluationSkinDataFromPlayer(PLAYER_2);
	local textGradeFunc = LoadActor(evaluationSkinData["text_lua"]);
	t[#t+1] = textGradeFunc(evaluationSkinData["path_skin"],PLAYER_2);
	
end;


if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = Def.ActorFrame {
		CreateStats( PLAYER_1 );
	};
end;
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	t[#t+1] = Def.ActorFrame {
		CreateStats( PLAYER_2 );
	};
end;

t[#t+1] = LoadActor(THEME:GetPathB("","SurvivalMode/OnEvaluation")) .. { };

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if PREFSMAN:GetPreference("MenuTimer") then
			local timer = SCREENMAN:GetTopScreen():GetChild("Timer")
			if timer then
			        timer:visible(true);
			end			
		end;
	end;
};

t[#t+1] = LoadActor("SaniNetEval")..
{};

t[#t+1] = LoadActor("ScreenEvaluationAddOn/information")..{
		OnCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;
		FinalizedMessageCommand=cmd(finishtweening;linear,0.3;diffusealpha,0);
};

t[#t+1] = LoadActor("ScreenEvaluationAddOn/modelevel")..{};

t[#t+1] = Def.Quad{
		InitCommand=cmd(visible,false;queuecommand,"checkVsData");	
		checkVsDataCommand=function(self)
			if GAMESTATE:GetNumSidesJoined() == 2 and checkVsMode() then
				local stepPlayedP1 = pnStats1:GetPlayedSteps();
				local stepPlayedP2 = pnStats2:GetPlayedSteps();

				local hashChartP1 = stepPlayedP1[#stepPlayedP1]:GetHash();
				local hashChartP2 = stepPlayedP2[#stepPlayedP2]:GetHash();

				if hashChartP1 == hashChartP2 then
					local p1Score = pnStats1:GetPhoenixScore();
					local p2Score = pnStats2:GetPhoenixScore();
					setVsCount(p1Score,p2Score);
				end;
			end;
		end;
	};

--********
-- ADD ON
--********
--VS MODE
if GAMESTATE:GetNumSidesJoined() == 2 and checkVsMode() then
	t[#t+1] = LoadActor("ScreenEvaluationAddOn/vsMode")..{};
end;

--********
-- NONSTOP CENTER
--********
--1) CHECK IF IT'S ON
if isNonstopCenterModeActive() then
		--we save the stat of the player.
		if GAMESTATE:GetNumSidesJoined() == 2 then
			savePlayerStatsGameplay(PLAYER_1);
			savePlayerStatsGameplay(PLAYER_2);
		else
			savePlayerStatsGameplay(GAMESTATE:GetMasterPlayerNumber());
		end;

		local timerScreen = getSecondsBeforeSongNonstopCenter();
		local chartBase = getNextSongGameplayNonstopCenter();

		if chartBase ~= nil then
			local songBase = SONGMAN:GetSongFromSteps(chartBase);		
			local bannerNewPath = GetBannerFromSong(songBase);
			local bpmActual = "-";

			if chartBase ~= nil then
				bpmActual = "BPM ".. ProcessBPM(songBase:GetCustomBPM());
			end;

			t[#t+1] = LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/HG") )..{
					InitCommand=function(self)
						self:zoom(0.6);
						self:xy(SCREEN_CENTER_X,SCREEN_TOP+20);						
					end;
			};

			t[#t+1] = LoadFont("MenuTimer numbers")..{
				OnCommand=cmd(zoom,0.6;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;y,SCREEN_TOP+2 ;x,SCREEN_CENTER_X;settext,timerScreen;queuecommand,"timer");
				timerCommand=function(self)

					self:sleep(1);
					timerScreen = timerScreen - 1;
					if timerScreen < 0 then
						timerScreen = 0;
					end;

					if timerScreen < 10 then
						self:settext("0"..timerScreen);
					else
						self:settext(timerScreen);	
					end;
					
					if timerScreen == 0 then
						--SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					else
						self:queuecommand("timer");
					end;


				end;
				FinalizedMessageCommand=cmd(stoptweening;visible,false);	
				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
			};
			branchGameplayNonstopCenter();

			--INFO NOSTOP CENTER
			t[#t+1] = Def.ActorFrame{
				OnCommand=function(self)
					self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-92);
				end;
				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/base") )..{
						InitCommand=function(self)
							self:zoom(0.7);
							self:zoomy(1)
						end;
				};

				Def.Banner {	
					Name="songBanner";	--banner standard,
					InitCommand=cmd(scaletoclipped,120,80;xy,0,1;);
					OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,1;);
					OnCommand=function(self)
						self:stoptweening():LoadFromCachedBanner(bannerNewPath["bpath"]);					
					end;
				};

				LoadFont("_TitleXolonium")..{
					Name="title";
					Text="NEXT SONG";
					InitCommand=cmd(zoom,0.4);
					OnCommand=function(self)
						self:y(-48);
					end;
				};
				LoadFont("_TitleXolonium")..{
					Name="bpm";
					Text=bpmActual;
					InitCommand=cmd(zoom,0.35);
					OnCommand=function(self)
						self:y(48);
					end;
				};
			};

			--SPEED 
			--with this thing we can change the speed on the fly.
			t[#t+1] = LoadActor("ScreenEvaluationAddOn/speedModNonstopCenter")..{
				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
			};

		else
			--end of the road.
			t[#t+1] = LoadActor("ScreenEvaluationAddOn/speedModNonstopCenter")..{
				OnCommand=function(self)
					self:diffusealpha(0);
				end;
				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
			};
			branchGameplayNonstopCenter();
		end;
end;

-- offset recomendation
local function medianaJudgmentData(t)
	
	if t == nil or #t == 0 then
		return 0;
	end;

	local offsetTimingList = {};
	--we only allow offsets >= 0.01

	local toleranceFast=-0.01; -- below of the receptor.
	local toleranceSlow=0.025; -- on top of the receptor

	for i=1,#t do
		if t[i].rawOffset_ms >= toleranceSlow or t[i].rawOffset_ms <= toleranceFast then
			table.insert(offsetTimingList,t[i].rawOffset_ms);
		end;
	end;

    table.sort(offsetTimingList, function(a, b)
        return a < b
    end)

    local n = #offsetTimingList
    if n == 0 then
    	return 0;
    end;

    local mid = math.floor(n / 2)
    if n % 2 == 0 then
        return (offsetTimingList[mid] + offsetTimingList[mid + 1]) / 2
    else
        return offsetTimingList[mid + 1]
    end
end

function offsetRecomendation(player)

	local plText = "";
	if player == PLAYER_1 then
		plText = "P1";
	else
		plText = "P2";
	end;

	-- because anything inside those timing is normal? no one is capable to stay at 0.0 xD but 
	-- those parameters works fine to remove that noise.

	local toleranceFast=-0.015; -- below of the receptor.
	local toleranceSlow=0.03; -- on top of the receptor

	local tableOffsets = {};

	if GAMESTATE:Env()["timing"..plText] ~= nil then
		tableOffsets = GAMESTATE:Env()["timing"..plText];
	end;
	
	if #tableOffsets > 50 then
		local medPlayer = medianaJudgmentData(tableOffsets);
		
		if medPlayer == 0 then
			GAMESTATE:Env()["recomendedOffset"..plText] = "";
			return;
		end;


		local timingAdjCustomOption = getCustomOptionValuePlayer(player,"timing_adjustment");
		local timingPlayer = 0.0;
		timingPlayer = tonumber(timingAdjCustomOption) or 0.0;

		local newTimingForPlayer = (medPlayer*10) + timingPlayer;

		--this is what we want, i don't want to work with float numbers because they just work like ass xD.
		local stringTiming = string.format("%.1f", newTimingForPlayer);

		if medPlayer < toleranceFast or medPlayer >= toleranceSlow then

			if newTimingForPlayer > 0 then
				stringTiming = "+"..stringTiming;
			end;

			GAMESTATE:Env()["recomendedOffset"..plText] = stringTiming;
		else
			--kind of ok, here we don't need to change.
			--Trace("seems OK :D");
			GAMESTATE:Env()["recomendedOffset"..plText] = "";
		end;
	else
		--Trace("Not enough data ->["..#tableOffsets.." inputs / 50]");
	end;

end;

if GAMESTATE:IsSideJoined(PLAYER_1) then
	offsetRecomendation(PLAYER_1);
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
	offsetRecomendation(PLAYER_2);
end;

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local profileSkinData = getProfileSkinPlayer(PLAYER_1);
	if profileSkinData["isDefault"] == false then
		local profileFrameSkinFunc = LoadActor(profileSkinData["luaPath"]);
		t[#t+1] = profileFrameSkinFunc(profileSkinData["basePathSkin"],PLAYER_1,"ScreenEvaluation");
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local profileSkinData = getProfileSkinPlayer(PLAYER_2);
	if profileSkinData["isDefault"] == false then
		local profileFrameSkinFunc = LoadActor(profileSkinData["luaPath"]);
		t[#t+1] = profileFrameSkinFunc(profileSkinData["basePathSkin"],PLAYER_2,"ScreenEvaluation");
	end;
end;

return t
