local vStats = STATSMAN:GetCurStageStats();
local iGrade = 8;
local pnStats = vStats:GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() );
iGrade = TierToState(pnStats:GetGrade());
local sResult = pnStats:GetSuccess() and "S" or "F";

local function GetCustomY(object)
	local sMach = GetMachineName();
	-- 1 : white belt
	-- 0 : black belt
	-- FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
	if sMach ~= "UNKNOWN" then
		if object == 1 then
			return -218;
		elseif object == 2 then
			return 186;
		elseif object == 3 then
			return 188;
		elseif object == 4 then
			return 275;
		elseif object == 5 then
			return -20;
		elseif object == 6 then
			return 77;
		else
			return -190;
		end;
	else
		if object == 1 then
			return -218;
		elseif object == 2 then
			return 218;
		elseif object == 3 then
			return 221;
		elseif object == 4 then
			return 295;
		elseif object == 5 then
			return -77;
		elseif object == 6 then
			return 17;
		else
			return -190;
		end;
	end;
end;

local DelayGradeShow = 4.7;
local DelayMissionResult = 6.3;
local WaitUntilDrum = 1.1;
local DelayNewRecord = 8;
local DelayDrum = 0.08;
local DrumGonnaEnd = false;

local function EvalRollingNumbers(text, del_text, xlim, ylim, horiza, final)
	local r = Def.ActorFrame {};
	local dir;
	if (horiza=='HorizAlign_Left') then dir = 1; else dir = -1; end;
	local cur={};
	local xx= 17;
	for i=1,#text do
		cur[i]=0;
		r[#r+1] = Def.RollingNumbers {
			File = THEME:GetPathF("","evalscore");
			OnCommand=cmd(Load,"RollingNumbers";horizalign,horiza;sleep,WaitUntilDrum;settext,"";x,xlim+dir*(i-1)*xx;y,ylim;zoom,1.14;diffusealpha,1;sleep,del_text+(i-1)*(.2);queuecommand,'Lot');
			LotCommand=function(self)
				self:sleep(0.03);
				self:settext(math.random(0,9));
				cur[i]=cur[i]+1;
				if cur[i] < 10 then
					self:queuecommand("Lot");
				else
					if dir == -1 then
						self:settext(string.sub(text,#text-(i-1),#text-(i-1)));
					else
						self:settext(string.sub(text,i,i));
					end;
					
					if final and i == #text then
						DrumGonnaEnd = true;
					end;
				end;
			end;
		};
	end;
	return r;
end;
local function Drum(wait,delay)
	local r = Def.ActorFrame {};
	local bOffScreen = false;
	for i=0,40 do
		r[#r+1] = Def.Sound {
			OnCommand=cmd(sleep,wait + (delay*i);queuecommand,'Lot');
			LotCommand=function(self)
				if not bOffScreen then
					if not DrumGonnaEnd then
						SOUND:PlayOnce(THEME:GetPathS("","EVAL_DRUM"));
						self:sleep(delay);
					end;
				end;
			end;
			OffCommand=function(self)
				bOffScreen = true;
			end;
		};
	end;
	return r;
end;
local bTier = 0;
local tStatsGlobal ={};
local bothfailed={true,true};


local yStatPos = 205;
local xStatPos = 420;
local xRollPos = 400;
local SnapDistance = 32.7;
local function CreateStats( pnPlayer )

	Trace("GENERATING STATS FOR:"..pnPlayer);
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );
	tStatsGlobal = {		
		Chapter		= GAMESTATE:GetCurrentSong():GetTranslitArtist();
		Desc		= GAMESTATE:GetCurrentSteps(pnPlayer):GetQuestDesc();
		Success		= pnStageStats:GetSuccess();
	};	
	local tStats = {
		Perfect 	= pnStageStats:GetTapNoteScores("TapNoteScore_W1") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_W2") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointHit");		
		Great		= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		Good		= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		Bad			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores("TapNoteScore_Miss") +
					  pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
		MaxCombo 	= pnStageStats:MaxCombo();
		MissCombo 	= pnStageStats:MaxMissCombo();--3q3q3q
		Heart		= pnStageStats:GetTapNoteScores("TapNoteScore_Heart");
		Potion		= pnStageStats:GetTapNoteScores("TapNoteScore_Potion");
		Mine		= pnStageStats:GetTapNoteScores("TapNoteScore_HitMine");
		Velocity	= pnStageStats:GetTapNoteScores("TapNoteScore_Velocity");
		BrainO		= pnStageStats:GetTapNoteScores("TapNoteScore_BrainO");
		BrainX		= pnStageStats:GetTapNoteScores("TapNoteScore_BrainX");
		Life		= pnStageStats:GetCurrentLife();
		Score		= pnStageStats:GetScore();
		Grade		= pnStageStats:GetGrade();
		TierGrade	= gradeTransformState(pnStageStats:GetScore());
		
		Failed		= pnStageStats:GetFailedAux();
	};
	if pnPlayer == PLAYER_1 then
		bothfailed[1] =tStats["Failed"];
	end;
	if pnPlayer == PLAYER_2 then
		bothfailed[2] =tStats["Failed"];
	end;
	local tValues = {
		CURRENT			= ( tStats["Perfect"]*10 + tStats["Great"]*5 + tStats["Good"]*1 + tStats["Bad"]*-2 + tStats["Miss"]*-5), 
		MAX		= ( tStats["Perfect"] + tStats["Great"] + tStats["Good"] + tStats["Bad"] + tStats["Miss"] )*10,
	};
	tValues["CURRENT"] = (100*tValues["CURRENT"])/tValues["MAX"];
	if tValues["CURRENT"] < 0 then
		tValues["CURRENT"] = 0;
	end;
	tValues["MAX"] = 100;	
	local statsAux={};
	statsAux[1] ="Perfect";
	statsAux[2] ="Great";
	statsAux[3] ="Good";
	statsAux[4] ="Bad";
	statsAux[5] ="Miss";
	statsAux[6] ="MaxCombo";
	statsAux[7] ="MissCombo";
	statsAux[8] ="Heart";
	statsAux[9] ="Potion";
	statsAux[10] ="Mine";
	statsAux[11] ="Velocity";
	statsAux[12] ="BrainO";
	statsAux[13] ="BrainX";
	statsAux[14] ="Life";
	statsAux[15] ="Score";
	tStats["Life"] = round(tStats["Life"],2) * 100;
	local xSide;
	local xAlign;
	local xAuxX;
	xSide = 1;
	xAlign = 'HorizAlign_Right';
	xAuxX=0;
	

	local t = Def.ActorFrame {};
	
	local iAux2Player = 0;
	if GAMESTATE:GetNumSidesJoined() == 2 then
		iAux2Player = 250;
	end;

	--letras
	if tStats["Failed"] then

		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			OnCommand=cmd(Center;addx,iAux2Player*xSide;addy,0;animate,false;setstate,tStats["TierGrade"];zoom,1.4;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,1.2;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
	else

		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			OnCommand=cmd(Center;addx,iAux2Player*xSide;addy,0;animate,false;setstate,tStats["TierGrade"];zoom,1.8;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,1.2);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			OnCommand=cmd(Center;addx,iAux2Player*xSide;;addy,0;animate,false;setstate,tStats["TierGrade"];zoom,0.8325;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.2;diffusealpha,1;zoom,0.95;linear,0.4;zoom,1.8;diffusealpha,0;blend,Blend.Add);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;

	--[[
	if TierToState(tStats["Grade"]) == 0 then
		t[#t+1] = LoadActor(THEME:GetPathG("","SE-FXFLARE"))..{
			OnCommand=cmd(Center;addx,iAux2Player*xSide;addy,-25;animate,false;zoom,0.3325;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;linear,0.25;zoom,1.5;diffusealpha,0;blend,Blend.Add);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;
	]]

	--if TierToState(tStats["Grade"]) == 0 then
	--	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
	--		OnCommand=cmd(Center;addy,-50;animate,false;setstate,1;zoom,1;diffusealpha,0;sleep,5;linear,0.2;diffusealpha,1;zoom,2;linear,0.4;zoom,4;diffusealpha,0);
	--		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	--	};
	--end;
	
	if GAMESTATE:GetNumSidesJoined() == 2 then
		if pnPlayer == PLAYER_1 then
			xSide = -1;
		else
			xSide = 1;
		end;
	end;
	for i=1,13,1 do
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[statsAux[i]]),0.1*i,SCREEN_CENTER_X+xStatPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign, false)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;


	if not tStatsGlobal["Success"]  then
	
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,140;zoom,0.5;animate,false;setstate,1;diffusealpha,0;sleep,DelayMissionResult + 0.15;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;blend,Blend.Add;addx,-250;addy,140;animate,false;setstate,1;diffusealpha,0;sleep,DelayMissionResult;linear,0.15;diffusealpha,1;addx,250;linear,0.15;zoom,0.5;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;blend,Blend.Add;addx,250;addy,140;animate,false;setstate,1;diffusealpha,0;sleep,DelayMissionResult;linear,0.15;diffusealpha,1;addx,-250;linear,0.15;zoom,0.5;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	
	else
	
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,140;zoom,0.5;animate,false;setstate,0;diffusealpha,0;sleep,DelayMissionResult + 0.15;linear,.5;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,140;animate,false;zoom,0.7;setstate,0;diffusealpha,0;sleep,DelayMissionResult + 0.15;linear,.13;diffusealpha,.5;linear,.25;zoomy,0.8;zoomx,0.5;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
	end;


	bTier = TierToState(tStats["Grade"]);
	
	--Trace("TOTAL ITEMS: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Item"));
	--Trace("TOTAL Heart: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Heart"));
	--Trace("TOTAL POTIONS: " .. 	pnStageStats:GetTapNoteScores("TapNoteScore_Potion"));
	--Trace("TOTAL mine: " .. pnStageStats:GetTapNoteScores("TapNoteScore_HitMine"));
	--Trace("TOTAL VELO: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Velocity"));
	--Trace("TOTAL HIDDEN ITEMS: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Hidden"));
	
	if GAMESTATE:GetNumSidesJoined() == 2 then
		if pnPlayer == PLAYER_1 then
			t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[statsAux[14]]),0.1*14,SCREEN_CENTER_X+420*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
			t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+xStatPos*xSide + 30,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		else
			t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[statsAux[14]]),0.1*14,SCREEN_CENTER_X+390*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
			t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+xStatPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
	else
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[statsAux[14]]),0.1*14,SCREEN_CENTER_X+390*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+xStatPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;
	
	
	t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[statsAux[15]]),0.1*15,SCREEN_CENTER_X+xStatPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*15,xAlign, true)..{
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};
	pnStageStats:FailPlayer();
	return t
