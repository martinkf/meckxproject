--[[
visibleCDLElements = 13;
CDLEx = 41.5;
GAMESTATE:GetGameMode() ~= 'Basic'
--]]
FullCDLElements = 15;
visibleCDLElements = 15

--Maybe we can stop the calls from the CDElements when we process all the items
--and if the song changes reset to 0 and all items call be called again to refresh.
LastCDLElementsProcesed = {};
for i = 1,FullCDLElements do
	table.insert(LastCDLElementsProcesed, false);
end;

function resetLastCDLElementsProcesed()
	for i = 1,FullCDLElements do
		LastCDLElementsProcesed[i] = false;
	end;
end;


CDLEx = 70
xajs = (visibleCDLElements-1)/2;


--FRAME DELAY
--why call the function every frame wtf or why was this way ._ .
local frameDelay = 4;
local t = Def.ActorFrame {};

local StepsColor = {
	StepsType_Pump_Single 		= color("#eb1b00"),
	StepsType_Pump_Double 		= color("#21a305"),
	StepsType_Pump_Single_P		= color("#7e0c7e"),
	StepsType_Pump_Double_P	= color("#003391"),
	Coop					= color("#f6ed00"),
	StepsType_Pump_Halfdouble	= color("#007272"),
};


local function GetCurrentSongIcon(n,elemnts)
	local steps = GetSteps();
	if not steps then return 7 end;
	if #steps > elemnts and n == elemnts then
		return 99;
	end;
	return GetIconLayer(n,steps) or 7;
end;

local function GetCurrentSongIconTrainOthers(n,elemnts)
	local steps = GetSteps();
	if not steps then return 7 end;
	if #steps > elemnts and n == elemnts then
		return 99;
	end;

	return GetIconLayerStepType(n,steps) or 7;

end;

local function CustomMeterforIcon(n,elemnts)
	local steps = GetSteps(), isCustom;
	if not steps then return "" end;
	if #steps > elemnts and n == elemnts then
		return #steps-elemnts+1
	elseif n > 0 and n <= #steps then
		if isCustom then
			DisplayLV(steps[n].meter);
		else
			return DisplayLV(steps[n]:GetMeter());
		end;
	end;
	return "";
end;

local function CustomMeterforIconTrainOthers(n,elemnts)
	local steps = GetSteps(), isCustom;

	if not steps then return "" end;

	if #steps > elemnts and n == elemnts then
		return #steps-elemnts+1
	elseif n > 0 and n <= #steps then
		return DisplayLV(steps[n].meter);
	end;

	return "";
end;

--obtiene el grado del jugador para un chart en particular
local function getGradePlayer(player,indexStep)
	local song = GAMESTATE:GetCurrentSong();
	local steps = GetCurrentStepfromList(indexStep);
	local scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(song,steps);
	local resp = {state=-1,isfailed=0};

	assert(scorelist)
	local scores = scorelist:GetHighScores();
	if (scores[1] == nil ) then 
		return resp; 
	end;

	local scorePlayer=scores[1]:GetPhoenixScore();

	local statePlayer = gradeTransformState(scorePlayer);
	local isFailed = 0;

	if scores[1]:GetFailedAux() then
		isFailed = 1;
	end;

	resp["state"] = statePlayer;
	resp["isfailed"] = isFailed;
	return resp;
end;

