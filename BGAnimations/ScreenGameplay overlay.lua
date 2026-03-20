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
};

local stage= GAMESTATE:GetCurrentStageIndex()+1;
local oldnoteskin={};
local TweakY = 28;
setStageCounterInGameplay(true);


function songBar()
	return 	Def.SongMeterDisplay {
		OnCommand=function(self)
			if isAspectRatio1610() then
				self:y(SCREEN_TOP+1);
			end;
		end;		
		StreamWidth=SCREEN_WIDTH;
		Stream=Def.Quad { 
			InitCommand=cmd(diffusealpha,1;draworder,99;zoomto,1,4;diffuse,color("#ffffff")); 
		};
		Tip=LoadActor(THEME:GetPathG("","ScreenGameplay/song position tip"));
	};
end;

--[[
--:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
--Lifebar Options::
--suddendeath = 1 miss break song
--5missmax = at 6 miss break song
--pfcmode = anything below perfect break song

local failSettingP1 = "";
local failSettingP2 = "";
local typeExtraLifeBarP1 = "none";
local typeExtraLifeBarP2 = "none";

if GAMESTATE:IsHumanPlayer(PLAYER_1)  then
	failSettingP1 = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();
	local exlP1Temp = getCustomOptionValuePlayer(PLAYER_1,"lifebar_extra_mode");
	if exlP1Temp == nil then
		typeExtraLifeBarP1 = "none";
	else
		typeExtraLifeBarP1 = exlP1Temp;
	end;

end;

if GAMESTATE:IsHumanPlayer(PLAYER_2)  then
	failSettingP2 = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();
	local exlP2Temp =  getCustomOptionValuePlayer(PLAYER_2,"lifebar_extra_mode");
	if exlP2Temp == nil then
		typeExtraLifeBarP2 = "none";
	else
		typeExtraLifeBarP2 = exlP2Temp;
	end;	
end;

local statusFailPlayerLifeBarExtra = {false,false};

t[#t+1] = Def.Quad {
		InitCommand=cmd(zoomto,0,0;visible,false);
		JudgmentMessageCommand=function(self,param)

			if typeExtraLifeBarP2 == "none" and typeExtraLifeBarP1 == "none" then
				--nada
			else
				if param.Player == PLAYER_1 then

					local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W3");
					local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W4");
					local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W5");
					local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
					local allTns = gr+gd+bd+miss;

					if typeExtraLifeBarP1 == "suddendeath" then
						if miss > 0 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[1] = true;
							--SCREENMAN:SetNewScreen("ScreenStageBreak");
						end;
					end;

					if typeExtraLifeBarP1 == "5missmax" then
						if miss > 5 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[1] = true;
							--SCREENMAN:SetNewScreen("ScreenStageBreak");
						end;
					end;

					if typeExtraLifeBarP1 == "pfcmode" then
						if allTns > 0 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[1] = true;
							--SCREENMAN:SetNewScreen("ScreenStageBreak");
						end;
					end;

					if typeExtraLifeBarP1 == "none" then
						if failSettingP1 == "FailType_Immediate" then
							--debemos saber si estas muerto para cambiar el estado.
							local isFailedp1Aux =STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetFailedAux();
							statusFailPlayerLifeBarExtra[1] = isFailedp1Aux;
						end;
					end;

				end;



				if param.Player == PLAYER_2 then

					local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W3");
					local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W4");
					local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_W5");
					local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
					local allTns = gr+gd+bd+miss;

					if typeExtraLifeBarP2 == "suddendeath" then
						if miss > 0 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[2] = true;
							SCREENMAN:SetNewScreen("ScreenFastStageBreak");
						end;
					end;

					if typeExtraLifeBarP2 == "5missmax" then
						if miss > 5 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[2] = true;
							SCREENMAN:SetNewScreen("ScreenFastStageBreak");
						end;
					end;

					if typeExtraLifeBarP2 == "pfcmode" then
						if allTns > 0 then
							STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):FailPlayer();
							statusFailPlayerLifeBarExtra[2] = true;
							SCREENMAN:SetNewScreen("ScreenFastStageBreak");
						end;
					end;

					if typeExtraLifeBarP2 == "none" then
						if failSettingP2 == "FailType_Immediate" then
							--debemos saber si estas muerto para cambiar el estado.
							local isFailedp2Aux =STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player):GetFailedAux();
							statusFailPlayerLifeBarExtra[2] = isFailedp2Aux;
						end;
					end;

				end;

				if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
					-- ~=
					if statusFailPlayerLifeBarExtra[1] == true and statusFailPlayerLifeBarExtra[2] == true then
						SCREENMAN:SetNewScreen("ScreenFastStageBreak");
					end;

				else
					--here only if one of the special lifebars is selected, if not, we just ignore.
					if GAMESTATE:IsSideJoined(PLAYER_1) then
						if statusFailPlayerLifeBarExtra[1] == true and typeExtraLifeBarP1 ~= "none" then
							SCREENMAN:SetNewScreen("ScreenFastStageBreak");
						end;
					else
						if statusFailPlayerLifeBarExtra[2] == true and typeExtraLifeBarP2 ~= "none" then
							SCREENMAN:SetNewScreen("ScreenFastStageBreak");
						end;
					end;

				end;	
					
			end;

		end;
};
]]
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
	t[#t+1] = LoadActor("ScreenGameplayDouble") .. {
		OnCommand=cmd(addy,-1);
	}; 