end;

--we avoid to print unused skins, all zero stats
local function allZeroSkin(pnStageStats, skin)
	local iTotal = 0;
	iTotal = pnStageStats:GetTapNoteSkin(skin, "TapNoteScore_W1") +
	pnStageStats:GetTapNoteSkin(skin,"TapNoteScore_W2") +
	pnStageStats:GetTapNoteSkin(skin,"TapNoteScore_CheckpointHit") +
	pnStageStats:GetTapNoteSkin(skin,'TapNoteScore_W3') +
	pnStageStats:GetTapNoteSkin(skin,'TapNoteScore_W4') +
	pnStageStats:GetTapNoteSkin(skin,'TapNoteScore_W5') +
	pnStageStats:GetTapNoteSkin(skin,"TapNoteScore_Miss") +
	pnStageStats:GetTapNoteSkin(skin,"TapNoteScore_CheckpointMiss") +
	pnStageStats:MaxComboSkin(skin) +
	pnStageStats:MaxMissComboSkin(skin);
	
	Trace("TOTAL FOR:"..skin.." :"..iTotal);
	if iTotal == 0 then
		return true;
	else
		return false;
	end;
end;

-- 3q3q3q
local function CreateSeparateStats( pnPlayer )
	Trace("GENERATING SEPARATE STATS FOR:"..pnPlayer);
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );
	tStatsGlobal = {		
		Chapter		= GAMESTATE:GetCurrentSong():GetTranslitArtist();
		Desc		= GAMESTATE:GetCurrentSteps(pnPlayer):GetQuestDesc();
		Success		= pnStageStats:GetSuccess();
	};
	
	
	local preload = GAMESTATE:GetCurrentSteps(pnPlayer):GetPreloadNoteSkin();
	Trace("ALL SKINS FOR PLAYER:"..pnPlayer.. " :"..preload);
	preload = split(',',preload );
	
	local skin = { "xx" };
	for p=1,#preload,1 do
		-- if #skin then
			if not allZeroSkin(pnStageStats, preload[p]) then
				table.insert(skin, preload[p]);				
			end;
		-- end;
	end;
	--default siempre va a quedar primero, entonces si tienes 2 preload noteskin quedaría de la siguiente forma
	--default, old, slime
	--[1][2][3]	
	--en caso de no tener 3 skin el tercero es "dummy"
	if #skin <= 2 then
		for s=1,(3 - #skin),1 do
			table.insert(skin, "dummy");
		end;
	end;
	Trace("SKINS NUM:"..#skin);
	local tStats={};
	for i=1,#skin,1 do
		tStats[i] = 
		{
			Perfect 	= pnStageStats:GetTapNoteSkin(skin[i], "TapNoteScore_W1") +
						  pnStageStats:GetTapNoteSkin(skin[i],"TapNoteScore_W2") +
						  pnStageStats:GetTapNoteSkin(skin[i],"TapNoteScore_CheckpointHit");		
			Great		= pnStageStats:GetTapNoteSkin(skin[i],'TapNoteScore_W3');
			Good		= pnStageStats:GetTapNoteSkin(skin[i],'TapNoteScore_W4');
			Bad			= pnStageStats:GetTapNoteSkin(skin[i],'TapNoteScore_W5');
			Miss		= pnStageStats:GetTapNoteSkin(skin[i],"TapNoteScore_Miss") +
						  pnStageStats:GetTapNoteSkin(skin[i],"TapNoteScore_CheckpointMiss");
			MaxCombo 	= pnStageStats:MaxComboSkin(skin[i]);
			MissCombo 	= pnStageStats:MaxMissComboSkin(skin[i]);--3q3q3q
			Heart		= pnStageStats:GetTapNoteScores("TapNoteScore_Heart");
			Potion		= pnStageStats:GetTapNoteScores("TapNoteScore_Potion");
			Mine		= pnStageStats:GetTapNoteScores("TapNoteScore_HitMine");
			Velocity	= pnStageStats:GetTapNoteScores("TapNoteScore_Velocity");
			BrainO		= pnStageStats:GetTapNoteScores("TapNoteScore_BrainO");
			BrainX		= pnStageStats:GetTapNoteScores("TapNoteScore_BrainX");
			Life		= pnStageStats:GetCurrentLife();
			Score		= pnStageStats:GetScore();
			Grade		= pnStageStats:GetGrade();		
			
			Failed		= pnStageStats:GetFailedAux();
		};
	end;
	

	if pnPlayer == PLAYER_1 then
		bothfailed[1] =tStats[1]["Failed"];
	end;
	if pnPlayer == PLAYER_2 then
		bothfailed[2] =tStats[1]["Failed"];
	end;
	
	-- Trace(tStats[1]["Perfect"]);
	
	local tValues = {
		CURRENT			= ( tStats[1]["Perfect"]*10 + tStats[1]["Great"]*5 + tStats[1]["Good"]*1 + tStats[1]["Bad"]*-2 + tStats[1]["Miss"]*-5), 
		MAX		= ( tStats[1]["Perfect"] + tStats[1]["Great"] + tStats[1]["Good"] + tStats[1]["Bad"] + tStats[1]["Miss"] )*10,
	};
	tValues["CURRENT"] = (100*tValues["CURRENT"])/tValues["MAX"];
	if tValues["CURRENT"] < 0 then
		tValues["CURRENT"] = 0;
	end;
	tValues["MAX"] = 100;
	
	local statsAux={};
	statsAux[1] ="Perfect";
	statsAux[2] ="Great";
	statsAux[3] ="Good";
	statsAux[4] ="Bad";
	statsAux[5] ="Miss";
	statsAux[6] ="MaxCombo";
	statsAux[7] ="MissCombo";
	statsAux[8] ="Heart";
	statsAux[9] ="Potion";
	statsAux[10] ="Mine";
	statsAux[11] ="Velocity";
	statsAux[12] ="BrainO";
	statsAux[13] ="BrainX";
	statsAux[14] ="Life";
	statsAux[15] ="Score";
	tStats[1]["Life"] = round(tStats[1]["Life"],2) * 100;
	local xSide;
	local xAlign;
	local xAuxX;
	xSide = 1;
	
	
	if pnPlayer == PLAYER_1 then
		xSide = -1;
	end;
	if pnPlayer == PLAYER_2 then
		xSide = 1;
	end;
	
	xAlign = 'HorizAlign_Right';
	xAuxX=0;
	local t = Def.ActorFrame {};
	
	-- No es perfecto pero bue.
	-- local xAuxStat;
	-- xAuxStat =  60;
	-- if (#preload > 2) then
		-- xAuxStat = -(#preload * (10 * (#preload + 1)));
	-- end;
	--if TierToState(tStats[1]["Grade"]) ~= 0 then
	--	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
	--		OnCommand=cmd(Center;addy,-50;animate,false;setstate,1;zoom,1;diffusealpha,0;sleep,5;linear,0.2;diffusealpha,1;zoom,2;linear,0.4;zoom,4;diffusealpha,0);
	--		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	--	};
	--end;
	
	-- for s=1,#skin,1 do
		-- for i=1,13,1 do
			-- t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[s][statsAux[i]]),0.1*i,SCREEN_CENTER_X+xAuxStat*xSide + (s * 120),SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign, false)..{
				-- FinalizedMessageCommand=cmd(finishtweening;visible,false);
			-- };
		-- end;
	-- end;
	if GAMESTATE:GetCurrentMission():GetPlayers() == 1 then
		for s=1,#skin,1 do
			for i=1,13,1 do
				t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[s][statsAux[i]]),0.1*i,SCREEN_CENTER_X + 420 + (s * 120) - (#skin * 120),SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign, false)..{
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};
			end;
		end;
	else
		for s=1,#skin,1 do
			for i=1,13,1 do
				t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[s][statsAux[i]]),0.1*i,SCREEN_CENTER_X + (420 + (s * 120) - (#skin * 120)) * xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*i,xAlign, false)..{
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
				};
			end;
		end;
	end;
	
	if not tStatsGlobal["Success"]  then
	
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,100;animate,false;setstate,tStatsGlobal["Success"] and 0 or 1;diffusealpha,0;sleep,DelayMissionResult + 0.15;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;blend,Blend.Add;addx,-250;addy,100;animate,false;setstate,tStatsGlobal["Success"] and 0 or 1;diffusealpha,0;sleep,6.5;linear,0.15;diffusealpha,1;addx,250;linear,0.25;zoom,1.1;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;blend,Blend.Add;addx,250;addy,100;animate,false;setstate,tStatsGlobal["Success"] and 0 or 1;diffusealpha,0;sleep,DelayMissionResult;linear,0.15;diffusealpha,1;addx,-250;linear,0.25;zoom,1.1;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	
	else
	
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,100;animate,false;setstate,0;diffusealpha,0;sleep,DelayMissionResult + 0.15;linear,.5;diffusealpha,1);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/result_mission"))..{
			OnCommand=cmd(Center;addy,100;animate,false;setstate,0;diffusealpha,0;sleep,DelayMissionResult + 0.15;linear,.3;diffusealpha,.5;linear,.5;zoomy,1.05;zoomx,1.1;diffusealpha,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
	end;

	bTier = TierToState(tStats[1]["Grade"]);
	
	-- Trace("TOTAL ITEMS: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Item"));
	-- Trace("TOTAL Heart: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Heart"));
	-- Trace("TOTAL POTIONS: " .. 	pnStageStats:GetTapNoteScores("TapNoteScore_Potion"));
	-- Trace("TOTAL mine: " .. pnStageStats:GetTapNoteScores("TapNoteScore_HitMine"));
	-- Trace("TOTAL VELO: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Velocity"));
	-- Trace("TOTAL HIDDEN ITEMS: " .. pnStageStats:GetTapNoteScores("TapNoteScore_Hidden"));

	-- t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[1][statsAux[14]]),0.1*14,SCREEN_CENTER_X+390*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
		-- FinalizedMessageCommand=cmd(finishtweening;visible,false);
	-- };
	
	if GAMESTATE:GetNumSidesJoined() == 2 then
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[1][statsAux[14]]),0.1*14,SCREEN_CENTER_X+390*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[1][statsAux[15]]),0.1*15,SCREEN_CENTER_X+xStatPos*xSide,SCREEN_CENTER_Y-yStatPos+SnapDistance*15,xAlign, true)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		if pnPlayer == PLAYER_1 then
			t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+(xStatPos*xSide) - 20,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
		if pnPlayer == PLAYER_2 then
			t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+(xStatPos*xSide),SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
	else
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[1][statsAux[14]]),0.1*14,SCREEN_CENTER_X+390*1,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign, false)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = EvalRollingNumbers('%',0.1*14,SCREEN_CENTER_X+xStatPos*1,SCREEN_CENTER_Y-yStatPos+SnapDistance*14,xAlign)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		t[#t+1] = EvalRollingNumbers(string.format("%03i", tStats[1][statsAux[15]]),0.1*15,SCREEN_CENTER_X+xStatPos*1,SCREEN_CENTER_Y-yStatPos+SnapDistance*15,xAlign, true)..{
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;
	
	
	
	if tStats["Failed"] then
		if GAMESTATE:GetNumSidesJoined() == 2 then
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-BROKENTIER"))..{
				OnCommand=cmd(xy,SCREEN_CENTER_X + 300 * xSide,SCREEN_CENTER_Y - 20;animate,false;setstate,TierToState(tStats["Grade"]);zoom,1.5;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);			
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};		
		else
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-BROKENTIER"))..{
				OnCommand=cmd(Center;addy,-20;animate,false;setstate,TierToState(tStats["Grade"]);zoom,1.5;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);			
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
	else
		if GAMESTATE:GetNumSidesJoined() == 2 then
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-GRADETIER"))..{
				OnCommand=cmd(xy,SCREEN_CENTER_X + 300 * xSide,SCREEN_CENTER_Y - 20;animate,false;setstate,TierToState(tStats[1]["Grade"]);zoom,1.5;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1);			
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-GRADETIER"))..{
				OnCommand=cmd(xy,SCREEN_CENTER_X + 300 * xSide,SCREEN_CENTER_Y - 20;animate,false;setstate,TierToState(tStats[1]["Grade"]);zoom,0.3325;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;linear,0.4;zoom,1.5;diffusealpha,0;blend,Blend.Add);
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		else
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-GRADETIER"))..{
				OnCommand=cmd(Center;addy,-20;animate,false;setstate,TierToState(tStats[1]["Grade"]);zoom,1.5;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1);			
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
			t[#t+1] = LoadActor(THEME:GetPathG("","SE-GRADETIER"))..{
				OnCommand=cmd(Center;addy,-20;animate,false;setstate,TierToState(tStats[1]["Grade"]);zoom,0.3325;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;linear,0.4;zoom,1.5;diffusealpha,0;blend,Blend.Add);
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};
		end;
	end;
	

	if TierToState(tStats[1]["Grade"]) == 0 then
		t[#t+1] = LoadActor(THEME:GetPathG("","SE-FXFLARE"))..{
			OnCommand=cmd(Center;addy,-20;animate,false;zoom,0.3325;diffusealpha,0;sleep,DelayGradeShow;linear,0.2;diffusealpha,1;zoom,1;linear,0.25;zoom,1.5;diffusealpha,0;blend,Blend.Add);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;
	
	
	pnStageStats:FailPlayer();
	return t
end;



local sGradeAnnouncer = "RANK_" .. iGrade;
if bFailedAux then
	sGradeAnnouncer = "BROKEN_" .. iGrade;
end;


local t = Def.ActorFrame {

	
	LoadActor( THEME:GetPathG("","Evaluation_Top label") ) .. {
		OnCommand=cmd(Center;addy,-242;animate,false;setstate,0;zoomy,0;sleep,0.125;linear,0.125;zoomy,.7);
		FinalizedMessageCommand=cmd(finishtweening;linear,0.3;zoomy,0)
	};
	
	LoadActor( THEME:GetPathG("","Evaluation_Top label") ) .. {
		OnCommand=cmd(Center;addy,-210;zoomy,0;setstate,1;sleep,0.125;linear,0.125;zoomy,.7;animate,false);
		FinalizedMessageCommand=cmd(finishtweening;linear,0.3;zoomy,0)
	};
	
	LoadFont("_mainfont")..{
		OnCommand=cmd(Center;addy,-240 ;settext,GetMachineName();zoomy,0;sleep,0.5;linear,0.125;zoom,.9);
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};
	
	
	
	

	LoadFont("_mainfont")..{
		InitCommand=function(self)
		
			local text = tStatsGlobal["Desc"];
			text = split('@',text );
			if #text > 2 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				elseif (gLANG() == "PT-") then
					text = text[3];
				else
					text = text[2];
				end
			elseif #text > 1 then	-- Si encontro un @, significa que hay ingles/español
				if (gLANG() == "EN-") then
					text = text[1];
				else
					text = text[2];
				end
			else
				text = text[1];
			end;
			
			text = string.gsub(text, "|", ":")
			text = string.gsub(text, "_", ":")
			
			self:settext(text);
		end;
		OnCommand=cmd(Center;addy,-212;zoomy,0;sleep,0.5;linear,0.125;zoom,.9);
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};
	
	--OBTENER EL USB
	GetUsb();
	
	Drum(WaitUntilDrum - 0.2, DelayDrum);
	Def.Sound {	--BGM
		OnCommand=cmd(queuecommand,"Lot");
		LotCommand=function(self)
			SOUND:PlayMusicPart(THEME:GetPathS("","XXMISSION_BGM"),0,17.47,0,0,true,false,false);
		end;
	};
	--Def.Sound {
	--	OnCommand=cmd(sleep,DelayGradeShow - 0.35;queuecommand,"Lot");
	--	LotCommand=function(self)
	--		SOUND:PlayOnce(THEME:GetPathS("","NUC"));
	--	end;
	--};
	--
	--LoadActor(THEME:GetPathS("","RANK/RANK_" .. iGrade)) .. {
	--	OnCommand=cmd(sleep,DelayGradeShow - 3.3;queuecommand,"Lot");
	--	LotCommand=cmd(play);
	--	OffCommand=cmd(stop);
	--};
	--
	--LoadActor(THEME:GetPathS("","RANK/FXRANK_" .. iGrade)) .. {
	--	OnCommand=cmd(sleep,DelayGradeShow ;queuecommand,"Lot");
	--	LotCommand=cmd(play);
	--	OffCommand=cmd(stop);
	--};

	Def.Sound {	--GRADE
		OnCommand=cmd(sleep,DelayGradeShow - 0.2;queuecommand,"Lot");
		LotCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("","NEW_RANK/NUC"));
		end;
	};
	
	-- JNC New Sounds -- AWFUL CODE
	LoadActor(THEME:GetPathS("","NEW_RANK/" .. sGradeAnnouncer )) .. {
		OnCommand=cmd(sleep,DelayGradeShow;queuecommand,"Lot");
		LotCommand=cmd(play);
		OffCommand=cmd(stop);
	};
	
	LoadActor(THEME:GetPathS("","NEW_RANK/FXRANK_" .. iGrade)) .. {
		OnCommand=cmd(sleep,DelayGradeShow;queuecommand,"Lot");
		LotCommand=cmd(play);
		OffCommand=cmd(stop);
	};

	
	LoadActor(THEME:GetPathS("","NEW_RANK/MISSION_" .. sResult .. "A")) .. {
		OnCommand=cmd(sleep,DelayMissionResult - 0.15;queuecommand,"Lot");
		LotCommand=cmd(play);
		OffCommand=cmd(stop);
	};
	
	LoadActor(THEME:GetPathS("","NEW_RANK/MISSION_" .. sResult.. "B")) .. {
		OnCommand=cmd(sleep,DelayMissionResult - 0.15;queuecommand,"Lot");
		LotCommand=cmd(play);
		OffCommand=cmd(stop);
	};
	
	LoadActor(THEME:GetPathS("","NEW_RANK/MISSION_" .. sResult.. "C")) .. {
		OnCommand=cmd(sleep,DelayMissionResult - 0.15;queuecommand,"Lot");
		LotCommand=cmd(play);
		OffCommand=cmd(stop);
	};

};

