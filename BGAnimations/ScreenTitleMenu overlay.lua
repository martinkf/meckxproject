--Activa todos los mensajes del sistema.
MESSAGEMAN:SetLogging(false);

--:: MUSIC INTRO::--
local musicIntroFile = "intro_ver_a.mp3";

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
--setDefaultScoreSystem();
initNonstopCenterVars();

--:::::::::::::::::--
GAMESTATE:Env()["inGameP1"] = false;
GAMESTATE:Env()["inGameP2"] = false;
--:::::::::::::::::--
--recomended offset for any player.
GAMESTATE:Env()["recomendedOffsetP1"] = "";
GAMESTATE:Env()["recomendedOffsetP2"] = "";
--tmpGuestSpeed
GAMESTATE:Env()["speedTempPlayer"] = nil;
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
	
	x[5] = player == PLAYER_1 and -428 or 172;
	x[6] = player == PLAYER_1 and -396 or 204;

	--get the preferences for the default local profile.
	--if these parameters are empty, we will not show anything because is the machine profile
	--if not, we will need to show the profiles selected as default for p1 and p2 in the Profile Editor.
	local idProfileDefaultP1 = PREFSMAN:GetPreference("DefaultLocalProfileIDP1");
	local idProfileDefaultP2 = PREFSMAN:GetPreference("DefaultLocalProfileIDP2");

	local xWidth = 100;
	t[#t+1] =  Def.ActorFrame{			

--[[
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
		
]]
		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[5] - (player == PLAYER_1 and -150 or -150),-31;diffusealpha,1;MaskDest;scaletoclipped,255,44;queuecommand,"InitProf");
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
							if usbskinplayer == "0_blank.png" or string.find(usbskinplayer, "0_blank.png") then
								self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
							else
								---que tal si utilizamos lo que guarda el perfil? xD								
								if string.find(usbskinplayer, "_video%.png") then
									local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
									if FILEMAN:DoesFileExist(videoFile) then
										
										local playerActivo = 1;
										if player == PLAYER_2 then playerActivo = 2; end;
										bannerPlayers[playerActivo] = videoFile;
										

										self:Load(videoFile);
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
									if FILEMAN:DoesFileExist(usbskinplayer) then
										self:Load(usbskinplayer);
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
						if usbskinplayer == "0_blank.png" or string.find(usbskinplayer, "0_blank.png") then
							self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						else
							---que tal si utilizamos lo que guarda el perfil? xD								
							if string.find(usbskinplayer, "_video%.png") then
								local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
								if FILEMAN:DoesFileExist(videoFile) then

									local playerActivo = 1;
									if player == PLAYER_2 then playerActivo = 2; end;
									bannerPlayers[playerActivo] = videoFile;

									self:Load(videoFile);

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
								if FILEMAN:DoesFileExist(usbskinplayer) then
									self:Load(usbskinplayer);
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
						if usbskinplayer == "0_blank.png" or string.find(usbskinplayer, "0_blank.png") then
							self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						else
							---que tal si utilizamos lo que guarda el perfil? xD								
							if string.find(usbskinplayer, "_video%.png") then
								local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
								if FILEMAN:DoesFileExist(videoFile) then
									self:Load(videoFile);
									self:play();
								else
									self:Load(THEME:GetPathG("","_blank"));
								end;
							else
								if FILEMAN:DoesFileExist(usbskinplayer) then
									self:Load(usbskinplayer);
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
						if (FILEMAN:DoesFileExist(sFile)) then
							self:Load(sFile);
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
						if (FILEMAN:DoesFileExist(sFile)) then
							self:Load(sFile);
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
						if (FILEMAN:DoesFileExist(sFile)) then
							self:Load(sFile);
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
						if PROFILEMAN:IsUsbProfile(params.Index) then
							self:settext("USB");
						else
							self:settext("LV");
						end;
						
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
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
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

					if params.Index < 0 or PROFILEMAN:IsUsbProfile(params.Index) then
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
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
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

		LoadActor(THEME:GetPathG("","profiles/topth_base_perfil")) .. {
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
						self:rotationy(180);
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

		
		LoadActor(THEME:GetPathG("","profiles/card_saninet")) .. {
			OnCommand=cmd(zoom,0.75;xy,SCREEN_CENTER_X+x[0]-100,-25);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					if params.Index < 0 then
						self:visible(false)
					else

					local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);	
					local cardPlayer = profile:GetSaninetKey();
					local typePlayer = profile:GetSaninetPlayerType();
					if #cardPlayer > 0 then
						self:diffusealpha(0);
						self:visible(true)
						self:y(20);
						self:linear(0.2):diffusealpha(1):addy(41);
						self:diffusealpha(1);
					else
						self:visible(false);
					end;


					end
				end;
			end;

			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","profiles/typeplayers 1x2")) .. {
			OnCommand=cmd(animate,false;setstate,0;zoom,0.75;xy,SCREEN_CENTER_X+x[0]+0,-25);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					if params.Index < 0 then
						self:visible(false)
					else

					local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);	
					local cardPlayer = profile:GetSaninetKey();
					local typePlayer = profile:GetSaninetPlayerType();
					if #cardPlayer > 0  then
						if typePlayer == "SaniNetPlayerType_Keyboard" then
							self:setstate(0);
							self:x(SCREEN_CENTER_X+x[0]+0);
						else
							self:setstate(1);
							self:x(SCREEN_CENTER_X+x[0]+14);
						end;

						self:diffusealpha(0);
						self:visible(true)
						self:y(20);
						self:linear(0.2):diffusealpha(1):addy(41);
						self:diffusealpha(1);
					else
						self:visible(false);
					end;


					end
				end;
			end;

			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
		};


	};		
