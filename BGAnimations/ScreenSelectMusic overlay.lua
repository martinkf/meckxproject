--[[
	#PARTS SHORTCUT
	0 - FRAME / OVERLAY 
	0 - THEME PARTS
	0 - VS
	1 - ARROWS WHEEL < >
	2 - NAV ARROWS
	3 - SONG INFO W/ DECORATION
	4 - MISSION QUEST
	5 - SURVIVAL
	6 - FULL INTERFACE
	7 - BASIC INTERFACE
	8 - ANIMATION INTERFACE	- RANKING
	9 - CHECK ASPECT RATIO
	10 - PROFILE SELECTOR
	11 - PROFILE PLAYER
]]

collectgarbage();

if GAMESTATE:IsHumanPlayer(PLAYER_1)  then
	local judgtimingp1=GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming();
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2)  then
	local judgtimingp2=GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming();
end;

function breakOnItem(player)
	local baseX = 0;
	if player == PLAYER_1 then
		baseX = SCREEN_CENTER_X-510;
	else
		baseX = SCREEN_CENTER_X+510;
	end;

	return Def.ActorFrame
	{
		OnCommand=function(self)
			self:x(baseX);
			self:y(SCREEN_CENTER_Y+165);
			self:zoom(0.65);
			self:queuecommand("checkBreak");
		end;

		checkBreakCommand=function(self)
			local STATE = GAMESTATE:GetPlayerState(player);
			local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();

			local isBreakOn = false;
			if failSetting == "FailType_Immediate" then
				isBreakOn = true;
			end;	
			self:visible(isBreakOn);
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("checkBreak");
			end;
		end;		
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,1);

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/breakonsprite"))..{
			OffCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};
	}
end;

function GetFixedChannelName(path)
	--devuelve un nombre display
	return arrChannelTitle[path] or path;
end;

function get_file_name(file)
      return file:match("^.+/(.+)$")
end

local ChangeDir = 0;
local t = Def.ActorFrame {};
local pvideoLoaded=false;

local stackSelectionP1=0;
local stackSelectionP2=0;
local prevXSize = 508;
local prevYSize = 290;

--quiero tener un counter global de frames, claramente llega a 60 y vuelve a 0.
framesCounterSDL = 0;
lastSong = nil;

t[#t+1] =  Def.ActorFrame
{
	InitCommand=cmd(SetUpdateFunction,frameCounterUpdater);
};

function frameCounterUpdater()
      if (framesCounterSDL + 1) > 60 then
      	framesCounterSDL = 0;
      end;	
	framesCounterSDL = framesCounterSDL + 1;
end;



--fav
--****************************
--*** 0 - FAVORITES        ***
--****************************
local p1StatusFavSelectMode=false;
local p2StatusFavSelectMode=false;

--****************************
--*** 0 - VS               ***
--****************************
-- only with 2 players.
if GAMESTATE:GetNumSidesJoined() == 2 then
	if GAMESTATE:Env()["p1vsCount"] == nil and GAMESTATE:Env()["p2vsCount"] == nil then
		GAMESTATE:Env()["p1vsCount"] = 0;
		GAMESTATE:Env()["p2vsCount"] = 0;
	end;
end;

--*********************************
--*** 0 - DIFFICULTY LIST TYPE  ***
--*********************************
--Here we manage what type of difficult list we want, because we want to add whatever as a "plugin".
local diffListTypeRegistered = {"sanity"};
local diffListTypeSelected = diffListTypeRegistered[1];
local pathToDiffTypePlug = "ScreenSelectMusic/difficultyList/"..diffListTypeSelected.."/";


--****************************
--*** 0 - FRAME / OVERLAY  ***
--****************************
local frameSelected = "simple";
if frameSelected == nil then
	frameSelected = "simple";
end;
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/"..frameSelected.."/overlay"))..{
};


--****************************
--*** 1 - ARROWS WHEEL < > ***
--****************************
local songwsx=150;
local basesongwsx = 150;
local basegroupwx=250;
local zoomArrowsBanner=0.5;
local zoomArrowsChannel=1;



t[#t+1] =  Def.ActorFrame
{

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(zoom,zoomArrowsBanner;y,YellowArrows_Y;x,SCREEN_CENTER_X-songwsx;diffusealpha,0.6;blend,'BlendMode_Add');
		PreviousSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X-(songwsx+10);linear,0.08;x,SCREEN_CENTER_X-songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);

		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);	
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.6);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);			
			self:y(YellowArrows_Y);
			self:x(SCREEN_CENTER_X-songwsx);
			self:linear(0.1);
			self:diffusealpha(0.6);
		end;

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.8);		
	};	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(zoom,zoomArrowsBanner;y,YellowArrows_Y;x,SCREEN_CENTER_X-songwsx;diffusealpha,0.8);
		PreviousSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X-(songwsx+10);linear,0.08;x,SCREEN_CENTER_X-songwsx);
		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);	
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.1);
			self:diffusealpha(0.8);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:zoom(zoomArrowsBanner);
			self:diffusealpha(0);
			self:y(YellowArrows_Y);
			self:x(SCREEN_CENTER_X-songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.8);
		end;

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.4);
	};	


 	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(rotationz,180;zoom,zoomArrowsBanner;y,YellowArrows_Y;x,SCREEN_CENTER_X+songwsx;diffusealpha,0.6;blend,'BlendMode_Add');		
		NextSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X+(songwsx+10);linear,0.08;x,SCREEN_CENTER_X+songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);

		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X+songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.6);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);
			self:y(YellowArrows_Y);
			self:x(SCREEN_CENTER_X+songwsx);
			self:linear(0.1);
			self:diffusealpha(0.6);
		end;		

		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.6);		
	};

 	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
		Name="MWARROW";
		InitCommand=cmd(rotationz,180;zoom,zoomArrowsBanner;y,YellowArrows_Y;x,SCREEN_CENTER_X+songwsx;diffusealpha,0.4);		
		NextSongMessageCommand=cmd(stoptweening;linear,0.08;x,SCREEN_CENTER_X+(songwsx+10);linear,0.08;x,SCREEN_CENTER_X+songwsx);

		--SelectChannelMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-40;linear,0.05;diffusealpha,0.4);
		--ChannelChosenMessageCommand=cmd(linear,0.05;diffusealpha,0;y,SCREEN_CENTER_Y-80;linear,0.05;diffusealpha,0.4);	


		SelectChannelMessageCommand=function(self)
			songwsx = basegroupwx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsChannel);		
			self:y(SCREEN_CENTER_Y-40);
			self:x(SCREEN_CENTER_X+songwsx);
			self:sleep(0.05);
			self:diffusealpha(0.8);
		end;

		ChannelChosenMessageCommand=function(self)
			songwsx = basesongwsx;
			self:diffusealpha(0);
			self:zoom(zoomArrowsBanner);
			self:y(YellowArrows_Y);
			self:x(SCREEN_CENTER_X+songwsx);
			self:linear(0.1);
			self:diffusealpha(0.8);
		end;


		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,0.4);		
	};
};

