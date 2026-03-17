local ARRAY={};
ARRAY[-1]=PLAYER_1;
ARRAY[1]=PLAYER_2;

local t = Def.ActorFrame{};

local yAux = 0;
local curAspect = round(GetScreenAspectRatio(),5);
if curAspect == 1.6 then -- 16:10
	yAux=35;
end;

--[[
local function DesCustomLabel(ltype)
	local fxlb = string.upper(ltype);

	if (string.find(fxlb, "QUEST")) then
		return "quest";
	elseif (string.find(fxlb, "ANOTHER")) then
		return "another";
	elseif (string.find(fxlb, "PRO")) then
		return "pro";
	elseif (string.find(fxlb, "INFINITY")) then
		return "infinity";
	elseif (string.find(fxlb, "JUMP")) then
		return "jump";
	elseif (string.find(fxlb, "HIDDEN")) then
		return "hidden";
	elseif (string.find(fxlb, "TRAIN")) then
		return "train";
	else
		return "normal";
	end;
	--WriteGamePrefToFile("DBG", "hidden" );
end;
]]

local function FixMeter(meter)	
	if meter == "!!" then
		meter = "51";
	end;
	if meter == "??" then
		meter = "99";
	end;
	
	meter = string.format("%02i", meter);
	if tonumber(meter) > 99 then
		meter = "99";
	end;
	return meter;
end;

local function GRAY(STEP,player)
	if not GAMESTATE:GetQuestZoneChannel() then
		return false;
	end;
	
	local profile = PROFILEMAN:GetProfile(player);
	for s=#profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),STEP):GetHighScores(), 1 , -1 do	
		if profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),STEP):GetHighScores()[s]:GetSuccess() then
			return true;
		end;
	end;
	
	return false;
end;

