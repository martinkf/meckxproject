local x = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,80;diffuse,color("0,0,0,0.5"));
		OnCommand=cmd();
		OffCommand=cmd();
	};
};
x[#x+1] = Def.Actor {
	BeginCommand=function(self)
		if SCREENMAN:GetTopScreen():HaveProfileToLoad() then self:sleep(1); end;
		self:queuecommand("Load");
	end;
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue(); end;
};

return x;