if PREFSMAN then
  --PREFSMAN:SetPreference("AttractSoundFrequency", "Never");
  PREFSMAN:SetPreference("PhoenixScoring", true);
  PREFSMAN:SavePreferences();
end

function themeVersionData()
	local vActual = "0.99";
	return "THEME v"..vActual.."\nREV-15022026";
end;

function defaultDifficultyListSkin()
	return "list";
end;

function fastSave()
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			PROFILEMAN:SaveProfile(PLAYER_1);
		end;						
	end;
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
			PROFILEMAN:SaveProfile(PLAYER_2);
		end;
	end;
end;

function checkPerformanceModeState()
	local perfp1=false;
	local perfp2=false;

	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
		if perfp1 == nil then
			perfp1 = false;
		end;
	end;
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");
		if perfp2 == nil then
			perfp2 = false;
		end;
	end;

	if perfp1 or perfp2 then
		return true;
	else
		return false;
	end;

end;

--here we activate and start everything
function checkVsMode()

	if GAMESTATE:Env()["vsMode"] == nil then
		GAMESTATE:Env()["vsMode"] = false;
	end;

	if GAMESTATE:Env()["vsModeHistory"] == nil then
		GAMESTATE:Env()["vsModeHistory"] = {};
	end;	

	if GAMESTATE:Env()["p1vsCount"] == nil then
		GAMESTATE:Env()["p1vsCount"] = 0;
	end;
	if GAMESTATE:Env()["p2vsCount"] == nil then
		GAMESTATE:Env()["p2vsCount"] = 0;
	end;

	return GAMESTATE:Env()["vsMode"];

end;

function restartVsHistory()
	if GAMESTATE:Env()["vsModeHistory"] == nil then
		GAMESTATE:Env()["vsModeHistory"] = {};
	else
		GAMESTATE:Env()["vsModeHistory"] = {};
	end;	
end;

function setVsmodeValue(status)
	GAMESTATE:Env()["vsMode"] = status;
end;

function changeVsModeStatus()
	if GAMESTATE:Env()["vsMode"] == false then
		GAMESTATE:Env()["vsMode"] = true;
		return true;
	else
		GAMESTATE:Env()["vsMode"] = false;
		return false;
	end;
end;

--transforma un score a un state de un sprite, desde la SSS+ a la F en una sola imagen.
function gradeTransformState(scorePlayer)

	local stateLetterSprite = 0;
    if scorePlayer >= 995000 then		                
       	stateLetterSprite = 0; -- SSS+
    elseif scorePlayer >= 990000 and scorePlayer <= 994999 then
        stateLetterSprite = 1;
    elseif scorePlayer >= 985000 and scorePlayer <= 989999 then
        stateLetterSprite = 2;		                
    elseif scorePlayer >= 980000 and scorePlayer <= 984999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 975000 and scorePlayer <= 979999 then
       stateLetterSprite = 4;
    elseif scorePlayer >= 970000 and scorePlayer <= 974999 then
        stateLetterSprite = 5;
    elseif scorePlayer >= 960000 and scorePlayer <= 969999 then
        stateLetterSprite = 6;
    elseif scorePlayer >= 950000 and scorePlayer <= 959999 then
        stateLetterSprite = 7;
    elseif scorePlayer >= 925000 and scorePlayer <= 949999 then
        stateLetterSprite = 8;
    elseif scorePlayer >= 900000 and scorePlayer <= 924999 then
        stateLetterSprite = 9;
    elseif scorePlayer >= 825000 and scorePlayer <= 899999 then
        stateLetterSprite = 10;
    elseif scorePlayer >= 750000 and scorePlayer <= 824999 then
        stateLetterSprite = 11;
    elseif scorePlayer >= 650000 and scorePlayer <= 749000 then
        stateLetterSprite = 12;
    elseif scorePlayer >= 550000 and scorePlayer <= 649999 then
        stateLetterSprite = 13;
    elseif scorePlayer >= 450000 and scorePlayer <= 549999 then
        stateLetterSprite = 14;
    elseif scorePlayer <= 449999 then
        stateLetterSprite = 15; -- f
    end;
    return stateLetterSprite;
end;

