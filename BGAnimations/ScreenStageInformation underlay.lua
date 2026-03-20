local function GetPath()
	local bgpath = GAMESTATE:GetCurrentSong():GetBackgroundPath();
	
	if not bgpath then
		return (THEME:GetPathG("Common", "fallback background"));
	else
		
		-- Fix anti-idiotas, para futuros wns que quieran hacer steps y no pongan el '/' antes para redir
		local str = string.sub (bgpath, 1, 6);
		str = string.lower(str);
		if str == "songs/" then
			return "/" .. bgpath;
		end;
	
		if FILEMAN:DoesFileExist(bgpath) then
			return bgpath;
		else
			return (THEME:GetPathG("Common", "fallback background"));
		end;
	end;
end;

function Actor:TITLE()
	local ratio = PREFSMAN:GetPreference("DisplayAspectRatio");
	local stretchBG = PREFSMAN:GetPreference("StretchBackgrounds")
	
	if (ratio > 1.5) then
		if stretchBG then
			self:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT )
		else
			self:scaletofit(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
	else
		self:scale_or_crop_background();
	end;
end;

function Actor:MECKXTITLE()
	self:scaletofit(0,0,SCREEN_WIDTH/3,SCREEN_HEIGHT/3);
	self:x(SCREEN_CENTER_X);
	self:y(SCREEN_CENTER_Y-100);
end;

local t = Def.ActorFrame { };

t[#t+1] = LoadActor(GetPath())..{
	InitCommand=cmd(MECKXTITLE);
	--FinalizedMessageCommand=function(self)
		--self:stoptweening():linear(0.05):diffusealpha(0);
	--end;

	--OffCommand=function(self)
		--self:stoptweening():linear(0.05):diffusealpha(0);
	--end;
};

t[#t+1] = Def.ActorFrame { 
		OnCommand=function(self)
			self:visible(true);
			self:diffusealpha(1);
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+310);

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

		--FinalizedMessageCommand=function(self)
			--self:stoptweening():linear(0.05):diffusealpha(0);
		--end;

		--OffCommand=function(self)
			--self:stoptweening():linear(0.05):diffusealpha(0);
		--end;

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