local t = Def.ActorFrame
{
	-- InitCommand=function(self)
		-- self:SetUpdateFunction(Update)
	-- end;
	SpecialFinishMessageCommand=function(self,params)
		local pnStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player);
		SpecialMissionResult(pnStageStats, params.ID);
		
	end;
	
	LoadActor("SaniNetGame")..
	{
	};

	JudgmentMessageCommand=function(self,param)

	end;
};

local stage= GAMESTATE:GetCurrentStageIndex()+1;
local oldnoteskin={};
local TweakY = 28;
setStageCounterInGameplay(true);

--true: is using Lua for halfdouble
--false: is using Lua but the doubles because there is no halfdouble lua.
--nil: is not using lua.
local isUsingHalfDoublePositionLua = isHalfDoubleSkinPositionItemsLua();


function songBar()
	return 	Def.SongMeterDisplay {
		OnCommand=function(self)
			if isAspectRatio1610() then
				self:y(SCREEN_TOP+1);
			end;

			if isAspectRatio43() then
				self:y(SCREEN_TOP+1);
			end;

		end;		
		StreamWidth=SCREEN_WIDTH;
		Stream=Def.Quad { 
			InitCommand=cmd(diffusealpha,1;draworder,99;zoomto,1,4;diffuse,color("#ffffff")); 
		};
		Tip=LoadActor(THEME:GetPathG("","ScreenGameplay/song position tip"))..{
			OnCommand=function(self)
				self:zoom(0.8);
			end;
		};
	};
end;

-- :::******************:::
-- ::: BAR LIFE OPTIONS :::
-- :::******************:::
function createLifeBarMode(player,typeMode)
	return Def.Quad {
		InitCommand=cmd(zoomto,0,0;visible,false);
		JudgmentMessageCommand=function(self,param)
			if param.Player ~= player then return end;
			self:queuecommand("CheckModeStatus");
		end;
		
		CheckModeStatusCommand=function(self)
			local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
			local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
			local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
			local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
			local allTns = gr+gd+bd+miss;
			local fcTns = gd+bd+miss;
			local efcTns = bd+miss;

			if typeMode == "suddendeath" then
				if miss > 0 then
					GAMESTATE:Env()["BreakFromMode"] = true;
					if GAMESTATE:GetNumSidesJoined() == 2 then
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):FailPlayer();
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):FailPlayer();						
					else
						STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer();
					end;
					
					SCREENMAN:GetTopScreen():give_up();
				end;
			elseif typeMode == "5missmax" then
				if miss > 5 then
					GAMESTATE:Env()["BreakFromMode"] = true;
					if GAMESTATE:GetNumSidesJoined() == 2 then
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):FailPlayer();
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):FailPlayer();
					else
						STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer();	
					end;

					SCREENMAN:GetTopScreen():give_up();
				end;
			elseif typeMode == "pfcmode" then
				if allTns > 0 then
					GAMESTATE:Env()["BreakFromMode"] = true;
					if GAMESTATE:GetNumSidesJoined() == 2 then
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):FailPlayer();
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):FailPlayer();
					else
						STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer();	
					end;

					SCREENMAN:GetTopScreen():give_up();
				end;
			elseif typeMode == "fcmode" then
				if fcTns > 0 then
					GAMESTATE:Env()["BreakFromMode"] = true;
					if GAMESTATE:GetNumSidesJoined() == 2 then
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):FailPlayer();
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):FailPlayer();
					else
						STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer();

					end;

					SCREENMAN:GetTopScreen():give_up();
				end;
			elseif typeMode == "efcmode" then
				if efcTns > 0 then
					GAMESTATE:Env()["BreakFromMode"] = true;
					if GAMESTATE:GetNumSidesJoined() == 2 then
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):FailPlayer();
						STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):FailPlayer();
					else
						STATSMAN:GetCurStageStats():GetPlayerStageStats(player):FailPlayer();	
					end;

					SCREENMAN:GetTopScreen():give_up();
				end;
			end;

		end;
	};

end;


if GAMESTATE:IsHumanPlayer(PLAYER_1)  then
	local exlP1Temp = getCustomOptionValuePlayer(PLAYER_1,"lifebar_extra_mode");
	if exlP1Temp ~= nil and exlP1Temp ~= "none" then
		t[#t+1] = createLifeBarMode(PLAYER_1,exlP1Temp);
	end;	
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2)  then
	local exlP2Temp =  getCustomOptionValuePlayer(PLAYER_2,"lifebar_extra_mode");
	if exlP2Temp ~= nil and exlP2Temp ~= "none" then
		t[#t+1] = createLifeBarMode(PLAYER_2,exlP2Temp);
	end;	
end;

--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

--opciones 
if GAMESTATE:Env()["infop1"] == nil then
	GAMESTATE:Env()["infop1"] = 0;
	GAMESTATE:Env()["fastp1"] = 0;
	GAMESTATE:Env()["slowp1"] = 0;
end; 

if GAMESTATE:Env()["infop2"] == nil then
	GAMESTATE:Env()["infop2"] = 0;
end; 

if GAMESTATE:Env()["fastp1"] == nil and GAMESTATE:Env()["slowp1"] == nil then
	GAMESTATE:Env()["fastp1"] = 0;
	GAMESTATE:Env()["slowp1"] = 0;
end;

if GAMESTATE:Env()["fastp2"] == nil and GAMESTATE:Env()["slowp2"] == nil then
	GAMESTATE:Env()["fastp2"] = 0;
	GAMESTATE:Env()["slowp2"] = 0;
end;

--





--FAST Y SLOW PARA EL SCREENEVALUATION
local p1f=0;
local p1sl=0;
local p2f=0;
local p2sl=0;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		GAMESTATE:Env()["fastp1"] = 0;
		GAMESTATE:Env()["slowp1"] = 0;
		GAMESTATE:Env()["fastp2"] = 0;
		GAMESTATE:Env()["slowp2"] = 0;		
	end;

	JudgmentMessageCommand=function(self,param)

			local extraJudgment = GAMESTATE:GetExtraJudgment();
			if param.Player == PLAYER_1 then
				if extraJudgment then
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							p1f = p1f + 1;
						end;				

						if not param.Early then
							p1sl = p1sl + 1;
						end;
					end;
				else
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_W2" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							p1f = p1f + 1;
						end;				

						if not param.Early then
							p1sl = p1sl + 1;
						end;
					end;

				end;
				GAMESTATE:Env()["fastp1"] = p1f;
				GAMESTATE:Env()["slowp1"] = p1sl;

	
			end;

			if param.Player == PLAYER_2 then
				if extraJudgment then
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							p2f = p2f + 1;
						end;				

						if not param.Early then
							p2sl = p2sl + 1;
						end;
					end;
				else

					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_W2" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							p2f = p2f + 1;
						end;				
						if not param.Early then
							p2sl = p2sl + 1;
						end;
					end;
				end;

				GAMESTATE:Env()["fastp2"] = p2f;
				GAMESTATE:Env()["slowp2"] = p2sl;

			end;
	end;

};

--this is my response to the fuckup hahahaha
function fixPositionOnBetaLifebars(player)
	local lifebarSkin = getCustomOptionValuePlayer(player,"lifebarSkin");
	local listBetaLifeBars = {"e_Clean","e_Hatsune","e_IIDX-EXH","e_Simple","e_Steam","e_RED"};
	if lifebarSkin == nil then
		return false;
	end;

	if lifebarSkin == "" then
		return false;
	end;

	for i=1,#listBetaLifeBars do
		if listBetaLifeBars[i] == lifebarSkin then
			return true;
		end;
	end;
	return false;
end;


--1P SOLO
if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:GetCurrentStyle():GetStyleType() ~= "StyleType_OnePlayerTwoSides" then
		t[#t+1] = LoadActor("ScreenGameplayPlayer1") .. {
			--OnCommand=cmd(addx,42;addy,-1);
			--OnCommand=cmd(addx,0;addy,-1);
			OnCommand=function(self)

				--this is a fuckup xD
				if fixPositionOnBetaLifebars(PLAYER_1) then
					self:addx(42);
				else
					--everything else will be fixed, now screen_center_x is the center lol
					self:addx(0);
				end;
				self:addy(-1);
			end;
		}; 