--backsimpleDiffList
t[#t + 1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.37;zoomx,2.8;zoomy,0.75;diffusealpha,0.8;fadetop,0.1);
	CurrentSongChangedMessageCommand=function(self)			
		self:finishtweening():diffusealpha(0.6):sleep(0.05):linear(0.2):diffusealpha(0.8);	
	end;	
	SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	

	SelectChannelMessageCommand=function(self)
		self:linear(0.2);
		self:y(SCREEN_CENTER_Y*1.51);
		self:diffusealpha(0.5);
		self:zoomx(2.1);
	end;
	ChannelChosenMessageCommand=function(self)
		self:y(SCREEN_CENTER_Y*1.37);
		self:diffusealpha(0.8);
		self:zoomx(2.8);
	end;

};

t[#t+1] =  Def.ActorFrame{

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/lvplaceholderbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;);
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8);
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/atype_lvbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;blend,"BlendMode_Add";queuecommand,"Ani");
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8):queuecommand("Ani");
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		AniCommand=function(self)
			self:linear(1);
			self:diffusealpha(1);
			self:decelerate(2);
			self:diffusealpha(0.5);
			self:queuecommand("Ani");
		end;

		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;queuecommand,"Ani");	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/btype_lvbase"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.35;zoom,1;diffusealpha,1;zoom,0.6;zoomx,0.65;blend,"BlendMode_Add";queuecommand,"Ani");
		CurrentSongChangedMessageCommand=function(self)			
			--self:finishtweening():diffusealpha(0):sleep(0.05):linear(0.2):diffusealpha(0.8):queuecommand("Ani");
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;	
		AniCommand=function(self)
			self:linear(2);
			self:diffusealpha(1);
			self:sleep(1);
			self:decelerate(1);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;queuecommand,"Ani");	
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};	

	SelectChannelMessageCommand=cmd(stoptweening;decelerate,0.1;diffusealpha,0;);
	ChannelChosenMessageCommand=cmd(stoptweening;decelerate,0.1;diffusealpha,1;);

};


--***********************************
--*** 3 - SONG INFO W/ DECORATION ***
--***********************************
local songInfoYBuffer = 95;
local songInfoYBufferSelected = 90;

