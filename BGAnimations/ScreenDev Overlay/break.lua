local t = Def.ActorFrame {};

local sleepInitial=0.25;
local baseY=SCREEN_CENTER_Y-40;
local sleepToAnimate=0.9;

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBreak/sf") )..{
	InitCommand=cmd(diffusealpha,0;y,baseY-150;x,SCREEN_CENTER_X;animate,false;zoom,0.8;setstate,0);
	OnCommand=function(self)
		self:sleep(sleepInitial);		
		self:accelerate(0.3);
		self:diffusealpha(1);
		self:y(SCREEN_CENTER_Y);
		self:sleep(0.7);
		self:diffusealpha(0);		
		self:sleep(0.1);
		self:diffusealpha(1);		
	end;
	FinalizedMessageCommand=function(self)
		self:linear(0.5);
		self:diffusealpha(0);
	end;	
}


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBreak/sf") )..{
	InitCommand=cmd(diffusealpha,0;y,baseY;x,SCREEN_CENTER_X;animate,false;zoom,0.8;setstate,1);
	OnCommand=function(self)
		self:sleep(sleepInitial);			
		self:sleep(sleepToAnimate);
		self:diffusealpha(1);
		self:sleep(0.05);
		self:diffusealpha(0);
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBreak/sf") )..{
	InitCommand=cmd(diffusealpha,0;y,baseY;x,SCREEN_CENTER_X;animate,false;zoom,0.8;setstate,2);
	OnCommand=function(self)
		self:sleep(sleepInitial);			
		self:sleep(sleepToAnimate+0.05);
		self:diffusealpha(1);
		self:sleep(0.05);
		self:diffusealpha(0);
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBreak/sf") )..{
	InitCommand=cmd(diffusealpha,0;y,baseY;x,SCREEN_CENTER_X;animate,false;zoom,0.8;setstate,3);
	OnCommand=function(self)
		self:sleep(sleepInitial);			
		self:sleep(sleepToAnimate+0.1);
		self:diffusealpha(1);
		self:sleep(0.05);
		self:diffusealpha(0);
	end;
}

--ran text
local ranText = math.random(1,3);

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenBreak/text_base_"..ranText) )..{
	InitCommand=cmd(diffusealpha,1;y,baseY+120;x,SCREEN_CENTER_X;zoom,0.6;cropright,1);
	OnCommand=function(self)
		self:sleep(sleepInitial);			
		self:sleep(sleepToAnimate);
		self:linear(0.25);
		self:cropright(0);
	end;
	FinalizedMessageCommand=function(self)
		self:linear(0.5);
		self:diffusealpha(0);
	end;
}

return t;