end;

--2P SOLO
if GAMESTATE:IsHumanPlayer(PLAYER_2) and GAMESTATE:GetCurrentStyle():GetStyleType() ~= "StyleType_OnePlayerTwoSides" then
	t[#t+1] = LoadActor("ScreenGameplayPlayer2") .. {
		--OnCommand=cmd(addx,-42;addy,-1);
		OnCommand=function(self)			
            --self:addx(-42);

            --this is a fuckup xD
			if fixPositionOnBetaLifebars(PLAYER_2) then
				self:addx(-42);
			else
				--everything else will be fixed, now screen_center_x is the center lol
				self:addx(0);
			end;

            self:addy(-1);			
		end;
	};
end;

--MODO DOBLE
if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then

	local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
	if isHalf then
		t[#t+1] = LoadActor("ScreenGameplayHalfDouble") .. {
			OnCommand=cmd(addy,-1);
		}; 
	else
		t[#t+1] = LoadActor("ScreenGameplayDouble") .. {
			OnCommand=cmd(addy,-1);
		}; 		
	end;




end;


-- :::FRAMESKIN:::
local isUsingDefaultSkin = true;
--:::: FRAME SKIN ::::--
--we get the installed themes. if it's intern we will asume is it the simple.
local luaFrameSkinSelected = getFrameSkinForPlayers("overlay","ScreenGamePlay");

if luaFrameSkinSelected["isDefault"]  == false then
	--LOAD EVERYTHING FROM THE FRAMESKIN

	local frameSkinFunc = LoadActor(luaFrameSkinSelected["lua"]);
	t[#t+1] = frameSkinFunc(luaFrameSkinSelected["path"]);
	isUsingDefaultSkin = false;
	
else
	--DEFAULT THINGS FOR THIS GAMEPLAY SCREEN	
	t[#t+1] = Def.ActorFrame{
		Name="HeaderCounter";
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP+TweakY);

			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				
				local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
				if isHalf then

					if isUsingHalfDoublePositionLua == nil then
						self:x(SCREEN_CENTER_X-280);
					elseif isUsingHalfDoublePositionLua then
						self:x(SCREEN_CENTER_X-280); 
					else
						self:x(SCREEN_LEFT+214);
					end;

				else
					self:x(SCREEN_LEFT+214);
				end;
				

			end;

			if GAMESTATE:GetNumSidesJoined() == 1  then
				if getStageCounterInGameplay() ~= nil and getStageCounterInGameplay() == false then
						self:visible(false);
				end;
			end;


		end;

		ToggleOffCounterCommand=function(self)
			self:visible(false);
		end;

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/SG-STAGEBACK")) .. {
			InitCommand=function(self)
				self:zoom(0.5);
			end;
		};

		LoadFont("stagefull")..{
			OnCommand=function(self)
				self:zoom(.9);
				self:settext(string.format("%02i", stage));
				--self:xy(SCREEN_CENTER_X,SCREEN_TOP+(TweakY+5));
				self:y(5);

			end;
		};
	};	
end;

-- NUKE FX
local NukePlaying = false;
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","FX/HPB")) .. {
		Name = "HPB";
		InitCommand=cmd(Center;diffusealpha,0;SetAllStateDelays,0.04;pause;animate,true;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT*1.6);
		StartNukeCommand=cmd(setstate,0;diffusealpha,1;play;sleep,.65;queuecommand,"PauseNuke");
		PauseNukeCommand=cmd(setstate,15;pause;linear,.1;diffusealpha,0);
	}; 

	Def.Quad {
		Name = "FlashNuke";
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("1,1,1,0"));
		StartNukeCommand=cmd(finishtweening;sleep,.3;linear,.3;diffusealpha,1;sleep,.16;linear,.3;diffusealpha,0);
	},
	
	DoNukeFXMessageCommand=function(self)
		if not NukePlaying then
			local this = self:GetChildren();
			self:finishtweening();
			this.HPB:finishtweening():queuecommand("StartNuke");
			this.FlashNuke:finishtweening():queuecommand("StartNuke");
			NukePlaying = true;
			self:sleep(.67);
			self:queuecommand("RestartPlay");
		end;
	end;
	
	RestartPlayCommand=function(self)
		NukePlaying = false;
	end;
	
}




--## GLOBAL UI OPTIONS ##--
--## PARAMS ##--
local fastP1 = 0;
local slowP1 = 0;
local fastP2 = 0;
local slowP2 = 0;
local UI_display_song_time = false;
local UI_display_songTimeTopBar = false;
local UI_display_LV_song = false;


if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local player_display_song_time_p1 = getCustomOptionValuePlayer(PLAYER_1,"gameplay_song_time_ui");
	if player_display_song_time_p1 ~= nil and player_display_song_time_p1 == true then
		UI_display_song_time = true;
	end;

	local player_display_topbar_song_time_p1 = getCustomOptionValuePlayer(PLAYER_1,"gameplay_topTimerBar");
	if player_display_topbar_song_time_p1 ~= nil and player_display_topbar_song_time_p1 then
		UI_display_songTimeTopBar = true;
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local player_display_song_time_p2 = getCustomOptionValuePlayer(PLAYER_2,"gameplay_song_time_ui");
	if player_display_song_time_p2 ~= nil and player_display_song_time_p2 == true then
		UI_display_song_time = true;
	end;

	local player_display_topbar_song_time_p2 = getCustomOptionValuePlayer(PLAYER_2,"gameplay_topTimerBar");
	if player_display_topbar_song_time_p2 ~= nil and player_display_topbar_song_time_p2 then
		UI_display_songTimeTopBar = true;
	end;
end;


--MACHINE CONFIG
local bShowLife = PREFSMAN:GetPreference('ShowExtraInfo');
local bShowTime = PREFSMAN:GetPreference('ShowExtraInfo');
local bShowSongLevel = PREFSMAN:GetPreference('ShowExtraInfo');
--local bShowGameDifficulty = PREFSMAN:GetPreference('ShowExtraInfo');

