--[[
	#PARTS SHORTCUT
	0 - FRAME / OVERLAY 
	0 - THEME PARTS
	0 - VS
	1 - ARROWS WHEEL < >
	2 - NAV ARROWS
	3 - SONG INFO W/ DECORATION
	4 - MISSION QUEST
	5 - SURVIVAL
	6 - FULL INTERFACE
	7 - BASIC INTERFACE
	8 - ANIMATION INTERFACE	- RANKING
	9 - CHECK ASPECT RATIO
	10 - PROFILE SELECTOR
	11 - PROFILE PLAYER
]]

collectgarbage();



if GAMESTATE:IsHumanPlayer(PLAYER_1)  then
	local savedTimingP1 = tonumber(getCustomOptionValuePlayer(PLAYER_1, "timing_adjustment")) or 0;
	GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming(savedTimingP1);

	local typeLifeBarExtra = getCustomOptionValuePlayer(PLAYER_1,"lifebar_extra_mode");
	if typeLifeBarExtra == "breakon" then
		GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(1); -- break on.
	end;
	
	--Scripts
	reApplyCVOption(PLAYER_1);

end;

if GAMESTATE:IsHumanPlayer(PLAYER_2)  then
	local savedTimingP2 = tonumber(getCustomOptionValuePlayer(PLAYER_2, "timing_adjustment")) or 0;
	GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming(savedTimingP2);

	local typeLifeBarExtra = getCustomOptionValuePlayer(PLAYER_2,"lifebar_extra_mode");
	if typeLifeBarExtra == "breakon" then
		GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(1); -- break on.
	end;

	--Scripts
	reApplyCVOption(PLAYER_2);

end;

function getChartInfoBox(player)

	local xPlayer=0;
	if player == PLAYER_1 then
		xPlayer = SCREEN_CENTER_X-446;
	else
		xPlayer = SCREEN_CENTER_X+446;
	end;

	return Def.ActorFrame{

			OnCommand=function(self)
				self:x(xPlayer);
				self:y(SCREEN_CENTER_Y-190);
				self:zoom(1.2);
				self:zoomy(0)
			end;

			ChangeStepsMessageCommand=function(self,params)
				if params.Player == player then
					self:stoptweening();
					self:zoomy(0);
					self:queuecommand("artistStep");
				end;
			end;

			SongChosenMessageCommand=function(self,params)				
					self:stoptweening();
					self:zoomy(0);
					self:queuecommand("artistStep");				
			end;


			SongUnchosenMessageCommand=function(self,params)				
					self:zoomy(0);
					self:GetChild("titleSong"):settext("-");
					self:GetChild("descSong"):settext("-");
					self:stoptweening();
			end;	



			artistStepCommand=function(self)

				local chartName = "";
				local chartDescription = "";
				local LabelType = "";
				local steps = GAMESTATE:GetCurrentSteps(player);
				local CustomLabel = DesCustomLabel(steps:GetDescription());

				chartName = steps:GetChartName();
				chartDescription = steps:GetDescription();
				LabelType = steps:GetLabelType();

				local showTextSteps=false;

				if #chartName > 0 then
					showTextSteps = true;
				end;

				--Not in quest, that thing has his own box.
				if "LABELTYPE_QUEST" == LabelType or "quest" == CustomLabel then
					showTextSteps=false;
				end;

				if showTextSteps then
					self:visible(true);
					if #chartName > 0 then							
						self:GetChild("titleSong"):settext(chartName);
						self:GetChild("descSong"):settext(chartDescription);
					else
						self:GetChild("titleSong"):settext("-");
						self:GetChild("descSong"):settext("-");
						--self:visible(false);
					end;
					self:queuecommand("Ani");
				else
					self:visible(false);
				end;

			end;

			AniCommand=function(self)
				self:stoptweening();
				self:zoomy(0);
				self:linear(0.05);
				self:zoomy(1.2)
			end;


			LoadActor(THEME:GetPathG("","ScreenSelectMusic/chartInfo"))..{	
				Name="charInfo";
				InitCommand=function(self)
					self:zoom(0.6);
					self:zoomy(0.4);

				end;
				OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
			};

			LoadFont("_TitleXolonium")..{
				Name="titleSong";
				InitCommand=cmd(y,-10;zoom,0.4;maxwidth,480;);
			};
			LoadFont("_TitleXolonium")..{
				Name="descSong";
				InitCommand=cmd(y,5;zoom,0.35;maxwidth,480;);
			};
	};


end;

function breakOnItem(player)
	local baseX = 0;
	if player == PLAYER_1 then
		baseX = SCREEN_CENTER_X-510;
	else
		baseX = SCREEN_CENTER_X+510;
	end;

	return Def.ActorFrame
	{
		OnCommand=function(self)
			self:x(baseX);
			self:y(SCREEN_CENTER_Y+165);
			self:zoom(0.65);

			if isAspectRatio43() then
				self:y(SCREEN_CENTER_Y+203);
			end;

			self:queuecommand("checkBreak");
		end;

		checkBreakCommand=function(self)
			local STATE = GAMESTATE:GetPlayerState(player);
			local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();
			local optionBreak = getCustomOptionValuePlayer(player,"lifebar_extra_mode");

			if optionBreak == "breakon" then
				self:GetChild("stageBreakModeSprite"):setstate(0);
				self:visible(true);
			elseif optionBreak == "suddendeath" then
				self:GetChild("stageBreakModeSprite"):setstate(1);
				self:visible(true);
			elseif optionBreak == "5missmax" then
				self:GetChild("stageBreakModeSprite"):setstate(2);
				self:visible(true);
			elseif optionBreak == "pfcmode" then
				self:GetChild("stageBreakModeSprite"):setstate(3);
				self:visible(true);
			elseif optionBreak == "fcmode" then
				self:GetChild("stageBreakModeSprite"):setstate(4);
				self:visible(true);
			elseif optionBreak == "efcmode" then
				self:GetChild("stageBreakModeSprite"):setstate(5);
				self:visible(true);
			else
				self:GetChild("stageBreakModeSprite"):setstate(0);
				self:visible(false);
			end;

			--[[
			local isBreakOn = false;
			if failSetting == "FailType_Immediate" then
				isBreakOn = true;
			end;
			self:visible(isBreakOn);
			]]
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("checkBreak");
			end;
		end;		
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,1);

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/stagebreakmode 1x6"))..{
			Name="stageBreakModeSprite";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(0);
			end;
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
	};
end;

function GetFixedChannelName(path)
	--devuelve un nombre display
	return arrChannelTitle[path] or path;
end;

function get_file_name(file)
      return file:match("^.+/(.+)$")
end

local ChangeDir = 0;
local t = Def.ActorFrame {};
local pvideoLoaded=false;

local stackSelectionP1=0;
local stackSelectionP2=0;
local prevXSize = 508;
local prevYSize = 290;

--quiero tener un counter global de frames, claramente llega a 60 y vuelve a 0.
framesCounterSDL = 0;
lastSong = nil;

t[#t+1] =  Def.ActorFrame
{
	InitCommand=cmd(SetUpdateFunction,frameCounterUpdater);
};

function frameCounterUpdater()
      if (framesCounterSDL + 1) > 60 then
      	framesCounterSDL = 0;
      end;	
	framesCounterSDL = framesCounterSDL + 1;
end;



--fav
--****************************
--*** 0 - FAVORITES        ***
--****************************
local p1StatusFavSelectMode=false;
local p2StatusFavSelectMode=false;

--****************************
--*** 0 - VS               ***
--****************************
-- only with 2 players.
if GAMESTATE:GetNumSidesJoined() == 2 then
	if GAMESTATE:Env()["p1vsCount"] == nil and GAMESTATE:Env()["p2vsCount"] == nil then
		GAMESTATE:Env()["p1vsCount"] = 0;
		GAMESTATE:Env()["p2vsCount"] = 0;
	end;
end;

--****************************
--*** 0 - FRAME / OVERLAY  ***
--****************************
local isUsingDefaultSkin = true;
--:::: FRAME SKIN ::::--
--we get the installed themes. if it's intern we will asume is it the simple.
local luaFrameSkinSelected = getFrameSkinForPlayers("overlay","ScreenSelectMusic");
if luaFrameSkinSelected["isDefault"] then
	local frameSelected = "simple";
	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/"..frameSelected.."/overlay"))..{
	};	
else
	local frameSkinFunc = LoadActor(luaFrameSkinSelected["lua"]);
	t[#t+1] = frameSkinFunc(luaFrameSkinSelected["path"]);
	isUsingDefaultSkin = false;
end;





--****************************
--*** 1 - ARROWS WHEEL < > ***
--****************************
local songwsx=150;
local basesongwsx = 150;
local basegroupwx=250;
local zoomArrowsBanner=0.5;
local zoomArrowsChannel=1;



t[#t+1] =  Def.ActorFrame
{
	InitCommand=cmd(visible,false);

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(zoom,zoomArrowsBanner;y,SCREEN_CENTER_Y*1.66;x,SCREEN_CENTER_X-songwsx;diffusealpha,0.6;blend,'BlendMode_Add');
		PreviousSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X-(songwsx+10);linear,0.08;x,SCREEN_CENTER_X-songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);

		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);	
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.6);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);			
			self:y(SCREEN_CENTER_Y*1.66);
			self:x(SCREEN_CENTER_X-songwsx);
			self:linear(0.1);
			self:diffusealpha(0.6);
		end;

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.8);		
	};	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(zoom,zoomArrowsBanner;y,SCREEN_CENTER_Y*1.66;x,SCREEN_CENTER_X-songwsx;diffusealpha,0.8);
		PreviousSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X-(songwsx+10);linear,0.08;x,SCREEN_CENTER_X-songwsx);
		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);	
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.1);
			self:diffusealpha(0.8);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:zoom(zoomArrowsBanner);
			self:diffusealpha(0);
			self:y(SCREEN_CENTER_Y*1.66);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.8);
		end;

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.4);
	};	


 	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(rotationz,180;zoom,zoomArrowsBanner;y,SCREEN_CENTER_Y*1.66;x,SCREEN_CENTER_X+songwsx;diffusealpha,0.6;blend,'BlendMode_Add');		
		NextSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X+(songwsx+10);linear,0.08;x,SCREEN_CENTER_X+songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);

		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X+songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.6);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);
			self:y(SCREEN_CENTER_Y*1.66);
			self:x(SCREEN_CENTER_X+songwsx);
			self:linear(0.1);
			self:diffusealpha(0.6);
		end;		

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.6);		
	};

 	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(rotationz,180;zoom,zoomArrowsBanner;y,SCREEN_CENTER_Y*1.66;x,SCREEN_CENTER_X+songwsx;diffusealpha,0.4);		
		NextSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X+(songwsx+10);linear,0.08;x,SCREEN_CENTER_X+songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);	


		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);		
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X+songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.8);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);
			self:y(SCREEN_CENTER_Y*1.66);
			self:x(SCREEN_CENTER_X+songwsx);
			self:linear(0.1);
			self:diffusealpha(0.8);
		end;


		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.4);		
	};
};

