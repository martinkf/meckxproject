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
	t[#t+1] = Def.ActorFrame{};

	if GAMESTATE:IsPlayerEnabled(ARRAY[p]) then
		t[#t+1] = LoadActor("../../../Meckx/MeckxChartDetailsInfoBar.lua")( { YPosition = -100, Player = p } );
	end

	t[#t+1] = Def.ActorFrame{

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
						local iScore = topscore:GetPhoenixScore();								
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
						local iScore = topscore:GetPhoenixScore();
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
						local iScore = topscore:GetPhoenixScore();								
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
							local iScore = topscore:GetPhoenixScore();
							if (iScore > 0) then self:visible(true); end;
							self:settext(string.upper(topscore:GetPhoenixScoreName()));
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
								local iScore = topscore:GetPhoenixScore();								
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
						local iScore = topscore:GetPhoenixScore();
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
						local iScore = topscore:GetPhoenixScore();								
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

	};
	
end;

return t;