local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
	};


	LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.4;visible,true);
		OnCommand=function(self)
		end;		
	};	

	LoadActor( THEME:GetPathG("","commonBackground/bredsm.mp4") )..{
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(12);
				self:diffusealpha(0.4);
				self:linear(12);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;		
	};	


	LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
	};	
};

local profileStatsShowingP1=true;
local profileStatsShowingP2=true;
local timeToShowSeconds = 5;

function getProfileStats(pnPlayer)

	local waslevelup = false;

	local OldStats = {
		Name		= PROFILEMAN:GetProfile(pnPlayer):GetDisplayName();
		Level		= PROFILEMAN:GetProfile(pnPlayer):GetOldUserLevel();
		Exp 		= PROFILEMAN:GetProfile(pnPlayer):GetOldUserExp();
		PP			= PROFILEMAN:GetProfile(pnPlayer):GetOldUserPP();
		ScoreSingle	= PROFILEMAN:GetProfile(pnPlayer):GetOldUserRankScoreSingle();
		ScoreDouble	= PROFILEMAN:GetProfile(pnPlayer):GetOldUserRankScoreDouble();
		ScoreTotal	= PROFILEMAN:GetProfile(pnPlayer):GetOldUserRankScoreSingle() +
					  PROFILEMAN:GetProfile(pnPlayer):GetOldUserRankScoreDouble();
		TotalStep	= PROFILEMAN:GetProfile(pnPlayer):GetOldTotalTapsAndHolds();
		TotalKcal	= PROFILEMAN:GetProfile(pnPlayer):GetOldTotalCaloriesBurned();
		TotalSession= PROFILEMAN:GetProfile(pnPlayer):GetOldTotalSessions();
		Title 	 	= PROFILEMAN:GetProfile(pnPlayer):GetCustomTitle();
	};	
	
	local NewStats = {
		Name		= PROFILEMAN:GetProfile(pnPlayer):GetDisplayName();
		Level		= PROFILEMAN:GetProfile(pnPlayer):GetUserLevel();
		Exp 		= PROFILEMAN:GetProfile(pnPlayer):GetUserExp();
		PP			= PROFILEMAN:GetProfile(pnPlayer):GetUserPP();
		ScoreSingle	= PROFILEMAN:GetProfile(pnPlayer):GetUserRankScoreSingle();
		ScoreDouble	= PROFILEMAN:GetProfile(pnPlayer):GetUserRankScoreDouble();
		ScoreTotal	= PROFILEMAN:GetProfile(pnPlayer):GetUserRankScoreSingle() +
					  PROFILEMAN:GetProfile(pnPlayer):GetUserRankScoreDouble();
		TotalStep	= PROFILEMAN:GetProfile(pnPlayer):GetTotalTapsAndHolds();
		TotalKcal	= PROFILEMAN:GetProfile(pnPlayer):GetTotalCaloriesBurned();
		TotalSession= PROFILEMAN:GetProfile(pnPlayer):GetTotalSessions();
		Title 	 	= PROFILEMAN:GetProfile(pnPlayer):GetCustomTitle();
	};	
	
	if OldStats["Level"] ~= NewStats["Level"] then
		waslevelup=true;
	end;

	local xPlacePlayer = 0;

	if pnPlayer == PLAYER_1 then
		xPlacePlayer = -350;
	else
		xPlacePlayer = 350;
	end;


 	return Def.ActorFrame {

 		OnCommand=function(self)
 			self:x(SCREEN_CENTER_X + xPlacePlayer);
 			self:y(SCREEN_CENTER_Y);

 			self:GetChild("playerTitle"):settext(NewStats["Title"]); 			
 			self:GetChild("playerName"):settext(NewStats["Name"]);
 			self:GetChild("playerLevel"):settext(NewStats["Level"]);
 			self:GetChild("playerExp"):settext(formatNumberWithDots(NewStats["Exp"]));
 			self:GetChild("playerPP"):settext(NewStats["PP"]);

 			self:GetChild("playerSingleScore"):settext(formatNumberWithDots(NewStats["ScoreSingle"]));
 			self:GetChild("playerDoubleScore"):settext(formatNumberWithDots(NewStats["ScoreDouble"]));
 			self:GetChild("playerTotalScore"):settext(formatNumberWithDots(NewStats["ScoreTotal"]));

 			if NewStats["TotalStep"] < 10000000 then
 				self:GetChild("playerTotalSteps"):settext(formatNumberWithDots(NewStats["TotalStep"]));
 			else
 				self:GetChild("playerTotalSteps"):settext(formatNumberWithDots(9999999));
 			end;

 			if NewStats["TotalKcal"] < 100000 then
 				self:GetChild("playerCalories"):settext(truncateToTwoDecimals(NewStats["TotalKcal"]));
 			else
 				self:GetChild("playerCalories"):settext(truncateToTwoDecimals(99999.00));
 			end;

 			self:GetChild("playerTotalSession"):settext(formatNumberWithDots(NewStats["TotalSession"]));

 			if waslevelup then
 				self:GetChild("lvUp"):visible(true);
 			end;

			self:zoom(0.6);
			self:zoomy(0);

			self:linear(0.1);
			self:zoomy(0.6);
			self:sleep(timeToShowSeconds);
			self:linear(0.1);
			self:zoomy(0);
 		end;

 		CodeMessageCommand=function(self, params)
 			if params.PlayerNumber == pnPlayer and params.Name == "UpRight" then
 				self:GetChild("timeStatus"):stoptweening():diffusealpha(0);
 				if pnPlayer == PLAYER_1 and profileStatsShowingP1 then
 					profileStatsShowingP1 = false;
 					self:stoptweening();
 					self:linear(0.1);
 					self:zoomy(0);
 				elseif pnPlayer == PLAYER_2 and profileStatsShowingP2 then
 					profileStatsShowingP2 = false;
 					self:stoptweening();
 					self:linear(0.1);
 					self:zoomy(0);
 				elseif pnPlayer == PLAYER_1 and profileStatsShowingP1 == false then
 					profileStatsShowingP1 = true;
 					self:stoptweening();
 					self:linear(0.1);
 					self:zoomy(0.6);
 				elseif pnPlayer == PLAYER_2 and profileStatsShowingP2 == false then
 					profileStatsShowingP2 = true;
 					self:stoptweening();
 					self:linear(0.1);
 					self:zoomy(0.6);
 				end;
 			end;
 		end;

		Def.Quad{
			Name="timeStatus";
		    InitCommand=function(self)
		        self:zoomto(480, 10)         -- tamaño: 50x50
		            :diffuse(color("1,1,1,1"))  -- color negro (RGB)
		            :diffusealpha(1)
		            :y(-340)
		            :cropright(1)
		            :linear(timeToShowSeconds)
		            :cropright(0)
		    end
		};


		LoadActor(THEME:GetPathG("","ScreenUSB/savecard")) .. {
			OnCommand=function(self)
			end;
		};

		LoadFont("_TitleXolonium 30px")..{
			Name="playerTitle";
			OnCommand=cmd(horizalign,center;zoom,0.6;y,-249);
		};			

		LoadFont("_TitleXolonium 30px")..{
			Name="playerName";
			OnCommand=cmd(horizalign,center;zoom,0.85;y,-206);
		};

		LoadFont("_TitleXolonium 30px")..{
			Name="playerLevel";
			OnCommand=cmd(horizalign,center;zoom,0.85;y,-164);
		};		

		LoadActor(THEME:GetPathG("","ScreenUSB/lvup")) .. {
			Name="lvUp";
			OnCommand=cmd(;zoom,1;y,-160;x,180;visible,false);
		};	

		LoadFont("_TitleXolonium 30px")..{
			Name="playerExp";
			OnCommand=cmd(horizalign,center;zoom,0.85;y,-120);
		};	

		LoadFont("_TitleXolonium 30px")..{
			Name="playerPP";
			OnCommand=cmd(horizalign,center;zoom,0.85;y,-76);
		};			

		LoadFont("_TitleXolonium 30px")..{
			Name="playerSingleScore";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,25;x,-50);
		};	

		LoadFont("_TitleXolonium 30px")..{
			Name="playerDoubleScore";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,70;x,-50);
		};			

		LoadFont("_TitleXolonium 30px")..{
			Name="playerTotalScore";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,115;x,-50);
		};		

		LoadFont("_TitleXolonium 30px")..{
			Name="playerTotalSteps";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,180;x,70);
		};		

		LoadFont("_TitleXolonium 30px")..{
			Name="playerCalories";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,225;x,70);
		};	

		LoadFont("_TitleXolonium 30px")..{
			Name="playerTotalSession";
			OnCommand=cmd(horizalign,left;zoom,0.85;y,265;x,70);
		};	


	};

