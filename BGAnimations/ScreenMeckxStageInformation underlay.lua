local t = Def.ActorFrame {
	-- automatically goes to next screen after 1 second
    OnCommand=function(self)
        self:sleep(1):queuecommand("Next")
    end,

    NextCommand=function(self)
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end
}

t[#t+1] = Def.ActorFrame {
	Def.Sprite {
		Name="songBackgroundImage";
        OnCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            if song then
                local bg = song:GetBackgroundPath()
                if bg then
                    self:Load(bg);
                    self:scaletocover(0,0,SCREEN_WIDTH/3,SCREEN_HEIGHT/3);
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y-100);
                end
            end
        end
    }
};

t[#t+1] = Def.ActorFrame {
	Name="chartDetailsInformation";
	OnCommand=function(self)
		self:visible(true);
		self:diffusealpha(1);
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);

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