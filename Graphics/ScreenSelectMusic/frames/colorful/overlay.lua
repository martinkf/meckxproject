local t = Def.ActorFrame { };

--header.
local zoomgeneralBottom=0.64;
local topArrangeX=300;
local topArrangeY = SCREEN_TOP-6;
local sleepBase=0.05;
local speedAnimation=0.2;
local speedExpandAnimation = 4;

local colorsHeader = {"#fb419b","#3ef7d2","#ffa024","#cffcc0","#35ff30"};
local colorHeaderSelected = 1;
local diffuseSprite=1;


function crearBaseColorful(player)

	local pl=1;
	local ry = 0;
	local playerEnabled=false;
	if player == PLAYER_1 then
		pl = -1;
		ry = 180;
	end;

	if GAMESTATE:IsPlayerEnabled(player) then
		playerEnabled = true;
	end;

	return Def.ActorFrame { 
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/connect"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+((topArrangeX-210)*pl),topArrangeY+45;diffusealpha,1;rotationy,ry);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/a_b"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY+40;diffusealpha,1;rotationy,ry;queuecommand,"AniLoop");
			AniLoopCommand=function(self)
				if playerEnabled == false then
					self:diffuse(0.2, 0.2, 0.2, 1)
				end; 
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom+0.015);
				self:sleep(0.2);
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom);
				self:queuecommand("AniLoop");
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);	
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/b_b"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY;diffusealpha,0;queuecommand,"Animate");
			AnimateCommand=function(self)
				if playerEnabled == false then
					self:diffuse(0.2, 0.2, 0.2, 1)
				end;
				self:sleep(sleepBase);
				self:decelerate(speedAnimation);
				self:diffusealpha(1);
				self:y(topArrangeY+35);
				self:queuecommand("AniLoop");
			end;
			AniLoopCommand=function(self)
				self:sleep(0.1);
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom+0.01);
				self:sleep(0.2);
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom);
				self:queuecommand("AniLoop");
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/c_b"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY;diffusealpha,0;queuecommand,"Animate");
			AnimateCommand=function(self)
				if playerEnabled == false then
					self:diffuse(0.2, 0.2, 0.2, 1)
				end;
				self:sleep(sleepBase+sleepBase);
				self:decelerate(speedAnimation);
				self:diffusealpha(1);
				self:y(topArrangeY+29);
				self:queuecommand("AniLoop");
			end;
			AniLoopCommand=function(self)
				self:sleep(0.2);
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom+0.005);
				self:sleep(0.2);
				self:linear(speedExpandAnimation);
				self:zoomx(zoomgeneralBottom);
				self:queuecommand("AniLoop");
			end;			
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/btop"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY;diffusealpha,0;queuecommand,"Animate");
			AnimateCommand=function(self)
				self:sleep(sleepBase+sleepBase+sleepBase);
				self:decelerate(speedAnimation);
				self:diffusealpha(1);
				self:y(topArrangeY+25);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/bglow"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY;diffusealpha,0;queuecommand,"Animate");
			AnimateCommand=function(self)
				if playerEnabled then
					self:y(topArrangeY+21);
					self:diffusecolor(color(colorsHeader[colorHeaderSelected]));
					if player == PLAYER_2 then
						self:cropleft(1)
						self:queuecommand("GlowSweepP2");
					else
						self:cropright(1)
						self:queuecommand("GlowSweep");	
					end;
				else
					self:visible(false);
				end;
			end;

			GlowSweepCommand=function(self)				
			    self:cropright(1)
			    self:sleep(0.5)
			    self:diffusealpha(diffuseSprite);
			    self:linear(4)			    
			    self:cropright(0)
			    self:diffusealpha(0.1);
			    self:sleep(0.5)
			    self:linear(2);
			    self:diffusealpha(0);
			    self:queuecommand("GlowSweep")
			end;	
			GlowSweepP2Command=function(self)				
			    self:cropleft(1)
			    self:sleep(0.5)
			    self:diffusealpha(diffuseSprite);
			    self:linear(4)			    
			    self:cropleft(0)
			    self:diffusealpha(0.1);
			    self:sleep(0.5)
			    self:linear(2);
			    self:diffusealpha(0);
			    self:queuecommand("GlowSweepP2")
			end;	
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};	


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/bglow"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X+(topArrangeX*pl),topArrangeY;diffusealpha,0;queuecommand,"Animate");
			AnimateCommand=function(self)
				if playerEnabled then
					self:y(topArrangeY+21);
					self:diffusecolor(color(colorsHeader[colorHeaderSelected]));
					if player == PLAYER_2 and playerEnabled then
						self:cropleft(1)
						self:sleep(3.5);
						self:queuecommand("GlowSweepP2");
					else
						self:cropright(1)
						self:sleep(3.5);
						self:queuecommand("GlowSweep");	
					end;
				else
					self:visible(false);
				end;
			end;

			GlowSweepCommand=function(self)				
			    self:cropright(1)
			    self:sleep(0.5)
			    self:diffusealpha(diffuseSprite);
			    self:linear(4)			    
			    self:cropright(0)
			    self:diffusealpha(0.1);
			    self:sleep(0.5)
			    self:linear(2);
			    self:diffusealpha(0);
			    self:queuecommand("GlowSweep")
			end;	
			GlowSweepP2Command=function(self)				
			    self:cropleft(1)
			    self:sleep(0.5)
			    self:diffusealpha(diffuseSprite);
			    self:linear(4)			    
			    self:cropleft(0)
			    self:diffusealpha(0.1);
			    self:sleep(0.5)
			    self:linear(2);
			    self:diffusealpha(0);
			    self:queuecommand("GlowSweepP2")
			end;	
			FinalizedMessageCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};	
	};
end;


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/frames/colorful/color_lens_light.png") )..{
	InitCommand=cmd(blend,'BlendMode_Add';zoom,0.445;x,SCREEN_WIDTH/2+7;y,SCREEN_TOP-20;spin;effectmagnitude,0,2,12);
}

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/back_conn"))..{
			OnCommand=cmd(zoom,zoomgeneralBottom;xy,SCREEN_CENTER_X,SCREEN_TOP+25;diffusealpha,0.7);
};

t[#t+1] = crearBaseColorful(PLAYER_1);
t[#t+1] = crearBaseColorful(PLAYER_2);



return t;