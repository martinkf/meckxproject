local t = Def.ActorFrame {};
local initTimeStart = 60;
--info


local function generarEstrellaBoom(sleepStart,sleepWait,xInit,yInit)
	return Def.ActorFrame{

		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star2.png") )..{
			InitCommand=cmd(zoom,0.1;diffusealpha,0;y,yInit;x,xInit);	
			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");				
			end;
			AniSecCommand=function(self)
				self:zoom(0.1);
				self:diffusealpha(0);				

				self:sleep(1.3); --1.3
				self:zoom(0.1);
				self:diffusealpha(1);
				self:linear(0.21); --1.51
				self:zoom(0.35);
				self:linear(0.7); -- 2.21
				self:zoom(0.4);
				self:linear(0);
				self:diffusealpha(0);
				self:sleep(0.05); -- 2.26
				self:diffusealpha(1);
				self:sleep(0.05); -- 2.31
				self:diffusealpha(0); 
				self:sleep(0.05); -- 2.36
				self:diffusealpha(1);
				self:sleep(0.05); -- 2.41
				self:diffusealpha(0);
				self:sleep(0.59); -- 3 segundos animación

				self:sleep(sleepWait);
				self:queuecommand("AniSec");
			end;
		};

		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star2.png") )..{
			InitCommand=cmd(zoom,0.12;diffusealpha,0;y,yInit+1;x,xInit+5;rotationz,20);	
			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");				
			end;

			AniSecCommand=function(self)
				self:zoom(0.12);
				self:diffusealpha(0);	
				self:x(xInit+5);
				self:y(yInit+1);
				self:rotationz(20);

				self:sleep(1.3);   --1.3
				self:diffusealpha(1);
				self:rotationz(20);
				self:zoom(0.13);
				self:sleep(0.05);  -- 1.35
				self:linear(0.3);  -- 1.65
				self:zoom(0.35);
				self:linear(0.5);  -- 2.15
				self:zoom(0.45);
				self:linear(0);
				self:diffusealpha(0);
				self:sleep(0.05); -- 2.2
				self:diffusealpha(1);
				self:sleep(0.05); -- 2.25
				self:diffusealpha(0);
				self:sleep(0.05); -- 2.3
				self:diffusealpha(1);
				self:sleep(0.05); -- 2.35
				self:diffusealpha(0);
				self:sleep(0.65); -- 3 segundos animación

				self:sleep(sleepWait);
				self:queuecommand("AniSec");							
			end;
		};		


		--estrella principal
		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star0.png") )..{
			InitCommand=cmd(zoom,0.35;diffusealpha,0;y,yInit;x,xInit;rotationz,325);	
			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");
			end;

			AniSecCommand=function(self)
				self:rotationz(325);
				self:zoom(0.35);
				self:diffusealpha(1);
				self:accelerate(0.1); -- 0.1
				self:rotationz(335);
				self:zoom(0.4);
				self:decelerate(0.3); -- 0.4
				self:zoom(0.35);
				self:rotationz(380);
				self:linear(0.95); -- 1.15 
				self:zoom(0.4);
				self:rotationz(400);
				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(1.65); -- 3 segundos de animación.

				self:sleep(sleepWait); -- 
				self:queuecommand("AniSec");
			end;
		};

		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star3a.png") )..{
			InitCommand=cmd(zoom,0.3;diffusealpha,0;y,yInit-25;x,xInit-25;diffusealpha,0;rotationz,345);

			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");
			end;


			AniSecCommand=function(self)
				self:zoom(0.3);
				self:y(yInit-25);
				self:x(xInit-25);
				self:rotationz(345);

				self:sleep(0.1);     -- 0.1
				self:diffusealpha(1);
				self:linear(0.2);   -- 0.3
				self:rotationz(355);
				self:addx(-25);
				self:addy(-15);
				self:zoom(0.55);

				self:linear(0.5);   -- 0.8
				self:rotationz(365);
				self:addx(-5);
				self:addy(-5);

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 0.82
				self:diffusealpha(1);

				self:linear(0.1); -- 0.92
				self:rotationz(368); 
				self:addx(-2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 0.94
				self:diffusealpha(1);

				self:linear(0.2); -- 1.14
				self:rotationz(372);
				self:addx(-2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 1.16
				self:diffusealpha(1);

				self:linear(0.2); -- 1.36
				self:rotationz(376);
				self:addx(-2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(1.64); -- 3 segundos de animación.

				self:sleep(sleepWait);
				self:queuecommand("AniSec");								
			end;
		};



		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star3a.png") )..{
			InitCommand=cmd(zoom,0.3;diffusealpha,1;y,yInit+25;x,xInit;diffusealpha,0;rotationz,345);	

			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");
			end;

			AniSecCommand=function(self)
				self:zoom(0.3);
				self:y(yInit+25);
				self:x(xInit);
				self:rotationz(345);

				self:sleep(0.1);     --0.1
				self:diffusealpha(1);
				self:linear(0.2);    -- 0.3
				self:rotationz(355);
				self:addx(-25);
				self:addy(15);
				self:zoom(0.55);

				self:linear(0.5);   -- 0.8
				self:rotationz(365);
				self:addx(-5);
				self:addy(5);

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02);   -- 0.82
				self:diffusealpha(1);

				self:linear(0.1);  -- 0.92
				self:rotationz(368);
				self:addx(-2);
				self:addy(2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 0.94
				self:diffusealpha(1);

				self:linear(0.2); -- 1.14
				self:rotationz(372);
				self:addx(-2);
				self:addy(2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); --1.16
				self:diffusealpha(1);

				self:linear(0.2); -- 1.36
				self:rotationz(376);
				self:addx(-2);
				self:addy(2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(1.64); -- 3 segundos de animación.

				self:sleep(sleepWait);
				self:queuecommand("AniSec");	
			end;
		};		


		LoadActor( THEME:GetPathG("","LOGO/nlogo3/effect_star3a.png") )..{
			InitCommand=cmd(zoom,0.3;diffusealpha,1;y,yInit;x,xInit+25;diffusealpha,0;rotationz,345);

			OnCommand=function(self)
				self:sleep(sleepStart);
				self:queuecommand("AniSec");
			end;

			AniSecCommand=function(self)
				self:zoom(0.3);
				self:y(yInit);
				self:x(xInit+25);
				self:rotationz(345);

				self:sleep(0.1);    --0.1
				self:diffusealpha(1);
				self:linear(0.2);  --0.3
				self:rotationz(355);
				self:addx(25);
				self:addy(-15);
				self:zoom(0.55);

				self:linear(0.5); -- 0.8
				self:rotationz(365);
				self:addx(5);
				self:addy(-5);

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 0.82
				self:diffusealpha(1);

				self:linear(0.1); -- 0.92
				self:rotationz(368);
				self:addx(2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 0.94
				self:diffusealpha(1);

				self:linear(0.2); -- 1.14
				self:rotationz(372);
				self:addx(2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(0.02); -- 1.16
				self:diffusealpha(1);

				self:linear(0.2); -- 1.36
				self:rotationz(376);
				self:addx(2);
				self:addy(-2);	

				self:sleep(0);
				self:diffusealpha(0);
				self:sleep(1.64); -- 3 segundos de animación.

				self:sleep(sleepWait);
				self:queuecommand("AniSec");	
			end;
		};	





	};

end;



t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/logo_base_clear.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0.5;diffusealpha,1;zoom,0.55;);
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/logo.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0.5;diffusealpha,1;zoom,0.55;);
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/nbaseglow_2.png") )..{
	InitCommand=cmd(diffusealpha,0;draworder,19;zoom,0.54;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,1.1;diffusealpha,0.2;queuecommand,"Animate");
	AnimateCommand=function(self)		

	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/back_glow_base.png") )..{
	InitCommand=cmd(diffusealpha,0;draworder,19;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,1;diffusealpha,0.65;zoom,0.55;queuecommand,"Animate");
	AnimateCommand=function(self)	

	end;
}



