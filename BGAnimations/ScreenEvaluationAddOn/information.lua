-- :: SECTIONS ::
-- FUNCTIONS_FRAME
-- CARDS_FRAME
-- BASE PLACEHOLDER
-- LOAD FRAME

--############################--
--###   FUNCTIONS_FRAME    ###--
--############################--
local infoDivActor = {};
local iconBaseOption = {};
local placesBarOptionInfo = {-110,-20,70,140}; -- 4 opciones maximo

local optList = {"highscore","ranking","graph"}; -- 2 activas
local cardActorHSList = {};
local cardActorRankingList = {};
local cardActorGraphList = {};


local player1BaseOptionInfo=1;
local player2BaseOptionInfo=1;

local globalXBaseInformation = 335; -- PLACE DEL BOX EN LA PANTALLA
local fixXForP1 = 50; -- mmmmm

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	if event.type ~= "InputEventType_FirstPress" then return false end
	local button= event.GameButton

	Trace("##### PLAYER:"..pn.." - BUTTON:"..button);
	local playerBaseOptionSelected = 1;

	if button == "MenuUp" or button == "MenuDown" then
		return;
	end;

	if pn == PLAYER_1 then

		if button == "MenuLeft" then
				Trace("MenuLeft<-p1");
				player1BaseOptionInfo = player1BaseOptionInfo - 1;
				if player1BaseOptionInfo < 1 then
					player1BaseOptionInfo = #optList;
				end;
				playerBaseOptionSelected = player1BaseOptionInfo;

				--back icono titulo
				local actorBackIconoTitulo = iconBaseOption[pn];
				if actorBackIconoTitulo then
					actorBackIconoTitulo:x(SCREEN_CENTER_X - (globalXBaseInformation+fixXForP1) + placesBarOptionInfo[player1BaseOptionInfo]);
				end;
		end;

		if button == "MenuRight" then
				Trace("MenuRight<-p1");
				player1BaseOptionInfo = player1BaseOptionInfo + 1;
				if player1BaseOptionInfo > #optList then
					player1BaseOptionInfo = 1;
				end;
				playerBaseOptionSelected = player1BaseOptionInfo;

				--back icono titulo
				local actorBackIconoTitulo = iconBaseOption[pn];
				if actorBackIconoTitulo then
					actorBackIconoTitulo:x(SCREEN_CENTER_X - (globalXBaseInformation+fixXForP1) + placesBarOptionInfo[player1BaseOptionInfo]);
				end;
		end;

		if button == "Start" then
			return;
		end;
	end;

	if pn == PLAYER_2 then

		if button == "MenuLeft" then
			player2BaseOptionInfo = player2BaseOptionInfo - 1;
			if player2BaseOptionInfo < 1 then
				player2BaseOptionInfo = #optList;
			end;
			playerBaseOptionSelected = player2BaseOptionInfo;

			--back icono titulo
			local actorBackIconoTitulo = iconBaseOption[pn];
			if actorBackIconoTitulo then
				actorBackIconoTitulo:x(SCREEN_CENTER_X + (globalXBaseInformation) + placesBarOptionInfo[player2BaseOptionInfo]);
			end;
		end;

		if button == "MenuRight" then
			player2BaseOptionInfo = player2BaseOptionInfo + 1;
			if player2BaseOptionInfo > #optList then
				player2BaseOptionInfo = 1;
			end;
			playerBaseOptionSelected = player2BaseOptionInfo;

			--back icono titulo
			local actorBackIconoTitulo = iconBaseOption[pn];
			if actorBackIconoTitulo then
				actorBackIconoTitulo:x(SCREEN_CENTER_X + (globalXBaseInformation) + placesBarOptionInfo[player2BaseOptionInfo]);
			end;
		end;

		if button == "Start" then
			return;
		end;
	end;

	if GAMESTATE:IsSideJoined(pn) then
		--comprobaciones para tarjetas
		if optList[playerBaseOptionSelected] == "highscore" then
			cardActorHSList[pn]:visible(true);
			cardActorRankingList[pn]:visible(false);			
			cardActorGraphList[pn]:visible(false);

		end;

		if optList[playerBaseOptionSelected] == "ranking" then
			cardActorHSList[pn]:visible(false);	
			cardActorRankingList[pn]:visible(true);
			cardActorGraphList[pn]:visible(false);
		end;	

		if optList[playerBaseOptionSelected] == "graph" then
			cardActorHSList[pn]:visible(false);	
			cardActorRankingList[pn]:visible(false);
			cardActorGraphList[pn]:visible(true);
		end;
	end;
