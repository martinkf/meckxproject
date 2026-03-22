local t = Def.ActorFrame {
	-- automatically goes to next screen after 1 second
    OnCommand=function(self)
        self:sleep(4):queuecommand("Next")
    end,

    NextCommand=function(self)
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end,
}

t[#t+1] = Def.ActorFrame {
	Def.Sprite {
		Name="VideoBackground",
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			self:y(SCREEN_CENTER_Y)
		end,
		OnCommand=function(self)
			self:Load(THEME:GetPathG("","commonBackground/bbluesm.mp4"))
			self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
			self:play()
		end,
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X)
		self:y(1)
	end;

	Def.Quad {
		Name="BeReadyQuad";
		InitCommand=function(self)
			self:valign(0)
			self:setsize(670,48)
			self:diffuse(0,0,0,0.9)
			self:fadeleft(0.2)
			self:faderight(0.2)
		end;
	};

	LoadFont("_TitleXolonium")..{
		Name="BeReadyText";
		Text="BE READY FOR...";
		InitCommand=function(self)
			self:y(22)
			self:valign(0.5)
			self:zoom(1.5)
			self:diffuse(1,0,0,1)
			self:maxwidth(960)
		end;
	};
};

t[#t+1] =  LoadActor("Meckx/MeckxSongTitleInfoBar.lua")( { YPosition = 136 } );

t[#t+1] = Def.ActorFrame {
	Def.Quad {
		Name="BottomMeckxArt";
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			self:y(SCREEN_BOTTOM-12)
			self:zoomto(SCREEN_WIDTH,24)
			self:diffuse(0,0,0,0.9)
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:y(SCREEN_CENTER_Y-38)
		self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1)
	end;

	Def.Quad {
		Name="SongImageBackgroundBox";
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			self:zoomto(438,252)
			self:diffuse(0,0,0,0.8)
		end;
	};

	Def.Sprite {
		Name="SongImageDuplicateFor43";
        OnCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                local bg = song:GetBackgroundPath()
                if bg then
                    self:Load(bg)
					self:x(SCREEN_CENTER_X)
					self:zoomto(426,240)
					self:diffuse(0.3,0.3,0.3,1)
                end
            end
        end
    };

	Def.Sprite {
		Name="SongImage";
        OnCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                local bg = song:GetBackgroundPath()
                if bg then
                    self:Load(bg)
					self:x(SCREEN_CENTER_X)
					local targetH = 240
					self:zoom( targetH / self:GetHeight() )
                end
            end
        end
    };
};

t[#t+1] = Def.ActorFrame {
	Name="chartDetailsInformation";
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y+290);

		if GAMESTATE:IsSideJoined(PLAYER_1) then
			local CurrentStepP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);

			-- CHART MAIN NAME
			local chartMainNamePlayer1 = Meckx_FetchFromChart(CurrentStepP1, "Chart Original Name")
			self:GetChild("chartMainNamePlayer1"):settext(chartMainNamePlayer1);

			-- CHART ORIGINAL NAME
			local chartOriginalNamePlayer1 = Meckx_FetchFromChart(CurrentStepP1, "Chart Original Name")
			self:GetChild("chartOriginalNamePlayer1"):settext("Originally called \""..chartOriginalNamePlayer1.."\"");

			-- CHART AUTHOR
			local chartAuthorPlayer1 = Meckx_FetchFromChart(CurrentStepP1, "Chart Author");
			self:GetChild("chartAuthorPlayer1"):settext(chartAuthorPlayer1);

			-- CHART ORIGIN
			local chartOriginPlayer1 = Meckx_FetchFromChart(CurrentStepP1, "Chart Origin")
			self:GetChild("chartOriginPlayer1"):settext("Chart debut in "..chartOriginPlayer1);

			-- CHART LEVEL
			local chartLevelPlayer1 = Meckx_FetchFromChart(CurrentStepP1, "Chart Level")
			self:GetChild("chartLevelPlayer1"):settext("Lvl. "..chartLevelPlayer1);
		end;

		if GAMESTATE:IsSideJoined(PLAYER_2) then
			local CurrentStepP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);

			-- CHART MAIN NAME
			local chartMainNamePlayer2 = Meckx_FetchFromChart(CurrentStepP2, "Chart Original Name")
			self:GetChild("chartMainNamePlayer2"):settext(chartMainNamePlayer2);

			-- CHART ORIGINAL NAME
			local chartOriginalNamePlayer2 = Meckx_FetchFromChart(CurrentStepP2, "Chart Original Name")
			self:GetChild("chartOriginalNamePlayer2"):settext("Originally called \""..chartOriginalNamePlayer2.."\"");

			-- CHART AUTHOR
			local chartAuthorPlayer2 = Meckx_FetchFromChart(CurrentStepP2, "Chart Author");
			self:GetChild("chartAuthorPlayer2"):settext(chartAuthorPlayer2);

			-- CHART ORIGIN
			local chartOriginPlayer2 = Meckx_FetchFromChart(CurrentStepP2, "Chart Origin")
			self:GetChild("chartOriginPlayer2"):settext("Chart debut in "..chartOriginPlayer2);

			-- CHART LEVEL
			local chartLevelPlayer2 = Meckx_FetchFromChart(CurrentStepP2, "Chart Level")
			self:GetChild("chartLevelPlayer2"):settext("Lvl. "..chartLevelPlayer2);
		end;

		self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1)

	end;

	LoadFont("_prime")..{
		Name="chartMainNamePlayer1";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer1;y,LoadingDifficultyDetails_YAnchor;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartOriginalNamePlayer1";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer1;y,LoadingDifficultyDetails_YAnchor+40;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartAuthorPlayer1";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer1;y,LoadingDifficultyDetails_YAnchor+80;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartOriginPlayer1";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer1;y,LoadingDifficultyDetails_YAnchor+120;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartLevelPlayer1";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer1;y,LoadingDifficultyDetails_YAnchor+160;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartMainNamePlayer2";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer2;y,LoadingDifficultyDetails_YAnchor;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartOriginalNamePlayer2";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer2;y,LoadingDifficultyDetails_YAnchor+40;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartAuthorPlayer2";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer2;y,LoadingDifficultyDetails_YAnchor+80;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartOriginPlayer2";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer2;y,LoadingDifficultyDetails_YAnchor+120;zoom,0.8;horizalign,center);
	};

	LoadFont("_prime")..{
		Name="chartLevelPlayer2";
		OnCommand=cmd(x,LoadingDifficultyDetails_XPlayer2;y,LoadingDifficultyDetails_YAnchor+160;zoom,0.8;horizalign,center);
	};

};

return t;