t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/sanita_glow.png") )..{
	InitCommand=cmd(draworder,20;diffusealpha,0;y,SCREEN_CENTER_Y-30;x,SCREEN_CENTER_X-403;sleep,0.3;zoom,0.235;queuecommand,"Animate";blend,"BlendMode_Add");
	AnimateCommand=function(self)
		self:sleep(2);		
		self:diffusecolor(color("#ff0081"));
		self:accelerate(4);
		self:diffusealpha(0.9);
		self:decelerate(4);
		self:diffusealpha(0);
		self:queuecommand("Animate");
	end;
}

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:sleep(0.95);
			self:accelerate(0.05);
			self:diffusealpha(0);
		end;		
};

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,1;diffusealpha,0;blend,"BlendMode_Add";queuecommand,"Animate");
		AnimateCommand=function(self)
			self:sleep(0.95);
			self:accelerate(0.05);
			self:diffusealpha(1);
			self:accelerate(0.5);
			self:diffusealpha(0);
		end;
};





t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,1;diffusealpha,1;blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)		
		self:cropright(1);
		self:sleep(0.1);
		self:linear(0.2);
		self:diffusealpha(0);
		self:cropright(0);
		
	end;
};

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/glow_init.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,0.5;zoom,1;blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(0.1);
		self:linear(0.2);
		self:diffusealpha(0.1);
		self:linear(0.2);
		self:cropright(0);
		self:diffusealpha(0);
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/logo_base_clear.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.55;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(0.8);
		self:linear(0.1);
		self:cropright(0);
		self:linear(0.1);
		self:diffusealpha(0);
	end;
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/x_intro.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-30;x,SCREEN_CENTER_X;diffusealpha,0;zoom,0.55;blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)
		self:sleep(0.2);
		self:linear(0.1);
		for i=0,4 do
			self:diffusealpha(1);
			self:linear(0.018);
			self:diffusealpha(0);
			self:linear(0.013);
			self:diffusealpha(1);
			self:linear(0.01);
			self:diffusealpha(0);
			self:linear(0.008);
			self:diffusealpha(1);
			self:linear(0.03);
		end;
		self:linear(0.1);
		self:x(SCREEN_CENTER_X-340);
		self:linear(0.1);
		self:diffusealpha(0);
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/x_intro.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-30;x,SCREEN_CENTER_X;diffusealpha,0;zoom,0.55;blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)
		self:sleep(0.2);
		self:linear(0.1);
		for i=0,4 do
			self:diffusealpha(1);
			self:linear(0.018);
			self:diffusealpha(0);
			self:linear(0.013);
			self:diffusealpha(1);
			self:linear(0.01);
			self:diffusealpha(0);
			self:linear(0.008);
			self:diffusealpha(1);
			self:linear(0.03);
		end;
		self:linear(0.1);
		self:x(SCREEN_CENTER_X-340);
		self:linear(0.1);
		self:diffusealpha(0);
	end;
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/nlogo_bw.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0.3;diffusealpha,0;zoom,0.55;diffusecolor,color("#ffffff");blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)
		self:sleep(6);
		self:accelerate(1);
		self:diffusealpha(0.2);
		self:fadeleft(0);
		self:accelerate(2);
		self:fadeleft(10);	
		self:decelerate(3);
		self:diffusealpha(0);	
		self:queuecommand("Animate");
	end;
}