if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	for i=1,15 do
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/2PlayerLabelEvaluationQuest"))..{
			OnCommand=cmd(Center;y,SCREEN_CENTER_Y-205+33*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.3;zoomy,0)
		};
	end;
else
	for i=1,15 do
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/mission/LabelEvaluationQuest"))..{
			OnCommand=cmd(Center;y,SCREEN_CENTER_Y-205+33*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,1);
			FinalizedMessageCommand=cmd(finishtweening;linear,0.3;zoomy,0)
		};
	end;
end;
if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	-- 3q3q3q
	-- if GAMESTATE:GetNumSidesJoined() == 2 then
		-- t[#t+1] = Def.ActorFrame {
			-- CreateStats( PLAYER_1 );
		-- };
	-- else
		if GAMESTATE:GetCurrentSteps(PLAYER_1):ShowSkinScore() == "YES" then		
			t[#t+1] = Def.ActorFrame {
				CreateSeparateStats( PLAYER_1 );
			};
		else 
			t[#t+1] = Def.ActorFrame {
				CreateStats( PLAYER_1 );
			};
		end;
	-- end;
end;
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	-- 3q3q3q
	-- if GAMESTATE:GetNumSidesJoined() == 2 then
		-- t[#t+1] = Def.ActorFrame {
			-- CreateStats( PLAYER_2);
		-- };
	-- else
		if GAMESTATE:GetCurrentSteps(PLAYER_2):ShowSkinScore() == "YES" then		
			t[#t+1] = Def.ActorFrame {
				CreateSeparateStats( PLAYER_2 );
			};
		else 
			t[#t+1] = Def.ActorFrame {
				CreateStats( PLAYER_2 );
			};
		end;
	-- end;	
end;

return t