for p=-1,1,2 do
	t[#t+1] = Def.ActorFrame{

		--****************************************
		--********* DIFFICULTY DETAILS  **********
		--****************************************

	Def.ActorFrame{
		OnCommand=function(self)
			self:x((p == -1 and DifficultyDetails_XPlayer1 or DifficultyDetails_XPlayer2));
			self:y(DifficultyDetails_Y);
			self:zoom(0.8);
			self:animate(false);
			self:visible(false);
		end;

		SongUnchosenMessageCommand=function(self,params)
				self:visible(false);
		end;

		ChangeStepsMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				self:stoptweening();
				self:queuecommand("UpdateDetails");
			end;
		end;

		SongChosenMessageCommand=function(self,params)

			if GAMESTATE:GetNumSidesJoined() == 2 then
				self:queuecommand("UpdateDetails");
			else
				if params.Player == ARRAY[p] then
					self:stoptweening();
					self:queuecommand("UpdateDetails");
				end;				
			end;

		end;

		StepsUnchosenMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				self:stoptweening();
			end;
		end;	

		UpdateDetailsCommand=function(self)
			
			local thisChart = GAMESTATE:GetCurrentSteps(ARRAY[p]);
			if thisChart then self:visible(true) end;

			-- CHART MAIN NAME
			local chartMainName = Meckx_FetchFromChart(thisChart, "Chart Original Name")
			if #chartMainName > 0 then				
				self:GetChild("chartMainName"):settext(chartMainName);
			else
				self:GetChild("chartMainName"):settext("");
			end;

			-- CHART ORIGINAL NAME
			local chartOriginalName = Meckx_FetchFromChart(thisChart, "Chart Original Name")
			if #chartOriginalName > 0 then				
				self:GetChild("chartOriginalName"):settext("Originally called \""..chartOriginalName.."\"");
			else
				self:GetChild("chartOriginalName"):settext("");
			end;

			-- CHART AUTHOR
			local chartAuthor = Meckx_FetchFromChart(thisChart, "Chart Author")
			if #chartAuthor > 0 then
				self:GetChild("chartAuthor"):settext(chartAuthor);
			else
				self:GetChild("chartAuthor"):settext("");
			end;

			-- CHART ORIGIN
			local chartOrigin = Meckx_FetchFromChart(thisChart, "Chart Origin")
			if #chartOrigin > 0 then				
				self:GetChild("chartOrigin"):settext("Chart debut in "..chartOrigin);
			else
				self:GetChild("chartOrigin"):settext("");
			end;

			-- CHART LEVEL
			local chartLevel = Meckx_FetchFromChart(thisChart, "Chart Level")
			if #chartLevel > 0 then				
				self:GetChild("chartLevel"):settext("Lvl. "..chartLevel);
			else
				self:GetChild("chartLevel"):settext("");
			end;

		end;

		Def.Quad{
			Name="chartMainName_bg";
			InitCommand=cmd(zoomto,400,42;diffuse,color("0,0,0,0.7");x,0;y,0;);
		};
		LoadFont("_prime")..{
			OnCommand=cmd(x,0;y,0;zoom,0.75;settext,"";horizalign,center;queuecommand,"UpdateDetails");
			Name="chartMainName";
		};

		Def.Quad{
			Name="chartOriginalName_bg";
			InitCommand=cmd(zoomto,400,42;diffuse,color("0,0,0,0.7");x,0;y,46;);
		};
		LoadFont("_prime")..{
			OnCommand=cmd(x,0;y,46;zoom,0.75;settext,"";horizalign,center;queuecommand,"UpdateDetails");
			Name="chartOriginalName";
		};

		Def.Quad{
			Name="chartAuthor_bg";
			InitCommand=cmd(zoomto,400,42;diffuse,color("0,0,0,0.7");x,0;y,92;);
		};
		LoadFont("_prime")..{
			OnCommand=cmd(x,0;y,92;zoom,0.75;settext,"";horizalign,center;queuecommand,"UpdateDetails");
			Name="chartAuthor";
		};

		Def.Quad{
			Name="chartOrigin_bg";
			InitCommand=cmd(zoomto,400,42;diffuse,color("0,0,0,0.7");x,0;y,138;);
		};
		LoadFont("_prime")..{
			OnCommand=cmd(x,0;y,138;zoom,0.75;settext,"";horizalign,center;queuecommand,"UpdateDetails");
			Name="chartOrigin";
		};

		Def.Quad{
			Name="chartLevel_bg";
			InitCommand=cmd(zoomto,400,42;diffuse,color("0,0,0,0.7");x,0;y,184;);
		};
		LoadFont("_prime")..{
			OnCommand=cmd(x,0;y,184;zoom,0.75;settext,"";horizalign,center;queuecommand,"UpdateDetails");
			Name="chartLevel";
		};

	};
		
	--*********************************
	--********* MACHINE BEST **********
	--*********************************

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/THEME-HIGHSCOREPANEL"))..{
		OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):animate(false):x(510*p):y(RecordsGrid_Y8):zoom(1):diffusealpha(0);	
			if (p == -1) then
				self:setstate(0);
			else
				self:setstate(1);
			end;
		end;
		
		SongChosenMessageCommand=cmd(stoptweening;diffusealpha,GAMESTATE:GetQuestZoneChannel() and 0 or 1;linear,0.1;zoom,0.65;y,RecordsGrid_Y9);
		SongUnchosenMessageCommand=cmd(stoptweening;linear,0.1;zoom,1.2;y,RecordsGrid_YA;zoom,1;diffusealpha,0);
	};

	Def.ActorFrame{

				OnCommand=cmd(xy,(p == -1 and -423 or 418),RecordsGrid_Y7;animate,false;visible,false);

				LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
					Name="LetterMyBest";
					OnCommand=cmd(y,0;x,0;animate,false;setstate,0;queuecommand,"SetLetter");
					SetLetterCommand=function(self)
						self:zoom(0.24);
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

				--letra my best
				LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
					Name="LetterMyBestFail";
					OnCommand=cmd(y,0;x,0;animate,false;setstate,0;queuecommand,"SetLetter");
					SetLetterCommand=function(self)
						self:zoom(0.24);
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


				SongChosenMessageCommand=cmd(finishtweening;sleep,0.2;queuecommand,"Set");
				SongUnchosenMessageCommand=cmd(finishtweening;visible,false);

				ChangeStepsMessageCommand=function(self,param)
					self:stoptweening();
					self:queuecommand("Set");
				end;

				StepsUnchosenMessageCommand=function(self)
					if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
						self:playcommand("Set");
					end;
				end;

				SetCommand=function(self)
					self:GetChild("LetterMyBestFail"):visible(false);
					self:GetChild("LetterMyBest"):visible(true);

					local song, steps;
					song = GAMESTATE:GetCurrentSong();
					steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

					local scorelist;
					if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
						scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps);
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if topscore then
							self:visible(true);
							local iScore = topscore:GetScore();								
							local iGrade = gradeTransformState(iScore);

							if (topscore:GetFailedAux()) then 
								self:GetChild("LetterMyBestFail"):setstate(iGrade);
								self:GetChild("LetterMyBestFail"):visible(true);									
								self:GetChild("LetterMyBest"):visible(false);
							else
								self:GetChild("LetterMyBest"):setstate(iGrade);
								self:GetChild("LetterMyBestFail"):visible(false);									
								self:GetChild("LetterMyBest"):visible(true);

							end;
						else
							self:visible(false);
						end;
					else
						self:visible(false);
					end;

				end;

				FinalizedMessageCommand=cmd(finishtweening;visible,false);

	};


	-- Machine Best Score

	--medals.
	Def.ActorFrame{
		OnCommand=cmd(xy,(p == -1 and -418 or 423),RecordsGrid_Y6;animate,false;visible,false);
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/fullcombo"))..{
			Name="fullcombo";
			OnCommand=function(self)
				self:zoom(0.5);
			end;
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/pfg"))..{
			Name="pfc";
			OnCommand=function(self)
				self:zoom(0.5);
			end;
		};

		SongChosenMessageCommand=cmd(stoptweening;queuecommand,"Set");
		SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

		ChangeStepsMessageCommand=function(self,param)
			self:stoptweening();
			self:queuecommand("Set");
		end;

		StepsUnchosenMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
				self:playcommand("Set");
			end;
		end;

		SetCommand=function(self)
			self:GetChild("pfc"):visible(false);
			self:GetChild("fullcombo"):visible(false);

			local song, steps;
			song = GAMESTATE:GetCurrentSong();
			steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

			local scorelist;
			if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
				scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					self:visible(true);
					local iScore = topscore:GetScore();
					--pfc
					if iScore > 999999 then
						self:GetChild("pfc"):visible(true);
						
					else
						--full combo
						local tnsbadmiss 	= scores[1]:GetTapNoteScore('TapNoteScore_W5') +
											scores[1]:GetTapNoteScore("TapNoteScore_Miss") +
											scores[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss");
						if tnsbadmiss == 0 then
							self:GetChild("fullcombo"):visible(true);
						end;

					end;

				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;

		end;


	};


	Def.ActorFrame{
		OnCommand=cmd(xy,(p == -1 and -405 or 445),RecordsGrid_Y5;animate,false;zoom,1.4;visible,false);

		LoadFont("scorebg")..{	
				Name="scoreBackMyBest";
				OnCommand=cmd(queuecommand,"SetPos";xy,(p == -1 and -162 or 24),8);
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.4);
					self:horizalign("left");
					self:settext("1000000");
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

		LoadFont("scorebg")..{	
				Name="scoreFrontMyBest";
				OnCommand=cmd(queuecommand,"SetPos";xy,(p == -1 and -56 or 130),8);
				SetPosCommand=function(self)
					self:zoom(0.4);
					self:horizalign("right");
					self:settext("1000000");
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

		SongChosenMessageCommand=cmd(stoptweening;queuecommand,"Set");
		SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

		ChangeStepsMessageCommand=function(self,param)
			self:stoptweening();
			self:queuecommand("Set");
		end;

		StepsUnchosenMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
				self:playcommand("Set");
			end;
		end;

		SetCommand=function(self)
			self:GetChild("scoreFrontMyBest"):settext("");
			self:GetChild("scoreBackMyBest"):settext("0000000");

			local song, steps;
			song = GAMESTATE:GetCurrentSong();
			steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

			local scorelist;
			if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
				scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					self:visible(true);
					local iScore = topscore:GetScore();								
					local iGrade = gradeTransformState(iScore);
					local backScore = getZeroStringFromScore(iScore);

					self:GetChild("scoreFrontMyBest"):settext(iScore);
					self:GetChild("scoreBackMyBest"):settext(backScore);

				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;

		end;

	};


	--Name Machine Best
	LoadFont("_TitleXolonium")..{	
			Name="PlayerNameBestMachine";
			OnCommand=cmd(xy,(p == -1 and -555 or 555),RecordsGrid_Y4;animate,false;zoom,1.4;visible,true;queuecommand,"SetPos";);
			SetPosCommand=function(self)
				self:zoom(0.6);
				self:horizalign("center");
				self:settext("");
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

			SongChosenMessageCommand=cmd(stoptweening;queuecommand,"Set");
			SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

			ChangeStepsMessageCommand=function(self,param)
				self:stoptweening();
				self:queuecommand("Set");
			end;

			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:playcommand("Set");
				end;
			end;

			SetCommand=function(self)
				local song, steps;
				song = GAMESTATE:GetCurrentSong();
				steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);			
				local scorelist;
				if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel()  then
					scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(song,steps);
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					if topscore  then
						self:visible(false);
						local iScore = topscore:GetScore();
						if (iScore > 0) then self:visible(true); end;
						self:settext(string.upper(topscore:GetScoreName()));
					else
						self:settext("");
						self:visible(false);

					end;
				else
					self:settext("");
					self:visible(false);
				end;
			end;

	};	
	
	--****************************
	--********* MY BEST **********
	--****************************
	Def.ActorFrame{

				OnCommand=cmd(xy,(p == -1 and -423 or 418),RecordsGrid_Y1;animate,false;visible,false);

				LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
					Name="LetterMyBest";
					OnCommand=cmd(y,0;x,0;animate,false;setstate,0;queuecommand,"SetLetter");
					SetLetterCommand=function(self)
						self:zoom(0.24);
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

				--letra my best
				LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
					Name="LetterMyBestFail";
					OnCommand=cmd(y,0;x,0;animate,false;setstate,0;queuecommand,"SetLetter");
					SetLetterCommand=function(self)
						self:zoom(0.24);
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


				SongChosenMessageCommand=cmd(finishtweening;sleep,0.2;queuecommand,"Set");
				SongUnchosenMessageCommand=cmd(finishtweening;visible,false);

				ChangeStepsMessageCommand=function(self,param)
					self:stoptweening();
					self:queuecommand("Set");
				end;

				StepsUnchosenMessageCommand=function(self)
					if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
						self:playcommand("Set");
					end;
				end;

				SetCommand=function(self)
					self:GetChild("LetterMyBestFail"):visible(false);
					self:GetChild("LetterMyBest"):visible(true);

					local song, steps;
					song = GAMESTATE:GetCurrentSong();
					steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

					local scorelist;
					if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
						scorelist =PROFILEMAN:GetProfile(ARRAY[p]):GetHighScoreList(song,steps);
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if topscore then
							self:visible(true);
							local iScore = topscore:GetScore();								
							local iGrade = gradeTransformState(iScore);

							if (topscore:GetFailedAux()) then 
								self:GetChild("LetterMyBestFail"):setstate(iGrade);
								self:GetChild("LetterMyBestFail"):visible(true);									
								self:GetChild("LetterMyBest"):visible(false);
							else
								self:GetChild("LetterMyBest"):setstate(iGrade);
								self:GetChild("LetterMyBestFail"):visible(false);									
								self:GetChild("LetterMyBest"):visible(true);

							end;
						else
							self:visible(false);
						end;
					else
						self:visible(false);
					end;

				end;

				FinalizedMessageCommand=cmd(finishtweening;visible,false);

	};


	--medals.
	Def.ActorFrame{
		OnCommand=cmd(xy,(p == -1 and -418 or 423),RecordsGrid_Y2;animate,false;visible,false);
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/fullcombo"))..{
			Name="fullcombo";
			OnCommand=function(self)
				self:zoom(0.5);
			end;
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/pfg"))..{
			Name="pfc";
			OnCommand=function(self)
				self:zoom(0.5);
			end;
		};

		SongChosenMessageCommand=cmd(stoptweening;queuecommand,"Set");
		SongUnchosenMessageCommand=cmd(stoptweening;visible,false);

		ChangeStepsMessageCommand=function(self,param)
			self:stoptweening();
			self:queuecommand("Set");
		end;

		StepsUnchosenMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
				self:playcommand("Set");
			end;
		end;

		SetCommand=function(self)
			self:GetChild("pfc"):visible(false);
			self:GetChild("fullcombo"):visible(false);

			local song, steps;
			song = GAMESTATE:GetCurrentSong();
			steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

			local scorelist;
			if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
				scorelist =PROFILEMAN:GetProfile(ARRAY[p]):GetHighScoreList(song,steps);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					self:visible(true);
					local iScore = topscore:GetScore();
					--pfc
					if iScore > 999999 then
						self:GetChild("pfc"):visible(true);
						
					else
						--full combo
						local tnsbadmiss 	= scores[1]:GetTapNoteScore('TapNoteScore_W5') + scores[1]:GetTapNoteScore("TapNoteScore_Miss") + scores[1]:GetTapNoteScore("TapNoteScore_CheckpointMiss");
						if tnsbadmiss == 0 then
							self:GetChild("fullcombo"):visible(true);
						end;

					end;

				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;

		end;


	};


	Def.ActorFrame{
		OnCommand=cmd(xy,(p == -1 and -405 or 445),RecordsGrid_Y3;animate,false;zoom,1.4;visible,false);

		LoadFont("scorebg")..{	
				Name="scoreBackMyBest";
				OnCommand=cmd(queuecommand,"SetPos";xy,(p == -1 and -162 or 24),8);
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.4);
					self:horizalign("left");
					self:settext("1000000");
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

		LoadFont("scorebg")..{	
				Name="scoreFrontMyBest";
				OnCommand=cmd(queuecommand,"SetPos";xy,(p == -1 and -56 or 130),8);
				SetPosCommand=function(self)
					self:zoom(0.4);
					self:horizalign("right");
					self:settext("1000000");
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

		SongChosenMessageCommand=cmd(finishtweening;sleep,0.2;queuecommand,"Set");
		SongUnchosenMessageCommand=cmd(finishtweening;visible,false);

		ChangeStepsMessageCommand=function(self,param)
			self:stoptweening();
			self:queuecommand("Set");
		end;

		StepsUnchosenMessageCommand=function(self)
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
				self:playcommand("Set");
			end;
		end;

		SetCommand=function(self)
			self:GetChild("scoreFrontMyBest"):settext("");
			self:GetChild("scoreBackMyBest"):settext("0000000");

			local song, steps;
			song = GAMESTATE:GetCurrentSong();
			steps = GAMESTATE:GetCurrentSteps(ARRAY[p]);	

			local scorelist;
			if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
				scorelist =PROFILEMAN:GetProfile(ARRAY[p]):GetHighScoreList(song,steps);
				local scores = scorelist:GetHighScores();
				local topscore = scores[1];
				if topscore then
					self:visible(true);
					local iScore = topscore:GetScore();								
					local iGrade = gradeTransformState(iScore);
					local backScore = getZeroStringFromScore(iScore);

					self:GetChild("scoreFrontMyBest"):settext(iScore);
					self:GetChild("scoreBackMyBest"):settext(backScore);

				else
					self:visible(false);
				end;
			else
				self:visible(false);
			end;

		end;

	};


	Def.ActorFrame{
		OnCommand=function(self)
			self:visible(false);
		end;
		
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/Difficulty_BigBalls frame") )..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):x(225*p):y(220):zoom(0.7):diffusealpha(0);				
			end;
			SongChosenMessageCommand=cmd(finishtweening;linear,0.125;y,220;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(finishtweening;diffusealpha,0);
			
			ChangeStepsMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:stoptweening();

				end;
			end;

			StepsChosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:finishtweening();
				end;
			end;
			StepsUnchosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then

					end;
					
				end;
			end;
		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/Difficulty_BigBalls glow spin") ) .. {
			InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,.15;spin);
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):x(225*p):y(220):zoom(1.56):diffusealpha(0):rotationy(0);	
			end;
			SongChosenMessageCommand=cmd(finishtweening;linear,0.125;y,220;diffusealpha,0.05);
			SongUnchosenMessageCommand=cmd(finishtweening;diffusealpha,0);
		};
		
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/FX-OverBallBackground") )..{
			OnCommand=function(self)
				self:visible(false):animate(false):x(225*p):y(220):zoom(.9):diffusealpha(0):blend('BlendMode_Add');
			end;
			SongUnchosenMessageCommand=cmd(finishtweening;diffusealpha,0);
			
			StepsChosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:finishtweening();
					self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p]));
					self:linear(.1);
					self:diffusealpha(1);
				end;
			end;
			StepsUnchosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:finishtweening();
					self:visible(false);
				end;
			end;
		};
		
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/FX-BallBackground") )..{
			OnCommand=function(self)
				self:visible(false):animate(false):x(225*p):y(220):zoom(.9):diffusealpha(0);
			end;
			SongUnchosenMessageCommand=cmd(finishtweening;diffusealpha,0);
			
			StepsChosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:finishtweening();
					self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p]));
					self:linear(.1);
					self:diffusealpha(1);
					self:queuecommand("Effect");
				end;
			end;
			StepsUnchosenMessageCommand=function(self, params)
				if (params.Player == ARRAY[p]) then
					self:finishtweening();
					self:visible(false);
				end;
			end;
			EffectCommand=cmd(linear,.22;diffusealpha,.5;linear,.22;diffusealpha,.9;queuecommand,"Effect");
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/StepBall_Body"))..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):setstate(0):diffusealpha(0):animate(false):x(900*p):y(220):zoom(.73);				
			end;
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.125;x,225*p;playcommand,"Refresh");
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.125;x,900*p;sleep,.1;diffusealpha,0);
			ChangeStepsMessageCommand=cmd(finishtweening;playcommand,"Refresh");
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():playcommand("Refresh");
				end;
			end;
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);					
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single' then
						self:setstate(0);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						self:setstate(1);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double' then
						self:setstate(3);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
						self:setstate(4);
					end;
					if CurrentStep:GetPlayers() ~= 1 then
						self:setstate(5);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						self:setstate(2);
					end;
					
					
					if (GAMESTATE:GetMusicTrainChannel() or  GAMESTATE:GetProgressiveChannel())  and #vpSteps > 0 then
						local sType = vpSteps[1].modes;
						local sVarType = nil;
						
						lastStepTypeTrain = sType;
						if (#vpSteps > 1) then
							sVarType = vpSteps[2].modes;
						end;
						
						if (sType == "pump-single") then
							self:setstate(0);
							lastStepTypeTrain = sType;
						end;
						if (sType == "pump-double") then
							self:setstate(3);
							lastStepTypeTrain = sType;
						end;
						
						
						if (sType == "pump-single-p") then
							lastStepTypeTrain = sType;
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:setstate(1);
								else
									self:setstate(0);
									lastStepTypeTrain = "pump-single";
								end;
							else
								self:setstate(1);
							end;
						end; 
						
						if (sType == "pump-double-p") then
							lastStepTypeTrain = sType;
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:setstate(4);
								else
									self:setstate(3);
									lastStepTypeTrain = "pump-double";
								end;
							else
								self:setstate(4);
							end;
						end; 
						
						if (sType == "pump-half") then
							lastStepTypeTrain = sType;
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:setstate(2);
								else
									self:setstate(3);
									lastStepTypeTrain = "pump-double";
								end;
							else
								self:setstate(2);
							end;
						end;
					end;
					
				end;
			end;
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DIFFLABELS"))..{
			OnCommand=function(self)
				self:setstate(0):animate(false):x(225*p):y(290):zoom(1);
			end;
			SongChosenMessageCommand=cmd(finishtweening;diffusealpha,1;sleep,0.125;queuecommand,"Refresh");
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			RefreshCommand=function(self)
				self:setstate(0);
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					if CurrentStep:GetLabelType() == "LABELTYPE_NEW" then
						local scorelist = PROFILEMAN:GetProfile(ARRAY[p]):GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(ARRAY[p]));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if not topscore then
							self:setstate(1);
						end;
					end;
					if CurrentStep:GetLabelType() == "LABELTYPE_UCS" then
						self:setstate(2);
					end;
					if CurrentStep:GetLabelType() == "LABELTYPE_ANOTHER" then
						self:setstate(3);
					end;
				end;
			end;
			SongUnchosenMessageCommand=cmd(finishtweening;setstate,0;diffusealpha,0);
			ChangeStepsMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			ProfileMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' and SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingSong' then
					self:finishtweening():queuecommand("Refresh");
				end;
			end;
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():queuecommand("Refresh");
				end;
			end;
		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/CUSLABELS"))..{
			OnCommand=function(self)
				self:setstate(0):animate(false):x(225*p):y(290):zoom(1);
			end;
			SongChosenMessageCommand=cmd(finishtweening;sleep,0.125;queuecommand,"Refresh");
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			RefreshCommand=function(self)
				if bIsModded() and mCustomLabel then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					self:setstate(0);
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) and not GAMESTATE:GetQuestZoneChannel() then

						local tlabel = string.lower(LabelTypeToMode(CurrentStep:GetLabelType()))
						local clabel = string.lower(DesCustomLabel(CurrentStep:GetDescription()))
						local setlclabel = setNormalLabelState(tlabel, clabel)

						local nlabel = (tlabel == "ucs" and 2) or (tlabel == "another" and 3) or 0
						self:setstate(nlabel == 0 and setlclabel or 0);

					end;
				end;
			end;
			SongUnchosenMessageCommand=cmd(finishtweening;setstate,0);
			ChangeStepsMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():queuecommand("Refresh");
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/SSM-FULL-QUESTTHINGS"))..{
			OnCommand=function(self)
				self:setstate(1):animate(false):y(-380):zoom(1.3):visible(false);				
			end;
			SongChosenMessageCommand=cmd(finishtweening;sleep,0.125;queuecommand,"Refresh");
			RefreshCommand=function(self)
				self:visible(false);
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					if GRAY(GAMESTATE:GetCurrentSteps(ARRAY[p]),ARRAY[p]) then
						self:visible(true);
					end;
				end;						
			end;
			SongUnchosenMessageCommand=cmd(finishtweening;visible,false);
			ChangeStepsMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			ProfileMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' and SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingSong' then
					self:finishtweening():queuecommand("Refresh");
				end;
			end;
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():queuecommand("Refresh");
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/StepBall_Ready"))..{
			OnCommand=cmd(visible,false;x,225*p;y,290;zoom,.7;glowshift;effectcolor1,color("1,1,1,0.25");effectcolor2,color("1,1,1,0");effectperiod,0.25);
			SongUnchosenMessageCommand=cmd(visible,false);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == ARRAY[p] then
					self:visible(true);
				end;
			end;
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == ARRAY[p] then
					self:visible(false);
				end;
			end;
		};

		LoadFont("Level")..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):x(900*p):y(205):zoomx(.85):zoomy(.95);
			end;
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.125;x,225*p;playcommand,"Refresh");
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.125;x,900*p;sleep,.1;diffusealpha,0);
			ChangeStepsMessageCommand=cmd(finishtweening;playcommand,"Refresh");
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():playcommand("Refresh");
				end;
			end;
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					self:visible(true);
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					local meter = CurrentStep:GetMeter();
					meter = FixMeter(meter);
					if (meter == "49" or meter == "50" or meter == "99") then
						meter = "??";
					end;
					if meter == "51" then
						meter = "!!";
					end;
					if CurrentStep:GetPlayers() ~= 1 then
						meter = "x"..CurrentStep:GetPlayers();
					end;

					self:settext(meter);
					
				end;
			end;
		};	

		LoadFont("borderlevel")..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):x(900*p):y(205):zoomx(.85):zoomy(.95);				
			end;
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.125;x,225*p;playcommand,"Refresh");
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.125;x,900*p;diffusealpha,0);
			ChangeStepsMessageCommand=cmd(finishtweening;playcommand,"Refresh");
			StepsUnchosenMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					self:finishtweening():playcommand("Refresh");
				end;
			end;
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					self:visible(true);
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single' then
						self:diffuse(color("#944f00"));
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double' then
						self:diffuse(color("#266219"));
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						self:diffuse(color("#7e0c7e"));
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
						self:diffuse(color("#003391"));
					end;
					if  CurrentStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						self:diffuse(color("#007272"));
					end;

					local meter = CurrentStep:GetMeter();
					meter = FixMeter(meter);
					if (meter == "49" or meter == "50" or meter == "99") then
						meter = "??";
					end;
					if meter == "51" then
						meter = "!!";
					end;
					
					
					if CurrentStep:GetPlayers() ~= 1 then
						meter = "x"..CurrentStep:GetPlayers();
						self:diffuse(color("#8f752e"));
					end;
					
					
					if (GAMESTATE:GetMusicTrainChannel() or  GAMESTATE:GetProgressiveChannel() ) and #vpSteps > 0 then
						local sType = vpSteps[1].modes;
						local sVarType = nil;
						
						if (#vpSteps > 1) then
							sVarType = vpSteps[2].modes;
						end;
						
						if (sType == "pump-single") then
							self:diffuse(color("#944f00"));
						end;
						if (sType == "pump-double") then
							self:diffuse(color("#266219"));
						end;
						
						
						if (sType == "pump-single-p") then
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:diffuse(color("#ff00f4"));
								else
									self:diffuse(color("#944f00"));
								end;
							else
								self:diffuse(color("#ff00f4"));
							end;
						end; 
						
						if (sType == "pump-double-p") then
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:diffuse(color("#7e0c7e"));
								else
									self:diffuse(color("#266219"));
								end;
							else
								self:diffuse(color("#7e0c7e"));
							end;
						end; 
						
						if (sType == "pump-half") then
							if (sVarType ~= nil) then
								if (sVarType == sType) then
									self:diffuse(color("#007272"));
								else
									self:diffuse(color("#266219"));
								end;
							else
								self:diffuse(color("#007272"));
							end;
						end;
						
					end;
					
					
					self:settext(meter);
				end;
			end;
		};

	};
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
		OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):rotationy(-180):animate(false):x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2):y(ChartSelectArrows_Y):zoom(0);
		end;
		SongChosenMessageCommand=cmd(finishtweening;linear,0.125;zoom,.6);
		SongUnchosenMessageCommand=cmd(finishtweening;linear,0.125;zoom,0);
		ChangeStepsMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				if params.Direction == 1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2):sleep(0.25);
				end;
				if params.Direction == -1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2):linear(0.125):x(p == -1 and (ChartSelectArrows_XLeftArrowP1-5) or (ChartSelectArrows_XLeftArrowP2-5)):linear(0.125):x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2);
				end;
			end;
		end;
		StepsUnchosenMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				if params.Direction == 1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2):sleep(0.25);
				end;
				if params.Direction == -1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2):linear(0.125):x(p == -1 and (ChartSelectArrows_XLeftArrowP1-5) or (ChartSelectArrows_XLeftArrowP2-5)):linear(0.125):x(p == -1 and ChartSelectArrows_XLeftArrowP1 or ChartSelectArrows_XLeftArrowP2);
				end;
			end;
		end;
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
		OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):animate(false):x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2):y(ChartSelectArrows_Y):zoom(0);
		end;
		SongChosenMessageCommand=cmd(finishtweening;linear,0.125;zoom,.6);
		SongUnchosenMessageCommand=cmd(finishtweening;linear,0.125;zoom,0);
		ChangeStepsMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				if params.Direction == 1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2):linear(0.125):x(p == -1 and (ChartSelectArrows_XRightArrowP1+5) or (ChartSelectArrows_XRightArrowP2+5)):linear(0.125):x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2);
				end;
				if params.Direction == -1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2):sleep(0.25);
				end;
			end;
		end;
		StepsUnchosenMessageCommand=function(self,params)
			if params.Player == ARRAY[p] then
				if params.Direction == 1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2):linear(0.125):x(p == -1 and (ChartSelectArrows_XRightArrowP1+5) or (ChartSelectArrows_XRightArrowP2+5)):linear(0.125):x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2);
				end;
				if params.Direction == -1 then
					self:finishtweening():x(p == -1 and ChartSelectArrows_XRightArrowP1 or ChartSelectArrows_XRightArrowP2):sleep(0.25);
				end;
			end;
		end;
	};		
	
};

end;

return t;