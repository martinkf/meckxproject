-- no necesitamos mas el archivo de Others

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


function StepDetailView(pn,tdata)
--	if not pn or not GAMESTATE:IsHumanPlayer(pn) then return Def.ActorFrame{} end;
	local xpos = pn == PLAYER_1 and -1 or 1
	local chartInfo = {
		sltr = 6,
		lv = "00",
		sType = 1,
		stpartist = "StepArtist_Name_Here",
		dlabel = 2,
		clabel = 2,
	}
	
	if tdata then
		if tdata._type == "song" and tdata.step then	--necesitamos agregar los demas tipos
			if tdata.step then
				local step = tdata.step
				local iconstate = DirectIconLayer2(step);
				if pn == PLAYER_2 then
					if iconstate == 2 or iconstate == 4 then
						iconstate = iconstate+1
					end;
				end;
				local labeltype = string.lower(LabelTypeToMode(step:GetLabelType()))
				local clabeldesc = string.lower(DesCustomLabel(step:GetDescription()))
				
				chartInfo.sltr = DirectIconLayer(step);
				chartInfo.lv = DisplayLV(step:GetMeter());
				chartInfo.sType = iconstate;
				chartInfo.stpartist = FixedChartCreditNames(step:GetAuthorCredit());
				chartInfo.dlabel = (labeltype == "ucs" and 2) or (labeltype == "another" and 3) or 0;
				chartInfo.clabel = setNormalLabelState(labeltype, clabeldesc);
			end;
		end;
	end;
	
	return Def.ActorFrame{
		Def.ActorFrame{
			Name = "Level",
			InitCommand = cmd(xy,-59 * xpos,-8;	),
		--	Def.Quad {		InitCommand=cmd(zoomto,88,60;diffuse,color("#7B68EE"););	};	--test
			LoadFont("Russo_One/Russo One outline 40px")..{
				Name = "Label",
				Text = "Lv",
				InitCommand = cmd(xy,-32,15;zoom,0.46;),
			},
			LoadFont("Level")..{		
				Name="TextA";	
				Text = chartInfo.lv;		
				OnCommand=cmd(xy,13,-2;zoom,.45;zoomx,.45*.96;);	
			};
			LoadFont("borderlevel")..{	
				Name="TextB";		
				Text = chartInfo.lv,		
				OnCommand=cmd(xy,13,-2;zoom,.45;zoomx,.45*.96;diffuse,color("#eb1b00");shadowlength,1;);	
			};		
		},

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepnames"))..{
			Name="TypeIcon";
			OnCommand=cmd(animate,false;setstate,4;xy,0*xpos,-10;zoom,.36);
		};


		LoadFont("scorebg")..{	
				Name="scoreBackMyBestLvl";
				OnCommand=cmd(queuecommand,"SetPos";xy,-10*xpos,5);
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.3);
					self:horizalign("left");
					self:settext("0");
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("scorebg")..{	
				Name="scoreFrontMyBest";
				OnCommand=cmd(queuecommand,"SetPos";y,5;x,70*xpos;);
				SetPosCommand=function(self)
					self:zoom(0.3);
					self:horizalign("right");
					self:settext("980000");
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/glowselector_level"))..{
			Name="glowSelector";
			InitCommand=cmd(x,20*xpos;y,-2;zoom,0.65;zoomx,0.8;fadeleft,0.8;animate,false;setstate,0);
			OnCommand=function(self)
				
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/selector_pfg"))..{
			Name="pfgselector";
			OnCommand=function(self)
				self:x(100*xpos);
				self:y(-12);
				self:zoom(0.75);
				if pn == PLAYER_1 then
					self:rotationy(180);
				end;
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/selector_fullcombo"))..{
			Name="fcselector";
			OnCommand=function(self)
				self:x(100*xpos);
				self:y(-12);
				self:zoom(0.68);
				if pn == PLAYER_1 then
					self:rotationy(180);
				end;
			end;
		};		


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade"))..{
			Name="gradescore";
			InitCommand=cmd(zoom,0.56;xy,91,8;animate,false;setstate,0);
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade"))..{
			Name="gradescorefail";
			InitCommand=cmd(zoom,0.56;xy,91,8;animate,false;setstate,0);
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/DIFFLABELS"))..{
			Name = "DLabel",
			InitCommand = cmd(zoom,0.6;xy,-45 * xpos,18;animate,false;setstate,chartInfo.dlabel;),
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/CUSLABELS"))..{
			Name = "CLabel",
			InitCommand = cmd(zoom,0.6;xy,-45 * xpos,18;animate,false;setstate,chartInfo.clabel;),
		};
		Def.ActorFrame{
			Name = "Padlock",
				InitCommand = cmd(xy,0,0;visible,false),
			
			LoadActor(THEME:GetPathG("","ScreenSelectMusic/SM-BACKTITLE"))..{
				InitCommand = cmd(zoom,.56;xy,16 * xpos,0;diffusealpha,1;zoomy,0.75;diffusecolor,color("#ffff00")),
			},
			LoadActor(THEME:GetPathG("","ScreenSelectMusic/Padlock"))..{
				InitCommand = cmd(zoom,0.26;xy,-46 * xpos,-2;),
			},
			LoadFont("_TitleXolonium")..{
				Text="Locked";
				InitCommand=cmd(zoom,.6;xy,20*xpos,-2;skewx,-0.16;);
			},
		};

	}
