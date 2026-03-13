function ChartInfoFull(pn)

	local StepsState = {
		StepsType_Pump_Single 		= 0,
		StepsType_Pump_Double 		= 1,
		StepsType_Pump_Single_P		= 5,
		StepsType_Pump_Double_P	= 4,
	--	StepsType_Pump_Double_Px		= 2,
		StepsType_Pump_Halfdouble	= 3,
	};
	local StepsColor = {
		StepsType_Pump_Single 		= color("#eb1b00"),
		StepsType_Pump_Double 		= color("#21a305"),
		StepsType_Pump_Single_P		= color("#7e0c7e"),
		StepsType_Pump_Double_P	= color("#003391"),
	--	StepsType_Pump_Double_Px		= color("#8f752e"),
		StepsType_Pump_Halfdouble	= color("#007272"),
	};
	
	if not pn then pn = GAMESTATE:GetMasterPlayer(); end;
	local p = pn == PLAYER_1 and -1 or 1;
	
	local t = Def.ActorFrame{};
	if GAMESTATE:IsHumanPlayer(pn) then
		t[#t+1] = Def.ActorFrame{
			LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepnames"))..{	Name="SNames";	OnCommand=cmd(animate,false;setstate,4;xy,12*p,-90;zoom,.8);	};
			LoadActor(THEME:GetPathG("","THEME-DIFFLABELS"))..{			Name="DIFFLABELS";	OnCommand=cmd(animate,false;xy,60,-68;zoom,.85;setstate,0;);	};
			LoadActor(THEME:GetPathG("","ScreenSelectMusic/CUSLABELS"))..{		Name="NEWCUSLABELS";	OnCommand=cmd(animate,false;xy,60,-64-6;zoom,.85;setstate,0;);	};
			LoadFont("Russo_One/Russo One outline 40px")..{
				Name="LvFontC";	
				Text = "Lv",
				InitCommand = cmd(xy,-76+(-10*p),0;zoom,.8;);
			};
			LoadFont("Level")..{		Name="LvFontA";		Text="08";		OnCommand=cmd(xy,24+(-10*p),-36;zoomx,.96;);	};
			LoadFont("borderlevel")..{	Name="LvFontB";		Text="08";		OnCommand=cmd(xy,24+(-10*p),-36;zoomx,.96;diffuse,color("#eb1b00");shadowlength,2;);	};

			Def.ActorFrame {
				Name = "ArtistFrame";	
				OnCommand=cmd(xy,24*p,108-4;);
				LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepartist_frame"))..{	OnCommand=cmd(zoom,.75;zoomx,0.72;blend,Blend.Add);	};
				LoadFont("Tomorrow/Tomorrow 40px")..{	Name="SArtist";		Text="";	OnCommand=cmd(zoom,.46;shadowlength,2;skewx,-0.18;maxwidth,190/.46;diffuse,color("#00ff00"));	};	--wrapwidthpixels,160/.86;
			};
			ChangeCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(pn);
				
			--	if CurrentStep then
					local stepArtist = FixedChartCreditNames(CurrentStep:GetAuthorCredit())
						self:GetChild("ArtistFrame"):GetChild("SArtist"):settext(stepArtist):visible(false);
						self:GetChild("ArtistFrame"):visible(false);
						
					local StepsType = CurrentStep:GetStepsType();
						self:GetChild("SNames"):setstate(StepsState[StepsType] or 0):x(12*p);
							if StepsType == "StepsType_Pump_Single_P" or StepsType == "StepsType_Pump_Double_P" then
								self:GetChild("SNames"):x(2*p);
							end;
					local level = DisplayLV(CurrentStep:GetMeter());
						self:GetChild("LvFontA"):settext(level);
						self:GetChild("LvFontB"):settext(level):diffuse(StepsColor[StepsType] or color("#eb1b00"));
							
						if CurrentStep:GetPlayers() ~= 1 then
							self:GetChild("SNames"):setstate(2):x(12*p);
							local xplayers = "x"..CurrentStep:GetPlayers();
							self:GetChild("LvFontA"):settext(xplayers);
							self:GetChild("LvFontB"):settext(xplayers):diffuse(color("#8f752e"));
						end;

					local tlabel = string.lower(LabelTypeToMode(CurrentStep:GetLabelType()))
					local clabel = string.lower(DesCustomLabel(CurrentStep:GetDescription()))
					local setlclabel = setNormalLabelState(tlabel, clabel)
					local nlabel = (tlabel == "ucs" and 2) or (tlabel == "another" and 3) or 0
						self:GetChild("DIFFLABELS"):setstate(nlabel);
						self:GetChild("NEWCUSLABELS"):setstate(nlabel == 0 and setlclabel or 0);
						if setlclabel == 10 then
							self:GetChild("NEWCUSLABELS"):zoomx(0.95);
						else
							self:GetChild("NEWCUSLABELS"):zoom(.85);
						end;

					--[[
						if (GAMESTATE:GetMusicTrainChannel() or  GAMESTATE:GetProgressiveChannel() ) and #vpSteps > 0 then
							local sType = vpSteps[1].modes;
							local sVarType = nil;
							if (#vpSteps > 1) then
								sVarType = vpSteps[2].modes;
							end;
							
							
							
						end;
						--]]
			--	end;
			end;
			ChangeStepsMessageCommand=function(self,param)
				local topScreen = SCREENMAN:GetTopScreen();
				if topScreen:GetSelectionState() ~= "SelectingSong" then
					if param.Player == pn then
						self:stoptweening():playcommand("Change");
					end;
				end;
			end;
			StepsUnchosenMessageCommand=function(self,param)
				local topScreen = SCREENMAN:GetTopScreen();
				if topScreen:GetSelectionState() ~= "SelectingSong" then
					if param.Player == pn then
						self:stoptweening():playcommand("Change");
					end;
				end;
			end;			
			SongChosenMessageCommand=cmd(finishtweening;sleep,.05;queuecommand,"Change");
		};
	end;
	return t;
end;

local function getHsBM(PLAYER)

	local steps = GAMESTATE:GetCurrentSteps(PLAYER);

	local machineBestscore=0;
	local isfailedMachineBest=0;
	local stateGradeMachineBest=-1;



	local mybestscore=0;
	local isfailedmybest=0;
	local stateGradeMyBest=-1;

	local frameHs =  Def.ActorFrame{
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_mybest"))..{
			InitCommand=cmd(zoom,0.7;);
			OnCommand=function(self)
				if PLAYER == PLAYER_1 then
					self:rotationy(180);
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/pfg"))..{
			Name="pfgSprite";
			InitCommand=cmd(zoom,0.6;);
			OnCommand=function(self)
				if PLAYER == PLAYER_2 then
					self:x(-68);
				else
					self:x(-42);
				end;

				self:y(-40);
				self:diffusealpha(0);
				
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/pfg"))..{
			Name="pfgSpriteGlow";
			InitCommand=cmd(zoom,0.6;);
			OnCommand=function(self)
				if PLAYER == PLAYER_2 then
					self:x(-68);
				else
					self:x(-42);
				end;

				self:y(-40);
				self:blend("BlendMode_Add");
				self:diffusealpha(0);
				
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};		


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/fullcombo"))..{
			Name="fcSprite";
			InitCommand=cmd(zoom,0.65;);
			OnCommand=function(self)
				if PLAYER == PLAYER_2 then
					self:x(-68);
				else
					self:x(-42);
				end;

				self:y(-36);
				self:diffusealpha(0);
				
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/fullcombo"))..{
			Name="fcSpriteGlow";
			InitCommand=cmd(zoom,0.65;);
			OnCommand=function(self)
				if PLAYER == PLAYER_2 then
					self:x(-68);
				else
					self:x(-42);
				end;

				self:y(-36);
				self:blend("BlendMode_Add");
				self:diffusealpha(0);
				
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_machinebest"))..{
			InitCommand=cmd(zoom,0.7;y,45;x,20);
			OnCommand=function(self)
				if PLAYER == PLAYER_1 then
					self:rotationy(180);
					self:x(-20);
				end;				
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/textSelectorRecords"))..{
			InitCommand=cmd(zoom,0.5;y,-5;x,-76;animate,0;setstate,0);
			OnCommand=function(self)
				if PLAYER == PLAYER_1 then
					self:x(-76);
				end;	
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/textSelectorRecords"))..{
			InitCommand=cmd(zoom,0.65;y,32;x,-48;animate,0;setstate,1);
			OnCommand=function(self)
				if PLAYER == PLAYER_1 then
					self:x(-75);
				end;	
			end;
			CurrentSongChangedMessageCommand=function(self)				
			end;		
		};	

		--mybest
		--score back
		LoadFont("scorebg")..{	
				Name="scoreBackMyBest";
				OnCommand=cmd(queuecommand,"SetPos";y,-5;x,-52;);
				SetPosCommand=function(self)

					if PLAYER == PLAYER_1 then
						self:x(-52);
					end;	
					self:diffusecolor(color("#787878"));
					self:zoom(0.4);
					self:horizalign("left");
					self:settext("0000000");
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
				OnCommand=cmd(queuecommand,"SetPos";y,-5;x,55;);
				SetPosCommand=function(self)
					if PLAYER == PLAYER_1 then
						self:x(54);
					end;	
					self:zoom(0.4);
					self:horizalign("right");
					self:settext("0000000");
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


		--GRADE--
		--letra my best
		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="LetterMyBest";
			OnCommand=cmd(y,0;x,78;animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.14);

				if PLAYER == PLAYER_1 then
					self:x(78);
				end;

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
			OnCommand=cmd(y,0;x,78;animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.14);

				if PLAYER == PLAYER_1 then
					self:x(78);
				end;

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


		--machinebest
		--score back
		LoadFont("scorebg")..{	
				Name="scoreBackMachineBest";
				OnCommand=cmd(queuecommand,"SetPos";y,48;x,-25;);
				SetPosCommand=function(self)

					if PLAYER == PLAYER_1 then
						self:x(-75);
					end;	
					self:diffusecolor(color("#787878"));
					self:zoom(0.55);
					self:horizalign("left");
					self:settext("0000000");
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
				Name="scoreFrontMachineBest";
				OnCommand=cmd(queuecommand,"SetPos";y,48;x,122;);
				SetPosCommand=function(self)
					if PLAYER == PLAYER_1 then
						self:x(72);
					end;	
					self:zoom(0.55);
					self:horizalign("right");
					self:settext("0000000");	

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

		--Name Machine Best
		LoadFont("_TitleXolonium")..{	
				Name="PlayerNameBestMachine";
				OnCommand=cmd(queuecommand,"SetPos";y,31;x,-2;);
				SetPosCommand=function(self)
					self:zoom(0.4);
					self:horizalign("left");
					self:settext("ARKADTT");
					if PLAYER == PLAYER_1 then
						self:x(-30);
					end;

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

		--GRADE--
		--letra Machine best
		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="LetterMachineBest";
			OnCommand=cmd(y,52;x,-55;animate,false;setstate,0;visible,false;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.14);

				if PLAYER == PLAYER_1 then
					self:x(-102);
				end;

				if isfailedMachineBest == 1 then
					self:visible(false);
				end;

				if stateGradeMachineBest == -1 then
					self:visible(false);
				end;

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

		LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			Name="LetterMachineBestFail";
			OnCommand=cmd(y,52;x,-55;animate,false;setstate,0;visible,false;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.14);

				if PLAYER == PLAYER_1 then
					self:x(-102);
				end;

				if isfailedMachineBest == 0 then
					self:visible(false);
				end;
				if stateGradeMachineBest == -1 then
					self:visible(false);
				end;


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



		ChangeStepsMessageCommand=function(self,param)
			--self:queuecommand("updateDataHSMBS");
			self:playcommand("updateDataHSMBS", { Player = param.Player })
		end;

		SongChosenMessageCommand=function(self,param)
			--self:queuecommand("updateDataHSMBS");
			self:playcommand("updateDataHSMBS", { Player = param.Player })
		end;

		updateDataHSMBSCommand=function(self,p)

				local song = GAMESTATE:GetCurrentSong();
				local steps = GAMESTATE:GetCurrentSteps(PLAYER);
				
				local arrayScores=getAllRankingFromSong(PLAYER);
				local dataPlayerScoreFromSong = GetHighScoreAndStateFromPlayer(PLAYER);

				local mbs = 0;
				local isfailedmbs=0;
				local stateGradeMbs = -1;

				if #arrayScores >= 1 then
					if (arrayScores[1] == nil ) then 
						mbs = 0;
						isfailedmbs=0;
						stateGradeMbs = -1;
					else
						mbs = arrayScores[1]["score"];

						if arrayScores[1]["failed"] == 1 then
							isfailedmbs = 1;
						end;
						stateGradeMbs = gradeTransformState(mbs);

						if isfailedmbs == 1 then
							self:GetChild("LetterMachineBest"):visible(false);
							self:GetChild("LetterMachineBestFail"):visible(true);
							self:GetChild("LetterMachineBestFail"):setstate(stateGradeMbs);
						else
							self:GetChild("LetterMachineBest"):visible(true);
							self:GetChild("LetterMachineBest"):setstate(stateGradeMbs);
							self:GetChild("LetterMachineBestFail"):visible(false);
						end;
						--name
						self:GetChild("PlayerNameBestMachine"):settext(arrayScores[1]["name"]);

						local backScoreMb =getZeroStringFromScore(mbs);
						self:GetChild("scoreBackMachineBest"):settext(backScoreMb);
						self:GetChild("scoreFrontMachineBest"):settext(mbs);

					end;
				else
						self:GetChild("LetterMachineBest"):visible(false);
						self:GetChild("LetterMachineBestFail"):visible(false);					
						self:GetChild("scoreBackMachineBest"):settext("0000000");
						self:GetChild("scoreFrontMachineBest"):settext("");
						self:GetChild("PlayerNameBestMachine"):settext("");
				end;

				--My best.

				if dataPlayerScoreFromSong["score"] == 0 then
						self:GetChild("LetterMyBest"):visible(false);
						self:GetChild("LetterMyBestFail"):visible(false);	
						self:GetChild("scoreBackMyBest"):settext("0000000");
						self:GetChild("scoreFrontMyBest"):settext("");
						self:GetChild("pfgSprite"):stoptweening():diffusealpha(0);
						self:GetChild("pfgSpriteGlow"):stoptweening():diffusealpha(0);

						self:GetChild("fcSprite"):stoptweening():diffusealpha(0);
						self:GetChild("fcSpriteGlow"):stoptweening():diffusealpha(0);

				else
						local backScore = getZeroStringFromScore(dataPlayerScoreFromSong["score"]);
						self:GetChild("scoreBackMyBest"):settext(backScore);
						self:GetChild("scoreFrontMyBest"):settext(dataPlayerScoreFromSong["score"]);

						if dataPlayerScoreFromSong["score"] == 1000000 then
							self:GetChild("pfgSprite"):stoptweening():linear(0.1):diffusealpha(1);
							if p.Player == PLAYER then 
								self:GetChild("pfgSpriteGlow"):stoptweening():zoom(0.6):diffusealpha(1):linear(0.2):zoom(0.65):diffusealpha(0);
							end;
						end;

						if dataPlayerScoreFromSong["fullcombo"] == 1 and dataPlayerScoreFromSong["score"] < 1000000 then
							self:GetChild("fcSprite"):stoptweening():linear(0.1):diffusealpha(1);
							if p.Player == PLAYER then 
								self:GetChild("fcSpriteGlow"):stoptweening():zoom(0.6):diffusealpha(1):linear(0.2):zoom(0.65):diffusealpha(0);
							end;
						end;

						local stateGrade = gradeTransformState(dataPlayerScoreFromSong["score"]);
						if dataPlayerScoreFromSong["failed"] == 1 then
							self:GetChild("LetterMyBest"):visible(false);
							self:GetChild("LetterMyBestFail"):visible(true);
							self:GetChild("LetterMyBestFail"):setstate(stateGrade);	
						else
							self:GetChild("LetterMyBest"):visible(true);
							self:GetChild("LetterMyBest"):setstate(stateGrade);	
							self:GetChild("LetterMyBestFail"):visible(false);							
						end;

				end;

		end;

		InitCommand=function(self)
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

	return frameHs;
end;

local StepsColor = {
	StepsType_Pump_Single 		= color("#ff001e"),
	StepsType_Pump_Double 		= color("#66e172"),
	StepsType_Pump_Single_P		= color("#fe2cae"),
	StepsType_Pump_Double_P	= color("#2553ff"),
	Coop					= color("#f6ed00"),
	StepsType_Pump_Halfdouble	= color("#25fcff"),
};

local t = Def.ActorFrame{};

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
t[#t+1] = Def.ActorFrame{	--PLAYER1
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.6;);
	
	SongChosenMessageCommand=function(self)
		if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
			self:x(SCREEN_CENTER_X-145);
		else
			self:x(SCREEN_CENTER_X);
		end;
	end;

	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*-1.2;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-1.2;decelerate,0.18;x,SCREEN_CENTER_X*-.36;queuecommand,"changeColor");
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-.36;accelerate,0.15;x,SCREEN_CENTER_X*-1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/backSelectorCover.png"))..{
			InitCommand=cmd(x,-60;zoom,0.64;diffusealpha,0.3;blend,Blend.Add;diffusecolor,color("#000000");diffusebottomedge,color("#ff001e");rotationy,180);
			ChangeStepsMessageCommand=cmd(queuecommand,"changeColor");
			ChangeCommand=cmd(queuecommand,"changeColor");
			changeColorCommand=function(self)							
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
					local StepsType = steps:GetStepsType();
					local getNumPlayersChart = steps:GetPlayers();
					local colorMode = getColorByStepType(StepsType,getNumPlayersChart);
					self:diffusebottomedge(colorMode);					
			end;	

			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
					local StepsType = steps:GetStepsType();
					self:fadetop(0.5);

					local getNumPlayersChart = steps:GetPlayers();

					local colorMode = getColorByStepType(StepsType,getNumPlayersChart);
					self:diffusecolor(colorMode);
				    
					self:queuecommand("Ani");
				end;
			end;
			AniCommand=function(self)
				self:linear(0.02);
				self:fadetop(0.6);
				self:linear(0.04);
				self:fadetop(0.9);				
				self:queuecommand("Ani");
			end;

			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:fadetop(0);	
					self:diffusecolor(color("#000000"));
					self:queuecommand("changeColor");
				end;
			end;					
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:fadetop(0);	
					self:diffusecolor(color("#000000"));
					self:queuecommand("changeColor");
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

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_arrowin"))..{
			InitCommand=cmd(x,55;zoomy,0.65;zoomx,0.8*0.8;diffusealpha,1;;rotationy,180;)
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/ReadyPlayer"))..{
			InitCommand=cmd(x,-95;y,-200; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:linear(0.08);
					self:x(-70);					
					self:diffusealpha(1);
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);						
					self:diffusealpha(0);
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
				end;
			end;
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
			end;			
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
				end;
			end;						
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/ReadyPlayer"))..{
			InitCommand=cmd(x,-95;y,-200; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;blend,"BlendMode_Add";draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:linear(0.08);
					self:x(-70);					
					self:diffusealpha(1);
					self:queuecommand("Animate");
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);						
					self:diffusealpha(0);
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
				end;
			end;	
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
				end;
			end;	
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
			end;	

			AnimateCommand=function(self)
				self:diffusealpha(0);
				self:linear(0.02);
				self:diffusealpha(1);
				self:queuecommand("Animate");
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

		--PaneDisplay(PLAYER_1)..{	InitCommand=cmd(xy,-80,60-4;zoom,1)	};
		ChartInfoFull(PLAYER_1)..{	InitCommand=cmd(xy,-60,0;zoom,1)	};
		getHsBM(PLAYER_1)..{InitCommand=cmd(xy,-64,45;zoom,1)};
		
		--STEPARTIST
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/stepartistsprite"))..{
			Name="stepartistbase";
			OnCommand=cmd(x,-221;y,-203;;zoom,0.65;visible,false);

			ChangeStepsMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;

			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;


			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
				end;
			end;	

			artistStepCommand=function(self)
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
					local stepArtist = steps:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
					else
						self:visible(false);
					end;			
			end;	
		};

		LoadFont("_century gothic")..{
			OnCommand=cmd(x,-188;y,-206;;zoom,0.65;settext,"";horizalign,center);

			ChangeStepsMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;

			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;


			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
				end;
			end;	

			artistStepCommand=function(self)
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
					local stepArtist = steps:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
						self:settext(stepArtist);
					else
						self:settext("");
						self:visible(false);
					end;			
			end;		
		};				

	};

	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*-1.2;y,-28;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-1.2;decelerate,0.12;x,SCREEN_CENTER_X*-.75;);
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-.75;accelerate,0.1;x,SCREEN_CENTER_X*-1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/backSelectorCoverBig.png"))..{
			InitCommand=cmd(x,-45;y,3;zoom,0.65;zoomx,0.8;diffusealpha,0.6;fadetop,0.1;rotationy,180);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_level"))..{
			InitCommand=cmd(x,-45;y,3;zoom,0.65;zoomx,0.8;rotationy,180);
			SongChosenMessageCommand=function(self)
				if GAMESTATE:GetMusicTrainChannel() then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
				end;
			end;			
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_arrowout"))..{
			InitCommand=cmd(x,55;zoom,0.65;rotationy,180;);
		};	

		
		ScrollerList(PLAYER_1)..{InitCommand=cmd(xy,-40,4);	};

	};
};
end;