function gradeTransformAnnouncer(scorePlayer)

	if scorePlayer == 1000000 then
		return 0;
	end;

	local stateLetterSprite = 0;
    if scorePlayer >= 995000 then		                
       	stateLetterSprite = 1; -- SSS+
    elseif scorePlayer >= 990000 and scorePlayer <= 994999 then
        stateLetterSprite = 1;
    elseif scorePlayer >= 985000 and scorePlayer <= 989999 then
        stateLetterSprite = 2;		                
    elseif scorePlayer >= 980000 and scorePlayer <= 984999 then
        stateLetterSprite = 2;
    elseif scorePlayer >= 975000 and scorePlayer <= 979999 then
       stateLetterSprite = 2;
    elseif scorePlayer >= 970000 and scorePlayer <= 974999 then
        stateLetterSprite = 2;
    elseif scorePlayer >= 960000 and scorePlayer <= 969999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 950000 and scorePlayer <= 959999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 925000 and scorePlayer <= 949999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 900000 and scorePlayer <= 924999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 825000 and scorePlayer <= 899999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 750000 and scorePlayer <= 824999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 650000 and scorePlayer <= 749000 then
        stateLetterSprite = 4;
    elseif scorePlayer >= 550000 and scorePlayer <= 649999 then
        stateLetterSprite = 5;
    elseif scorePlayer >= 450000 and scorePlayer <= 549999 then
        stateLetterSprite = 6;
    elseif scorePlayer <= 449999 then
        stateLetterSprite = 7; -- f
    end;
    return stateLetterSprite;
end;