--backsimpleDiffList
t[#t + 1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.36;zoomx,2.8;zoomy,0.75;diffusealpha,0.8;fadetop,0.1;visible,false);
	CurrentSongChangedMessageCommand=function(self)			
		self:finishtweening():diffusealpha(0.6):sleep(0.05):linear(0.2):diffusealpha(0.8);	
	end;	
	SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	

	SelectChannelMessageCommand=function(self)
		self:linear(0.2);
		self:y(SCREEN_CENTER_Y*1.51);
		self:diffusealpha(0.5);
		self:zoomx(2.1);

		if isAspectRatio1610() then
			self:y(SCREEN_CENTER_Y+163);
		end;
		if isAspectRatio43() then
			self:y(SCREEN_CENTER_Y+180);
		end;

	end;
	ChannelChosenMessageCommand=function(self)
		self:y(SCREEN_CENTER_Y*1.36);
		self:diffusealpha(0.8);
		self:zoomx(2.8);
	end;

};

local diffuseColor1="88";
local diffuseColor2="ff";
--0 119
local colorPulseA = {
	{ color1="#A8FF00"..diffuseColor1, color2="#00FF99"..diffuseColor2 },
	{ color1="#FF003C"..diffuseColor1, color2="#00FFD9"..diffuseColor2 }
}
--120 159
local colorPulseB = {
	{ color1="#3A00FF"..diffuseColor1, color2="#00E1FF"..diffuseColor2 }
}
--160 199
local colorPulseC={
	{ color1="#FF44CC"..diffuseColor1, color2="#44FFFF"..diffuseColor2 }
}
--200 219
local colorPulseD={
	{ color1="#3A00FF"..diffuseColor1, color2="#00E1FF"..diffuseColor2 },
	{ color1="#FF66CC"..diffuseColor1, color2="#CCFF00"..diffuseColor2 }
}
--220+
local colorPulseE={
	{ color1="#FF2200", color2="#FFD500"},
	{ color1="#FF66CC"..diffuseColor1, color2="#CCFF00"..diffuseColor2 },
	{ color1="#ff0059BB", color2="#FF00AA"},
	{ color1="#3A00FF", color2="#00E1FF" },
}

local tempPulse;

function getColorPulseForIntro()
	local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();
	local duration = GAMESTATE:GetCurrentSong():GetSampleLength();
	local pulse;
	local diffuseStatus = {low=0.25,medium=0.3,high=0.75,full=0.9};
	if bpm == nil or bpm == "???" then
	    bpm = "150";
	end

	if bpm ~= nil then
		local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
		if part1 and part2 then
			bpm = part2;
		end;

		local bpmNumber = tonumber(bpm);		
		if bpmNumber < 120 then
			pulse = colorPulseA[2];			
			pulse["diffuse"] = diffuseStatus["full"];

		elseif bpmNumber >= 120 and  bpmNumber < 160 then

			pulse = colorPulseB[1];
			pulse["diffuse"] = diffuseStatus["high"];

		elseif bpmNumber >= 160 and  bpmNumber < 200 then

			pulse = colorPulseC[1];
			pulse["diffuse"] = diffuseStatus["high"];

		elseif bpmNumber >= 200 and  bpmNumber < 220 then
			pulse = colorPulseD[1];
			pulse["diffuse"] = diffuseStatus["full"];

		elseif bpmNumber >= 220 then
			pulse = colorPulseE[4];
			pulse["diffuse"] = diffuseStatus["full"];
		end;
	else
		pulse = colorPulseA[1];
		pulse["diffuse"] = diffuseStatus["low"];
	end;



	return {pulse=pulse,duration=duration};
end;


t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(visible,false);


		Def.ActorFrame{



			LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/glowfulllvbase"))..{
			InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.343;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.67;blend,"BlendMode_Add";fadeleft,0.85;faderight,0.85;draworder,1);
			CurrentSongChangedMessageCommand=function(self)			
				--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8);
				if GAMESTATE:GetGameMode() == 'Basic' then
					self:visible(false);
				else
					self:visible(true);
				end;
				self:stoptweening();
				self:stopeffect();
				self:diffuse(color("#ff0000"));
				self:diffusealpha(0);
				self:queuecommand("PulseAni");

			end;	
			SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	
			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;	
			PulseAniCommand=function(self)
				self:linear(0.12);
				self:diffusealpha(1);
				local periodBps = getPeriodTimeForBpm(1);			
				self:diffuseramp();
				--[[
				self:effectcolor1(color("#00ffff88"));
				self:effectcolor2(color("#ff0000"));			
				]]

				local pulseIntro = getColorPulseForIntro();
				self:effectcolor1(color(pulseIntro["pulse"].color1));
				self:effectcolor2(color(pulseIntro["pulse"].color2));
				self:effectperiod(periodBps);

				self:diffusealpha(pulseIntro["pulse"].diffuse);

				self:sleep(pulseIntro["duration"]);
				self:linear(1)
				self:diffusealpha(0);

				
			end;		
		      };

				LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/glowfulllvbase"))..{
			InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.343;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.67;blend,"BlendMode_Add";fadeleft,1;faderight,1;draworder,1);
			CurrentSongChangedMessageCommand=function(self)			
				--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8);
				if GAMESTATE:GetGameMode() == 'Basic' then
					self:visible(false);
				else
					self:visible(true);
				end;
				self:stoptweening();
				self:stopeffect();
				self:diffuse(color("#ff0000"));
				self:diffusealpha(0);
				self:queuecommand("PulseAni");

			end;	
			SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	
			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;	
			PulseAniCommand=function(self)
				self:linear(0.12);
				self:diffusealpha(1);
				local periodBps = getPeriodTimeForBpm(1);			
				self:diffuseramp();
				--[[
				self:effectcolor1(color("#00ffff88"));
				self:effectcolor2(color("#ff0000"));			
				]]

				local pulseIntro = getColorPulseForIntro();
				self:effectcolor1(color(pulseIntro["pulse"].color1));
				self:effectcolor2(color(pulseIntro["pulse"].color2));
				self:effectperiod(periodBps);

				self:diffusealpha(pulseIntro["pulse"].diffuse);

				self:sleep(pulseIntro["duration"]);
				self:linear(1)
				self:diffusealpha(0);
			end;		
		};
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/lvplaceholderbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;);
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8);
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/atype_lvbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;blend,"BlendMode_Add";queuecommand,"Ani");
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8):queuecommand("Ani");
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		AniCommand=function(self)
			self:linear(1);
			self:diffusealpha(1);
			self:decelerate(2);
			self:diffusealpha(0.5);
			self:queuecommand("Ani");
		end;

		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;queuecommand,"Ani");	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/btype_lvbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;blend,"BlendMode_Add";queuecommand,"Ani");
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8):queuecommand("Ani");
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		AniCommand=function(self)
			self:linear(2);
			self:diffusealpha(1);
			self:sleep(1);
			self:decelerate(1);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;queuecommand,"Ani");	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};	


	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/glowplaceholdermove"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;blend,"BlendMode_Add";diffusealpha,0;queuecommand,"Ani");
		OnCommand=function(self)
			self:rainbow();
		      SCREENMAN:GetTopScreen():AddInputCallback(function(event)
			    		--printInLogParamsData("event",event);	    	
					local statusScreen = SCREENMAN:GetTopScreen():GetSelectionState();
					if statusScreen then
						if statusScreen == 'SelectingSong' then
					    	    	if event.type == "InputEventType_FirstPress" and event.button == "DownLeft" then

					    	    		if event.PlayerNumber == PLAYER_1 and GAMESTATE:IsSideJoined(PLAYER_1) then
					    	    			self:stoptweening():queuecommand("AniL");
						    	    	end;

						    	    	if event.PlayerNumber == PLAYER_2 and GAMESTATE:IsSideJoined(PLAYER_2) then
						    	    		self:stoptweening():queuecommand("AniL");
						    	    	end;
							 end;
					    	      if event.type == "InputEventType_FirstPress" and event.button == "DownRight" then
					    	    	
						    	    	if event.PlayerNumber == PLAYER_1 and GAMESTATE:IsSideJoined(PLAYER_1) then
						    	    		self:stoptweening():queuecommand("AniR");
						    	    	end;
						    	    	if event.PlayerNumber == PLAYER_2 and GAMESTATE:IsSideJoined(PLAYER_2) then
									self:stoptweening():queuecommand("AniR");
						    	    	end;

							end;
						end;
					end;
		      	return false;
		      end)


		end;
		CurrentSongChangedMessageCommand=function(self,params)	
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8):queuecommand("Ani");
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		AniLCommand=function(self)
			self:stoptweening();
			self:faderight(0);
			self:fadeleft(0);
			self:diffusealpha(0.3);
			self:faderight(0.5);
			self:linear(0.3)
			self:diffusealpha(0);

			--[[
			self:diffusealpha(0.3);
			self:fadeleft(0);
			self:faderight(0.5);
			self:linear(1);
			self:fadeleft(1);
			self:faderight(0);
			self:diffusealpha(0);
			]]
		end;
		AniRCommand=function(self)
			self:stoptweening();
			self:faderight(0);
			self:fadeleft(0);
			self:diffusealpha(0.3);
			self:fadeleft(0.5);
			self:linear(0.3)
			self:diffusealpha(0);
		end;

		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};	

	SelectChannelMessageCommand=cmd(stoptweening;decelerate,0.1;diffusealpha,0;);
	ChannelChosenMessageCommand=cmd(stoptweening;decelerate,0.1;diffusealpha,1;);

};


--***********************************
--*** 3 - SONG INFO W/ DECORATION ***
--***********************************
local songInfoYBuffer = 95;
local songInfoYBufferSelected = 90;

