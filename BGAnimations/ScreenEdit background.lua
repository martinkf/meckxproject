local t = Def.ActorFrame {};

t[#t+1] = LoadActor( THEME:GetPathG("","Editor Background") )..{
	InitCommand=cmd(stoptweening;Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
	HideEditBackgroundMessageCommand=cmd(stoptweening;visible,false);
	ShowEditBackgroundMessageCommand=cmd(stoptweening;visible,true);
};


t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.3);
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,0;x,0;y,SCREEN_CENTER_Y;zoomto,160,SCREEN_HEIGHT;diffuse,0,0,0,.5);
	OnCommand=cmd(diffusealpha,0;linear,.2;diffusealpha,.5);
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(horizalign,2;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;zoomto,164,SCREEN_HEIGHT;diffuse,0,0,0,.5);
	OnCommand=cmd(diffusealpha,0;linear,.2;diffusealpha,.5);
};


return t;