end

displayRange = 2;
loopingBehaviorElements = displayRange + 2;
visibleElements = 2 * displayRange + 1;
totalEDLElements = visibleElements + 2; -- additional 2 to allow for smooth animation of elements fading in
EDLEy = 46;
EDLEx = 14;
newYVertical = SCREEN_CENTER_Y * 1.58;



local function ListUpdatePosition(self, pn, positionOffset)
	local newy = (positionOffset) * EDLEy;
	local newx = math.abs(positionOffset) * (pn == PLAYER_1 and -1 or 1) * EDLEx;
	-- local newx = positionOffset * (pn == PLAYER_1 and 1 or -1) * EDLEx;
	local df = 0
	local isVisible = math.abs(positionOffset) <= displayRange

	if isVisible then
		df = math.max(math.abs(positionOffset),0)
		df = 1-(df*.46)
	end

	self:y(newy):x( newx ):z(math.abs(positionOffset)*-24):diffusealpha(df);
end

local function ListUpdaterInfinite(self, pn, index, dir)
    local children = {
        lva = self:GetChild("Level"):GetChild("TextA"),
		lvb = self:GetChild("Level"):GetChild("TextB"),
		llv = self:GetChild("Level"):GetChild("Label"),
        typeIcon = self:GetChild("TypeIcon"),
        cusLabel = self:GetChild("CLabel"),
        diffLabel = self:GetChild("DLabel"),
		Padlock = self:GetChild("Padlock"),
		scoreNumberBack = self:GetChild("scoreBackMyBestLvl"),
		scoreNumberFront = self:GetChild("scoreFrontMyBest"),
		gradescore = self:GetChild("gradescore"),
		gradescorefail = self:GetChild("gradescorefail"),
		glowSelector = self:GetChild("glowSelector"),
		pfgStars = self:GetChild("pfgselector"),
		fcStars = self:GetChild("fcselector"),
    }
	local StepsxPos = {
		StepsType_Pump_Single 		= 28,
		StepsType_Pump_Double 		= 34,
		StepsType_Pump_Single_P		= 42,
		StepsType_Pump_Double_P		= 48,
		StepsType_Pump_Halfdouble	= 34,
	};

			local nsteps = GetSteps()
			local loopingBehavior = false;

			if #nsteps >= loopingBehaviorElements then
				loopingBehavior = true
				self:visible(true);
			elseif index <= #nsteps then
				self:visible(true);
			else
				self:visible(false);
				return;
			end;

			local stepindex = 0

			if loopingBehavior then
				stepindex = (index+GetActiveIndex(pn)-displayRange-3)%#nsteps+1
			else
				stepindex = index
			end

			local step, custom = GetCurrentStepfromList(stepindex);

            
			local scoreLevel = {score=0,failed=0};
			local scoreBacklevel="";
			local lvDebug = "";
            if step then

            	--obtenemos los datos del record de este modo si es que lo tiene
            	scoreLevel = GetHighScoreAndStateFromStepsPlayer(step,pn);
            	scoreBacklevel = getZeroStringFromScore(scoreLevel["score"]);
				children.scoreNumberBack:visible(true);
				children.gradescore:visible(true);
				children.gradescorefail:visible(true);
				children.scoreNumberFront:visible(true);

				if custom then
					local StepsType = step.modes;
		
					local tlabel = string.lower(LabelTypeToMode(step.label))
					local clabel = string.lower(DesCustomLabel(step.cuslabel))
					local setlclabel = setNormalLabelState(tlabel, clabel)
					local nlabel = (tlabel == "ucs" and 2) or (tlabel == "another" and 3) or 0
					local fixlv = DisplayLV(step.meter)
					
					children.lva:settext(fixlv)
					children.lvb:settext(fixlv):diffuse(StepsColor[StepsType] or color("#eb1b00"));
					children.llv:diffusealpha(1)
					local xdir = pn == PLAYER_1 and -1 or 1;
					local xPos = StepsxPos[StepsType] or 0;					

					children.typeIcon:setstate(StepsState[StepsType] or 0):x(xPos*xdir):diffusealpha(1);
					children.Padlock:visible(false);	
					
					children.cusLabel:setstate(nlabel == 0 and setlclabel or 0)
					children.diffLabel:setstate(nlabel)
					
						if step.players ~= 1 then
							children.typeIcon:setstate(2):x(34*xdir):diffusealpha(1);
							local xplayers = "x"..step:GetPlayers();
							children.lva:settext(xplayers);
							children.lvb:settext(xplayers):diffuse(color("#8f752e"));
						end;
				else
					if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
                children.lva:settext("")
				children.lvb:settext("")
				children.llv:diffusealpha(0)
                children.typeIcon:setstate(0):diffusealpha(0);
                children.cusLabel:setstate(0)
                children.diffLabel:setstate(0)
				children.Padlock:visible(false)
				children.scoreNumberBack:visible(false)
				children.gradescore:visible(false);
				children.gradescorefail:visible(false);
				children.scoreNumberFront:visible(false);
						return;
					end;
					local StepsType = step:GetStepsType();
				
					local tlabel = string.lower(LabelTypeToMode(step:GetLabelType()))
					local clabel = string.lower(DesCustomLabel(step:GetDescription()))
					local setlclabel = setNormalLabelState(tlabel, clabel)
					local nlabel = (tlabel == "ucs" and 2) or (tlabel == "another" and 3) or 0
					
					local fixlv = DisplayLV(step:GetMeter())
					lvDebug = fixlv;
					children.lva:settext(fixlv)
					children.lvb:settext(fixlv):diffuse(StepsColor[StepsType] or color("#eb1b00"));
					children.llv:diffusealpha(1)
					local xdir = pn == PLAYER_1 and -1 or 1;
					local xPos = StepsxPos[StepsType] or 0;
					children.typeIcon:setstate(StepsState[StepsType] or 0):x(xPos*xdir):diffusealpha(1);
					children.Padlock:visible(false);
					
					children.cusLabel:setstate(nlabel == 0 and setlclabel or 0)
					children.diffLabel:setstate(nlabel)
					
						if step:GetPlayers() ~= 1 then
							children.typeIcon:setstate(2):x(34*xdir):diffusealpha(1);
							local xplayers = "x"..step:GetPlayers();
							children.lva:settext(xplayers);
							children.lvb:settext(xplayers):diffuse(color("#8f752e"));
						end;
						
						if GAMESTATE:GetQuestZoneChannel() then
							if tlabel == "s2" then
								local chk = CheckLock("S1", pn)
								children.Padlock:visible(chk);
							elseif tlabel == "s3" then
								local chk = CheckLock("S2", pn)
								children.Padlock:visible(chk);
							elseif tlabel == "s4" then
								local chk = CheckLock("S3", pn)
								children.Padlock:visible(chk);
							end;
						end;
				end;	
            else
                children.lva:settext("")
				children.lvb:settext("")
				children.llv:diffusealpha(0)
                children.typeIcon:setstate(0):diffusealpha(0);
                children.cusLabel:setstate(0)
                children.diffLabel:setstate(0)
				children.Padlock:visible(false)
				children.scoreNumberBack:visible(false)
				children.gradescore:visible(false);
				children.gradescorefail:visible(false);
				children.scoreNumberFront:visible(false);
            end
		
				local positionOffset = 0

				if loopingBehavior then
					positionOffset = index - displayRange - 2
				else
					local activeIndex = GetActiveIndex(pn)		--centro
					--limite (pares + offset 0)
					positionOffset = stepindex - activeIndex
					if positionOffset > displayRange then
						positionOffset = positionOffset - #nsteps
					end
					if positionOffset < -displayRange then
						positionOffset = positionOffset + #nsteps
					end
				end

				if dir == 0 then
					self:finishtweening()
				elseif loopingBehavior then
					self:finishtweening()
					ListUpdatePosition(self, pn, positionOffset + dir)
					self:decelerate(0.125)
				else
					self:stoptweening():decelerate(0.125);
				end;

				ListUpdatePosition(self, pn, positionOffset)

				--ranking por score
				if pn == PLAYER_1 then --por alguna razon el p1 se descuadra y me da paja revisar >:(
					children.scoreNumberBack:x(-70);
					children.scoreNumberFront:x(10);
					children.gradescore:x(-94);
					children.gradescorefail:x(-94);
					local xPos = StepsxPos[StepsType] or 0;
					local xdir = pn == PLAYER_1 and -1 or 1;
					children.typeIcon:x((xPos+25)*xdir);
					children.glowSelector:rotationy(180);
				end;

				--obtenemos los datos y los colocamos
				children.scoreNumberBack:diffusealpha(1);
				children.scoreNumberFront:diffusealpha(1);
				children.gradescore:diffusealpha(0);
				children.gradescorefail:diffusealpha(0);
				

				--score front
				children.scoreNumberFront:settext(scoreLevel["score"]);
				--score back (00000)
				--children.scoreNumberBack:settext(scoreBacklevel);	
				children.scoreNumberBack:settext(scoreBacklevel);	

				if scoreLevel["fullcombo"] == 1 and scoreLevel["score"] < 1000000 then
					children.fcStars:diffusealpha(1);
				else
					children.fcStars:diffusealpha(0);
				end;

				if scoreLevel["score"] > 999999 then
					children.pfgStars:diffusealpha(1);
				else
					children.pfgStars:diffusealpha(0);
				end;



				--letra
				if scoreLevel["failed"] == 1 then
					local gradeState= gradeTransformState(scoreLevel["score"]);
					children.gradescorefail:setstate(gradeState);
					children.gradescorefail:diffusealpha(1);
					children.glowSelector:setstate(0);
				else
					children.glowSelector:diffusealpha(0);
					if scoreLevel["score"] > 0 then
						local gradeState= gradeTransformState(scoreLevel["score"]);
						children.gradescore:setstate(gradeState);					
						children.gradescore:diffusealpha(1);

						if scoreLevel["score"] > 999999 then
							children.glowSelector:setstate(2);
						end;						
					end;
				end;
				
				if df == 0 then --centro
					self:zoom(0.86);
					children.glowSelector:diffusealpha(0);
					if scoreLevel["failed"] == 1 then
						children.glowSelector:diffusealpha(1);
					end;

				else
					self:zoom(0.76);
					children.glowSelector:diffusealpha(0);
				end;		
end


function ScrollerList(pn)
local t = Def.ActorFrame{};
	for i = 1, totalEDLElements, 1 do
		t[#t + 1] = Def.ActorFrame {
			OnCommand=cmd(zoomx,0;zoom,1.16;);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0;decelerate,0.2;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1;accelerate,0.2;diffusealpha,0);
			StepDetailView(pn)..{
				InitCommand = cmd(zoom,.86);
				SongChosenMessageCommand=function(self)
					ListUpdaterInfinite(self, pn, i, 0)
				end;
				ChangeStepsMessageCommand=function(self,param)
					if param.Player == pn then
						ListUpdaterInfinite(self, pn, i, param.Direction)
					end
				end;
				OnCommand=function(self)
					if not GAMESTATE:IsHumanPlayer(pn) then
						self:visible(false);
						return;
					end;
				end;
			};
		};
	end;
	return t;
end;

return t;