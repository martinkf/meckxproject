local t = Def.ActorFrame {};

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0);	
		OffCommand=function(self)
			self:linear(0.3);
			self:diffuse(0,0,0,1);
		end;
};

return t;