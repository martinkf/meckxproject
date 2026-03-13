

Branch	= {
	TimerEventMode = function()
			if GAMESTATE:IsEventMode() then
					return 99999;
			else
				if not PREFSMAN:GetPreference("MenuTimer") then
					return 99999;
				end;

				return 0;
			end;

	end;

	GetBackFromOptions = function()
		if PREFSMAN:GetPreference('MainMenu') then
			return "ScreenMainMenu"
		else
			return "ScreenOptionsService"
		end
	end;
	
	GetNextToTitle = function()
		if (SONGMAN:GetNumBasicSongs() == 0) then
			return "ScreenRandomWall"
		end;
		if GAMESTATE:IsEventMode() or PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) then
			return "ScreenRandomWall"
		else
			return "ScreenPreBasicMode"
		end
	end;
	
	--[[
	GetStartScreen = function()
		return "ScreenMainMenu"
	end;
	]]

	GetStartScreen = function()
		if PREFSMAN:GetPreference('MainMenu') then
			return "ScreenMainMenu"
		else
			return "ScreenTitleMenu"
		end
	end;
		
	
	GetMainScreen = function()
		if PREFSMAN:GetPreference('MainMenu') then
			return "ScreenMainMenu"
		else
			return "ScreenTitleMenu"
		end
	end,

	AfterCompany = function()
		--return "ScreenTitleMenu"
		if PREFSMAN:GetPreference('MainMenu') then
			return "ScreenMainMenu"
		else
			return "ScreenTitleMenu"
		end
	end,

	AfterEvaluation = function()
	
		if GAMESTATE:GetSurvivalChannel() then
			GAMESTATE:SetNextSurvivalSong();
			return "ScreenLoadSong";
		end;
		-- EVENT
		if GAMESTATE:IsEventMode() then
		
			if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() or GAMESTATE:GetRandomTrainChannel() then
				return "ScreenSelectMusic";
			else
				for pn in ivalues(PlayerNumber) do
					if GAMESTATE:IsPlayerEnabled(pn) then
						GAMESTATE:JoinPlayer(pn);
					end;
				end;
				if GAMESTATE:GetGameMode() == "WorldMax" then
					return "ScreenWorldMaxLoading";
				elseif GAMESTATE:GetGameMode() == "QuestWorld" then
					return "ScreenQuestWorldLoading";
				elseif GAMESTATE:GetGameMode() == "Infinity" then
					return "ScreenInfinityLoading";
				else
					return "ScreenSelectMusic";
				end
			end
		end;
		
		-- basic mode
		if GAMESTATE:GetGameMode() == 'Basic' and GAMESTATE:GetBiggestNumStagesLeftForAnyHumanPlayer() <= 1 then
			local screen ="ScreenGameOver";

			for pn in ivalues(PlayerNumber) do
				if GAMESTATE:IsPlayerEnabled(pn) then
					screen =  "ScreenUsbResult"
				end;
			end;

			return screen;

			--return "ScreenGameOver";
		elseif ( GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() or GAMESTATE:GetRandomTrainChannel() ) and GAMESTATE:GetBiggestNumStagesLeftForAnyHumanPlayer() <= 1 then
				return "ScreenUsbResult";
		else

			if GAMESTATE:GetBiggestNumStagesLeftForAnyHumanPlayer() <= 0 then
				local screen ="ScreenGameOver";
				
				for pn in ivalues(PlayerNumber) do
					if GAMESTATE:IsPlayerEnabled(pn) then
						--if PROFILEMAN:IsPersistentProfile(pn) then
							screen =  "ScreenUsbResult"
						--end;
					end;
				end;
				return screen;
			else
				if GAMESTATE:GetGameMode() == "WorldMax" then
					if GAMESTATE:NeedBossAnimation() then
						return "ScreenWorldMaxBoss";
					else
						return "ScreenWorldMaxLoading";
					end
				elseif GAMESTATE:GetGameMode() == "QuestWorld" then
					return "ScreenQuestWorldLoading";
				elseif GAMESTATE:GetGameMode() == "Infinity" then
					return "ScreenInfinityLoading";
				else
					return "ScreenSelectMusic";
				end
			end
		end;
		

	end,

	AfterStageBreak = function()	

		-- EVENT
		if GAMESTATE:IsEventMode() then
		
			if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() or GAMESTATE:GetRandomTrainChannel() then
				return "ScreenSelectMusic";
			else
				for pn in ivalues(PlayerNumber) do
					if GAMESTATE:IsPlayerEnabled(pn) then
						GAMESTATE:JoinPlayer(pn);
					end;
				end;
				return "ScreenSelectMusic";
			end
		end;

		local screen ="ScreenEvaluation";

		if GAMESTATE:IsEventMode() and GAMESTATE:GetGameMode() == "Full" then
			--- return "ScreenRandomWall";

			if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() or GAMESTATE:GetRandomTrainChannel() then
				return "ScreenSelectMusic";
			else
				for pn in ivalues(PlayerNumber) do
					if GAMESTATE:IsPlayerEnabled(pn) then
						GAMESTATE:JoinPlayer(pn);
					end;
				end;
				return "ScreenSelectMusic";
			end

		end;


		return screen;
		--[[
		for pn in ivalues(PlayerNumber) do
			if GAMESTATE:IsPlayerEnabled(pn) then
				if PROFILEMAN:IsPersistentProfile(pn) then
					screen =  "ScreenUsbResult"
				end;
			end;
		end;
		]]
				
	end,
	AfterGameplay = function()
		local screen = "ScreenLoadSong";
		if GAMESTATE:GetCurrentStageIndex() <= GAMESTATE:NumTrainSongs() and (GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetProgressiveChannel()) then
			screen =  "ScreenLoadSong";
		else
			-- tqtqtq
			if GAMESTATE:GetGameMode() == "Quest" or GAMESTATE:GetGameMode() == "WorldMax" or GAMESTATE:GetGameMode() == "Infinity" or GAMESTATE:GetGameMode() == "QuestWorld" then
				screen = "ScreenEvaluationQuest";
			else
				screen =  "ScreenEvaluation";
			end;
		end	
		return screen;
	end,	
	BeforeGameplay = function()
		local screen = "ScreenSelectMusic";
		if GAMESTATE:GetGameMode() == "WorldMax" then
			screen =  "ScreenWorldMaxMain";
		elseif GAMESTATE:GetGameMode() == "Infinity" then
			screen = "ScreenInfinityMain";
		elseif GAMESTATE:GetGameMode() == "QuestWorld" then
			screen = "ScreenQuestWorld";
		end
		return screen;
	end,
	GetScreenIndex = function()
		-- no coin mode >:(
		return "ScreenTitleMenu"
	end
};