end;

--utiles de perfil para cada jugador
for i=-1,1,2 do

	t[#t+1] = GetPlatSm() .. {
		OnCommand=cmd(Center;x, i == -1 and 170 or SCREEN_WIDTH - 170 ;addy,155;visible,Visible() and BPlayerCanJoin[i];queuecommand,"check43");
		check43Command=function(self)
			if isAspectRatio43() then
				self:addy(120);
			end;
		end;
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

	t[#t+1] = LoadActor(THEME:GetPathG("","SaniNet/ServerStatus")) .. {	--OFFLINE
		InitCommand=cmd(animate,false;setstate,1;zoom,0.32);
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

			if isAspectRatio43() then
				self:y(SCREEN_CENTER_Y+420);
			end;

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

			if isAspectRatio43() then
				self:y(SCREEN_CENTER_Y+418);
			end;

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

					if isAspectRatio43() then
						self:SetSecondsIntoAnimation(0):Center():setsize(SCREEN_WIDTH,SCREEN_HEIGHT);
					end;

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

					if isAspectRatio43() then
						self:SetSecondsIntoAnimation(0):Center():setsize(SCREEN_WIDTH,SCREEN_HEIGHT);
					end;

					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "Infinity" then
					self:ChangeBack(XTRADir.. "/INFINITY.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);		
					if isAspectRatio43() then
						self:SetSecondsIntoAnimation(0):Center():setsize(SCREEN_WIDTH,SCREEN_HEIGHT);
					end;
					self:visible(true);
				elseif GAMESTATE:GetGameMode() == "QuestWorld" then
					self:ChangeBack(XTRADir.. "/FIESTAEX.MPG");
					self:SetSecondsIntoAnimation(0):Center():setsize(1280,720);
					if isAspectRatio43() then
						self:SetSecondsIntoAnimation(0):Center():setsize(SCREEN_WIDTH,SCREEN_HEIGHT);
					end;
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


if PREFSMAN:GetPreference('AllowQuestThemeSwitch') and checkForPiuRelatedObj then

	 t[#t+1] = LoadActor(THEME:GetPathG("", "ScreenTitleMenu/gamemode"))..{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP+20);
			self:zoom(0.6);
		end;
	};

end;

--#############################
local luckyToastyNumber = 5; -- 5%
--#############################


if math.random(1,100) <= luckyToastyNumber then

	musicIntroFile = "intro_ver_b.mp3";

	local speedAniSanita=0.084;
	local lastFramePause= 0.05;
	local aniStatusSanita = {0,0};
	local sleepWaitUntilShow=1;
	local lightShowTransitionTime=0.41;
	local waitUntilSoundLightShow = 13;
	--####
	local rewindAni = {false,false};
	local sanitaFileDanceP1 = "s1dance 1x6";
	local sanitaFileDanceP2 = "s2dance 1x6";
	local placeXDanceSanita = 360;


	if math.random(1,2) == 1 then
		sanitaFileDanceP1 = "s1dance 1x6";
		sanitaFileDanceP2 = "s2dance 1x6";
	else
		sanitaFileDanceP1 = "s2dance 1x6";
		sanitaFileDanceP2 = "s1dance 1x6";
	end;


	t[#t+1] = Def.ActorFrame{
			OnCommand=function(self)
			self:x(SCREEN_CENTER_X+placeXDanceSanita);
			self:y(SCREEN_CENTER_Y+220);			
		end;

		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/llight"))..{
			OnCommand=function(self)
				self:zoom(0.3);
				self:x(48);
				self:visible(false);
				self:sleep(sleepWaitUntilShow+waitUntilSoundLightShow);	
				self:blend("BlendMode_Add");
				self:queuecommand("AniOn");
			end;
			AniOnCommand=function(self)
				self:visible(true);	
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0.8);
				self:queuecommand("AniOff");
			end;
			AniOffCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0);
				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("AniOn");	
				end;
				
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("On");
			end;
			EndAniCommand=function(self)
				self:diffusealpha(0);
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/rlight"))..{
			OnCommand=function(self)
				self:blend("BlendMode_Add");
				self:zoom(0.3);
				self:x(-35);
				self:y(6);
				self:diffusealpha(0);
				self:sleep(sleepWaitUntilShow+lightShowTransitionTime+waitUntilSoundLightShow);
				self:queuecommand("AniOn");
			end;
			AniOnCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0.8);
				self:queuecommand("AniOff");
			end;
			AniOffCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0);
				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("AniOn");	
				end;
				
			end;
			EndAniCommand=function(self)
				self:diffusealpha(0);
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("On");
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};


		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/"..sanitaFileDanceP1))..{
			OnCommand=function(self)
				self:zoom(0.4);
				self:animate(false);
				self:visible(false);
				self:sleep(1);		
				self:setstate(0)
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:visible(true);		
				self:setstate(aniStatusSanita[1]);

				local lastWaitbuffer = 0;
				if aniStatusSanita[1] == 4 then
					rewindAni[1] = true;
					lastWaitbuffer = lastFramePause;
				elseif aniStatusSanita[1] == 0 then
					rewindAni[1] = false;
					lastWaitbuffer = lastFramePause;
				else
					lastWaitbuffer = 0;
				end;

				self:sleep(speedAniSanita + lastWaitbuffer);

				if rewindAni[1] then
					aniStatusSanita[1] = aniStatusSanita[1] - 1; 
				else
					aniStatusSanita[1] = aniStatusSanita[1] + 1; 
				end;

				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("Ani");	
				end;

			end;

			EndAniCommand=function(self)
				self:setstate(5);
			end;

			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("Ani");
			end;
		};



	};


	t[#t+1] = Def.ActorFrame{
	 		OnCommand=function(self)
				self:x(SCREEN_CENTER_X+(placeXDanceSanita*-1) );
				self:y(SCREEN_CENTER_Y+220);
				self:rotationy(180);
			end;


		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/llight"))..{
			OnCommand=function(self)
				self:zoom(0.3);
				self:x(48);
				self:visible(false);
				self:sleep(sleepWaitUntilShow+waitUntilSoundLightShow);	
				self:blend("BlendMode_Add");
				self:queuecommand("AniOn");
			end;
			AniOnCommand=function(self)
				self:visible(true);	
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0.8);
				self:queuecommand("AniOff");
			end;
			AniOffCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0);
				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("AniOn");	
				end;
				
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("On");
			end;
			EndAniCommand=function(self)
				self:diffusealpha(0);
			end;

			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/rlight"))..{
			OnCommand=function(self)
				self:blend("BlendMode_Add");
				self:zoom(0.3);
				self:x(-35);
				self:y(6);
				self:diffusealpha(0);
				self:sleep(sleepWaitUntilShow+lightShowTransitionTime+waitUntilSoundLightShow);
				self:queuecommand("AniOn");
			end;
			AniOnCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0.8);
				self:queuecommand("AniOff");
			end;
			AniOffCommand=function(self)
				self:linear(lightShowTransitionTime);
				self:diffusealpha(0);
				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("AniOn");	
				end;
				
			end;
			EndAniCommand=function(self)
				self:diffusealpha(0);
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("On");
			end;
		};


		LoadActor(THEME:GetPathG("", "ScreenTitleMenu/"..sanitaFileDanceP2))..{
			OnCommand=function(self)
				self:zoom(0.4);
				self:animate(false);
				self:visible(false);
				self:sleep(1);	
				self:setstate(0)
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:visible(true);	
				self:setstate(aniStatusSanita[2]);
				local lastWaitbuffer = 0;
				if aniStatusSanita[2] == 4 then
					rewindAni[2] = true;
					lastWaitbuffer = lastFramePause;
				elseif aniStatusSanita[2] == 0 then
					rewindAni[2] = false;
					lastWaitbuffer = lastFramePause;
				else
					lastWaitbuffer = 0;
				end;

				self:sleep(speedAniSanita + lastWaitbuffer);

				if rewindAni[2] then
					aniStatusSanita[2] = aniStatusSanita[2] - 1; 
				else
					aniStatusSanita[2] = aniStatusSanita[2] + 1; 
				end;

				if segPassedIntroSong >= 30 then
					self:queuecommand("EndAni");
				else
					self:queuecommand("Ani");	
				end;

			end;

			EndAniCommand=function(self)
				self:setstate(5);
			end;
			AniLoopSoundMessageCommand=function(self)
				self:queuecommand("Ani");
			end;
		};
	};