local function BarTitle(self)
	local statusScreen = SCREENMAN:GetTopScreen():GetSelectionState();
	if statusScreen then
		if statusScreen == 'SelectingSong' then
			local currentSong = GAMESTATE:GetCurrentSong()
			local isRandomChannel = GAMESTATE:GetRandomChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetSurvivalChannel()

			local songartist = "???"
			local bpmActual = "BPM ???"
			local durationSong = "??:??"
			
			if isRandomChannel or (currentSong and currentSong:GetOrigin() == "RANDOMXX") then
				if GAMESTATE:GetSurvivalChannel() and currentSong then
					local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("Title"):settext(songtitle);
				else
					self:GetChild("Title"):settext("?????");
				end;
			elseif currentSong then
				local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("Title"):settext(songtitle );
					
				--get real information about a train


				bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
				songartist = GAMESTATE:GetCurrentSong():GetDisplayArtist();
				local MusicLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() or 0;
				durationSong = MusicLength > 0 and SecondsToMMSS(MusicLength) or "";

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
			else
				self:GetChild("Title"):settext("?????");
			end;

			local ftext = songartist .."  •  "..bpmActual.."  •  "..durationSong
			self:GetChild("Artist"):settext(ftext);
			self:GetChild("Artist"):AddAttribute(0, {Length=#songartist, Diffuse=color("#ffe7c9"),StrokeColor=color("0,0,0,1")})
			self:GetChild("Artist"):AddAttribute(#songartist + 5, {Length=#bpmActual, Diffuse=color("#c9fff3"),StrokeColor=color("0,0,0,1")})
			self:GetChild("Artist"):AddAttribute(#songartist + #bpmActual + 10, {Length=#durationSong, Diffuse=color("#ffc9ea"),StrokeColor=color("0,0,0,1")})
		end;
	end;
end;

local function WheelCounter(self)
	local screen = SCREENMAN:GetTopScreen()
		if not screen or screen:GetName() ~= "ScreenSelectMusic" then return end
		if screen:GetSelectionState() ~= "SelectingSong" then return end
	
	local musicWheel = screen:GetChild("MusicWheel")
	local indexText = "";
	if musicWheel then
		local index = (musicWheel:GetCurrentIndex() + 1) or 0
		local items = musicWheel:GetNumItems()
		indexText = counterformat(index) .. " / " .. counterformat(items)
	else
		indexText = ""
	end
	self:GetChild("Counter"):settext(indexText);

end;

local favMessage;

local langMessageFav = PREFSMAN:GetPreference('Language').."_favorite_message";


t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.19;visible,false);
	SelectChannelMessageCommand=cmd(finishtweening;decelerate,0.1;diffusealpha,0);
	ChannelChosenMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,0.1;linear,0.3;diffusealpha,1);	

	--[[
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/BackTitle"))..{
		InitCommand=cmd(zoom,1.1;zoomy,.9;fadeleft,0.15;faderight,0.15;);
	};
	]]

	Def.Sound {
	    Name = "favActivateSound";
	    File = THEME:GetPathS("", "xsanity/favActivate");
	};


	--Favorite
	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/"..langMessageFav))..{
		name="favoriteMessage";
		InitCommand = function(self)
			self:zoom(0.6):xy(0, -40):diffusealpha(0);
			favMessage = self;
		end;

		CurrentSongChangedMessageCommand = function(self) 
			local p1NoPersistent = false;
			local p2NoPersistent = false;
			
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				if not PROFILEMAN:IsPersistentProfile(PLAYER_1) then
					p1NoPersistent=true;
				end;
			end;
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				if not PROFILEMAN:IsPersistentProfile(PLAYER_2) then
					p2NoPersistent=true;
				end;
			end;

			if p1NoPersistent or p2NoPersistent then
				self:diffusealpha(0);
				return;
			end;

			if GAMESTATE:GetGameMode() ~= 'Basic' then
				self:stoptweening():diffusealpha(0):sleep(5):linear(1):diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};



	--Favorite
	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/favorite"))..{
		name="favoriteP1";
		InitCommand = function(self)
			self:zoom(0.8):xy(-150, -40):visible(GAMESTATE:IsPlayerEnabled(PLAYER_1)):diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand = function(self) 
			p1StatusFavSelectMode = false;

			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_1) then
				 	p1StatusFavSelectMode = true;
				 else
				 	p1StatusFavSelectMode = false;
				 end
			end

			self:stoptweening():queuecommand("UpdateFavorite") 
		end;
		SongUnchosenMessageCommand = function(self) 
			p1StatusFavSelectMode = false;
			self:stoptweening():queuecommand("UpdateFavorite") 
		end;

	   	SongChosenMessageCommand = function(self) 
			p1StatusFavSelectMode = true;
			self:stoptweening():queuecommand("UpdateFavorite");
	   	end;
		
		SelectChannelMessageCommand = function(self) 
			p1StatusFavSelectMode = false;
			self:stoptweening():diffusealpha(0) 
		end;
		UpdateFavoriteCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_1) then
					self:stoptweening():sleep(0.05):linear(0.09):diffusealpha(1);
					favMessage:stoptweening():diffusealpha(0);
				 else
				 	self:stoptweening():diffusealpha(0);
				 end
			else
				self:stoptweening():diffusealpha(0);
			end

			if p1StatusFavSelectMode then
				self:sleep(0.25);
				self:queuecommand("UpdateFavorite");
			end;
		end;

		FinalizedMessageCommand = function(self)	
			p1StatusFavSelectMode = false;
			self:stoptweening():visible(false);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};

	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/favorite"))..{
		name="favoriteP2";
		InitCommand = function(self)
			self:zoom(0.8):xy(150, -40):visible(GAMESTATE:IsPlayerEnabled(PLAYER_2)):diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand = function(self) 
			self:stoptweening():queuecommand("UpdateFavorite") 
		end;

		SongUnchosenMessageCommand = function(self) 
			p2StatusFavSelectMode = false;
		end;

		SongChosenMessageCommand = function(self) 
			p2StatusFavSelectMode = true;
			self:stoptweening():queuecommand("UpdateFavorite");
		end;

		SelectChannelMessageCommand = function(self) 
			p2StatusFavSelectMode = false;
			self:stoptweening():diffusealpha(0) 
		end;


		UpdateFavoriteCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_2) then
					self:stoptweening():sleep(0.05):linear(0.09):diffusealpha(1);
					favMessage:stoptweening():diffusealpha(0);
				 else
				 	self:stoptweening():diffusealpha(0);
				 end
			else
				self:stoptweening():diffusealpha(0);
			end

			if p2StatusFavSelectMode then
				self:sleep(0.25);
				self:queuecommand("UpdateFavorite");
			end;
		end;


		FinalizedMessageCommand = function(self)	
			p2StatusFavSelectMode = false;
			self:stoptweening():visible(false);
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};
	Def.ActorFrame{
		Name="Fonts";
		UpdateinfoCommand=function(self)
			BarTitle(self);

			local title = self:GetChild("Title");
			local Artist = self:GetChild("Artist");
			local basetitle = self:GetChild("Basetitle");

			if title and basetitle then
				local textWidth = title:GetZoomedWidth();
				local textWidthArtist = Artist:GetZoomedWidth();

				local baseWidth = basetitle:GetWidth();
				local margin = 250; -- Total extra ancho (10px a cada lado)
				local marginArtist = 250; -- Total extra ancho (10px a cada lado)

				local zoomXName=0;
				local zoomXArtis=0;

				if baseWidth > 0 then
					zoomXName = (textWidth + margin) / baseWidth;
					zoomXArtis = (textWidthArtist + marginArtist) / baseWidth;
					--basetitle:zoomx(newZoomX);
				end

				if zoomXName >= zoomXArtis then
					basetitle:zoomx(zoomXName);
				end;

				if zoomXArtis >= zoomXName then
					basetitle:zoomx(zoomXArtis);
				end;				


			end
		end;
		showInfoCommand=function(self)
			self:finishtweening():diffusealpha(0):accelerate(0.25):diffusealpha(1);	
		end;
		CurrentSongChangedMessageCommand=function(self)			
			self:finishtweening():queuecommand("Updateinfo"):diffusealpha(0):sleep(0.02):queuecommand("showInfo");	
		end;
		OffCommand=function(self)
			self:finishtweening():linear(0.15):diffusealpha(0);
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
			Name="Basetitle";
			InitCommand=cmd(xy,-2,2;zoomy,0.8;diffusealpha,0.95;fadeleft,0.3;faderight,0.3);		
		};


		LoadFont("_TitleXolonium")..{
			Name="Title";
			Text="SongName Test";
			InitCommand=cmd(zoom,0.8;xy,0,-14;maxwidth,750/.78;);
		};

		LoadFont("_TitleXolonium")..{
			Name="Artist";
			Text="SongArtist Test";
			InitCommand=cmd(zoom,.5;xy,0,12;skewx,0;maxwidth,700/.54;);
		};	
	};

	Def.ActorFrame{
		InitCommand=function(self)
			self:SetUpdateFunction(WheelCounter);
		end;
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1;);
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,1;);
		LoadFont("xolonium")..{
			Name="Counter";
			Text="x,xxx / x,xxx";
			InitCommand=cmd(zoom,.7;xy,-37,106;horizalign,left;maxwidth,160/.8;strokecolor,color("0,0,0,1") );
			OnCommand=function(self)
				if isAspectRatio43() then
					self:y(140);
				end;
			end;
		};

	};
};


