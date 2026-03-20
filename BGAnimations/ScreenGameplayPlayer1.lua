local TweakY = 24;
local TweakX = SCREEN_CENTER_X-280;
if GAMESTATE:GetNumPlayersEnabled() == 1 and PREFSMAN:GetPreference("Center1Player") then
	TweakX = SCREEN_CENTER_X-40;
end;

local FrameTime = 0.0167;
local bAlreadyDead = false;

--THEME LIFEBAR
--CAMBIAR AL QUE SE QUIERA AGREGANDO LA CARPETA CORRESPONDIENTE CON LOS ARCHIVOS CORRESPONDIENTES
local profileP1SkinLifeBar = getCustomOptionValuePlayer(PLAYER_1,"lifebarSkin");

if profileP1SkinLifeBar == nil then
	profileP1SkinLifeBar = "none";
end;
local themeLifeBar = getPathSkinLifeBar(profileP1SkinLifeBar);

--revisamos si tiene un propio lua para cargar y no usar el defecto
--en el caso de encontrar el default.lua, cargamos eso.
local luaFileSkin = FindFileWithPatternOnDirectory(themeLifeBar.."/","default.lua");
if luaFileSkin ~= "-" then
	local actorFunc = LoadActor(themeLifeBar.."/default.lua");
	return actorFunc(themeLifeBar,PLAYER_1);
end;

local function Beat(self)
	-- too many locals
	local this = self:GetChildren()
	local playerstate = GAMESTATE:GetPlayerState( PLAYER_1 )
	local songposition = playerstate:GetSongPosition() -- GAMESTATE:GetSongPosition()	
	local beat = songposition:GetSongBeat() * songposition:GetCurScroll(PLAYER_1);
	local add = (songposition:GetCurBPS() * songposition:GetCurScroll(PLAYER_1)) / -0.5;
	local part = beat%1
	part = clamp(part,0,1)	
	if part <= 0.1 then
		this.Pulse:x(SCREEN_CENTER_X-465);
	end;	
	
	this.Pulse:addx(add);
	
	local eff = scale(part,0,0.7,1,0)
	if (songposition:GetDelay() or false) and part == 0 then eff = 0 end
	if beat < 0 then
		eff = 0
	end
	this.RedGlow:diffusealpha(eff);
	
	--local FPS = DISPLAY:GetFPS();
	--if (FPS > 0) then
	--	FrameTime = 1 / FPS;
	--end;