function getBreakIconPlayer_StaticUI(player)

	-- revisamos si es que tenemos icono de break.
	local schemePlayerSelected = getSkinSelectedInfoSchemePath(player);

	-- 
	if schemePlayerSelected["default"] == false then
		local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"BreakIcon");
		if isValid then
			local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."BreakIcon/default.lua");
			return actorFunc(schemePlayerSelected["pathLua"],player);
		end;
	end;


	local MedRateH=0.5;

	local zoomBaseNum = 0.38;
	local offsetPlayer = 0;
	local offsetTop = SCREEN_TOP + 26;

	local usingHeartDecreaseMiss = false;
	local modeUsed = "";
	local numHearts = 1;
	local paddingMoreHearts = 15;

	local lifebarExtraSelected = getCustomOptionValuePlayer(player,"lifebar_extra_mode");
	if lifebarExtraSelected == "5missmax" then
		modeUsed = "5missmax";
		usingHeartDecreaseMiss = true;
		numHearts = 6;
	end;

	if lifebarExtraSelected == "suddendeath" then
		modeUsed = "suddendeath";
		MedRateH = 0.25;
	end;

	if player == PLAYER_1 then
		offsetPlayer = SCREEN_LEFT + 188;
		paddingMoreHearts = paddingMoreHearts * -1;

		if modeUsed == "5missmax" then
			offsetPlayer = SCREEN_LEFT + 194;
			zoomBaseNum = 0.33
		end;
		
	else
		offsetPlayer = SCREEN_RIGHT - 188;
		if modeUsed == "5missmax" then
			offsetPlayer = SCREEN_RIGHT - 194;
			zoomBaseNum = 0.33
		end;
	end;

	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
		

		local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
		if isHalf then
			if isUsingHalfDoublePositionLua == nil then
				offsetPlayer = SCREEN_CENTER_X + 250;
			elseif isUsingHalfDoublePositionLua then
				offsetPlayer = SCREEN_CENTER_X + 250;
			else				
				offsetPlayer = SCREEN_CENTER_X + 396;
			end;
		else
			offsetPlayer = SCREEN_CENTER_X + 396;
		end;

	end;	

	local pathHeartFull = "ScreenGamePlay_ui/info/heart_full";
	local pathHeartEmpty = "ScreenGamePlay_ui/info/heart_empty";

	local STATE = GAMESTATE:GetPlayerState(player);
	local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();	
	if failSetting == "FailType_Immediate" then
		pathHeartFull = "ScreenGamePlay_ui/info/breakon_heart_full";
	end;


	if lifebarExtraSelected == "pfcmode" then
		pathHeartFull = "ScreenGamePlay_ui/info/star_pfc";
		pathHeartEmpty ="_blank";
		zoomBaseNum = 0.6;
		MedRateH = 0.7;
	end;
	if lifebarExtraSelected == "fcmode" then
		pathHeartFull = "ScreenGamePlay_ui/info/star_fc";
		pathHeartEmpty="_blank";
		zoomBaseNum = 0.65;
		MedRateH = 0.7;
	end;
	if lifebarExtraSelected == "efcmode" then
		pathHeartFull = "ScreenGamePlay_ui/info/star_efc";
		pathHeartEmpty="_blank";
		zoomBaseNum = 0.65;
		MedRateH = 0.7;
	end;
	--

	local actorBaseFrame = Def.ActorFrame{};

	for i=numHearts,1,-1 do
		actorBaseFrame[#actorBaseFrame+1] = Def.ActorFrame{
			OnCommand=function(self)
				self:x(offsetPlayer + (paddingMoreHearts * (i-1) ));
				self:y(offsetTop);
				self:zoom(zoomBaseNum);
			end;

			LoadActor(THEME:GetPathG("",pathHeartFull))..{
				Name="heartPlayerBase";
				OnCommand=function(self)
					self:visible(true);
				end;
			};

			LoadActor(THEME:GetPathG("",pathHeartFull))..{
				Name="heartPlayerBaseGlow";
				OnCommand=function(self)
					self:visible(true);
					self:queuecommand("Loop");
				end;
				LoopCommand=cmd(stoptweening;diffusealpha,0;zoom,1;linear,MedRateH;zoom,1+0.05;diffusealpha,.9;linear,MedRateH;zoom,1;diffusealpha,0;queuecommand,'Loop');

				LifeChangedMessageCommand=function(self,params)
					if params.Player ~= player then return end;
					local iLife = params.RealLife;
					if iLife <= 0 then
						self:visible(false);
					end;
				end;
			};

			LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/heart_empty"))..{
				Name="heartPlayerBaseEmpty";
				OnCommand=function(self)
					self:visible(false);
				end;
			};

			LifeChangedMessageCommand=function(self,params)
				if params.Player ~= player then return end;

				if usingHeartDecreaseMiss and modeUsed == "5missmax" then
					--multiple heart
					local this = self:GetChildren();
					local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
					local depleteHeart = false;

					if miss == 1 and i == 6 then
						depleteHeart = true;
					end;
					if miss == 2 and i == 5 then
						depleteHeart = true;	
					end;
					if miss == 3 and i == 4 then
						depleteHeart = true;	
						MedRateH = 0.4;
					end;
					if miss == 4 and i == 3 then
						depleteHeart = true;	
						MedRateH = 0.3;
					end;
					if miss == 5 and i == 2 then
						depleteHeart = true;
						MedRateH = 0.2;
					end;
					if miss == 6 and i == 1 then
						depleteHeart = true;	
					end;

					if depleteHeart then
						this.heartPlayerBase:visible(false);
						this.heartPlayerBaseGlow:visible(false);
						this.heartPlayerBaseEmpty:visible(true);
					end;

				else

					--1 heart.
					local this = self:GetChildren();
					local iLife = params.RealLife;
					if iLife <= 0 then
						this.heartPlayerBase:visible(false);
						this.heartPlayerBaseGlow:visible(false);
						this.heartPlayerBaseEmpty:visible(true);
					end;
				end;
			end;
		};
	end;

	return actorBaseFrame;

end;


function getLevelSong_StaticUI(player)
   
	local zoomBaseNum = 0.65;
	local zoomFont= 0.8;
	local offsetPlayer = 0;

	local offsetTop = SCREEN_TOP + 27;

	local offsetPlayerX = {0,0,0};
	if player == PLAYER_1 then
		offsetPlayer = SCREEN_LEFT + 41;	
		offsetPlayerX = {66,-28,15};	
	else
		offsetPlayer = SCREEN_RIGHT - 41;
		offsetPlayerX = {-66,-18,25};
	end;



	return Def.ActorFrame{
		
		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/Level/base"))..{
			Name="lvBase";
			--OnCommand=cmd(shadowlength,2;zoom,0.8;diffusealpha,0.8);
			OnCommand=function(self)
				self:zoom(0.7);
				self:diffuse(color("0,0,0,1"));
				self:diffusealpha(1);
				self:y(3);
				if player == PLAYER_1 then
					self:rotationy(180);
					self:x(4);
					
				end;
				if player == PLAYER_2 then
					self:x(0);
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/Level/base"))..{
			Name="lvBase";
			--OnCommand=cmd(shadowlength,2;zoom,0.8;diffusealpha,0.8);
			OnCommand=function(self)
				self:zoom(0.7);
				self:diffusealpha(0.8);
				if player == PLAYER_1 then
					self:rotationy(180);
					self:x(1);
				end;
				if player == PLAYER_2 then
					self:x(2);
				end;
			end;
		};



		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/Level/back_big"))..{
			Name="lvBaseGlow";
			--OnCommand=cmd(shadowlength,2;zoom,0.7;blend,"BlendMode_Add";diffusealpha,0.35);

			OnCommand=function(self)
				self:shadowlength(2);
				self:zoom(0.7);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.35);

				if player == PLAYER_1 then
					self:rotationy(180);
				end;

			end;

		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/Level/mark"))..{
			Name="lvBaseGlowLine";
			--OnCommand=cmd(shadowlength,2;zoom,0.7;blend,"BlendMode_Add";x,-100;y,-2);
			OnCommand=function(self)
				self:shadowlength(2);
				self:zoom(0.7);
				self:blend("BlendMode_Add");
				self:y(-2);

				if player == PLAYER_1 then
					self:x(100);
					self:rotationy(180);
				end;

				if player == PLAYER_2 then
					self:x(-100);
				end;
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelJudge";
			OnCommand=function(self)
				self:shadowlength(2);
				self:x(offsetPlayerX[1]);
				self:y(-5);
				self:zoom(zoomFont-0.15);
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelMode";
			OnCommand=function(self)
				self:shadowlength(2);
				self:settext("Lv");
				self:x(offsetPlayerX[2]);
				self:y(-3);			
				self:zoom(zoomFont);	

			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelNumber";
			OnCommand=function(self)
				self:shadowlength(2);
				self:x(offsetPlayerX[3]);
				self:y(-3);	
				self:zoom(zoomFont);			
			end;
		};

		LoadFont("Level")..{
			Name="fontLevelNumberCoop";
			OnCommand=function(self)
				self:shadowlength(2);
				self:x(offsetPlayerX[3]);
				self:y(-7);	
				self:zoom(0.38);	

				if player == PLAYER_1 then
					self:addx(-10);
				else
					self:addx(-30);
				end;

			end;
		};

		

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/Level/back_big"))..{
			Name="entryGlow";
			OnCommand=cmd(shadowlength,2;zoom,0.8;blend,"BlendMode_Add";queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(0.4);
				self:zoom(1.03);
				self:diffusealpha(0);

			end;
		};

		OnCommand=function(self)
			self:zoom(zoomBaseNum);
			--self:x(offsetPlayer);
			self:x(offsetPlayer);
			self:y(offsetTop);
			local this = self:GetChildren();
			
			local currentStep = GAMESTATE:GetCurrentSteps(player);
			local meter = currentStep:GetMeter();

			this.fontLevelNumber:settext(meter);

			local STATE = GAMESTATE:GetPlayerState(player);
			this.fontLevelJudge:settext("NJ");
			if STATE:GetPlayerOptions('ModsLevel_Preferred'):HardJudgement() then this.fontLevelJudge:settext("HJ"); end;
			if STATE:GetPlayerOptions('ModsLevel_Preferred'):VeryHardJudgement() then this.fontLevelJudge:settext("VJ"); end;			
			if STATE:GetPlayerOptions('ModsLevel_Preferred'):ExtraJudgement() then this.fontLevelJudge:settext("XJ"); end;
			if STATE:GetPlayerOptions('ModsLevel_Preferred'):UltraHardJudgement() then this.fontLevelJudge:settext("UJ"); end;
			if STATE:GetPlayerOptions('ModsLevel_Preferred'):EasyJudgement() then this.fontLevelJudge:settext("EJ"); end;

			if currentStep:GetStepsType() == 'StepsType_Pump_Single' then
				this.lvBaseGlow:diffuse(color("#ff0000"));
				this.lvBaseGlowLine:diffuse(color("#ff0000"));
			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Double' then
				this.lvBaseGlow:diffuse(color("#00ff00"));
				this.lvBaseGlowLine:diffuse(color("#00ff00"));		

			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
				this.lvBaseGlow:diffuse(color("#ff00ff"));	
				this.lvBaseGlowLine:diffuse(color("#ff00ff"));	
			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
				this.lvBaseGlow:diffuse(color("#0018cf"));	
				this.lvBaseGlowLine:diffuse(color("#0018cf"));	
			end;
			if  currentStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
				this.lvBaseGlow:diffuse(color("#00ffff"));	
				this.lvBaseGlowLine:diffuse(color("#00ffff"));
			end;			
			if currentStep:GetPlayers() ~= 1 then
				this.lvBaseGlow:diffuse(color("#ffff00"));			
				this.lvBaseGlowLine:diffuse(color("#ffff00"));
				local xplayers = "x"..currentStep:GetPlayers();
				this.fontLevelNumberCoop:settext(xplayers);
				this.fontLevelNumber:visible(false);
				this.fontLevelMode:visible(false);
			end;

		end;


	};