end;



--ATTRACT MUSIC
--::::::::::::::
local freqAttract = PREFSMAN:GetPreference("AttractSoundFrequency");
local volumeAttract  = PREFSMAN:GetPreference("SoundVolumeAttract");
local playSong = false;

if freqAttract == "AttractSoundFrequency_EveryTime" then
	playSong = true;
elseif freqAttract == "AttractSoundFrequency_Every2Times" then
	if math.random(1,2) == 1 then
		playSong = true;
	end;
elseif freqAttract == "AttractSoundFrequency_Every3Times" then
	if math.random(1,3) == 1 then
		playSong = true;
	end;
elseif freqAttract == "AttractSoundFrequency_Every4Times" then
	if math.random(1,4) == 1 then
		playSong = true;
	end;
elseif freqAttract == "AttractSoundFrequency_Every4Times" then
	if math.random(1,5) == 1 then
		playSong = true;
	end;
end;

t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathS("","xsanity/"..musicIntroFile)) .. {
		OnCommand=function(self)
			if playSong then
				self:play();				
			end;
			self:sleep(checkTimeSeg);
			self:queuecommand("checkIfRepeat");
		end;
		StopMusicMessageCommand=cmd(stop);	

		checkIfRepeatCommand=function(self)						
			if segPassedIntroSong == segForRepeatSong then
				if playSong then					
					self:play();
					MESSAGEMAN:Broadcast("AniLoopSound");
				end;
				segPassedIntroSong = 0;
			else
				segPassedIntroSong = segPassedIntroSong + checkTimeSeg;
			end;
			self:sleep(checkTimeSeg);
			self:queuecommand("checkIfRepeat");
		end;

		PrevModMessageCommand=function(self,params)
			if GAMESTATE:GetGameMode() == "Basic" then
				if playSong then
					self:play();
					segPassedIntroSong = 0;
				end;
			else
				self:stop();
			end;		
		end;
		NextModMessageCommand=function(self,params)
			if GAMESTATE:GetGameMode() == "Basic" then
				if playSong then
					self:play();
					segPassedIntroSong = 0;
				end;
			else
				self:stop();
			end;		
		end;

		OffCommand=function(self)
			self:stoptweening();
		end;
	};
};




return t;
