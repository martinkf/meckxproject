local function GetSongBannerPath(song)
    if not song then
        return THEME:GetPathG("", "_blank.png");
    end;

	local backgroundPath = 	song:GetBackgroundPath()
	 
    -- Fallback to song's preview video or background
	if backgroundPath and FILEMAN:DoesFileExist(backgroundPath) then
        return backgroundPath
    end

    -- Fallback to theme defaults
    return PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview")
end

local function GetBannerSong(song)		
	local dataBannerSong = {generic=0,bpath=""};
	if (song ~= nil) then
		local sbackground = song:GetBannerPath();
		--local sbackground = song:GetBackgroundPath();
		if (sbackground ~= nil) then
			if FILEMAN:DoesFileExist( sbackground ) then
				--self:LoadFromCachedBanner( sbackground );
				dataBannerSong["generic"]=0;
				dataBannerSong["bpath"]=sbackground;
				return dataBannerSong;
			else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
			end;
		else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
		end;	
	end;	

    if not song then
		dataBannerSong["generic"]=1;
		dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
		return dataBannerSong;					
    end;
end

local function GetPreviewVidOnly(song)
    local respData = {path="",novideo=true};

    if not song then
    	respData["path"] = THEME:GetPathG("", "_blank.png");
        return respData;
    end;

    local previewPath = 	song:GetPreviewVidPath()
    local sPrevFolder = "/Previews_HD/";


	if previewPath and #previewPath > 1 then
        local customPath = sPrevFolder .. previewPath
        if FILEMAN:DoesFileExist(customPath) then
        	respData["path"] = customPath;
        	respData["novideo"] = false;
            return respData;
        end
   end;

    -- Fallback to song's preview video or background
    if song:HasPreviewVid() and FILEMAN:DoesFileExist(previewPath) then
		if ActorUtil.GetFileType(previewPath) == "FileType_Movie" then
			respData["path"] = previewPath;
			respData["novideo"] = false;
			return respData;
		else
			--return THEME:GetPathG("", "_blank.png");
			respData["path"] = "";
			return respData;			
		end;
    end
    -- Fallback to theme defaults

    respData["path"] = PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "_blank.png")
    return respData;
end



local t = Def.ActorFrame { };

t[#t+1] =  Def.ActorFrame{ -- general grey background video
	InitCommand=cmd(Center;);
	LoadActor( THEME:GetPathG("","commonBackground/bbluetogreysm") )..{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;xy,0,0;);
	};
};
t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(Center;visible,false;);
	VisibleCommand=cmd(visible,true);
	HideCommand=cmd(visible,false);
	SelectChannelMessageCommand=cmd(queuecommand,"Hide");
	ChannelChosenMessageCommand=cmd(stoptweening;queuecommand,"Visible");
	OffCommand=cmd(stoptweening;sleep,.15;easeinquad,.3;diffusealpha,0;queuecommand,"Hide");
	FinalizedMessageCommand=function(self)
		self:stoptweening();
		self:linear(0.15);
		self:diffusealpha(0);
	end;	
	
	Def.ActorFrame{		--Banner & PrevVid
		OnCommand=cmd(diffusealpha,0;accelerate,.15;diffusealpha,1;);
		OffCommand=cmd(stoptweening;sleep,.1;accelerate,.25;diffusealpha,0;);

		Def.ActorFrame{	--control de childs
			UpdateCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then

					local PreviewPath 	= GetPreviewVidOnly(song);
					local BannerPath 	= GetSongBannerPath(song);
					
					-- PERFORMANCE MODE--
					local performanceType = getPerformanceModeType();
					if performanceType >= 2 then
						PreviewPath["novideo"] = true;
					end;
					-- END PERFORMANCE MODE--

					if PreviewPath["novideo"] then
						self:GetChild("nBanner"):stoptweening():diffusealpha(1):Load(BannerPath):scaletoclipped(SCREEN_WIDTH/4,SCREEN_HEIGHT/4);
						self:GetChild("Preview"):visible(false):LoadBackground(THEME:GetPathG("","blackdot"));
					else
						self:GetChild("Preview"):stoptweening():visible(true):LoadBackground(PreviewPath["path"]);
						self:GetChild("Preview"):zoomto(SCREEN_WIDTH/4,SCREEN_HEIGHT/4):diffusealpha(0):linear(1):diffusealpha(1);
						self:GetChild("nBanner"):stoptweening():diffusealpha(0);
					end;

					self:diffusealpha(1);
				end;
			end;
			
			InitCommand=function(self)
				local performanceType = getPerformanceModeType();
				if performanceType >= 2 then
					self:stoptweening():queuecommand("Update");
				else
					self:stoptweening():diffusealpha(0):sleep(0.38):queuecommand("Update");
				end;
			end;

			CurrentSongChangedMessageCommand=function(self)
				local performanceType = getPerformanceModeType();
				if performanceType >= 2 then
					self:stoptweening():queuecommand("Update");
				else
					self:stoptweening():diffusealpha(0):sleep(0.38):queuecommand("Update");
				end;
			end;

			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

			Def.Sprite{		Name="Preview";	--video preview
				InitCommand=cmd(setsize,SCREEN_WIDTH/4,SCREEN_HEIGHT/4;xy,0,0;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};

			Def.Banner {	Name="nBanner";	--banner standard,
				InitCommand=cmd(setsize,SCREEN_WIDTH/4,SCREEN_HEIGHT/4;xy,0,0;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};
		};
	};
};



t[#t+1] =  Def.ActorFrame{ --this is a "screen filter" you add to the BGA_P when it's a background BGA_P in order to smoothen it to the eyes
	InitCommand=cmd(Center;visible,false;);
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH/4,SCREEN_HEIGHT/4;y,SCREEN_CENTER_Y-(SCREEN_HEIGHT/2);fadetop,.42;diffuse,color("#33333399"););
		ChannelChosenMessageCommand=cmd(visible,true);
		SelectChannelMessageCommand=cmd(visible,false);
	};
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/bg/back3"))..{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/4,SCREEN_HEIGHT/4;fadetop,1;diffusealpha,0.8;);
		ChannelChosenMessageCommand=cmd(linear,0.3;fadetop,1);
		SelectChannelMessageCommand=cmd(fadetop,0);
	};
};



