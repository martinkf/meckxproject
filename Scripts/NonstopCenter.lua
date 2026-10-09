function initNonstopCenterVars()
	local NSdata ={
		NC_Songs={}, 		 --Songs registered
		NC_NumSongs=0,		 --Num of songs of this NS
		NC_IdSongPlaying = 1, --Index of the actual song playing, if we lose a song,we end the NS and this goes back to 1.
		NC_SegBeforeContinue = 30, --Num of seconds before the next song starts.
		NC_IsPlayingNC = false, -- check if the game is a NC. this is only when gameplay Start
		NC_tmpIdSongPrevBranch = 1,

		-- Here are the stats of the gameplay.
		-- we controlate the speeds of both players from here
		-- we don't touch the player config, we adjust on the fly but not save anything.
		NC_player_p1_failed = false,
		NC_player_p2_failed = false,
		NC_player_1_StageData = {},
		NC_player_2_StageData = {},
		NC_player_p1_av=0,
		NC_player_p1_speed="",
		NC_player_p2_av=0,
		NC_player_p2_speed="",
		NC_time_playing = 0;

		--we only use this if there are 2 players playing.
		NC_p1_wins = 0,
		NC_p2_wins = 0,
		NC_player_draws = 0,
		NC_next_screen=""
	};
	GAMESTATE:Env()["NONSTOPCENTER"] = NSdata;	
end;

--******
-- SPEED CONTROL
--******
function setAvSpeedNonstopCenterMode(player,av)
	local param="";
	if player == PLAYER_1 then
		param = "NC_player_p1_av";
	else
		param = "NC_player_p2_av";
	end;

	GAMESTATE:Env()["NONSTOPCENTER"][param] = av;
	return true;
end;
function setSpeedNonstopCenterMode(player,speed)
	local param="";
	if player == PLAYER_1 then
		param = "NC_player_p1_speed";
	else
		param = "NC_player_p2_speed";
	end;

	GAMESTATE:Env()["NONSTOPCENTER"][param] = speed;
	return true;
end;

function getAvSpeedNonstopCenterMode(player)
	local param="";
	if player == PLAYER_1 then
		param = "NC_player_p1_av";
	else
		param = "NC_player_p2_av";
	end;

	return GAMESTATE:Env()["NONSTOPCENTER"][param];
end;
function getSpeedNonstopCenterMode(player)
	local param="";
	if player == PLAYER_1 then
		param = "NC_player_p1_speed";
	else
		param = "NC_player_p2_speed";
	end;

	return GAMESTATE:Env()["NONSTOPCENTER"][param];
end;

function addAvNonstopCenterMode(player)
	local avSpeed = getAvSpeedNonstopCenterMode(player);
	avSpeed = avSpeed + 10;
	if avSpeed > 900 then
		avSpeed = 900;
	end;
	setAvSpeedNonstopCenterMode(player,avSpeed);
	GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):MMod(avSpeed);
end;
function minusAvNonstopCenterMode(player)
	local avSpeed = getAvSpeedNonstopCenterMode(player);
	avSpeed = avSpeed - 10;
	if avSpeed <= 300 then
		avSpeed = 300;
	end;
	setAvSpeedNonstopCenterMode(player,avSpeed);
	GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):MMod(avSpeed);
end;

function playerIsAvNonstopCenterMode(player)
	local STATE = GAMESTATE:GetPlayerState(player);
	local AV = STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod()
	if AV == nil then return false; end;
	return true;
end;

function minusSpeedNonstopCenterMode(player)
	local speedPlayer = getSpeedNonstopCenterMode(player);
	speedPlayer = speedPlayer - 0.25;
	if speedPlayer < 1 then
		speedPlayer = 1;
	end;
	setSpeedNonstopCenterMode(player,speedPlayer);
	GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod(speedPlayer);
end;

function plusSpeedNonstopCenterMode(player)
	local speedPlayer = getSpeedNonstopCenterMode(player);
	speedPlayer = speedPlayer + 0.25;
	if speedPlayer >= 7 then
		speedPlayer = 1;
	end;
	setSpeedNonstopCenterMode(player,speedPlayer);
	GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod(speedPlayer);
