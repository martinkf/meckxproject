local t = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		OnCommand=cmd(stoptweening;sleep,0.05;linear,0.05;diffusealpha,1);
	}
};

return t;