--BORDER WHEEL SONG SELECTED
local periodBps=0;
t[#t+1] =  Def.ActorFrame
{
	SelectChannelMessageCommand=function(self)
	--	bPickingChannel = true;
		self:visible(false);		
	end;
	ChannelChosenMessageCommand=function(self)
	--	bPickingChannel = false;
		self:visible(true);
	end;
	
	InitCommand=cmd(y,THEME:GetMetric("ScreenSelectMusic", "MusicWheelY");visible,false;);
	
	Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X,-82;rainbow;effectperiod,4;setsize,220,1;faderight,.1;fadeleft,.1;queuecommand,"Ani");	--blend,"BlendMode_Add"
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.25;linear,.3;diffusealpha,1;queuecommand,"Ani");
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);		
		OffCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		FinalizedMessageCommand=function(self)
			self:finishtweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		AniCommand=function(self)
			self:stoptweening();
			self:rainbow();
			--local steps = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
			local periodTime = 4;
			local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();

			if bpm == "???" then
			    bpm = "150";
			end

			if bpm ~= nil then
				local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
				if part1 and part2 then
					bpm = part2;
				end;

				periodTime = (60/bpm)*4;
			end;

			self:effectperiod(periodTime);
		end;
	};
	
	Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X,82;rainbow;effectperiod,4;setsize,220,1;faderight,.1;fadeleft,.1;queuecommand,"Ani");	--blend,"BlendMode_Add"
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.25;linear,.3;diffusealpha,1;queuecommand,"Ani");
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);		
		OffCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		FinalizedMessageCommand=function(self)
			self:finishtweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	

		AniCommand=function(self)
			self:rainbow();
			--local steps = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
			local periodTime = 4;
			local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();

			if bpm == "???" then
			    bpm = "150";
			end

			if bpm ~= nil then
				local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
				if part1 and part2 then
					bpm = part2;
				end;

				periodTime = (60/bpm)*4;
			end;

			self:effectperiod(periodTime);
		end;
	};

	Def.Quad{

		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(-82);
			self:setsize(266,2);
			self:diffuse(color("#ff0000"));
			self:blend("BlendMode_Add");
		end;
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening();
			--self:linear(0.05);
			self:diffusealpha(0);
			self:sleep(0.3);
			local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();

			if bpm == "???" then
			    bpm = "150";
			end

			if bpm ~= nil then
				local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
				if part1 and part2 then
					bpm = part2;
				end;
			else
				 bpm = 150;
			end;
			periodBps = (60/bpm);
			self:stopeffect();
			self:linear(0.1);
			self:diffusealpha(1);
			
			self:diffuseramp();
			self:effectcolor1(color("#ff00ff88"));
			self:effectcolor2(color("#ff0000"));			
			self:effectperiod(periodBps);
			self:fadeleft(.15);
			self:faderight(.15);
		end;
	};

	Def.Quad{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(82);
			self:setsize(266,2);
			self:diffuse(color("#ff0000"));
			self:blend("BlendMode_Add");
		end;
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening();
			self:diffusealpha(0);
			self:sleep(0.25);
			local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();
			if bpm == "???" then
			    bpm = "150";
			end

			if bpm ~= nil then
				local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
				if part1 and part2 then
					bpm = part2;
				end;
			else
				 bpm = 150;
			end;
			periodBps = (60/bpm);
			self:stopeffect();
			self:linear(0.12);
			self:diffusealpha(1);
			
			self:diffuseramp();
			self:effectcolor1(color("#ff00ff88"));
			self:effectcolor2(color("#ff0000"));			
			self:effectperiod(periodBps);
			self:fadeleft(.1);
			self:faderight(.1);
		end;
	};

	--[[

	Def.Quad{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X-130);
			self:y(0);
			self:setsize(1,160);
			self:diffuse(color("#ff0000"));
		end;

		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening();
			local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM();
			if bpm ~= nil then
				local part1, part2 = bpm:match("([^%-]+)%-([^%-]+)");
				if part1 and part2 then
					bpm = part2;
				end;
			end;
			periodBps = (60/bpm);
			self:queuecommand("Ani");
		end;

		AniCommand=function(self)
			self:diffuseramp();
			self:effectcolor1(color("#ff000000"));
			self:effectcolor2(color("#ff0000"));			
			self:effectperiod(periodBps);
		end;
	};
	]]
};




--**********************************************
--*** 4 - MISSION QUEST 			   ***
--**********************************************
--this is just to beautify some of the names of the mission charts
--when selecting songs.
function procMissionNames(name)

	local titleList = {
		"NX World Tour",
		"NX2 WM",
		"NXA WM",
		"Fiesta 2 Quest Zone ",
		"Prime Quest Zone",
		"Infinity - "
	}

	local defaultDataTitle = {title="",desc="",index=0,default=true};
	local dataTitle = {
		{title="",desc="Pump it up NX - World Tour",index=0,default=false},
		{title="",desc="Pump it up NX2 - WorldMax",index=0,default=false},
		{title="",desc="Pump it up NXA - WorldMax",index=0,default=false},
		{title="",desc="Pump it up Fiesta 2 - Quest Zone",index=0,default=false},
		{title="",desc="Pump it up Prime - Quest Zone",index=0,default=false},
		{title="",desc="Pump it up Infinity",index=0,default=false}
	}

	local existsInList = false;
	local idTitle = 0;

	for i=1,#titleList do 
		local checkTitle = string.find(name, titleList[i]);
		if checkTitle then
			local procName = string.gsub(name, escape_lua_pattern(titleList[i]), "");
			local baseResult = dataTitle[i];
			baseResult["title"] = procName;
			return baseResult;
		end;
	end;

	defaultDataTitle["title"] = name;
	return defaultDataTitle;
end;


t[#t+1] = Def.ActorFrame{
	
	InitCommand=cmd(y,SCREEN_CENTER_Y-355;visible,false);
	SongChosenMessageCommand=cmd(stoptweening;queuecommand,"changeTitlesMission");
	ChangeStepsMessageCommand=function(self)
		self:queuecommand("changeTitlesMission");
	end;
	SongUnchosenMessageCommand=function(self)
		self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):settext("");
		self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):settext("");
		self:GetChild("baseFullFrame"):GetChild("titleMissionFull"):settext("");
		self:GetChild("baseFullFrame"):GetChild("descMissionFull"):settext("");

		self:visible(false);
		self:GetChild("baseSimpleFrame"):visible(false);
		self:GetChild("baseFullFrame"):visible(false);
	end;
	changeTitlesMissionCommand=function(self)		
		self:stoptweening();
		self:GetChild("baseSimpleFrame"):visible(false);
		local title ="";
		local desc = "";
		local missionSuccess=false;
		local misionFailed=false;
		self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):visible(false);

		if GAMESTATE:GetQuestZoneChannel() then
			Trace("::: GET QUEST ZONE CHANNEL");
			self:visible(true);
			
			local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetQuestDesc();			
			text = split('@',text );
			if #text > 2 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				elseif (gLANG() == "PT-") then
					text = text[3];
				else
					text = text[2];
				end
			elseif #text > 1 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				else
					text = text[2];
				end
			else
				text = text[1];
			end;
			
			text = split('|',text );
			if #text > 1 then
				title= text[1];
				desc = text[2];
			else
				title= text[1];
			end;


			local song = GAMESTATE:GetCurrentSong();
			local steps = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
			local scorelist = PROFILEMAN:GetProfile(GAMESTATE:GetMasterPlayerNumber()):GetHighScoreList(song,steps):GetHighScores();

			self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):visible(false);

			if #scorelist > 0 then
				for i=1,#scorelist do
					if scorelist[i]:GetSuccess() then
						missionSuccess = true;
						self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):visible(true);
						self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):setstate(0);
					end;
				end;

				if missionSuccess == false then
					misionFailed=true;
					self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):visible(true);
					self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):setstate(1);
				end;

			else
				self:GetChild("baseFullFrame"):GetChild("missionStatusFull"):visible(false);
			end;


			--new thing
			self:GetChild("baseFullFrame"):visible(true);
			self:GetChild("baseFullFrame"):GetChild("titleMissionFull"):settext(title);
			self:GetChild("baseFullFrame"):GetChild("descMissionFull"):settext(desc);

			if desc == "" then
				self:GetChild("baseFullFrame"):GetChild("titleMissionFull"):zoom(0.9):y(-15);
				self:GetChild("baseFullFrame"):GetChild("descMissionFull"):zoom(0.6):y(-5);
			else
				self:GetChild("baseFullFrame"):GetChild("titleMissionFull"):zoom(0.8):y(-22);
				self:GetChild("baseFullFrame"):GetChild("descMissionFull"):zoom(0.6):y(-5);
			end;


		elseif GAMESTATE:GetQuestWorldChannel() then
			
			self:visible(true);
			if (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_UCQ") then
				local description = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDescription();
				if (string.len(description) > 0) then
					desc = description;
				end;
			else
				local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetChartName();
				if (string.len(text) > 0) then
					title= text;
				end;
			end;


			--here we will process the name to beautify it a little
			local dataTitleMission = procMissionNames(title);
			if dataTitleMission["default"] == false then
				title = dataTitleMission["title"];
				desc = dataTitleMission["desc"];
			else
				title = dataTitleMission["title"];
			end;

			--new thing
			self:GetChild("baseSimpleFrame"):visible(true);
			self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):settext(title);
			self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):settext(desc);

			if desc == "" then
				self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):zoom(0.9):y(-2);
				self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):zoom(0.6):y(-2);
			elseif title == "" then
				self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):zoom(0.9):y(-2);
				self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):zoom(0.9):y(-2);
			else
				self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):zoom(0.8):y(-6);
				self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):zoom(0.6):y(10);
			end;

		elseif (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_QUEST") then
			self:visible(true);
			self:GetChild("baseSimpleFrame"):visible(true);
			local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetChartName();
			if (string.len(text) > 0) then
				title = text;
			end;

			--here we will process the name to beautify it a little
			local dataTitleMission = procMissionNames(title);
			local procTitle = "";
			local procDesc = "";		
			if dataTitleMission["default"] == false then
				procTitle = dataTitleMission["title"];
				procDesc = dataTitleMission["desc"];
			else
				procTitle = dataTitleMission["title"];
			end;

			self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):settext(procTitle);
			self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):settext(procDesc);

			self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):zoom(0.8):y(-7);
			self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):zoom(0.6):y(10);

		elseif (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_UCQ") then
			self:visible(true);
			self:GetChild("baseSimpleFrame"):visible(true);
			local description = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDescription();
			if (string.len(description) > 0) then
				desc = description;
			end;

			self:GetChild("baseSimpleFrame"):GetChild("titleMissionBasic"):settext("");
			self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):settext(desc);
			self:GetChild("baseSimpleFrame"):GetChild("descMissionBasic"):zoom(0.9):y(-5);

		else
			self:visible(false);
		end;
	end;	

	SelectChannelMessageCommand=cmd(finishtweening;visible,false);
	OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);

	Def.ActorFrame{

		Name="baseSimpleFrame";
		OnCommand=cmd(y,-580;x,SCREEN_CENTER_X;visible,false);
		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.15;y,SCREEN_CENTER_Y-10);
		OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/simpleBase"))..{	
			Name="missionBaseBasic";
			InitCommand=cmd(zoom,.65);
			OnCommand=cmd(zoom,.65);
			OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
		};

		LoadFont("_myriad pro")..{
			Name="titleMissionBasic";
			InitCommand=cmd(zoom,0.8;visible,true;shadowlength,2;y,-6);
			OnCommand=function(self)
				self:settext("TITLE MISSION");
			end;
		};

		LoadFont("_myriad pro")..{
			Name="descMissionBasic";
			InitCommand=cmd(zoom,0.6;visible,true;shadowlength,2;y,8);
			OnCommand=function(self)
				self:settext("DESC MISSION");
			end;
		};
	};


	Def.ActorFrame{
		Name="baseFullFrame";
		OnCommand=cmd(y,-580;x,SCREEN_CENTER_X;visible,false);
		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.15;y,SCREEN_CENTER_Y-40);
		OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/fullBase"))..{	
			Name="missionBaseFull";
			InitCommand=cmd(zoom,.65);
			OnCommand=cmd(zoom,.65);
			OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
		};

		LoadFont("_myriad pro")..{
			Name="titleMissionFull";
			InitCommand=cmd(zoom,0.8;visible,true;shadowlength,2;y,-22);
			OnCommand=function(self)
				self:settext("TITLE MISSION");
			end;
		};

		LoadFont("_myriad pro")..{
			Name="descMissionFull";
			InitCommand=cmd(zoom,0.6;visible,true;shadowlength,2;y,-5);
			OnCommand=function(self)
				self:settext("DESC MISSION");
			end;
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/missionStatus 1x2"))..{	
			Name="missionStatusFull";
			InitCommand=cmd(animate,false;zoom,.35;blend,"BlendMode_Add");
			OnCommand=cmd(animate,false;zoom,.35);
			SongChosenMessageCommand=cmd(stoptweening;x,205;y,-36);
			OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
		};
	};
};

