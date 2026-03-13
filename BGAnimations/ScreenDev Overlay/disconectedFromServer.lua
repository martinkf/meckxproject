local t = Def.ActorFrame {};

local baseStepContinueY = SCREEN_CENTER_Y+25;

t[#t+1] = Def.ActorFrame{

	LoadFont("_TitleXolonium")..{
				Name="Title";
				Text="Disconected from the game server for inactivity.";
				InitCommand=cmd(zoom,1;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;);
	};

	Def.Quad {		
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+25);
			self:zoomto(868,5);
			self:diffuse(color("#7B68EE"));
			self:cropright(1);
			self:queuecommand("Ani");
		end;

		AniCommand=function(self)
			self:linear(5);
			self:cropright(0);
			self:sleep(1);

	        local top = SCREENMAN:GetTopScreen();
	        top:SetNextScreenName("ScreenDisconectedServer");
	        top:StartTransitioningScreen("SM_GoToNextScreen");
		end;
	};



	LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/screenjoin_center"))..{
		OnCommand=cmd(xy,SCREEN_CENTER_X,baseStepContinueY+50;zoom,1;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:linear(0.5);
			self:y(baseStepContinueY+50);
			self:linear(0.5);
			self:y(baseStepContinueY+48);
			self:queuecommand("Animate");
		end;	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};	

	LoadFont("_TitleXolonium")..{
				Name="Title";
				Text="Press the center step to continue";
				InitCommand=cmd(zoom,0.4;xy,SCREEN_CENTER_X,baseStepContinueY+70;);
	};

		CodeMessageCommand=function(self, params)
			if params.PlayerNumber == player and params.Name == "Center" then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			end;
		end;

}


return t;