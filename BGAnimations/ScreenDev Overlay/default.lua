local t = Def.ActorFrame {};

t[#t+1] = 	LoadFont("_TitleXolonium")..{
			Name="Title";
			Text="DEBUG SCREEN";
			InitCommand=cmd(zoom,1;xy,SCREEN_CENTER_X,SCREEN_TOP+20;);
};


t[#t+1] = LoadActor("gameover")..{}


--[[
t[#t+1] = LoadActor("logo_underlay")..{}
t[#t+1] = LoadActor("logo_overlay")..{}
t[#t+1] = LoadActor("bg_matrix")..{}
t[#t+1] = LoadActor("logo_overlay")..{

}
]]

--[[
t[#t+1] = LoadActor("logo3static/logo_underlay")..{
		OnCommand=function(self)
		end;
};

t[#t+1] = LoadActor("logo3static/logo_overlay")..{
		OnCommand=function(self)
		end;
};
]]



--[[
t[#t+1] = Def.Sound{
	File=THEME:GetPathG("","ScreenGameOver/syssd_gameover.mp3"),
	OnCommand=function(self)
		-- play this sound effect at the parent screen's OnCommand
		self:play()
	end
}
]]

return t;