end;

-- COMPANION
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local companionSelected = getCustomOptionValuePlayer(PLAYER_1,"companion");
	local companionPath=GetCompanionExternalPath();

	if companionSelected ~= false then
		if companionSelected ~= nil and companionSelected ~= "none" then
			--mm maybe another check if the player delete the companion meanwhile he is playing...
			if FILEMAN:DoesFileExist(companionPath..companionSelected.."/companion.lua") then
				local companionLoad = LoadActor(companionPath..companionSelected.."/companion.lua");
				t[#t+1] = companionLoad(companionPath..companionSelected.."/",PLAYER_1);	
			end;	
		end;
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local companionSelected = getCustomOptionValuePlayer(PLAYER_2,"companion");

	if companionSelected ~= false then
		local companionPath=GetCompanionExternalPath();

		if companionSelected ~= nil and companionSelected ~= "none" then
			if FILEMAN:DoesFileExist(companionPath..companionSelected.."/companion.lua") then
				local companionLoad = LoadActor(companionPath..companionSelected.."/companion.lua");
				t[#t+1] = companionLoad(companionPath..companionSelected.."/",PLAYER_2);
			end;	
		end;
	end;
end;



if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	--Breakicon
	local breakIconP1 = getCustomOptionValuePlayer(PLAYER_1,"gameplay_break_icon_ui");
	
	if breakIconP1 == nil then
		breakIconP1 = false;
	end;

	if bShowLife or breakIconP1 then 
		t[#t+1] = getBreakIconPlayer_StaticUI(PLAYER_1);		
	end;

	--Lv display
	local levelDisplayP1 = getCustomOptionValuePlayer(PLAYER_1,"gameplay_lv_ui");
	if levelDisplayP1 == nil then
		levelDisplayP1 = false;
	end;

	if bShowSongLevel or levelDisplayP1 then 

		local schemePlayerSelected = getSkinSelectedInfoSchemePath(PLAYER_1);
		if schemePlayerSelected["default"] == false then

			local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Level");
			if isValid then
				local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Level/default.lua");
				t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_1);
			else
				t[#t+1] = getLevelSong_StaticUI(PLAYER_1);		
			end;

		else
			t[#t+1] = getLevelSong_StaticUI(PLAYER_1);	
		end;


		
	end;

end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	--Breakicon	
	local breakIconP2 = getCustomOptionValuePlayer(PLAYER_2,"gameplay_break_icon_ui");
	if breakIconP2 == nil then
		breakIconP2 = false;
	end;
	
	if bShowLife or breakIconP2 then 
		t[#t+1] = getBreakIconPlayer_StaticUI(PLAYER_2);		
	end;

	--Lv display
	local levelDisplayP2 = getCustomOptionValuePlayer(PLAYER_2,"gameplay_lv_ui");

	if levelDisplayP2 == nil then
		levelDisplayP2 = false;
	end;

	if bShowSongLevel or levelDisplayP2 then 

		local schemePlayerSelected = getSkinSelectedInfoSchemePath(PLAYER_2);
		if schemePlayerSelected["default"] == false then

			local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Level");
			if isValid then
				local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Level/default.lua");
				t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_2);
			else
				t[#t+1] = getLevelSong_StaticUI(PLAYER_2);		
			end;

		else
			t[#t+1] = getLevelSong_StaticUI(PLAYER_2);	
		end;

		
	end;	
end;


if UI_display_songTimeTopBar then
	t[#t+1] = songBar()..{InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-360);};
end;

--TIEMPO / TIME
if bShowTime or UI_display_song_time then

	--#### SCHEME MOD ###--
	local useSchemeModMusicDuration = false;
	local playerSchemeMusicDuration = nil;
	local pathLuaSchemeMusicDuration = "";

	if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
		-- two player
		local sPSelectedMusicDurationP1 = getSkinSelectedInfoSchemePath(PLAYER_1);
		local sPSelectedMusicDurationP2 = getSkinSelectedInfoSchemePath(PLAYER_2);

		if sPSelectedMusicDurationP1["default"] == false and sPSelectedMusicDurationP2["default"] then

			useSchemeModMusicDuration = true;
			playerSchemeMusicDuration = PLAYER_1;
			pathLuaSchemeMusicDuration= sPSelectedMusicDurationP1["pathLua"];

		elseif sPSelectedMusicDurationP1["default"] and sPSelectedMusicDurationP2["default"] == false then

			useSchemeModMusicDuration = true;
			playerSchemeMusicDuration = PLAYER_2;
			pathLuaSchemeMusicDuration = sPSelectedMusicDurationP2["pathLua"];

		elseif sPSelectedMusicDurationP1["default"] == false and sPSelectedMusicDurationP2["default"] == false then

			if sPSelectedMusicDurationP1["name"] == sPSelectedMusicDurationP2["name"] then
				useSchemeModMusicDuration = true;
				playerSchemeMusicDuration = PLAYER_1;
				pathLuaSchemeMusicDuration= sPSelectedMusicDurationP1["pathLua"];
			else
				useSchemeModMusicDuration = false;
			end;
		else
			useSchemeModMusicDuration = false;
		end;
	else
		--one player
		local sPSelectedMusicDuration = getSkinSelectedInfoSchemePath(GAMESTATE:GetMasterPlayerNumber());
		if sPSelectedMusicDuration["default"] == false then
			useSchemeModMusicDuration = true;
			playerSchemeMusicDuration = GAMESTATE:GetMasterPlayerNumber();
			pathLuaSchemeMusicDuration= sPSelectedMusicDuration["pathLua"];
		end;
	end;

	--Validate the mod.
	local isValidSchemeMusicDuration = false;
	if useSchemeModMusicDuration then
		isValidSchemeMusicDuration = checkLuaSkinSelectedInfoScheme(pathLuaSchemeMusicDuration,"MusicDuration");
	end;

	if isValidSchemeMusicDuration then
		--Load MOD

		local actorFuncMusicDuration = LoadActor(pathLuaSchemeMusicDuration.."MusicDuration/default.lua");
		t[#t+1] = actorFuncMusicDuration(pathLuaSchemeMusicDuration,playerSchemeMusicDuration);

	else
		--Load DEFAULT

		local player = GAMESTATE:GetMasterPlayerNumber();
		local songPosition = GAMESTATE:GetPlayerState(player):GetSongPosition();
		local song = GAMESTATE:GetCurrentSong();	

		local totalseconds = 0;
		local lastSecondSong = song:GetLastSecond() or 0;
		local SongTotalSeconds = song:MusicLengthSeconds() or 0;


		if lastSecondSong == 0 and SongTotalSeconds == 0 then -- no data for the time.
			return;
		elseif SongTotalSeconds > 0 then
			totalseconds = SongTotalSeconds;
		elseif lastSecondSong > 0 then 
			totalseconds = lastSecondSong;
		end;

		if totalseconds == 0 then -- just in case lol
			return;
		end;

		local lTimer;
		local tFormat = nil

		if totalseconds < 600 then
			tFormat = SecondsToMSS;
		elseif totalseconds >= 360 and totalseconds < 3600 then
			tFormat = SecondsToMMSS;
		elseif totalseconds >= 3600 and totalseconds < 36000 then
			tFormat = SecondsToHMMSS;
		else
			tFormat = SecondsToHHMMSS;
		end;

		local function Update (self)
			if songPosition:GetMusicSeconds() < 0 then
				lTimer:settext(tFormat(totalseconds));
				return;
			end
			lTimer:settext(tFormat(clamp(totalseconds - (songPosition:GetMusicSeconds()), 0, totalseconds)));
		end;
		
		t[#t+1] = LoadFont("_karnivore lite white 20px")..{
			InitCommand=function(self)
				lTimer = self;
				self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM - 40);
				self:shadowlength(2);
			end;
		};

		t[#t+1] =  Def.ActorFrame
		{
			InitCommand=function(self)
				self:SetUpdateFunction(Update);
			end;
		};

	end;
end;

--### GAMEPLAY UI SLOT ITEMS ###---
function getGameplayUiSlotItems(player)

	local uiItemsListH = {}; -- aca guardamos los slots programados.
	local slotUsedItemsUi = {};--aca guardamos los que estan activos para que tengan un orden xD
	--name,height
	uiItemsListH = {	
			{"judgdata", 168},
			{"score", 50},
			{"fastslow", 67},
	};

	local extraJudgmentSetted = GAMESTATE:GetExtraJudgment();
	if extraJudgmentSetted == false then
		uiItemsListH = {	
				{"judgdata", 143},
				{"score", 50},
				{"fastslow", 67},
		};
	end;

	-- obtenemos si es que estan activos los items en el ui.
	local judgDataUi = getCustomOptionValuePlayer(player,"gameplay_stats_ui");
	local scoreDataUi = getCustomOptionValuePlayer(player,"gameplay_score_ui");
	local scorePercentaje = getCustomOptionValuePlayer(player,"gameplay_score_percentaje_ui");
	local fastslowUi = getCustomOptionValuePlayer(player,"gameplay_fastslow");

	
	
	if judgDataUi == nil then
		judgDataUi = false;
	end;

	if scoreDataUi == nil then
		scoreDataUi = false;
	end;

	if fastslowUi == nil then
		fastslowUi = false;
	end;

	if judgDataUi ~= nil and judgDataUi == true then
		table.insert(slotUsedItemsUi,uiItemsListH[1]);
	end;

	if scoreDataUi ~= nil and scoreDataUi == true then
		table.insert(slotUsedItemsUi,uiItemsListH[2]);
	elseif scorePercentaje ~= nil and scorePercentaje == true then
		table.insert(slotUsedItemsUi,uiItemsListH[2]);
	end;	

	if fastslowUi ~= nil and fastslowUi == true then
		table.insert(slotUsedItemsUi,uiItemsListH[3]);
	end;

	return slotUsedItemsUi;
end;

function createStatJudgmentUiPlayer(player,pos_height,zoomBasePanel)

	local fontJudg="_karnivore lite white 20px";
	local zoomBaseNum = zoomBasePanel;

	local xBase=-80;
	local yBase=43;
	local yOffsetData=28.8; -- separacion entre dato

	local offsetPlayer = 0;	
	if player == PLAYER_1 then
		offsetPlayer = -535;
	else
		offsetPlayer = 635;
	end;

	local extraJudgmentSetted = GAMESTATE:GetExtraJudgment();
	local yPaddingNoex = 0;

	local spriteJudg = "judg_b";
	if extraJudgmentSetted == false then
		spriteJudg = "judg_noex";
		yPaddingNoex = -29;
	end;

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/"..spriteJudg))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2);					
		};	

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/"..spriteJudg))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2);					
		};	


		LoadFont(fontJudg)..{
			Name="perfectplus";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};

		LoadFont(fontJudg)..{
			Name="perfect";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*1));
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");

					if extraJudgmentSetted == false then
						self:visible(false);
					end;

			end;
		};

		LoadFont(fontJudg)..{
			Name="great";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*2) + yPaddingNoex);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};


		LoadFont(fontJudg)..{
			Name="good";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*3) + yPaddingNoex);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};

		LoadFont(fontJudg)..{
			Name="bad";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*4) + yPaddingNoex);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};


		LoadFont(fontJudg)..{
			Name="miss";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*5) + yPaddingNoex);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/"..spriteJudg))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2;blend,"BlendMode_Add";queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(0.4);
				self:zoom(1.03);
				self:diffusealpha(0);
			end;

		};	

		OnCommand=function(self)
			self:zoom(zoomBaseNum);
			self:x(SCREEN_CENTER_X+offsetPlayer);
			self:y(pos_height);			
		end;

		JudgmentMessageCommand=function(self,param)
			if param.Player ~= player then return end;
			self:queuecommand("DrawData");
		end;

		DrawDataCommand=function(self)
			--esta jugando con extra judgment?
			local extraJudgment = GAMESTATE:GetExtraJudgment();
			local pfplus = 0;
			local pf = 0;

			local checkpointPerfect =STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");
			if extraJudgment then
				pfplus = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1") + checkpointPerfect;
				pf = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2");
			else
				pfplus = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1") + STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2") + checkpointPerfect;
				pf = 0;
			end;

 	
			local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
			local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
			local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
			local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");

			local this = self:GetChildren();
			this.perfectplus:settext(pfplus);
			this.perfect:settext(pf);
			this.great:settext(gr);
			this.good:settext(gd);
			this.bad:settext(bd);
			this.miss:settext(miss);	
		end;
	};


