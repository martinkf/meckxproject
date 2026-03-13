local t = Def.ActorFrame {}

function getRankList(player)

	local hslist = getAllRankingFromSong(player);
	local hlistProc = {};
	local maxNumRank = 5;
	local procRank = 0;

	local numRankInSistem = #hslist;
	if numRankInSistem > 5 then
		numRankInSistem = 5;
	end;
	for i=1,numRankInSistem do
		local typeLightStatus = "";
		local judgStateRecordTmp = hslist[i]["judgState"];

		local judgStateRecord = 0;
		if judgStateRecordTmp == -1 then
			judgStateRecord = 0;
		elseif judgStateRecordTmp == 0 then
			judgStateRecord = 1;
		else
			judgStateRecord = judgStateRecordTmp;
		end;

		if hslist[i]["score"] == 1000000 then
			typeLightStatus = "pfc";
		end;

		if hslist[i]["failed"] == 1 then
			typeLightStatus = "failed";
		end;

		if hslist[i]["failed"] == 0 then
			typeLightStatus = "clear";
		end;	
		table.insert(hlistProc,{guid=hslist[i]["guid"],name=hslist[i]["name"],failed=hslist[i]["failed"],score=hslist[i]["score"],lightStatus=typeLightStatus,fc=hslist[i]["fc"],judg=judgStateRecord,dateScore=hslist[i]["dateScore"]});
	end;
	return hlistProc;
end;

local localMachineRecordItems = {};
local lmBaseXScreen = {400,-430};

local localRecordBaseX = 0;
local localRecordZoom = 0.45;
local localRecordY = SCREEN_CENTER_Y+120;
local localRecordActivePlayer;
local diffListTypeLocalRank = "";

if GAMESTATE:IsSideJoined(PLAYER_1) then
	localRecordBaseX = (SCREEN_CENTER_X+310);
	localRecordActivePlayer = PLAYER_1;
	diffListTypeLocalRank = getCustomOptionValuePlayer(PLAYER_1,"difficultyListMode");
else
	localRecordBaseX = (SCREEN_CENTER_X-310);
	localRecordActivePlayer = PLAYER_2;
	diffListTypeLocalRank = getCustomOptionValuePlayer(PLAYER_2,"difficultyListMode");
end;


if diffListTypeLocalRank == nil or #diffListTypeLocalRank == 0 then
	localRecordY = SCREEN_CENTER_Y+120; -- this is the default place
	localRecordZoom = 0.45;
else
	if diffListTypeLocalRank == defaultDifficultyListSkin() then
		localRecordY = SCREEN_CENTER_Y+120;
		localRecordZoom = 0.45;
	elseif diffListTypeLocalRank == "orbs" then
		localRecordY = SCREEN_CENTER_Y+180;
		localRecordZoom = 0.32;
	else
		localRecordY = SCREEN_CENTER_Y+120; -- this is the default place
		localRecordZoom = 0.45;
	end;
end;


