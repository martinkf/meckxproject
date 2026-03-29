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

--PERFORMANCE MODE

t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(Center);
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
	--	LoadActor(THEME:GetPathG("","LOGO/logo2"))..{
	--		InitCommand=cmd(zoom,.4;diffusealpha,1;y,-120;);
	--	};
		Def.Sprite {
			Name="VideoBackground",
			InitCommand=function(self)
				self:x(0)
			end,
			OnCommand=function(self)
				self:Load(THEME:GetPathG("","commonBackground/bbluesm.mp4"))
				self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
				self:play()
			end,
		};
		Def.ActorFrame{	--control de childs
			UpdateCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then

					local PreviewPath 	= GetPreviewVidOnly(song);
					local BannerPath 	= GetSongBannerPath(song);
					--self:accelerate(0.1*(0.6)):diffusealpha(1);		

					self:GetChild("gBanner"):stoptweening():Load(BannerPath):scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT);
					
					-- PERFORMANCE MODE --
					-- WHEN IS ACTIVE IN ANY PLAYER IT WILL NOT LOAD VIDEOS, ONLY IMAGES.
					local perfp1 = false;
					local perfp2 = false;

					if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
						perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
						perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");
					else
						if GAMESTATE:IsHumanPlayer(PLAYER_1) then
							perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
						elseif GAMESTATE:IsHumanPlayer(PLAYER_2) then
							perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");
						end;
					end;

					if perfp1 == nil then perfp1 = false; end;
					if perfp2 == nil then perfp2 = false; end;

					if perfp1 or perfp2 then
						PreviewPath["novideo"] = true;
					end;

					-- END PERFORMANCE MODE--

					if PreviewPath["novideo"] then
						self:GetChild("Preview"):visible(false):LoadBackground(THEME:GetPathG("","blackdot"));
					else
						self:GetChild("Preview"):stoptweening():visible(true):LoadBackground(PreviewPath["path"]);
						self:GetChild("Preview"):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):accelerate(0.4):diffusealpha(1);
					end;
					self:diffusealpha(1);
				end;
			end;
			InitCommand=cmd(playcommand,"Update");
			CurrentSongChangedMessageCommand=function(self)
				self:stoptweening():diffusealpha(0):sleep(0.38):queuecommand("Update");
			end;

			
			Def.Quad {		Name="Glow";	--cuadro gris
				InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("#333333FF"););
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};
			Def.Banner {	Name="gBanner";	--banner glow, da efecto al segundo marco
				InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;xy,0,0;blend,Blend.Add;diffusealpha,1/3;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};
			Def.Sprite{		Name="Preview";	--video preview
				InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;xy,0,0;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};
			
		};

		Def.ActorFrame{	
			--control de childs
			HideCommand=cmd(visible,false);
			SelectChannelMessageCommand=cmd(queuecommand,"channelEntry");				
			VisibleCommand=cmd(visible,true);
			ChannelChosenMessageCommand=cmd(stoptweening;queuecommand,"Visible");

			channelEntryCommand=function(self)
				--self:GetChild("nBanner"):stoptweening():Load(THEME:GetPathG("", "_blank.png"));
			end;

			UpdateCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					local bannerNewPath = GetBannerSong(song);
				end;
			end;
			InitCommand=cmd(playcommand,"Update");
			CurrentSongChangedMessageCommand=function(self)
				self:queuecommand("Update");
			end;
		};

	};

};


t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(Center;);

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/bg/back3"))..{
		Name="GrayGridThatEffectsTheVideoPreview";
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.8;);
		ChannelChosenMessageCommand=cmd(linear,0.3;fadetop,1);
		SelectChannelMessageCommand=cmd(fadetop,0);
	};
	--Def.Quad {
		-- maybe use this to cover the entirety of the profile banners?
		--Name="TopMeckxArt";
		--InitCommand=function(self)
			--self:y(-SCREEN_CENTER_Y+28)
			--self:zoomto(SCREEN_WIDTH,57)
			--self:diffuse(0,0,0,0.9);
		--end;
	--};
	Def.Quad {	
		Name="TopMeckxArt";
		InitCommand=function(self)
			self:y(-SCREEN_CENTER_Y+1)
			self:valign(0)
			self:zoomto(SCREEN_WIDTH-820,48)
			self:diffuse(0,0,0,0.75);
			self:fadeleft(0.2)
			self:faderight(0.2)
		end;
	};
	Def.Quad {
		Name="BottomMeckxArt";
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-12)
			self:zoomto(SCREEN_WIDTH,24)
			self:diffuse(0,0,0,0.75);
		end;
	};
};


-- COMMON BACKGROUND
--header.
t[#t+1] = Def.ActorFrame {


	LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
		SelectChannelMessageCommand=function(self)
			self:diffusealpha(1);
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;

	};


	LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;visible,false);
		OnCommand=function(self)
		end;

			SelectChannelMessageCommand=function(self)
				local performanceStatus = checkPerformanceModeState();
				if performanceStatus then
					self:stoptweening();
					self:visible(false);
					return;
				else
					self:visible(true);
					self:diffusealpha(0.4);
				end;
			end;

			ChannelChosenMessageCommand=function(self)
				self:stoptweening();
				self:visible(false);
				self:diffusealpha(0);
			end;	
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);		
	};	

	LoadActor( THEME:GetPathG("","commonBackground/bredsm.mp4") )..{
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;visible,false);
			AniCommand=function(self)
				self:linear(12);
				self:diffusealpha(0.4);
				self:linear(12);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;
			SelectChannelMessageCommand=function(self)

				local performanceStatus = checkPerformanceModeState();
				if performanceStatus then
					self:stoptweening();
					self:visible(false);
				else
					self:stoptweening();
					self:visible(true);
					self:queuecommand("Ani");
				end;

			end;

			ChannelChosenMessageCommand=function(self)
				self:stoptweening();
				self:visible(false);
				self:diffusealpha(0);
			end;			
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};	


	LoadActor("MainLogo/bg_matrix")..{
		OnCommand=cmd(diffusealpha,0);
		SelectChannelMessageCommand=function(self)
			self:diffusealpha(1);
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;

	};


	LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
		SelectChannelMessageCommand=function(self)
			self:diffusealpha(1);
		end;

		ChannelChosenMessageCommand=function(self)
			self:diffusealpha(0);
		end;
	};	


};



--FRAME
local frameSelected = "simple";
if frameSelected == nil then
	frameSelected = "simple";
end;
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/"..frameSelected.."/underlay"))..{
};


--FILTER STEP TYPE MESSAGE (only for 1 player, because with 2 players you can't pick double............. lol)
--if GAMESTATE:GetNumSidesJoined() == 1 then
	t[#t+1] = LoadActor("ScreenSelectMusicLua/filterMessages")..{};
--end;


-- Exit message.
if PREFSMAN:GetPreference("AllowUnjoinShortcut") then
	local langMsgExit = PREFSMAN:GetPreference('Language');
	local imgExitLang = langMsgExit.."_exit";

	t[#t+1] =  Def.ActorFrame
	{
		OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-250;;visible,false;zoom,0.7);

		SelectChannelMessageCommand=function(self)
			self:visible(true);
		end;
		ChannelChosenMessageCommand=function(self)
			self:visible(false);
		end;
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMessage/"..imgExitLang))..{
			InitCommand=cmd();
		};
	}
end;


--because why not
t[#t+1] = LoadActor("ScreenSelectMusicLua/channelMusicHelper")..{};


return t;