if GAMESTATE:Env()["lastChannelMusic2players"] == nil then
	GAMESTATE:Env()["lastChannelMusic2players"] = "";
end;

local allMusicChannelAvailable={};
local indexMusicSelectedPlayer=1;
local inSelectChannel=false;


function splitString(str, sep)
	if #sep == nil or #sep == 0 then
		return {};
	end;
    local result = {}
    local gmatch = "([^"..sep.."]+)";
    for part in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(result, part)
    end
    return result
end

function cleanChannelSongName(fileName)
	local songProc = string.gsub(fileName, ".mp3", "");
	songProc = string.gsub(songProc, ".ogg", "");
	songProc = string.gsub(songProc, ".wav", "");
	songProc = string.gsub(songProc, "%(loop%)", "");

	local songSplit = splitString(songProc,"_");
	local nombre = "";
	local artista = "";

	if #songSplit == 2 then
		--path,name,artist
		nombre = songSplit[1];
		artista = songSplit[2];
	else
		nombre = songProc;
		artista = "V.A";
	end;

	return {nombre=nombre,artista=artista};
end;

function noneMusicSelected()
	indexMusicSelectedPlayer = 1;
end;

function prevChannelsong()
	if (indexMusicSelectedPlayer - 1) < 1 then
		indexMusicSelectedPlayer = #allMusicChannelAvailable;
	else
		indexMusicSelectedPlayer = indexMusicSelectedPlayer - 1;
	end;

	return allMusicChannelAvailable[indexMusicSelectedPlayer];
end;

function nextChannelSong()
	if (indexMusicSelectedPlayer + 1) > #allMusicChannelAvailable then
		indexMusicSelectedPlayer = 1;
	else
		indexMusicSelectedPlayer = indexMusicSelectedPlayer + 1;
	end;

	return allMusicChannelAvailable[indexMusicSelectedPlayer];
end;

function getActualChannelSong()
	return allMusicChannelAvailable[indexMusicSelectedPlayer];
end;

function registerAllMusicAvailableForChannels()
		allMusicChannelAvailable = {};
		
	  	local activeTheme = THEME:GetCurThemeName();
	  	local internalPathMusic = "/Themes/"..activeTheme.."/Sounds/xsanity/ch/";
		local externalPathMusic = GetChannelMusicExternalPath();

		local internalAudioFiles = getFilesWithPatternOnDirectory(internalPathMusic,{".mp3",".ogg",".wav"});
		local externalAudioFiles = getFilesWithPatternOnDirectory(externalPathMusic,{".mp3",".ogg",".wav"});


		table.insert(allMusicChannelAvailable,{type="internal",fullpath=internalPathMusic.."blank.ogg",audio="blank.ogg",name="none",artist="none"})
		table.insert(allMusicChannelAvailable,{type="internal",fullpath=internalPathMusic.."default (loop).ogg",audio="default (loop).ogg",name="Default",artist="v.a"})

		for i = 1, #internalAudioFiles do
			local songData = cleanChannelSongName(internalAudioFiles[i]);
			if internalAudioFiles[i] ~= "blank.ogg" and internalAudioFiles[i] ~= "default (loop).ogg" then
				local fullpathMusic = internalPathMusic..internalAudioFiles[i];
				table.insert(allMusicChannelAvailable,{type="internal",fullpath=fullpathMusic,audio=internalAudioFiles[i],name=songData["nombre"],artist=songData["artista"]})
			;end
		end;

		for i = 1, #externalAudioFiles do
			local songData = cleanChannelSongName(externalAudioFiles[i]);
			local fullpathMusic = externalPathMusic..externalAudioFiles[i];
			table.insert(allMusicChannelAvailable,{type="external",fullpath=fullpathMusic,audio=externalAudioFiles[i],name=songData["nombre"],artist=songData["artista"]})
		end;
end;

function saveMusicSelectedPlayer(player,song,type)
	setCustomOptionValuePlayer(player,"channelMusic",song);
	setCustomOptionValuePlayer(player,"channelMusic_type",type);
end;

function formatTextMaxLengh(text)
	if #text > 30 then
		local sub = string.sub(text, 1, 27);
		return sub.."...";
	end;
end;

