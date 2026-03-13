local t = Def.ActorFrame {};
--info
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
		local vActual = '0.1';
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
		self:settext("RHYTHMSANITY ALT- V"..vActual.."\nREV-09012025-00\nVSYNC: "..vsyncState.."\n"..tipoRes..gwidth.." X "..gheight);
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


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/logo2.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.55;);
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/logo2.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-20;x,SCREEN_CENTER_X;diffusealpha,0;zoom,0.55;blend,"BlendMode_Add";queuecommand,"ani");
	aniCommand=function(self)
		self:stoptweening();
		self:linear(2);
		self:diffusealpha(0.4);
		self:faderight(1);
		self:linear(4);
		self:fadeleft(1);
		self:faderight(0);
		self:diffusealpha(0);
		self:sleep(2);
		self:queuecommand("ani");

	end;
}


return t;