local t = Def.ActorFrame {};

local function getSectorMapsAni(xFromCenter,YfromCenter,initSleepMs,zoomBase)
	local initSleep=initSleepMs;
	local timeOnScreen=4;
	local extraDelayExecution = 3;
	return Def.ActorFrame {

		OnCommand=function(self)
			self:x(SCREEN_CENTER_X+xFromCenter);
			self:y(SCREEN_CENTER_Y+YfromCenter);
			self:sleep(timeOnScreen+extraDelayExecution);
			self:queuecommand("Animate");
		end;

		AnimateCommand=function(self)
			local xPosTrRan = math.random(-500,500);
			local yPosTrRan = math.random(-500,500);
			self:x(SCREEN_CENTER_X+xPosTrRan);
			self:y(SCREEN_CENTER_Y+yPosTrRan);
			self:GetChild("txts"):queuecommand("On");
			self:GetChild("trsector"):queuecommand("On");
			self:sleep(timeOnScreen+extraDelayExecution);
			self:queuecommand("Animate");
		end;

		FinalizedMessageCommand = function(self)	
			self:stoptweening():diffusealpha(0);
		end;        

		LoadActor( THEME:GetPathG("","LOGO/nlogo3/txt_sector.png") ).. {
			Name="txts";
			InitCommand=cmd(zoom,0.6+zoomBase;diffusealpha,0;addx,-35);
			OnCommand=function(self)
				self:sleep(initSleep);
				self:diffusealpha(1);
				self:sleep(timeOnScreen);
				self:linear(0);
				self:diffusealpha(0);				
			end;
		};


		LoadActor( THEME:GetPathG("","LOGO/nlogo3/saddress.png") ).. {
			Name="trsector";
			InitCommand=cmd(zoom,0.4+zoomBase;diffusealpha,0);
			OnCommand=function(self)
				self:rotationz(45);
				self:sleep(initSleep);
				self:sleep(0.12);
				self:diffusealpha(1);
				self:decelerate(0.3);
				self:rotationz(0);
				self:sleep(timeOnScreen);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0.05);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0.05);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0);
				self:diffusealpha(0);
			end;	
			FinalizedMessageCommand = function(self)	
				self:stoptweening():diffusealpha(0);
			end;      
		};
	};
end;

t[#t+1] = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
	};


	LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.4;visible,true);
		OnCommand=function(self)
		end;		
	};	

	LoadActor( THEME:GetPathG("","commonBackground/bredsm.mp4") )..{
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(12);
				self:diffusealpha(0.4);
				self:linear(12);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;	
	};	


	LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
		SelectChannelMessageCommand=function(self)
			self:diffusealpha(1);
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;
	};	
};

local ranTrMin = 30;
local ranTrMax = 90; 
for i=1,15 do
	local xPosTrRan = math.random(-500,500);
	local yPosTrRan = math.random(-500,500);
	local zoomBaseTrRan = math.random(15,25)/100;
	t[#t+1] = getSectorMapsAni(xPosTrRan,yPosTrRan,(math.random(ranTrMin,ranTrMax)/100),zoomBaseTrRan);
end;

return t;