local function BarTitle(self)
	local statusScreen = SCREENMAN:GetTopScreen():GetSelectionState();
	if statusScreen then
		if statusScreen == 'SelectingSong' then
			local currentSong = GAMESTATE:GetCurrentSong()
			local isRandomChannel = GAMESTATE:GetRandomChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetSurvivalChannel()

			local songartist = "???"
			local bpmActual = "BPM ???"
			local durationSong = "??:??"
			
			if isRandomChannel or (currentSong and currentSong:GetOrigin() == "RANDOMXX") then
				if GAMESTATE:GetSurvivalChannel() and currentSong then
					local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("Title"):settext(songtitle);
				else
					self:GetChild("Title"):settext("?????");
				end;
			elseif currentSong then
				local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("Title"):settext(songtitle );
					
				--get real information about a train


				bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
				songartist = GAMESTATE:GetCurrentSong():GetDisplayArtist();
				local MusicLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() or 0;
				durationSong = MusicLength > 0 and SecondsToMMSS(MusicLength) or "";

				if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
					local dataTrain = getTrainProgresiveInfoLess();
					bpmActual = "BPM " .. ProcessBPM(dataTrain.bpm);
					songartist = "V.A";
					durationSong = dataTrain.duration > 0 and SecondsToMMSS(dataTrain.duration) or "";
				end;
			else
				self:GetChild("Title"):settext("?????");
			end;

			local ftext = songartist .."  •  "..bpmActual.."  •  "..durationSong
			self:GetChild("Artist"):settext(ftext);
			self:GetChild("Artist"):AddAttribute(0, {Length=#songartist, Diffuse=color("#ffe7c9"),StrokeColor=color("0,0,0,1")})
			self:GetChild("Artist"):AddAttribute(#songartist + 5, {Length=#bpmActual, Diffuse=color("#c9fff3"),StrokeColor=color("0,0,0,1")})
			self:GetChild("Artist"):AddAttribute(#songartist + #bpmActual + 10, {Length=#durationSong, Diffuse=color("#ffc9ea"),StrokeColor=color("0,0,0,1")})
		end;
	end;
end;

local function WheelCounter(self)
	local screen = SCREENMAN:GetTopScreen()
		if not screen or screen:GetName() ~= "ScreenSelectMusic" then return end
		if screen:GetSelectionState() ~= "SelectingSong" then return end
	
	local musicWheel = screen:GetChild("MusicWheel")
	local indexText = "";
	if musicWheel then
		local index = (musicWheel:GetCurrentIndex() + 1) or 0
		local items = musicWheel:GetNumItems()
		indexText = counterformat(index) .. " / " .. counterformat(items)
	else
		indexText = ""
	end
	self:GetChild("Counter"):settext(indexText);
	
	local curChannel = GetFixedChannelName(GAMESTATE:GetChannelName() or "");
	self:GetChild("Channel"):settext(curChannel);

	--categorias
	if GAMESTATE:GetRandomChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetSurvivalChannel() then
		self:GetChild("Category"):settext("-");		
	else
		if (curChannel ~= nil) then
			if curChannel == "ORIGINAL" or curChannel == "XROSS" or curChannel == "J-MUSIC" or curChannel == "K-POP" or curChannel == "WORLD MUSIC" then
				self:GetChild("Category"):settext("-");
			else
				local categoryText = CHGetCategory(0);
				if categoryText ~= nil then
					self:GetChild("Category"):settext(CHGetCategory(0));
				else
					self:GetChild("Category"):settext("-");
				end;
			end;
		end;
	end;	

end;

local favMessage;

local langMessageFav = PREFSMAN:GetPreference('Language').."_favorite_message";


t[#t+1] =  Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.19);
	SelectChannelMessageCommand=cmd(finishtweening;decelerate,0.1;diffusealpha,0);
	ChannelChosenMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,0.1;linear,0.3;diffusealpha,1);	

	--[[
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/BackTitle"))..{
		InitCommand=cmd(zoom,1.1;zoomy,.9;fadeleft,0.15;faderight,0.15;);
	};
	]]

	Def.Sound {
	    Name = "favActivateSound";
	    File = THEME:GetPathS("", "xsanity/favActivate");
	};


	--Favorite
	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/"..langMessageFav))..{
		name="favoriteMessage";
		InitCommand = function(self)
			self:zoom(0.6):xy(0, -40):diffusealpha(0);
			favMessage = self;
		end;

		CurrentSongChangedMessageCommand = function(self) 
			local p1NoPersistent = false;
			local p2NoPersistent = false;
			
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				if not PROFILEMAN:IsPersistentProfile(PLAYER_1) then
					p1NoPersistent=true;
				end;
			end;
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				if not PROFILEMAN:IsPersistentProfile(PLAYER_2) then
					p2NoPersistent=true;
				end;
			end;

			if p1NoPersistent or p2NoPersistent then
				self:diffusealpha(0);
				return;
			end;

			if GAMESTATE:GetGameMode() ~= 'Basic' then
				self:stoptweening():diffusealpha(0):sleep(5):linear(1):diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};



	--Favorite
	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/favorite"))..{
		name="favoriteP1";
		InitCommand = function(self)
			self:zoom(0.8):xy(-150, -40):visible(GAMESTATE:IsPlayerEnabled(PLAYER_1)):diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand = function(self) 
			p1StatusFavSelectMode = false;

			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_1) then
				 	p1StatusFavSelectMode = true;
				 else
				 	p1StatusFavSelectMode = false;
				 end
			end

			self:stoptweening():queuecommand("UpdateFavorite") 
		end;
		SongUnchosenMessageCommand = function(self) 
			p1StatusFavSelectMode = false;
			self:stoptweening():queuecommand("UpdateFavorite") 
		end;

	   	SongChosenMessageCommand = function(self) 
			p1StatusFavSelectMode = true;
			self:stoptweening():queuecommand("UpdateFavorite");
	   	end;
		
		SelectChannelMessageCommand = function(self) 
			p1StatusFavSelectMode = false;
			self:stoptweening():diffusealpha(0) 
		end;
		UpdateFavoriteCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_1) then
					self:stoptweening():sleep(0.05):linear(0.09):diffusealpha(1);
					favMessage:stoptweening():diffusealpha(0);
				 else
				 	self:stoptweening():diffusealpha(0);
				 end
			else
				self:stoptweening():diffusealpha(0);
			end

			if p1StatusFavSelectMode then
				self:sleep(0.25);
				self:queuecommand("UpdateFavorite");
			end;
		end;

		FinalizedMessageCommand = function(self)	
			p1StatusFavSelectMode = false;
			self:stoptweening():visible(false);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};

	LoadActor(THEME:GetPathG("", "ScreenSelectMusic/favorite"))..{
		name="favoriteP2";
		InitCommand = function(self)
			self:zoom(0.8):xy(150, -40):visible(GAMESTATE:IsPlayerEnabled(PLAYER_2)):diffusealpha(0);
		end;
		CurrentSongChangedMessageCommand = function(self) 
			self:stoptweening():queuecommand("UpdateFavorite") 
		end;

		SongUnchosenMessageCommand = function(self) 
			p2StatusFavSelectMode = false;
		end;

		SongChosenMessageCommand = function(self) 
			p2StatusFavSelectMode = true;
			self:stoptweening():queuecommand("UpdateFavorite");
		end;

		SelectChannelMessageCommand = function(self) 
			p2StatusFavSelectMode = false;
			self:stoptweening():diffusealpha(0) 
		end;


		UpdateFavoriteCommand = function(self)
			if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				 if GAMESTATE:GetCurrentSong():GetFavorite(PLAYER_2) then
					self:stoptweening():sleep(0.05):linear(0.09):diffusealpha(1);
					favMessage:stoptweening():diffusealpha(0);
				 else
				 	self:stoptweening():diffusealpha(0);
				 end
			else
				self:stoptweening():diffusealpha(0);
			end

			if p2StatusFavSelectMode then
				self:sleep(0.25);
				self:queuecommand("UpdateFavorite");
			end;
		end;


		FinalizedMessageCommand = function(self)	
			p2StatusFavSelectMode = false;
			self:stoptweening():visible(false);
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};
	Def.ActorFrame{
		Name="Fonts";
		UpdateinfoCommand=function(self)
			BarTitle(self);

			local title = self:GetChild("Title");
			local Artist = self:GetChild("Artist");
			local basetitle = self:GetChild("Basetitle");

			if title and basetitle then
				local textWidth = title:GetZoomedWidth();
				local textWidthArtist = Artist:GetZoomedWidth();

				local baseWidth = basetitle:GetWidth();
				local margin = 250; -- Total extra ancho (10px a cada lado)
				local marginArtist = 250; -- Total extra ancho (10px a cada lado)

				local zoomXName=0;
				local zoomXArtis=0;

				if baseWidth > 0 then
					zoomXName = (textWidth + margin) / baseWidth;
					zoomXArtis = (textWidthArtist + marginArtist) / baseWidth;
					--basetitle:zoomx(newZoomX);
				end

				if zoomXName >= zoomXArtis then
					basetitle:zoomx(zoomXName);
				end;

				if zoomXArtis >= zoomXName then
					basetitle:zoomx(zoomXArtis);
				end;				


			end
		end;
		showInfoCommand=function(self)
			self:finishtweening():diffusealpha(0):accelerate(0.25):diffusealpha(1);	
		end;
		CurrentSongChangedMessageCommand=function(self)			
			self:finishtweening():queuecommand("Updateinfo"):diffusealpha(0):sleep(0.02):queuecommand("showInfo");	
		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
			Name="Basetitle";
			InitCommand=cmd(xy,-2,2;zoomy,0.8;diffusealpha,0.95;fadeleft,0.3;faderight,0.3);		
		};


		LoadFont("_TitleXolonium")..{
			Name="Title";
			Text="SongName Test";
			InitCommand=cmd(zoom,0.8;xy,0,-14;maxwidth,750/.78;);
		};

		LoadFont("_TitleXolonium")..{
			Name="Artist";
			Text="SongArtist Test";
			InitCommand=cmd(zoom,.5;xy,0,12;skewx,0;maxwidth,700/.54;);
		};	
	};

	Def.ActorFrame{
		InitCommand=function(self)
			self:SetUpdateFunction(WheelCounter);
		end;
		SongChosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.15;diffusealpha,1;);
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,1;);
		LoadFont("xolonium")..{
			Name="Counter";
			Text="x,xxx / x,xxx";
			InitCommand=cmd(zoom,.7;xy,-37,SongIndexCounter_Y;horizalign,left;maxwidth,160/.8;strokecolor,color("0,0,0,1") );
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
			Name="baseChannel";
			InitCommand=cmd(xy,-360,130;zoomy,0.3;zoomx,0.6;diffusealpha,0.95;fadeleft,0.3;faderight,0.3);
		};

		LoadFont("xolonium")..{
			Name="Channel";
			Text="ALL TUNES";
			InitCommand=cmd(zoom,.8;xy,-360,128;horizalign,center;maxwidth,180/.8;strokecolor,color("0,0,0,1") );
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
			Name="baseCategory";
			InitCommand=cmd(xy,360,130;zoomy,0.3;zoomx,0.6;diffusealpha,0.95;fadeleft,0.3;faderight,0.3);
		};

		LoadFont("xolonium")..{
			Name="Category";
			Text="ALL TUNES";
			InitCommand=cmd(zoom,.8;xy,360,128;horizalign,center;maxwidth,180/.8;strokecolor,color("0,0,0,1") );
		};

	};
};


