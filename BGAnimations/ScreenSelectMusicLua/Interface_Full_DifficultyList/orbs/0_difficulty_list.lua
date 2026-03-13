local xCount=14;
local xCenter=7;
local SONGSTEPS = nil;
local ARRAY={};
local StepsType={'StepsType_Pump_Single','StepsType_Pump_Halfdouble','StepsType_Pump_Double','StepsType_Pump_Single_P','StepsType_Pump_Double_P' };


local MaxFloors = 1;

-- StepsType_Pump_Routine
ARRAY[0] = PLAYER_1;
ARRAY[2] = PLAYER_2;

function gethround(num)
	local result
	result = round(num)
	if (num > round(num)) then
		result = round(num + 1)
	end
	return result
end


local function METER( a,b )
	return a:GetMeter() < b:GetMeter()
end

local function QUESTLABEL( a,b )
	local STEP1 =string.gsub(a:GetLabelType(), "LABELTYPE_S", "");
	local STEP2 = string.gsub(b:GetLabelType(), "LABELTYPE_S", "");
	return STEP1 < STEP2;
end

local function StepTypeToMode(stype)
	if stype == "StepsType_Pump_Single" then
		return "pump-single";
	elseif stype == "StepsType_Pump_Double" then
		return "pump-double";
	elseif stype == "StepsType_Pump_Halfdouble" then
		return "pump-half";
	elseif stype == "StepsType_Pump_Single_P" then
		return "pump-single-p";
	elseif stype == "StepsType_Pump_Double_P" then
		return "pump-double-p";
	else
		return "";
	end;
end;

local function CharToMeter(num, stype, players)
	
	if meter == "!!" then
		meter = "51";
	end;
	if meter == "??" then
		meter = "99";
	end;
	
	if tonumber(num) > 99 then
		num = "99";
	end;
	
	if stype ~= "pump-double-p" then
		if (num == "49" or num == "50" or num == "99") then
			num = "??";
		end;
		if num == "51" then
			num = "!!";
		end;
	else
		if players == 1 then
			if (num == "49" or num == "50" or num == "99") then
				num = "??";
			end;
			if num == "51" then
				num = "!!";
			end;
		end;
	end;
	
	if stype == "pump-single" or stype == "pump-half" or  stype == "pump-double-p"   then
		num = num.gsub(num, "0", "a");
		num = num.gsub(num, "1", "b");
		num = num.gsub(num, "2", "c");
		num = num.gsub(num, "3", "d");
		num = num.gsub(num, "4", "e");
		num = num.gsub(num, "5", "f");
		num = num.gsub(num, "6", "g");
		num = num.gsub(num, "7", "h");
		num = num.gsub(num, "8", "i");
		num = num.gsub(num, "9", "j");
		num = num.gsub(num, "?", "k");
		num = num.gsub(num, "!", "l");
	else
		num = num.gsub(num, "0", "A");
		num = num.gsub(num, "1", "B");
		num = num.gsub(num, "2", "C");
		num = num.gsub(num, "3", "D");
		num = num.gsub(num, "4", "E");
		num = num.gsub(num, "5", "F");
		num = num.gsub(num, "6", "G");
		num = num.gsub(num, "7", "H");
		num = num.gsub(num, "8", "I");
		num = num.gsub(num, "9", "J");
		num = num.gsub(num, "?", "K");
		num = num.gsub(num, "!", "L");
	end;
	
	return num;
end;


