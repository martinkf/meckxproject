local BPlaying = false;
local BPlayerCanJoin={};
BPlayerCanJoin[-1] = true;
BPlayerCanJoin[1] = true;

nxtstg = -1;
sortMode = 0;


local Left = false;
local State = 0;


local t = Def.ActorFrame{
	
	LoadActor(THEME:GetPathS("","NXA TITLE")) .. {
		OnCommand=cmd(queuecommand,"Sound");
		SoundCommand=function(self)
			if PREFSMAN:GetPreference('MusicTitle') then
				if (GAMESTATE:GetCoins() > 0 or GAMESTATE:GetCoinMode() == "CoinMode_Free" or GAMESTATE:GetCoinMode() == "CoinMode_Home") and GAMESTATE:GetGameMode() == "WorldMax" and not BPlaying then
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
			if GAMESTATE:GetGameMode() == "WorldMax" and not BPlaying then
				self:play();
				BPlaying=true;
			else
				self:stop();
				BPlaying=false;
			end;
		end;
		NextModMessageCommand=function(self,params)
			if GAMESTATE:GetGameMode() == "WorldMax" and not BPlaying then
				self:play();
				BPlaying=true;
			else
				self:stop();
				BPlaying=false;
			end;
		end;
	};
	
	
	-- LoadActor(THEME:GetPathG("","TITLE/NXA.MPG"))..
	-- {
		-- OnCommand=cmd(Center;FullScreen);
		-- PrevModMessageCommand=function(self,params)
			-- if GAMESTATE:GetGameMode() == "WorldMax" then
				-- self:SetSecondsIntoAnimation(0);
				-- self:play();
			-- else
				-- self:pause();
			-- end;
		-- end;
		-- NextModMessageCommand=function(self,params)
			-- if GAMESTATE:GetGameMode() == "WorldMax" then
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
	
	-- Def.Sound {
		-- PlayerJoinedMessageCommand=function(self)
			-- SOUND:PlayOnce(THEME:GetPathS("","START"));
		-- end;
	-- };
	
	
	
	
	LoadActor(THEME:GetPathG("","TITLE/NXAc_step")) .. 
	{
		OnCommand=function(self)
			self:xy(140,SCREEN_BOTTOM - 210):animate(false):zoom(1.75):playcommand("ForceAni");
		end;
		ForceAniCommand=function(self)
			self:finishtweening();
			if Left then
				State = State - 1;
			else
				State = State + 1;
			end;
			self:setstate(State);
			if State == 8 then
				Left = true;
			end;
			if State == 0 then
				Left = false;
			end;
			
			self:sleep(0.03125):queuecommand("ForceAni");
		end;
		-- CoinInsertedMessageCommand=cmd(visible,Visible());
	};
	LoadActor(THEME:GetPathG("","TITLE/NXAc_step")) ..  
	{
		OnCommand=function(self)
			self:xy(SCREEN_RIGHT - 140,SCREEN_BOTTOM - 210):zoom(1.75):animate(false):playcommand("ForceAni");
		end;
		ForceAniCommand=function(self)
			self:finishtweening();			
			self:setstate(State);
			self:sleep(0.03125):queuecommand("ForceAni");
		end;
		-- CoinInsertedMessageCommand=cmd(visible,Visible());
	};
	
	LoadActor(THEME:GetPathG("","TITLE/NXA_USB")) .. 
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
		-- LoadActor(THEME:GetPathG("","_blank"))..{
			-- OnCommand=cmd(xy,SCREEN_CENTER_X+x[2],SCREEN_CENTER_Y+437;animate,false;scaletoclipped,38,35);
			-- ProfileMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:finishtweening();
					-- local sFile = PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetAvatarFile();
					-- if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
						-- self:Load("/Avatars/" .. sFile);
					-- else
						-- self:Load("/Avatars/000.png");
					-- end;
					
					-- self:y(SCREEN_CENTER_Y+437);
					-- self:linear(0.2):addy(-100);
				-- end;
			-- end;
			-- CardDisconnectedMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:y(SCREEN_CENTER_Y+437);
				-- end;
			-- end;
		-- };

		-- LoadActor(THEME:GetPathG("","THEME-BANKAVATAR")) .. {
			-- OnCommand=cmd(xy,SCREEN_CENTER_X+x[0],SCREEN_CENTER_Y+437;animate,false;setstate,0);
			-- ProfileMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:finishtweening();
					-- self:y(SCREEN_CENTER_Y+437);
					-- self:linear(0.2):addy(-100);
				-- end;
			-- end;
			-- CardDisconnectedMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:y(SCREEN_CENTER_Y+437);
				-- end;
			-- end;
		-- };
		-- LoadFont("title")..{
			-- OnCommand=cmd(xy,SCREEN_CENTER_X+x[1],SCREEN_CENTER_Y+430;zoom,0.8;horizalign,left);
			-- ProfileMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:finishtweening():stopeffect();
					-- self:settext(string.upper(PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetDisplayName()));
					-- self:y(SCREEN_CENTER_Y+430);
					-- self:linear(0.2):addy(-100);
				-- end;
			-- end;
			-- CardDisconnectedMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:y(SCREEN_CENTER_Y+430);
				-- end;
			-- end;
		-- };
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
		-- LoadActor(THEME:GetPathG("","TE-PROMPT"))..{
			-- InitCommand=cmd(Center;addy,260;zoomx,.7;zoomy,.3;diffusealpha,0);
			-- WorldMaxMissingMessageCommand=function(self, params)
				-- self:finishtweening():linear(0.1):diffusealpha(.7):sleep(1.8):linear(0.13):diffusealpha(0);
			-- end;
		-- };
		
		-- LoadFont("_mainfont")..
		-- {
			-- InitCommand=cmd(Center;addy,260;diffusealpha,0;settext,"WorldMax Media is not installed");
			-- WorldMaxMissingMessageCommand=function(self, params)
			
				-- if (PREFSMAN:GetPreference('Language') == "en") then
					-- self:settext("WorldMax Media is not installed")
					-- self:zoom(1);
				-- elseif (PREFSMAN:GetPreference('Language') == "po") then
					-- self:settext("WorldMax Media não está instalado")
					-- self:zoom(1);
				-- else
					-- self:settext("El contenido multimedia de WorldMax\nno está instalado")
					-- self:zoom(.8);
				-- end;
				
				-- self:finishtweening():linear(0.1):diffusealpha(1):sleep(2):linear(0.13):diffusealpha(0);
			-- end;
		-- };
		
		
		-- LoadFont("USBL")..{
			-- OnCommand=cmd(xy,SCREEN_CENTER_X+x[3],SCREEN_CENTER_Y+477;horizalign,left);
			-- ProfileMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:finishtweening();
					-- self:settext(string.format("%05i", PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetUserLevel()));
					-- self:y(SCREEN_CENTER_Y+477);
					-- self:linear(0.2):addy(-100);
				-- end;
			-- end;
			-- CardDisconnectedMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:y(SCREEN_CENTER_Y+476);
				-- end;
			-- end;
		-- };		
	};	
	-- for h=1, PREFSMAN:GetPreference("SongsPerPlay"),1 do
		-- t[#t+1]=LoadActor(THEME:GetPathG("","THEME-BANKAVATAR")) .. {
			-- OnCommand=cmd(xy,SCREEN_CENTER_X+x[4] + 19 * (h*-1),SCREEN_CENTER_Y+437;animate,false;setstate,1);
			-- ProfileMessageCommand=function(self,params)				
				-- if params.Player == player then
					-- self:finishtweening();
					-- self:y(SCREEN_CENTER_Y+437);
					-- self:linear(0.2):addy(-100);
				-- end;
			-- end;
			-- CardDisconnectedMessageCommand=function(self,params)
				-- if params.Player == player then
					-- self:y(SCREEN_CENTER_Y+437);
				-- end;
			-- end;
		-- };
	-- end;			
end;
-- for i=-1,1,2 do
	-- t[#t+1] = GetPlat() .. {
		-- OnCommand=cmd(Center;addx,470*i;addy,80;visible,Visible() and BPlayerCanJoin[i]);
		-- VisibleAuxMessageCommand=cmd(visible,Visible() or not BPlayerCanJoin[i])
	-- };
	-- t[#t+1] = LoadActor(THEME:GetPathG("","TITLESCREEN-UTIL")) .. {
		-- InitCommand=cmd(animate,false;setstate,0);
		-- OnCommand=cmd(Center;addx,400*i;addy,250;visible,not Visible() and BPlayerCanJoin[i]);
		-- VisibleAuxMessageCommand=cmd(visible,not Visible() and BPlayerCanJoin[i])
	-- };
	-- t[#t+1] = LoadActor(THEME:GetPathG("","TITLESCREEN-UTIL")) .. {
		-- InitCommand=cmd(animate,false;setstate,0);
		-- OnCommand=cmd(Center;addx,400*i;addy,250;visible,not Visible() and BPlayerCanJoin[i];queuecommand,"Effect");
		-- EffectCommand=cmd(finishtweening;zoom,1;diffusealpha,1;linear,.8;zoom,1.25;diffusealpha,0;queuecommand,"Effect");
		-- VisibleAuxMessageCommand=cmd(visible,not Visible() and BPlayerCanJoin[i])
	-- };
	
	-- t[#t+1] = LoadActor(THEME:GetPathG("","TITLESCREEN-UTIL")) .. {	--OFFLINE
		-- InitCommand=cmd(animate,false;setstate,1);
		-- OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-45;visible,(SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu"));
	-- };
	
	-- t[#t+1] = LoadActor(THEME:GetPathG("", "TITLE-BUTTONS")) .. {
		-- OnCommand=function(self)
			-- if VisibleButton() and BPlayerCanJoin[i] then
				-- self:x(SCREEN_CENTER_X + 470*i);
			-- else
				-- self:x(SCREEN_CENTER_X + 760*i);
			-- end;
			-- self:animate(false):y(SCREEN_CENTER_Y+210):playcommand("Effect");
		-- end;
		-- EffectCommand=cmd(finishtweening;glowshift;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.25");effectperiod,1.5);
		-- VisibleAuxMessageCommand=function(self)
			-- self:linear(0.125);
			-- if VisibleButton() and BPlayerCanJoin[i] then
				-- self:x(SCREEN_CENTER_X + 470*i);
			-- else
				-- self:x(SCREEN_CENTER_X + 760*i);
			-- end;
		-- end;
	-- };
	-- t[#t+1] = LoadActor(THEME:GetPathG("", "TITLE-BUTTONS")) .. {

		-- OnCommand=cmd(animate,false;setstate,1;xy,SCREEN_CENTER_X + 470*i,SCREEN_CENTER_Y + 210;diffusealpha,0.5;fadeleft,0.4;faderight,0.4;blend,"BlendMode_Add";visible,VisibleButton() and BPlayerCanJoin[i]playcommand,"Effect");
		-- EffectCommand=function(self)
			-- if i == -1 then
				-- self:finishtweening():cropleft(1):cropright(-1):linear(1.5):cropleft(-1):cropright(1):queuecommand("Effect");
			-- end
			-- if i == 1 then
				-- self:finishtweening():cropleft(-1):cropright(1):linear(1.5):cropleft(1):cropright(-1):queuecommand("Effect");
			-- end
		-- end;
		-- VisibleAuxMessageCommand=cmd(visible,VisibleButton() and BPlayerCanJoin[i])
	-- };
	-- t[#t+1] = LoadActor(THEME:GetPathG("", "TITLE-BUTTONS")) .. {
		-- OnCommand=function(self)
			-- if VisibleButton() and BPlayerCanJoin[i] then
				-- self:x(SCREEN_CENTER_X + 470*i);
			-- else
				-- self:x(SCREEN_CENTER_X + 760*i);
			-- end;
			-- self:animate(false):y(SCREEN_CENTER_Y+210);
			
			-- if (gLANG() == "EN-") then
				-- self:setstate(4);
			-- elseif (gLANG() == "PO-") then
				-- self:setstate(6);
			-- else
				-- self:setstate(2);
			-- end;
		-- end;
		-- VisibleAuxMessageCommand=function(self)
			-- self:linear(0.125);
			-- if VisibleButton() and BPlayerCanJoin[i] then
				-- self:x(SCREEN_CENTER_X + 470*i);
			-- else
				-- self:x(SCREEN_CENTER_X + 760*i);
			-- end;
		-- end;
	-- };
-- end;

CreateUsbForPlayer(PLAYER_1);
CreateUsbForPlayer(PLAYER_2);	

return t;