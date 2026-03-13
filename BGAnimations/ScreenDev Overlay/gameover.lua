local t = Def.ActorFrame {};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_bg") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,1;y,SCREEN_CENTER_Y-15;x,SCREEN_CENTER_X+15;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(linear,0;diffusealpha,0;sleep,1.8;decelerate,4;diffusealpha,0.3;y,SCREEN_CENTER_Y+5;x,SCREEN_CENTER_X-5;linear,2;diffusealpha,0);
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/txt_go1") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(linear,0.4;zoom,0.65;queuecommand,"reflej");
	--reflejos tanda 1
	reflejCommand=cmd(linear,0;diffusealpha,0;sleep,0.2;diffusealpha,1;queuecommand,"refleja");
	--reflejos tanda 2
	reflejaCommand=cmd(sleep,0.45;linear,0.4;y,SCREEN_CENTER_Y-12);	
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/txt_go2") )..{
	InitCommand=cmd(zoom,0.65;Center;diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,0);	
	OnCommand=cmd(diffusealpha,0;queuecommand,"reflej");
	--entrada reflejos 1
	reflejCommand=cmd(sleep,0.4;diffusealpha,1;sleep,0.05;diffusealpha,0;sleep,0.05;diffusealpha,1,sleep,0.05;diffusealpha,0);
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/txt_go3") )..{
	InitCommand=cmd(zoom,0.65;Center;diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,0);	
	OnCommand=cmd(queuecommand,"reflej");
	--entrada reflejos 1
	reflejCommand=cmd(sleep,0.45;diffusealpha,1;sleep,0.05;diffusealpha,0);
	--entrada reflejos 2
	reflejacommand=cmd();	
}


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/txt_thanks") )..{
	InitCommand=cmd(zoom,0.65;diffusealpha,1;y,SCREEN_CENTER_Y+25;x,SCREEN_CENTER_X;diffusealpha,0);
	OnCommand=cmd(queuecommand,"reflej");
	reflejCommand=cmd(sleep,1.4;linear,0.4;addy,10;diffusealpha,1);
}


--game Over

--Brillo game Over
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_ef_ball_blue") )..{
	InitCommand=cmd(zoom,0.8;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y-12;x,SCREEN_CENTER_X+56.5;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.2;linear,0.4;diffusealpha,0.7;sleep,2;accelerate,4;addx,-250;diffusealpha,0);
}
--[[
--gamE over
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_e") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y-12;x,SCREEN_CENTER_X-16.5;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.4;linear,0.1;diffusealpha,1;sleep,0.5;linear,2.5;diffusealpha,0);
}
]]
-- thanks for playinG
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_g") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X+173;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.6;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

-- thanks for plAying
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_a") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X+103;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.4;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

-- thanks fOr playing
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_b_o2") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X+17;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

-- Thanks for playing
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_t") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X-175;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.2;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

-- thanks You for playing
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_y") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X-70;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.3;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_b_o2") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X-53;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.3;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_u") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y+34;x,SCREEN_CENTER_X-36;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.3;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}


--brillos letras
--[[
--Game over
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_g_p") )..{
	InitCommand=cmd(zoom,0.65;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y-12;x,SCREEN_CENTER_X-202;queuecommand,"anima");	
	--entrada
		animaCommand=cmd(sleep,2;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}

--game Over
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_o2") )..{
	InitCommand=cmd(zoom,0.65;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y-12;x,SCREEN_CENTER_X+49;queuecommand,"anima");	
	--entrada
		animaCommand=cmd(draworder,1000;sleep,2.2;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}


--game oveR
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameOver/go_glow_r") )..{
	InitCommand=cmd(zoom,0.63;diffusealpha,0;blend,'BlendMode_Add';y,SCREEN_CENTER_Y-12;x,SCREEN_CENTER_X+208;queuecommand,"anima");	
	--entrada
	animaCommand=cmd(sleep,2.1;linear,0.1;diffusealpha,1;linear,2.5;diffusealpha,0);
}
]]

	--[[
	Def.Sound {
		OnCommand=cmd(queuecommand,"Lot");
		LotCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("","GAMEOVER"));
		end;
	};
	]]

return t;