end;

--*********
--BASE
--*********

function isNonstopCenterModeActive()
	if GAMESTATE:Env()["NONSTOPCENTER"] == nil then
		return false;
	end;

	if GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] == nil then
		return false;
	end;

	if GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] then
		return true;
	elseif GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] == false then
		return false;
	end;
end;

function setNonstopCenter(isPlaying)
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] = isPlaying;
	return true;
end;

function getNextScreenNonstopCenter()
	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"];
end;

--*********
--UTILS
--*********
function getSecondsBeforeSongNonstopCenter()
	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
end;

function addSecondsToPauseNonstopCenter()
	local secondsToAdd = 5;
	local newSeconds = GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] + secondsToAdd ;
	if newSeconds >= 60 then
		GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] = 60;	
	else
		GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] = newSeconds;
	end; 
	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
end;

function removeSecondsToPauseNonstopCenter()
	local secondsToRemove = 5;
	local newSeconds = GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] - secondsToRemove;
	if newSeconds <= 5 then
		GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] = 5;	
	else
		GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"] = newSeconds;
	end; 

	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
end;

function resetPlayerStatsNonstopCenter()
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] = false;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p1_failed"] = false;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p2_failed"] = false;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"] = {};
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_2_StageData"] = {};
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_time_playing"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_p1_wins"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_p2_wins"] = 0;

	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p1_av"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p1_speed"] = "";
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p2_av"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p2_speed"] = "";

	GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_draws"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] = 1;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = "";
end;

function resetSongRegisteredNonstopCenter()
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] = {};
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_NumSongs"] = 0;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] = 1;
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] = false;
end;

--total num of song registered.
function getNumSongRegisteredNonstopCenter()
	return #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
end;