local function GetSteps()

	if GAMESTATE:GetCurrentSong() == nil then return nil; end;
	
	if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
		local vpSongs, vpTemp = GAMESTATE:GetTrainInfo(GAMESTATE:GetCurrentSong(),false);
		
		vpSteps = vpTemp;	
		local auxSteps={};
		for i=1 ,#vpSteps do
			auxSteps[i] = {};
			auxSteps[i].meter = vpSteps[i]:GetMeter();
			auxSteps[i].modes = StepTypeToMode(vpSteps[i]:GetStepsType());
			auxSteps[i].players = 1;
			auxSteps[i].label = "normal";
			auxSteps[i].realstep = null;
			auxSteps[i].cuslabel = "";
			
			if (i == 1) then
				TrainTypeBall = auxSteps[i].modes;
			end;
		end;
		
		vpSteps = auxSteps;
	else
		if GAMESTATE:GetQuestZoneChannel() then
			vpSteps = GAMESTATE:GetCurrentSong():GetAllSteps();	
			table.sort(vpSteps,QUESTLABEL);
			
			local auxSteps={};
			for i=1 ,#vpSteps ,1 do
					auxSteps[#auxSteps+1] = {};
					auxSteps[#auxSteps].meter = vpSteps[i]:GetMeter();
					auxSteps[#auxSteps].modes = StepTypeToMode(vpSteps[i]:GetStepsType());
					auxSteps[#auxSteps].players = vpSteps[i]:GetPlayers();
					auxSteps[#auxSteps].label = LabelTypeToMode(vpSteps[i]:GetLabelType());
					auxSteps[#auxSteps].difficulty = vpSteps[i]:GetDifficulty();
					auxSteps[#auxSteps].realstep = vpSteps[i];
					auxSteps[#auxSteps].cuslabel = DesCustomLabel(vpSteps[i]:GetDescription());
			end;
			vpSteps = auxSteps;
			return vpSteps;
		else
			vpSteps = SongUtil.GetCurrentPlayableSteps(GAMESTATE:GetCurrentSong());
		end;
		--
		local auxSteps={};
		for st=1, #StepsType, 1 do
			for i=1 ,#vpSteps ,1 do
				if vpSteps[i]:GetStepsType() == StepsType[st] then
					auxSteps[#auxSteps+1] = {};
					auxSteps[#auxSteps].meter = vpSteps[i]:GetMeter();
					auxSteps[#auxSteps].modes = StepTypeToMode(vpSteps[i]:GetStepsType());
					auxSteps[#auxSteps].players = vpSteps[i]:GetPlayers();
					auxSteps[#auxSteps].label = LabelTypeToMode(vpSteps[i]:GetLabelType());
					auxSteps[#auxSteps].difficulty = vpSteps[i]:GetDifficulty();
					auxSteps[#auxSteps].realstep = vpSteps[i];
					auxSteps[#auxSteps].cuslabel = DesCustomLabel(vpSteps[i]:GetDescription());
				end;
			end;
		end;
		vpSteps = auxSteps;
		
		for i=#vpSteps, 1, -1 do
			if vpSteps[i].modes == "pump-half" and GAMESTATE:GetNumPlayersEnabled() == 2 then
				table.remove(vpSteps,i);
				i = #vpSteps;
			end;
		end;
		
		for i=#vpSteps, 1, -1 do
			if vpSteps[i].modes == "pump-double" and GAMESTATE:GetNumPlayersEnabled() == 2 then
				table.remove(vpSteps,i);
				i = #vpSteps;
			end;
		end;
		for i=#vpSteps, 1, -1 do
			if vpSteps[i].modes == "pump-double-p" and GAMESTATE:GetNumPlayersEnabled() == 2 then
				table.remove(vpSteps,i);
				i = #vpSteps;
			end;
		end;
	end;
	
	MaxFloors = gethround(#vpSteps / 13);
	return vpSteps;
end;


local function GRAY(SONGSTEPS,player,lfloor)
	if not GAMESTATE:GetQuestZoneChannel() then
		return false;
	end;
	
	for t=#SONGSTEPS, 1, -1 do
		local profile = PROFILEMAN:GetProfile(player);
		for s=#profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),SONGSTEPS[t].realstep):GetHighScores(), 1 , -1 do	
			if profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),SONGSTEPS[t].realstep):GetHighScores()[s]:GetLabelType() == lfloor and
				profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),SONGSTEPS[t].realstep):GetHighScores()[s]:GetSuccess() then
				return false;
			end;
		end;
	end;
	return true;
end;

local iMasterFloor = 0;
local iMasterStep = 0;

local t = Def.ActorFrame{
	OnCommand=function(self)
		self:finishtweening();
		self:queuecommand("Refresh");
	end;

	--Fast quick for effects
	CurrentSongChangedMessageCommand=function(self)
		iMasterStep= 0;
		iMasterFloor = 0;
		xCenter = 7;
		if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' then	
			self:queuecommand("Refresh");
		end;
	end;
	SongUnchosenMessageCommand=function(self)
		self:stoptweening();
		self:queuemessage("StepsReadyAux");
	end;
		
	ChannelChosenMessageCommand=function(self)
		self:stoptweening():queuecommand("Refresh");
	end;
	ProfileMessageCommand=function(self)
		self:stoptweening():queuecommand("Refresh");
	end;
	RefreshCommand=function(self)

		if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' then	
			if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'Finalized' then
				SONGSTEPS = GetSteps();
				self:playcommand("StepsReadyAux");
				--MESSAGEMAN:Broadcast( "StepsReadyAux" );
				
				if (SONGSTEPS ~= nil and #SONGSTEPS > 13) then
					self:queuemessage("ShowRArrow");
					--MESSAGEMAN:Broadcast( "ShowRArrow" );
				else
					self:queuemessage("HideRArrow");
					--MESSAGEMAN:Broadcast( "HideRArrow" );
				end;
			end;
		end;
	end;

	
};


local separationBalls = 85;
for i=1,13,1 do
	
	t[#t+1] = Def.ActorFrame{
		-- Ball Color
		
		InitCommand=function(self)
			self:x((i -xCenter) * separationBalls);
		end;
		
		SongChosenMessageCommand=cmd(finishtweening;linear,.2;y,0);
		SongUnchosenMessageCommand=function(self)
			
		end;
		
		SelectChannelMessageCommand=function(self)
			self:finishtweening():linear( (13-i) / 30 ):x((i*15)*100):diffusealpha(0);
		end;
		ChannelChosenMessageCommand=function(self)
			self:finishtweening():x( ( (i-xCenter) * 100) - 700 ):linear((13-i) / 30 ):x( (i-xCenter) * separationBalls):diffusealpha(1);
		end;

		OffCommand=function(self)
			self:finishtweening():linear( (13-i) / 30 ):addx((i*15)*100);
		end;
		
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/StepList_Ballons"))..{
			InitCommand=cmd(visible,true;zoom,.5);
			OnCommand=cmd(diffusealpha,0;animate,false;setstate,7;linear,0.15;diffusealpha,1);
			
			StepsReadyAuxMessageCommand=function(self)
				-- 31
				if SONGSTEPS ~= nil then
					if SONGSTEPS[i + iMasterFloor] then
						self:setstate(7);

						if SONGSTEPS[i + iMasterFloor].modes == "pump-double" then
							self:setstate(1);
						elseif SONGSTEPS[i + iMasterFloor].modes == "pump-single-p" then
							self:setstate(2);
						elseif SONGSTEPS[i + iMasterFloor].modes == "pump-double-p"  then
							self:setstate(3);
						elseif SONGSTEPS[i + iMasterFloor].modes == "pump-half" then
							self:setstate(5);
						elseif SONGSTEPS[i + iMasterFloor].modes == "pump-single" then
							self:setstate(0);
						end;
						
						if SONGSTEPS[i + iMasterFloor].modes == "pump-double-p" and SONGSTEPS[i + iMasterFloor].players ~= 1  then
							self:setstate(4);
						end;
						
						if SONGSTEPS[i].label == "s2" then
							--buscar el label S1 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S1");				
							if gray then
								self:setstate(6);
							end;
						end;
						if SONGSTEPS[i].label == "s3" then
							--buscar el label S2 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S2");	
							if gray then
								self:setstate(6);
							end;
						end;
						if SONGSTEPS[i].label == "s4" then
							--buscar el label S3 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S3");	
							if gray then
								self:setstate(6);
							end;
						end;
						
						
					else
						self:setstate(7);
					end;
				else
					self:setstate(7);
				end;

			end;

		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/glow_ring") ) .. {
			InitCommand=cmd(blend,'BlendMode_Add';rotationz,180;diffusealpha,.15;spin);
			OnCommand=function(self)
				--self:effectmagnitude(0,0,-100);
			end;
		};


		
		LoadFont("_LevelSmall")..{	--meter single y single-p		
			InitCommand=cmd(visible,false;zoom,.85;zoomy,.82);
			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					if SONGSTEPS[i + iMasterFloor] then -- and (SONGSTEPS[i + iMasterFloor].modes == "pump-single" or SONGSTEPS[i + iMasterFloor].modes == "pump-single-p") 
						
						self:visible(true);
						local meter = SONGSTEPS[i+ iMasterFloor].meter;

						
						meter = string.format("%02i", meter);
						
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						
						if SONGSTEPS[i+ iMasterFloor].modes == "pump-double-p" and SONGSTEPS[i+ iMasterFloor].players ~= 1 then
							meter = "x" .. SONGSTEPS[i+ iMasterFloor].players;
						end;
						
						self:settext( meter );
						
						if SONGSTEPS[i].label == "s2" then
							--buscar el label S1 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S1");				
							if gray then
								self:visible(false);
							end;
						end;
						if SONGSTEPS[i].label == "s3" then
							--buscar el label S2 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S2");	
							if gray then
								self:visible(false);
							end;
						end;
						if SONGSTEPS[i].label == "s4" then
							--buscar el label S3 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S3");	
							if gray then
								self:visible(false);
							end;
						end;
						
					else
						self:settext("");
					end;
				else
					self:settext("");
				end;

			end;

		};
		
		LoadFont("_LevelBorderSmall")..{	--meter single y single-p		
			InitCommand=cmd(visible,false;zoom,.85;zoomy,.82);
			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					if SONGSTEPS[i + iMasterFloor] then 
					
						self:visible(true);
						local meter = SONGSTEPS[i+ iMasterFloor].meter;
						
						meter = string.format("%02i", meter);
						
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						
						if SONGSTEPS[i+ iMasterFloor].modes == "pump-double-p" and SONGSTEPS[i+ iMasterFloor].players ~= 1 then
							meter = "x" .. SONGSTEPS[i+ iMasterFloor].players;
						end;
						self:settext( meter );
						
						if SONGSTEPS[i+ iMasterFloor].modes == "pump-double" then
							self:diffuse(color("#0b4a00"));
						elseif SONGSTEPS[i+ iMasterFloor].modes == "pump-double-p" then
							if SONGSTEPS[i+ iMasterFloor].players ~= 1 then
								self:diffuse(color("#2e1e00"));
							else
								self:diffuse(color("#003391"));
							end;
						elseif SONGSTEPS[i+ iMasterFloor].modes == "pump-half" then
							self:diffuse(color("#00495b"));
						elseif SONGSTEPS[i+ iMasterFloor].modes == "pump-single" then
							self:diffuse(color("#710000"));
						elseif SONGSTEPS[i+ iMasterFloor].modes == "pump-single-p" then
							self:diffuse(color("#540056"));
						end;
						
						
						if SONGSTEPS[i].label == "s2" then
							--buscar el label S1 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S1");				
							if gray then
								self:visible(false);
							end;
						end;
						if SONGSTEPS[i].label == "s3" then
							--buscar el label S2 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S2");	
							if gray then
								self:visible(false);
							end;
						end;
						if SONGSTEPS[i].label == "s4" then
							--buscar el label S3 está completado
							local gray = GRAY(SONGSTEPS,GAMESTATE:GetMasterPlayerNumber(),"S3");	
							if gray then
								self:visible(false);
							end;
						end;
						
					else
						self:settext("");
					end;
				else
					self:settext("");
				end;

			end;

		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DIFFLABELS"))..{
			InitCommand=cmd(setstate,0);
			OnCommand=function(self)
				self:animate(false):zoom(.6):setstate(0):y(24);
			end;
			SongUnchosenMessageCommand=cmd(finishtweening);
			StepsReadyAuxMessageCommand=cmd(finishtweening;queuecommand,"StepsChanged");
			SongChosenMessageCommand=cmd(finishtweening;queuecommand,"StepsChanged");
			
			StepsChangedCommand=function(self)
			
				if SONGSTEPS ~= nil then
					if SONGSTEPS[i+iMasterFloor] then
					
						self:setstate(0);
						self:diffusealpha(1);

						--if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:GetCurrentSteps(PLAYER_1) == SONGSTEPS[i + iMasterFloor].realstep then
						--	self:diffusealpha(0);
						--else
						--	self:diffusealpha(1);
						--end;
						
						--if SONGSTEPS[i+iMasterFloor].label == "new" then
						--	for pn in ivalues(PlayerNumber) do
						--		if GAMESTATE:IsPlayerEnabled(pn) then
						--			local scorelist = PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentSong(),SONGSTEPS[i+iMasterFloor].realstep);
						--			local scores = scorelist:GetHighScores();
						--			local topscore = scores[1];
						--			if not topscore then
						--				self:setstate(1);
						--			end;
						--		end;
						--	end;
						--end;
						
						if SONGSTEPS[i+iMasterFloor].label == "ucs" then
							self:setstate(2);
						end;
						if SONGSTEPS[i+iMasterFloor].label == "another" then
							self:setstate(3);
						end;
						

					else
						self:setstate(0);
						   
					end;
				end;
			
			
			end;

		};
		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/CUSLABELS"))..{
			InitCommand=cmd(zoom,.6;y,23;animate,false);
			SongUnchosenMessageCommand=cmd(finishtweening);
			StepsReadyAuxMessageCommand=cmd(finishtweening;queuecommand,"StepsChanged");
			SongChosenMessageCommand=cmd(finishtweening;queuecommand,"StepsChanged");
			
			StepsChangedCommand=function(self)
				if SONGSTEPS ~= nil then
					self:setstate(0);
					self:diffusealpha(0);
					if SONGSTEPS[i + iMasterFloor] then
						
						self:diffusealpha(1);
						--if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:GetCurrentSteps(PLAYER_1) == SONGSTEPS[i + iMasterFloor].realstep then
						--	self:diffusealpha(0);
						--else
						--	
						--end;
						if not GAMESTATE:GetMusicTrainChannel() and not  GAMESTATE:GetProgressiveChannel() and not GAMESTATE:GetQuestZoneChannel() then 


							local tlabel = string.lower(LabelTypeToMode(SONGSTEPS[i + iMasterFloor].label))
							local clabel = string.lower(DesCustomLabel(SONGSTEPS[i + iMasterFloor].cuslabel))
							local setlclabel = setNormalLabelState(tlabel, clabel)

							local nlabel = (tlabel == "ucs" and 2) or (tlabel == "another" and 3) or 0
							self:setstate(nlabel == 0 and setlclabel or 0);
						end;
					else
						self:setstate(0);
					end;
				else
					self:setstate(0);
				end;
				
				
			end;
		};


		--p1
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="slgradep1";
			InitCommand=cmd(zoom,1;xy,0,-40;visible,false;animate,false;setstate,0);
			--CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,0.05;accelerate,0.18;diffusealpha,1);

			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					self:visible(false);
					if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_1) then			
						local song, steps;
						song = GAMESTATE:GetCurrentSong();
						steps = SONGSTEPS[i + iMasterFloor].realstep;			
						local scorelist;
						if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
							scorelist =PROFILEMAN:GetProfile(PLAYER_1):GetHighScoreList(song,steps);
							assert(scorelist)
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then

								if topscore:GetFailedAux() then
									self:visible(false);
								else
									self:visible(true);
									local iScore = topscore:GetScore();								
									local iGrade = gradeTransformState(iScore);
									self:setstate(iGrade);
								end;
							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				end;
			end;


		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep1fail";
			InitCommand=cmd(zoom,1;xy,0,-40;visible,false;animate,false;setstate,0);
			--CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,0.05;accelerate,0.18;diffusealpha,1);

			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					self:visible(false);
					if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_1) then			
						local song, steps;
						song = GAMESTATE:GetCurrentSong();
						steps = SONGSTEPS[i + iMasterFloor].realstep;			
						local scorelist;
						if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
							scorelist =PROFILEMAN:GetProfile(PLAYER_1):GetHighScoreList(song,steps);
							assert(scorelist)
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then

								if topscore:GetFailedAux() then
									self:visible(true);
									local iScore = topscore:GetScore();								
									local iGrade = gradeTransformState(iScore);
									self:setstate(iGrade);
								else
									self:visible(false);

								end;


							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				end;
			end;
		};	

		--p2
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="slgradep2";
			InitCommand=cmd(zoom,1;xy,0,40;visible,false;animate,false;setstate,0);
			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					self:visible(false);
					if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_2) then			
						local song, steps;
						song = GAMESTATE:GetCurrentSong();
						steps = SONGSTEPS[i + iMasterFloor].realstep;			
						local scorelist;
						if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
							scorelist =PROFILEMAN:GetProfile(PLAYER_2):GetHighScoreList(song,steps);
							assert(scorelist)
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then

								if topscore:GetFailedAux() then
									self:visible(false);
								else
									self:visible(true);
									local iScore = topscore:GetScore();								
									local iGrade = gradeTransformState(iScore);
									self:setstate(iGrade);
								end;
							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				end;
			end;
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep2fail";
			InitCommand=cmd(zoom,1;xy,0,40;visible,false;animate,false;setstate,0);
			StepsReadyAuxMessageCommand=function(self)
				if SONGSTEPS ~= nil then
					self:visible(false);
					if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_2) then			
						local song, steps;
						song = GAMESTATE:GetCurrentSong();
						steps = SONGSTEPS[i + iMasterFloor].realstep;			
						local scorelist;
						if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
							scorelist =PROFILEMAN:GetProfile(PLAYER_2):GetHighScoreList(song,steps);
							assert(scorelist)
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then

								if topscore:GetFailedAux() then
									self:visible(true);
									local iScore = topscore:GetScore();								
									local iGrade = gradeTransformState(iScore);
									self:setstate(iGrade);
								else
									self:visible(false);

								end;


							else
								self:visible(false);
							end;
						else
							self:visible(false);
						end;
					end;
				end;
			end;
		};	


		--[[
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep1fail";
			InitCommand=cmd(zoom,0.63;xy,18,-17;visible,true;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};		
		--p2
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="slgradep2";
			InitCommand=cmd(zoom,0.63;xy,-2,29;visible,true;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep2fail";
			InitCommand=cmd(zoom,0.63;xy,-2,29;visible,true;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};
		]]
		
		--LoadActor(THEME:GetPathG("","SM-SMALLBALL-GRADE"))..{
		--	OnCommand=cmd(visible,true;y,-25;animate,false;zoom,.7);			
		--	StepsReadyAuxMessageCommand=function(self)
		--		if SONGSTEPS ~= nil then
		--			self:visible(false);
		--			if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_1) then
		--	
		--				local song, steps;
		--				song = GAMESTATE:GetCurrentSong();
		--				steps = SONGSTEPS[i + iMasterFloor].realstep;			
		--				local scorelist;
		--				if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
		--					scorelist =PROFILEMAN:GetProfile(PLAYER_1):GetHighScoreList(song,steps);
		--					assert(scorelist)
		--					local scores = scorelist:GetHighScores();
		--					local topscore = scores[1];
		--					if topscore then
		--						local iNum = TierToState(topscore:GetGrade());
		--						local iScore = topscore:GetScore();
		--						if (topscore:GetFailedAux()) then iNum = iNum + 8; end;
		--						self:setstate(iNum);
		--						if (iScore > 0) then self:visible(true); end;
		--					else
		--						self:visible(false);
		--					end;
		--				else
		--					self:visible(false);
		--				end;
		--			end;
		--		end;
		--	end;
		--	FinalizedMessageCommand=cmd(finishtweening;visible,false);
		--};
		--
		--LoadActor(THEME:GetPathG("","SM-SMALLBALL-GRADE"))..{
		--	OnCommand=cmd(visible,true;y,26;animate,false;zoom,.7);			
		--	StepsReadyAuxMessageCommand=function(self)
		--		if SONGSTEPS ~= nil then
		--			self:visible(false);
		--			
		--			if SONGSTEPS[i + iMasterFloor] and GAMESTATE:IsHumanPlayer(PLAYER_2) then
		--	
		--				local song, steps;
		--				song = GAMESTATE:GetCurrentSong();
		--				steps = SONGSTEPS[i + iMasterFloor].realstep;			
		--				local scorelist;
		--				if song and steps and not GAMESTATE:GetQuestZoneChannel() and not GAMESTATE:GetRandomTrainChannel() then
		--					scorelist =PROFILEMAN:GetProfile(PLAYER_2):GetHighScoreList(song,steps);
		--					assert(scorelist)
		--					local scores = scorelist:GetHighScores();
		--					local topscore = scores[1];
		--					if topscore then
		--						local iNum = TierToState(topscore:GetGrade());
		--						local iScore = topscore:GetScore();
		--						if (topscore:GetFailedAux()) then iNum = iNum + 8; end;
		--						self:setstate(iNum);
		--						if (iScore > 0) then self:visible(true); end;
		--					else
		--						self:visible(false);
		--					end;
		--				else
		--					self:visible(false);
		--				end;
		--			end;
		--		end;
		--	end;
		--	FinalizedMessageCommand=cmd(finishtweening;visible,false);
		--};



	}
end;


for p=0,2,2 do	
	for s = 0,1,1 do
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/SSM-FULL-CURSOR"))..{
			InitCommand=cmd(animate,false;setstate,(s+p);visible,false);
			
			AlphaCommand=cmd(finishtweening;diffusealpha,1;linear,.6;diffusealpha,.6;linear,.6;diffusealpha,1;queuecommand,"Alpha");
			SongChosenMessageCommand=cmd(stoptweening;queuecommand,"SetPositions");
			SongUnchosenMessageCommand=cmd(stoptweening;visible,false);
			
			SetAnimCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					if not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
						self:visible(true);
					else
						self:visible(false);
					end;
					self:queuecommand("Alpha");
				end;
			end;
			SetPositionsCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					for i=1, #SONGSTEPS, 1 do
						if (CurrentStep == SONGSTEPS[i].realstep) then
						
							local index = i;
							if (index > 13) then
								index = (index % 13)
								if (index == 0) then
									index = 13;
								end;
							end;
							
							self:y( p == 2 and 30 or  -30):x( (index - xCenter) * separationBalls);
							self:sleep(.2);
							self:queuecommand("SetAnim");
						end;
					end;
				else
					self:visible(false);
				end;
			end;
			
			-- Graciosito, necesita 1 frame bajo queuecommand porque si no, no actualiza xd
			ChangeStepsMessageCommand=cmd(finishtweening;queuecommand,"SetCursor");
			
			SetCursorCommand=function(self)
				
				if not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
					self:visible(true);
				else
					self:visible(false);
				end;
				if GAMESTATE:IsHumanPlayer( ARRAY[p] ) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					for i=1, #SONGSTEPS, 1 do
						
						if (CurrentStep == SONGSTEPS[i].realstep) then
							local index = i;
							if (index > 13) then
								index = (index % 13)
								if (index == 0) then
									index = 13;
								end;
							end;
							self:finishtweening():x((index-xCenter) * separationBalls):queuecommand("Alpha");
							
							if (ARRAY[p] == GAMESTATE:GetMasterPlayerNumber()) then
								iMasterStep = i;
								iMasterFloor = ( gethround(iMasterStep/13)  -1) * 13;
							end;
							
							if (iMasterFloor > 0) then
								MESSAGEMAN:Broadcast( "ShowLArrow" );
								local currentFloor = (iMasterFloor / 13) + 1;
								
								if ( currentFloor == MaxFloors) then
									MESSAGEMAN:Broadcast( "HideRArrow" );
								else
									MESSAGEMAN:Broadcast( "ShowRArrow" );
								end;
								
							else
								MESSAGEMAN:Broadcast( "HideLArrow" );
								if (MaxFloors > 1) then MESSAGEMAN:Broadcast( "ShowRArrow" ); end;
							end;
							MESSAGEMAN:Broadcast( "StepsReadyAux" );
						end;
						
					end;
				else
					self:visible(false);
				end;
			end;
			CurrentSongChangedMessageCommand=function(self)
				iMasterFloor = 0;
			end;
			
			StepsUnchosenMessageCommand=function(self, params)
				--iMasterFloor = 0;
				self:stopeffect():stoptweening();
				if params.Player == ARRAY[p] and not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
					if SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
						self:queuecommand("SetCursor");
					end;
				end;
			end;
			RefreshStepMessageCommand=cmd(finishtweening;queuecommand,"SetCursor");
			StepsChosenMessageCommand=function(self, params)
				if params.Player == ARRAY[p] and not GAMESTATE:GetMusicTrainChannel() and not GAMESTATE:GetProgressiveChannel() then
					self:finishtweening():visible(true):diffuseshift():effectcolor1(1,1,1,0.4):effectcolor2(1,1,1,1):effectperiod(.2) ;
				end;
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.125;visible,false)
		};
	end;
end;


--Derecha
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
	OnCommand=function(self)
		self:visible(false):animate(false):x(570):zoom(.4):y(0):rotationz(0);
	end;
	CurrentSongChangedMessageCommand=function(self,params)
		self:visible(false);
	end;
	ShowRArrowMessageCommand=function(self,params)
		if not GAMESTATE:GetQuestZoneChannel() then
			self:visible(true);
		end;
	end;
	SongChosenMessageCommand=function(self)
		self:finishtweening():linear(.2):y(0):rotationz(0):zoom(0.6);
	end;
	SongUnchosenMessageCommand=function(self)
		self:finishtweening():linear(.2):y(0):rotationz(0):zoom(0.4);
	end;
	HideRArrowMessageCommand=function(self,params)
		self:visible(false);
	end;
	FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
};

--Izquierda
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/DifficultyList/orbs/MusicWheel_Arrow"))..{
	OnCommand=function(self)
		self:visible(false):animate(false):x(-570):zoom(.4):rotationy(-180):y(0):rotationz(0);
	end;
	CurrentSongChangedMessageCommand=function(self,params)
		self:visible(false);
	end;
	SongChosenMessageCommand=function(self)
		self:finishtweening():linear(.2):y(0):rotationz(0):zoom(0.6);
	end;
	SongUnchosenMessageCommand=function(self)
		self:finishtweening():linear(.2):y(0):rotationz(0):zoom(0.4);
	end;
	HideLArrowMessageCommand=function(self,params)
		self:visible(false);
	end;
	ShowLArrowMessageCommand=function(self,params)
		if not GAMESTATE:GetQuestZoneChannel() then
			self:visible(true);
		end;
	end;
	FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
};






return t;