--BORDER WHEEL SONG SELECTED
t[#t+1] =  Def.ActorFrame
{
	SelectChannelMessageCommand=function(self)
	--	bPickingChannel = true;
		self:visible(false);		
	end;
	ChannelChosenMessageCommand=function(self)
	--	bPickingChannel = false;
		self:visible(true);
	end;
	
	InitCommand=cmd(y,THEME:GetMetric("ScreenSelectMusic", "MusicWheelY"));
	Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X,-82;rainbow;effectperiod,4;setsize,256,1;faderight,.1;fadeleft,.1;);	--blend,"BlendMode_Add"
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.25;linear,.3;diffusealpha,1;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);		
		OffCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};
	Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X,82;rainbow;effectperiod,4;setsize,256,1;faderight,.1;fadeleft,.1;);	--blend,"BlendMode_Add"
		CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.25;linear,.3;diffusealpha,1;);
		SongChosenMessageCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
		SongUnchosenMessageCommand=cmd(stoptweening;sleep,.25;linear,0.3;diffusealpha,1);		
		OffCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};	
};

--**********************************************
--*** 4 - MISSION QUEST 			   ***
--**********************************************

t[#t+1] = Def.ActorFrame{
	
	InitCommand=cmd(y,SCREEN_CENTER_Y-355;visible,false);
	SongChosenMessageCommand=cmd(stoptweening;queuecommand,"changeTitlesMission");
	ChangeStepsMessageCommand=function(self)
		self:queuecommand("changeTitlesMission");
	end;
	SongUnchosenMessageCommand=function(self)
		self:GetChild("titleMission"):settext("");
		self:GetChild("descMission"):settext("");
		self:visible(false);
	end;
	changeTitlesMissionCommand=function(self)
		self:stoptweening();
		local title ="";
		local desc = "";

		if GAMESTATE:GetQuestZoneChannel() then
			self:visible(true);
			local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetQuestDesc();			
			text = split('@',text );
			if #text > 2 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				elseif (gLANG() == "PT-") then
					text = text[3];
				else
					text = text[2];
				end
			elseif #text > 1 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				else
					text = text[2];
				end
			else
				text = text[1];
			end;
			
			text = split('|',text );
			if #text > 1 then
				title= text[1];
				desc = text[2];
			else
				title= text[1];
			end;
		elseif GAMESTATE:GetQuestWorldChannel() then
			self:visible(true);
			if (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_UCQ") then
				local description = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDescription();
				if (string.len(description) > 0) then
					desc = description;
				end;
			else
				local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetChartName();
				if (string.len(text) > 0) then
					title= text;
				end;
				
			end;
		elseif (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_QUEST") then
			self:visible(true);
			local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetChartName();
			if (string.len(text) > 0) then
				title = text;
			end;
		elseif (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_UCQ") then
			self:visible(true);
			local description = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDescription();
			if (string.len(description) > 0) then
				desc = description;
			end;
		else
			self:visible(false);
		end;

		self:GetChild("titleMission"):settext(title);
		self:GetChild("descMission"):settext(desc);

	end;	

	SelectChannelMessageCommand=cmd(finishtweening;visible,false);
	OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/base"))..{	
		Name="missionBase";
		InitCommand=cmd(animate,false;zoom,.65;y,-580;x,SCREEN_CENTER_X);
		OnCommand=cmd(animate,false;zoom,.65;y,-340;x,SCREEN_CENTER_X);
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;y,SCREEN_CENTER_Y-110);
		OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
	};
	
	LoadFont("_myriad pro")..{
		Name="titleMission";
		InitCommand=cmd(y,SCREEN_CENTER_Y-155;zoom,1;x,SCREEN_CENTER_X;visible,true;shadowlength,2);
		OnCommand=function(self)
			self:settext("-");
		end;
	};

	LoadFont("_myriad pro")..{
		Name="descMission";
		InitCommand=cmd(y,SCREEN_CENTER_Y-110;zoom,.85;x,SCREEN_CENTER_X;visible,true;shadowlength,2);
		OnCommand=function(self)
			self:settext("-");
		end;
	};

	--[[
	LoadFont("_myriad pro")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-140;zoom,.85;x,SCREEN_CENTER_X;visible,false;shadowlength,2);
		SetQuestTextCommand=function(self)
			if GAMESTATE:GetQuestZoneChannel() then
				local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetQuestDesc();
				
				text = split('@',text );
				if #text > 2 then	-- Si encontro un @, significa que hay ingles/español
					if (gLANG() == "EN-") then
						text = text[1];
					elseif (gLANG() == "PT-") then
						text = text[3];
					else
						text = text[2];
					end
				elseif #text > 1 then	-- Si encontro un @, significa que hay ingles/español
					if (gLANG() == "EN-") then
						text = text[1];
					else
						text = text[2];
					end
				else
					text = text[1];
				end;
				
				text = split('|',text );
				if #text > 1 then
					self:settext(text[1].."\n\n"..text[2]);
				else
					self:settext(text[1]);
				end;
			else
				if (GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetLabelType() == "LABELTYPE_UCQ") then
					local desc = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetDescription();
					if (string.len(desc) > 0) then
						self:settext(desc);
					else
						self:settext("");
					end;
				else
					local text = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetChartName();
					if (string.len(text) > 0) then
						self:settext(text);
					else
						self:settext("");
					end;
					
				end;
			end;
			
		end;
		ChangeStepsMessageCommand=cmd(finishtweening;queuecommand,"SetQuestText");
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		StepsUnchosenMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingSong' then
				self:finishtweening();
				self:queuecommand("SetQuestText");
			end;
		end;
		SongChosenMessageCommand=cmd(stoptweening;settext,"";sleep,.2;visible,(GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0;queuecommand,"SetQuestText"); 
		OffCommand=cmd(finishtweening;visible,false);
	};
	]]
	
};

-- Iconos en quest 
local StateIco; 
t[#t+1] = Def.ActorFrame
{
	-- Hago esto para no repetir el for 5 veces (e incluso 9 veces), solo 1 vez y ya alv
	SongChosenMessageCommand=cmd(queuecommand,"CheckQuestMods");
	ChangeStepsMessageCommand=cmd(queuecommand,"CheckQuestMods");
	CheckQuestModsCommand=function(self)
		StateIco = GetValidQuestMods( GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() ) );
	end;
}

