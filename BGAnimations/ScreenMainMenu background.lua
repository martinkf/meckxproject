local t = Def.ActorFrame {};
--[[
t[#t+1] = LoadActor("LogoBase/_base")..{
	InitCommand=cmd();
}

t[#t+1] = LoadActor("LogoBase/_logo")..{
	InitCommand=cmd();
}

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.6);
	
};
]]

--logo2
--[[
t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0);
		OnCommand=function(self)
			self:sleep(0.7);
			self:linear(0.1);
			self:diffusealpha(1);
		end;
	};	

t[#t+1] =  LoadActor( THEME:GetPathG("","LOGO/nlogo2/bredsm.mp4") )..{
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0);
			OnCommand=function(self)
				self:sleep(0.7);
				self:linear(12);
				self:diffusealpha(0.8);
				self:sleep(4);
				self:linear(8);
				self:diffusealpha(0.1);
				self:queuecommand("On");
			end;
	};	

t[#t+1] = LoadActor("MainLogo/logox_overlay")..{
		OnCommand=function(self)
			self:addy(-10);
		end;
	};
]]


--logo 1
--[[

t[#t+1] = LoadActor("MainLogo/logo_underlay")..{
	InitCommand=cmd();
}


t[#t+1] = LoadActor("MainLogo/logo_overlay")..{
	InitCommand=cmd();
}

]]

t[#t+1] = LoadActor("MainLogo/logo3static/logo_underlay")..{
	OnCommand=function(self)
	end;
};

t[#t+1] = LoadActor("MainLogo/logo3static/logo_overlay")..{
	OnCommand=function(self)
	end;
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.8);
	
};	
return t;