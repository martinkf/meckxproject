local t = Def.ActorFrame
{
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);
	};

	LoadFont("sysdata")..{
		OnCommand=cmd(Center;settext,"Loading System Data...\nThis may take a few minutes";zoom,.8);
		--EffectCommand=cmd(linear,1;diffusealpha,0;sleep,.5;linear,1;diffusealpha,1;sleep,.5;queuecommand,"Effect");
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};
	
};


return t;