for i=1,9,1 do
	t[#t+1] = LoadActor(THEME:GetPathG("","SC-CW_ICONS"))..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-50;visible,false;setstate,0;animate,false);
		SongChosenMessageCommand=cmd(diffusealpha,0;sleep,.2;queuecommand,"CheckQuestMods");
		ChangeStepsMessageCommand=cmd(queuecommand,"CheckQuestMods");
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		CheckQuestModsCommand=function(self)
			if GAMESTATE:GetQuestZoneChannel() then
				self:visible(false);
				if (StateIco[i] ~= nil) then
					self:setstate(StateIco[i] - 1);
					self:x(SCREEN_CENTER_X-320 + (70 * i));
					self:visible(true);
					self:diffusealpha(1);
				end;
			end;
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};
end;

-- Esto en caso de que hayan mas de 5 mods, y pues, tengo espacio en el panel geeeeee
--[[
for i=6,9,1 do
	t[#t+1] = LoadActor(THEME:GetPathG("","SC-CW_ICONS"))..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-70;visible,false;setstate,0;animate,false);
		SongChosenMessageCommand=cmd(diffusealpha,0;sleep,.2;queuecommand,"CheckQuestMods");
		ChangeStepsMessageCommand=cmd(queuecommand,"CheckQuestMods");
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		CheckQuestModsCommand=function(self)
			if GAMESTATE:GetQuestZoneChannel() then
				self:visible(false);
				if (StateIco[i] ~= nil) then
					self:setstate(StateIco[i] - 1);
					self:x(SCREEN_CENTER_X-140 + (70 * i));
					self:visible(true);
					self:diffusealpha(1);
				end;
			end;
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};
end;
]]


--**********************************
--*** 5 - SURVIVAL  		   ***
--**********************************
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/mission/base"))..{
		InitCommand=cmd(animate,false;zoom,.65;y,SCREEN_CENTER_Y-110;x,SCREEN_CENTER_X;visible,false);
		OnCommand=cmd(animate,false;zoom,.65;y,SCREEN_CENTER_Y-110;x,SCREEN_CENTER_X;visible,false);
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		SongChosenMessageCommand=function(self)
			if GAMESTATE:GetSurvivalChannel() then
				self:finishtweening();
				self:visible(true);
			end;
		end;
		OffCommand=cmd(stoptweening;linear,.2;y,-200;diffusealpha,0);
	};
	
	LoadFont("_myriad pro")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y-110;zoom,.85;x,SCREEN_CENTER_X;visible,false;shadowlength,2);
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
		SongChosenMessageCommand=function(self)
			if GAMESTATE:GetSurvivalChannel() then
				local SurvivorLevel = 25;
				local GradeGoal = SurvivalGradeToText( GAMESTATE:GetExpectedSurvivalGrade() );
				self:settext( GetSurvivalTextToPanel( SurvivorLevel , GradeGoal) ) 

				self:visible(true);
			end;
		end;
		SurvivalMenuCloseMessageCommand=function(self, params)
			if GAMESTATE:GetSurvivalChannel() then
				local SurvivorLevel = 25;
				local GradeGoal = SurvivalGradeToText( params.current );
				self:settext( GetSurvivalTextToPanel( SurvivorLevel , GradeGoal) )

				self:visible(true);
			end;
		end;
		OffCommand=cmd(finishtweening;linear,.2;y,-240);
	};
	
};

t[#t+1] = LoadActor(THEME:GetPathB("","SurvivalMode/OnSelectMusic"));

--**********************************
--*** 6 - BASIC INTERFACE	   ***
--**********************************


if GAMESTATE:GetGameMode() == 'Basic' then
	--basic list, this is permanent or be in this file.
	t[#t+1] =  LoadActor("ScreenSelectMusicLua/0_Interface_Basic_Level_List") .. {
		InitCommand=cmd(y,-30);
		OnCommand=cmd(stoptweening;decelerate,0.2;y,8);
		SelectChannelMessageCommand=cmd(stoptweening;decelerate,0.1;y,-30;diffusealpha,0;);
		ChannelChosenMessageCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.2;y,8);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.2;y,-30;diffusealpha,0;);
		SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.2;y,8);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

	};

	t[#t+1]=LoadActor("ScreenSelectMusicLua/0_Interface_Basic_Base")..{
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() == 'Basic');
		FullModeMessageCommand=cmd(playcommand,"On");
	};
end;


--**********************************
--*** 7 - FULL INTERFACE	   ***
--**********************************

--Break on icon.
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	t[#t+1] = breakOnItem(PLAYER_1);
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t+1] = breakOnItem(PLAYER_2);
end;

t[#t+1] =  Def.ActorFrame
{
	LoadActor("ScreenSelectMusicLua/0_Interface_Full_Base")..{
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= 'Basic');
		--OnCommand=cmd(visible,true);
		FullModeMessageCommand=cmd(playcommand,"On");
	};

	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_1);
		InitCommand=cmd(xy,Player1ModIcons_X,PlayerModIcons_Y);
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= "Quest");
		PlayerJoinedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then 
				self:queuecommand("On");
			end;
		end;
		CurrentSongChangedMessageCommand=cmd(queuecommand,"CheckNew");
		CheckNewCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST"  then
					self:visible(false);
				else
					self:visible(true);
				end;
			else
				self:visible(false);
			end;
		end;

		ProfileWindowCloseMessageCommand=function(self,params)
			if params.PN == PLAYER_1 then 
				self:queuecommand("On");
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;


	};
	
	LoadActor("ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_2);
		InitCommand=cmd(xy,Player2ModIcons_X,PlayerModIcons_Y);
		OnCommand=cmd(visible,GAMESTATE:GetGameMode() ~= "Quest");
		CurrentSongChangedMessageCommand=cmd(queuecommand,"CheckNew");
		CheckNewCommand=function(self)
			if GAMESTATE:GetCurrentSong() ~= nil then
				if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST"  then
					self:visible(false);
				else
					self:visible(true);
				end;
			else
				self:visible(false);
			end;
		end;
		PlayerJoinedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then 
				self:queuecommand("On");
			end;
		end;

		ProfileWindowCloseMessageCommand=function(self,params)
			if params.PN == PLAYER_2 then 
				self:queuecommand("On");
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

	};

};


