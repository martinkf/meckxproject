local t = Def.ActorFrame {};

local function InputHandler(event)
	if not event.PlayerNumber or not event.button then
		return false
	end
	
	if event.button == "Center" or event.button == "Start" then
		local nextScreen = Branch.GetStartScreen();
		SCREENMAN:SetNewScreen(nextScreen);
	end;
end;


t[#t+1] = Def.ActorFrame {

	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler);
		SCREENMAN:GetTopScreen():lockinput(.5);
	end,
};


t[#t+1] = LoadActor("screenLogo/logo_underlay")..{
		OnCommand=function(self)
		end;
	};

t[#t+1] = LoadActor("screenLogo/logo_overlay")..{
		OnCommand=function(self)
		end;
	};

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);
		OnCommand=function(self)
			self:linear(0.3);
			self:diffusealpha(0);
		end;

		OffCommand=function(self)
			self:linear(0.3);
			self:diffusealpha(1);
		end;
	};


return t;