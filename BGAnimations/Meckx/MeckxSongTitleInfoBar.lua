return function(params)

	-- params
	local entireY = params.YPosition -- Y positioning of the entire module
	-- levers
	local upperInfoY = 19; -- Y alignment of the upper info bar part
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
			local currentSong = GAMESTATE:GetCurrentSong()
			local isRandomChannel = GAMESTATE:GetRandomChannel() or GAMESTATE:GetRandomTrainChannel() or GAMESTATE:GetSurvivalChannel()

			local songartist = "???"
			local bpmActual = "BPM ???"
			local durationSong = "??:??"
			local songOrigin = GAMESTATE:GetCurrentSong():GetOrigin();
			
			-- UPDATING SONG TITLE
			if isRandomChannel or (currentSong and currentSong:GetOrigin() == "RANDOMXX") then
				if GAMESTATE:GetSurvivalChannel() and currentSong then
					local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("SongTitle"):settext(songtitle);
				else
					self:GetChild("SongTitle"):settext("?????");
				end;
			elseif currentSong then
				local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
					self:GetChild("SongTitle"):settext(songtitle );
					
				--get real information about a train


				bpmActual = "BPM " .. ProcessBPM(GAMESTATE:GetCurrentSong():GetCustomBPM());
				songartist = GAMESTATE:GetCurrentSong():GetDisplayArtist();
				--songcategory = GAMESTATE:GetCurrentSong():GetCategory();
				songcategory = CHGetCategory(0)
				local MusicLength = GAMESTATE:GetCurrentSong():MusicLengthSeconds() or 0;
				durationSong = MusicLength > 0 and SecondsToMMSS(MusicLength) or "";

				if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
					local dataTrain = getTrainProgresiveInfoLess();
					bpmActual = "BPM " .. ProcessBPM(dataTrain.bpm);
					songartist = "V.A";
					durationSong = dataTrain.duration > 0 and SecondsToMMSS(dataTrain.duration) or "";
				end;
			else
				self:GetChild("SongTitle"):settext("?????");
			end;

			-- UPDATING SONG ARTIST
			self:GetChild("SongArtist"):settext(songartist);

			-- UPDATING SONG BPM
			self:GetChild("SongBPM"):settext(bpmActual);

			-- UPDATING SONG CATEGORY
			self:GetChild("SongCategory"):settext(songcategory);

			-- UPDATING SONG ORIGIN
			self:GetChild("SongOrigin"):settext(songOrigin);

			-- START ANIMATION
			self:playcommand("StartShowAnimation")
		end;
		StartShowAnimationCommand=function(self)
			self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1)
		end;

		Def.Quad {
			InitCommand=function(self)
				self:x(0)
				self:y(0)
				self:valign(0.5)
				self:setsize(SCREEN_WIDTH-110,108)
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
				self:y(-25)
				self:zoom(1.5)
				self:maxwidth(960)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="SongArtist";
			Text="SongArtist Test";
			InitCommand=function(self)
				self:x(-12)
				self:y(upperInfoY)
				self:halign(1)
				self:zoom(0.5)
				self:diffuse(color("#FFE7C9"))
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
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="SongBPM";
			Text="BPM 0";
			InitCommand=function(self)
				self:x(12)
				self:y(upperInfoY)
				self:halign(0)
				self:zoom(0.5)
				self:diffuse(color("#C9FFF3"))
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="SongCategory";
			Text="SongCategory Test";
			InitCommand=function(self)
				self:x(-12)
				self:y(lowerInfoY)
				self:halign(1)
				self:zoom(0.5)
				self:diffuse(color("#C9FFC9"))
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
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="SongOrigin";
			Text="SongOrigin Test";
			InitCommand=function(self)
				self:x(12)
				self:y(lowerInfoY)
				self:halign(0)
				self:zoom(0.5)
				self:diffuse(color("#FFC9EA"))
			end;
		};

	};

	return t

end