--******************************************
--*** 8 - ANIMATION INTERFACE	- RANKING  ***
--******************************************
t[#t+1] =  Def.ActorFrame
{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		FullModeCWMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
		FullModeMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
		RankModeCWMessageCommand=cmd(finishtweening;diffuse,color("1,1,1,1");linear,0.125;diffuse,color("0,0,0,1");linear,0.125;diffuse,color("0,0,0,0.75");sleep,0.25;linear,0.125;diffuse,color("0,0,0,0"));
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/blurback"))..{
		OnCommand=cmd(zoom,0;y,SCREEN_CENTER_Y-80;x,SCREEN_CENTER_X+600;animate, true;SetAllStateDelays,0.05725;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.2;queuecommand,"AnimateMode");
		FullModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.15;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X+600;sleep,0.15;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoom,0.5;linear,0.5;zoomy,.6;zoomx,.8;x,SCREEN_CENTER_X+600;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/blurback"))..{
		OnCommand=cmd(zoom,0;y,SCREEN_CENTER_Y-80;x,SCREEN_CENTER_X-600;animate, true;SetAllStateDelays,0.05725;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.2;queuecommand,"AnimateMode");
		FullModeCWMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.15;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;zoomx,.2;zoomy,.6;x,SCREEN_CENTER_X-600;sleep,0.15;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoom,0.5;linear,0.5;zoomy,.6;zoomx,.8;x,SCREEN_CENTER_X-600;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-RANKFIREBACK"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false;blend,Blend.Add);
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.17;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,0;zoomy,0;linear,0.05;zoomy,1;vibrate;effectmagnitude,3,3,3;diffusealpha,1;linear,0.3;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-FULLMODELABEL"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false);
		FullModeCWMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.2;setstate,1;queuecommand,"AnimateMode");
		AnimateModeCommand=cmd(diffusealpha,1;zoomy,0;linear,0.05;zoomy,1;linear,0.1;glow,1,1,1,0.17;linear,0.1;glow,1,1,1,0;sleep,0.1;linear,0.2;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullmode/SSM-MODEBACKFX"))..{
		OnCommand=cmd(Center;addy,-75;zoom,1;zoomy,0;animate,false;blend,Blend.Add);
		FullModeCWMessageCommand=cmd(finishtweening;sleep,0.05;setstate,0;queuecommand,"AnimateMode");
		FullModeMessageCommand=cmd(finishtweening;sleep,0.17;setstate,0;queuecommand,"AnimateMode");
		RankModeCWMessageCommand=cmd(finishtweening;sleep,0.17;setstate,1;queuecommand,"AnimateModeRank");
		AnimateModeCommand=cmd(diffusealpha,0;zoomy,0;sleep,0.05;linear,0.2;zoomy,1;diffusealpha,.8;linear,0.65;diffusealpha,0);
		AnimateModeRankCommand=cmd(diffusealpha,0;zoomy,0;linear,0.05;vibrate;effectmagnitude,3,3,3;zoomy,1;diffusealpha,.8;sleep,.2;linear,.5;diffusealpha,0);
		OffCommand=cmd(stoptweening);
	};
	
	
	Def.Sound {
		FinalizedMessageCommand=cmd(stoptweening;queuecommand,"PlaySound");
		PlaySoundCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("","JoinGamePlay"));
		end;
	};
}

--******************************************
--*** 9 - CHECK ASPECT RATIO  	     ***
--******************************************

local function Visible()
	return GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin();
end;

local ARRAY={};
ARRAY[-1] = PLAYER_1;
ARRAY[1] = PLAYER_2;

local curAspect = round(GetScreenAspectRatio(),5);
if curAspect <= 1.33333 then -- 4:3
	t[#t+1] = Def.ActorFrame {
		Def.Quad{
			InitCommand=cmd(FullScreen;diffuse,color("0,0,0,1"));
		};
		LoadFont("normalxolonium")..{
			InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;settext,"Sanity Select Music Style is only compatible under\n 16:9 or 16:10 Display Aspect Ratio");
		};
	};

end;

--********************************
--*** 10 - PROFILE SELECTOR    ***
--********************************
for i=-1,1,2 do
	t[#t+1] = Def.ActorFrame {


		Def.Quad{
			InitCommand=cmd(xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 302 or -300),SCREEN_CENTER_Y;setsize,400,SCREEN_HEIGHT;diffuse,color('0,0,0,1');diffusealpha,0);
			OnCommand=function(self)
			end;
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0.8);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeperfilback"))..{
			OnCommand=cmd(zoom,0.75;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),250;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 					
					self:diffusealpha(0);
				end;	
			end;				
		};

		Def.Quad{
			InitCommand=cmd(xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 302 or -300),254.3;setsize,220,25;diffuse,color('1,1,1,1');diffusealpha,0);
			OnCommand=function(self)
			end;

			ProfileWindowMoveMessageCommand=function(self,params)	
			self:faderight(0.5);
			self:fadeleft(0.5);		
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:cropright(1);
						self:linear(0.1);
						self:diffusealpha(0.8);
						self:cropright(0);
						self:linear(0.2);
						self:diffusealpha(0);						
					else
						self:finishtweening();
						self:cropleft(1);
						self:linear(0.1);
						self:diffusealpha(0.8);						
						self:cropleft(0);
						self:linear(0.2);
						self:diffusealpha(0);						
					end;
				end;
			end;				
		};


		LoadFont("_XoloPlayer")..{
			InitCommand=cmd(xy,SCREEN_CENTER_X + 300 * i,250;zoom,1.2;visible,false);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(true);
					self:settext(params.NAME);
				end;
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(false);
				end;
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(false);
				end;
			end;
			ProfileWindowMoveMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:visible(true);
					self:settext(params.NAME);
				end;
			end;

			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:cropright(1);
						self:linear(0.1);
						self:cropright(0);
						self:linear(0.2);					
					else
						self:finishtweening();
						self:cropleft(1);
						self:linear(0.1);					
						self:cropleft(0);
						self:linear(0.2);					
					end;
					self:settext(params.NAME);
				end;
			end;	

		};


		--INFO
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_info"))..{
			OnCommand=cmd(zoom,0.75;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),330;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueleft"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),326;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueleft"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),326;diffusealpha,0;blend,"BlendMode_Add");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	

			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();
						self:linear(0.05);
						self:diffusealpha(1);
						self:linear(0.05);
						self:diffusealpha(0);			
					else
						self:finishtweening();				
					end;
				end;
			end;	

		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueright"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 430 or -170),326;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_blueright"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 430 or -170),326;diffusealpha,0;blend,"BlendMode_Add");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowMoveMessageCommand=function(self,params)	
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening();		
					else
						self:finishtweening();
						self:linear(0.05);
						self:diffusealpha(1);
						self:linear(0.05);
						self:diffusealpha(0);				
					end;
				end;
			end;	
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_center"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),324;diffusealpha,0;queuecommand,"Animate");
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(1);
					self:queuecommand("Animate");
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:stoptweening();
					self:diffusealpha(0);
				end;	
			end;	

			AnimateCommand=function(self)
				self:linear(0.4);
				self:y(322);
				self:linear(0.4);
				self:y(326);
				self:queuecommand("Animate");
			end;	

			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;	
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChangeProfile/changeprofile_textselect"))..{
			OnCommand=cmd(zoom,0.8;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 300 or -300),343;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;				
			end;
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
		};


	};
end;