end;

function createScoreUiPlayer(player,pos_height,zoomBasePanel)

	local fontJudg="_karnivore lite white 20px";
	local zoomBaseNum = zoomBasePanel;

	local xBase=-64;
	local yBase=40;

	local offsetPlayer = 0;	
	if player == PLAYER_1 then
		offsetPlayer = -535;
	else
		offsetPlayer = 635;
	end;

	local scorePercentaje = getCustomOptionValuePlayer(player,"gameplay_score_percentaje_ui");
	if scorePercentaje == nil then
		scorePercentaje = false;
	end;

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/scoredata"))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2);					
		};	
	
		LoadFont(fontJudg)..{
			Name="scorePlayer";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase);
					self:x(xBase-2);
					self:zoom(1.2);
					if scorePercentaje then
						self:settext("0%");
						self:x(xBase+4);
						self:y(yBase+1);
						self:zoom(1.3);
					else
						self:settext("0");
					end;
					
					self:horizalign("center");
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/scoredata"))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2;blend,"BlendMode_Add";queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(0.4);
				self:zoom(1.03);
				self:diffusealpha(0);
			end;
		};	

		OnCommand=function(self)
			self:zoom(zoomBaseNum);
			self:x(SCREEN_CENTER_X+offsetPlayer);
			self:y(pos_height);			
		end;

		JudgmentMessageCommand=function(self,param)
			if param.Player ~= player then return end;
			self:queuecommand("DrawData");
		end;

		DrawDataCommand=function(self)
			local this = self:GetChildren();
			local score = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPhoenixScore();
			local percentaje = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentScore();
			
			if scorePercentaje then
				local percData ="0"
				if percentaje == 100 then
					percData = "100";
				else
					percData = string.format("%.2f", truncateToTwoDecimals(percentaje));
				end;
				this.scorePlayer:settext(percData.."%");
			else
				this.scorePlayer:settext(formatNumberWithDots(score));
			end;

