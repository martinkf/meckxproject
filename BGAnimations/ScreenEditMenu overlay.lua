return Def.ActorFrame {
	LoadActor(THEME:GetPathG("","PIU LOGO"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_TOP+10;zoom,.6;vertalign,top);
	};
}