local function SimpleListUpdater(self,index)

	local LvText = self:GetChild("LvText");
	local LvBorder = self:GetChild("LvBorder");
	local CUSLABEL = self:GetChild("CUSLABEL");
	local DIFFLABEL = self:GetChild("DIFFLABEL");
	local Plus = self:GetChild("Plus");
	local Padlock = self:GetChild("Padlock");
	local backlvrect = self:GetChild("BgRect");
	local slGradeP1 = self:GetChild("slgradep1");
	local slGradeP1fail = self:GetChild("slgradep1fail");
	local slGradeP2 = self:GetChild("slgradep2");
	local slGradeP2fail = self:GetChild("slgradep2fail");	
	local basicMode = self:GetChild("bmode");
	slGradeP1fail:visible(false);
	slGradeP1:visible(false);

	slGradeP2fail:visible(false);
	slGradeP2:visible(false);	

    local topScreen = SCREENMAN:GetTopScreen()
    if topScreen:GetName() == "ScreenSelectMusic" and topScreen:GetSelectionState() == "SelectingSong" then

		if not GAMESTATE:GetProgressiveChannel() then	--and not GAMESTATE:GetQuestZoneChannel() then 

			local stype;
			local step;
			local custommeter;



			if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
				stype = GetCurrentSongIconTrainOthers(index,visibleCDLElements);
				step = GetCurrentStepfromList(index) or nil;
				custommeter = CustomMeterforIconTrainOthers(index,visibleCDLElements);

				if step ~= nil and (stype ~= 99 and stype ~= 7 ) then
					backlvrect:visible(true);
					backlvrect:diffuse(StepsColor[step.modes] or color("#eb1b00"));
					backlvrect:diffusealpha(0.8);

					LvText:settext(custommeter):horizalign(stype == 99 and left or center);
					LvBorder:settext(custommeter):horizalign(stype == 99 and left or center):diffuse(color("#919191"));	
					LvBorder:diffuse(StepsColor[step.modes] or color("#eb1b00"));
					CUSLABEL:setstate(0);
					DIFFLABEL:setstate(0);					
				else
					CUSLABEL:setstate(0);
					DIFFLABEL:setstate(0);
					backlvrect:visible(false);
					slGradeP1:visible(false);
					slGradeP2:visible(false);	
					LvText:settext("");
					LvBorder:settext("");				
				end;

			else
				stype = GetCurrentSongIcon(index,visibleCDLElements);
				step = GetCurrentStepfromList(index) or nil;
				custommeter = CustomMeterforIcon(index,visibleCDLElements);

				LvText:settext(custommeter):horizalign(stype == 99 and left or center);
				LvBorder:settext(custommeter):horizalign(stype == 99 and left or center):diffuse(color("#919191"));
				Plus:visible(false);
				Padlock:visible(false);
				
				if step and (stype ~= 99 and stype ~= 7 ) then


					local tlabel = string.lower(LabelTypeToMode(step:GetLabelType()));		--regresa string
					local clabel = string.lower(DesCustomLabel(step:GetDescription()));		--regresa string
					local setlclabel = setNormalLabelState(tlabel, clabel);		-- regresa num
					local StepsType = step:GetStepsType();
					local getNumPlayersChart = step:GetPlayers();

					backlvrect:visible(true);


					local colorMode = getColorByStepType(StepsType,getNumPlayersChart);
					backlvrect:diffuse(colorMode);
					LvBorder:diffuse(colorMode);
					
					backlvrect:diffusealpha(0.8);


					if GAMESTATE:GetGameMode() == 'Basic' then						
						basicMode:visible(true);
						basicMode:zoom(0.34);
						backlvrect:visible(false);

						local meterSong = step:GetMeter();

						local modeStateColorLevel = basicModeLevelStateAndColor(meterSong,StepsType);
						LvBorder:diffuse(color(modeStateColorLevel["color"]));
						basicMode:setstate(modeStateColorLevel["state"]);
					else
						basicMode:visible(false);
					end;


					--intentamos obtener la letra del jugador.
					if GAMESTATE:IsHumanPlayer(PLAYER_1) then
						local gradeP1 = getGradePlayer(PLAYER_1,index);
						if(gradeP1["state"] > -1) then
							if gradeP1["isfailed"] == 1 then
								slGradeP1fail:setstate(gradeP1["state"]);
								slGradeP1fail:visible(true);	
							else
								slGradeP1:setstate(gradeP1["state"]);
								slGradeP1:visible(true);		
							end;

						end;
					end;

					if GAMESTATE:IsHumanPlayer(PLAYER_2) then
						local gradeP2 = getGradePlayer(PLAYER_2,index);
						if(gradeP2["state"] > -1) then
							if gradeP2["isfailed"] == 1 then
								slGradeP2fail:setstate(gradeP2["state"]);
								slGradeP2fail:visible(true);									
							else
								slGradeP2:setstate(gradeP2["state"]);
								slGradeP2:visible(true);
							end;
						end;
					end;

					if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
						if StepsType == "StepsType_Pump_Double" or StepsType == "StepsType_Pump_Double_P" or StepsType == "StepsType_Pump_Halfdouble" then
							slGradeP1fail:visible(false);
							slGradeP1:visible(false);

							slGradeP2fail:visible(false);
							slGradeP2:visible(false);
						end;					
					end;
					-- fin grados


					if step:GetPlayers() ~= 1 then
						local xplayers = "x"..step:GetPlayers();
						LvText:settext(xplayers);
						LvBorder:settext(xplayers):diffuse(color("#8f752e"));
					end;
					if GAMESTATE:GetQuestZoneChannel() then
						CUSLABEL:setstate(0);
						DIFFLABEL:setstate(0);
						if tlabel == "s2" then
							local chk = CheckLock("S1", GAMESTATE:GetMasterPlayerNumber())
							Padlock:visible(chk);
						elseif tlabel == "s3" then
							local chk = CheckLock("S2", GAMESTATE:GetMasterPlayerNumber())
							Padlock:visible(chk);
						elseif tlabel == "s4" then
							local chk = CheckLock("S3", GAMESTATE:GetMasterPlayerNumber())
							Padlock:visible(chk);
						end;
					else
						local nlabel = 0;
							nlabel = tlabel == "ucs" and 2 or nlabel;
							nlabel = tlabel == "another" and 3 or nlabel;
						CUSLABEL:setstate(nlabel == 0 and setlclabel or 0);
						DIFFLABEL:setstate(nlabel);
					end;
				else
					
					CUSLABEL:setstate(0);
					DIFFLABEL:setstate(0);
					backlvrect:visible(false);
					slGradeP1:visible(false);
					slGradeP2:visible(false);
					basicMode:visible(false);

				end;
				
				if stype == 99 then
					Plus:visible(true);
				end
			end;

		else
			LvText:settext("");
			LvBorder:settext("");
			CUSLABEL:setstate(0);
			DIFFLABEL:setstate(0);
			Plus:visible(false);
			Padlock:visible(false);
			backlvrect:visible(false);
			slGradeP1:visible(false);
			slGradeP2:visible(false);			
		end;
	end;

	--item ready.
	LastCDLElementsProcesed[index] = true;
