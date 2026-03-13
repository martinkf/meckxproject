--Activa todos los mensajes del sistema.
MESSAGEMAN:SetLogging(false);

--:::: SANINET ::::--
-- we init the var here.
if GAMESTATE:Env()["saninetConnectionId"] == nil then
	GAMESTATE:Env()["saninetConnectionId"] = "";
else
	GAMESTATE:Env()["saninetConnectionId"] = "";
end; 

if GAMESTATE:Env()["saninetUsername"] == nil then
	GAMESTATE:Env()["saninetUsername"] = "";
else
	GAMESTATE:Env()["saninetUsername"] = "";
end; 

--:::::::::::::::::--
-- VS MODE (files with the addon)
--screenTitleMenu 
--screenGameplay
--screenEvaluation
checkVsMode();
restartVsHistory();
createCustomOptionEnvPlayers(PLAYER_1); --this is for the guest player options
createCustomOptionEnvPlayers(PLAYER_2); --this is for the guest player options
--:::::::::::::::::--
GAMESTATE:Env()["inGameP1"] = false;
GAMESTATE:Env()["inGameP2"] = false;
--:::::::::::::::::--
local BPlaying = false;
local BPlayerCanJoin={};
BPlayerCanJoin[-1] = true;
BPlayerCanJoin[1] = true;
soundPlayerSelectP1=false;
soundPlayerSelectP2=false;

local segPassedIntroSong=0;
local segForRepeatSong=40;
local checkTimeSeg=2;

nxtstg = -1;
sortMode = 0;

local bannerPlayers={"",""};

local t = Def.ActorFrame{

--logo 3 xD
	LoadActor("MainLogo/logo3/logo_underlay")..{
		OnCommand=function(self)
		end;
	};

	LoadActor("MainLogo/bg_matrix")..{};

	LoadActor("MainLogo/logo3/logo_overlay")..{
		OnCommand=function(self)
		end;
	};

	LoadActor(THEME:GetPathS("","xsanity/intro_ver_a.mp3")) .. {
		OnCommand=function(self)
			self:play();
			if not GAMESTATE:IsEventMode() then
				--Trace("##### NO SOY MODO EVENTO");
				self:sleep(checkTimeSeg);
				self:queuecommand("checkIfRepeat");
			else
				--Trace("##### SOY MODO EVENTO");
			end;
		end;
		StopMusicMessageCommand=cmd(stop);	

		checkIfRepeatCommand=function(self)			
			if segPassedIntroSong == segForRepeatSong then
				self:play();
				segPassedIntroSong = 0;
			else
				segPassedIntroSong = segPassedIntroSong + checkTimeSeg;
			end;
			self:sleep(checkTimeSeg);
			self:queuecommand("checkIfRepeat");
		end;

		OffCommand=function(self)
			self:stoptweening();
		end;
	};

	LoadActor(THEME:GetPathS("","SANITY_EFFECTTITLE")) .. {
		PlayMusicMessageCommand=cmd(play);
		StopMusicMessageCommand=cmd(stop);
	};
	
		
	CoinInsertedMessageCommand=function(self)
		--NO COINS >:( PLS
		MESSAGEMAN:Broadcast("VisibleAux");
	end;

	PlayerJoinedMessageCommand=function(self,params)
		if params.Player == PLAYER_1 then 
			BPlayerCanJoin[-1] = false;
		end
		if params.Player == PLAYER_2 then 
			BPlayerCanJoin[1] = false;
		end
		MESSAGEMAN:Broadcast("VisibleAux");
	end;
	


	Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X, SCREEN_TOP + 100;setsize,SCREEN_WIDTH,50;zoomx,0;diffuse,color('0,0,0,0'));
		SaniNetErrorMessageMessageCommand=function(self, params)
			if params.Message == 2 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			end;
		end;
	};
	LoadFont("normalxolonium")..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_TOP + 100;shadowlength,1;shadowcolor,color("#00000");zoom,.84;diffuse,color('1,1,0,0'));
		SaniNetErrorMessageMessageCommand=function(self, params)
		 	if params.Message == 2 then	--on join
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Logged off from the Saninet server");
			end;
		end;
	};

	--
	LoadActor(THEME:GetPathS("","xsanity/START_2")) .. {
		OnCommand=function(self)
			self:stop();
		end;		
		StopMusicMessageCommand=cmd(stop);
		--
		CodeMessageCommand=function(self, params)		
			if soundPlayerSelectP1 == false then
				if params.PlayerNumber == PLAYER_1 and params.Name == "Center" then
					self:play();
					soundPlayerSelectP1 = true;
				end;
			end;

			if soundPlayerSelectP2 == false then
				if params.PlayerNumber == PLAYER_2 and params.Name == "Center" then
					self:play();
					soundPlayerSelectP2 = true;
				end;
			end;
		end;
		
		OffCommand=function(self)
			self:play();
		end;
	};

	
};