-- PROFILE LEVEL

local function TitleArray()
	local array=
	{
		{min=1,		max = 4,		title="STARTER",						Color1="#F8F8F8",	Color2="#878787",	Effect="normal",		zoomx= .75},
		{min=5,		max = 14,		title="ROOKIE",							Color1="#FFC6A3",	Color2="#BF7819",	Effect="normal",		zoomx= .75},
		{min=15,	max = 19,		title="EXPLORER",						Color1="#76D7C4",	Color2="#58D68D",	Effect="normal",		zoomx= .75},
		{min=20,	max = 24,		title="INTERMEDIATE",					Color1="#BAFFFC",	Color2="#34AEE0",	Effect="normal",		zoomx= .75},
		{min=25,	max = 31,		title="ADVANCED",						Color1="#F7DC6F",	Color2="#F1C40F",	Effect="transition",	zoomx= .75},
		{min=32,	max = 36,		title="BRAWLER",						Color1="#48C9B0",	Color2="#2ECC71",	Effect="transition",	zoomx= .75},
		{min=37,	max = 41,		title="EXPERT",							Color1="#EC7063",	Color2="#F7DC6F",	Effect="normal",		zoomx= .75},
		{min=42,	max = 46,		title="MENTOR",							Color1="#F39C12",	Color2="#EC7063",	Effect="transition",	zoomx= .75},
		{min=47,	max = 52,		title="SPECIALIST",						Color1="#FFFFFF",	Color2="#FFFFFF",	Effect="normal",		zoomx= .75},
		{min=53,	max = 59,		title="ELITE PLAYER",					Color1="#D438FE",	Color2="#FE3886",	Effect="normal",		zoomx= .75},
		{min=60,	max = 64,		title="[F]ANATIC PLAYER",				Color1="#FA008C",	Color2="#FA0000",	Effect="transition",	zoomx= .7},
		{min=65,	max = 72,		title="[D]ANK PLAYER",					Color1="#BDFA00",	Color2="#00FA13",	Effect="transition",	zoomx= .75},
		{min=73,	max = 77,		title="[C]HAD PLAYER",					Color1="#00DFFA",	Color2="#00FAAA",	Effect="transition",	zoomx= .75},
		{min=78,	max = 84,		title="[B]EST PLAYER",					Color1="#F2FA00",	Color2="#D8FF00",	Effect="transition",	zoomx= .75},
		{min=85,	max = 92,		title="[A]WESOME",						Color1="000000",	Color2="0000000",	Effect="rainbow",		zoomx= .75},
		{min=93,	max = 99,		title="[S]UPER PLAYER",				Color1="000000",	Color2="000000",	Effect="rainbow",		zoomx= .75},
	};
	return array;