-- Iconos en quest 
local StateIco; 
t[#t+1] = Def.ActorFrame
{
	-- Hago esto para no repetir el for 5 veces (e incluso 9 veces), solo 1 vez y ya alv
	SongChosenMessageCommand=cmd(queuecommand,"CheckQuestMods");
	ChangeStepsMessageCommand=cmd(queuecommand,"CheckQuestMods");
	CheckQuestModsCommand=function(self)
		StateIco = GetValidQuestMods( GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ) );
	end;
}

for i=1,9,1 do
	t[#t+1] = LoadActor(THEME:GetPathG("","SC-CW_ICONS"))..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-10;visible,false;setstate,0;animate,false);
		SongChosenMessageCommand=cmd(diffusealpha,0;sleep,.2;queuecommand,"CheckQuestMods");
		ChangeStepsMessageCommand=cmd(queuecommand,"CheckQuestMods");
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		CheckQuestModsCommand=function(self)
			if GAMESTATE:GetQuestZoneChannel() then
				self:visible(false);
				if (StateIco[i] ~= nil) then
					self:setstate(StateIco[i] - 1);
					--self:x(SCREEN_CENTER_X-270 + (50 * i));
					--self:x(SCREEN_CENTER_X-75 + (50 * i)); -> 2
					-- self:x(SCREEN_CENTER_X-50 + (50 * i)); -> 1

					self:x( (SCREEN_CENTER_X - (50 + (25* (#StateIco-1) ) )  ) + (50 * i));

					self:visible(true);
					self:diffusealpha(1);
					self:zoom(0.65);
				end;
			end;
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};
end;


--**********************************
--*** 5 - SURVIVAL  		   ***
--**********************************
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/base"))..{
		InitCommand=cmd(animate,false;zoom,.65;y,SCREEN_CENTER_Y-110;x,SCREEN_CENTER_X;visible,false);
		OnCommand=cmd(animate,false;zoom,.65;y,SCREEN_CENTER_Y-110;x,SCREEN_CENTER_X;visible,false);
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		SongChosenMessageCommand=function(self)
			if GAMESTATE:GetSurvivalChannel() then
				self:finishtweening();
				self:visible(true);
			end;
		end;
		OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
	};
	
	LoadFont("_myriad pro")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-110;zoom,.85;x,SCREEN_CENTER_X;visible,false;shadowlength,2);
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		SongChosenMessageCommand=function(self)
			if GAMESTATE:GetSurvivalChannel() then
				local SurvivorLevel = 25;
				local GradeGoal = SurvivalGradeToText( GAMESTATE:GetExpectedSurvivalGrade() );
				self:settext( GetSurvivalTextToPanel( SurvivorLevel , GradeGoal) ) 

				self:visible(true);
			end;
		end;
		SurvivalMenuCloseMessageCommand=function(self, params)
			if GAMESTATE:GetSurvivalChannel() then
				local SurvivorLevel = 25;
				local GradeGoal = SurvivalGradeToText( params.current );
				self:settext( GetSurvivalTextToPanel( SurvivorLevel , GradeGoal) )

				self:visible(true);
			end;
		end;
		OffCommand=cmd(finishtweening;linear,.2;y,-240);
	};
	
};

t[#t+1] = LoadActor(THEME:GetPathB("","SurvivalMode/OnSelectMusic"));

--**********************************
--*** 6 - BASIC INTERFACE	   ***
--**********************************


if GAMESTATE:GetGameMode() == 'Basic' then
	--basic list, this is permanent or be in this file.
	t[#t+1] =  LoadActor("ScreenSelectMusicLua/0_Interface_Basic_Level_List") .. {
		InitCommand=cmd(y,-30);
		OnCommand=cmd(stoptweening;decelerate,0.2;y,8);
		SelectChannelMessageCommand=cmd(stoptweening;decelerate,0.1;y,-30;diffusealpha,0;);
		ChannelChosenMessageCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.2;y,8);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;y,-30;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.2;y,8);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

	};

	t[#t+1]=LoadActor("ScreenSelectMusicLua/0_Interface_Basic_Base")..{
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() == 'Basic');
		FullModeMessageCommand=cmd(playcommand,"On");
	};
end;

--*************************
--*** CHART INFO   ***
--*************************



if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	t[#t+1] = getChartInfoBox(PLAYER_1)..{
		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

	};
end;
if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t+1] = getChartInfoBox(PLAYER_2)..{

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};
end;

--**********************************
--*** 7 - FULL INTERFACE	   ***
--**********************************

--Break on icon.
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	t[#t+1] = breakOnItem(PLAYER_1);
	--here to bypass the screen evaluation if we get a break from a mode
	GAMESTATE:Env()["BreakFromMode"] = false;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t+1] = breakOnItem(PLAYER_2);
	--here to bypass the screen evaluation if we get a break from a mode
	GAMESTATE:Env()["BreakFromMode"] = false;
end;

t[#t+1] =  Def.ActorFrame
{
	LoadActor("ScreenSelectMusicLua/0_Interface_Full_Base")..{
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= 'Basic');
		--OnCommand=cmd(visible,true);
		FullModeMessageCommand=cmd(playcommand,"On");
	};

	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_1);
		InitCommand=cmd(xy,SCREEN_CENTER_X-594,SCREEN_CENTER_Y-268);
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= "Quest");
		PlayerJoinedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then 
				self:queuecommand("On");
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"CheckNew");
		CheckNewCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST"  then
					self:visible(false);
				else
					self:visible(true);
				end;
			else
				self:visible(false);
			end;
		end;

		ProfileWindowCloseMessageCommand=function(self,params)
			if params.PN == PLAYER_1 then 
				self:queuecommand("On");
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;


	};
	
	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_2);
		InitCommand=cmd(xy,SCREEN_CENTER_X+120,SCREEN_CENTER_Y-268);
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= "Quest");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"CheckNew");
		CheckNewCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST"  then
					self:visible(false);
				else
					self:visible(true);
				end;
			else
				self:visible(false);
			end;
		end;
		PlayerJoinedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then 
				self:queuecommand("On");
			end;
		end;

		ProfileWindowCloseMessageCommand=function(self,params)
			if params.PN == PLAYER_2 then 
				self:queuecommand("On");
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

	};

};


--******************************************
--*** 8 - ANIMATION INTERFACE	- RANKING  ***
--******************************************
t[#t+1] =  Def.ActorFrame
{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		FullModeCWMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
		FullModeMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
		RankModeCWMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/blurback"))..{
		OnCommand=cmd(zoom,0;y,SCREEN_CENTER_Y-80;x,SCREEN_CENTER_X+600;animate, true;SetAllStateDelays,0.05725;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.2;queuecommand,"AnimateMode");
		FullModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.15;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.15;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoom,0.5;linear,0.5;zoomy,.6;zoomx,.8;x,SCREEN_CENTER_X+600;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/blurback"))..{
		OnCommand=cmd(zoom,0;y,SCREEN_CENTER_Y-80;x,SCREEN_CENTER_X-600;animate, true;SetAllStateDelays,0.05725;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.2;queuecommand,"AnimateMode");
		FullModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.15;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.15;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoom,0.5;linear,0.5;zoomy,.6;zoomx,.8;x,SCREEN_CENTER_X-600;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-RANKFIREBACK"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.17;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,0;zoomy,0;linear,0.05;zoomy,1;vibrate;effectmagnitude,3,3,3;diffusealpha,1;linear,0.3;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-FULLMODELABEL"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false);
		FullModeCWMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.2;setstate,1;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoomy,0;linear,0.05;zoomy,1;linear,0.1;glow,1,1,1,0.17;linear,0.1;glow,1,1,1,0;sleep,0.1;linear,0.2;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-MODEBACKFX"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false;blend,Blend.Add);
		FullModeCWMessageCommand=cmd(finishtweening;sleep,0.05;setstate,0;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.17;setstate,1;queuecommand,"AnimateModeRank");
		AnimateModeCommand=cmd(diffusealpha,0;zoomy,0;sleep,0.05;linear,0.2;zoomy,1;diffusealpha,.8;linear,0.65;diffusealpha,0);
		AnimateModeRankCommand=cmd(diffusealpha,0;zoomy,0;linear,0.05;vibrate;effectmagnitude,3,3,3;zoomy,1;diffusealpha,.8;sleep,.2;linear,.5;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	
	Def.Sound {
		FinalizedMessageCommand=cmd(stoptweening;queuecommand,"PlaySound");
		PlaySoundCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("","JoinGamePlay"));
		end;
	};
}

--******************************************
--*** 9 - CHECK ASPECT RATIO  	     ***
--******************************************

local function Visible()
	return GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin();
end;

local ARRAY={};
ARRAY[-1] = PLAYER_1;
ARRAY[1] = PLAYER_2;