--[[
			if scorePercentaje then
				local percData ="0"
				if score / 10000 == 100 then
					percData = "100";
				else
					percData = string.format("%.2f", truncateToTwoDecimals(score / 10000));
				end;
				this.scorePlayer:settext(percData.."%");
			else
				this.scorePlayer:settext(formatNumberWithDots(score));
			end;
]]
			
		end;
	};


end;



local function mapValue(value)
    local maxInput = 150
    local maxOutput = 92    
    return value * (maxOutput / maxInput)
end

local dataJudgBox = {
	{badzoom=228,badx=0,goodzoom=200,goodx=12,greatzoom=144,greatx=14,perfectzoom=97,perfectx=14,mperfectzoom=35,mperfectx=14},--ej
	{badzoom=214,badx=7,goodzoom=180,goodx=12,greatzoom=130,greatx=14,perfectzoom=75,perfectx=14,mperfectzoom=35,mperfectx=14},--nj
	{badzoom=205,badx=10,goodzoom=159,goodx=12,greatzoom=110,greatx=12,perfectzoom=52,perfectx=12,mperfectzoom=35,mperfectx=14},--hj
	{badzoom=165,badx=12,goodzoom=120,goodx=12,greatzoom=77,greatx=14,perfectzoom=35,perfectx=14,mperfectzoom=25,mperfectx=14},--vj
	{badzoom=85,badx=12,goodzoom=65,goodx=12,greatzoom=48,greatx=14,perfectzoom=25,perfectx=12,mperfectzoom=25,mperfectx=12},--xj
	{badzoom=54,badx=12,goodzoom=44,goodx=12,greatzoom=34,greatx=12,perfectzoom=25,perfectx=12,mperfectzoom=25,mperfectx=12},--uj
}

function createTimingBarForPlayer(player)
	local posX = 0;
	local posY = SCREEN_CENTER_Y-120;
	local zoomBase = 1.2;
	local diffuseBase = 0.8;
	local fbottom=0;
	local ftop=0;
	local dataJudgSelected = dataJudgBox[2];


	local STATE = GAMESTATE:GetPlayerState(player);
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):EasyJudgement() then dataJudgSelected = dataJudgBox[1] end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):HardJudgement() then dataJudgSelected = dataJudgBox[3] end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):VeryHardJudgement() then dataJudgSelected = dataJudgBox[4] end;			
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):ExtraJudgement() then dataJudgSelected = dataJudgBox[5]  end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):UltraHardJudgement() then dataJudgSelected = dataJudgBox[6]  end;


	if player == PLAYER_1 then
		posX = SCREEN_CENTER_X - 240;
	else
		posX = SCREEN_CENTER_X + 240;
	end;

	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
		posX = SCREEN_CENTER_X;
	end;

	if GAMESTATE:GetNumSidesJoined() == 1 then
		if PREFSMAN:GetPreference("Center1Player") then
	    	posX = SCREEN_CENTER_X;
		end;

		if GAMESTATE:GetQuestZoneChannel() then
			posX = SCREEN_CENTER_X;
		end;

		if GAMESTATE:GetGameMode() == "WorldMax" then
			posX = SCREEN_CENTER_X;
		end;

		if GAMESTATE:GetGameMode() == "QuestWorld" then
			posX = SCREEN_CENTER_X;
		end;

	end;

	return Def.ActorFrame{
		OnCommand=function(self)
				self:x(posX);
				self:y(posY);
				self:zoom(zoomBase);
				self:diffusealpha(1);
		end;

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/timingBar"))..{
			OnCommand=function(self)
				self:zoom(1);
				self:zoomy(0.5);
			end;
		};

		Def.ActorFrame{
			OnCommand=function(self)
				--self:zoomy(0.3);
				self:zoomy(0.22);

			end;
			LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/timingBar"))..{
				OnCommand=function(self)
					self:zoom(1);
					self:zoomy(0.6);
				end;
			};

		    Def.Quad {
		    	Name="missBSide";
		        InitCommand = function(self)
		            self:zoomto(225, 8):diffuse(color("#fc0303")):diffusealpha(0.4);
		            self:x(0);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		    };

		    Def.Quad {
		    	Name="badBSide";
		        InitCommand = function(self)
		            self:zoomto(dataJudgSelected["badzoom"], 8):diffuse(color("#ff00f7")):diffusealpha(diffuseBase);
		            self:x(dataJudgSelected["badx"]);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		    };

		    Def.Quad {
		    	Name="goodBSide";
		        InitCommand = function(self)
		            self:zoomto(dataJudgSelected["goodzoom"], 8):diffuse(color("#ffea00")):diffusealpha(diffuseBase);
		            self:x(dataJudgSelected["goodx"]);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		    };

		    Def.Quad {
		    	Name="greattBSide";
		        InitCommand = function(self)
		            self:zoomto(dataJudgSelected["greatzoom"], 8):diffuse(color("#00ff2a")):diffusealpha(diffuseBase);
		            self:x(dataJudgSelected["greatx"]);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		    };

		    Def.Quad {
		    	Name="perfectBSide";
		        InitCommand = function(self)
		            self:zoomto(dataJudgSelected["perfectzoom"], 8):diffuse(color("#006aff")):diffusealpha(diffuseBase+0.2);
		            self:x(dataJudgSelected["perfectx"]);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		    };

		    Def.Quad {
		    	Name="mperfectBSide";
		        InitCommand = function(self)
		            self:zoomto(dataJudgSelected["mperfectzoom"], 8):diffuse(color("#00fff7")):blend("BlendMode_Add"):diffusealpha(0.15);
		            self:x(dataJudgSelected["mperfectx"]);
		            self:fadebottom(fbottom);
		            self:fadetop(ftop);
		        end;
		        OnCommand=function(self)
					local extraJudgment = GAMESTATE:GetExtraJudgment();
					if extraJudgment == false then
						self:visible(false);
					end;
		        end;
		    };
		};

	    Def.Quad {
	    	Name="centerBar";
	        InitCommand = function(self)
	            self:zoomto(3, 8):diffuse(1, 1, 1, 1);
	            self:x(0);
	        end;
	    };

	    Def.Quad {
	    	Name="timingbar";
	        InitCommand = function(self)
	            self:zoomto(3, 8):diffuse(1, 0, 0, 1);
	            self:x(0);
	        end;
	    };


		JudgmentMessageCommand=function(self,param)
			if param.Player ~= player then 				
				return 
			end;

			if param.TapNoteScore == "TapNoteScore_CheckpointHit" or param.TapNoteScore == "TapNoteScore_CheckpointMiss" then
				return;
			end;

			if param.TapNoteScore == "TapNoteScore_Miss" or param.TapNoteScore == "TapNoteScore_CheckpointMiss" then
				return;
			end;

			noteOffset = param.TapNoteOffset and math.floor(param.TapNoteOffset * 1000 + 0.5) or nil;
			local valueOnGraph = mapValue(noteOffset);
			self:stoptweening():diffusealpha(1):sleep(0.5):linear(0.5):diffusealpha(0);
			self:GetChild("timingbar"):stoptweening():x(valueOnGraph):diffusealpha(1):linear(2):diffusealpha(0);
		end;
	};
end;