end;

--STAGE BACKGROUND
t[#t+1] = Def.ActorFrame{
	Name="HeaderCounter";
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP+TweakY);

		if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:x(SCREEN_LEFT+214);
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
local UI_display_LV_song = false;


if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local player_display_song_time_p1 = getCustomOptionValuePlayer(PLAYER_1,"gameplay_song_time_ui");
	if player_display_song_time_p1 ~= nil and player_display_song_time_p1 == true then
		UI_display_song_time = true;
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local player_display_song_time_p2 = getCustomOptionValuePlayer(PLAYER_2,"gameplay_song_time_ui");
	if player_display_song_time_p2 ~= nil and player_display_song_time_p2 == true then
		UI_display_song_time = true;
	end;
end;


--MACHINE CONFIG
local bShowLife = PREFSMAN:GetPreference('ShowExtraInfo');
local bShowTime = PREFSMAN:GetPreference('ShowExtraInfo');
local bShowSongLevel = PREFSMAN:GetPreference('ShowExtraInfo');
--local bShowGameDifficulty = PREFSMAN:GetPreference('ShowExtraInfo');

--SONG DURATION BAR
t[#t+1] = songBar()..{InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-360);};

function getBreakIconPlayer_StaticUI(player)

	local MedRateH=0.5;

	local zoomBaseNum = 0.38;
	local offsetPlayer = 0;
	local offsetTop = SCREEN_TOP + 26;

	if player == PLAYER_1 then
		offsetPlayer = SCREEN_LEFT + 188;
	else
		offsetPlayer = SCREEN_RIGHT - 188;
	end;

	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
		offsetPlayer = SCREEN_CENTER_X + 396;
	end;	

	return Def.ActorFrame{
			OnCommand=function(self)
				self:x(offsetPlayer);
				self:y(offsetTop);
				self:zoom(zoomBaseNum);
			end;

			LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/heart_full"))..{
				Name="heartPlayerBase";
				OnCommand=function(self)
					self:visible(true);
				end;
			};

			LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/heart_full"))..{
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
				local this = self:GetChildren();
				local iLife = params.RealLife;
				if iLife <= 0 then
					this.heartPlayerBase:visible(false);
					this.heartPlayerBaseGlow:visible(false);
					this.heartPlayerBaseEmpty:visible(true);
				end;
			end;

	};

--[[

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/heart 2x1"))..{
			Name="heartPlayerBase";
			OnCommand=cmd(animate,false;halign,1;valign,0;shadowlength,2;setstate,1);
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/heart 2x1"))..{
			Name="heartPlayerBaseGlow";
			OnCommand=cmd(animate,false;shadowlength,2;setstate,1;queuecommand,"Ani";x,-30;y,24;diffusealpha,0;blend,"BlendMode_Add");
			AniCommand=function(self)
				self:linear(1.2);
				self:diffusealpha(0.9);
				self:zoom(1.02);
				self:linear(1.2);
				self:diffusealpha(0);
				self:zoom(0.95);
				self:queuecommand("Ani");
			end;			
		};		

		OnCommand=function(self)
			self:zoom(zoomBaseNum);
			self:x(offsetPlayer);
			self:y(offsetTop);

		end;

		LifeChangedMessageCommand=function(self,params)
			if params.Player ~= player then return end;
			local this = self:GetChildren();

			local iLife = params.RealLife;
			if iLife <= 0 then
				this.heartPlayerBase:setstate(0);	
				this.heartPlayerBaseGlow:visible(false);				
			end;
		end;
	};

]]

end;

