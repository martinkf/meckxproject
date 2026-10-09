local t = Def.ActorFrame {}
local isAspectRatio1610On=isAspectRatio1610();
local isAspect43On=isAspectRatio43();

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/bottom_keys") )..{
		InitCommand=function(self)
			self:zoom(0.6);
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+347);
			self:fadetop(0.8);

			if isAspectRatio1610On then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-420);
			end;

			if isAspect43On then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+472);
			end;

		end;
}


--#######
--PROFILE
--P1
if GAMESTATE:IsSideJoined(PLAYER_1) then
	local profileSkinData = getProfileSkinPlayer(PLAYER_1);

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
				self:y(SCREEN_CENTER_Y-320);

				if isAspectRatio1610On then
					self:y(SCREEN_CENTER_Y-360);
				end;

				if isAspect43On then
					self:y(SCREEN_CENTER_Y-438);
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
				self:x(SCREEN_CENTER_X-196);
				self:y(SCREEN_CENTER_Y-268);
				self:zoom(0.9);
				if profileSkinData["isDefault"] == false then
					self:x(SCREEN_CENTER_X-538);
					self:y(SCREEN_CENTER_Y-260);

					if isAspectRatio1610On then
						self:y(SCREEN_CENTER_Y-300);
					end;

					if isAspect43On then
						self:y(SCREEN_CENTER_Y-380);
					end;
				else
					if isAspectRatio1610On then
						self:y(SCREEN_CENTER_Y-305);
					end;

					if isAspect43On then
						self:y(SCREEN_CENTER_Y-386);
					end;
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
				OnCommand=cmd(y,-23;x,-78;settext,"PROFILE EDITOR";shadowcolor,color("0,0,0,1");shadowlength,2;zoom,0.75;queuecommand,"set");
				setCommand=function(self)
						local profileSkinData = getProfileSkinPlayer(PLAYER_1);			
						if profileSkinData["isDefault"] == false then
							self:zoom(0.56);
							self:x(-62);
						end;
				end;
			};
		};

	}
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
local profileSkinData = getProfileSkinPlayer(PLAYER_2);		
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
				self:x(SCREEN_CENTER_X+538);
				self:y(SCREEN_CENTER_Y-320);

				if isAspectRatio1610On then
					self:y(SCREEN_CENTER_Y-360);
				end;

				if isAspect43On then
					self:y(SCREEN_CENTER_Y-438);
				end;

			end;


			LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/f10"))..{
				Name="f10plugin";
				InitCommand=cmd(zoom,0.45;y,-21);
			};	
			LoadActor(THEME:GetPathG("","ScreenSelectMusic/keys/bchange"))..{
				Name="f10plugin";
				InitCommand=cmd(zoom,0.4;y,8;rotationy,180);
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
				self:y(SCREEN_CENTER_Y-268);
				self:zoom(0.9);

					
				if profileSkinData["isDefault"] == false then
					self:x(SCREEN_CENTER_X+538);

					if isAspectRatio1610On then
						self:y(SCREEN_CENTER_Y-300);
					end;

					if isAspect43On then
						self:y(SCREEN_CENTER_Y-380);
					end;
				else
					if isAspectRatio1610On then
						self:y(SCREEN_CENTER_Y-305);
					end;

					if isAspect43On then
						self:y(SCREEN_CENTER_Y-386);
					end;
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
				OnCommand=cmd(y,-23;x,75;settext,"PROFILE EDITOR";shadowcolor,color("0,0,0,1");shadowlength,2;zoom,0.75;queuecommand,"set");
				setCommand=function(self)
						local profileSkinData = getProfileSkinPlayer(PLAYER_2);			
						if profileSkinData["isDefault"] == false then
							self:zoom(0.56);
							self:x(62);
						end;
				end;

			};
		};
	}
end;

--######
local yBaseForInfoKeys=SCREEN_CENTER_Y+347;
local yBaseForInfoKeys1610=SCREEN_CENTER_Y+387;
local yBaseForInfoKeys43=SCREEN_CENTER_Y+465;

--f11 SEARCH
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X+400);
		self:y(yBaseForInfoKeys);

		if isAspectRatio1610On then
			self:y(yBaseForInfoKeys1610);
		end;

		if isAspect43On then
			self:y(yBaseForInfoKeys43);
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
	        elseif PREFSMAN:GetPreference('Language') == "ko" then
	        	self:x(42);
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

		if isAspect43On then
			self:y(yBaseForInfoKeys43);
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


t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X-200);
		self:y(yBaseForInfoKeys);

		if isAspectRatio1610On then
			self:y(yBaseForInfoKeys1610);
		end;

		if isAspect43On then
			self:y(yBaseForInfoKeys43);
		end;

		self:queuecommand("CheckStatusForKey");

		if PREFSMAN:GetPreference('Language') == "es" then
			self:x(SCREEN_CENTER_X-180);
		end;

	end;

	SelectChannelMessageCommand=function(self)
		self:visible(false);
	end;
	ChannelChosenMessageCommand=function(self)
		self:queuecommand("CheckStatusForKey");
	end;

	CheckStatusForKeyCommand=function(self)
		local getChannelName = GAMESTATE:GetChannelName();
		if GAMESTATE:GetFilterTwo() ~= "FilterTwo_Channel" or getChannelName == "ALLTUNES" then 
			self:visible(false);
		else
			self:visible(true);
		end;		
	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/krctrl"))..{
		Name="rctrl";
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
	        self:x(-185);
	        self:settext(getMiscText("RCTRL"));

			if PREFSMAN:GetPreference('Language') == "pt" then
	        	self:x(-177);
	        elseif PREFSMAN:GetPreference('Language') == "en" then
	        	self:x(-142);
	        elseif PREFSMAN:GetPreference('Language') == "ko" then
	        	self:x(-78);
	        end;

		end;
	};

};

--[[
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X-380);
		self:y(yBaseForInfoKeys);

		if isAspectRatio1610On then
			self:y(yBaseForInfoKeys1610);
		end;
		
		if isAspect43On then
			self:y(yBaseForInfoKeys43);
		end;

		self:queuecommand("CheckStatusForKey");

		if PREFSMAN:GetPreference('Language') == "es" then
			self:x(SCREEN_CENTER_X-400);
		end;

		if PREFSMAN:GetPreference('Language') == "pt" then
			self:x(SCREEN_CENTER_X-405);
		end;

	end;

	CheckStatusForKeyCommand=function(self)
		if GAMESTATE:IsEventMode() == false then
			self:visible(false);
		end;		
	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/kf5"))..{
		Name="kf5";
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
	        self:x(-155);
	        self:settext(getMiscText("F5"));
		end;
	};

};
]]

return t;