end;

local function ColorArray()
	local array=
	{
		{	title="WHITE",			Color1="#FFFFFF",		Color2="#FFFFFF",	effect="normal"	},
		{	title="BRONCE",			Color1="#FFC6A3",		Color2="#BF7819",	effect="normal"	},
		{	title="GREEN",			Color1="#B7FF99",		Color2="#ABFF40",	effect="normal"	},
		{	title="LIGHTBLUE",		Color1="#BAFFFC",		Color2="#34AEE0",	effect="normal"	},
		{	title="GOLD",			Color1="#F7DC6F",		Color2="#F1C40F",	effect="normal"	},
		{	title="VIOLET",			Color1="#BE85FF",		Color2="#973BFF",	effect="normal"	},
		{	title="PURPLE",			Color1="#FFA4F0",		Color2="#FF4094",	effect="normal"	},
		{	title="RED",			Color1="#FF8FA0",		Color2="#FF1B3A",	effect="normal"	},
		{	title="BLUE",			Color1="#46B9FF",		Color2="#126FFF",	effect="normal"	},
		{	title="ORANGE",			Color1="#FF894D",		Color2="#FF6112",	effect="normal"	},
		
		{	title="GLOWPINK",		Color1="#FA58F4",		Color2="#FF0080",	effect="shift"	},
		{	title="GLOWCYAN",		Color1="#00FF80",		Color2="#00FFFF",	effect="shift"	},
		{	title="GLOWRED",		Color1="#FFBF00",		Color2="#FE2E2E",	effect="shift"	},
		{	title="GLOWGREEN",		Color1="#00FF40",		Color2="#C8FE2E",	effect="shift"	},
		{	title="GLOWGOLD",		Color1="#FE9A2E",		Color2="#FFFF00",	effect="shift"	},
		{	title="RAINBOW",		Color1="#FFFF00",		Color2="#FFFF00",	effect="rainbow"	},
	};
	return array;
end;

