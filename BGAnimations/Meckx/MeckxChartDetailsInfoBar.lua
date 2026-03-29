return function(params)

	-- params
	local basalX = params.XBasal -- X positioning, offsetting both players
	local biasedX = params.XBiased -- X positioning, biased for each player
	local entireY = params.YPosition -- Y positioning of the entire module
	local p = params.Player -- -1 for PLAYER_1, 1 for PLAYER_2
	local relevantPlayer = (p == -1) and PLAYER_1 or PLAYER_2

	-- levers
	local upperInfoY = -39; -- Y alignment of the upper info bar part
	local mainTextY = -4; -- Y aligment of the big chart title part
	local lowerInfoY = 39; -- Y alignment of the lower info bar part
	local arrowDistance = 280 -- distance from the arrows to the center of the infobar
	local arrowStrength = 10 -- amount of pixels the arrow move when pressed
	local arrowColor = (relevantPlayer == PLAYER_1) and {1,0,1,1} or {0,1,1,1}

	-- drawing
	local t = Def.ActorFrame {};

	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self)
			self:x( (basalX) + (p*biasedX) )
			self:y(entireY)
			self:playcommand("UpdateInfoWithAnimation")
		end;

		SongChosenMessageCommand=function(self)
			self:finishtweening():y(entireY):linear(0.25):y(entireY-500)
			self:playcommand("UpdateInfo")
		end;

		SongUnchosenMessageCommand=function(self)
			self:finishtweening():y(entireY-500):linear(0.125):y(entireY)
		end;

		ChangeStepsMessageCommand=function(self)
			self:playcommand("UpdateInfo")
		end;

		UpdateInfoCommand=function(self)
			-- LOCAL VARIABLES
			local thisChart = GAMESTATE:GetCurrentSteps(relevantPlayer);
			local thisChartType = Meckx_FetchFromChart(thisChart, "Chart Type")
			local thisChartLevel = Meckx_FetchFromChart(thisChart, "Chart Level")

			-- UPDATING CHART MAIN NAME
			local chartMainNameText
			if thisChartType == "Single" then chartMainNameText = "S"
			elseif thisChartType == "Halfdouble" then chartMainNameText = "HD"
			elseif thisChartType == "Double" then chartMainNameText = "D"
			elseif thisChartType == "Double_P" then chartMainNameText = "CO-OP 2P (LEVEL " end
			chartMainNameText = chartMainNameText..thisChartLevel
			if thisChartType == "Double_P" then chartMainNameText = chartMainNameText..")" end

			local chartMainNameColor
			chartMainNameColor = Meckx_FetchFromChart(thisChart, "Color based on Chart Type")
			local chartColorSoft
			chartColorSoft = Meckx_FetchFromChart(thisChart, "Color based on Chart Type Soft")

			self:GetChild("ChartMainName"):settext(chartMainNameText);
			self:GetChild("ChartMainName"):diffuse(chartMainNameColor);

			-- UPDATING CHART AUTHOR
			local chartAuthorText
			chartAuthorText = Meckx_FetchFromChart(thisChart, "Chart Author")
			self:GetChild("ChartAuthor"):settext(chartAuthorText);
			self:GetChild("ChartAuthor"):diffuse(chartColorSoft);

			-- UPDATING CHART ORIGIN AND ORIGINAL NAME
			local chartOriginText
			chartOriginText = Meckx_FetchFromChart(thisChart, "Chart Origin")
			
			local chartOriginalNameTextUnformatted
			local chartOriginalNameTextFormatted = ""
			chartOriginalNameTextUnformatted = Meckx_FetchFromChart(thisChart, "Chart Original Name")
			if chartOriginalNameTextUnformatted == chartMainNameText or
				chartOriginalNameTextUnformatted == "CO-OP 2P"
			then
				self:GetChild("LowerDot"):settext(chartOriginText);
			else
				--chartOriginalNameTextFormatted = "Originally called \""..chartOriginalNameTextUnformatted.."\""
				chartOriginalNameTextFormatted = " • \""..chartOriginalNameTextUnformatted.."\""
				self:GetChild("LowerDot"):settext(chartOriginText..chartOriginalNameTextFormatted);
			end
			self:GetChild("LowerDot"):diffuse(chartColorSoft);

			-- UPDATING YOUR MOTHER
			
		end;
		StartShowAnimationCommand=function(self)
			self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1)
		end;
		UpdateInfoWithAnimationCommand=function(self)
			self:playcommand("UpdateInfo")
			self:playcommand("StartShowAnimation")
		end;

		Def.Quad {
			InitCommand=function(self)
				self:x(0)
				self:y(0)
				self:valign(0.5)
				self:setsize(600,108)
				self:diffuse(0,0,0,0.7)
				self:fadeleft(0.2)
				self:faderight(0.2)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="ChartMainName";
			Text="Testing test";
			InitCommand=function(self)
				self:x(0)
				self:y(mainTextY)
				self:zoom(1.5)
				self:maxwidth(340)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="ChartAuthor";
			Text="ChartAuthor Test";
			InitCommand=function(self)
				self:x(0)
				self:y(upperInfoY)
				self:halign(0.5)
				self:zoom(0.5)
				--self:diffuse(color("#FFE7C9"))
				self:maxwidth(980)
			end;
		};

		--LoadFont("_TitleXolonium")..{
			--Name="ChartOrigin";
			--Text="ChartOrigin Test";
			--InitCommand=function(self)
				--self:x(-12)
				--self:y(lowerInfoY)
				--self:halign(1)
				--self:zoom(0.5)
				--self:diffuse(color("#C9FFC9"))
				--self:diffuse(color("#FFE7C9"))
				--self:maxwidth(490)
			--end;
		--};

		LoadFont("_TitleXolonium")..{
			Name="LowerDot";
			Text="•";
			InitCommand=function(self)
				self:x(0)
				self:y(lowerInfoY)
				self:halign(0.5)
				self:zoom(0.5)
				--self:diffuse(color("#FFE7C9"))
			end;
		};
		
		--LoadFont("_TitleXolonium")..{
			--Name="ChartOriginalName";
			--Text="ChartOriginalName Test";
			--InitCommand=function(self)
				--self:x(12)
				--self:y(lowerInfoY)
				--self:halign(0)
				--self:zoom(0.5)
				--self:diffuse(color("#FFC9EA"))
				--self:diffuse(color("#FFE7C9"))
				--self:maxwidth(490)
			--end;
		--};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
			Name="LeftArrow";
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(relevantPlayer))
				self:rotationy(-180)
				self:animate(false)
				self:x(-arrowDistance)
				self:y(0)
				self:zoom(0)
				self:diffuse(arrowColor)
			end;

			SongChosenMessageCommand=function(self)
				self:finishtweening()
				self:linear(0.125)
				self:zoom(1)
			end;
			SongUnchosenMessageCommand=function(self)
				self:finishtweening()
				self:linear(0.125)
				self:zoom(0)
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player == relevantPlayer then
					if params.Direction == 1 then
						self:finishtweening():x(-arrowDistance):sleep(0.25);
					end;
					if params.Direction == -1 then
						self:finishtweening():x(-arrowDistance):linear(0.125):x(-arrowDistance-arrowStrength):linear(0.125):x(-arrowDistance);
					end;
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
			Name="RightArrow";
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(relevantPlayer))
				self:animate(false)
				self:x(arrowDistance)
				self:y(0)
				self:zoom(0)
				self:diffuse(arrowColor)
			end;

			SongChosenMessageCommand=function(self)
				self:finishtweening()
				self:linear(0.125)
				self:zoom(1)
			end;
			SongUnchosenMessageCommand=function(self)
				self:finishtweening()
				self:linear(0.125)
				self:zoom(0)
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player == relevantPlayer then
					if params.Direction == 1 then
						self:finishtweening():x(arrowDistance):linear(0.125):x(arrowDistance+arrowStrength):linear(0.125):x(arrowDistance);
					end;
					if params.Direction == -1 then
						self:finishtweening():x(arrowDistance):sleep(0.25);
					end;
				end;
			end;
		};

	};

	return t

end