--[[
--Check 4:3
local curAspect = round(GetScreenAspectRatio(),5);
if curAspect <= 1.33333 then -- 4:3
	t[#t+1] = Def.ActorFrame {
		Def.Quad{
			InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		};
		LoadFont("normalxolonium")..{
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;settext,"Sanity Select Music Style is only compatible under\n 16:9 or 16:10 Display Aspect Ratio");
		};
	};

end;
]]
--********************************
--*** 10 - PROFILE SELECTOR    ***
--********************************
for i=-1,1,2 do
	t[#t+1] = Def.ActorFrame {


		Def.Quad{
			InitCommand=cmd(xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 302 or -300),SCREEN_CENTER_Y;setsize,400,SCREEN_HEIGHT;diffuse,color('0,0,0,1');diffusealpha,0);
			OnCommand=function(self)
			end;
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0.8);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeperfilback"))..{
			OnCommand=cmd(zoom,0.75;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),250;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 					
					self:diffusealpha(0);
				end;	
			end;				
		};

		Def.Quad{
			InitCommand=cmd(xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 302 or -300),254.3;setsize,220,25;diffuse,color('1,1,1,1');diffusealpha,0);
			OnCommand=function(self)
			end;

			ProfileWindowMoveMessageCommand=function(self,params)	
			self:faderight(0.5);
			self:fadeleft(0.5);		
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:cropright(1);
						self:linear(0.1);
						self:diffusealpha(0.8);
						self:cropright(0);
						self:linear(0.2);
						self:diffusealpha(0);						
					else
						self:finishtweening();
						self:cropleft(1);
						self:linear(0.1);
						self:diffusealpha(0.8);						
						self:cropleft(0);
						self:linear(0.2);
						self:diffusealpha(0);						
					end;
				end;
			end;				
		};


		LoadFont("_XoloPlayer")..{
			InitCommand=cmd(xy,SCREEN_CENTER_X + 300 * i,250;zoom,1.2;visible,false);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(true);
					self:settext(params.NAME);
				end;
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(false);
				end;
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(false);
				end;
			end;
			ProfileWindowMoveMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(true);
					self:settext(params.NAME);
				end;
			end;

			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:cropright(1);
						self:linear(0.1);
						self:cropright(0);
						self:linear(0.2);					
					else
						self:finishtweening();
						self:cropleft(1);
						self:linear(0.1);					
						self:cropleft(0);
						self:linear(0.2);					
					end;
					self:settext(params.NAME);
				end;
			end;	

		};


		--INFO
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_info"))..{
			OnCommand=cmd(zoom,0.75;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),330;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueleft"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),326;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueleft"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),326;diffusealpha,0;blend,"BlendMode_Add");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	

			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:linear(0.05);
						self:diffusealpha(1);
						self:linear(0.05);
						self:diffusealpha(0);			
					else
						self:finishtweening();				
					end;
				end;
			end;	

		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueright"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 430 or -170),326;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueright"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 430 or -170),326;diffusealpha,0;blend,"BlendMode_Add");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();		
					else
						self:finishtweening();
						self:linear(0.05);
						self:diffusealpha(1);
						self:linear(0.05);
						self:diffusealpha(0);				
					end;
				end;
			end;	
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_center"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),324;diffusealpha,0;queuecommand,"Animate");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(1);
					self:queuecommand("Animate");
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;	

			AnimateCommand=function(self)
				self:linear(0.4);
				self:y(322);
				self:linear(0.4);
				self:y(326);
				self:queuecommand("Animate");
			end;	

			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;	
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_textselect"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),343;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};


	};
end;



for i=-1,1,2 do
	t[#t+1] = Def.ActorFrame {
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
			OnCommand=cmd(zoom,0.4;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),254.3;diffusealpha,0);

			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;	
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowMoveMessageCommand=function(self,params)			
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening():addx(-5):linear(0.125):addx(5);
					end;
				end;
			end;			
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
			OnCommand=cmd(rotationz,180;zoom,0.4;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 432 or -168),252;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;	
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;			
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowMoveMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					if params.DIR == 1 then
						self:finishtweening():addx(5):linear(0.125):addx(-5);
					end;
				end;
			end;			
		};



	};
end;

--********************************
--*** 11 - PROFILE PLAYER      ***
--********************************