if GAMESTATE:IsHumanPlayer(PLAYER_2) then
t[#t+1] = Def.ActorFrame{	--PLAYER2
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.6;);

	SongChosenMessageCommand=function(self)
		if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
			self:x(SCREEN_CENTER_X+145);
		else
			self:x(SCREEN_CENTER_X);
		end;
	end;

	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*1.2;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*1.2;decelerate,0.18;x,SCREEN_CENTER_X*.36;queuecommand,"changeColor");
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*.36;accelerate,0.15;x,SCREEN_CENTER_X*1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/backSelectorCover.png"))..{
			InitCommand=cmd(x,60;zoom,0.64;diffusealpha,0.3;blend,Blend.Add;diffusecolor,color("#000000");diffusebottomedge,color("#000000"));
			ChangeStepsMessageCommand=cmd(queuecommand,"changeColor");
			ChangeCommand=cmd(queuecommand,"changeColor");

			changeColorCommand=function(self)
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
					local StepsType = steps:GetStepsType();
					--self:diffusebottomedge(StepsColor[StepsType]);

					local getNumPlayersChart = steps:GetPlayers();

					local colorMode = getColorByStepType(StepsType,getNumPlayersChart);
					self:diffusebottomedge(colorMode);

			end;
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
					local StepsType = steps:GetStepsType();
					self:fadetop(0.5);
					local getNumPlayersChart = steps:GetPlayers();

					local colorMode = getColorByStepType(StepsType,getNumPlayersChart);
					self:diffusecolor(colorMode);	    
					self:queuecommand("Ani");
				end;
			end;
			AniCommand=function(self)
				self:linear(0.02);
				self:fadetop(0.6);
				self:linear(0.04);
				self:fadetop(0.9);				
				self:queuecommand("Ani");
			end;

			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:fadetop(0);	
					self:diffusecolor(color("#000000"));
					self:queuecommand("changeColor");
				end;
			end;
			
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:fadetop(0);	
					self:diffusecolor(color("#000000"));
					self:queuecommand("changeColor");
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

		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_arrowin"))..{
			InitCommand=cmd(x,-55;zoomy,0.65;zoomx,0.8*0.8;diffusealpha,1;)
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/ReadyPlayer"))..{
			InitCommand=cmd(x,95;y,-200; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:linear(0.08);
					self:x(75);
					self:diffusealpha(1);
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:linear(0.08);
					self:x(95);					
					self:diffusealpha(0);
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:linear(0.08);
					self:x(95);						
					self:diffusealpha(0);
				end;
			end;		
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:linear(0.08);
					self:x(95);						
					self:diffusealpha(0);
				end;
			end;
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/ReadyPlayer"))..{
			InitCommand=cmd(x,95;y,-200; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;blend,"BlendMode_Add";draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:linear(0.08);
					self:x(75);
					self:diffusealpha(1);
					self:queuecommand("Animate");
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:linear(0.08);
					self:x(95);					
					self:diffusealpha(0);
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:linear(0.08);
					self:x(95);						
					self:diffusealpha(0);
				end;
			end;		
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:linear(0.08);
					self:x(95);						
					self:diffusealpha(0);
					self:sleep(0.3);
				end;
			end;
			SongUnchosenMessageCommand=function(self,params)
					self:stoptweening();
					self:linear(0.08);
					self:x(-95);											
					self:diffusealpha(0);
			end;


			AnimateCommand=function(self)
				self:diffusealpha(0);
				self:linear(0.02);
				self:diffusealpha(1);
				self:queuecommand("Animate");
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

		ChartInfoFull(PLAYER_2)..{	InitCommand=cmd(xy,60,0;zoom,1)	};
		getHsBM(PLAYER_2)..{	InitCommand=cmd(xy,64,45;zoom,1)	};

		--STEPARTIST
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/stepartistsprite"))..{
			Name="stepartistbase";
			OnCommand=cmd(x,219;y,-203;;zoom,0.65;visible,false);

			ChangeStepsMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;

			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;


			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
				end;
			end;	

			artistStepCommand=function(self)
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
					local stepArtist = steps:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
					else
						self:visible(false);
					end;			
			end;	
		};

		LoadFont("_century gothic")..{
			OnCommand=cmd(x,252;y,-206;;zoom,0.65;settext,"arka";horizalign,center);

			ChangeStepsMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;

			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:queuecommand("artistStep");
				end;
			end;


			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:stoptweening();
				end;
			end;	

			artistStepCommand=function(self)
					local steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
					local stepArtist = steps:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
						self:settext(stepArtist);
					else
						self:settext("");
						self:visible(false);
					end;			
			end;		
		};		



	};

	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*1.2;y,-28;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*1.2;decelerate,0.12;x,SCREEN_CENTER_X*.75;queuecommand,"glowCheck");
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*.75;accelerate,0.1;x,SCREEN_CENTER_X*1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/backSelectorCoverBig.png"))..{
			InitCommand=cmd(x,45;y,3;zoom,0.65;zoomx,0.8;diffusealpha,0.6;fadetop,0.1);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_level"))..{
			InitCommand=cmd(x,45;y,3;zoom,0.65;zoomx,0.8);
			SongChosenMessageCommand=function(self)
				if GAMESTATE:GetMusicTrainChannel() then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
				end;
			end;				
		};		
	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/list/selector_arrowout"))..{
			InitCommand=cmd(x,-55;zoom,0.65;);
		};

		ScrollerList(PLAYER_2)..{	InitCommand=cmd(xy,40,4);	};

	};
};
end;


return t;