end;




local sleepBaseLv=0;
for i = 1, FullCDLElements, 1 do

	t[#t + 1] = Def.ActorFrame {

		--niveles
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/CUSLABELS"))..{
			Name="CUSLABEL";
			InitCommand=cmd(zoom,.45;xy,0,21;animate,false;setstate,0);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DIFFLABELS"))..{
			Name="DIFFLABEL";
			InitCommand=cmd(zoom,.45;xy,0,21;animate,false;setstate,0);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/Plus (doubleres)"))..{
			Name="Plus";
			InitCommand=cmd(zoom,.75;xy,-8,3;visible,false;);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/basicBacklv"))..{
			Name="bmode";
			InitCommand=cmd(zoom,.75;xy,0,2;visible,false;animate,false;setstate,0);
			CurrentSongChangedMessageCommand=function(self)
				if GAMESTATE:GetGameMode() == 'Basic' then	
					self:stoptweening();
					self:diffusealpha(0);
					self:sleep(sleepBaseLv);
					self:accelerate(0.18);
					self:diffusealpha(1);
				else
					self:visible(false)
				end;
			end;
		};		


		Def.Quad{
			Name="BgRect";
			InitCommand=cmd(zoomto,38,43;xy,8,5;skewx,-0.6;diffuse,color("1,0,0,0");visible,false;diffusealpha,0.8;queuecommand,"Ani"); -- rojo puro
			AniCommand=function(self)
				self:fadebottom(1);
				self:fadetop(0.05);
				--self:queuecommand("Ani");
			end;
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,0.6;queuecommand,"Ani");
		};

		Def.Quad{
			Name="BgRect";
			InitCommand=cmd(zoomto,38,43;xy,8,5;skewx,-0.6;diffuse,color("1,0,0,0");visible,false;diffusealpha,0.6;fadetop,0.9;fadebottom,0.3;blend,"BlendMode_Add";queuecommand,"Ani"); -- rojo puro
			AniCommand=function(self)
				self:linear(1.5);
				self:fadetop(0.9);
				self:decelerate(2);
				self:fadetop(0.5);
				self:queuecommand("Ani");
			end;
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,0.6;queuecommand,"Ani");
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

		LoadFont("Level")..{
			Name="LvText";
			InitCommand=cmd(xy,1,0;shadowlength,0;zoom,0.3;maxwidth,50/.22);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1;);
		};

		LoadFont("new_borderlevel/newBorderLevel")..{	
			Name="LvBorder";
			InitCommand=cmd(xy,1.2,0;shadowlength,0;zoom,0.3;maxwidth,50/.22;diffuse,color("#c1c1c1"));
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/Padlock"))..{
			Name="Padlock";
			InitCommand=cmd(zoomx,0.28;zoomy,0.22;xy,6,6;visible,false;);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};

		--p1
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="slgradep1";
			InitCommand=cmd(zoom,0.63;xy,18,-17;visible,false;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep1fail";
			InitCommand=cmd(zoom,0.63;xy,18,-17;visible,false;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};		
		--p2
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="slgradep2";
			InitCommand=cmd(zoom,0.63;xy,-2,29;visible,false;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};		
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="slgradep2fail";
			InitCommand=cmd(zoom,0.63;xy,-2,29;visible,false;animate,false;setstate,1);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,sleepBaseLv;accelerate,0.18;diffusealpha,1);
		};				
		
		FullModeMessageCommand=cmd(stoptweening;queuecommand,"UpdatePos");
		RankModeMessageCommand=cmd(stoptweening;queuecommand,"UpdatePos");


		OnCommand=function(self)
			self:SetUpdateFunction(function(self)
				--we stop calling simpleListUpdate if the items are ready...
				if framesCounterSDL % frameDelay == 0 and LastCDLElementsProcesed[i] == false then
					SimpleListUpdater(self, i)
				end;
			end);
			self:playcommand("UpdatePos");
		end;

		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening();
			--reset status of all level items.
			resetLastCDLElementsProcesed();
			self:queuecommand("UpdatePos");
		end;


		UpdatePosCommand=function(self)

			local steps = GetSteps();
			if steps ~= nil then
				xajs = (math.min(#steps,visibleCDLElements)-1)/2;
				self:xy(SCREEN_CENTER_X-(xajs*CDLEx)+(CDLEx*(i-1)),SCREEN_CENTER_Y*1.63-116);

				if GAMESTATE:GetGameMode() == 'Basic' then	
					self:xy(SCREEN_CENTER_X-(xajs*CDLEx)+(CDLEx*(i-1)),SCREEN_CENTER_Y*1.63-110);
				else
					self:xy(SCREEN_CENTER_X-(xajs*CDLEx)+(CDLEx*(i-1)),SCREEN_CENTER_Y*1.63-116);
				end;

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
end;

return t;