t[#t+1] = generarEstrellaBoom(2.4,5.2,SCREEN_CENTER_X-165,SCREEN_CENTER_Y-180)..{
	InitCommand=function(self)	

	end;
};


t[#t+1] = generarEstrellaBoom(1.2,6.9,SCREEN_CENTER_X-410,SCREEN_CENTER_Y-120)..{
	InitCommand=function(self)		
		self:zoom(0.8);
	end;
};

t[#t+1] = generarEstrellaBoom(3,7,SCREEN_CENTER_X+710,SCREEN_CENTER_Y+200)..{
	InitCommand=function(self)		
		self:zoom(0.5);
	end;
};


t[#t+1] = generarEstrellaBoom(2.7,6.8,SCREEN_CENTER_X-300,SCREEN_CENTER_Y+210)..{
	InitCommand=function(self)		
		self:zoom(0.65);
	end;
};

t[#t+1] = generarEstrellaBoom(1.8,4.2,SCREEN_CENTER_X+480,SCREEN_CENTER_Y-210)..{
	InitCommand=function(self)		
	end;
};


t[#t+1] = generarEstrellaBoom(1.8,9.5,SCREEN_CENTER_X+340,SCREEN_CENTER_Y+140)..{
	InitCommand=function(self)		
	end;
};


t[#t+1] = LoadFont("xolonium 20px")..{
	InitCommand=function(self)
		self:x(14);
		self:y(SCREEN_TOP + 110);
        local vsyncEnabled = PREFSMAN:GetPreference("Vsync");
        local vsyncState = vsyncEnabled and "ON" or "OFF";
        local visualDelay = PREFSMAN:GetPreference("VisualDelaySeconds");
		local visualDelayTruncated = string.format("%.3f", visualDelay);
		local gwidth = PREFSMAN:GetPreference("DisplayWidth");
		local gheight = PREFSMAN:GetPreference("DisplayHeight");
		local vActual = themeVersionData();
		local tipoRes = "SD ";
		if gwidth == 1280 and gheight == 720 then
			tipoRes = "HD "
		end;

		if gwidth == 1920 and gheight == 1080 then
			tipoRes = "FHD "
		end;

		if gwidth == 2048 and gheight == 1080 then
			tipoRes = "2K "
		end;

		if gwidth == 3840 and gheight == 2160 then
			tipoRes = "4K "
		end;		

		self:vertspacing(5);
		--self:settext("PIUMOD - V"..vActual.."\nREV-01112024-00-ARKA\nVSYNC: "..vsyncState.."\n"..tipoRes..gwidth.." X "..gheight.."\nVISUAL DELAY: "..visualDelayTruncated);
		self:settext(vActual.."\nVSYNC: "..vsyncState.."\n"..tipoRes..gwidth.." X "..gheight);
		--self:skewx(-.12);
		self:horizalign("HorizAlign_Left");
		self:zoom(.65);
		self:shadowlength(0.8)  -- Define la longitud de la sombra
        self:shadowcolor(color("0,0,0,1"))  -- Color negro para la sombra
	end;
	OffCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(.5);	-- para que cualquier entrada no interrumpa la transici�n de ventanas
		(cmd(visible,false))(self);
	end;
}

--
-- AUDIO INTRO
--
--[[
t[#t+1] = LoadActor(THEME:GetPathS("","xsanity/intro_ver_a.mp3"))..{
	InitCommand=cmd();
	OnCommand=function(self)
		self:play();
	end;
};
]]


return t;