for i=-1,1,2 do
	t[#t+1] = Def.ActorFrame {
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
			OnCommand=cmd(zoom,0.4;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 170 or -430),254.3;diffusealpha,0);

			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;	
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;				
			ProfileWindowMoveMessageCommand=function(self,params)			
				if params.PN == ARRAY[i] then 
					if params.DIR == -1 then
						self:finishtweening():addx(-5):linear(0.125):addx(5);
					end;
				end;
			end;			
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ws_arrow_to_left"))..{
			OnCommand=cmd(rotationz,180;zoom,0.4;xy,SCREEN_CENTER_X + (ARRAY[i] == PLAYER_2 and 432 or -168),252;diffusealpha,0);
			ProfileWindowOpenMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(1);
				end;	
			end;
			ProfileWindowCloseMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;			
			ProfileWindowCancelMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					self:diffusealpha(0);
				end;	
			end;	
			ProfileWindowMoveMessageCommand=function(self,params)
				if params.PN == ARRAY[i] then 
					if params.DIR == 1 then
						self:finishtweening():addx(5):linear(0.125):addx(-5);
					end;
				end;
			end;			
		};



	};
end;

--********************************
--*** 11 - PROFILE PLAYER      ***
--********************************

--* i dont want to do this ; _; 
--* little thing to show a message and reload the screen when a player joins when the active gamemode is "Basic"
--* IDK why when you join in basicmode it not go to the "ScreenJoin", it just insert the player >:(
--* This fixes the problem of the joined player with no sprites for selecting mode.
--* HELP
t[#t+1] = Def.ActorFrame
{
	LoadActor( THEME:GetPathG("","ScreenSelectMusic/default_back_1.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	};	

	LoadActor( THEME:GetPathG("","LOGO/back2.png") )..{
   		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,1;);
   	};

	Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.3);
	};


	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(glow,color("1,1,1,1");Center;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,1);
	};	

	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(blend,Blend.Add;glow,color("1,1,1,1");Center;addx,-1;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,0.6);
	};

	OnCommand=function(self)
		self:visible(false);
	end;

	PlayerJoinedMessageCommand=function(self)
		if GAMESTATE:GetGameMode() == 'Basic' then
			self:visible(true);	
			SCREENMAN:SetNewScreen( SCREENMAN:GetTopScreen():GetName() );			 
		end;
	end;			
}

t[#t+1] =  Def.ActorFrame
{
	LoadActor("profile/default")..{
		OnCommand=function(self)
			self:zoom(1.15);
			self:x(-100);
		end;
	};
}


t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:zoom(0.75);
		self:x(SCREEN_CENTER_X);
	end;


		
	LoadActor("SaniNetMusic")..
	{
		OnCommand=function(self)
		end;

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Username == '' then
		        	self:visible(false);
		        	return;
			end;
			
		end;		

		SaniNetRoomMessageCommand=function(self,params)
			if params.Username == '' then
		        	self:visible(false);
		        	return;
			end;
		end;

	};

	Def.Quad{
		InitCommand=cmd(y,SCREEN_TOP + 180;setsize,SCREEN_WIDTH,50;zoomx,0;diffuse,color('0,0,0,0');faderight,0.5;fadeleft,0.5;);
		SaniNetErrorMessageMessageCommand=function(self, params)
			if GAMESTATE:GetGameMode() == 'Basic' then
				return;
			end;
			
			if params.Message == 0 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			elseif params.Message == 1 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			elseif params.Message == 3 then
				self:finishtweening():linear(0.2):zoomx(1):diffuse(color('0,0,0,0.9')):sleep(3):linear(0.2):diffuse(color('0,0,0,0')):sleep(0):zoomx(0);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
	};
	LoadFont("normalxolonium")..{
		InitCommand=cmd(y,SCREEN_TOP + 180;shadowlength,1;shadowcolor,color("#00000");zoom,.84;diffuse,color('1,1,0,0'));
		SaniNetErrorMessageMessageCommand=function(self, params)
			if GAMESTATE:GetGameMode() == 'Basic' then
				return;
			end;

		 	if params.Message == 0 then	--on join
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Please log off from Saninet to enable two players play");
			elseif params.Message == 1 then	--on actions
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Saninet services are only available for single player");
			elseif params.Message == 3 then --on status
				self:finishtweening():sleep(0.1):linear(0.1):diffuse(color('1,1,0,1')):sleep(3):linear(0.2):diffuse(color('1,1,0,0'));
				self:settext("Saninet services are only available for single player");
			end;
		end;
		
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		
	};
}


--****************************
--*** 0 - THEME PARTS 	   ***
--****************************

t[#t+1] = LoadActor("ScreenSelectMusicLua/keyinfo")..{
		OnCommand=cmd(visible,true);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};

t[#t+1] = LoadActor("ScreenSelectMusicLua/parts")..{
		OnCommand=cmd(visible,true);
		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;				
};

--HEADER BASIC MODE
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICHEADER"))..{
		InitCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' and PREFSMAN:GetPreference("MenuTimer") == false then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;

		OnCommand=function(self)
			self:y(SCREEN_TOP+28);
			self:x(SCREEN_CENTER_X);
			self:zoom(0.6);
		end;

		FullModeMessageCommand=cmd(stoptweening;visible,false);

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};


--HEADER BASIC MODE
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/simple_basicheader"))..{
		InitCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' and PREFSMAN:GetPreference("MenuTimer") then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;

		OnCommand=function(self)
			self:y(SCREEN_CENTER_Y+20);
			self:x(SCREEN_CENTER_X);
			self:zoom(0.6);	
		end;

		FullModeMessageCommand=cmd(stoptweening;visible,false);

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;			
};

--*************************
--*** 2 - NAV ARROWS    ***
--*************************


--*************************
--*** GRAPH   ***
--*************************

t[#t+1] = LoadActor("ScreenSelectMusicLua/graphsong")..{

		OnCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FullModeMessageCommand=function(self)
			self:visible(true);
		end;

		SongChosenMessageCommand=function(self)

				if GAMESTATE:GetGameMode() ~= 'Basic' and not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
					self:visible(true);
				else
					self:visible(false);
				end;

		end;

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then
				self:diffusealpha(0);
			else
				self:diffusealpha(1);
			end;
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;		

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

};

--*************************
--*** VS   ***
--*************************
if GAMESTATE:GetNumSidesJoined() == 2 then
	t[#t+1] = LoadActor("ScreenSelectMusicLua/vsparts")..{
		OnCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				self:visible(false);
			else
				self:visible(true);
			end;

			if checkVsMode() == false then
				self:visible(false);
			else
				self:visible(true);
			end;
		end;

		FullModeMessageCommand=cmd(playcommand,"On");

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
		CheckSelectedMessageCommand=function(self,params)
			if checkVsMode() == false then
				self:visible(false);
			elseif checkVsMode() then
				self:visible(true);
			end;
		end;	

		SelectChannelMessageCommand=function(self)
			self:diffusealpha(0);
		end;

		ChannelChosenMessageCommand=function(self)
			self:linear(0.15);
			self:diffusealpha(1);
		end;

	};
