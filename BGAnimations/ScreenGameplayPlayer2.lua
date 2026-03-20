local TweakY = 29;--28 pre
local TweakX = SCREEN_CENTER_X+280;
if GAMESTATE:GetNumPlayersEnabled() == 1 and PREFSMAN:GetPreference("Center1Player") then
	TweakX = SCREEN_CENTER_X+40;
end;
local bAlreadyDead = false;

--THEME LIFEBAR
--CAMBIAR AL QUE SE QUIERA AGREGANDO LA CARPETA CORRESPONDIENTE CON LOS ARCHIVOS CORRESPONDIENTES
local profileP2SkinLifeBar = getCustomOptionValuePlayer(PLAYER_2,"lifebarSkin");

if profileP2SkinLifeBar == nil then
	profileP2SkinLifeBar = "none";
end;
local themeLifeBar = getPathSkinLifeBar(profileP2SkinLifeBar);


--revisamos si tiene un propio lua para cargar y no usar el defecto
--en el caso de encontrar el default.lua, cargamos eso.
local luaFileSkin = FindFileWithPatternOnDirectory(themeLifeBar.."/","default.lua");
if luaFileSkin ~= "-" then
	local actorFunc = LoadActor(themeLifeBar.."/default.lua");
	return actorFunc(themeLifeBar,PLAYER_2);
end;

local function Beat(self)
	-- too many locals
	local this = self:GetChildren()
	local playerstate = GAMESTATE:GetPlayerState( PLAYER_2 )
	local songposition = playerstate:GetSongPosition() -- GAMESTATE:GetSongPosition()	
	local beat = songposition:GetSongBeat() * songposition:GetCurScroll(PLAYER_2);
	local add = (songposition:GetCurBPS() * songposition:GetCurScroll(PLAYER_2)) / 0.5;
	local part = beat%1
	part = clamp(part,0,1)	
	if part <= 0.1 then
		this.Pulse:x(SCREEN_CENTER_X+455);
	end;	
	this.Pulse:addx(add);
	
	local eff = scale(part,0,0.7,1,0)
	if (songposition:GetDelay() or false) and part == 0 then eff = 0 end
	if beat < 0 then
		eff = 0
	end
	this.RedGlow:diffusealpha(eff);
end

local t = Def.ActorFrame{
	OnCommand=function(self)
		self:zoom(1.03);
		self:addx(-68);
		--self:addx(-24);
		self:zoomy(1.25);
		self:addy(-8);
	end;
	LoadActor(themeLifeBar.."/SG-BACKBARONE") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+90;y,SCREEN_TOP+TweakY;animate,false;zoomx,.97;zoomy,.8); 
		LifeChangedMessageCommand=function(self,params)
			local lifeP2 = params.LifeMeter:GetLife();
			if params.Player == PLAYER_2 then
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				if lifeP2 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then				
					self:setstate(1);
				else
					self:setstate(0);
				end;
			end;
		end;
	}; 
	
	LoadActor(themeLifeBar.."/SG-MASKBAR") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+50;y,SCREEN_TOP+TweakY;zoomx,.15;zoomy,1.2;MaskSource);	
	};
	
	LoadActor(themeLifeBar.."/SG-MASKBAR") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+465;y,SCREEN_TOP+TweakY;zoomy,1.2;MaskSource);	
	}; 
	InitCommand=cmd(SetUpdateFunction,Beat);
	LoadActor(themeLifeBar.."/SG-PULSE") .. {
		Name="Pulse";
		InitCommand=cmd(horizalign,right;y,SCREEN_TOP+TweakY;x,SCREEN_CENTER_X+455;diffusealpha,.9;MaskDest);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then	
				local lifeP2 = params.LifeMeter:GetLife();
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				self:zoomx(lifeP2 - 0.017);
			end;
		end;
	}; 
	LoadActor(themeLifeBar.."/SG-REALBARONE") .. {
		InitCommand=cmd(horizalign,right;x,SCREEN_CENTER_X+92;y,SCREEN_TOP+TweakY;rotationy,180;MaskDest;animate,false); 
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				
				if not bAlreadyDead then
					self:setstate(0)
				end;
				
				local lifeP2 = params.LifeMeter:GetLife();
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				local aux = params.LifeMeter:GetLife() >= 0.99 and 0 or 0.1;
				self:cropright(1 - lifeP2 + aux);
				
				if not bAlreadyDead and STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player):GetFailedAux() then
					self:setstate(2);
					bAlreadyDead = true
					MESSAGEMAN:Broadcast("GreyStatusP2");
				end;
				
				if lifeP2 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:setstate(1);
				end;
			end;
		end;
	};
	
	-- Red Glow
	LoadActor(themeLifeBar.."/SG-GLOWBARONEP") .. {
		Name="RedGlow";
		InitCommand=cmd(rotationy,180;horizalign,right;x,SCREEN_CENTER_X+75;y,SCREEN_TOP+TweakY;animate,false;setstate,1;diffusealpha,.9;zoomy,.84); 	
		--OnCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.5");effectcolor2,color("1,1,1,1");effectperiod,0.05);
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == PLAYER_2 then
				local lifeP2 = params.LifeMeter:GetLife();
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				if lifeP2 < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
	}; 
	
	-- Rainbow Glow
	LoadActor(themeLifeBar.."/SG-GLOWBARONEP") .. {
		InitCommand=cmd(rotationy,180;horizalign,right;x,SCREEN_CENTER_X+75;zoomy,.9;y,SCREEN_TOP+TweakY;animate,false;setstate,0); 	
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == PLAYER_2 then
				local lifeP2 = params.LifeMeter:GetLife();
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				
				if lifeP2 >= 1 then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
		GreyStatusP2MessageCommand=function(self)
			self:setstate(3);
		end;
	}; 
	
	LoadActor(themeLifeBar.."/SG-GLOWBARONEP") .. {
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+77;y,SCREEN_TOP+TweakY;animate,false;setstate,2); 	
	}; 
	

	LoadActor(themeLifeBar.."/SG-TIP") .. {
		InitCommand=cmd(draworder,4;horizalign,left;x,SCREEN_CENTER_X+170;y,SCREEN_TOP+TweakY;animate,false);
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				local lifeP2 = params.LifeMeter:GetLife();
				lifeP2 = tonumber(string.format("%.2f", lifeP2));
				self:setstate(0);
				if lifeP2 < THEME:GetMetric("LifeMeterBar", "DangerThreshold")  then
					self:setstate(1);
				end;
				self:x(SCREEN_CENTER_X +442 + (1 - lifeP2 * 360))
			end;
		end;
	};
	
	--LoadFont("_open sans") .. {
	--	InitCommand=cmd(draworder,4;horizalign,left;x,SCREEN_CENTER_X+175;y,SCREEN_TOP+TweakY;animate,false);
	--	LifeChangedMessageCommand=function(self,params)
	--		if params.Player == PLAYER_2 then
	--			local lifeP2 = params.LifeMeter:GetLife();
	--			lifeP2 = tonumber(string.format("%.2f", lifeP2));
	--			self:settext(lifeP2);
	--		end;
	--	end;
	--};
	
	LoadActor("ScreenGamePlayArtifacts") .. {
		OnCommand=cmd(x,TweakX;y,SCREEN_CENTER_Y;zoom,.5);
		DoTheBiteMessageCommand=function(self,params)
			if (params.PlayerNumber == PLAYER_2) then
				self:playcommand("BiteEffect");
			end;
		end;
	}; 
};
return t