--* i dont want to do this ; _; 
--* little thing to show a message and reload the screen when a player joins when the active gamemode is "Basic"
--* IDK why when you join in basicmode it not go to the "ScreenJoin", it just insert the player >:(
--* This fixes the problem of the joined player with no sprites for selecting mode.
--* HELP
t[#t+1] = Def.ActorFrame
{
	LoadActor( THEME:GetPathG("","ScreenSelectMusic/default_back_1.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	};	

	LoadActor( THEME:GetPathG("","LOGO/back2.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	};

	Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.3);
	};


	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(glow,color("1,1,1,1");Center;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,1);
	};	

	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(blend,Blend.Add;glow,color("1,1,1,1");Center;addx,-1;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,0.6);
	};

	OnCommand=function(self)
		self:visible(false);
	end;

	PlayerJoinedMessageCommand=function(self)
		if GAMESTATE:GetGameMode() == 'Basic' then
			self:visible(true);	
			SCREENMAN:SetNewScreen( SCREENMAN:GetTopScreen():GetName() );			 
		end;
	end;			
}



-- the check of print this default profile is in the lua, check it there.
t[#t+1] =  Def.ActorFrame
{
	LoadActor("profile/default")..{
		OnCommand=function(self)
			self:zoom(1.15);
			self:x(-100);
		end;
	};
}

--check if we are using a skin for the profile.
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	local profileSkinData = getProfileSkinPlayer(PLAYER_1);
	if profileSkinData["isDefault"] == false then
		local profileFrameSkinFunc = LoadActor(profileSkinData["luaPath"]);
		t[#t+1] = profileFrameSkinFunc(profileSkinData["basePathSkin"],PLAYER_1,"ScreenSelectMusic");
	end;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local profileSkinData = getProfileSkinPlayer(PLAYER_2);
	if profileSkinData["isDefault"] == false then
		local profileFrameSkinFunc = LoadActor(profileSkinData["luaPath"]);
		t[#t+1] = profileFrameSkinFunc(profileSkinData["basePathSkin"],PLAYER_2,"ScreenSelectMusic");
	end;
end;



t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:zoom(0.75);
		self:x(SCREEN_CENTER_X);
	end;


		
	LoadActor("SaniNetMusic")..
	{
		OnCommand=function(self)
		end;

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Username == '' then
		        	self:visible(false);
		        	return;
			end;
			
		end;		

		SaniNetRoomMessageCommand=function(self,params)
			if params.Username == '' then
		        	self:visible(false);
		        	return;
			end;
		end;

	};

	Def.Quad{
		InitCommand=cmd(y,SCREEN_TOP + 180;setsize,SCREEN_WIDTH,50;zoomx,0;diffuse,color('0,0,0,0');faderight,0.5;fadeleft,0.5;);
		SaniNetErrorMessageMessageCommand=function(self, params)
			if GAMESTATE:GetGameMode() == 'Basic' then
				return;
			end;

			if #GAMESTATE:Env()["saninetUsername"] == 0 then
				return;
			end;
			
			if params.Message == 0 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			elseif params.Message == 1 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			elseif params.Message == 3 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};
	LoadFont("normalxolonium")..{
		InitCommand=cmd(y,SCREEN_TOP + 180;shadowlength,1;shadowcolor,color("#00000");zoom,.84;diffuse,color('1,1,0,0'));
		SaniNetErrorMessageMessageCommand=function(self, params)
			if GAMESTATE:GetGameMode() == 'Basic' then
				return;
			end;

			if #GAMESTATE:Env()["saninetUsername"] == 0 then
				return;
			end;

		 	if params.Message == 0 then	--on join
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Please log off from Saninet to enable two players play");
			elseif params.Message == 1 then	--on actions
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Saninet services are only available for single player");
			elseif params.Message == 3 then --on status
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Saninet services are only available for single player");
			end;
		end;
		
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};
}


--****************************
--*** 0 - THEME PARTS 	   ***
--****************************

t[#t+1] = LoadActor("ScreenSelectMusicLua/keyinfo")..{
		OnCommand=cmd(visible,true);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};

if isUsingDefaultSkin or GAMESTATE:GetGameMode() == 'Basic' then

	t[#t+1] = LoadActor("ScreenSelectMusicLua/parts")..{
			OnCommand=cmd(visible,true);
			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;	
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;				
	};
end;

--HEADER BASIC MODE
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICHEADER"))..{
		InitCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' and PREFSMAN:GetPreference("MenuTimer") == false then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;

		OnCommand=function(self)
			self:y(SCREEN_TOP+28);
			self:x(SCREEN_CENTER_X);
			self:zoom(0.6);
		end;

		FullModeMessageCommand=cmd(stoptweening;visible,false);

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};


--HEADER BASIC MODE
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/simple_basicheader"))..{
		InitCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' and PREFSMAN:GetPreference("MenuTimer") then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;

		OnCommand=function(self)
			self:y(SCREEN_CENTER_Y+20);
			self:x(SCREEN_CENTER_X);
			self:zoom(0.6);	
		end;

		FullModeMessageCommand=cmd(stoptweening;visible,false);

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};

--*************************
--*** 2 - NAV ARROWS    ***
--*************************
if isUsingDefaultSkin then
	local zoomNavArrow = 0.72;
	t[#t+1] =  Def.ActorFrame
	{
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="UL_Arrow";
			InitCommand=cmd(animate,false;setstate,GAMESTATE:GetGameMode() == 'Basic' and 4 or 0;y,34;x,35;zoom,zoomNavArrow);
			FullModeMessageCommand=cmd(finishtweening;setstate,0;diffusealpha,1);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			InitCommand=cmd(animate,false;setstate,GAMESTATE:GetGameMode() == 'Basic' and 4 or 0;y,34;x,35;zoom,zoomNavArrow;blend,"BlendMode_Add");
			OnCommand=function(self)
				self:linear(0.35);
				self:zoom(1);
				self:diffusealpha(0);
			end;
			FullModeMessageCommand=cmd(finishtweening;setstate,0;diffusealpha,1;queuecommand,"On");
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="UL_Arrow_Glow";
			InitCommand=cmd(animate,false;setstate,0;y,34;x,35;blend,'BlendMode_Add';queuecommand,"Effect";zoom,zoomNavArrow);
			EffectCommand=cmd(diffusealpha,0;linear,1;diffusealpha,.3;linear,1;diffusealpha,0;queuecommand,"Effect");
			--SelectChannelMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.5;diffusealpha,0;queuecommand,"Effect");
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="UR_Arrow";
			InitCommand=cmd(animate,false;setstate,GAMESTATE:GetGameMode() == 'Basic' and 5 or 1;y,34;x,SCREEN_WIDTH-34;zoom,zoomNavArrow);
			FullModeMessageCommand=cmd(finishtweening;setstate,1;diffusealpha,1);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			InitCommand=cmd(animate,false;setstate,GAMESTATE:GetGameMode() == 'Basic' and 5 or 1;y,34;x,SCREEN_WIDTH-34;zoom,zoomNavArrow;blend,"BlendMode_Add");
			FullModeMessageCommand=cmd(finishtweening;setstate,1;diffusealpha,1;queuecommand,"On");
			OnCommand=function(self)
				self:linear(0.35);
				self:zoom(1);
				self:diffusealpha(0);
			end;
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="UR_Arrow_Glow";
			InitCommand=cmd(zoom,zoomNavArrow;animate,false;setstate,1;y,34;x,SCREEN_WIDTH-34;blend,'BlendMode_Add';queuecommand,"Effect");
			EffectCommand=cmd(diffusealpha,0;linear,1;diffusealpha,.3;linear,1;diffusealpha,0;queuecommand,"Effect");
			--SelectChannelMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.5;diffusealpha,0;queuecommand,"Effect");
			FullModeMessageCommand=cmd(finishtweening;queuecommand,"Effect");
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="DL_Arrow";
			InitCommand=cmd(zoom,zoomNavArrow;animate,false;setstate,8;y,SCREEN_HEIGHT-35;x,34)
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			InitCommand=cmd(zoom,zoomNavArrow;animate,false;setstate,8;y,SCREEN_HEIGHT-35;x,34;blend,"BlendMode_Add");
			OnCommand=function(self)
				self:linear(0.35);
				self:zoom(1);
				self:diffusealpha(0);
			end;
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="DL_Arrow_Glow";
			InitCommand=cmd(diffusealpha,0;zoom,zoomNavArrow;animate,false;setstate,8;y,SCREEN_HEIGHT-35;x,34;blend,'BlendMode_Add');
			PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,1;linear,.2;diffusealpha,0);
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="DR_Arrow";
			InitCommand=cmd(zoom,zoomNavArrow;animate,false;setstate,9;y,SCREEN_HEIGHT-35;x,SCREEN_WIDTH-34)
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			InitCommand=cmd(zoom,zoomNavArrow;animate,false;setstate,9;y,SCREEN_HEIGHT-35;x,SCREEN_WIDTH-34;blend,"BlendMode_Add");
			OnCommand=function(self)
				self:linear(0.35);
				self:zoom(1);
				self:diffusealpha(0);
			end;
		};

		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/NAVARROW"))..{
			Name="DR_Arrow_Glow";
			InitCommand=cmd(diffusealpha,0;zoom,zoomNavArrow;animate,false;setstate,9;y,SCREEN_HEIGHT-35;x,SCREEN_WIDTH-34;blend,'BlendMode_Add');
			NextSongMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,1;linear,.2;diffusealpha,0);
		};
		
		
		
		LoadActor(THEME:GetPathG("","SSM-ARREFX"))..{
			Name="PRESS_FX";
			InitCommand=cmd(animate,false;zoom,.74;y,SCREEN_HEIGHT-50;x,SCREEN_WIDTH-50;diffusealpha,0;blend,'BlendMode_Add');
			PreviousSongMessageCommand=cmd(finishtweening;visible,true;Center;x,50;y,SCREEN_HEIGHT-50;diffusealpha,0.2;skewx,0;skewy,0;rotationy,180;rotationz,0;linear,0.125;skewx,-0.25;skewy,-0.25;diffusealpha,.2;linear,0.125;diffusealpha,0;skewx,-0.5;skewy,-0.5);
			NextSongMessageCommand=cmd(finishtweening;visible,true;Center;x,SCREEN_WIDTH-50;y,SCREEN_HEIGHT-50;diffusealpha,0.2;skewx,0;skewy,0;rotationy,0;rotationz,0;linear,0.125;skewx,-0.25;skewy,-0.25;diffusealpha,.2;linear,0.125;diffusealpha,0;skewx,-0.5;skewy,-0.5);
		};
		
		LoadActor(THEME:GetPathG("","SSM-ARREFX"))..{
			OnCommand=cmd(diffusealpha,0;zoom,.74;blend,"BlendMode_Add");		
			SelectChannelMessageCommand=function(self, params)
				self:finishtweening():visible(true):Center():y(50):diffusealpha(0.1):skewx(0):skewy(0):rotationz(90);
				if params.Direction == -1 then
					self:x(50):rotationy(180);
				elseif params.Direction == 1 then
					self:x(SCREEN_WIDTH-50):rotationy(0);
				else
					self:visible(false);
				end;
				self:linear(0.125):skewx(-0.25):skewy(-0.25):diffusealpha(.3):linear(0.125):diffusealpha(0):skewx(-0.5):skewy(-0.5);
			end;
			FilterTwoMessageCommand=function(self, params)
				self:finishtweening():visible(true):Center():y(50):diffusealpha(0.1):skewx(0):skewy(0):rotationz(90);
				self:x(SCREEN_WIDTH-50):rotationy(0);
				self:linear(0.125):skewx(-0.25):skewy(-0.25):diffusealpha(.3):linear(0.125):diffusealpha(0):skewx(-0.5):skewy(-0.5);
			end;
		};	
		
		LoadActor(THEME:GetPathG("","SSM-ARREFX"))..{
			OnCommand=cmd(diffusealpha,0;zoom,.74;blend,"BlendMode_Add");		
			ChangeStepsMessageCommand=function(self,params)			
				self:finishtweening():visible(true):Center():y(SCREEN_HEIGHT-50):diffusealpha(0.1):skewx(0):skewy(0):rotationz(0);
				if params.Direction == -1 then
					self:x(50):rotationy(180);
				elseif params.Direction == 1 then
					self:x(SCREEN_WIDTH-50):rotationy(0);
				else
					self:visible(false);
				end;
				self:linear(0.125):skewx(-0.25):skewy(-0.25):diffusealpha(.3):linear(0.125):diffusealpha(0):skewx(-0.5):skewy(-0.5);
			end;
			
			FilterOneMessageCommand=function(self, params)
				self:finishtweening():visible(true):Center():y(50):diffusealpha(0.5):skewx(0):skewy(0):rotationz(90);
				self:x(50):rotationy(180);
				self:linear(0.125):skewx(-0.25):skewy(-0.25):diffusealpha(.3):linear(0.125):diffusealpha(0):skewx(-0.5):skewy(-0.5);
			end;
		};
		
		SelectChannelMessageCommand=function(self)
			self:GetChild("UR_Arrow"):finishtweening();
			self:GetChild("UR_Arrow_Glow"):finishtweening();
			
			self:GetChild("UL_Arrow"):finishtweening();
			self:GetChild("UL_Arrow_Glow"):finishtweening();
			
			if (GAMESTATE:GetFilterTwo() == 'FilterTwo_Level') then
				self:GetChild("UR_Arrow"):setstate(15);
				self:GetChild("UR_Arrow_Glow"):setstate(15);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Category') then
				self:GetChild("UR_Arrow"):setstate(11);
				self:GetChild("UR_Arrow_Glow"):setstate(11);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Channel') then
				self:GetChild("UR_Arrow"):setstate(7);
				self:GetChild("UR_Arrow_Glow"):setstate(7);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Quests') then
				self:GetChild("UR_Arrow"):setstate(14);
				self:GetChild("UR_Arrow_Glow"):setstate(14);
			else
				self:GetChild("UR_Arrow"):setstate(3);
				self:GetChild("UR_Arrow_Glow"):setstate(3);
			end;
			
			if (GAMESTATE:GetFilterOne() == 'FilterOne_Double') then
				self:GetChild("UL_Arrow"):setstate(10);
				self:GetChild("UL_Arrow_Glow"):setstate(10);
			elseif (GAMESTATE:GetFilterOne() == 'FilterOne_Single') then
				self:GetChild("UL_Arrow"):setstate(6);
				self:GetChild("UL_Arrow_Glow"):setstate(6);
			else
				self:GetChild("UL_Arrow"):setstate(2);
				self:GetChild("UL_Arrow_Glow"):setstate(2);
			end;
			
			self:GetChild("UR_Arrow_Glow"):queuecommand("Effect");
			self:GetChild("UL_Arrow_Glow"):queuecommand("Effect");
		end;
		
		ChannelChosenMessageCommand=function(self)
			self:GetChild("UL_Arrow"):finishtweening():setstate(0);
			self:GetChild("UR_Arrow"):finishtweening():setstate(1);
			
			self:GetChild("UL_Arrow_Glow"):finishtweening():setstate(0);
			self:GetChild("UR_Arrow_Glow"):finishtweening():setstate(1);
			
			--self:GetChild("UL_Arrow_Glow"):finishtweening():setstate(0):diffusealpha(1):linear(.1):diffusealpha(0):queuecommand("Effect");
			--self:GetChild("UR_Arrow_Glow"):finishtweening():setstate(1):diffusealpha(1):linear(.1):diffusealpha(0):queuecommand("Effect");
			--
			--self:GetChild("DL_Arrow_Glow"):finishtweening():diffusealpha(1):linear(.1):diffusealpha(0):queuecommand("Effect");
			--self:GetChild("DR_Arrow_Glow"):finishtweening():diffusealpha(1):linear(.1):diffusealpha(0):queuecommand("Effect");
		end;
		
		FilterTwoMessageCommand=function(self, params)
			self:GetChild("UR_Arrow"):finishtweening();
			self:GetChild("UR_Arrow_Glow"):finishtweening();
			local statenum = 3;
			if (GAMESTATE:GetFilterTwo() == 'FilterTwo_Level') then
				statenum = 15;
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Category') then
				statenum = 11;
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Channel') then
				statenum = 7;
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Quests') then
				statenum = 14;
			end;
			self:GetChild("UR_Arrow"):setstate( statenum );
			self:GetChild("UR_Arrow_Glow"):setstate( statenum ):diffusealpha(1):linear(.5):diffusealpha(0):queuecommand("Effect");
		end;
		
		FilterOneMessageCommand=function(self, params)
			self:GetChild("UL_Arrow"):finishtweening();
			self:GetChild("UL_Arrow_Glow"):finishtweening();
			
			local statenum = 2;
			if (GAMESTATE:GetFilterOne() == 'FilterOne_Double') then
				statenum = 10;
			elseif (GAMESTATE:GetFilterOne() == 'FilterOne_Single') then
				statenum = 6;
			end;
			self:GetChild("UL_Arrow"):setstate( statenum );
			self:GetChild("UL_Arrow_Glow"):setstate( statenum ):diffusealpha(1):linear(.5):diffusealpha(0);
			
			self:GetChild("UL_Arrow_Glow"):queuecommand("Effect");
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
	};
end;





--*************************
--*** GRAPH   ***
--*************************

t[#t+1] = LoadActor("ScreenSelectMusicLua/graphsong")..{

		OnCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FullModeMessageCommand=function(self)
			self:visible(true);
		end;

		SongChosenMessageCommand=function(self)

				if GAMESTATE:GetGameMode() ~= 'Basic' and not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
					self:visible(true);
				else
					self:visible(false);
				end;

		end;

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:diffusealpha(0);
			else
				self:diffusealpha(1);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

};




--*************************
--*** VS   ***
--*************************
if GAMESTATE:GetNumSidesJoined() == 2 then
	t[#t+1] = LoadActor("ScreenSelectMusicLua/vsparts")..{
		OnCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;

			if checkVsMode() == false then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FullModeMessageCommand=cmd(playcommand,"On");

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		CheckSelectedMessageCommand=function(self,params)
			if checkVsMode() == false then
				self:visible(false);
			elseif checkVsMode() then
				self:visible(true);
			end;
		end;	

		SelectChannelMessageCommand=function(self)
			self:diffusealpha(0);
		end;

		ChannelChosenMessageCommand=function(self)
			self:linear(0.15);
			self:diffusealpha(1);
		end;

	};