end

local function GetHighScoreFromPlayer(PLAYERNUM)

	local song = GAMESTATE:GetCurrentSong();
	local steps = GAMESTATE:GetCurrentSteps(PLAYERNUM);			
	local scorelist;
	
	if song and steps then
		scorelist = PROFILEMAN:GetProfile(PLAYERNUM):GetHighScoreList(song,steps);
		assert(scorelist)
		local scores = scorelist:GetHighScores();
		if (scores[1] == nil ) then return 0 end;
		local high = scores[1]:GetPhoenixScore();
		return high;
	end;
	
	return 0;
end;

function gradeTransform(scorePlayer)

	local stateLetterSprite = 0;
    if scorePlayer >= 995000 then		                
       	stateLetterSprite = 0;
    elseif scorePlayer >= 990000 and scorePlayer <= 994999 then
        stateLetterSprite = 1;
    elseif scorePlayer >= 985000 and scorePlayer <= 989999 then
        stateLetterSprite = 2;		                
    elseif scorePlayer >= 980000 and scorePlayer <= 984999 then
        stateLetterSprite = 3;
    elseif scorePlayer >= 975000 and scorePlayer <= 979999 then
       stateLetterSprite = 4;
    elseif scorePlayer >= 970000 and scorePlayer <= 974999 then
        stateLetterSprite = 5;
    elseif scorePlayer >= 960000 and scorePlayer <= 969999 then
        stateLetterSprite = 6;
    elseif scorePlayer >= 950000 and scorePlayer <= 959999 then
        stateLetterSprite = 7;
    elseif scorePlayer >= 925000 and scorePlayer <= 949999 then
        stateLetterSprite = 8;
    elseif scorePlayer >= 900000 and scorePlayer <= 924999 then
        stateLetterSprite = 9;
    elseif scorePlayer >= 825000 and scorePlayer <= 899999 then
        stateLetterSprite = 10;
    elseif scorePlayer >= 750000 and scorePlayer <= 824999 then
        stateLetterSprite = 11;
    elseif scorePlayer >= 650000 and scorePlayer <= 749000 then
        stateLetterSprite = 12;
    elseif scorePlayer >= 550000 and scorePlayer <= 649999 then
        stateLetterSprite = 13;
    elseif scorePlayer >= 450000 and scorePlayer <= 549999 then
        stateLetterSprite = 14;
    elseif scorePlayer <= 449999 then
        stateLetterSprite = 15;
    end;

    return stateLetterSprite;
end;

--############################--
--###      CARDS_FRAME     ###--
--############################--

