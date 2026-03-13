local dl_distance =63;
local dl_q = 12;
local arrayP={};
arrayP[1]=PLAYER_1;
arrayP[2]=PLAYER_2;
local t = Def.ActorFrame{};



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



--p1 y p2
local arrayBaseX={SCREEN_CENTER_X-145,SCREEN_CENTER_X+145};
local baseY = SCREEN_TOP+185;
local baseZoomLv=0.35;
for i=1,#arrayP do
	
	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepartistsprite"))..{
			OnCommand=function(self)
				self:visible(true):setstate(0):diffusealpha(1):animate(false):x(arrayBaseX[i]):y(baseY-30):zoom(baseZoomLv+0.15):visible(false);
				self:queuecommand("Show");
			end;
			ShowCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);

				if arrayP[i] == PLAYER_1 then
					self:addx(5);
				else
					self:addx(-5);
				end;

				if GAMESTATE:IsHumanPlayer(arrayP[i]) then
					local stepArtist = CurrentStep:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
					else
						self:visible(false);
					end;	
					self:stoptweening();
					self:linear(0.2);
				else
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

	t[#t+1] = LoadFont("_century gothic")..{
			OnCommand=cmd(x,arrayBaseX[i]+29;y,baseY-32;zoom,0.5;settext,"";horizalign,center;queuecommand,"artistStep");
			artistStepCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);

				if arrayP[i] == PLAYER_1 then
					self:addx(5);
				else
					self:addx(-5);
				end;

				if GAMESTATE:IsHumanPlayer(arrayP[i]) then					
					local stepArtist = CurrentStep:GetAuthorCredit();
					if #stepArtist > 0 then
						self:visible(true);
						self:settext(stepArtist);
					else
						self:settext("");
						self:visible(false);
					end;
				else
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


--BASIC MODE
if GAMESTATE:GetGameMode() == 'Basic' then

	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/basicBacklv"))..{
			OnCommand=function(self)
				self:visible(true):setstate(0):diffusealpha(1):animate(false):x(arrayBaseX[i]):y(baseY+22):zoom(baseZoomLv+0.1):visible(false);
				self:queuecommand("Show");
			end;
			ShowCommand=function(self)
				if GAMESTATE:IsHumanPlayer(arrayP[i]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);	

					local modeStateColorLevel = basicModeLevelStateAndColor(CurrentStep:GetMeter(),CurrentStep:GetStepsType());
					self:setstate(modeStateColorLevel["state"]);

					self:visible(true);
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

else

	t[#t+1] = Def.Quad{
			Name="BgRect";
			InitCommand=cmd(zoomto,40,60;x,arrayBaseX[i];y,baseY+23;skewx,-0.6;diffuse,color("1,0,0,0");visible,true;diffusealpha,0.5;queuecommand,"Ani"); -- rojo puro
			OnCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);
				local getNumPlayersChart = CurrentStep:GetPlayers();

				local colorMode = getColorByStepType(CurrentStep:GetStepsType(),getNumPlayersChart);
				self:diffuse(colorMode);

				if not GAMESTATE:IsHumanPlayer(arrayP[i]) then
					self:visible(false);
				end;
			end;
			AniCommand=function(self)
				self:fadebottom(1);
				self:fadetop(0.05);
				--self:queuecommand("Ani");
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};


	t[#t+1] = Def.Quad{
			Name="BgRect";
			InitCommand=cmd(zoomto,40,60;x,arrayBaseX[i];y,baseY+23;skewx,-0.6;diffuse,color("1,0,0,0");visible,true;diffusealpha,0.4;fadetop,0.9;fadebottom,0.3;blend,"BlendMode_Add";queuecommand,"Ani"); -- rojo puro
			OnCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);
				local getNumPlayersChart = CurrentStep:GetPlayers();

				local colorMode = getColorByStepType(CurrentStep:GetStepsType(),getNumPlayersChart);
				self:diffuse(colorMode);

				if not GAMESTATE:IsHumanPlayer(arrayP[i]) then
					self:visible(false);
				end;


			end;
			AniCommand=function(self)
				self:linear(4);
				self:diffusealpha(0.4);
				self:linear(4);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};	


	t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepnames"))..{
			OnCommand=function(self)
				self:visible(true):setstate(0):diffusealpha(1):animate(false):x(arrayBaseX[i]):y(baseY):zoom(baseZoomLv-0.05):zoomx(baseZoomLv+ 0.05):visible(false);
				self:queuecommand("Show");
			end;
			ShowCommand=function(self)
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);
				if GAMESTATE:IsHumanPlayer(arrayP[i]) then
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single' then
						self:setstate(0);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double' then
						self:setstate(1);					
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						self:setstate(5);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
						self:setstate(4);
					end;
					if  CurrentStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						self:setstate(1);		
						self:setstate(3);
					end;
					if CurrentStep:GetPlayers() ~= 1 then
						self:setstate(2);						
					end;

					self:visible(true);
					self:stoptweening();
					self:linear(0.2);
					
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


	t[#t+1] = LoadFont("level")..{
		OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(arrayP[i])):x(arrayBaseX[i]):y(baseY+20):zoomx(baseZoomLv):zoomy(baseZoomLv +0.1):queuecommand("Refresh");				
		end;

		FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
		RefreshCommand=function(self)
			if GAMESTATE:IsHumanPlayer(arrayP[i]) then
				local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);
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
				
				if GAMESTATE:GetMusicTrainChannel() or  GAMESTATE:GetProgressiveChannel()  then
					meter = "??";
				end;				
				self:settext(meter);				
			end;
		end;
	};	


	t[#t+1] = LoadFont("borderlevel")..{
			OnCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(arrayP[i])):x(arrayBaseX[i]):y(baseY+20):zoomx(baseZoomLv):zoomy(baseZoomLv +0.1):queuecommand("Refresh");				
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			
			RefreshCommand=function(self)		
				if GAMESTATE:IsHumanPlayer(arrayP[i]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(arrayP[i]);
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single' then
						self:diffuse(color("#eb1b00"));
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double' then
						self:diffuse(color("#21a305"));
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
					
					if GAMESTATE:GetGameMode() == 'Basic' then
						
						self:diffuse(color("#04bbc2"));
						if CurrentStep:GetMeter() > 2 and CurrentStep:GetMeter() <= 4 then
							self:diffuse(color("#f5b402"));
						end;			
						if CurrentStep:GetMeter() > 4 then
							self:diffuse(color("#ff0000"));	
						end;
						if CurrentStep:GetStepsType() == "StepsType_Pump_Double" then
							self:diffuse(color("#21a305"));
						end;

					end;
					
					if GAMESTATE:GetMusicTrainChannel() or  GAMESTATE:GetProgressiveChannel()  then
						if lastStepTypeTrain == "pump-single" then
							self:diffuse(color("#944f00"));
						end;
						if lastStepTypeTrain == "pump-double" then
							self:diffuse(color("#266219"));
						end;
						if lastStepTypeTrain == "pump-single-p" then
							self:diffuse(color("#7e0c7e"));
						end;
						if lastStepTypeTrain == "pump-double-p" then
							self:diffuse(color("#003391"));
						end;
						if lastStepTypeTrain == "pump-half" then
							self:diffuse(color("#007272"));
						end;
						meter = "??";
					end;
					
					self:settext(meter);
				end;
			end;
		};


end;



return t;