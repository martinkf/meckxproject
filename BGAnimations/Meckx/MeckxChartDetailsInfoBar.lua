return function(params)

	-- params
	local entireY = params.YPosition -- Y positioning of the entire module
	local p = params.Player -- -1 for PLAYER_1, 1 for PLAYER_2
	local relevantPlayer = (p == -1) and PLAYER_1 or PLAYER_2

	-- levers
	local upperInfoY = 19; -- Y alignment of the upper info bar part
	local lowerInfoY = 39; -- Y alignment of the lower info bar part

	-- drawing
	local t = Def.ActorFrame {};

	t[#t+1] =  Def.ActorFrame {
		InitCommand=function(self)
			self:x(p*386)
			self:y(entireY+700)
			self:playcommand("UpdateInfo")
		end;

		SongChosenMessageCommand=function(self)
			self:finishtweening():y(entireY+700):linear(0.25):y(entireY)
			self:playcommand("UpdateInfo")
		end;

		SongUnchosenMessageCommand=function(self)
			self:finishtweening():y(entireY):linear(0.125):y(entireY+700)
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

			self:GetChild("ChartMainName"):settext(chartMainNameText);
			self:GetChild("ChartMainName"):diffuse(chartMainNameColor);

			-- UPDATING CHART AUTHOR
			local chartAuthorText
			chartAuthorText = Meckx_FetchFromChart(thisChart, "Chart Author")
			self:GetChild("ChartAuthor"):settext(chartAuthorText);

			-- UPDATING YOUR MOTHER
		end;

		Def.Quad {
			InitCommand=function(self)
				self:x(0)
				self:y(0)
				self:valign(0.5)
				self:setsize(610,108)
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
				self:y(-25)
				self:zoom(1.5)
				self:maxwidth(960)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="ChartAuthor";
			Text="ChartAuthor Test";
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
			Name="LowerDot";
			Text="•";
			InitCommand=function(self)
				self:x(0)
				self:y(lowerInfoY)
				self:halign(0.5)
				self:zoom(0.5)
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
			Name="LeftArrow";
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(relevantPlayer))
				self:rotationy(-180)
				self:animate(false)
				self:x(-340)
				self:y(0)
				self:zoom(0)
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
						self:finishtweening():x(-340):sleep(0.25);
					end;
					if params.Direction == -1 then
						self:finishtweening():x(-340):linear(0.125):x(-360):linear(0.125):x(-340);
					end;
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
			Name="RightArrow";
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(relevantPlayer))
				self:animate(false)
				self:x(340)
				self:y(0)
				self:zoom(0)
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
						self:finishtweening():x(340):linear(0.125):x(360):linear(0.125):x(340);
					end;
					if params.Direction == -1 then
						self:finishtweening():x(340):sleep(0.25);
					end;
				end;
			end;
		};

	};

	return t

end