end;

--*************************
--*** RANKING   ***
--*************************

local isSaninetRankingActive =false;
if GAMESTATE:GetNumSidesJoined() == 1 and #GAMESTATE:Env()["saninetUsername"] == 0 then
	Trace("::::::::::::::::::::: LOCAL RANK!")
	--t[#t+1] = LoadActor("ScreenSelectMusicLua/ranking")..{
	t[#t+1] = LoadActor("ScreenSelectMusicLua/newRank")..{
			--OnCommand=cmd(visible,true);
			OnCommand=function(self)
				if GAMESTATE:GetGameMode() ~= 'Basic' then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;		
			SongChosenMessageCommand=function(self)

				if isSaninetRankingActive then
					self:visible(false);
					return;				
				end;
				
				if GAMESTATE:GetGameMode() ~= 'Basic' then
					self:visible(true);

					if GAMESTATE:GetMusicTrainChannel()  or GAMESTATE:GetProgressiveChannel() then
						self:visible(false);
					else
						self:visible(true);
					end;
				else
					self:visible(false);
				end;


			end;

			FullModeMessageCommand=cmd(playcommand,"On");
			
			SaniNetClientStateMessageCommand=function(self,params)
				if params.Username ~= '' then
					self:visible(false);
					isSaninetRankingActive = true;			
				end;
			end;
	};
else
	Trace("::::::::::::::::::::: NO LOCAL RANK!");
	Trace("saninet id: "..GAMESTATE:Env()["saninetConnectionId"]);

end;

--**********************
-- Exit message.
--**********************
if PREFSMAN:GetPreference("AllowUnjoinShortcut") then
	local langMsgExit = PREFSMAN:GetPreference('Language');
	local imgExitLang = langMsgExit.."_exit";

	t[#t+1] =  Def.ActorFrame
	{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-250);
			self:visible(false);
			self:zoom(0.7)

			if isAspectRatio43() then
				self:y(SCREEN_CENTER_Y-320);
			end;

		end;

		SelectChannelMessageCommand=function(self)
			self:visible(true);
		end;
		ChannelChosenMessageCommand=function(self)
			self:visible(false);
		end;
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMessage/"..imgExitLang))..{
			InitCommand=cmd();
		};
	}
end;


--**********************
--** PERFORMANCE MODE **
--**********************
local imgTextPerformance = PREFSMAN:GetPreference('Language').."_option_text";
--local imgTextPerformance = "ko_option_text";
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP+70);
		self:zoom(0.55);

	    	SCREENMAN:GetTopScreen():AddInputCallback(function(event)
	      	if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F7" then
	      		changePerformanceModeType();
	      		self:GetChild("bigPerformanceOption"):stoptweening():queuecommand("Ani");
	      		local ptype = getPerformanceModeType();
	      		local posOpt = {-137,-60,32,124};
	      		if ptype == 0 then
	      			self:GetChild("bigPerformanceOption"):GetChild("optSelect"):x(posOpt[ptype+1]);

	      			self:GetChild("bigPerformanceOption"):GetChild("opt1"):setstate(0);
	      			self:GetChild("bigPerformanceOption"):GetChild("opt2"):setstate(0);
	      			self:GetChild("bigPerformanceOption"):GetChild("opt3"):setstate(0);
	      			self:GetChild("pmTypeSelected"):setstate(ptype);
	      			PREFSMAN:SetPreference("SongBackgrounds", true);

					self:stoptweening():sleep(2):linear(1):diffusealpha(0);
	      		else 
	      			self:stoptweening():linear(0.2):diffusealpha(1);
	      			if ptype == 1 then
		      			self:GetChild("bigPerformanceOption"):GetChild("opt1"):setstate(1);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt2"):setstate(0);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt3"):setstate(0);
		      			PREFSMAN:SetPreference("SongBackgrounds", true);
						fastSave();
	      			elseif ptype == 2 then
		      			self:GetChild("bigPerformanceOption"):GetChild("opt1"):setstate(1);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt2"):setstate(1);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt3"):setstate(0);
		      			PREFSMAN:SetPreference("SongBackgrounds", true);
						fastSave();
	      			elseif ptype == 3 then
		      			self:GetChild("bigPerformanceOption"):GetChild("opt1"):setstate(1);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt2"):setstate(1);
		      			self:GetChild("bigPerformanceOption"):GetChild("opt3"):setstate(1);
		      			PREFSMAN:SetPreference("SongBackgrounds", false);
						fastSave();
	      			end;

	      			self:GetChild("pmTypeSelected"):setstate(ptype);
	      			self:GetChild("bigPerformanceOption"):GetChild("optSelect"):x(posOpt[ptype+1]);



	      		end;
	      	end;
	    	end)

	    	self:queuecommand("checkPerformance");

	end;

	OffCommand=function(self)
		self:finishtweening();
		self:linear(0.15);
		self:diffusealpha(0);
	end;

	checkPerformanceCommand=function(self)
		if getPerformanceModeType() == 0 then
			self:diffusealpha(0);
			self:GetChild("pmTypeSelected"):setstate(0);
		else
			self:GetChild("pmTypeSelected"):setstate(getPerformanceModeType());
			self:diffusealpha(1);			
		end;
	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/base_small"))..{
		Name="baseSmall";
	};

	Def.ActorFrame{
		Name="bigPerformanceOption";
		OnCommand=function(self)
			self:diffusealpha(0);
		end;

		AniCommand=function(self)
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(3);
			self:linear(0.2);
			self:diffusealpha(0);

		end;

		OffCommand=function(self)
			self:finishtweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/base_big"))..{
			Name="baseBig";
			OnCommand=function(self)
				self:y(72);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/base_big"))..{
			Name="baseBig";
			OnCommand=function(self)
				self:y(72);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/select"))..{
			Name="optSelect";
			OnCommand=function(self)
				self:x(124); --off -137 | A -60 | B  32 | C 124
				self:y(35);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/type_titles"))..{
			OnCommand=function(self)
				self:x(0);
				self:y(28);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/type_titles"))..{
			OnCommand=function(self)
				self:x(0);
				self:y(28);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/"..imgTextPerformance))..{
			OnCommand=function(self)
				self:x(-30);
				self:y(104);
				self:zoom(1.1);
				if PREFSMAN:GetPreference('Language') == "pt" then
					self:y(102);
				end;
			end;
		};

		-- opt 1
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/pmstatus 1x2"))..{
			Name="opt1";
			OnCommand=function(self)
				self:x(130);
				self:y(74);
				self:animate(false);
				self:setstate(0);
				self:zoom(1.1);
			end;
		};
		-- opt 2
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/pmstatus 1x2"))..{
			Name="opt2";
			OnCommand=function(self)
				self:x(130);
				self:y(103);
				self:animate(false);
				self:setstate(0);
				self:zoom(1.1);
			end;
		};
		-- opt 3
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/pmstatus 1x2"))..{
			Name="opt3";
			OnCommand=function(self)
				self:x(130);
				self:y(133);
				self:animate(false);
				self:setstate(0);
				self:zoom(1.1);
			end;
		};
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/title"))..{
		OnCommand=function(self)
			self:x(-50);
			self:y(1);
		end;
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/performanceMode/pmtype 1x4"))..{
		Name="pmTypeSelected";
		OnCommand=function(self)
			self:animate(false);
			self:setstate(0);
			self:y(-1);
			self:x(120);
		end;
	};



};

t[#t+1] = Def.ActorFrame{
  OnCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
      if (event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F12") and not PROFILEMAN:HasAnyUsbProfile() then
        
        if GAMESTATE:GetNumSidesJoined() == 1 then 
        	if PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) == false then
        		return true
        	end
        else
        	if PROFILEMAN:IsPersistentProfile(PLAYER_1) == false and PROFILEMAN:IsPersistentProfile(PLAYER_2) == false then
        		return true
        	end
  	  end

        local top = SCREENMAN:GetTopScreen()
        top:SetNextScreenName("ScreenPlayerCustomProfile")
        top:StartTransitioningScreen("SM_GoToNextScreen")
        return true

      end
      return false
    end)
  end
}

--t[#t+1] = Def.ActorFrame{
--  OnCommand=function(self)
--    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
--      if (event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F8") then
--        
--		if GAMESTATE:GetNumSidesJoined() == 1 then 
--			if PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) == false then
--				return true
--			end
--		else
--			if PROFILEMAN:IsPersistentProfile(PLAYER_1) == false and PROFILEMAN:IsPersistentProfile(PLAYER_2) == false then
--				return true
--			end
--		end
--
--        SCREENMAN:AddNewScreenToTop("ScreenProfileAnalytics");
--        return true
--
--      end
--      return false
--    end)
--  end
--}

local nonstopCenter = true;

if nonstopCenter then
t[#t+1] = Def.ActorFrame{
	  OnCommand=function(self)
	    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
	      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F5" then
			if GAMESTATE:IsEventMode() then
				if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' then
					local top = SCREENMAN:GetTopScreen();
					top:SetNextScreenName("ScreenCreateOwnTrain");
					top:StartTransitioningScreen("SM_GoToNextScreen");
					return true;
				end
			end;	
	      end;
	      return false;
	    end)
	  end;
	};
else
	local profilerActive = false;
	t[#t+1] = LoadActor("Profiler/ProfilerBase")..{

		  OnCommand=function(self)
		  	self:visible(false);
		    	SCREENMAN:GetTopScreen():AddInputCallback(function(event)
		      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F5" then

			      if SCREENMAN:GetTopScreen():GetSelectionState() == "SelectingSong" then
							
			        if profilerActive then
			        	self:visible(false);
			        	profilerActive = false;
			        else
			        	self:visible(true);
			        	profilerActive = true;
			        end;

			      end;

		      end

		    end)
		  end
	};
end;


--random plugin
t[#t+1] = LoadActor("ScreenSelectMusicLua/selectRandomSongPlugin")..{};


--meckx temp - this is just a test i'm not sure it's going anywhere
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):visible(false);
	end;
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):visible(false);
	end;
	CodeMessageCommand = function(self, params)
		if params.Name == "MeckxFiOne" then
			self:visible(true)
		elseif params.Name == "MeckxFiTwo" then
			self:visible(false)
		end
	end,

	Def.Quad{
		Name="testingmeckx";
		InitCommand=function(self)
			self:zoomto(300, 300):diffuse(color("0,0,0"))
		end,
		OnCommand=function(self)
			self:zoomto(300, 300):diffuse(color("0,0,0"))
		end,		
	},
};

return t;