-- Obtiene una lista de records de una cancion ordenada
function getAllRankingFromSong(PLAYERNUM)
	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(PLAYERNUM);	

	local listProfileId =  PROFILEMAN:GetLocalProfileIDs();
	--debugearTabla(listProfileId);
	local arrayScores={};

	for i=1,#listProfileId do
		local profileLocal = PROFILEMAN:GetLocalProfile(listProfileId[i]);
		local hsList = profileLocal:GetHighScoreList(song,steps):GetHighScores();
		if #hsList > 0 then
			local name = profileLocal:GetDisplayName();
			local guidProfile = profileLocal:GetGUID();
			local score = hsList[1]:GetScore();
			local failed = 0;
			local dateScore = hsList[1]:GetDate();
			local judgStateRecord = -1;
			local fullCombo = false;
			if hsList[1]:GetFailedAux() then
				failed = 1;
			end;
			
			local modListRecord = hsList[1]:GetModifiers();
			--Obtenemos el judgment de este record
			if string.find(modListRecord, "VeryHardJudgement") then
			   judgStateRecord = 2;
			elseif string.find(modListRecord, "ExtraJudgement") then
			   judgStateRecord = 3;	
			elseif string.find(modListRecord, "UltraHardJudgement") then
			   judgStateRecord = 4;	
			elseif string.find(modListRecord, "HardJudgement") then
			   judgStateRecord = 0;
			end;


			--When fixed, this will show a full combo sticker  :) but right now, this thing can't so this function is very sad.
			local tnsbadmiss 	= hsList[1]:GetTapNoteScore('TapNoteScore_W5') +
							  hsList[1]:GetTapNoteScore("TapNoteScore_Miss") +
							  hsList[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss");
			
			if tnsbadmiss == 0 then
				fullCombo = true;
			end;

			table.insert(arrayScores,{guid=guidProfile,name=name,failed=failed,score=score,judgState=judgStateRecord,dateScore=dateScore,fc=fullCombo});
		end;
		
	end;

	if #arrayScores > 1 then
		table.sort(arrayScores, function(a, b)
		    return a.score > b.score
		end)
	end;
	
	return arrayScores;
end;

function GetHighScoreAndStateFromPlayer(PLAYERNUM)

	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(PLAYERNUM);			
	local scorelist;
	local dataHs = {score=0,failed=0,fullcombo=0};
	
	if song and steps then
		scorelist = PROFILEMAN:GetProfile(PLAYERNUM):GetHighScoreList(song,steps);
		assert(scorelist)
		local scores = scorelist:GetHighScores();
		if (scores[1] == nil ) then return dataHs end;
		dataHs["score"] = scores[1]:GetScore();

		local isFailed = 0;
		if scores[1]:GetFailedAux() then
			isFailed = 1;
		end;
		dataHs["failed"] = isFailed;

		dataHs["fullcombo"] = 0;
		
		--When fixed, this will show a full combo sticker  :) but right now, this thing can't so this function is very sad.
		local tnsbadmiss 	= scores[1]:GetTapNoteScore('TapNoteScore_W5') +
						  scores[1]:GetTapNoteScore("TapNoteScore_Miss") +
						  scores[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss");
		
		if tnsbadmiss == 0 then
			dataHs["fullcombo"] = 1;
		end;
		
		printHighscoreDataPlayer(PLAYERNUM,scores[1]);

		return dataHs;
	end;
	
	return dataHs;
end;

function printHighscoreDataPlayer(player,scoreData)


			local plStats = {
				Perfect 	= scoreData:GetTapNoteScore("TapNoteScore_W1") +
							  scoreData:GetTapNoteScore("TapNoteScore_W2") +
							  scoreData:GetTapNoteScore("TapNoteScore_CheckpointHit");		
				Great		= scoreData:GetTapNoteScore('TapNoteScore_W3');
				Good		= scoreData:GetTapNoteScore('TapNoteScore_W4');
				Bad			= scoreData:GetTapNoteScore('TapNoteScore_W5');
				Miss		= scoreData:GetTapNoteScore("TapNoteScore_Miss") +
							  scoreData:GetTapNoteScore("TapNoteScore_CheckpointMiss");
				MaxCombo 	= scoreData:GetMaxCombo();
				Score		= scoreData:GetScore();
			};

			local plStatsExtraJudg = {
				MPerfectExtraJudg = scoreData:GetTapNoteScore("TapNoteScore_W1") + scoreData:GetTapNoteScore("TapNoteScore_CheckpointHit"); --1
				PerfectExtraJudg = scoreData:GetTapNoteScore("TapNoteScore_W2"); --2
			};

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

			--[[
			Trace("# 02 THEME.LUA###"..player.." :HIGHSCORE [1] TRACE:");
			Trace("# MPERFECT ->"..mperf);
			Trace("# PERFECT  ->"..perf);
			Trace("# GREAT    ->"..gr);
			Trace("# GOOD     ->"..gd);
			Trace("# BAD      ->"..bd);
			Trace("# MISS     ->"..miss);
			Trace("# COMBO    ->"..combo);
			Trace("# SCORE    ->"..score);
			]]
end;


function GetHighScoreAndStateFromStepsPlayer(steps,player)
	local song = GAMESTATE:GetCurrentSong();			
	local scorelist;
	local dataHs = {score=0,failed=0};
	
	if type(steps) == "table" then		
    -- Es un train
    	return dataHs;
	end

	if song and steps then
		scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(song,steps);
		assert(scorelist)
		local scores = scorelist:GetHighScores();
		if (scores[1] == nil ) then return dataHs end;
		dataHs["score"] = scores[1]:GetScore();

		local isFailed = 0;
		if scores[1]:GetFailedAux() then
			isFailed = 1;
		end;
		dataHs["failed"] = isFailed;


		dataHs["fullcombo"] = 0;
		--[[
		local tnsbadmiss 	= scores[1]:GetTapNoteScore('TapNoteScore_W5') +
						  scores[1]:GetTapNoteScore("TapNoteScore_Miss") +
						  scores[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss");
		if tnsbadmiss == 0 then
			dataHs["fullcombo"] = 1;
		end;
		]]

		return dataHs;
	end;
	
	return dataHs;
end;

--Retorna la cantidad de 0 que le falta al score a la izq
--para completar el millon-> 998000=0 :: 99800=00
--usado en el font que va atras del score para dar el efecto de los 0.
function getZeroStringFromScore(score)
	local hsLengthMb = string.len(tostring(score));
	local backScoreMb ="";

	if (7-hsLengthMb) > 0 then
		for i=1,(7-hsLengthMb) do
			backScoreMb = backScoreMb.."0";
		end;
	end;
	return backScoreMb;
end;