function createFastSlowUiPlayer(player,pos_height,zoomBasePanel)

	local fontJudg="_karnivore lite white 20px";
	local zoomBaseNum = zoomBasePanel;

	local xBase=-53;
	local yBase=35;
	local xBaseTipCenter = -63;

	local offsetPlayer = 0;	
	if player == PLAYER_1 then
		offsetPlayer = -535;
	else
		offsetPlayer = 635;
	end;

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/fastslowdata"))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2);					
		};	

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/tipfastslow"))..{
			Name="tipoFastSlow";
			--   -55= 100% fast  55=100% slow
			OnCommand=cmd(halign,1;valign,0;shadowlength,0;zoom,1;zoomy,1.5;y,yBase+39;x,xBaseTipCenter);					
		};				

		LoadFont(fontJudg)..{
			Name="fastPlayer";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};

		LoadFont(fontJudg)..{
			Name="slowPlayer";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+25);
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/fastslowdata"))..{
			OnCommand=cmd(halign,1;valign,0;shadowlength,2;blend,"BlendMode_Add";queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(0.4);
				self:zoom(1.03);
				self:diffusealpha(0);
			end;
		};	


		OnCommand=function(self)
			self:zoom(zoomBaseNum);
			self:x(SCREEN_CENTER_X+offsetPlayer);
			self:y(pos_height);			
		end;

		JudgmentMessageCommand=function(self,param)
			if param.Player ~= player then return end;
			local this = self:GetChildren();
			local extraJudgment = GAMESTATE:GetExtraJudgment();
			local totalTimingErrors=0;
			local tipBalancePlayer = 0.5;
			if player == PLAYER_1 then
				if extraJudgment then
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							fastP1 = fastP1 + 1;
						end;				

						if not param.Early then
							slowP1 = slowP1 + 1;
						end;
					end;
				else
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_W2" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							fastP1 = fastP1 + 1;
						end;				

						if not param.Early then
							slowP1 = slowP1 + 1;
						end;
					end;

				end;
				GAMESTATE:Env()["fastp1"] = fastP1;
				GAMESTATE:Env()["slowp1"] = slowP1;	

				this.fastPlayer:settext(fastP1);
				this.slowPlayer:settext(slowP1);	
				totalTimingErrors = fastP1 + slowP1;
				tipBalancePlayer = 0.5 + ((fastP1 - slowP1) / (2 * totalTimingErrors));	
			end;

			if param.Player == PLAYER_2 then
				if extraJudgment then

					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							fastP2 = fastP2 + 1;
						end;				

						if not param.Early then
							slowP2 = slowP2 + 1;
						end;
					end;
				else
					if param.TapNoteScore ~= "TapNoteScore_W1" and param.TapNoteScore ~= "TapNoteScore_W2" and param.TapNoteScore ~= "TapNoteScore_Miss" and param.TapNoteScore ~= "TapNoteScore_CheckpointMiss" and param.TapNoteScore ~= "TapNoteScore_CheckpointHit" then
						if param.Early then
							fastP2 = fastP2 + 1;
						end;				

						if not param.Early then
							slowP2 = slowP2 + 1;
						end;
					end;
				end;

				GAMESTATE:Env()["fastp2"] = fastP2;
				GAMESTATE:Env()["slowp2"] = slowP2;

				this.fastPlayer:settext(fastP2);
				this.slowPlayer:settext(slowP2);
				totalTimingErrors = fastP2 + slowP2;

				--Movemos el tip dependiendo de como va.
				-- 0.5 cera centro 1 totalmente fast, 0 totalmente slow
				tipBalancePlayer = 0.5 + ((fastP2 - slowP2) / (2 * totalTimingErrors));
			end;

			local tipPosActual = (tipBalancePlayer - 0.5) * 110;
			this.tipoFastSlow:x(xBaseTipCenter+tipPosActual);

		end;
	};
end;

