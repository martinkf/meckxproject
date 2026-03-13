local t = Def.ActorFrame {};


function createBaseProfileCustom(player)
	local xBase=0;
	local yBase=SCREEN_CENTER_Y;	
if player == PLAYER_1 then
	xBase = SCREEN_CENTER_X + 300;
else
	xBase = SCREEN_CENTER_X - 300;
end;




return Def.ActorFrame{



			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/base.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase);
					self:zoom(0.6);
				end;
			};

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/f1.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase);
					self:zoom(0.6);
				end;
			};			

			--cursor
			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/cursor_back.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase-160);
					self:zoom(0.5);
				end;
			};	
			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/cursor_a.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase-160);
					self:zoom(0.5);
				end;
			};				

			--BANNER
			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/banner_text_opt.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase-160);
					self:zoom(0.6);
				end;
			};		

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_banner_opt.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase-90);
					self:zoom(0.6);
				end;
			};	

			--BACKGROUND

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/background_text_opt.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase);
					self:zoom(0.6);
				end;
			};	

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase+50);
					self:zoom(0.6);
				end;
			};	

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/save_opt.png") )..{
				OnCommand=function(self)
					self:x(xBase);
					self:y(yBase+130);
					self:zoom(0.6);
				end;
			};	

};


end;

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);	
};

t[#t+1] = createBaseProfileCustom(PLAYER_1);
t[#t+1] = createBaseProfileCustom(PLAYER_2);


return t;