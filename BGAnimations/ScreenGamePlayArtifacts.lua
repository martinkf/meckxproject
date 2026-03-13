
local fdelay1 = 0.08;
local fdelay2 = 0.16;

local t = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","FX/BLOOD_FX")) .. {
		Name = "BloodEffect";
		InitCommand=cmd(diffusealpha,0);
		StartAnimationCommand=cmd(y,0;sleep,.4;diffusealpha,1;zoom,.5;linear,.15;zoom,1.25;sleep,.45;linear,.25;addy,300;diffusealpha,0);
	}; 
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MouthDownDelay1";
		InitCommand=cmd(rotationx,180;y,110;diffusealpha,0); 
		StartAnimationCommand=cmd(y,100;sleep,fdelay1;zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,.3;addy,200;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,-200;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,-7;linear,.1;addy,14;linear,.1;addy,-7;linear,.1;addy,14;linear,.15;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MouthDownDelay2";
		InitCommand=cmd(rotationx,180;y,110;diffusealpha,0); 
		StartAnimationCommand=cmd(y,100;sleep,fdelay2;zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,.3;addy,200;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,-200;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,-7;linear,.1;addy,14;linear,.1;addy,-7;linear,.1;addy,14;linear,.15;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MainMouthDown";
		InitCommand=cmd(rotationx,180;y,110;diffusealpha,0); 
		StartAnimationCommand=cmd(y,100;zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,1;addy,200;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,-200;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,-5;linear,.1;addy,10;sleep,.05;linear,.1;addy,-5;linear,.1;addy,10;linear,.15;diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MouthUpDelay1";
		InitCommand=cmd(diffusealpha,0);
		StartAnimationCommand=cmd(sleep,fdelay1;zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,.3;addy,-400;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,400;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,7;linear,.1;addy,-14;linear,.1;addy,7;linear,.1;addy,-14;linear,.15;diffusealpha,0);
	}; 
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MouthUpDelay2";
		InitCommand=cmd(diffusealpha,0);
		StartAnimationCommand=cmd(sleep,fdelay2;zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,.3;addy,-400;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,400;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,7;linear,.1;addy,-14;linear,.1;addy,7;linear,.1;addy,-14;linear,.15;diffusealpha,0);
	}; 
	LoadActor(THEME:GetPathG("","FX/MOUTH")) .. {
		Name = "MainMouthUp";
		InitCommand=cmd(diffusealpha,0);
		StartAnimationCommand=cmd(zoomy,.45;zoomx,.65;diffusealpha,0;linear,.2;diffusealpha,1;addy,-400;linear,.1;zoomy,.8;zoomx,1;linear,.1;addy,400;sleep,.05;queuecommand,"EatEffect");
		EatEffectCommand=cmd(stoptweening;linear,.1;addy,5;linear,.1;addy,-10;sleep,.05;linear,.1;addy,5;linear,.1;addy,-10;linear,.15;diffusealpha,0);
	}; 
	
	BiteEffectCommand=function(self)
		local this = self:GetChildren();
		this.MainMouthDown:finishtweening():queuecommand("StartAnimation");
		this.MainMouthUp:finishtweening():queuecommand("StartAnimation");
		this.MouthDownDelay1:finishtweening():queuecommand("StartAnimation");
		this.MouthDownDelay2:finishtweening():queuecommand("StartAnimation");
		this.MouthUpDelay1:finishtweening():queuecommand("StartAnimation");
		this.MouthUpDelay2:finishtweening():queuecommand("StartAnimation");
		this.BloodEffect:finishtweening():queuecommand("StartAnimation");
	end;

	
}

return t;