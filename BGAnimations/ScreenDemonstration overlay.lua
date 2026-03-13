local t = Def.ActorFrame
{
	CoinInsertedMessageCommand=function(self)
		SCREENMAN:GetTopScreen():GetChild("Timer"):SetSeconds(0.1)
	end;
	
	LoadActor(THEME:GetPathB("ScreenGameplay","overlay"));
	
	LoadActor(THEME:GetPathG("","SD-DEMO"))..
	{
		OnCommand=cmd(Center;loop,false);
	};

	
};
return t;