end;

--*************************
--*** RANKING   ***
--*************************

local isSaninetRankingActive =false;
if GAMESTATE:GetNumSidesJoined() == 1 and #GAMESTATE:Env()["saninetUsername"] == 0 then
	Trace("::::::::::::::::::::: LOCAL RANK!")
	--t[#t+1] = LoadActor("ScreenSelectMusicLua/ranking")..{
	t[#t+1] = LoadActor("ScreenSelectMusicLua/newRank")..{
			--OnCommand=cmd(visible,true);
			OnCommand=function(self)
				if GAMESTATE:GetGameMode() ~= 'Basic' then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
			FinalizedMessageCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;		
			SongChosenMessageCommand=function(self)

				if isSaninetRankingActive then
					self:visible(false);
					return;				
				end;
				
				if GAMESTATE:GetGameMode() ~= 'Basic' then
					self:visible(true);

					if GAMESTATE:GetMusicTrainChannel()  or GAMESTATE:GetProgressiveChannel() then
						self:visible(false);
					else
						self:visible(true);
					end;
				else
					self:visible(false);
				end;


			end;

			FullModeMessageCommand=cmd(playcommand,"On");
			
			SaniNetClientStateMessageCommand=function(self,params)
				if params.Username ~= '' then
					self:visible(false);
					isSaninetRankingActive = true;			
				end;
			end;
	};
else
	Trace("::::::::::::::::::::: NO LOCAL RANK!");
	Trace("saninet id: "..GAMESTATE:Env()["saninetConnectionId"]);

end;


t[#t+1] = Def.ActorFrame{
  OnCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
    	--Trace("#######"..event.type);
    	--Trace("#######"..event.DeviceInput.button);
      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F8" then
        local top = SCREENMAN:GetTopScreen()
        top:SetNextScreenName("ScreenPlayerCustomProfile")
        top:StartTransitioningScreen("SM_GoToNextScreen")
        return true
      end
      return false
    end)
  end
}

--**********************
--** PERFORMANCE MODE **
--**********************
--this is when you want to get maximum performance when selecting songs
--sometimes videos are a problem and a very serious problem on low end hw like the mk 
--with this, people who dislike slow things or whaterver will benefit from this option.
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/performancemode"))..{
		Name="performancemode";
		InitCommand=cmd();
		OnCommand=function(self)
			self:visible(false);
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP+70);
			self:zoom(0.45);
			
		    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
		    	--Trace("#######"..event.type);
		    	--Trace("#######"..event.DeviceInput.button);
		      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F7" then
				local perfp1=false;
				local perfp2=false;

				if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
					perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
					perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");

					if perfp1 == nil then
						perfp1 = false;
					end;
					if perfp2 == nil then
						perfp2 = false;
					end;

					if perfp1 and perfp2 then
						self:visible(false);
						setCustomOptionValuePlayer(PLAYER_1,"performance_mode",false);
						setCustomOptionValuePlayer(PLAYER_2,"performance_mode",false);
					elseif perfp1 == false and perfp2 == false then
						self:visible(true);
						setCustomOptionValuePlayer(PLAYER_1,"performance_mode",true);
						setCustomOptionValuePlayer(PLAYER_2,"performance_mode",true);
					elseif perfp1 == false and perfp2 then
						self:visible(false);
						setCustomOptionValuePlayer(PLAYER_1,"performance_mode",false);
						setCustomOptionValuePlayer(PLAYER_2,"performance_mode",false);
					elseif perfp1 and perfp2 == false then
						self:visible(false);
						setCustomOptionValuePlayer(PLAYER_1,"performance_mode",false);
						setCustomOptionValuePlayer(PLAYER_2,"performance_mode",false);
					end;

				else
					if GAMESTATE:IsHumanPlayer(PLAYER_1) then
						perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
						if perfp1 == nil then
							perfp1 = false;
						end;

						if perfp1 == false then
							self:visible(true);
							setCustomOptionValuePlayer(PLAYER_1,"performance_mode",true);
							PREFSMAN:SetPreference("SongBackgrounds", false);
							fastSave();
						else
							self:visible(false);
							setCustomOptionValuePlayer(PLAYER_1,"performance_mode",false);
							PREFSMAN:SetPreference("SongBackgrounds", true);
							fastSave();
						end;
					end;

					if GAMESTATE:IsHumanPlayer(PLAYER_2) then
						perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");
						if perfp2 == nil then
							perfp2 = false;
						end;

						if perfp2 == false then
							self:visible(true);
							setCustomOptionValuePlayer(PLAYER_2,"performance_mode",true);
							PREFSMAN:SetPreference("SongBackgrounds", false);
							fastSave();
						else
							self:visible(false);
							setCustomOptionValuePlayer(PLAYER_2,"performance_mode",false);
							PREFSMAN:SetPreference("SongBackgrounds", true);
							fastSave();
						end;
					end;
				end;




		        return true
		      end
		      return false
		    end)

		    self:queuecommand("checkPerformanceMode");
		end;

		checkPerformanceModeCommand=function(self)
			local perfp1=false;
			local perfp2=false;

			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode");
				if perfp1 == nil then
					perfp1 = false;
				end;
			end;
			if GAMESTATE:IsHumanPlayer(PLAYER_2) then
				perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode");
				if perfp2 == nil then
					perfp2 = false;
				end;
			end;

			if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) and GAMESTATE:Env()["vsMode"] then
				self:y(SCREEN_TOP+109);
			end;

			if perfp1 or perfp2 then
				self:visible(true);
				PREFSMAN:SetPreference("SongBackgrounds", false);
			else
				self:visible(false);
				PREFSMAN:SetPreference("SongBackgrounds", true);
			end;
		end;

		CheckSelectedMessageCommand=function(self, params)
			if GAMESTATE:Env()["vsMode"] then
				self:y(SCREEN_TOP+109);
			else
				self:y(SCREEN_TOP+70);
			end;	
		end;

	};



t[#t+1] = Def.ActorFrame{
  OnCommand=function(self)
    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F12" then
        local top = SCREENMAN:GetTopScreen()
        top:SetNextScreenName("ScreenPlayerCustomProfile")
        top:StartTransitioningScreen("SM_GoToNextScreen")
        return true
      end
      return false
    end)
  end
}

--[[
local profilerActive = false;
t[#t+1] = LoadActor("Profiler/ProfilerBase")..{

	  OnCommand=function(self)
	  	self:visible(false);
	    	SCREENMAN:GetTopScreen():AddInputCallback(function(event)
	      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F12" then
	        if profilerActive then
	        	self:visible(false);
	        	profilerActive = false;
	        else
	        	self:visible(true);
	        	profilerActive = true;
	        end;
	      end

	    end)
	  end
};
]]

return t;