local t = Def.ActorFrame {

	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		OnCommand=cmd(stoptweening;sleep,0.1;linear,0.05;diffusealpha,1;sleep,0.28;queuecommand,"proc");
		procCommand=function(self)
			SCREENMAN:GetTopScreen():PostScreenMessage("SM_GoToNextScreen", 0);
		end;
	}
};

return t;