t[#t+1] =  Def.ActorFrame {

	OnCommand=function(self)
		self:xy(localRecordBaseX, localRecordY);
		self:zoom(localRecordZoom);
		self:visible(false);
	end;	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/MACHINE_RANKING"))..{			
		Name="logoRankingOnline";
		OnCommand=function(self)
		end;
	};

	UpdateInfoCommand=function(self)


		local topScreen = SCREENMAN:GetTopScreen();				
		local recordsReg = getRankList(localRecordActivePlayer);

		for i=1,5 do
			localMachineRecordItems[i]:visible(false);				
		end;	


		if #recordsReg == 0 then
			localMachineRecordItems[1]:visible(true);
			localMachineRecordItems[1]:GetChild("nodata"):visible(true);
			localMachineRecordItems[1]:GetChild("placeRanking"):settext("");
			localMachineRecordItems[1]:GetChild("judgPlayerRank"):visible(false);
			localMachineRecordItems[1]:GetChild("fcomboTag"):stoptweening():visible(false);
			localMachineRecordItems[1]:GetChild("pfcTag"):stoptweening():visible(false);

		else
			localMachineRecordItems[1]:GetChild("nodata"):visible(false);
			localMachineRecordItems[1]:GetChild("judgPlayerRank"):visible(true);

			for i=1,#recordsReg do
				localMachineRecordItems[i]:visible(true);
				local place = i;
				local playerName = recordsReg[i]["name"];
				local itsFc = recordsReg[i]["fc"];
				local itsPfc = false;

				if recordsReg[i]["score"] == 1000000 then
					itsPfc = true;
				end;

				local judgRecord = recordsReg[i]["judg"];
				local scoreRecord = recordsReg[i]["score"];
				local letterRecord = gradeTransformState(recordsReg[i]["score"]);
				local dateRecord = "0/0/0000";
				local diffScore = 0;
				local itsMe = false;

				localMachineRecordItems[i]:GetChild("placeRanking"):stoptweening():settext(place);

				--LAMPS
				local stateLamp = 4;
				if itsPfc then
					stateLamp = 2;
					localMachineRecordItems[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("0.549,0.894,1,0")):effectcolor2(color("0.549,0.894,1,0.5")):effectperiod(0.1):visible(true):diffusealpha(0.25);
					localMachineRecordItems[i]:GetChild("pfcTag"):stoptweening():visible(true);
					localMachineRecordItems[i]:GetChild("backr_1"):stoptweening():setstate(3);
				elseif itsFc then
					stateLamp = 1;
					localMachineRecordItems[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("#FFA23900")):effectcolor2(color("#FFA239FF")):effectperiod(0.1):visible(true):diffusealpha(0.25);
					localMachineRecordItems[i]:GetChild("fcomboTag"):stoptweening():visible(true);
					localMachineRecordItems[i]:GetChild("backr_1"):stoptweening():setstate(2);
				else
					stateLamp = 4;
					localMachineRecordItems[i]:GetChild("lampRankingGlow"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("fcomboTag"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("pfcTag"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("backr_1"):stoptweening():setstate(1);
				end;
				localMachineRecordItems[i]:GetChild("lampRanking"):stoptweening():setstate(stateLamp);


				if recordsReg[i]["failed"] == 1 then
					localMachineRecordItems[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("#FF000000")):effectcolor2(color("#FF0000FF")):effectperiod(0.1):visible(true):diffusealpha(0.25);
					localMachineRecordItems[i]:GetChild("fcomboTag"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("pfcTag"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("fcomboTag"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("backr_1"):stoptweening():setstate(5);	
					localMachineRecordItems[i]:GetChild("lampRanking"):stoptweening():setstate(3);
				end;

				--NAME
				localMachineRecordItems[i]:GetChild("nameRank"):stoptweening():settext(playerName);

				--RANK
				local stateRank = gradeTransformState(tonumber(scoreRecord));
				if recordsReg[i]["failed"] == 0 then
					localMachineRecordItems[i]:GetChild("failPassRes"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("passRes"):stoptweening():setstate(stateRank);
					localMachineRecordItems[i]:GetChild("passRes"):stoptweening():visible(true);
					
				else
					localMachineRecordItems[i]:GetChild("passRes"):stoptweening():visible(false);
					localMachineRecordItems[i]:GetChild("failPassRes"):stoptweening():setstate(stateRank);
					localMachineRecordItems[i]:GetChild("failPassRes"):stoptweening():visible(true);					
				end;

				--SCORE
				local backScore = getZeroStringFromScore(scoreRecord);
				localMachineRecordItems[i]:GetChild("scoreBackRank"):stoptweening():settext(backScore);
				localMachineRecordItems[i]:GetChild("scoreFrontRank"):stoptweening():settext(scoreRecord);

				--JUDG
				if judgRecord == 1 then
					localMachineRecordItems[i]:GetChild("judgPlayerRank"):setstate(1);
				elseif judgRecord == 2 then
					localMachineRecordItems[i]:GetChild("judgPlayerRank"):setstate(2);
				elseif judgRecord == 3 then
					localMachineRecordItems[i]:GetChild("judgPlayerRank"):setstate(3);
				elseif judgRecord == 4 then
					localMachineRecordItems[i]:GetChild("judgPlayerRank"):setstate(4);
				else
					localMachineRecordItems[i]:GetChild("judgPlayerRank"):setstate(0);
				end;



				localMachineRecordItems[i]:GetChild("judgPlayerRank"):visible(true);
				localMachineRecordItems[i]:visible(true);
				localMachineRecordItems[i]:stoptweening():queuecommand("AniRecord");


			end;

		end;

	end;

	ChangeStepsMessageCommand=function(self,param)
		local topScreen = SCREENMAN:GetTopScreen();
		if topScreen:GetSelectionState() == "SelectingSteps" then
			self:stoptweening():queuecommand("UpdateInfo");
		end;
	end;

	StepsUnchosenMessageCommand=function(self,param)
		local topScreen = SCREENMAN:GetTopScreen();
		--SelectingSong <- con esto para ocultar.
		if topScreen:GetSelectionState() == "ConfirmSteps" then
				self:stoptweening():queuecommand("UpdateInfo");
		end;

		if topScreen:GetSelectionState() == "SelectingSong" then
			self:stoptweening();
			self:visible(false);
		end;
	end;		

	SongChosenMessageCommand=function(self)
		local topScreen = SCREENMAN:GetTopScreen();
		self:stoptweening();
		self:visible(true);
		self:stoptweening():queuecommand("UpdateInfo");
	end;

	SongUnchosenMessageCommand=function(self)
			self:stoptweening();
			self:visible(false);
	end;


};


for i=1,5 do

	t[#t+1] =  Def.ActorFrame {
		OnCommand=function(self)
			self:xy(localRecordBaseX, localRecordY);
			self:zoom(localRecordZoom);
			self:diffusealpha(0);
			self:queuecommand("AniRecord");
			self:visible(false);
			localMachineRecordItems[i] = self;
		end;

		AniRecordCommand=function(self)
			self:sleep(0.025 * (i-1));
			self:diffusealpha(0.8);
			self:x(localRecordBaseX-2);
			self:decelerate(0.4);
			self:x(localRecordBaseX+2);
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand = function(self) 
			self:visible(false);
		end;

		Def.Quad{
			Name="meMarkRecord";
			InitCommand=cmd(setsize,145,50;diffuse,color('1,1,1,1');visible,true;diffusealpha,1;x,-350;diffusealpha,0.6);
			OnCommand=function(self)
				self:y(78 + (90 * (i-1) ));
				self:zoom(1);
				self:cropleft(1);
			end;
			AniCommand=function(self)
				self:stoptweening();
				self:cropleft(1);
				self:fadeleft(0.7);				
				self:sleep(0.025 * (i-1));				
				self:linear(0.1);
				self:cropleft(0);

			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/bestbackrecord"))..{			
			Name="backr_1";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(1);
				
				self:y(80 + (90 * (i-1) ));
				self:zoom(1.1);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking//lamp_ranking"))..{			
			Name="lampRanking";
			InitCommand=cmd(x,-280;animate,false;setstate,0);
			OnCommand=function(self)
				self:y(77 + (90 * (i-1) ));
				self:zoom(1.1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/glow_lamp"))..{			
			Name="lampRankingGlow";
			InitCommand=cmd(x,-280;blend,"BlendMode_Add";visible,false);
			OnCommand=function(self)
				self:y(77 + (90 * (i-1) ));
				self:zoom(1.1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="passRes";
			InitCommand=cmd(x,232;visible,true;diffusealpha,1;animate,false;setstate,0);
			OnCommand=function(self)
				self:y(76 + (90 * (i-1) ));
				self:zoom(0.34);
			end;			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			Name="failPassRes";
			InitCommand=cmd(x,232;visible,false;diffusealpha,1;animate,false;setstate,0);
			OnCommand=function(self)
				self:y(76 + (90 * (i-1) ));
				self:zoom(0.34);
			end;	
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
			

		};

		LoadFont("_TitleXolonium")..{	
				Name="nameRank";
				InitCommand=function(self)
					self:zoom(0.9);
					self:horizalign("left");
					self:x(-295);
					self:settext("ANOTHERA");
					self:shadowlength(2);
					self:shadowcolor(color("#191919"));

				end;

				OnCommand=function(self)
					self:y(74 + (90 * (i-1) ));
					self:zoom(0.96);
				end;	

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("scorebg")..{	
				Name="scoreBackRank";
				InitCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:horizalign("left");
					self:settext("0000000");
					self:x(-105);			
				end;

				OnCommand=function(self)
					self:y(68 + (90 * (i-1) ));
					self:zoom(1);
				end;		

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadFont("scorebg")..{	
				Name="scoreFrontRank";
				InitCommand=function(self)
					self:zoom(0.9);
					self:horizalign("right");
					self:settext("0000000");
					self:x(160);	
				end;

				OnCommand=function(self)
					self:y(68 + (90 * (i-1) ));
					self:zoom(1);
				end;	

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
--[[
		LoadFont("xolonium 20px")..{
				Name="dateRecord";	
				OnCommand=function(self)
					self:horizalign("left");
					self:shadowlength(1);
					self:shadowcolor(color("#191919"));
					self:settext("2025/09/16");
					self:y(97 + (90 * (i-1) ));
					self:x(-78);
					self:zoom(1.1);
				end;

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
]]
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/judgPlayer"))..{
			Name="judgPlayerRank";
			OnCommand=function(self)
				self:x(350);
				self:animate(false);
				self:setstate(0);
				self:y(58 + (90 * (i-1) ));
				self:zoom(1.25);
			end;

			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadFont("interphase/InterNumber numbers").. {
			Name="placeRanking";
			InitCommand=function(self)
				self:visible(true);
				self:horizalign("right");
				self:settext("");
				self:x(-328);
			end;
				OnCommand=function(self)
					self:y(42 + (90 * (i-1) ));
					self:zoom(1.1);					
				end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/pfg"))..{
			Name="pfcTag";
			OnCommand=function(self)
				self:visible(false);
				self:diffusealpha(1);
				self:x(310);
				self:y(96 + (90 * (i-1) ));
				self:zoom(0.7);
			end;

			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/fullcombo"))..{
			Name="fcomboTag";
			OnCommand=function(self)
				self:visible(false);
				self:diffusealpha(1);
				self:x(310);
				self:y(100 + (90 * (i-1) ));
				self:zoom(0.7);
			end;		
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/bestbackrecord"))..{			
			Name="nodata";
			OnCommand=function(self)
				self:animate(false);
				self:y(80 + (90 * (0) ));
				self:zoom(1.1);
				self:setstate(4);
				self:visible(false);
			end;
		};

	};

end;



return t;