--APPLY SLOT ITEMS
local topBaseHeightUiItems = SCREEN_TOP + 50; -- desde que Y comienzan a dibujarse los items del ui.
local marginYBaseItems = 8; -- 4 piexels de margen entre items

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local listaUiGameplayItems = getGameplayUiSlotItems(PLAYER_1);
	local heightUsed = 0;
	if #listaUiGameplayItems > 0 then	
		for i = 1,#listaUiGameplayItems,1 do		

			local schemePlayerSelected = getSkinSelectedInfoSchemePath(PLAYER_1);

			if listaUiGameplayItems[i][1] == "judgdata" then
				--here we check if the player has selected an external ui item, if so, we load that lua :P
				local yItem = heightUsed;
				if schemePlayerSelected["default"] == false then

					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Judgment");
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Judgment/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_1);
					else
						t[#t+1] = createStatJudgmentUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);
					end;
				else					
					t[#t+1] = createStatJudgmentUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);							
				end;
			end;

			if listaUiGameplayItems[i][1] == "score" then

				local yItem = heightUsed;
				if schemePlayerSelected["default"] == false then

					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Score");					
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Score/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_1);
					else
						t[#t+1] = createScoreUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);	
					end;

				else
					
					t[#t+1] = createScoreUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);
				end;

		
			end;

			if listaUiGameplayItems[i][1] == "fastslow" then	

				local yItem = heightUsed;
				if schemePlayerSelected["default"] == false then

					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Timing");	
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Timing/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_1);
					else
						t[#t+1] = createFastSlowUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);
					end;

				else
					
					t[#t+1] = createFastSlowUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);
				end;
			end;

			heightUsed = heightUsed + (marginYBaseItems + listaUiGameplayItems[i][2]); 
		end;
	end;
end;


if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local listaUiGameplayItems = getGameplayUiSlotItems(PLAYER_2);
	local heightUsed = 0;
	if #listaUiGameplayItems > 0 then	

	local schemePlayerSelected = getSkinSelectedInfoSchemePath(PLAYER_2);

		for i = 1,#listaUiGameplayItems,1 do

			if listaUiGameplayItems[i][1] == "judgdata" then

				local yItem = heightUsed; -- default
				if schemePlayerSelected["default"] == false then

					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Judgment");
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Judgment/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_2);
					else
						t[#t+1] = createStatJudgmentUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);
					end;

				else
					t[#t+1] = createStatJudgmentUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);
				end;

			end;

			if listaUiGameplayItems[i][1] == "score" then

				local yItem = heightUsed;
				if schemePlayerSelected["default"] == false then
					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Score");					
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Score/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_2);
					else
						t[#t+1] = createScoreUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);	
					end;

				else
					
					t[#t+1] = createScoreUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);					
				end;
	
			end;

			if listaUiGameplayItems[i][1] == "fastslow" then

				local yItem = heightUsed;
				if schemePlayerSelected["default"] == false then

					local isValid = checkLuaSkinSelectedInfoScheme(schemePlayerSelected["pathLua"],"Timing");	
					if isValid then
						local actorFunc = LoadActor(schemePlayerSelected["pathLua"].."Timing/default.lua");
						t[#t+1] = actorFunc(schemePlayerSelected["pathLua"],PLAYER_2);
					else
						t[#t+1] = createFastSlowUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);
					end;

				else
					
					t[#t+1] = createFastSlowUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);
				end;

			end;

			heightUsed = heightUsed + (marginYBaseItems + listaUiGameplayItems[i][2]); 
		end;

	end;
end;

--TIMING BAR
if GAMESTATE:IsHumanPlayer(PLAYER_1) then

	local timingBar = getCustomOptionValuePlayer(PLAYER_1,"gameplay_timingbar");
	if timingBar == nil then
		timingBar = false;
	end;

	if timingBar then
		t[#t+1] = createTimingBarForPlayer(PLAYER_1);
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local timingBar = getCustomOptionValuePlayer(PLAYER_2,"gameplay_timingbar");
	if timingBar == nil then
		timingBar = false;
	end;
	if timingBar then
		t[#t+1] = createTimingBarForPlayer(PLAYER_2);
	end;	
end;

--## END GAMEPLAY UI ##--

--EXTRA STATS (GRAFICOS)

t[#t+1] = LoadActor(THEME:GetPathB("","SurvivalMode/OnGamePlay")) .. { };

-- MENU PAUSE
--=========================================================================================
ButtonName = {	-- renombramiento de botones
	MenuUp = "UpLeft";
	MenuDown = "UpRight";
	MenuLeft = "DownLeft";
	MenuRight = "DownRight";
	Back = "Back";
	Start = "Center";
	Select = "CommandW";
};

local bpauseST = {
	"Continue";
	"Restart";
	"Return";
	--"Skip";
};

ScrollerItems = {};
ispaused = false;
allowMenuPause = true
iMenuP = 0;

local function ginput(event)
	if event.type == "InputEventType_FirstPress" then

			if ispaused then

				local DI_Button = event.DeviceInput.button;
				DI_Button = string.sub(DI_Button,#DI_Button-4,#DI_Button);
				if string.lower(DI_Button) == "scape" then
					iMenuP = 0;
					MESSAGEMAN:Broadcast("CenterButtonPress",params);
					return;
				end;
			end;

			local DI_Button = event.DeviceInput.button;
			DI_Button = string.sub(DI_Button,#DI_Button-4,#DI_Button);
			
			local params = {};
			
			params.Player = event.PlayerNumber;
			params.Pause = not ispaused;
			if --[[string.lower(DI_Button) == "enter" or]] string.lower(DI_Button) == "scape" then
				MESSAGEMAN:Broadcast("StartButtonPressed",params);
				return;
			end;

			if ispaused then
				local iButton = ButtonName[event.GameButton] or nil
				if iButton then
					params.Button = iButton;
					MESSAGEMAN:Broadcast(iButton.."ButtonPress",params);
				end;
			end;
	end;
end;



for k = 1, #bpauseST do
	ScrollerItems[#ScrollerItems+1] = Def.ActorFrame {	Name=bpauseST[k];
		LoadFont("_TitleXolonium")..{
			Name="Text"; Text=THEME:GetString("MenuPauseTitles",bpauseST[k]);
			InitCommand=cmd(zoom,0.9;maxwidth,210;skewx,-.225;shadowlength,1;vertalign,bottom;);
		};
	};
end;

t[#t+1] =Def.ActorFrame{
	InitCommand=cmd(draworder,100;y,-150);
	--Def.Quad {	Name="Quad";
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/bg/back3"))..{
	--LoadActor(GetElement("bg/back3","SelectMusic"))..{
		Name="Quad";
		OnCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT+300;);	--diffuse,color("0,0,0,0.8");
	};
	LoadFont("Russo_One/Russo One 40px")..{	Name="sPaused";	Text="PAUSED GAME";
		InitCommand=cmd(zoom,1.2;Center;addy,60;diffuseshift;effectcolor1,color("#FFFFFF");effectcolor2,color("#aeaeae"););
	};
	LoadFont("Tomorrow/Tomorrow outline 40px")..{	Name="Desc";	Text="Description Here...";
		InitCommand=cmd(zoom,.56;Center;addy,250;);
	};
	LoadActor(THEME:GetPathS("","S_CMD_MOVE"))..{	Name="sMove";	};
	LoadActor(THEME:GetPathS("","S_CMD_INOUT"))..{	Name="sInOut";	};
	Def.ActorScroller {
		Name="GroupScroller";
		SecondsPerItem=.2;
		InitCommand=function(self)
			self:SetLoop(false):
				SetWrap(false):
				SetFastCatchup(true):
				SetDrawByZPosition(true);
			self:SetCurrentAndDestinationItem(iMenuP);
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			local ry = math.min(math.max(offset,-1),1);
			self:zoom(1.25-(math.min(math.abs(offset),1)*.25));
			self:diffusealpha(1-(math.min(math.abs(offset),1)*0.36));
			self:x(240*(itemIndex-((numItems+1)/2)+1));
			self:y((math.min(math.abs(offset),1)*12));
		end;
		children = ScrollerItems;
		OnCommand=cmd(Center;addy,160;);
	};
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(ginput);
		self:GetChild("sPaused"):visible(ispaused);
		self:GetChild("Quad"):visible(ispaused);
		self:GetChild("GroupScroller"):visible(ispaused);
		self:GetChild("Desc"):visible(ispaused);
	end;
	DownLeftButtonPressMessageCommand=function(self)
		if not allowMenuPause then return end;
		if iMenuP > 0 then
			iMenuP = iMenuP-1;
			self:GetChild("sMove"):play();
			self:GetChild("Desc"):settext(THEME:GetString("MenuPauseDescs",bpauseST[iMenuP+1]));
			self:GetChild("GroupScroller"):finishtweening():SetDestinationItem(iMenuP);
		end;
	end;
	DownRightButtonPressMessageCommand=function(self)
		if not allowMenuPause then return end;
		if iMenuP < #bpauseST-1 then
			iMenuP = iMenuP+1;
			self:GetChild("sMove"):play();
			self:GetChild("Desc"):settext(THEME:GetString("MenuPauseDescs",bpauseST[iMenuP+1]));
			self:GetChild("GroupScroller"):finishtweening():SetDestinationItem(iMenuP);
		end;
	end;
	CenterButtonPressMessageCommand=function(self)
		if not allowMenuPause then return end;
		self:GetChild("sInOut"):play();
		if iMenuP == 0 then										--continue
			ispaused = not ispaused;
			SCREENMAN:GetTopScreen():PauseGame(ispaused);
			self:GetChild("sPaused"):visible(ispaused);
			self:GetChild("Quad"):visible(ispaused);
			self:GetChild("GroupScroller"):visible(ispaused);
			self:GetChild("Desc"):visible(ispaused);
		elseif iMenuP == 1 then									--restart
			local ret = SCREENMAN:GetTopScreen():restart_gameplay();
		elseif iMenuP == 2 then									--return
			self:GetChild("Quad"):diffusealpha(.95);
			self:GetChild("sPaused"):visible(not ispaused);
			self:GetChild("GroupScroller"):visible(not ispaused);
			self:GetChild("Desc"):visible(not ispaused);
			SCREENMAN:GetTopScreen():begin_backing_out();
		elseif iMenuP == 3 then									--finish
			self:GetChild("Quad"):diffusealpha(1);
			self:GetChild("sPaused"):visible(not ispaused);
			self:GetChild("GroupScroller"):visible(not ispaused);
			self:GetChild("Desc"):visible(not ispaused);
			SCREENMAN:GetTopScreen():give_up();
			SCREENMAN:GetTopScreen():PauseGame(not ispaused);
		end;
	end;
	StartButtonPressedMessageCommand=function(self)
		if not allowMenuPause then return end;
		if ispaused then
			self:playcommand("CenterButtonPress");
			return;
		end;
		ispaused = not ispaused;
			SCREENMAN:GetTopScreen():PauseGame(ispaused);
		self:GetChild("sInOut"):play();
		self:GetChild("sPaused"):visible(ispaused);
		self:GetChild("Quad"):visible(ispaused);
		self:GetChild("GroupScroller"):visible(ispaused);
		self:GetChild("GroupScroller"):SetCurrentAndDestinationItem(iMenuP);

			if not ispaused then
				iMenuP = 0;
				self:GetChild("GroupScroller"):SetCurrentAndDestinationItem(iMenuP);
			end;
		self:GetChild("Desc"):visible(ispaused):settext(THEME:GetString("MenuPauseDescs",bpauseST[iMenuP+1]));
	end;
	SaniNetClientStateMessageCommand=function(self,params)
		if params.Username ~= '' then
			allowMenuPause = false;
		end;
	end;
};

--ADD ON :: TIMING DATA
t[#t+1] = LoadActor("ScreenGameplayAddOn/TimingDataForPlayers") .. {
	InitCommand=cmd();
};


--VS MODE
if GAMESTATE:GetNumSidesJoined() == 2 and checkVsMode() then

	local hashChartP1 =  GAMESTATE:GetCurrentSteps(PLAYER_1):GetHash();
	local hashChartP2 =  GAMESTATE:GetCurrentSteps(PLAYER_2):GetHash();

	if hashChartP1 == hashChartP2 then
		--VSMODE
		t[#t+1] = LoadActor("ScreenGameplayAddOn/vsMode") .. {

		};
	end;


end;


t[#t+1] = LoadActor(THEME:GetPathB("","ReactsOverlay")) .. { };


return t