--## HIGHSCORE
function getHighCoreCard(PLAYER)

	--local hsPlayer = GetHighScoreFromPlayer(PLAYER);
	local guidPlayer = PROFILEMAN:GetProfile(PLAYER):GetGUID();
	local hsPlayer = GetHighScoreAndStateFromPlayer(PLAYER);
	local hsLength = string.len(tostring(hsPlayer["score"]));
	local backScore="";
	local isFailed = hsPlayer["failed"];	
	local spriteGrade="pass_res";

	local spriteGradeMb="pass_res";

	if isFailed == 1 then
		spriteGrade = "fail_pass_res";
	end;
	if (7-hsLength) > 0 then
		for i=1,(7-hsLength) do
			backScore = backScore.."0";
		end;
	end;	

	local hsSong = getAllRankingFromSong(PLAYER);

	if #hsSong >= 1 then
		if hsSong[1]["failed"] == 1 then
			spriteGradeMb="fail_pass_res";
		end;

	end;

	return Def.ActorFrame{

		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_hs"))..{
			OnCommand=function(self)
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_hs"))..{
			OnCommand=function(self)
				self:blend("BlendMode_Add");
				self:fadeleft(0.9);
			end;
		};		

		--MY BEST
		LoadFont("scorebg")..{	
				Name="scoreBackMyBest";
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.7);
					self:horizalign("left");
					if hsPlayer["score"] == 0 then
						backScore="0000000";
					end;
					self:settext(backScore);
					self:y(-58);
					self:x(-104);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadFont("scorebg")..{	
				Name="scoreFrontMyBest";
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					if hsPlayer["score"] == 0 then
						self:visible(false);
						return;
					end;
					self:zoom(0.7);
					self:horizalign("right");
					self:settext(hsPlayer["score"]);
					self:y(-58);
					self:x(82);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/"..spriteGrade))..{
			Name="LetterMyBest";
			OnCommand=cmd(animate,false;setstate,6;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				if hsPlayer["score"] == 0 then
					self:visible(false);
					return;
				end;
				self:zoom(0.28);
				self:x(152);
				self:y(-50);

				self:setstate(gradeTransform(hsPlayer["score"]));
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};		


		LoadActor(THEME:GetPathG("","ScreenEvaluation/arr_hs"))..{
			InitCommand=cmd(diffusealpha,0;animate,false;setstate,0);
			OnCommand=function(self)
				if SCREENMAN:GetTopScreen():IsNewRecordPersonal(PLAYER) then
					self:setstate(0);
					self:diffusealpha(1);
					self:y(-50);
					self:x(-230);
					self:zoom(0.7);
				end;
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		LoadActor(THEME:GetPathG("","ScreenEvaluation/arr_hs"))..{
			InitCommand=cmd(diffusealpha,0;animate,false;setstate,0;blend,"BlendMode_Add");
			OnCommand=function(self)
				if SCREENMAN:GetTopScreen():IsNewRecordPersonal(PLAYER) then
					self:setstate(0);
					self:diffusealpha(1);
					self:zoom(0.7);
					self:y(-50);
					self:x(-230);
					self:queuecommand("Ani");
				end;
			end;
			AniCommand=function(self)
				self:linear(0.2);
				self:fadebottom(1);
				self:linear(0.05);
				self:fadebottom(0);
				self:linear(0.1);
				self:fadetop(1);
				self:queuecommand("Ani");
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};




		--MACHINE BEST
		LoadFont("_TitleXolonium")..{	
				Name="nameMachineBest";
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.8);
					self:horizalign("left");
					self:settext("---");
					self:y(18);
					self:x(-105);

					if #hsSong >= 1 then
						self:settext(hsSong[1]["name"]);
					end;

				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("scorebg")..{	
				Name="scoreBackMachineBest";
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.7);
					self:horizalign("left");
					self:settext("0000000");
					self:y(44);
					self:x(-104);

					if #hsSong >= 1 then
						local hsLengthMb = string.len(tostring(hsSong[1]["score"]));
						local backScoreMb ="";

						if (7-hsLengthMb) > 0 then
							for i=1,(7-hsLengthMb) do
								backScoreMb = backScoreMb.."0";
							end;
						end;
						self:settext(backScoreMb);
					end;					
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadFont("scorebg")..{	
				Name="scoreFrontMachineBest";
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.7);
					self:horizalign("right");
					self:settext("");
					self:y(44);
					self:x(82);
					if #hsSong >= 1 then
						self:settext(hsSong[1]["score"]);
					end;	

				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	
		LoadActor(THEME:GetPathG("","ScreenEvaluation/"..spriteGradeMb))..{
			Name="LetterMachineBest";
			OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.28);
				self:x(152);
				self:y(36);

				if #hsSong >= 1 then
					self:setstate(gradeTransform(hsSong[1]["score"]));
				else
					self:visible(false);
				end;	
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};




		InitCommand=function(self)
		end;


	};

end;

