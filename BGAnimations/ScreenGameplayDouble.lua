local YTweak = 29;
local bAlreadyDead = false;

local function Beat(self)
	-- too many locals
	local this = self:GetChildren()
	-- local PLAYER = GetMasterPlayerNumber
	local playerstate = GAMESTATE:GetPlayerState( GAMESTATE:GetMasterPlayerNumber() )
	local songposition = playerstate:GetSongPosition() -- GAMESTATE:GetSongPosition()	
	local beat = songposition:GetSongBeat() * songposition:GetCurScroll(GAMESTATE:GetMasterPlayerNumber());
	local add = (songposition:GetCurBPS() * songposition:GetCurScroll(GAMESTATE:GetMasterPlayerNumber())) / -0.3;
	local part = beat%1
	part = clamp(part,0,1)	
	if part <= 0.1 then
		this.Pulse:x(SCREEN_CENTER_X-370);
	end;	
	this.Pulse:addx(add);
end

--THEME LIFEBAR
--CAMBIAR AL QUE SE QUIERA AGREGANDO LA CARPETA CORRESPONDIENTE CON LOS ARCHIVOS CORRESPONDIENTES
local profileLifeBar = getCustomOptionValuePlayer(GAMESTATE:GetMasterPlayerNumber(),"lifebarSkin");

if profileLifeBar == nil then
	profileLifeBar = "none";
end;
local themeLifeBar = getPathSkinLifeBar(profileLifeBar);


local luaFileSkin = FindFileWithPatternOnDirectory(themeLifeBar.."/","default_double.lua");
if luaFileSkin ~= "-" then
	local actorFunc = LoadActor(themeLifeBar.."/default_double.lua");
	return actorFunc(themeLifeBar,GAMESTATE:GetMasterPlayerNumber());
end;


local t = Def.ActorFrame{

	OnCommand=function(self)
		self:zoomx(0.99);
		self:zoomy(1.05);
		self:addy(-2);
		self:addx(5);
	end;

	LoadActor(themeLifeBar.. "/SG-BACKBARDOUBLE") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+YTweak;animate,false;rotationy,180;zoomy,.7;zoomx,.99); 
		LifeChangedMessageCommand=function(self,params)
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));
				if life < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
					self:setstate(1);
				else
					self:setstate(0);
				end;
		end;
	}; 
	LoadActor(themeLifeBar.. "/SG-MASKBAR") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X-640;y,SCREEN_TOP+YTweak;zoomx,2;zoomy,1.2;MaskSource;rotationy,180);	
	}; 
	LoadActor(themeLifeBar.. "/SG-MASKBAR") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X+394;y,SCREEN_TOP+YTweak;zoomx,0.18;zoomy,1.2;MaskSource;rotationy,180);	
	}; 
	InitCommand=cmd(SetUpdateFunction,Beat);
	LoadActor(themeLifeBar.. "/SG-PULSE") .. {
		Name="Pulse";
		InitCommand=cmd(horizalign,left;diffusealpha,.9;y,SCREEN_TOP+YTweak;x,SCREEN_CENTER_X-370;MaskDest);
		LifeChangedMessageCommand=function(self,params)
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));
			self:zoomx(life*2);
		end;
	}; 
	LoadActor(themeLifeBar.. "/SG-REALBARDOUBLE") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X+1;y,SCREEN_TOP+YTweak;MaskDest;animate,false); 
		LifeChangedMessageCommand=function(self,params)
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));
			local aux = params.LifeMeter:GetLife() >= 0.99 and 0 or 0.1;--clamp(1.0- life,0.05, 0.1);
			self:cropright(1 - life + aux);
			
			if not bAlreadyDead then
				self:setstate(0)
			end;
			
			if not bAlreadyDead and STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetFailedAux() then
				self:setstate(2);
				bAlreadyDead = true
				MESSAGEMAN:Broadcast("GreyStatus");
			end;
			
			--if life < THEME:GetMetric("LifeMeterBar", "DangerThreshold")  then
			--	self:setstate(1);
			--end;
		end;
	};
	
	-- red glow
	LoadActor(themeLifeBar.. "/SG-GLOWBARDOUBLEP") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+YTweak;animate,false;setstate,1;diffusealpha,.9;zoomy,.8;zoomx,.99); 	
		OnCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,0.4");effectcolor2,color("1,1,1,0.8");effectperiod,0.05);
		LifeChangedMessageCommand=function(self,params)		
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));
			if life < THEME:GetMetric("LifeMeterBar", "DangerThreshold") and not bAlreadyDead then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	}; 
	
	-- rainbow glow
	LoadActor(themeLifeBar.. "/SG-GLOWBARDOUBLEP") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+YTweak;animate,false;setstate,0;diffusealpha,.9;zoomy,.8;zoomx,.99); 	
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)		
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));

			if life >= 1 then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
		GreyStatusMessageCommand=function(self)
			self:setstate(3);
		end;
	}; 
	
	LoadActor(themeLifeBar.. "/SG-GLOWBARDOUBLEP") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+YTweak;rotationy,180;animate,false;setstate,2); 	
	}; 
	LoadActor(themeLifeBar.. "/SG-TIP") .. {
		InitCommand=cmd(y,SCREEN_TOP+YTweak;animate,false);
		OnCommand=cmd(diffuseblink;effectperiod,0.05;effectcolor1,1,1,1,1;effectcolor2,1,1,1,0);
		OffCommand=cmd(stoptweening);
		LifeChangedMessageCommand=function(self,params)
			local life = params.LifeMeter:GetLife();
			life = tonumber(string.format("%.2f", life));
			self:setstate(0);
			if life < THEME:GetMetric("LifeMeterBar", "DangerThreshold")  then
				self:setstate(1);
			end;
			self:x(SCREEN_CENTER_X -368 + (life)* 735)
		end;
	};
	
	LoadActor("ScreenGamePlayArtifacts") .. {
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
	}; 
	
};
return t