function Actor:SetLevelProperties(profile)
	local iMainLevel = profile:GetUserLevel();
	local finalText = iMainLevel;
	self:stopeffect();
	self:finishtweening();
	self:rainbowscroll(false);

	local ArrColor = ColorArray();
	self:diffusetopedge(color(ArrColor[1].Color1));
	self:diffusebottomedge(color(ArrColor[1].Color2));
	self:settext(finalText);

	
	--[[
	if (iMainLevel >= 100) then
		
		local customTitle = profile:GetCustomTitle();
		local cIndex = profile:GetColorTitle() + 1;
		local ArrColor = ColorArray();
		
		if (string.len(customTitle) > 15) then
			customTitle = string.sub(customTitle,1,15);
		end;

		if (customTitle ~= "") then
		
			self:settext(customTitle);
			if (cIndex <= #ArrColor) then
				
				self:rainbowscroll(false);
				if (ArrColor[cIndex].effect == "rainbow") then
					self:rainbowscroll(true);
				elseif (ArrColor[cIndex].effect == "shift") then
					self:diffuseshift();
					self:effectcolor1(color(ArrColor[cIndex].Color1));
					self:effectcolor2(color(ArrColor[cIndex].Color2));
					self:effectperiod(1.25);
				else
					self:diffusetopedge(color(ArrColor[cIndex].Color1));
					self:diffusebottomedge(color(ArrColor[cIndex].Color2));
				end;
				
			else
				self:diffusetopedge(color(ArrColor[1].Color1));
				self:diffusebottomedge(color(ArrColor[1].Color2));
			end;

		else
			self:settext("[S]UPER PLAYER");
			self:rainbowscroll(true);
		end;
		
	else
	
		local sublevel = (iMainLevel - arrInfo[Index].min) + 1;
		self:settext(arrInfo[Index].title .. " Lv " .. sublevel);
		self:zoomx(arrInfo[Index].zoomx);
		
		if (arrInfo[Index].Effect == "transition") then
			self:diffuseshift();
			self:effectcolor1(color(arrInfo[Index].Color1));
			self:effectcolor2(color(arrInfo[Index].Color2));
		end;	
		if (arrInfo[Index].Effect == "normal") then
			self:diffusetopedge(color(arrInfo[Index].Color1));
			self:diffusebottomedge(color(arrInfo[Index].Color2));
		end;
		if (arrInfo[Index].Effect == "rainbow") then
			self:rainbowscroll(true);
		end;
		
	end;
	]]
end;


function Actor:SetOnlineUser(OnlineLevel, customTitle, OnlineColor)

	local iMainLevel = tonumber(OnlineLevel) ;
	local ColorTitle = tonumber(OnlineColor);
	
	--if (iMainLevel == nil) then iMainLevel = 0;end;
	
	self:stopeffect();
	self:finishtweening();
	self:rainbowscroll(false);

	local arrInfo = TitleArray();
	for i=1,#arrInfo do
		if (iMainLevel >= arrInfo[i].min and iMainLevel <= arrInfo[i].max) then
			Index = i;
			break;
		end;
	end;
	
	if (iMainLevel >= 100) then
		
		local cIndex = ColorTitle + 1;
		local ArrColor = ColorArray();
		
		if (string.len(customTitle) > 15) then
			customTitle = string.sub(customTitle,1,15);
		end;

		if (customTitle ~= "") then
		
			self:settext(customTitle);
			if (cIndex <= #ArrColor) then
			
				self:rainbowscroll(false);
				if (ArrColor[cIndex].effect == "rainbow") then
					self:rainbowscroll(true);
				elseif (ArrColor[cIndex].effect == "shift") then
					self:diffuseshift();
					self:effectcolor1(color(ArrColor[cIndex].Color1));
					self:effectcolor2(color(ArrColor[cIndex].Color2));
					self:effectperiod(1.25);
				else
					self:diffusetopedge(color(ArrColor[cIndex].Color1));
					self:diffusebottomedge(color(ArrColor[cIndex].Color2));
				end;
				
			else
				self:diffusetopedge(color(ArrColor[1].Color1));
				self:diffusebottomedge(color(ArrColor[1].Color2));
			end;

		else
			self:settext("[S]UPER PLAYER");
			self:rainbowscroll(true);
		end;
		
	else
	
		local sublevel = (iMainLevel - arrInfo[Index].min) + 1;
		self:settext(arrInfo[Index].title .. " Lv " .. sublevel);
		self:zoomx(arrInfo[Index].zoomx);
		
		if (arrInfo[Index].Effect == "transition") then
			self:diffuseshift();
			self:effectcolor1(color(arrInfo[Index].Color1));
			self:effectcolor2(color(arrInfo[Index].Color2));
		end;	
		if (arrInfo[Index].Effect == "normal") then
			self:diffusetopedge(color(arrInfo[Index].Color1));
			self:diffusebottomedge(color(arrInfo[Index].Color2));
		end;
		if (arrInfo[Index].Effect == "rainbow") then
			self:rainbowscroll(true);
		end;
		
	end;
	
end;

-- PROFILE LEVEL
---------------------------------------------------------------------------------



function GetPlat()
	local PlatAnimation = Def.ActorFrame{
	
	children = {
	
					LoadActor(THEME:GetPathG("","SM-BACKJOIN")) .. {	--OFFLINE
						InitCommand=cmd(animate,false;diffusealpha,0);
						OnCommand=cmd(y,60;sleep,.1;playcommand,"Effect");
						EffectCommand=cmd(zoom,.95;diffusealpha,1;linear,0.3;zoom,1;diffusealpha,0;sleep,0.3;queuecommand,"Effect");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};
					LoadActor( THEME:GetPathG("","THEME-PLAT") )..{
						OnCommand=cmd(y,90;animate,false);
					};

					LoadActor( THEME:GetPathG("","THEME-PLAT") )..{
						OnCommand=cmd(animate,false;setstate,1;zoom,1;diffusealpha,1;y,88;glow,1,1,0,1;linear,0.3;zoom,1.2;glow,1,1,0,0;diffusealpha,0;sleep,0.3;queuecommand,"On");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};

					LoadActor( THEME:GetPathG("","THEME-PLAT") )..{
						OnCommand=cmd(animate,false;setstate,2;linear,0.3;y,0;linear,0.3;y,40;queuecommand,"On");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};
				};
	};
	
	return PlatAnimation; 
end;

function GetPlatSm()
	local PlatAnimation = Def.ActorFrame{
	
	children = {
					--[[
					LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKJOIN-SM")) .. {	--OFFLINE
						InitCommand=cmd(animate,false;diffusealpha,0);
						OnCommand=cmd(y,60;sleep,.1;playcommand,"Effect");
						EffectCommand=cmd(zoom,.95;diffusealpha,1;linear,0.3;zoom,1;diffusealpha,0;sleep,0.3;queuecommand,"Effect");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};
					]]
					LoadActor( THEME:GetPathG("","ScreenSelectMusic/THEME-PLAT-SM") )..{
						OnCommand=cmd(y,90;zoom,1.2;animate,false);
					};

					LoadActor( THEME:GetPathG("","ScreenSelectMusic/THEME-PLAT-SM") )..{
						OnCommand=cmd(animate,false;setstate,1;zoom,1.2;diffusealpha,1;y,88;glow,1,1,0,1;linear,0.3;zoom,1.4;glow,1,1,0,0;diffusealpha,0;sleep,0.3;queuecommand,"On");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};

					LoadActor( THEME:GetPathG("","ScreenSelectMusic/THEME-PLAT-SM") )..{
						OnCommand=cmd(animate,false;setstate,2;linear,0.3;y,-10;linear,0.3;y,30;queuecommand,"On");
						ConfirmStepsMessageCommand=cmd(finishtweening;queuecommand,"On");
					};
				};
	};
	
	return PlatAnimation; 
end;

function GetUsb()
	local ARRAY={};
	ARRAY[-1]=PLAYER_1;
	ARRAY[1]=PLAYER_2;
	
	local xWidth={};
	xWidth[-1]=100;
	xWidth[1]=100;

	local yPosFix = 32;
	
	local t = Def.ActorFrame{};
	for p=-1,1,2 do
		t[#t+1] = Def.ActorFrame{
		
			OffCommand=function(self)
				self:linear(.4):addy(-200);
			end;
		
			LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
				
				OnCommand=cmd(Center;zoom,.62;addx,300*p;y,yPosFix;animate,false;setstate,0;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)
					self:diffusealpha(0.5);
					if (p == -1 ) then
						self:addy(3);
					end;
				
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};	

			LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
				
				OnCommand=cmd(Center;zoom,.62;addx,300*p;y,yPosFix;animate,false;setstate,0;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)
					self:blend('BlendMode_Add');
					if (p == -1 ) then
						self:addy(3);
					end;
				
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};


			
			------------------------------------------------------------------------------------------------------------
			LoadActor(THEME:GetPathG("","MaskAvatar"))..{
				OnCommand=cmd(Center;addx,360*p;y,yPosFix+2;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);rotationy,(p == -1 and 0 or 180);MaskSource);
			};
			
			LoadActor(THEME:GetPathG("","_blank"))..{
				OnCommand=cmd(Center;addx,335*p;y,yPosFix+30;diffusealpha,1;MaskDest;scaletoclipped,240,44;queuecommand,"Profile");
				ProfileCommand=function(self)
					
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening();
						local level = PROFILEMAN:GetProfile(ARRAY[p]):GetUserLevel();
						if (level >= 0) then
							self:visible(true);
							self:Load("/UsbSkins/eclipse_20.png");
							--[[
							local sFile = PROFILEMAN:GetProfile(ARRAY[p]):GetSkinUsbFile();
							if (FILEMAN:DoesFileExist("/UsbSkins/" .. sFile)) then
								self:Load("/UsbSkins/" .. sFile);
							else
								self:Load(THEME:GetPathG("","profiles/base_splash.png"));
							end;
							self:diffusealpha(.8);
							self:diffusebottomedge(.4,.4,.4,1);
							]]
						else
							self:visible(false);
						end;
					end;
				end;
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};
			------------------------------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------------------------------
			--PROFILE IMAGE
			LoadActor(THEME:GetPathG("","_blank"))..{
				OnCommand=cmd(Center;addx,p == 1 and 197 or -445;scaletoclipped,50,50;y,32;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileMessageCommand=function(self,params)
					if params.Player == player then
						self:finishtweening();
						local sFile = PROFILEMAN:GetProfile(ARRAY[p]):GetAvatarFile();

						if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
							self:Load("/Avatars/" .. sFile);
						else
							self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						end;
						
					end;
				end;
				CardDisconnectedMessageCommand=function(self,params)
					if params.Player == player then
						self:y(SCREEN_CENTER_Y+437);
					end;
				end;
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};


			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,p == 1 and 277 or -279;y,yPosFix-12;zoom,0.75;horizalign,center;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)

					if (p == -1 ) then
						self:addy(2);
					end;

					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening():stopeffect();
						xWidth[p] = self:GetWidth();
						self:settext("LV");
					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};

			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,p == 1 and 277 or -279;y,yPosFix+4;zoom,0.75;horizalign,center;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)

					if (p == -1 ) then
						self:addy(2);
					end;

					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening():stopeffect();
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
						self:SetLevelProperties(profile);
						xWidth[p] = self:GetWidth();
						--self:settext( SetLevelProperties(PROFILEMAN:GetProfile(ARRAY[p])));
					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};			

			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,p == 1 and 368 or -368;y,yPosFix-5;zoom,.8;shadowlength,1;shadowcolor,0,0,0,1;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);horizalign,p == 1 and center or center;queuecommand,"Profile");
				ProfileCommand=function(self)
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening():stopeffect();
						profile = PROFILEMAN:GetProfile(ARRAY[p]);

						if p == 1 then
							self:y(yPosFix-5);
						else
							self:y(yPosFix-1);
						end;
						self:settext(string.upper(profile:GetDisplayName()));
					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};		
		};

		-- Corazones
		--   No deberian existir.
		--   Pienso mas en el gameplay que en emular como funciona la piu arcade
		--   si que evitemos todo tipo de cosas que emulen el "arcade", queremos jugar sin parar como lo hacen los juegos de pc.
		--   arka
	end;


	return t;
end;