--## RANKING
function getRankingCard(PLAYER)

	local hsSong = getAllRankingFromSong(PLAYER);
	local guidPlayer = PROFILEMAN:GetProfile(PLAYER):GetGUID();

	local preHsTemp = {};
	local hsFinalProc = {}; -- lista final
	local encontrado = false;
	local maxRecords = 3;
	local recordPersonal = 0;

	for i=1,#hsSong do

		if encontrado == false then 
			if hsSong[i]["guid"] == guidPlayer then		

				if  next(preHsTemp) ~= nil then
					preHsTemp["diff"] = hsSong[i]["score"] - preHsTemp["score"];
					table.insert(hsFinalProc,preHsTemp);
				end;
				recordPersonal = hsSong[i]["score"];
				table.insert(hsFinalProc,{guid=guidPlayer,pos=i,name=hsSong[i]["name"],failed=hsSong[i]["failed"],score=hsSong[i]["score"],diff=0,player=true});				
				encontrado = true;

			else
				preHsTemp = {guid=hsSong[i]["guid"],pos=i,name=hsSong[i]["name"],failed=hsSong[i]["failed"],score=hsSong[i]["score"],diff=0,player=false};
			end;
		else	
			if #hsFinalProc < 3 then	
				local diffRank = recordPersonal - hsSong[i]["score"];
				table.insert(hsFinalProc,{guid=hsSong[i]["guid"],pos=i,name=hsSong[i]["name"],failed=hsSong[i]["failed"],score=hsSong[i]["score"],diff=diffRank,player=false});	
			end;
		end;

	end;

	--si no hay records, intentamos mostrar los 3 primeros :)
	if #hsFinalProc == 0 and #hsSong > 0 then

		local maxIndexHs = 3;
		if #hsSong <3 then
			maxIndexHs = #hsSong;
		end;

		for i=1,maxIndexHs do
				table.insert(hsFinalProc,{guid=hsSong[i]["guid"],pos=i,name=hsSong[i]["name"],failed=hsSong[i]["failed"],score=hsSong[i]["score"],diff=0,player=false});	
		end;
	end;

	--aca tenemos que armar el coso.
	local t = Def.ActorFrame {};

	for i=1,#hsFinalProc do

		local isFailed = hsFinalProc[i]["failed"];
		local spriteGrade="pass_res";
		if isFailed == 1 then
			spriteGrade = "fail_pass_res";
		end;


		t[#t+1]	= LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_rank_placeholder"))..{				
			OnCommand=function(self)
				self:zoomy(0.94);

				self:y(-125 + (i*62));
			end;
		};

		if hsFinalProc[i]["guid"] == guidPlayer then
			t[#t+1]	= LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_rank_placeholder"))..{				
				OnCommand=function(self)
					self:zoomy(0.94);
					self:y(-125 + (i*62));
					self:blend("BlendMode_Add");
					self:diffusealpha(0.3);
					self:queuecommand("Ani");
				end;
			};
		end;


		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_rank_itemcolor"))..{
			OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.8);
				self:y(-130 + (i*62));
				self:x(-190);
				self:setstate(0);
				self:diffusealpha(0.2);
			end;


			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	


		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/card_rank_itemcolor"))..{
			OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.8);
				self:y(-130 + (i*62));
				self:x(-190);
				self:setstate(0);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.5);



				if hsFinalProc[i]["failed"] == 1 then
					self:setstate(5);
					self:diffusealpha(0.8);
					self:queuecommand("failedAni");

				else



					if hsFinalProc[i]["score"] == 1000000 then
						self:setstate(2);
					else
						self:setstate(3);
					end;

					if hsFinalProc[i]["player"] then
						self:diffusealpha(1);
						self:queuecommand("Ani");
					end;

				end;
			end;

			AniCommand=function(self)
				self:linear(0.5);
				self:diffusealpha(0.8);
				self:decelerate(0.5);
				self:diffusealpha(0.5);
				self:queuecommand("Ani");
			end;

			failedAniCommand=function(self)
				self:linear(0.03);
				self:diffusealpha(0);
				self:linear(0.03);
				self:diffusealpha(0.4);
				self:queuecommand("failedAni");
			end;

			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	


		--Place
		t[#t+1]	=  LoadFont("scorebg")..{	
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.5);
					self:horizalign("center");
					self:settext(hsFinalProc[i]["pos"]);
					self:y(-134 + (i*62));
					self:x(-190);
					if hsFinalProc[i]["pos"] == 1 then
						self:zoom(0.6);
					end;	
					if hsFinalProc[i]["pos"] == 2 then
						self:zoom(0.55);
					end;	
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		--Name
		t[#t+1]	=  LoadFont("_TitleXolonium")..{	
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.55);
					self:horizalign("left");
					self:settext(hsFinalProc[i]["name"]);
					self:y(-142 + (i*62));
					self:x(-142);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		--SCORE
		t[#t+1]	=  LoadFont("scorebg")..{	
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.65);
					self:horizalign("left");					
					self:y(-124 + (i*62));
					self:x(-94);

					self:settext("");					
					local hsLength = string.len(tostring(hsFinalProc[i]["score"]));
					local backScore ="";
					if (7-hsLength) > 0 then
						for i=1,(7-hsLength) do
							backScore = backScore.."0";
						end;
					end;
					self:settext(backScore);
				end;

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		t[#t+1]	=  LoadFont("scorebg")..{	
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.65);
					self:horizalign("right");
					self:settext(hsFinalProc[i]["score"]);
					self:y(-124 + (i*62));
					self:x(80);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	


		t[#t+1]	=  LoadFont("xolonium 20px")..{	
				OnCommand=cmd(queuecommand,"SetPos");
				SetPosCommand=function(self)
					self:zoom(0.65);
					self:horizalign("right");			
					if hsFinalProc[i]["diff"] > 0 then
						self:diffusecolor(color("#00ff00"));
						self:settext("+"..hsFinalProc[i]["diff"]);
					end;
					if hsFinalProc[i]["diff"] == 0 then
						self:settext("+"..hsFinalProc[i]["diff"]);
					end;
					if hsFinalProc[i]["diff"] < 0 then
						self:diffusecolor(color("#ff0000"));
						self:settext(hsFinalProc[i]["diff"]);
					end;					
					self:y(-142 + (i*62));
					self:x(80);
					if hsFinalProc[i]["player"] then
						self:visible(false);
					else
						self:visible(true);
					end;
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};


		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/"..spriteGrade))..{
			OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
			SetLetterCommand=function(self)
				self:zoom(0.26);
				self:y(-126 + (i*62));
				self:x(153);
				self:setstate(gradeTransform(hsFinalProc[i]["score"]));
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};		

	

	end;

	return t;