--*********
--SONGS
--*********
function totalTimeOfSongsNonstopCenter()
	local totalSecondsSongs=0;

	for i=1,#GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] do

		local songInList = SONGMAN:GetSongFromSteps(GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"][i]);
		local lastSecondSong = songInList:GetLastSecond() or 0;
		local SongTotalSeconds = songInList:MusicLengthSeconds() or 0;

		if lastSecondSong > 0 then
			totalSecondsSongs = totalSecondsSongs + lastSecondSong;
		elseif SongTotalSeconds > 0 then
			totalSecondsSongs = totalSecondsSongs + SongTotalSeconds;
		end;
		
	end;

	local totalMinutes = 0;
	if totalSecondsSongs > 0 then
		totalMinutes = math.floor((totalSecondsSongs % 3600) / 60);
	end;

	local totalHours = 0;
	if totalSecondsSongs > 0 then
		totalHours = math.floor(totalSecondsSongs / 3600)
	end;
	
	return {hours=totalHours,seconds =totalSecondsSongs, minutes = totalMinutes,formated=formatSecondsFull(totalSecondsSongs)};
end;

function ListOfSongsSelectedNonstopCenter()
	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
end;

function addSongsNonstopCenter(song)
	local NumMaxOfSongs = 12;
	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] == NumMaxOfSongs then
		return false;
	end;

	table.insert(GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"],song);
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_NumSongs"] = #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
	return true;
end;

function removeLastSongNonstopCenterNonstopCenter()
	if getNumSongRegisteredNonstopCenter() == 0 then
		return false;
	end;
	--remove the last entry.
	table.remove(GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"]);
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_NumSongs"] = #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
	return true;
end;

function removeSongFromIndexNonstopCenter(index)
	local numSongReg = getNumSongRegisteredNonstopCenter();
	if getNumSongRegisteredNonstopCenter() == 0 then
		return false;
	end;

	if index > numSongReg then
		return false;
	end;

	table.remove(GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"],index);
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_NumSongs"] = #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
	return true;
end;


--*********
--GAMEPLAY
--*********
function goBackFromNonstopCenter()
	local screen = SCREENMAN:GetTopScreen();
	screen:SetNextScreenName("ScreenSelectMusic");
	screen:StartTransitioningScreen("SM_GoToNextScreen");
end;
--set the song.
function setGameplayNonstopCenter()
    --here we set the screen, set the vars and start playing :)
	local chartToPlay = getActualSongGameplayNonstopCenter();
	if chartToPlay == nil then
		return;
	end;

	local songBase = SONGMAN:GetSongFromSteps(chartToPlay);

	-- Asignar canción
	GAMESTATE:SetCurrentSong(songBase)
	
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		GAMESTATE:SetCurrentSteps(PLAYER_1, chartToPlay);
	end;
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		GAMESTATE:SetCurrentSteps(PLAYER_2, chartToPlay);
	end;
end;

--start the gameplay.
function startGameplayNonstopCenter()
	local screen = SCREENMAN:GetTopScreen()
	--screen:SetNextScreenName("ScreenGameplay");
	--SCREENMAN:SetNewScreen("ScreenGameplay"); --ScreenGameplay

	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IsPlayingNC"] = true;
	screen:SetNextScreenName("ScreenLoadSong"); --ScreenGameplay
	screen:StartTransitioningScreen("SM_GoToNextScreen");
end;

--restart the index 
function restartIndexSongNonstopCenter()
	GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] = 1;
end;

--get the id of the actual song.
function getIndexSongPlayingNonstopCenter()
	return GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"];
end;

-- get a curated array with the player information.
function getPlayerInformationNonstopCenter(player)

	if player == PLAYER_1 then
		return {
			stagesData = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"],
			isFailed = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p1_failed"],
			time_playing = GAMESTATE:Env()["NONSTOPCENTER"]["NC_time_playing"],
			wins=GAMESTATE:Env()["NONSTOPCENTER"]["NC_p1_wins"],
			loses=GAMESTATE:Env()["NONSTOPCENTER"]["NC_p2_wins"],
			draws=GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_draws"]
		};
	else
		return {
			stagesData = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_2_StageData"],
			isFailed = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_p2_failed"],
			time_playing = GAMESTATE:Env()["NONSTOPCENTER"]["NC_time_playing"],
			wins=GAMESTATE:Env()["NONSTOPCENTER"]["NC_p2_wins"],
			loses=GAMESTATE:Env()["NONSTOPCENTER"]["NC_p1_wins"],
			draws=GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_draws"]
		};
	end;
end;

function savePlayerStatsGameplay(player)

	if player == nil then
		return nil;
	end;

	local imPlayer1=false;
	local imPlayer2=false;

	if player == PLAYER_1 then
		imPlayer1 = true;
	else
		imPlayer2 = true;
	end;

	local pnStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);

	if pnStageStats == nil then
		return nil;
	end;

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
		Failed		= pnStageStats:GetFailedAux();
		autoplay    = pnStageStats:GetAutoPlay();
	};

	local isNewRecord = false;
	--[[
	if SCREENMAN:GetTopScreen():IsNewRecordPersonal(player) then
		isNewRecord = true;
	end;
	]]

	local ispfc = false;
	local isfc = false;
	local isefc = false;
	local gradeId = gradeTransformState(tStats["Score"]);
	local isAutoPlay = false;

	if tStats["Perfect"] > 0 and tStats["Great"] == 0 and tStats["Good"] == 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
		ispfc = true;
	elseif tStats["Perfect"] > 0 and tStats["Great"] > 0 and tStats["Good"] == 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
		isfc = true;
	elseif tStats["Perfect"] > 0 and tStats["Great"] > 0 and tStats["Good"] > 0 and tStats["Bad"] == 0 and tStats["Miss"] == 0 then
		isefc = true;
	end;

	-- we check if the stat is already inserted.
	local dataPlayer = {};

	if player == PLAYER_1 then
		dataPlayer = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"];
	else
		dataPlayer = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_2_StageData"];
	end;

	for i=1,#dataPlayer do
		if dataPlayer[i]["idSong"] == idSongPlayed then
			--data already registered.
			return nil;
		end;		
	end;

	--if there are 2 players, we check who won this stage.
	local iWin = false;
	local is_Draw = false;

	if GAMESTATE:GetNumSidesJoined() == 2 then
		local scorep1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPhoenixScore();
		local scorep2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetPhoenixScore();

		if imPlayer1 then
			if scorep1 > scorep2 then
				iWin = true;
			end;
			if scorep1 == scorep2 then
				is_Draw = true;
			end;
		else
			if scorep2 > scorep1 then
				iWin = true;
			end;
			if scorep1 == scorep2 then
				is_Draw = true;
			end;
		end;
	end;

	local idSongPlayed = getIndexSongPlayingNonstopCenter();
	local playerStageStats = {
		idSong = idSongPlayed;
		gradeId = gradeId;
		score = tStats["Score"];
		isFailed = tStats["Failed"];
		isPfc = ispfc;
		isFc = isfc;
		isEfc = isefc;
		isWin = iWin;
		isDraw = is_Draw;
		isNewRecord = isNewRecord;
		isAutoPlay = tStats["autoplay"];
	};

 	--we save the data.
	if player == PLAYER_1 then
		table.insert(GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"],playerStageStats);
		--we print what we saved
		--printInLogParamsData("save p1 [ID:"..idSongPlayed.."]",GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"]);
	else
		table.insert(GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_2_StageData"],playerStageStats);
		--printInLogParamsData("save p2 [ID:"..idSongPlayed.."]",GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"]);
	end;

	return playerStageStats;
end;

-- check if we can continue or not
function branchGameplayNonstopCenter()
	local screenEvaluationName = "ScreenEvaluationNonstopCenter";
	local screenLoadingSongName = "ScreenLoadSong";

	-- -> ScreenLoadSong
	-- -> ScreenNCEvaluation / ScreenSelectMusic meanwhile xD
	if GAMESTATE:GetNumSidesJoined() == 2 then
		--we check if the 2 players failed, if not we continue to the next.
		local pnStageStatsP1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
		local pnStageStatsP2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);


		-- we check if there is a next song.
		local newIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] + 1;
		if newIndex > getNumSongRegisteredNonstopCenter() then
			-- no more songs.
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenEvaluationName;
		else
			-- next song.
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_tmpIdSongPrevBranch"] = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"];

			local newIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] + 1;
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] = newIndex;
			
			setGameplayNonstopCenter();
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenLoadingSongName;
		end;

		--[[
		--on a duel, there is a winner even if both players fail. we better show this at the evaluation.		
		if pnStageStatsP1:GetFailedAux() and pnStageStatsP2:GetFailedAux() then
			--both failed we end the gameplay.			
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenEvaluationName;
		else


		end;
		]]
	else
		local playerOn = GAMESTATE:GetMasterPlayerNumber();
		local pnStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(playerOn);
		if pnStageStats:GetFailedAux() then
			GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenEvaluationName;
		else
			local newIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] + 1;
			if newIndex > getNumSongRegisteredNonstopCenter() then
				-- no more songs.
				GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenEvaluationName;
			else
				-- next song.
				GAMESTATE:Env()["NONSTOPCENTER"]["NC_tmpIdSongPrevBranch"] = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"];
				local newIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] + 1;
				GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"] = newIndex;
				setGameplayNonstopCenter();
				GAMESTATE:Env()["NONSTOPCENTER"]["NC_next_screen"] = screenLoadingSongName;
			end;
		end;

	end;

end;

function getActualSongGameplayNonstopCenter()
	local actualIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"];
	
	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] == 0 then
		return nil;
	end;

    return GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"][actualIndex];
end;

--this will check a song afterwards the branch so the next next song...
function getNextSongGameplayNonstopCenter()
	local actualIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_IdSongPlaying"]+1;
	
	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] == 0 then
		return nil;
	end;

	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] < actualIndex then
		return nil;
	end;

    return GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"][actualIndex];
end;

--this will ignore the branch process and show the actual next song if there is one
function getActualNextSongGameplayNonstopCenter()
	local actualIndex = GAMESTATE:Env()["NONSTOPCENTER"]["NC_tmpIdSongPrevBranch"]+1;
	
	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] == 0 then
		return nil;
	end;

	if #GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"] < actualIndex then
		return nil;
	end;

    return GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"][actualIndex];
end;