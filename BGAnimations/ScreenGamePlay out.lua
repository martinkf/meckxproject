local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		OnCommand=function(self)
			self:diffusealpha(1);
		end;
	};
};

return t;