end;

function getGraphCard(player)
--[[
			Trace("-----------------------------------------------");
			Trace("- SongPosition :"..timingP1[i]["songPosition"]);
			Trace("- msSongPosition :"..timingP1[i]["msSongPosition"]);
			Trace("- beat :"..timingP1[i]["beat"]);
			Trace("- beatrow :"..timingP1[i]["beatrow"]);
			Trace("- col [Columna] :"..timingP1[i]["col"]);
			Trace("- tns :"..timingP1[i]["tns"]);
			Trace("- tns_name :"..timingP1[i]["tns_name"]);
			Trace("- offset :"..timingP1[i]["offset_ms"]);
			Trace("- isEarly :"..timingP1[i]["isEarly"]);
]]

	local dataPlayerGraphs = {};
	--we obtain the data colected.
	local width = 460;
	local height = 150;
	local padding = 4;
	local smooth_radius = 14;



	if player == PLAYER_1 then
		if GAMESTATE:Env()["timingP1"] ~= nil then
			dataPlayerGraphs = GAMESTATE:Env()["timingP1"];
		end;
	end;
	if player == PLAYER_2 then
		if GAMESTATE:Env()["timingP2"] ~= nil then
			dataPlayerGraphs = GAMESTATE:Env()["timingP2"];
		end;
	end;

	local MaxOffset = 200;
	local MinOffset = -200;
	--create array for data
	local bins = {};
	for i = MinOffset, MaxOffset do
	    bins[i] = { total = 0, tns = "" , color = "#000000" };
	end

	local tnsColors = {"#b9feff","#00ccff","#00ff24","#fff600","#ff00de","#ff0000"};

	--now we navigate everything to pupulate.
	for i=1, #dataPlayerGraphs do
		--we check the color
		local color = tnsColors[dataPlayerGraphs[i]["tns"]+1];
		local offsetAction = dataPlayerGraphs[i]["offset_ms"];

		if offsetAction > MaxOffset then
			offsetAction = MaxOffset;
		end;

		if offsetAction < MinOffset then
			offsetAction = MinOffset;
		end;

		local tempCount = bins[offsetAction]["total"];
		bins[offsetAction]["total"] = tempCount + 1;
		bins[offsetAction]["tns"] = dataPlayerGraphs[i]["tns_name"]; --perfect,great,good,bad,miss
		bins[offsetAction]["color"] = color; 		
	end;

	--graph


	return Def.ActorFrame {



	    Def.Quad{
	      InitCommand=function(self)
	        self:zoomto(width-3, height+40):diffuse(0,0,0,0.65):diffusebottomedge(0,0,0,0.8):x(-2);
	      end
	    };

		Def.ActorFrame {
			OnCommand=function(self)
				self:zoomx(1);
				self:y(-10);
			end;

		    Def.ActorMultiVertex{
		      InitCommand=function(self) 
		      	self:SetDrawState{Mode="DrawMode_Triangles"} 
		      end;

		      OnCommand=function(self)
		        local verts = build_area_verts(bins,MinOffset,MaxOffset,padding,width,height,smooth_radius);
		        self:SetNumVertices(#verts)
		        self:SetVertices(verts)
		      end;
		    };
		};

	    Def.Quad{
	      InitCommand=function(self) self:zoomto(2, height-padding*2+35):diffuse(color("#fff000")) end
	    },

	    Def.Quad{
	      InitCommand=function(self) self:zoomto(width-1, 1):diffuse(color("#ffffff")):y(61):x(-2) end
	    },

		LoadFont("xolonium 20px")..{	
				OnCommand=function(self)
					self:zoom(0.8);
					self:x(96);
					self:y(80);
					self:settext("0 MS / Perfect Timing");
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	    

	    --early
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,0;x,-170;y,-80;zoom,0.6);
		};
	    --early
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,-170;y,-50;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,-135;y,-40;zoom,0.6);
		};
		--late
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,1;x,170;y,-80;zoom,0.6);
		};	
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,170;y,-50;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,203;y,-60;zoom,0.6);
		};


		 LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,-52;y,80;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,-17;y,80;zoom,0.6);
		};

	};	