end;


local numParticles = 70  -- Cambia este valor para más o menos partículas
local screenW = SCREEN_WIDTH
local screenH = SCREEN_HEIGHT
local minSpeed = 5
local maxSpeed = 30

local minSpeedF = 20
local maxSpeedF = 60

local iTmp=1;



-- Función que crea una sola partícula
local function makeParticle(index)
	local firstTimeParticle = true;
    return LoadActor(THEME:GetPathG("","ScreenUSB/deco"))..{
        Name = "particle" .. index,
        InitCommand = function(self)
        	self:animate(false);
        	self:setstate(0);
            self:zoomto(16, 16)                         -- Tamaño del cuadrado
            self:diffuse(1, 1, 1, 0.7)                -- Color blanco semitransparente
            self:visible(true);
            self:queuecommand("Reset")
            
        end;

        ResetCommand = function(self)
        		-- random de color
        		local rcolorcomplete=false;
        		
        		local centerArrow = math.random() <= 0.1;
        		if centerArrow then
        			self:setstate(1);
        		else
        			self:setstate(0);
        		end;

        		--random size
        		local miniArrow = math.random() <= 0.3;
        		if miniArrow then        			
        			local microArrow = math.random() <= 0.5;
        			if microArrow then
        				self:zoomto(8, 8);
        			else
        				self:zoomto(12, 12);
        			end;
        		else
        			 self:zoomto(16, 16);
        		end;

        		if centerArrow then
	        		self:blend("BlendMode_Add");
					self:diffuseblink()
					self:effectcolor1(color("#fcff00")) 
					self:effectcolor2(color("#ffcc00"))  
					self:effectperiod(2)
					self:effecttiming(1, 0.1, 1, 0.1)
        		else
	        		local redc = math.random() <= 0.1;
	        		if redc and rcolorcomplete == false then
	        		self:blend("BlendMode_Add");
					self:diffuseblink()
					self:effectcolor1(color("#ff3600")) 
					self:effectcolor2(color("#ff7800"))  
					self:effectperiod(2)
					self:effecttiming(1, 0.1, 1, 0.1)
	        			rcolorcomplete=true;
	        		end;

	        		local bluec = math.random() <= 0.1;
	        		if bluec and rcolorcomplete == false then
							self:diffuseblink()
							self:effectcolor1(color("#00c0ff"))  
							self:effectcolor2(color("#00fffc"))  
							self:effectperiod(2)
							self:effecttiming(1, 0.1, 1, 0.1)
	        			rcolorcomplete=true;
	        		end;
        		end;


        		local arcoiris = math.random() <= 0.1;
        		if arcoiris and rcolorcomplete == false then
						self:rainbow();
        			rcolorcomplete=true;
        		end;

                -- Parte desde abajo hacia arriba
                local startX = math.random(-350, screenW);
                local endingX = startX+420;

                local startY = screenH + 10

                local speed = 0;

                if iTmp == 1 then
                	speed = math.random(minSpeed, maxSpeed)
                else
                	speed = math.random(minSpeedF, maxSpeedF)
                end;

			    iTmp = iTmp + 1;
			    if iTmp > 2 then
			    	iTmp = 1;
			    end;                

                local travelTime = (screenH + 20) / speed


        		if firstTimeParticle then
        			firstTimeParticle = false;
					-- Simular que ya ha avanzado algo
					local simulatedTime = math.random() * travelTime -- tiempo aleatorio entre 0 y travelTime
					local progress = simulatedTime / travelTime

					local currentX = startX + (endingX - startX) * progress
					local currentY = startY + (-10 - startY) * progress
					local remainingTime = travelTime - simulatedTime

					self:xy(currentX, currentY)
					self:stoptweening()
					self:linear(remainingTime):xy(endingX, -10):queuecommand("Reset")
        		else
	                self:xy(startX, startY)
	                self:stoptweening()
	                self:linear(travelTime):xy(endingX,-10):queuecommand("Reset")
        		end;



        end;

		FinalizedMessageCommand = function(self)	
			self:stoptweening():visible(false);
		end;        
    }