local function Visible()
	return GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin();
end;

local function VisibleButton()
	if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
		return false;
	else
		return GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin();
	end;
end;


local function CreateUsbForPlayer(player)
	
	local x={};
	
	x[0] = player == PLAYER_1 and -300 or 300;
	x[1] = player == PLAYER_1 and -365 or 363;
	x[2] = player == PLAYER_1 and -500 or 308;
	x[3] = player == PLAYER_1 and -450 or 358;
	x[4] = player == PLAYER_1 and -155 or 270;
	
	x[5] = player == PLAYER_1 and -427 or 172;
	x[6] = player == PLAYER_1 and -396 or 204;

	--get the preferences for the default local profile.
	--if these parameters are empty, we will not show anything because is the machine profile
	--if not, we will need to show the profiles selected as default for p1 and p2 in the Profile Editor.
	local idProfileDefaultP1 = PREFSMAN:GetPreference("DefaultLocalProfileIDP1");
	local idProfileDefaultP2 = PREFSMAN:GetPreference("DefaultLocalProfileIDP2");

	local xWidth = 100;
	t[#t+1] =  Def.ActorFrame{			

		LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
			OnCommand=cmd(zoom,0.65;xy,SCREEN_CENTER_X+x[0],-25;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					if params.Index < 0 then
						self:visible(false)
					else
						self:visible(true)
						self:y(-26);
						self:linear(0.2):addy(53);
						self:diffusealpha(1);
					end
				end;
			end;

			InitProfCommand=function(self)

				if player == PLAYER_1 then
					self:finishtweening();
					if idProfileDefaultP1 == "" then
						self:visible(false)
					else
						self:visible(true)
						self:y(-26);
						self:linear(0.2):addy(53);
						self:diffusealpha(1);
					end;	
				end;

				if player == PLAYER_2 then
					self:finishtweening();
					if idProfileDefaultP2 == "" then
						self:visible(false)
					else
						self:visible(true)
						self:y(-26);
						self:linear(0.2):addy(53);
						self:diffusealpha(1);
					end;	
				end;
			end;

			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
		};
		

		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[5] - (player == PLAYER_1 and -150 or -150),-31;diffusealpha,1;MaskDest;scaletoclipped,254,44;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					if params.Index < 0 then
						self:visible(false)
						return
					end
					local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);				
					local level = profile:GetUserLevel();
					if (level >= 0) then
						self:visible(true);
						if params.Index < 0 then
							self:Load(THEME:GetPathG("","profiles/b_guest_2.png"));
						else
							local usbskinplayer = profile:GetSkinUsbFile();
							if usbskinplayer == "0_blank.png" then
								self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
							else
								---que tal si utilizamos lo que guarda el perfil? xD								
								if string.find(usbskinplayer, "_video%.png") then
									local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
									if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
										
										local playerActivo = 1;
										if player == PLAYER_2 then playerActivo = 2; end;
										bannerPlayers[playerActivo] = videoFile;
										

										self:Load("/UsbSkins/" .. videoFile);
										if bannerPlayers[1] == bannerPlayers[2] then
											self:rate(0.5);
										else
											self:rate(1);
										end;

										self:play();
									else
										self:Load(THEME:GetPathG("","_blank"));
									end;
								else
									if FILEMAN:DoesFileExist("/UsbSkins/" .. usbskinplayer) then
										self:Load("/UsbSkins/" .. usbskinplayer);
									else
										self:Load(THEME:GetPathG("","_blank"));
									end;
								end;
							end;
						end;

						self:y(-30);
						self:linear(0.2):addy(57);
					else
						self:visible(false);
					end;
				end;
			end;

			InitProfCommand=function(self)
				if player == PLAYER_1 then
					self:finishtweening()
					if idProfileDefaultP1 == "" then
						self:visible(false)
						return
					end
					local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP1);
					local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);				
					local level = profile:GetUserLevel();
					if (level >= 0) then
						self:visible(true);
						local usbskinplayer = profile:GetSkinUsbFile();
						if usbskinplayer == "0_blank.png" then
							self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						else
							---que tal si utilizamos lo que guarda el perfil? xD								
							if string.find(usbskinplayer, "_video%.png") then
								local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
								if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then

									local playerActivo = 1;
									if player == PLAYER_2 then playerActivo = 2; end;
									bannerPlayers[playerActivo] = videoFile;

									self:Load("/UsbSkins/" .. videoFile);

									if bannerPlayers[1] == bannerPlayers[2] then
										self:rate(0.5);
									else
										self:rate(1);
									end;
									
									self:play();
								else
									self:Load(THEME:GetPathG("","_blank"));
								end;
							else
								if FILEMAN:DoesFileExist("/UsbSkins/" .. usbskinplayer) then
									self:Load("/UsbSkins/" .. usbskinplayer);
								else
									self:Load(THEME:GetPathG("","_blank"));
								end;
							end;
						end;
					end;
					self:y(-30);
					self:linear(0.2):addy(57);

				end;

				if player == PLAYER_2 then
					self:finishtweening()
					if idProfileDefaultP2 == "" then
						self:visible(false)
						return
					end
					local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP2);
					local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);				
					local level = profile:GetUserLevel();

					if (level >= 0) then
						self:visible(true);
						local usbskinplayer = profile:GetSkinUsbFile();
						if usbskinplayer == "0_blank.png" then
							self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						else
							---que tal si utilizamos lo que guarda el perfil? xD								
							if string.find(usbskinplayer, "_video%.png") then
								local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
								if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
									self:Load("/UsbSkins/" .. videoFile);
									self:play();
								else
									self:Load(THEME:GetPathG("","_blank"));
								end;
							else
								if FILEMAN:DoesFileExist("/UsbSkins/" .. usbskinplayer) then
									self:Load("/UsbSkins/" .. usbskinplayer);
								else
									self:Load(THEME:GetPathG("","_blank"));
								end;
							end;
						end;
					end;
					self:y(-30);
					self:linear(0.2):addy(57);

				end;

			end;


			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-30);
				end;
			end;
		};

		-- esta wea es horrible :( pero funciona y no va a joder memoria (espero)
		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[5],-31;scaletoclipped,50,50;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();

					if params.Index < 0 then
						--self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						self:visible(false)
					else
						self:visible(true)
						local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);
						local sFile = profile:GetAvatarFile();
						if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
							self:Load("/Avatars/" .. sFile);
						else
							self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						end;
					end;

					self:scaletoclipped(45,45);
					self:y(-31);
					self:linear(0.2):addy(58);
				end;
			end;


			InitProfCommand=function(self)
				if player == PLAYER_1 then
					self:finishtweening()
					if idProfileDefaultP1 == "" then
						self:visible(false)
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP1);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);		
						local sFile = profile:GetAvatarFile();
						if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
							self:Load("/Avatars/" .. sFile);
						else
							self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						end;
						self:scaletoclipped(45,45);
						self:y(-31);
						self:linear(0.2):addy(58);	
					end;	
				end;

				if player == PLAYER_2 then
					self:finishtweening()
					if idProfileDefaultP2 == "" then
						self:visible(false)
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP2);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);		
						local sFile = profile:GetAvatarFile();
						if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
							self:Load("/Avatars/" .. sFile);
						else
							self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						end;
						self:scaletoclipped(45,45);
						self:y(-31);
						self:linear(0.2):addy(58);	
					end;	

				end;			
			end;


			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
		};



		------------------------------------------------------------------------------------------------------------------
		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6],-22;zoom,0.75;horizalign,left;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();

					if params.Index < 0 then
						self:visible(false)
						self:settext("GUEST PLAYER");
					else
						self:visible(true)
						self:settext("LV");
					end;

					self:y(-28);
					xWidth = self:GetWidth();
					self:linear(0.2):addy(63);
				end;
			end;


			InitProfCommand=function(self)

				if player == PLAYER_1 then
					self:finishtweening();
					if idProfileDefaultP1 == "" then
						self:visible(false)
					else
						self:visible(true)
						self:settext("LV");
						self:y(-28);
						xWidth = self:GetWidth();
						self:linear(0.2):addy(63);
					end;	
				end;

				if player == PLAYER_2 then
					self:finishtweening();
					if idProfileDefaultP2 == "" then
						self:visible(false)
					else
						self:visible(true)
						self:settext("LV");
						self:y(-28);
						xWidth = self:GetWidth();
						self:linear(0.2):addy(63);
					end;	
				end;
			end;

			OffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		};

		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6],-22;zoom,0.75;horizalign,left;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then

					if player == PLAYER_1 then
						self:x(SCREEN_CENTER_X+x[6]+28);
					else
						self:x(SCREEN_CENTER_X+x[6]+28);
					end;

					self:finishtweening();
					profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);
					self:diffusealpha(0);

					if params.Index < 0 then
						self:visible(false);
					else
						self:visible(true);
						self:finishtweening();
						self:SetLevelProperties(profile);
						self:y(-28);
						xWidth = self:GetWidth();
						self:linear(0.2):addy(63);						
					end;



				end;
			end;

			InitProfCommand=function(self)

				if player == PLAYER_1 then
					if idProfileDefaultP1 == "" then
						self:visible(false)
						self:finishtweening()
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP1);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);	
						self:x(SCREEN_CENTER_X+x[6]+28);
						self:diffusealpha(0);
						self:visible(true);
						self:finishtweening();
						self:SetLevelProperties(profile);
						self:y(-28);
						xWidth = self:GetWidth();
						self:linear(0.2):addy(63);	
					end;	
				end;

				if player == PLAYER_2 then
					if idProfileDefaultP2 == "" then
						self:visible(false)
						self:finishtweening()
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP2);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);	
						self:x(SCREEN_CENTER_X+x[6]+28);
						self:diffusealpha(0);
						self:visible(true);
						self:finishtweening();
						self:SetLevelProperties(profile);
						self:y(-28);
						xWidth = self:GetWidth();
						self:linear(0.2):addy(63);	
					end;	
				end;

			end;

			OffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		};

		--------------------------------------------------------------------------------------------------------------------
		
		
		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6],-32;zoom,.78;shadowlength,1;shadowcolor,0,0,0,1;horizalign,left;queuecommand,"InitProf");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then

					self:finishtweening():stopeffect();
					if params.Index < 0 then
						self:visible(false)
					else
						self:visible(true)
						self:settext(string.upper(PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetDisplayName()));
						self:y(-39);
						self:linear(0.2):addy(54);
					end
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-47);
				end;
			end;


			InitProfCommand=function(self)

				if player == PLAYER_1 then
					self:finishtweening():stopeffect();
					if idProfileDefaultP1 == "" then
						self:visible(false)
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP1);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);	
						local name = profile:GetDisplayName();
						self:settext(name);
						self:y(-39);
						self:linear(0.2):addy(54);	
					end;	
				end;

				if player == PLAYER_2 then
					self:finishtweening():stopeffect();
					if idProfileDefaultP2 == "" then
						self:visible(false)
					else
						self:visible(true)
						local idProfile = PROFILEMAN:GetLocalProfileIndexFromID(idProfileDefaultP2);
						local profile = PROFILEMAN:GetLocalProfileFromIndex(idProfile);	
						local name = profile:GetDisplayName();
						self:settext(name);
						self:y(-39);
						self:linear(0.2):addy(54);	
					end;	
				end;
				
			end;

			OffCommand=cmd(stoptweening;linear,0.15;diffusealpha,0);
		};

		
		
	};		
