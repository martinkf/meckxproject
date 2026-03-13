
--No puedo sacar esta pantalla sin que el usuario caiga en "basicmode" no tengo idea porque :s, investigare xD -arka
local x = Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);
	};
	
};
return x;



