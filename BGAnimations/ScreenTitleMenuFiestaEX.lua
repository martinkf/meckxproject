local BPlaying = false;
local BPlayerCanJoin={};
BPlayerCanJoin[-1] = true;
BPlayerCanJoin[1] = true;

nxtstg = -1;
sortMode = 0;

local t = Def.ActorFrame{
	
	LoadActor(THEME:GetPathS("","FIESTAEX TITLE")) .. {
		OnCommand=cmd(queuecommand,"Sound");
		SoundCommand=function(self)
			if PREFSMAN:GetPreference('MusicTitle') then
				if (GAMESTATE:GetCoins() > 0 or GAMESTATE:GetCoinMode() == "CoinMode_Free" or GAMESTATE:GetCoinMode() == "CoinMode_Home") and GAMESTATE:GetGameMode() == "QuestWorld" and not BPlaying then
					self:play();	
					BPlaying=true;
				elseif GAMESTATE:GetCoins() == 0 and GAMESTATE:GetCoinMode() == "CoinMode_Pay" then
					self:stop();
					BPlaying=false;
				end;
			else
				self:stop();
				BPlaying=false;
			end;
		end;
		-- CoinInsertedMessageCommand=cmd(queuecommand,"Sound");
		PrevModMessageCommand=function(self,params)
			if GAMESTATE:GetGameMode() == "QuestWorld" and not BPlaying then
				self:play();
				BPlaying=true;
			else
				self:stop();
				BPlaying=false;
			end;
		end;
		NextModMessageCommand=function(self,params)
			if GAMESTATE:GetGameMode() == "QuestWorld" and not BPlaying then
				self:play();
				BPlaying=true;
			else
				self:stop();
				BPlaying=false;
			end;
		end;
	};
	
	-- LoadActor(THEME:GetPathG("","TITLE/FIESTAEX.MPG"))..
	-- {
		-- OnCommand=cmd(Center;FullScreen);
		-- PrevModMessageCommand=function(self,params)
			-- if GAMESTATE:GetGameMode() == "QuestWorld" then
				-- self:SetSecondsIntoAnimation(0);
				-- self:play();
			-- else
				-- self:pause();
			-- end;
		-- end;
		-- NextModMessageCommand=function(self,params)
			-- if GAMESTATE:GetGameMode() == "QuestWorld" then
				-- self:SetSecondsIntoAnimation(0);
				-- self:play();
			-- else
				-- self:pause();
			-- end;
		-- end;
	-- };	
	
	CoinInsertedMessageCommand=function(self)
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
	
	------------------------------------PLAYER 1------------------------------------
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,0;xy,150,SCREEN_CENTER_Y + 153);
		MissionConfirmedMessageCommand=cmd(visible,true);
		BackMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,1;xy,150,SCREEN_CENTER_Y + 143);
		MissionConfirmedMessageCommand=cmd(visible,true);
		BackMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,1;xy,150,SCREEN_CENTER_Y + 143;queuecommand,"Animate");
		MissionConfirmedMessageCommand=cmd(visible,true;finishtweening;queuecommand,"Animate");
		AnimateCommand=cmd(zoom,1.75;diffusealpha,1;linear,0.4;zoom,2.5;diffusealpha,0;sleep,0.2;queuecommand,"Animate");
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,2;xy,150,SCREEN_CENTER_Y + 80;queuecommand,"Animate");
		MissionConfirmedMessageCommand=cmd(visible,true;finishtweening;queuecommand,"Animate");
		AnimateCommand=cmd(y,SCREEN_CENTER_Y + 80;linear,0.24;y,SCREEN_CENTER_Y + 60;linear,0.24;y,SCREEN_CENTER_Y + 80;queuecommand,"Animate");
	};	
	------------------------------------PLAYER 2------------------------------------
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,0;xy,SCREEN_WIDTH - 150,SCREEN_CENTER_Y + 153);
		MissionConfirmedMessageCommand=cmd(visible,true);
		BackMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,1;xy,SCREEN_WIDTH - 150,SCREEN_CENTER_Y + 143);
		MissionConfirmedMessageCommand=cmd(visible,true);
		BackMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,1;xy,SCREEN_WIDTH - 150,SCREEN_CENTER_Y + 143;queuecommand,"Animate");
		MissionConfirmedMessageCommand=cmd(visible,true;finishtweening;queuecommand,"Animate");
		AnimateCommand=cmd(zoom,1.75;diffusealpha,1;linear,0.4;zoom,2.5;diffusealpha,0;sleep,0.2;queuecommand,"Animate");
	};
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEXCENTERSTEP 3x1")).. 
	{		
		OnCommand=cmd(zoom,1.75;animate,false;setstate,2;xy,SCREEN_WIDTH - 150,SCREEN_CENTER_Y + 80;queuecommand,"Animate");
		MissionConfirmedMessageCommand=cmd(visible,true;finishtweening;queuecommand,"Animate");
		AnimateCommand=cmd(y,SCREEN_CENTER_Y + 80;linear,0.24;y,SCREEN_CENTER_Y + 60;linear,0.24;y,SCREEN_CENTER_Y + 80;queuecommand,"Animate");
	};
	
	-- Def.Sound {
		-- PlayerJoinedMessageCommand=function(self)
			-- SOUND:PlayOnce(THEME:GetPathS("","START"));
		-- end;
		--OffCommand=function(self)
		--	if SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu" then
		--		SOUND:PlayOnce(THEME:GetPathS("","START"));
		--	end;
		--end;
	-- };
	
	
	LoadActor(THEME:GetPathG("","TITLE/FIESTAEX_USB")) .. 
	{
		OnCommand=function(self)
			self:zoom(1.5);
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
	
	x[0] = player == PLAYER_1 and -404 or 404;
	x[1] = player == PLAYER_1 and -473 or 335;
	x[2] = player == PLAYER_1 and -500 or 308;
	x[3] = player == PLAYER_1 and -450 or 358;
	x[4] = player == PLAYER_1 and -281 or 527;
	
	t[#t+1] =  Def.ActorFrame{			
	
		-- esta wea es horrible :( pero funciona y no va a joder memoria (espero)
		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[2],SCREEN_CENTER_Y+437;animate,false;scaletoclipped,38,35);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					local sFile = PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetAvatarFile();
					if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
						self:Load("/Avatars/" .. sFile);
					else
						self:Load("/Avatars/000.png");
					end;
					
					self:y(SCREEN_CENTER_Y+437);
					self:linear(0.2):addy(-100);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(SCREEN_CENTER_Y+437);
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","THEME-BANKAVATAR")) .. {
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0],SCREEN_CENTER_Y+437;animate,false;setstate,0);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:y(SCREEN_CENTER_Y+437);
					self:linear(0.2):addy(-100);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(SCREEN_CENTER_Y+437);
				end;
			end;
		};
		LoadFont("title")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[1],SCREEN_CENTER_Y+430;zoom,0.8;horizalign,left);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect();
					self:settext(string.upper(PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetDisplayName()));
					self:y(SCREEN_CENTER_Y+430);
					self:linear(0.2):addy(-100);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(SCREEN_CENTER_Y+430);
				end;
			end;
		};
		--LoadActor(THEME:GetPathG("","THEME-GRIDAVATAR"))..{
		--	OnCommand=cmd(xy,SCREEN_CENTER_X+x[2],SCREEN_CENTER_Y+437;zoomx,.36;zoomy,.32;animate,false;setstate,39);
		--	ProfileMessageCommand=function(self,params)
		--		if params.Player == player then
		--			self:finishtweening();
		--			self:y(SCREEN_CENTER_Y+437);
		--			self:linear(0.2):addy(-100);
		--			self:setstate(PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetBirthYear());
		--		end;
		--	end;
		--	CardDisconnectedMessageCommand=function(self,params)
		--		if params.Player == player then
		--			self:y(SCREEN_CENTER_Y+437);
		--		end;
		--	end;
		--};
		
		-- Player 2
		LoadActor(THEME:GetPathG("","TE-PROMPT"))..{
			InitCommand=cmd(Center;addy,260;zoomx,.7;zoomy,.3;diffusealpha,0);
			WorldMaxMissingMessageCommand=function(self, params)
				self:finishtweening():linear(0.1):diffusealpha(.7):sleep(1.8):linear(0.13):diffusealpha(0);
			end;
		};
		
		LoadFont("_mainfont")..
		{
			InitCommand=cmd(Center;addy,260;diffusealpha,0;settext,"WorldMax Media is not installed");
			WorldMaxMissingMessageCommand=function(self, params)
			
				if (PREFSMAN:GetPreference('Language') == "en") then
					self:settext("WorldMax Media is not installed")
					self:zoom(1);
				elseif (PREFSMAN:GetPreference('Language') == "po") then
					self:settext("WorldMax Media não está instalado")
					self:zoom(1);
				else
					self:settext("El contenido multimedia de WorldMax\nno está instalado")
					self:zoom(.8);
				end;
				
				self:finishtweening():linear(0.1):diffusealpha(1):sleep(2):linear(0.13):diffusealpha(0);
			end;
		};
		
		
		LoadFont("USBL")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[3],SCREEN_CENTER_Y+477;horizalign,left);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:settext(string.format("%05i", PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetUserLevel()));
					self:y(SCREEN_CENTER_Y+477);
					self:linear(0.2):addy(-100);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(SCREEN_CENTER_Y+476);
				end;
			end;
		};		
	};	
	for h=1, PREFSMAN:GetPreference("SongsPerPlay"),1 do
		t[#t+1]=LoadActor(THEME:GetPathG("","THEME-BANKAVATAR")) .. {
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[4] + 19 * (h*-1),SCREEN_CENTER_Y+437;animate,false;setstate,1);
			ProfileMessageCommand=function(self,params)				
				if params.Player == player then
					self:finishtweening();
					self:y(SCREEN_CENTER_Y+437);
					self:linear(0.2):addy(-100);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(SCREEN_CENTER_Y+437);
				end;
			end;
		};
	end;			
end;

-- CreateUsbForPlayer(PLAYER_1);
-- CreateUsbForPlayer(PLAYER_2);	

return t;