function getMusicForChannelPlayer()
	Trace("###################################----------------> music");
	registerAllMusicAvailableForChannels();
	--we check what player is playing, if there is 1 player, we only choose that song
	--if there are 2 players we alternate the song, because both players needs love

	--we find what music is configured to the player.
	local musicChannelMusic = "";
	local musicChannelMusicType = "";
	local pathMusic = "";

	if GAMESTATE:GetNumSidesJoined() == 1 then
		
		local playerActive = nil;
		if GAMESTATE:IsSideJoined(PLAYER_1) then
			playerActive = PLAYER_1
		else
			playerActive = PLAYER_2
		end;

		musicChannelMusic = getCustomOptionValuePlayer(playerActive,"channelMusic");
		musicChannelMusicType = getCustomOptionValuePlayer(playerActive,"channelMusic_type");
	else

		if GAMESTATE:Env()["lastChannelMusic2players"] == "" then
			musicChannelMusic = getCustomOptionValuePlayer(PLAYER_1,"channelMusic");
			musicChannelMusicType = getCustomOptionValuePlayer(PLAYER_1,"channelMusic_type");
			GAMESTATE:Env()["lastChannelMusic2players"] = "p1";
		else
			if GAMESTATE:Env()["lastChannelMusic2players"] == "p1" then
				musicChannelMusic = getCustomOptionValuePlayer(PLAYER_2,"channelMusic");
				musicChannelMusicType = getCustomOptionValuePlayer(PLAYER_2,"channelMusic_type");
				GAMESTATE:Env()["lastChannelMusic2players"] = "p2";
			elseif GAMESTATE:Env()["lastChannelMusic2players"] == "p2" then
				musicChannelMusic = getCustomOptionValuePlayer(PLAYER_1,"channelMusic");
				musicChannelMusicType = getCustomOptionValuePlayer(PLAYER_1,"channelMusic_type");
				GAMESTATE:Env()["lastChannelMusic2players"] = "p1";
			end;

		end;

	end;

	if musicChannelMusic == nil or musicChannelMusic == "" or musicChannelMusic == "-" then
		--default
		musicChannelMusic = "default (loop).ogg";
		musicChannelMusicType = "internal";		
	end;
	--preparamos el path
	if musicChannelMusicType == "internal" then
	  	local activeTheme = THEME:GetCurThemeName();
	  	pathMusic = "/Themes/"..activeTheme.."/Sounds/xsanity/ch/"..musicChannelMusic;	  	
	else
		pathMusic = "/Mods/ChannelMusic/"..musicChannelMusic;
	end;

	--we check if the file exist
	if FILEMAN:DoesFileExist(pathMusic) == false then
		--here we put everything to default
		musicChannelMusic = "default (loop).ogg";
		pathMusic = THEME:GetPathS("","xsanity/ch/"..musicChannelMusic);
		if GAMESTATE:GetNumSidesJoined() == 1 then
			local pActive = nil;
			if GAMESTATE:IsSideJoined(PLAYER_1) then
				pActive = PLAYER_1
			else
				pActive = PLAYER_2
			end;		    		
			saveMusicSelectedPlayer(pActive,musicChannelMusic,"internal");
			indexMusicSelectedPlayer = 2;
		end;
	else
		--what index of the songs is this file.
		for i=1,#allMusicChannelAvailable do
			if allMusicChannelAvailable[i]["audio"] == musicChannelMusic then
				indexMusicSelectedPlayer = i;
	    		if GAMESTATE:GetNumSidesJoined() == 1 then
					local pActive = nil;
					if GAMESTATE:IsSideJoined(PLAYER_1) then
						pActive = PLAYER_1
					else
						pActive = PLAYER_2
					end;		    		
					local actualSongData = getActualChannelSong();	
	    			saveMusicSelectedPlayer(pActive,actualSongData["audio"],actualSongData["type"]);
	    		end;
			end;
		end;
	end;




	--

	local songData = cleanChannelSongName(musicChannelMusic);
	local nombre = songData["nombre"];
	local artista = songData["artista"];


	return Def.ActorFrame{

		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			--self:y(SCREEN_CENTER_Y+270);
			self:y(SCREEN_CENTER_Y+270);
			self:diffusealpha(0);
			self:zoom(0.8);
		end;

		OnCommand=function(self)
		    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
			      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F5" then

			      	if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingChannel' then

				      	--we change the song.
				      	local prevSongData = prevChannelsong();
				      	self:GetChild("MusicChannelBack"):stoptweening():stop():load(prevSongData["fullpath"]):play();
				      	self:GetChild("nameSong"):stoptweening():diffusealpha(0):x(30):settext(prevSongData["name"]):linear(0.1):diffusealpha(1):x(0);
			    		self:GetChild("aristSong"):stoptweening():diffusealpha(0):x(30):settext(prevSongData["artist"]):linear(0.1):diffusealpha(1):x(0);
			    		self:GetChild("numSongs"):settext(indexMusicSelectedPlayer.."/"..#allMusicChannelAvailable);
			    		self:GetChild("fbackk"):stoptweening():linear(0.05):zoom(0.7):linear(0.05):zoom(0.75);

			    		if indexMusicSelectedPlayer == 1 then
			    			self:GetChild("nameSong"):settext("none");
			    			self:GetChild("aristSong"):settext("none");
			    		end;

			    		--solo si hay 1 player, cuando hay 2, no modificamos.
			    		if GAMESTATE:GetNumSidesJoined() == 1 then
							local pActive = nil;
							if GAMESTATE:IsSideJoined(PLAYER_1) then
								pActive = PLAYER_1
							else
								pActive = PLAYER_2
							end;		    			
			    			saveMusicSelectedPlayer(pActive,prevSongData["audio"],prevSongData["type"]);
			    		end;

				        return true

			      	end


			      end

			      if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F6" then

			      	if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingChannel' then
				      	--we change the song.			      	
				      	local nextSongData = nextChannelSong();
				      	self:GetChild("MusicChannelBack"):stoptweening():stop():load(nextSongData["fullpath"]):play();
				      	self:GetChild("nameSong"):stoptweening():diffusealpha(0):x(-30):settext(nextSongData["name"]):linear(0.1):diffusealpha(1):x(0);
			    		self:GetChild("aristSong"):stoptweening():diffusealpha(0):x(-30):settext(nextSongData["artist"]):linear(0.1):diffusealpha(1):x(0);
			    		self:GetChild("numSongs"):settext(indexMusicSelectedPlayer.."/"..#allMusicChannelAvailable);
			    		self:GetChild("fadvk"):stoptweening():linear(0.05):zoom(0.7):linear(0.05):zoom(0.75);

			    		if indexMusicSelectedPlayer == 1 then
			    			self:GetChild("nameSong"):settext("none");
			    			self:GetChild("aristSong"):settext("none");
			    		end;

			    		--solo si hay 1 player, cuando hay 2, no modificamos.		    		
			    		if GAMESTATE:GetNumSidesJoined() == 1 then
							local pActive = nil;
							if GAMESTATE:IsSideJoined(PLAYER_1) then
								pActive = PLAYER_1
							else
								pActive = PLAYER_2
							end;		    			
			    			saveMusicSelectedPlayer(pActive,nextSongData["audio"],nextSongData["type"]);
			    		end

				        return true
				    end

			      end
		      return false
		    end)	

		    if indexMusicSelectedPlayer > 1 then
			    self:GetChild("MusicChannelBack"):play():pause(true);
		    else
		    	self:GetChild("MusicChannelBack"):stop();
			end;

	    	self:GetChild("backNowPlaying"):visible(true);
	    	self:GetChild("nameSong"):visible(true);
	    	self:GetChild("aristSong"):visible(true);		


			if indexMusicSelectedPlayer == 1 then
				self:GetChild("nameSong"):settext("none");
				self:GetChild("aristSong"):settext("none");
			end;	

		end;

		SelectChannelMessageCommand=function(self)
		    if indexMusicSelectedPlayer > 1 then
		    	self:GetChild("MusicChannelBack"):pause(false);
			end;			
			self:stoptweening():y(SCREEN_CENTER_Y+230):linear(0.18):y(SCREEN_CENTER_Y+290):diffusealpha(1);		    				
		end;

		ChannelChosenMessageCommand=function(self)
		    if indexMusicSelectedPlayer > 1 then
		    	self:GetChild("MusicChannelBack"):pause(true);		    	
			end;
			self:stoptweening():y(SCREEN_CENTER_Y+290):linear(0.1):y(SCREEN_CENTER_Y+230):diffusealpha(0);
		end;

		OffCommand=function(self)
		    if indexMusicSelectedPlayer > 1 then
		    	self:GetChild("MusicChannelBack"):stop();
			end;
		end;

		LoadActor(pathMusic) .. {
			Name="MusicChannelBack";
		};

		--we add the frame only if it has info, if not, meh
		--[[
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/nowplaying"))..{
			Name="backNowPlaying";
			InitCommand=function(self)
				self:diffusealpha(1);
				self:zoom(0.7);
			end;
		};
		]]

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/djnowplaying"))..{
			Name="backNowPlaying";
			InitCommand=function(self)
				self:diffusealpha(1);
				self:y(-15);
				self:zoom(0.8);
			end;
		};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/lightturntable"))..{
			InitCommand=function(self)
				self:diffusealpha(0.4);
				self:x(-105);
				self:y(-38);
				self:zoom(0.75);
			end;
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/redlightturntable"))..{
			InitCommand=function(self)
				self:diffusealpha(0.4);
				self:x(103);
				self:y(-38);
				self:zoom(0.75);
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/lightturntable"))..{
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(-105);
				self:y(-38);
				self:zoom(0.75);
				self:blend("BlendMode_Add");
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:linear(0.8);
				self:diffusealpha(0);
				self:linear(0.8);
				self:diffusealpha(1);
				self:queuecommand("Ani");
			end;
			OffCommand=function(self)
			    self:stoptweening();
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/btnred"))..{
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(-116);
				self:y(13);
				self:zoom(0.9);
				self:diffusealpha(1);
			end;
			OffCommand=function(self)
			    self:stoptweening();
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/btnred"))..{
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(129);
				self:y(14);
				self:zoom(0.9);
				self:diffusealpha(1);
			end;
			OffCommand=function(self)
			    self:stoptweening();
			end;
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/btnred"))..{
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(-156);
				self:y(13);
				self:zoom(0.9);
				--self:blend("BlendMode_Add");
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:linear(0.8);
				self:diffusealpha(0.2);
				self:linear(1.2);
				self:diffusealpha(0.9);
				self:queuecommand("Ani");
			end;
			OffCommand=function(self)
			    self:stoptweening();
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/btnred"))..{
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(156);
				self:y(14);
				self:zoom(0.9);
				--self:blend("BlendMode_Add");
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:linear(0.8);
				self:diffusealpha(0.2);
				self:linear(1.2);
				self:diffusealpha(0.9);
				self:queuecommand("Ani");
			end;
			OffCommand=function(self)
			    self:stoptweening();
			end;
		};

		Def.Quad {
			InitCommand=cmd(zoomto,200,18;diffuse,color("#363636");y,-40;diffusealpha,0.8);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/f5k"))..{
			Name="fbackk";
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(-76);
				self:y(13);
				self:zoom(0.75);
			end;
		};	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ChannelMusic/f6k"))..{
			Name="fadvk";
			InitCommand=function(self)
				self:diffusealpha(1);
				self:x(76);
				self:y(13);
				self:zoom(0.75);
			end;
		};	

		LoadFont("_TitleXolonium")..{
			Name="headerDj";
			Text="NOW PLAYING";
			InitCommand=cmd(zoom,0.35;horizalign,center;y,-42);
		};

		LoadFont("_TitleXolonium")..{
			Name="numSongs";
			Text=indexMusicSelectedPlayer.."/"..#allMusicChannelAvailable;
			InitCommand=cmd(zoom,0.4;horizalign,center;x,0;y,13);
		};			

		LoadFont("_TitleXolonium")..{
			Name="nameSong";
			Text=nombre;
			InitCommand=cmd(zoom,0.35;horizalign,center;y,-24);
		};

		LoadFont("_TitleXolonium")..{
			Name="aristSong";
			Text=artista;
			InitCommand=cmd(zoom,0.35;horizalign,center;y,-8);
		};		

	};
end;

local t = Def.ActorFrame { };
t[#t+1] = getMusicForChannelPlayer();

return t;