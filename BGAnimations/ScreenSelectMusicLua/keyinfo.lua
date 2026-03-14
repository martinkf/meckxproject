local t = Def.ActorFrame {}
local isAspectRatio1610On=isAspectRatio1610();

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/bottom_keys") )..{
		InitCommand=function(self)
			self:zoom(0.6);
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+347);
			self:fadetop(0.8);

			if isAspectRatio1610On then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-420);
			end;

		end;
}


--#######
--PROFILE
--P1
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		if GAMESTATE:IsSideJoined(PLAYER_1) then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;

	Def.ActorFrame{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X-538);
			self:y(ChangeProfile_Y);

			if isAspectRatio1610On then
				self:y(SCREEN_CENTER_Y-360);
			end;
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/f9"))..{
			Name="f10plugin";
			InitCommand=cmd(zoom,0.45;y,-21);
		};	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/bchange"))..{
			Name="f10plugin";
			InitCommand=cmd(zoom,0.4;y,8);
		};

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Username ~= '' then
				self:visible(false);	
			end;
		end;
	};

	Def.ActorFrame{

		OnCommand=function(self)
			self:x(SCREEN_CENTER_X-197);
			self:y(ProfileEditorText_Y);
			self:zoom(0.9);

			if isAspectRatio1610On then
				self:y(SCREEN_CENTER_Y-305);
			end;
		end;

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:diffusealpha(0.2);
			else
				self:diffusealpha(1);
			end;
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/f12"))..{
			Name="f12plugin";
			InitCommand=cmd(zoom,0.45;y,-21);
		};	

		LoadFont("_century gothic")..{
			OnCommand=cmd(y,-23;x,-78;settext,"PROFILE EDITOR";shadowcolor,color("0,0,0,1");shadowlength,2;zoom,0.75);

		};
	};

}

--P2
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		if GAMESTATE:IsSideJoined(PLAYER_2) then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X+530;y,SCREEN_CENTER_Y-320);

		OnCommand=function(self)
			self:x(SCREEN_CENTER_X+530);
			self:y(ChangeProfile_Y);

			if isAspectRatio1610On then
				self:y(SCREEN_CENTER_Y-360);
			end;
		end;


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/f10"))..{
			Name="f10plugin";
			InitCommand=cmd(zoom,0.45;y,-21);
		};	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/bchange"))..{
			Name="f10plugin";
			InitCommand=cmd(zoom,0.4;y,8);
		};	

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Username ~= '' then
				self:visible(false);	
			end;
		end;
	};

	Def.ActorFrame{
		--OnCommand=cmd(x,SCREEN_CENTER_X+187;y,SCREEN_CENTER_Y-268;zoom,0.9);

		OnCommand=function(self)
			self:x(SCREEN_CENTER_X+188);
			self:y(ProfileEditorText_Y);
			self:zoom(0.9);

			if isAspectRatio1610On then
				self:y(SCREEN_CENTER_Y-305);
			end;
		end;

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:diffusealpha(0.2);
			else
				self:diffusealpha(1);
			end;
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/f12"))..{
			Name="f12plugin";
			InitCommand=cmd(zoom,0.45;y,-21);
		};	

		LoadFont("_century gothic")..{
			OnCommand=cmd(y,-23;x,75;settext,"PROFILE EDITOR";shadowcolor,color("0,0,0,1");shadowlength,2;zoom,0.75);

		};
	};
}

--######
local yBaseForInfoKeys=FunctionKeysSearch_Y;
local yBaseForInfoKeys1610=SCREEN_CENTER_Y+387;

--f11 SEARCH
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X+400);
		self:y(yBaseForInfoKeys);

		if isAspectRatio1610On then
			self:y(yBaseForInfoKeys1610);
		end;

	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/kf11"))..{
		Name="f11";
		InitCommand=cmd(zoom,0.7);
	};	

	LoadFont("xolonium").. 
	{
		InitCommand=cmd(zoom,0.65);
		OnCommand=function(self)
	        self:wrapwidthpixels(420)  -- Limita el ancho en píxeles donde el texto se ajustará automáticamente.
	        self:maxheight(100)        -- Establece el máximo espacio vertical que puede ocupar el texto.
	        self:vertspacing(-2)       -- Ajusta el espacio entre líneas (opcional).	
	        self:addx(75);
	        self:settext(getMiscText("F11"));

	        if PREFSMAN:GetPreference('Language') == "es" then
	        	self:addx(10);
	        elseif PREFSMAN:GetPreference('Language') == "pt" then
	        	self:addx(6);
	        end;

		end;
	};

};

t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X+190);
		self:y(yBaseForInfoKeys);

		if isAspectRatio1610On then
			self:y(yBaseForInfoKeys1610);
		end;

	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/kf7"))..{
		Name="f7";
		InitCommand=cmd(zoom,0.7);
	};	

	LoadFont("xolonium").. 
	{
		InitCommand=cmd(zoom,0.65);
		OnCommand=function(self)
	        self:wrapwidthpixels(420)  -- Limita el ancho en píxeles donde el texto se ajustará automáticamente.
	        self:maxheight(100)        -- Establece el máximo espacio vertical que puede ocupar el texto.
	        self:vertspacing(-2)       -- Ajusta el espacio entre líneas (opcional).
	        self:horizalign("left");
	        self:addx(20);
	        self:settext(getMiscText("F7"));

			if PREFSMAN:GetPreference('Language') == "pt" then
	        	self:zoom(0.62);
	        end;

		end;
	};

};

return t;