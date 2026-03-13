local t = Def.ActorFrame { };

--header.
local zoomgeneralBottom=0.8;
local topArrangeX=360;
local topArrangeY = SCREEN_CENTER_Y+350;
local colorMix = {"#ff0081","#00fffc","#00ffa8","#00ff00","#00fffc"};
local selectedColor = "#ffbe00";
local colorSelector = 1;

	t[#t+1] = Def.ActorFrame {

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/bot_base"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X-(topArrangeX+30),topArrangeY;diffusealpha,0.5);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/bot_lineglow"))..{
			Name="glowp1";
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X-(topArrangeX+70),topArrangeY-16;diffusealpha,0;queuecommand,"color");

			StepsChosenMessageCommand=function(self,params)				
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:queuecommand("selected");
				end;
			end;
			StepsUnchosenMessageCommand=function(self,params)				
				if params.Player == PLAYER_1 then	
					self:stoptweening();
					self:queuecommand("color");
				end;
			end;
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:queuecommand("color");
			end;			

			colorCommand=function(self)			
				self:diffusecolor(color(colorMix[colorSelector]));
				self:fadeleft(1);
				self:faderight(1);				
				self:accelerate(1);
				self:diffusealpha(1);
				self:accelerate(1);
				self:faderight(0);
				self:decelerate(4);
				self:fadeleft(1);
				self:diffusealpha(0);
				self:sleep(1);
				self:queuecommand("color");
			end;

			selectedCommand=function(self)
				self:faderight(0);
				self:diffusecolor(color(colorMix[colorSelector]));
				self:linear(0.025);
				self:diffusealpha(1);
				self:linear(0.04);
				self:diffusealpha(0);
				self:queuecommand("selected");
			end;				
			
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/bot_base"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX+30),topArrangeY;diffusealpha,0.5;rotationy,180);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/bot_lineglow"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX+70),topArrangeY-16;diffusealpha,0;rotationy,180;queuecommand,"color");
			Name="glowp2";
			StepsChosenMessageCommand=cmd(stoptweening;queuecommand,"selected");
			StepsUnchosenMessageCommand=cmd(stoptweening;queuecommand,"color");	

			StepsChosenMessageCommand=function(self,params)				
				if params.Player == PLAYER_2 then					
					self:stoptweening();			
					self:queuecommand("selected");
				end;
			end;
			StepsUnchosenMessageCommand=function(self,params)
					
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:queuecommand("color");
				end;
			end;
			
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:queuecommand("color");
			end;			

			colorCommand=function(self)				
				self:diffusecolor(color(colorMix[colorSelector]));
				self:fadeleft(1);
				self:faderight(1);				
				self:accelerate(1);
				self:diffusealpha(1);
				self:accelerate(1);
				self:faderight(0);
				self:decelerate(4);
				self:fadeleft(1);
				self:diffusealpha(0);
				self:sleep(1);
				self:queuecommand("color");
			end;	

			selectedCommand=function(self)
				self:faderight(0);
				self:diffusecolor(color(colorMix[colorSelector]));
				self:linear(0.025);
				self:diffusealpha(1);
				self:linear(0.04);
				self:diffusealpha(0);
				self:queuecommand("selected");
			end;			
					
		};	

	};



return t;