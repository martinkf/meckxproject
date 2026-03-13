local t = Def.ActorFrame {};
local initTimeStart =0;
--info



t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/logo_base_clear.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0;diffusealpha,1;zoom,0.5;);
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/logo.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0;diffusealpha,1;zoom,0.5;);
}



t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/sanita_glow.png") )..{
	InitCommand=cmd(draworder,20;diffusealpha,0;y,SCREEN_CENTER_Y-30;x,SCREEN_CENTER_X-403;sleep,0.3;zoom,0.185;queuecommand,"Animate";blend,"BlendMode_Add");
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





t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo3/nlogo_bw.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;sleep,0.3;diffusealpha,0;zoom,0.5;diffusecolor,color("#ffffff");blend,"BlendMode_Add";queuecommand,"Animate");
	AnimateCommand=function(self)
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


return t;