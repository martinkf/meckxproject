local t = Def.ActorFrame {};

	t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/back1.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	}


	t[#t+1] = Def.ActorFrame {
		Def.Sprite {
			InitCommand=function(self)			
				self:ChangeBack(THEME:GetPathG("","LOGO/logo.mpg"));
				self:SetSecondsIntoAnimation(0):Center():diffusealpha(0.3):blend("BlendMode_Add"):setsize(1280,720);
			end;
		}		
	};
	


	t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/back2.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	}

	t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.3);
};

return t;