end

-- Crear todas las partículas y agregarlas al ActorFrame
for i = 1, numParticles do
    t[#t + 1] = makeParticle(i);
end

local StepsState = {
	StepsType_Pump_Single 		= 0,
	StepsType_Pump_Double 		= 1,
	StepsType_Pump_Single_P		= 5,
	StepsType_Pump_Double_P	= 4,
--	StepsType_Pump_Double_Px		= 2,
	StepsType_Pump_Halfdouble	= 3,
};

local StepsStateColor = {
	StepsType_Pump_Single 		= "#f50202",
	StepsType_Pump_Double 		= "#02f504",
	StepsType_Pump_Single_P		= "#9808c0",
	StepsType_Pump_Double_P		= "#0e66b8",
--	StepsType_Pump_Double_Px		= 2,
	StepsType_Pump_Halfdouble	= "#029c7d",
};

function StepTypeToMode(stype)
    local mapping = {
        ["StepsType_Pump_Single"] = 0,
        ["StepsType_Pump_Double"] = 1,
        ["StepsType_Pump_Halfdouble"] = 3,
        ["StepsType_Pump_Single_P"] = 5,
        ["StepsType_Pump_Double_P"] = 4
    }
    return mapping[stype] or 0
end

function StepTypeToModeColor(stype)
    local mapping = {
        ["StepsType_Pump_Single"] = "#f50202",
        ["StepsType_Pump_Double"] = "#02f504",
        ["StepsType_Pump_Halfdouble"] = "#029c7d",
        ["StepsType_Pump_Single_P"] = "#9808c0",
        ["StepsType_Pump_Double_P"] = "#0e66b8"
    }
    return mapping[stype] or "#f50202"
end

function getSongPlayedBanners()

	local tBanners = Def.ActorFrame {};
	local numSongPlayed = STATSMAN:GetStagesPlayed();
	local heightBase = SCREEN_TOP-30;
	local xBase = SCREEN_WIDTH/2;

	local stageStatsTmp = STATSMAN:GetPlayedStageStats(1);
	local playedSongTmp = stageStatsTmp:GetPlayedSongs();
	--vamos a buscar los ultimos 10 temas jugados.

	--:GetDisplayMainTitle();
	for i=1,numSongPlayed do
		--~
		local stageStatsTmp = STATSMAN:GetPlayedStageStats(i);
		local playedSongTmp = stageStatsTmp:GetPlayedSongs();
		local player1StageStats = nil;
		local player2StageStats = nil;

		if GAMESTATE:GetNumSidesJoined() == 2 then
			player1StageStats = stageStatsTmp:GetPlayerStageStats(PLAYER_1);
			player2StageStats = stageStatsTmp:GetPlayerStageStats(PLAYER_2);
		else
			if GAMESTATE:IsSideJoined(PLAYER_1) then 
				player1StageStats = stageStatsTmp:GetPlayerStageStats(PLAYER_1);
			end;
			if GAMESTATE:IsSideJoined(PLAYER_2) then 
				player2StageStats = stageStatsTmp:GetPlayerStageStats(PLAYER_2);
			end;
		end;		

		for j=1,#playedSongTmp do

			local songPlayed;
			local titleSong ="";

			local ptPlayer1=0;
			local letraStateP1=15;
			local fileLetraP1="pass_res";
			local lvPlayer1=0;
			local stateModoP1=0;
			local colorLvModeP1 = "";

			local ptPlayer2=0;
			local letraStateP2=15;	
			local fileLetraP2="pass_res";
			local lvPlayer2=0;			
			local stateModoP2=0;
			local colorLvModeP2 = "";


			local titleSongPathImg="";

			--GetPlayerStageStats

			songPlayed = playedSongTmp[j];
			titleSong = songPlayed:GetDisplayMainTitle();
			
		    -- Fallback to song's preview video or background
			if FILEMAN:DoesFileExist(songPlayed:GetBackgroundPath()) then
		    	titleSongPathImg = songPlayed:GetBackgroundPath();
		    else
		    	titleSongPathImg = THEME:GetPathG("", "Common nopreview");
		    end

		    if player1StageStats ~= nil then
		    	ptPlayer1 = player1StageStats:GetScore();
		    	letraStateP1 = gradeTransformState(ptPlayer1);		    	
		    	if player1StageStats:GetFailedAux() then
		    		fileLetraP1 = "fail_pass_res";
		    	else
		    		fileLetraP1 = "pass_res";
		    	end;
		    	--we need to get the step data :o
		    	local stepdataP1 = player1StageStats:GetPlayedSteps();

		    	--basicModeLevelStateAndColor
				if GAMESTATE:GetGameMode() == 'Basic' then
					Trace("# ESTOY EN BASIC #");
					local stateColorBasic = basicModeLevelStateAndColor(stepdataP1[1]:GetMeter(),stepdataP1[1]:GetStepsType());
					lvPlayer1 = stepdataP1[1]:GetMeter();
			    	stateModoP1 = stateColorBasic["state"];
			    	colorLvModeP1 = stateColorBasic["color"];
				else
			    	lvPlayer1 = stepdataP1[1]:GetMeter();
			    	stateModoP1 = StepTypeToMode(stepdataP1[1]:GetStepsType());
			    	colorLvModeP1 = StepTypeToModeColor(stepdataP1[1]:GetStepsType());
				end;
		    	--StepTypeToModeColor

		    end;

		    if player2StageStats ~= nil then
		    	ptPlayer2 = player2StageStats:GetScore();
		    	letraStateP2 = gradeTransformState(ptPlayer2);
		    	if player2StageStats:GetFailedAux() then
		    		fileLetraP2 = "fail_pass_res";
		    	else
		    		fileLetraP2 = "pass_res";
		    	end;

		    	--we need to get the step data :o
		    	local stepdataP2 = player2StageStats:GetPlayedSteps();
				if GAMESTATE:GetGameMode() == 'Basic' then
					Trace("# ESTOY EN BASIC #");
					local stateColorBasic = basicModeLevelStateAndColor(stepdataP2[1]:GetMeter(),stepdataP2[1]:GetStepsType());
					lvPlayer2 = stepdataP2[1]:GetMeter();
			    	stateModoP2 = stateColorBasic["state"];
			    	colorLvModeP2 = stateColorBasic["color"];
				else
			    	lvPlayer2 = stepdataP2[1]:GetMeter();
			    	stateModoP2 = StepTypeToMode(stepdataP2[1]:GetStepsType());
			    	colorLvModeP2 = StepTypeToModeColor(stepdataP2[1]:GetStepsType());
				end;



		    end;

			tBanners[#tBanners+1] =	Def.ActorFrame {
				OnCommand=function(self)
					self:x(xBase);
					self:y(heightBase+(i*130));
				end;

				Def.Banner {
						InitCommand=cmd(setsize,200,100);
						OnCommand=function(self)
							self:stoptweening();
							--cargamos cada cancion y el record respectivo.
							self:Load(titleSongPathImg);
							self:SetSize(180,80);
						end;
				};

				LoadFont("_TitleXolonium 30px")..{
					Text="NOMBRE DE LA CANCION";
					InitCommand=cmd(zoom,0.45;horizalign,center;addy,50;addx,5);
					OnCommand=function(self)						
						self:settext(titleSong);
					end;
				};


			};


			--LETRAS (AAA,AA,etc...), SCORE TEC P1
			tBanners[#tBanners+1] =	Def.ActorFrame {
				OnCommand=function(self)
					self:x(xBase-360);
					self:y(heightBase+(i*130));
				end;

				LoadActor(THEME:GetPathG("","ScreenUSB/resultp"))..{
					Name="TypeIcon";
					InitCommand=cmd(addy,0;zoom,0.65);
					OnCommand=function(self)
					    if player1StageStats ~= nil then
					    	self:visible(true);
					    else
					    	self:visible(false);
					    end;
					end;					
				};	

				--p1
				LoadActor(THEME:GetPathG("","ScreenEvaluation/"..fileLetraP1))..{
					InitCommand=cmd(animate,false;setstate,letraStateP1;zoom,0.3;x,-165);
					OnCommand=function(self)
					    if player1StageStats ~= nil then
					    	self:visible(true);
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

				LoadFont("_TitleXolonium 30px")..{
					Text="1.000.000";
					InitCommand=cmd(zoom,1;horizalign,center;x,5;y,-4);
					OnCommand=function(self)
					    if player1StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(formatNumberWithDots(ptPlayer1));
					    else
					    	self:visible(false);
					    end;
						
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

				--BASIC MODE
				LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/basicBacklv"))..{
					Name="bmodeBack";
					OnCommand=function(self)
						if GAMESTATE:GetGameMode() == 'Basic' then
							if player1StageStats ~= nil then
								self:animate(false):visible(true):zoom(0.37):x(167):y(3):setstate(stateModoP1);
							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				};
				--

				LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepnames"))..{
					Name="TypeIcon";
					InitCommand=cmd(animate,false;setstate,1;addy,-20;zoom,0.45;x,165);
					OnCommand=function(self)

						if GAMESTATE:GetGameMode() == 'Basic' then
							self:visible(false);
							return;
						end;


					    if player1StageStats ~= nil then
					    	self:visible(true);
					    	self:setstate(stateModoP1);
					    else
					    	self:visible(false);
					    end;
					end;	
					FinalizedMessageCommand=cmd(finishtweening;visible,false);				
				};	

				LoadFont("_LevelSmall")..{
					Text="99";
					InitCommand=cmd(zoom,0.9;horizalign,center;addy,8;x,165);
					OnCommand=function(self)
					    if player1StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(lvPlayer1);
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

				LoadFont('_LevelBorderSmall')..
				{
					InitCommand=cmd(zoom,0.9;horizalign,center;addy,8;x,165);
					OnCommand=function(self,params)
					    if player1StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(lvPlayer1);
					    	self:diffuse(color(colorLvModeP1));
					    else
					    	self:visible(false);
					    end;

					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

			};


			--LETRAS (AAA,AA,etc...), SCORE ETC P2
			tBanners[#tBanners+1] =	Def.ActorFrame {
				OnCommand=function(self)
					self:x(xBase+360);
					self:y(heightBase+(i*130));
				end;
				LoadActor(THEME:GetPathG("","ScreenUSB/resultp"))..{
					Name="TypeIcon";
					InitCommand=cmd(addy,0;zoom,0.68);
					OnCommand=function(self)
					    if player2StageStats ~= nil then
					    	self:visible(true);
					    else
					    	self:visible(false);
					    end;
					end;					
				};	

				--p2
				LoadActor(THEME:GetPathG("","ScreenEvaluation/"..fileLetraP2))..{
					InitCommand=cmd(animate,false;setstate,letraStateP2;zoom,0.3;x,160);
					OnCommand=function(self)
					    if player2StageStats ~= nil then
					    	self:visible(true);
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

				LoadFont("_TitleXolonium 30px")..{
					Text="1.000.000";
					InitCommand=cmd(zoom,1;horizalign,center;x,-12;y,-4);
					OnCommand=function(self)
					    if player2StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(formatNumberWithDots(ptPlayer2));
					    else
					    	self:visible(false);
					    end;
					end;
				};

				--BASIC MODE
				LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/basicBacklv"))..{
					Name="bmodeBack";
					OnCommand=function(self)
						if GAMESTATE:GetGameMode() == 'Basic' then
							if player2StageStats ~= nil then
								self:animate(false):visible(true):zoom(0.37):x(-168):y(3):setstate(stateModoP2);
							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				};
				--

				LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepnames"))..{
					Name="TypeIcon";
					InitCommand=cmd(animate,false;setstate,1;addy,-20;zoom,0.45;x,-170);
					OnCommand=function(self)

						if GAMESTATE:GetGameMode() == 'Basic' then
							self:visible(false);
							return;
						end;

					    if player2StageStats ~= nil then
					    	self:visible(true);
					    	self:setstate(stateModoP2);
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);					
				};

				LoadFont("_LevelSmall")..{
					Text="99";
					InitCommand=cmd(zoom,0.9;horizalign,center;addy,8;x,-170);
					OnCommand=function(self)
					    if player2StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(lvPlayer2);
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

				LoadFont('_LevelBorderSmall')..
				{
					InitCommand=cmd(zoom,0.9;horizalign,center;addy,8;x,-170);
					OnCommand=function(self,params)
					    if player2StageStats ~= nil then
					    	self:visible(true);
					    	self:settext(lvPlayer2);
					    	self:diffuse(color(colorLvModeP2));
					    else
					    	self:visible(false);
					    end;
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};

			};




		end;

	end;

	return tBanners;
end;

--add the information of the past gameplay
--BORDER WHEEL SONG SELECTED
t[#t+1] =  Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_TOP+25);

		 local songPlayed = STATSMAN:GetStagesPlayed();
	end;
	LoadFont("_TitleXolonium 30px")..{
		Name="titulo";
		Text="GAME RESULT";
		InitCommand=cmd(zoom,1.2;horizalign,center);
	};
};

 --local vStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber());
 local songPlayed = STATSMAN:GetStagesPlayed();

t[#t+1] = getSongPlayedBanners();

--PROFILE STATS SAVE
--[[
local profileStatsShowingP1=true;
local profileStatsShowingP2=true;
local timeToShowSeconds = 5;
]]

local segForChangeHeader = timeToShowSeconds; -- after x amount of seconds, the header will change from hide to show
local segPassedForChangeHeader=-1; --idk but it needs 1 second more, wtf xD
local interruptedP1 = false; -- with this we check if the first x seconds are interrumpted with a arrow press
local interruptedP2 = false;
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:queuecommand("checktimerHeader");
	end;

	checktimerHeaderCommand=function(self)
		self:sleep(1);
		segPassedForChangeHeader = segPassedForChangeHeader + 1;
		
		if segForChangeHeader > segPassedForChangeHeader then
			self:queuecommand("checktimerHeader");
		else			
			if interruptedP1 == false then
				profileStatsShowingP1=false;
			end;

			if interruptedP2 == false then
				profileStatsShowingP2=false;
			end;
		end;	
	end;
}


if GAMESTATE:IsSideJoined(PLAYER_1) and PROFILEMAN:IsPersistentProfile(PLAYER_1) then 
	
	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenUSB/headerInfo")) .. {
			OnCommand=function(self)
				self:animate(false);
				self:setstate(1);
				self:zoom(0.6);
				self:y(SCREEN_CENTER_Y-332);
				self:x(SCREEN_CENTER_X-350);

				if isAspectRatio1610() then
					self:y(SCREEN_CENTER_Y-370);
				end;

				self:queuecommand("checkInit");
			end;

			checkInitCommand=function(self)
				self:sleep(1);
				if segPassedForChangeHeader == 5 then
					self:setstate(0);
				else
					self:queuecommand("checkInit");
				end;
			end;


			CodeMessageCommand=function(self, params)
	 			if params.PlayerNumber == PLAYER_1 and params.Name == "UpRight" then
	 				interruptedP1=true;
	 				if profileStatsShowingP1 then
	 					self:stoptweening();
	 					self:setstate(0);
	 				elseif profileStatsShowingP1 == false then
	 					self:stoptweening();
	 					self:setstate(1);
	 				end;
	 			end;
	 		end;

	};	

	t[#t+1] = getProfileStats(PLAYER_1);
end;
if GAMESTATE:IsSideJoined(PLAYER_2) and PROFILEMAN:IsPersistentProfile(PLAYER_2) then 

	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenUSB/headerInfo")) .. {
			OnCommand=function(self)
				self:animate(false);
				self:setstate(1);
				self:zoom(0.6);
				self:y(SCREEN_CENTER_Y-332);
				self:x(SCREEN_CENTER_X+350);

				if isAspectRatio1610() then
					self:y(SCREEN_CENTER_Y-370);
				end;

				self:queuecommand("checkInit");
			end;

			checkInitCommand=function(self)
				self:sleep(1);
				if segPassedForChangeHeader == 5 then
					self:setstate(0);
				else
					self:queuecommand("checkInit");
				end;
			end;

			CodeMessageCommand=function(self, params)
	 			if params.PlayerNumber == PLAYER_2 and params.Name == "UpRight" then
	 				interruptedP2=true;
	 				if profileStatsShowingP2 then
	 					self:stoptweening();
	 					self:setstate(0);
	 				elseif profileStatsShowingP2 == false then

	 					self:stoptweening();
	 					self:setstate(1);
	 				end;
	 			end;
	 		end;

	};	


	t[#t+1] = getProfileStats(PLAYER_2);
end;

--background music :o 
t[#t+1] = LoadActor(THEME:GetPathS("","ScreenUSB/SilverStream")) .. {
	OnCommand=cmd(queuecommand,"PlayM");
	PlayMCommand=function(self)
		self:play();
	end;
	OffCommand=function(self)
		self:stop()
	end;
};

return t;