function getLevelSong_StaticUI(player)

	local zoomBaseNum = 0.5;
	local offsetPlayer = 0;
	local offsetTop = SCREEN_TOP + 27;

	local offsetPlayerX = {0,0,0};
	if player == PLAYER_1 then
		offsetPlayer = SCREEN_LEFT + 41;	
		offsetPlayerX = {90,-18,30};	
	else
		offsetPlayer = SCREEN_RIGHT - 41;
		offsetPlayerX = {-90,-18,30};
	end;

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/lv_bg"))..{
			Name="lvBase";
			OnCommand=cmd(shadowlength,2;zoom,0.8;diffusealpha,0.8);
		};

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/lv_bg"))..{
			Name="lvBaseGlow";
			OnCommand=cmd(shadowlength,2;zoom,0.8;blend,"BlendMode_Add");
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelJudge";
			OnCommand=function(self)
				self:shadowlength(2);
				self:x(offsetPlayerX[1]);
				self:y(-5);
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelMode";
			OnCommand=function(self)
				self:shadowlength(2);
				self:settext("Lv");
				self:x(offsetPlayerX[2]);
				self:y(-5);				

			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="fontLevelNumber";
			OnCommand=function(self)
				self:shadowlength(2);
				self:x(offsetPlayerX[3]);
				self:y(-5);				
			end;
		};

		OnCommand=function(self)
			self:zoom(zoomBaseNum);
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

			if currentStep:GetStepsType() == 'StepsType_Pump_Single' then
				this.lvBaseGlow:diffuse(color("#ff0000"));
			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Double' then
				this.lvBaseGlow:diffuse(color("#00ff00"));						
			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
				this.lvBaseGlow:diffuse(color("#ff00ff"));	
			end;
			if currentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
				this.lvBaseGlow:diffuse(color("#0018cf"));	
			end;
			if  currentStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
				this.lvBaseGlow:diffuse(color("#00ffff"));	
			end;			
			if currentStep:GetPlayers() ~= 1 then
				this.lvBaseGlow:diffuse(color("#ffff00"));					
			end;

		end;


	};

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
		t[#t+1] = getLevelSong_StaticUI(PLAYER_1);		
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
		t[#t+1] = getLevelSong_StaticUI(PLAYER_2);		
	end;	
end;




--TIEMPO / TIME
if bShowTime or UI_display_song_time then

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

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenGamePlay_ui/info/judg_b"))..{
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
			end;
		};

		LoadFont(fontJudg)..{
			Name="great";
			OnCommand=function(self)
					self:draworder(99);
					self:diffusealpha(1);
					self:y(yBase+(yOffsetData*2));
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
					self:y(yBase+(yOffsetData*3));
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
					self:y(yBase+(yOffsetData*4));
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
					self:y(yBase+(yOffsetData*5));
					self:x(xBase);
					self:settext("0");
					self:horizalign("left");
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

			
		end;
	};


end;



local function mapValue(value)
    local maxInput = 150
    local maxOutput = 92    
    return value * (maxOutput / maxInput)
end

local dataJudgBox = {
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
	local dataJudgSelected = dataJudgBox[1];


	local STATE = GAMESTATE:GetPlayerState(player);
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):HardJudgement() then dataJudgSelected = dataJudgBox[2] end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):VeryHardJudgement() then dataJudgSelected = dataJudgBox[3] end;			
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):ExtraJudgement() then dataJudgSelected = dataJudgBox[4]  end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):UltraHardJudgement() then dataJudgSelected = dataJudgBox[5]  end;


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

			if listaUiGameplayItems[i][1] == "judgdata" then
				local yItem = heightUsed;
				t[#t+1] = createStatJudgmentUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);		
			end;

			if listaUiGameplayItems[i][1] == "score" then
				local yItem = heightUsed;
				t[#t+1] = createScoreUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);			
			end;

			if listaUiGameplayItems[i][1] == "fastslow" then				
				local yItem = heightUsed;
				t[#t+1] = createFastSlowUiPlayer(PLAYER_1,topBaseHeightUiItems + yItem,0.81);
			end;
			heightUsed = heightUsed + (marginYBaseItems + listaUiGameplayItems[i][2]); 
		end;
	end;
end;


if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local listaUiGameplayItems = getGameplayUiSlotItems(PLAYER_2);
	local heightUsed = 0;
	if #listaUiGameplayItems > 0 then	

		for i = 1,#listaUiGameplayItems,1 do
			if listaUiGameplayItems[i][1] == "judgdata" then
				local yItem = heightUsed;
				t[#t+1] = createStatJudgmentUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);		
			end;

			if listaUiGameplayItems[i][1] == "score" then
				local yItem = heightUsed;
				t[#t+1] = createScoreUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);			
			end;

			if listaUiGameplayItems[i][1] == "fastslow" then				
				local yItem = heightUsed;
				t[#t+1] = createFastSlowUiPlayer(PLAYER_2,topBaseHeightUiItems + yItem,0.81);
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
			if not GAMESTATE:IsEventMode() then
			--	local Scost = GAMESTATE:IsCourseMode() and PREFSMAN:GetPreference("SongsPerPlay") or (GAMESTATE:GetCurrentSong():GetHearts() or 1);
				Scost = GAMESTATE:GetCurrentSong():GetHearts() or 1;
				for _, pn in ipairs(PlayerNumber) do
					for i = 1, Scost do
						GAMESTATE:AddStageToPlayer(pn);
					end;
				end;
			end;
			self:GetChild("Quad"):diffusealpha(.95);
			self:GetChild("sPaused"):visible(not ispaused);
			self:GetChild("GroupScroller"):visible(not ispaused);
			self:GetChild("Desc"):visible(not ispaused);
			SCREENMAN:SetNewScreen("ScreenStageInformation");
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

return t