end
local t = Def.ActorFrame{

	OnCommand=function(self)
		self:zoom(1.03);
		self:addx(31);
		--self:addx(-11);
		self:zoomy(1.25);
		self:addy(-2);
	end;

	LoadActor(themeLifeBar.. "/SG-BACKBARONE") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-93;y,SCREEN_TOP+TweakY;animate,false;rotationy,180;zoomx,.96;zoomy,.8); 
		LifeChangedMessageCommand=function(self,params)
			local lifeP1 = params.LifeMeter:GetLife();
			lifeP1 = tonumber(string.format("%.2f", lifeP1));
			if params.Player == PLAYER_1 then
				if lifeP1 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:setstate(1);
				else
					self:setstate(0);
				end;
			end;
		end;
	}; 
	
	LoadActor(themeLifeBar.. "/SG-MASKBAR") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-90;y,SCREEN_TOP+TweakY;zoomx,.15;zoomy,1.2;MaskSource);	
	};
	
	LoadActor(themeLifeBar.. "/SG-MASKBAR") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-465;y,SCREEN_TOP+TweakY;zoomy,1.2;MaskSource;rotationy,180);	
	};
	InitCommand=cmd(SetUpdateFunction,Beat);
	LoadActor(themeLifeBar.. "/SG-PULSE") .. {
		Name="Pulse";
		InitCommand=cmd(horizalign,left;diffusealpha,.9;y,SCREEN_TOP+TweakY;x,SCREEN_CENTER_X-465;MaskDest);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				local lifeP1 = params.LifeMeter:GetLife();
				lifeP1 = tonumber(string.format("%.2f", lifeP1));
				self:zoomx(lifeP1);
			end;
		end;
	}; 		
	LoadActor(themeLifeBar.. "/SG-REALBARONE") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-464;y,SCREEN_TOP+TweakY;MaskDest;animate,false); 
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then	
			
				if not bAlreadyDead then
					self:setstate(0)
				end;
				
				local lifeP1 = params.LifeMeter:GetLife();
				lifeP1 = tonumber(string.format("%.2f", lifeP1));
				local aux = params.LifeMeter:GetLife() >= 0.99 and 0 or 0.1;
				self:cropright(1 - lifeP1 + aux);
				
				if not bAlreadyDead and STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player):GetFailedAux() then
					self:setstate(2);
					bAlreadyDead = true
					MESSAGEMAN:Broadcast("GreyStatusP1");
				end;
				
				if lifeP1 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:setstate(1);
				end;
			end;
		end;
	};
	
	-- Red Glow
	LoadActor(themeLifeBar.. "/SG-GLOWBARONEP") .. {
		Name="RedGlow";
		InitCommand=cmd(horizalign,right;x,SCREEN_CENTER_X-75;y,SCREEN_TOP+TweakY;animate,false;setstate,1;diffusealpha,.9;zoomx,1.01); 	
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == PLAYER_1 then
				local lifeP1 = params.LifeMeter:GetLife();
				lifeP1 = tonumber(string.format("%.2f", lifeP1));
				if lifeP1 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
	}; 
	
	-- Rainbow Glow
	LoadActor(themeLifeBar.. "/SG-GLOWBARONEP") .. {
		InitCommand=cmd(horizalign,right;x,SCREEN_CENTER_X-80;zoomy,.9;y,SCREEN_TOP+TweakY;animate,false;setstate,0); 	
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		FrameTimeCommand=cmd(diffusealpha,1;sleep,FrameTime;diffusealpha,0;sleep,FrameTime;queuecommand,"FrameTime");
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == PLAYER_1 then
				local lifeP1 = params.LifeMeter:GetLife();
				lifeP1 = tonumber(string.format("%.2f", lifeP1));
				if lifeP1 >= 1 then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
		GreyStatusP1MessageCommand=function(self)
			self:setstate(3);
		end;
	}; 
	
	LoadActor(themeLifeBar.. "/SG-GLOWBARONEP") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-80;y,SCREEN_TOP+TweakY;rotationy,180;animate,false;setstate,2); 	
	}; 
	
	LoadActor(themeLifeBar.."/SG-TIP") .. {
		InitCommand=cmd(draworder,4;horizalign,left;y,SCREEN_TOP+TweakY;animate,false);
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		FrameTimeCommand=cmd(diffusealpha,1;sleep,FrameTime;diffusealpha,0;sleep,FrameTime;queuecommand,"FrameTime");
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				local lifeP1 = params.LifeMeter:GetLife();
				lifeP1 = tonumber(string.format("%.2f", lifeP1));
				self:setstate(0);
				if lifeP1 < THEME:GetMetric("LifeMeterBar", "DangerThreshold")  then
					self:setstate(1);
				end;
				self:x(SCREEN_CENTER_X -478 + (lifeP1 * 363))
			end;
		end;
	};
	--LoadFont("_unispace 18px")..{
	--	OnCommand=cmd(x,14;y,22;zoomx,.65;zoomy,.58;shadowlengthx,-1;shadowcolor,color("#000000");shadowlengthy,1;horizalign,left;queuecommand,"Print");
	--	LifeChangedMessageCommand=function(self,params)
	--		local lifeP1 = params.LifeMeter:GetLife();
	--		lifeP1 = tonumber(string.format("%.2f", lifeP1));
	--		self:settext("LIFE: " .. lifeP1);
	--	end;
	--};	

	LoadActor("ScreenGamePlayArtifacts") .. {
		OnCommand=cmd(x,TweakX;y,SCREEN_CENTER_Y;zoom,.5);
		DoTheBiteMessageCommand=function(self,params)
			if (params.PlayerNumber == PLAYER_1) then
				self:playcommand("BiteEffect");
			end;
		end;
	}; 

};
return t