end;

function build_area_verts(bins,MIN_BIN,MAX_BIN,PADDING,WIDTH,HEIGHT,SMOOTH_RADIUS)

  local counts, maxCount = smooth_counts(bins, SMOOTH_RADIUS,MIN_BIN,MAX_BIN)
  local verts = {}
  if maxCount == 0 then return verts end

  local innerW = WIDTH - PADDING*2
  local innerH = HEIGHT - PADDING*2
  local binCount = (MAX_BIN - MIN_BIN + 1)
  local binW = innerW / binCount
  local leftX = -WIDTH/2 + PADDING
  local baseY =  HEIGHT/2 - PADDING

  for i=MIN_BIN,MAX_BIN do
    local c = counts[i] or 0
    local h = math.max(1, (c / maxCount) * innerH)
    local xL = leftX + (i - MIN_BIN) * binW
    local xR = xL + binW
    local yB = baseY
    local yT = baseY - h
    local col = color_for_ms(bins[i])  -- color fijo por ventana
    if i == 0 then
    	col = color("#fff000"); 
    end;

    -- rectángulo como 2 triángulos
    verts[#verts+1] = { {xL, yB, 0}, col }
    verts[#verts+1] = { {xL, yT, 0}, col }
    verts[#verts+1] = { {xR, yT, 0}, col }

    verts[#verts+1] = { {xL, yB, 0}, col }
    verts[#verts+1] = { {xR, yT, 0}, col }
    verts[#verts+1] = { {xR, yB, 0}, col }
  end

  return verts
end

function color_for_ms(data)
	return color(data["color"]);
end;

function smooth_counts(bins, r,MIN_BIN,MAX_BIN)
  if r<=0 then
    local raw, m = {}, 0
    for i=MIN_BIN,MAX_BIN do raw[i]=bins[i].total; if raw[i]>m then m=raw[i] end end
    return raw, m
  end
  local k = gaussian_kernel(r); local half = math.floor(#k/2)
  local out, m = {}, 0
  for i=MIN_BIN,MAX_BIN do
    local s=0
    for j=-half,half do
      local jj=i+j
      if jj>=MIN_BIN and jj<=MAX_BIN then s = s + bins[jj].total * k[j+half+1] end
    end
    out[i]=s; if s>m then m=s end
  end
  return out, m
end

function gaussian_kernel(r)
  if r <= 0 then return {1} end
  local sigma = r * 0.75
  local twoS2 = 2*sigma*sigma
  local k, sum = {}, 0
  for x=-r, r do
    local w = math.exp(-(x*x)/twoS2); k[#k+1]=w; sum=sum+w
  end
  for i=1,#k do k[i]=k[i]/sum end
  return k
end

--############################--
--###   BASE PLACEHOLDER   ###--
--############################--

function getInfoTabPlayer(PLAYER)

local xPlace=0;
local yPlace=0;

if PLAYER == PLAYER_1 then
	xPlace = SCREEN_CENTER_X - (globalXBaseInformation+fixXForP1);
	yPlace = SCREEN_CENTER_Y+250;
end;
if PLAYER == PLAYER_2 then
	xPlace = SCREEN_CENTER_X + globalXBaseInformation;
	yPlace = SCREEN_CENTER_Y+250;
end;

	return Def.ActorFrame{
		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/base"))..{
			Name="baseInfo";
			OnCommand=function(self)
				self:y(yPlace);
				self:x(xPlace+25);
				self:diffusealpha(0.8);
				self:zoom(0.7);
				self:zoomx(0.81);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};

		--base titulos
		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/selectBase"))..{
			Name="selectBaseInfo";
			OnCommand=function(self)
				self:y(yPlace-78);
				self:x(xPlace+placesBarOptionInfo[1]);
				self:zoom(0.8);
				iconBaseOption[PLAYER] = self;
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		}; 	

		--titulos
		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/title_hs"))..{
			OnCommand=function(self)
				self:y(yPlace-78);
				self:x(xPlace+placesBarOptionInfo[1]);
				self:zoom(0.8);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};
		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/title_rank"))..{
			OnCommand=function(self)
				self:y(yPlace-78);
				self:x(xPlace+placesBarOptionInfo[2]);
				self:zoom(0.8);
			end;	
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};	

		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/graph"))..{
			OnCommand=function(self)
				self:y(yPlace-78);
				self:x(xPlace+placesBarOptionInfo[3]);
				self:zoom(0.8);
			end;	
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};	

		--tarjetas
		getHighCoreCard(PLAYER)..{
			OnCommand=function(self)
				self:y(yPlace+10);
				self:x(xPlace+28);
				self:zoom(0.8);
				cardActorHSList[PLAYER] = self;
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);	
		};	

		--Ranking
		getRankingCard(PLAYER)..{
			OnCommand=function(self)
			self:y(yPlace+10);
			self:x(xPlace+28);
			self:zoom(0.8);
			cardActorRankingList[PLAYER] = self;
			self:visible(false);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);	
		};	
		--Graphic
		getGraphCard(PLAYER)..{
			OnCommand=function(self)
			self:y(yPlace+10);
			self:x(xPlace+28);
			self:zoom(0.8);
			cardActorGraphList[PLAYER] = self;
			self:visible(false);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);	
		};	


		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/actions 1x4"))..{
			Name="dleft";
			OnCommand=function(self)
				self:y(yPlace+80);
				self:x(xPlace-150);
				self:animate(false);
				self:setstate(2);
				self:diffusealpha(1);
				self:zoom(0.5);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};
		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/actions 1x4"))..{
			Name="rleft";
			OnCommand=function(self)
				self:y(yPlace+80);
				self:x(xPlace+200);
				self:animate(false);
				self:setstate(3);
				self:diffusealpha(1);
				self:zoom(0.5);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
		};

		OnCommand= function(self)
			SCREENMAN:GetTopScreen():AddInputCallback(input)
			infoDivActor[PLAYER] = self;
		end
	};

end;


--############################--
--###      LOAD FRAME      ###--
--############################--
local t = Def.ActorFrame{};

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	t[#t + 1] = getInfoTabPlayer(PLAYER_1);
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t + 1] = getInfoTabPlayer(PLAYER_2);
end;

return t;