end;

--utiles de perfil para cada jugador
for i=-1,1,2 do

	t[#t+1] = GetPlatSm() .. {
		OnCommand=cmd(Center;x, i == -1 and 170 or SCREEN_WIDTH - 170 ;addy,155;visible,Visible() and BPlayerCanJoin[i]);
		VisibleAuxMessageCommand=cmd(visible,false)
	};
	
	--[[
	t[#t+1] = LoadActor(THEME:GetPathG("","TITLESCREEN-UTIL")) .. {
		InitCommand=cmd(animate,false;setstate,0);
		OnCommand=cmd(Center;addx,400*i;addy,250;visible,not Visible() and BPlayerCanJoin[i]);
		VisibleAuxMessageCommand=cmd(visible,not Visible() and BPlayerCanJoin[i])
	};
	t[#t+1] = LoadActor(THEME:GetPathG("","TITLESCREEN-UTIL")) .. {
		InitCommand=cmd(animate,false;setstate,0);
		OnCommand=cmd(Center;addx,400*i;addy,250;visible,not Visible() and BPlayerCanJoin[i];queuecommand,"Effect");
		EffectCommand=cmd(finishtweening;zoom,1;diffusealpha,1;linear,.8;zoom,1.25;diffusealpha,0;queuecommand,"Effect");
		VisibleAuxMessageCommand=cmd(visible,not Visible() and BPlayerCanJoin[i])
	};
	]]

	t[#t+1] = LoadActor(THEME:GetPathG("","saninetStatus")) .. {	--OFFLINE
		InitCommand=cmd(animate,false;setstate,1;zoom,0.8);
		SaniNetAliveMessageCommand=function(self,params)
			self:setstate(not params.Alive and 1 or 0);
		end;
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-45;visible,(SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu"));
	};

	
	t[#t+1] = LoadActor(THEME:GetPathG("", "ScreenTitleMenu/PROMPT")) .. {
		OnCommand=function(self)
			if VisibleButton() and BPlayerCanJoin[i] then
				self:x(i == -1 and 170 or SCREEN_WIDTH - 170);
			end;
			self:animate(false):y(SCREEN_CENTER_Y+300):zoom(.7):playcommand("Effect");
		end;
		EffectCommand=cmd(finishtweening;glowshift;effectcolor1,color("1,1,1,0");effectcolor2,color("0,0,0,0.1");effectperiod,1.5);
		OffCommand=cmd(finishtweening;visible,false);
	};


	
	t[#t+1] = LoadFont("_TitleXolonium") .. {
		OnCommand=function(self)
			self:settext("PROFILE SELECT");
			if VisibleButton() and BPlayerCanJoin[i] then
				self:x(i == -1 and 170 or SCREEN_WIDTH - 170);
			end;
			self:animate(false):y(SCREEN_CENTER_Y+298):zoom(.5):playcommand("Effect"):shadowlength(2);
		end;
		EffectCommand=cmd(finishtweening;glowshift;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.1");effectperiod,1.5);
		OffCommand=cmd(finishtweening;visible,false);
	};
	
end;


CreateUsbForPlayer(PLAYER_1);
CreateUsbForPlayer(PLAYER_2);	

t[#t+1] = LoadActor("SaniNetLogin")..
{
};

local checkForPiuRelatedObj = checkForObjFilesPiuContent();


if checkForPiuRelatedObj then

	t[#t+1] = Def.ActorFrame{
	-------------------------- PIU ORIGINAL THINGS --------------------------------
		Def.Sprite {
			InitCommand=function(self)
				self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
				self:visible(false);
			end;
			PrevModMessageCommand=function(self,params)
				if GAMESTATE:GetGameMode() == "Basic" then
					self:visible(false);
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
				elseif GAMESTATE:GetGameMode() == "WorldMax" then
					self:ChangeBack(XTRADir.. "/NXA.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "Infinity" then
					self:ChangeBack(XTRADir.. "/INFINITY.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);			
					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "QuestWorld" then
					self:ChangeBack(XTRADir.. "/FIESTAEX.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
					self:visible(true);
				end;		
			end;
			NextModMessageCommand=function(self,params)
				if GAMESTATE:GetGameMode() == "Basic" then
					self:visible(false);
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
				elseif GAMESTATE:GetGameMode() == "WorldMax" then
					self:ChangeBack(XTRADir.. "/NXA.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "Infinity" then
					self:ChangeBack(XTRADir.. "/INFINITY.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);		
					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "QuestWorld" then
					self:ChangeBack(XTRADir.. "/FIESTAEX.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
					self:visible(true);
				end;		
			end;
		};
		
		
		LoadActor("ScreenTitleMenuNXA")..
		{
			OnCommand=cmd(playcommand,"GameMode");
			PrevModMessageCommand=cmd(playcommand,"GameMode");
			NextModMessageCommand=cmd(playcommand,"GameMode");
			GameModeCommand=function(self)
				if GAMESTATE:GetGameMode() == "WorldMax" then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};
		LoadActor("ScreenTitleMenuFiestaEX")..
		{
			OnCommand=cmd(playcommand,"GameMode");
			PrevModMessageCommand=cmd(playcommand,"GameMode");
			NextModMessageCommand=cmd(playcommand,"GameMode");
			GameModeCommand=function(self)
				if GAMESTATE:GetGameMode() == "QuestWorld" then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};
		LoadActor("ScreenTitleMenuInfinity")..
		{
			OnCommand=cmd(playcommand,"GameMode");
			PrevModMessageCommand=cmd(playcommand,"GameMode");
			NextModMessageCommand=cmd(playcommand,"GameMode");
			GameModeCommand=function(self)
				if GAMESTATE:GetGameMode() == "Infinity" then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		};
		----------------------------------------------------------
	};
end;

return t;