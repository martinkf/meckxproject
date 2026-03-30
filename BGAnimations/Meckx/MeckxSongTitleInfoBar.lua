return function(params)

	-- params
	local entireY = params.YPosition -- Y positioning of the entire module
	-- levers
	local upperInfoY = -39; -- Y alignment of the upper info bar part
	local songTitleY = -4; -- Y aligment of the big song title part
	local lowerInfoY = 39; -- Y alignment of the lower info bar part

	-- drawing
	local t = Def.ActorFrame {};

	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			self:y(entireY)
			self:playcommand("UpdateInfo")
		end;
		SelectChannelMessageCommand=function(self)
			self:visible(false)
		end;
		ChannelChosenMessageCommand=function(self)
			self:visible(true)
		end;
		CurrentSongChangedMessageCommand=function(self)
			self:playcommand("UpdateInfo")
		end;
		UpdateInfoCommand=function(self)
			-- LOGIC

			--preliminary references
			local currentSong = GAMESTATE:GetCurrentSong();
			local songTitle = currentSong:GetDisplayMainTitle();
			local songArtist = currentSong:GetDisplayArtist();
			local songDisplayBpm = "BPM " .. ProcessBPM(currentSong:GetCustomBPM());
			local songOrigin = currentSong:GetOrigin();
			local songCategoryUnformatted = currentSong:GetCategory();
			local songCategoryFormatted = Meckx_FetchFromSong(currentSong,"Song Formatted Category");

			--local isRandomChannel = GAMESTATE:GetRandomChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetSurvivalChannel();
			-- changing this so new StageInformation screen for Survival can display song info
			local isNotASong = Meckx_IsThisASong(currentSong)
			
			--adaptations
			if isNotASong then --this means you're hovering over a musicwheel item that's not really a song
				self:GetChild("EntireBG"):visible(false);
				self:GetChild("SongTitle"):visible(false);
				self:GetChild("UpperDot"):visible(false);
				self:GetChild("LowerDot"):visible(false);
			else
				self:GetChild("EntireBG"):visible(true);
				self:GetChild("SongTitle"):visible(true);
				self:GetChild("UpperDot"):visible(true);
				self:GetChild("LowerDot"):visible(true);
			end


			--old logic for reference
			--if isRandomChannel or (currentSong and songOrigin == "RANDOMXX") then
				--if GAMESTATE:GetSurvivalChannel() and currentSong then
					--donothing
				--else
					--songtitle = "?????";
				--end;
			--elseif currentSong then
				--get real information about a train
				--bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
				--songartist = GAMESTATE:GetCurrentSong():GetDisplayArtist();

				--if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
					--local dataTrain = getTrainProgresiveInfoLess();
					--bpmActual = "BPM " .. ProcessBPM(dataTrain.bpm);
					--songartist = "V.A";
					--durationSong = dataTrain.duration > 0 and SecondsToMMSS(dataTrain.duration) or "";
				--end;
			--else
				--songtitle = "?????";
			--end;

			--new logic

			-- UPDATING SONG TITLE			
			self:GetChild("SongTitle"):settext(songTitle);

			-- UPDATING SONG CATEGORY + SONG ARTIST
			self:GetChild("UpperDot"):settext(songCategoryFormatted.." • "..songArtist);
			self:GetChild("UpperDot"):diffuse(GetColor_POI(songCategoryUnformatted))
			-- UPDATING SONG ORIGIN + SONG BPM
			self:GetChild("LowerDot"):settext(songOrigin.." • "..songDisplayBpm);
			self:GetChild("LowerDot"):diffuse(GetColor_POI(songOrigin))

			-- START ANIMATION
			self:playcommand("StartShowAnimation")
		end;
		StartShowAnimationCommand=function(self)
			self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1)
		end;

		Def.Quad {
			Name="EntireBG";
			InitCommand=function(self)
				self:x(0)
				self:y(0)
				self:valign(0.5)
				self:setsize(1200,108)
				self:diffuse(0,0,0,0.7)
				self:fadeleft(0.2)
				self:faderight(0.2)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="SongTitle";
			Text="SongName Test";
			InitCommand=function(self)
				self:x(0)
				self:y(songTitleY)
				self:zoom(1.5)
				self:maxwidth(680)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="UpperDot";
			Text="•";
			InitCommand=function(self)
				self:x(0)
				self:y(upperInfoY)
				self:halign(0.5)
				self:zoom(0.5)
				self:diffuse(color("#c9c9C9"))
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="LowerDot";
			Text="•";
			InitCommand=function(self)
				self:x(0)
				self:y(lowerInfoY)
				self:halign(0.5)
				self:zoom(0.5)
				self:diffuse(color("#c9c9C9"))
			end;
		};

	};

	return t

end