--meckx temp - these are all temp quads for future formatting purposes and will be removed eventually
t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,40,SCREEN_HEIGHT;xy,SCREEN_LEFT,SCREEN_TOP;diffuse,color("#550000");valign,0;halign,0;diffusealpha,0.95;);
};
t[#t+1] = LoadFont("_TitleXolonium")..{
	Text="TEMP ALL SONGS";
	InitCommand=cmd(xy,SCREEN_LEFT+20,SCREEN_CENTER_Y;zoom,0.66;maxwidth,480;rotationz,270;);
};
t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,40,SCREEN_HEIGHT;xy,SCREEN_LEFT+40,SCREEN_TOP;diffuse,color("#000055");valign,0;halign,0;diffusealpha,0.95;);
};
t[#t+1] = LoadFont("_TitleXolonium")..{
	Text="TEMP ALL CHARTS";
	InitCommand=cmd(xy,SCREEN_LEFT+40+20,SCREEN_CENTER_Y;zoom,0.66;maxwidth,480;rotationz,270;);
};
t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,SCREEN_WIDTH-80,SCREEN_HEIGHT;xy,SCREEN_LEFT+40+40,SCREEN_TOP;diffuse,color("#550000");valign,0;halign,0;diffusealpha,0;);
	SongChosenMessageCommand=function(self)
		self:stoptweening();
		self:decelerate(0.5);
		self:zoomto(330,SCREEN_HEIGHT);
		self:diffusealpha(0.95);
	end;
	SongUnchosenMessageCommand=function(self)
		self:stoptweening();
		self:decelerate(0.25);
		self:zoomto(SCREEN_WIDTH-80,SCREEN_HEIGHT);
		self:diffusealpha(0);
	end;
};


t[#t+1] = Def.Quad {
	InitCommand=cmd(zoomto,SCREEN_WIDTH,26;xy,SCREEN_CENTER_X,SCREEN_TOP;diffuse,color("#000011");valign,0);
};



t[#t+1] = Def.Quad {		
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
		self:diffuse(color("#ffffff"));
		self:diffusealpha(1);
		self:decelerate(1);
		self:diffusealpha(0);
	end;
};

--CHECK IF IS SELECTED A CUSTOM FRAME SKIN
local luaFrameSkinSelected = getFrameSkinForPlayers("underlay","ScreenSelectMusic");
if luaFrameSkinSelected["isDefault"] then
	-- COMMON BACKGROUND
	--header.

	local backgroundActor = Def.ActorFrame{};
	backgroundActor[#backgroundActor+1] =  LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
			OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X ;y,SCREEN_CENTER_Y;diffusealpha,0);
			SelectChannelMessageCommand=function(self)
				self:diffusealpha(1);
			end;

			ChannelChosenMessageCommand=function(self)
				self:diffusealpha(0);
			end;

	};

	backgroundActor[#backgroundActor+1] = LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;visible,false);
		OnCommand=function(self)
		end;

			SelectChannelMessageCommand=function(self)
				if getPerformanceModeType() == 0 then
					self:visible(true);
					self:diffusealpha(0.4);
				else
					self:stoptweening();
					self:visible(false);
				end;

			end;

			ChannelChosenMessageCommand=function(self)
				self:stoptweening();
				self:visible(false);
				self:diffusealpha(0);
			end;	
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);		
	};

	backgroundActor[#backgroundActor+1] = LoadActor( THEME:GetPathG("","commonBackground/bredsm.mp4") )..{		
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;visible,false);
			AniCommand=function(self)
				self:linear(12);
				self:diffusealpha(0.4);
				self:linear(12);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;
			SelectChannelMessageCommand=function(self)

				if getPerformanceModeType() == 0 then
					self:stoptweening();
					self:visible(true);
					self:queuecommand("Ani");
				else
					self:stoptweening();
					self:visible(false);
				end;

			end;

			ChannelChosenMessageCommand=function(self)
				self:stoptweening();
				self:visible(false);
				self:diffusealpha(0);
			end;			
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};

--[[
if getPerformanceModeType() == 0 then

	backgroundActor[#backgroundActor+1] = LoadActor("MainLogo/bg_matrix")..{
		OnCommand=cmd(diffusealpha,0);
		SelectChannelMessageCommand=function(self)

			if getPerformanceModeType() == 0 then
				self:visible(true);
				--self:hibernate(0);
				self:diffusealpha(1);
			else
				self:stoptweening();
				self:visible(false);
				self:diffusealpha(0);
				--self:hibernate(math.huge);
			end;
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;

	};

end;
]]
	backgroundActor[#backgroundActor+1] = LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=function(self)
			self:zoom(0.8);
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);
			self:diffusealpha(0);

			if isAspectRatio43() then
				self:zoom(1.1);
			end;
		end;

		SelectChannelMessageCommand=function(self)
			self:diffusealpha(1);
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;
	};

	t[#t+1] = backgroundActor;

end;

if luaFrameSkinSelected["isDefault"] then
	local frameSelected = "simple";
	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/"..frameSelected.."/underlay"))..{
	};
else
	local frameSkinFunc = LoadActor(luaFrameSkinSelected["lua"]);
	t[#t+1] = frameSkinFunc(luaFrameSkinSelected["path"]);
end;









return t;