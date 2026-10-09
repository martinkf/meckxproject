-- :: SECTIONS ::
-- FUNCTIONS_FRAME
-- CARDS_FRAME
-- BASE PLACEHOLDER
-- LOAD FRAME

function createLinearLifeGraph(params)
	local width      = params.width or 450
	local height     = params.height or 200
	local data       = params.data or {}
	local line_width = params.line_width or 3
	local border      = (params.border ~= false)
	local border_color = params.border_color or {0,0,0,1}
	local border_width  = params.border_width or 4
	local bg_color = params.bg_color or {1,1,1,1}

	local max_sec = params.max_sec
	if not max_sec then
		max_sec = (#data > 0) and data[#data].sec or 1
	end
	if max_sec <= 0 then max_sec = 1 end

	-- ===== Colores por banda de vida =====
	local BAND_COLOR = {
		green  = {0.10, 0.80, 0.30, 1},
		yellow = {1.00, 0.85, 0.10, 1},
		red    = {0.90, 0.15, 0.15, 1},
	}

	-- umbrales ordenados de mayor a menor, con la banda de arriba y de abajo de cada uno
	local THRESHOLDS = {
		{ t = 0.6, above = BAND_COLOR.green,  below = BAND_COLOR.yellow },
		{ t = 0.3, above = BAND_COLOR.yellow, below = BAND_COLOR.red },
	}

	local function GetColorForLife(life)
		if life >= 0.6 then return BAND_COLOR.green
		elseif life >= 0.3 then return BAND_COLOR.yellow
		else return BAND_COLOR.red end
	end

	local function toXY(life, sec)
		local x = (sec / max_sec) * width
		if x > width then x = width end
		if x < 0 then x = 0 end
		local y = height - (life * height)
		if y < 0 then y = 0 end
		if y > height then y = height end
		return x, y
	end

	-- devuelve los umbrales que quedan estrictamente entre life1 y life2,
	-- con su fracción de avance (0..1) a lo largo del segmento
	local function GetCrossings(life1, life2)
		local crossings = {}
		if life1 == life2 then return crossings end
		local lo, hi = math.min(life1, life2), math.max(life1, life2)
		for _, entry in ipairs(THRESHOLDS) do
			if entry.t > lo and entry.t < hi then
				local frac = (entry.t - life1) / (life2 - life1)
				table.insert(crossings, { entry = entry, frac = frac })
			end
		end
		table.sort(crossings, function(a,b) return a.frac < b.frac end)
		return crossings
	end

	-- agrega los vértices de un segmento (life1,sec1) -> (life2,sec2),
	-- insertando cortes duros de color en cada cruce de umbral
	local function AddSegment(verts, life1, sec1, life2, sec2)
		if #verts == 0 then
			local x, y = toXY(life1, sec1)
			table.insert(verts, { {x,y,0}, GetColorForLife(life1), {0,0} })
		end

		local goingDown = life2 < life1
		local crossings = GetCrossings(life1, life2)

		for _, c in ipairs(crossings) do
			local sec = sec1 + c.frac * (sec2 - sec1)
			local x, y = toXY(c.entry.t, sec)

			local closingColor = goingDown and c.entry.above or c.entry.below
			local openingColor = goingDown and c.entry.below or c.entry.above

			table.insert(verts, { {x,y,0}, closingColor, {0,0} }) 
			table.insert(verts, { {x,y,0}, openingColor, {0,0} }) 
		end

		local x2, y2 = toXY(life2, sec2)
		table.insert(verts, { {x2,y2,0}, GetColorForLife(life2), {0,0} })
	end

	local function BuildVerts()
		local verts = {}

		if #data == 0 then
			table.insert(verts, { {0, height/2, 0}, BAND_COLOR.green, {0,0} })
			table.insert(verts, { {width, height/2, 0}, BAND_COLOR.green, {0,0} })
			return verts
		end

		for i = 2, #data do
			AddSegment(verts, data[i-1].life, data[i-1].sec, data[i].life, data[i].sec)
		end
		if #data == 1 then
			local x, y = toXY(data[1].life, data[1].sec)
			table.insert(verts, { {x,y,0}, GetColorForLife(data[1].life), {0,0} })
		end

		local last = data[#data]
		if last.sec < max_sec then
			local x, y = toXY(last.life, max_sec)
			table.insert(verts, { {x,y,0}, GetColorForLife(last.life), {0,0} })
		end

		return verts
	end

	local function functionDeathZone()
		local deathData = {isDead=false,x=0,sec=0};
		for i = 1, #data do
			if data[i].life == 0 then
				local x, y = toXY(data[i].life, data[i].sec)
				deathData["isDead"] = true;
				deathData["x"] = x;
				deathData["sec"] = data[i].realSec;
				return deathData;
			end;
		end
		return deathData;
	end;

	local af = Def.ActorFrame{
		InitCommand=function(self) self:xy(0,0) end,

	}

	if border then
		local bw = border_width
		af[#af+1] = Def.Quad{ InitCommand=function(self) self:xy(width/2, 0):zoomto(width+bw, bw):diffuse(border_color) end }
		af[#af+1] = Def.Quad{ InitCommand=function(self) self:xy(width/2, height):zoomto(width+bw, bw):diffuse(border_color) end }
		af[#af+1] = Def.Quad{ InitCommand=function(self) self:xy(0, height/2):zoomto(bw, height+bw):diffuse(border_color) end }
		af[#af+1] = Def.Quad{ InitCommand=function(self) self:xy(width, height/2):zoomto(bw, height+bw):diffuse(border_color) end }
	end

	local dataVerts = BuildVerts();
	local deathZoneData = functionDeathZone();

	-- la línea va AL FINAL, así queda arriba en el z-order
	af[#af+1] = Def.ActorMultiVertex{
		InitCommand=function(self)
			self:SetDrawState{ Mode="DrawMode_LineStrip" }
			self:SetLineWidth(line_width)
			self:SetVertices(dataVerts)
		end
	};

	af[#af+1] = Def.ActorFrame{
			OnCommand=function(self)
				if deathZoneData["isDead"] then
					self:visible(true);
					self:x(deathZoneData["x"]);
					self:y(185);
				else
					self:visible(false);
				end;	
			end;

			LoadActor(THEME:GetPathG("","ScreenEvaluation/information/skullIcon"))..{
				Name="deathIcon";
				InitCommand=function(self)
					self:zoom(0.3);
				end;
			};

			LoadFont("normalxolonium")..{
				InitCommand=function(self)
					if deathZoneData["isDead"] then
						self:y(20);
						self:zoom(0.5);
						self:horizalign("center");					
						--self:settext("Survived: "..deathZoneData["sec"]);
						self:settext("Survived: "..formatSecondsFull(deathZoneData["sec"]));
					else
						self:settext("");
					end;
				end;
			};
	};


	return af
end


--############################--
--###   FUNCTIONS_FRAME    ###--
--############################--
local infoDivActor = {};
local iconBaseOption = {};
local placesBarOptionInfo = {-110,-20,70,160}; -- 4 opciones maximo

local optList = {"highscore","ranking","graph","gameplay"}; -- 2 activas
local cardActorHSList = {};
local cardActorRankingList = {};
local cardActorGraphList = {};
local cardActorGameplayList = {};


local player1BaseOptionInfo=1;
local player2BaseOptionInfo=1;

local globalXBaseInformation = 335; -- PLACE DEL BOX EN LA PANTALLA
local fixXForP1 = 50; -- mmmmm

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	if event.type ~= "InputEventType_FirstPress" then return false end
	local button= event.GameButton

	local playerBaseOptionSelected = 1;

	if button == "MenuUp" or button == "MenuDown" then
		return;
	end;

	if pn == PLAYER_1 then

		if button == "MenuLeft" then
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
			cardActorGameplayList[pn]:visible(false);

		end;

		if optList[playerBaseOptionSelected] == "ranking" then
			cardActorHSList[pn]:visible(false);	
			cardActorRankingList[pn]:visible(true);
			cardActorGraphList[pn]:visible(false);
			cardActorGameplayList[pn]:visible(false);
		end;	

		if optList[playerBaseOptionSelected] == "graph" then
			cardActorHSList[pn]:visible(false);	
			cardActorRankingList[pn]:visible(false);
			cardActorGraphList[pn]:visible(true);
			cardActorGameplayList[pn]:visible(false);
		end;

		if optList[playerBaseOptionSelected] == "gameplay" then
			cardActorHSList[pn]:visible(false);	
			cardActorRankingList[pn]:visible(false);
			cardActorGraphList[pn]:visible(false);
			cardActorGameplayList[pn]:visible(true);
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



--##Graph Cards
function getGraphCard(player)

	local dataPlayerGraphsOrig = {};
	if player == PLAYER_1 then
		if GAMESTATE:Env()["timingP1"] ~= nil then
			dataPlayerGraphsOrig = GAMESTATE:Env()["timingP1"];
		end;
	end;
	if player == PLAYER_2 then
		if GAMESTATE:Env()["timingP2"] ~= nil then
			dataPlayerGraphsOrig = GAMESTATE:Env()["timingP2"];
		end;
	end;
	local tnsColors = {"#00ccff","#00ccff","#00ff24","#fff600","#ff00de","#ff0000"};

    local width = 460;
    local height = 150;


    local pointSize = 2.9; 
    local xSpacingScale = 0.98; 
    local ySpacingScale = 1.5;  
    local maxOffsetMs = 200;    


    local function clamp(valor, minimo, maximo)
        if valor < minimo then return minimo; end
        if valor > maximo then return maximo; end
        return valor;
    end

    local minBeat, maxBeat = nil, nil;
    local dataPlayerGraphs = {};

    dataPlayerGraphs = dataPlayerGraphsOrig;
    --[[
    for i=1,#dataPlayerGraphsOrig do
        if dataPlayerGraphsOrig[i]["isHoldNote"] == 0 then
        	table.insert(dataPlayerGraphs,dataPlayerGraphsOrig[i]);
        end;
    end;
    ]]


    local totalPuntos = #dataPlayerGraphs;

    for i=1,totalPuntos do
        local b = dataPlayerGraphs[i]["beat"];
        if minBeat == nil or b < minBeat then minBeat = b; end
        if maxBeat == nil or b > maxBeat then maxBeat = b; end
    end

    local rangoBeat = (maxBeat and minBeat) and (maxBeat - minBeat) or 0;
    if rangoBeat == 0 then rangoBeat = 1; end

    local graphBaseColors = {
    	ej={32,90},
    	nj={32,70},
    	hj={32,51},
    	vj={22,32},
    	xj={22,22},
    	uj={22,22},
    }
    local graphBaseColorsYBase = {
    	ej={-12,-12},
    	nj={-12,-12},
    	hj={-12,-12},
    	vj={-12,-11.5},
    	xj={-12,-12},
    	uj={-12,-12},
    }

    local judgPlayer = "nj";
    local STATE = GAMESTATE:GetPlayerState(player);
    if STATE:GetPlayerOptions('ModsLevel_Preferred'):EasyJudgement() then judgPlayer="ej"; end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):HardJudgement() then judgPlayer="hj"; end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):VeryHardJudgement() then judgPlayer="vj"; end;			
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):ExtraJudgement() then judgPlayer="vj"; end;
	if STATE:GetPlayerOptions('ModsLevel_Preferred'):UltraHardJudgement() then judgPlayer="uj"; end;

    local graphLifeToUse = {};
    local minBeatLifeGraph = nil;
    local maxBeatLifeGraph = nil;
    if player == PLAYER_1 then
    	graphLifeToUse = GAMESTATE:Env()["lifeP1"];
    else
    	graphLifeToUse = GAMESTATE:Env()["lifeP2"];
    end;

	local song = GAMESTATE:GetCurrentSong();	
    for i=1,#graphLifeToUse do
        local b = graphLifeToUse[i]["sec"];
        if minBeatLifeGraph == nil or b < minBeatLifeGraph then minBeatLifeGraph = b; end
        if maxBeatLifeGraph == nil or b > maxBeatLifeGraph then maxBeatLifeGraph = b; end
    end


	local graph = createLinearLifeGraph(
		{width = 452,
		height = 184,
		data = graphLifeToUse,
		max_sec = maxBeatLifeGraph,--song:GetLastBeat(),
		line_width = 1
		}
	);

	graph.OnCommand = function(self)
		self:xy(-230, -90);
		--self:zoomx(1.45)
	end

	--t[#t+1] = graph


    local t = Def.ActorFrame{
        Name="GraphPoints_P"..player;

        InitCommand=function(self)
            self:x(0);
            self:y(0);
        end;


        Def.Quad{
            Name="perf";
            InitCommand=function(self)
            	self:x(-2);
            	self:y(0);
                self:zoomto(458, 192);
                self:diffuse(color("#000000"));
            end;
        };

        Def.Quad{
            Name="perf";
            InitCommand=function(self)
            	self:x(-3);
            	self:y(graphBaseColorsYBase[judgPlayer][2]);
                self:zoomto(460, graphBaseColors[judgPlayer][2]);
                self:diffuse(color("#1f274d"));
            end;
        };

        Def.Quad{
            Name="perfEx";
            InitCommand=function(self)

				local extraJudgment = GAMESTATE:GetExtraJudgment();
				if extraJudgment then
	            	self:x(-3);
	            	self:y(graphBaseColorsYBase[judgPlayer][1]);
	                self:zoomto(460, graphBaseColors[judgPlayer][1]);
	                self:diffuse(color("#314445"));
				else
					self:visible(false);
				end;


            end;
        };

        graph;
        --examples

        Def.ActorFrame{

        	OnCommand=function(self)
        		if player == PLAYER_1 then
        			self:x(-242);
        		else
        			self:x(236);	
        		end;        		
        		self:y(-12);
        	end;

        	Def.ActorFrame{
        		Name="ejEx";
        		OnCommand=function(self)

        		end;
		        Def.Quad{
		            Name="ejx";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["ej"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };
				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-55);
							self:settext("EJ");
							self:x(-5);
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};
        	};

        	Def.ActorFrame{
        		Name="njEx";
        		OnCommand=function(self)
        			if player == PLAYER_1 then
        				self:x(-15);
        			else
        				self:x(15);
        			end;
        		end;

		        Def.Quad{
		            Name="nje";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["nj"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };

				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-46);
							self:x(-6);
							self:settext("NJ");
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};

        	};


        	Def.ActorFrame{
        		Name="hjEx";
        		OnCommand=function(self)
        			if player == PLAYER_1 then
        				self:x(-30);
        			else
        				self:x(30);
        			end;
        		end;

		        Def.Quad{
		            Name="hje";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["hj"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };

				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-35);
							self:x(-6);
							self:settext("HJ");
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};

        	};


        	Def.ActorFrame{
        		Name="vjEx";
        		OnCommand=function(self)
        			if player == PLAYER_1 then
        				self:x(-45);
        			else
        				self:x(45);
        			end;
        		end;

		        Def.Quad{
		            Name="hje";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["vj"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };

				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-25);
							self:x(-6);
							self:settext("VJ");
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};

        	};

        	Def.ActorFrame{
        		Name="xjEx";
        		OnCommand=function(self)
        			if player == PLAYER_1 then
        				self:x(-60);
        			else
        				self:x(60);
        			end;
        		end;

		        Def.Quad{
		            Name="hje";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["xj"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };

				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-25);
							self:x(-6);
							self:settext("XJ");
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};
        	};


        	Def.ActorFrame{
        		Name="ujEx";
        		OnCommand=function(self)
        			if player == PLAYER_1 then
        				self:x(-75);
        			else
        				self:x(75);
        			end;
        		end;

		        Def.Quad{
		            Name="hje";
		            InitCommand=function(self)
		                self:zoomto(10, graphBaseColors["uj"][2]);
		                self:diffuse(color("#4dc3ff"));
		            end;
		        };

				LoadFont("normalxolonium 15x15")..{
					OnCommand=function(self)
							self:y(-25);
							self:x(-6);
							self:settext("UJ");
							self:zoom(0.45);
							self:horizalign("left");
					end;
				};
        	};

        };


        --[[
        Def.Quad{
            Name="nje";
            InitCommand=function(self)
            	self:x(255);
            	self:y(graphBaseColorsYBase[judgPlayer][2]);
                self:zoomto(10, graphBaseColors["nj"][2]);
                self:diffuse(color("#4dc3ff"));
            end;
        };
		LoadFont("normalxolonium 15x15")..{
			OnCommand=function(self)
					self:y(-58);
					self:x(248);
					self:settext("NJ");
					self:zoom(0.45);
					self:horizalign("left");
			end;
		};

        Def.Quad{
            Name="nje";
            InitCommand=function(self)
            	self:x(255);
            	self:y(graphBaseColorsYBase[judgPlayer][2]);
                self:zoomto(10, graphBaseColors["nj"][2]);
                self:diffuse(color("#4dc3ff"));
            end;
        };
		LoadFont("normalxolonium 15x15")..{
			OnCommand=function(self)
					self:y(-58);
					self:x(248);
					self:settext("NJ");
					self:zoom(0.45);
					self:horizalign("left");
			end;
		};
]]
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/new_receptor_graph"))..{
			OnCommand=function(self)
				self:zoom(1.68);
				self:x(-4);
				self:diffusealpha(0);
			end;
		};

        Def.Quad{
            Name="BaseX";
            InitCommand=function(self)
            	self:x(-3);
                self:zoomto(460, 1);
                self:diffuse(color("#ffff00"));
            end;
        };



	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,1;x,0;y,-80;zoom,0.6);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,0;x,0;y,80;zoom,0.6);
		};
    };



    for i=1,totalPuntos do
        local entrada = dataPlayerGraphs[i];
        if entrada["isHoldNote"] == 1 and (entrada["tns"]+1) == 6 then

        end;

        local colorHex = tnsColors[entrada["tns"]+1];
        local offsetMs = clamp(entrada["offset_ms"], -maxOffsetMs, maxOffsetMs);
        local beat = entrada["beat"];

        local ratioX = (beat - minBeat) / rangoBeat;
        local posX = (-width/2) + (ratioX * width * xSpacingScale);
        posX = clamp(posX, -width/2, width/2);

        local ratioY = offsetMs / maxOffsetMs;
        local posY = -(ratioY * (height/2) * ySpacingScale);
        posY = clamp(posY, -height/2, height/2); 

        t[#t+1] = Def.Quad{
            Name="Point"..i;
            InitCommand=function(self)
                self:x(posX);
                self:y(posY);
                self:zoomto(pointSize, pointSize);
                self:diffuse(color(colorHex));
            end;
        };
    end

    return t;
end;

function old_getGraphCard(player)

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


--## Gameplay
function createMatrixStats(player)
	local matrixSelected = {};

	local statsStartXPlace = {
		single=-115;
		half=-150;
		double = -180;
	};
	local xPlaceSelected = 0;

	--:::::::::::::::::::::--
	-- MATRIX DEFINITION
	--:::::::::::::::::::::--
	local singleMatrix={
		pf={0,0,0,0,0},
		gr={0,0,0,0,0},
		gd={0,0,0,0,0},
		bd={0,0,0,0,0},
		ms={0,0,0,0,0},
	};

	local doubleMatrix={
		pf={0,0,0,0,0,0,0,0,0,0},
		gr={0,0,0,0,0,0,0,0,0,0},
		gd={0,0,0,0,0,0,0,0,0,0},
		bd={0,0,0,0,0,0,0,0,0,0},
		ms={0,0,0,0,0,0,0,0,0,0},
	};

	local halfMatrix={
		pf={0,0,0,0,0,0},
		gr={0,0,0,0,0,0},
		gd={0,0,0,0,0,0},
		bd={0,0,0,0,0,0},
		ms={0,0,0,0,0,0},
	};

	--:::::::::::::::::::::--
	-- PROC PLAYER DATA
	--:::::::::::::::::::::--

	local dataPl = "P1";
	if player == PLAYER_2 then
		dataPl = "P2";
	end;
	local dataTmp = GAMESTATE:Env()["timing"..dataPl];

	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
		local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
		if isHalf then
			matrixSelected = halfMatrix;
			xPlaceSelected = statsStartXPlace[2];
		else
			matrixSelected = doubleMatrix;
			xPlaceSelected = statsStartXPlace[3];
		end;
	else
		matrixSelected = singleMatrix;
		xPlaceSelected = statsStartXPlace[1];
	end;

	if dataTmp == nil or #dataTmp == 0 then
		return {matrix=matrixSelected,alertCol={}};
	end;

	--get the timing stats for the player.
	for i=1,#dataTmp do
		local colData = dataTmp[i]["col"] + 1;
		if dataTmp[i]["tns"] == 0 or dataTmp[i]["tns"] == 1 then
			matrixSelected["pf"][colData] = matrixSelected["pf"][colData] + 1;
		elseif dataTmp[i]["tns"] == 2 then
			matrixSelected["gr"][colData] = matrixSelected["gr"][colData] + 1;
		elseif dataTmp[i]["tns"] == 3 then
			matrixSelected["gd"][colData] = matrixSelected["gd"][colData] + 1;
		elseif dataTmp[i]["tns"] == 4 then
			matrixSelected["bd"][colData] = matrixSelected["bd"][colData] + 1;
		elseif dataTmp[i]["tns"] == 5 then
			matrixSelected["ms"][colData] = matrixSelected["ms"][colData] + 1;
		end;
	end;

	--:::::::::::::::::::::--
	-- COL ALERTS
	--:::::::::::::::::::::--

	--here we have the cols that needs to have a light or something
	--they have too much data like why this col has 123904812938 bads?
	local colAlerts = {};

	for i=1,#matrixSelected["pf"] do
		local colorAlert = "";
		local existAlert = false;

		--if a same col has good,bad and misses, the lower judg will take over.
		if matrixSelected["gd"][i] > 3 then
			colorAlert="#ffff00";
			existAlert = true;
		end;
		if matrixSelected["bd"][i] > 3 then
			colorAlert="#d302f7";
			existAlert = true;
		end;
		if matrixSelected["ms"][i] > 3 then
			colorAlert="#f70247";
			existAlert = true;
		end;
		if existAlert then
			table.insert(colAlerts,{col=i,color=colorAlert});
		end;
	end;
	return {matrix=matrixSelected,alertCol=colAlerts};
end;



function getGameplayCard(player)

	local dataPlayerGraphs = {};
	--we obtain the data colected.
	local width = 460;
	local height = 150;

	--:::::::::::::::::::::::::::::--
	--           global
	--:::::::::::::::::::::::::::::--
	local globaly = -20;
	local yBaseJudgment = globaly+(-38);
	local yBaseForArrows = globaly+(-45);
	local yPlaceBase = globaly+(-18);
	--:::::::::::::::::::::::::::::--
	--           Judgments
	--:::::::::::::::::::::::::::::--
	local paddingJudgment = 20;
	local zoomJudgments = 0.22;

	local baseTable = Def.ActorFrame{
		OnCommand=function(self)

		end;
	};


	local judgments = Def.ActorFrame{
		OnCommand=function(self)
			self:y(yBaseJudgment);
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
				if isHalf then
					self:x(-160);
				else
					self:x(-200);					
				end;
			else
				self:x(-150);
			end;
		end;
	};

	for i=1,5 do
		judgments[#judgments+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/Judgments 1x6"))..{
				Name="judg"..i;
				InitCommand=function(self)

					if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then						
						local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
						if isHalf == false then
							zoomJudgments = 0.18;
						end;
					end;
					self:animate(false);
					self:setstate(i);
					self:y(0 + (i*paddingJudgment));
					self:zoom(zoomJudgments);
				end;
		};
	end;


	--:::::::::::::::::::::::::::::--
	--           ARROWS
	--:::::::::::::::::::::::::::::--

	local paddingPos = 45;
	local zoomArrows = 0.15;
	local arrowStartPlace = {
		--single=-142;
		single=-115;
		half=-130;
		double = -180;
	};

	local arrowsPlaces = Def.ActorFrame{
		Name="arrowPlaces";
		OnCommand=function(self)
			self:y(yBaseForArrows);

			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
				if isHalf then
					self:queuecommand("setHalf");
				else
					self:queuecommand("setDouble");
				end;
			else
				self:queuecommand("setSingle");
			end;
			self:zoom(0.85);
		end;
		setSingleCommand=function(self)
			self:x(arrowStartPlace["single"]);
		end;
		setDoubleCommand=function(self)
			self:x(arrowStartPlace["double"]);
		end;
		setHalfCommand=function(self)
			self:x(arrowStartPlace["half"]);
		end;
	};

	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
		local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
		if isHalf then


			local gridColor="#ffffff";
			for i=1,7 do
			    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
			      InitCommand=function(self) 
			      	self:zoomto(2, 190):diffuse(color(gridColor));
			      	self:y(75);
			      	self:x(-23 + (i*paddingPos));
			      end;
			    };
			end;	

			for i=1,5 do
			    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
			      InitCommand=function(self) 
			      	self:zoomto(380,1):diffuse(color(gridColor));
			      	self:y(43 + ( (i-1)*24));
			      	self:x(100);
			      	self:diffusealpha(0.5);
			      end;
			    };
			end;

			local iPageArrow = 1;
			for i = 1,6 do 
				arrowsPlaces[#arrowsPlaces+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrowsDetail 1x5"))..{
					Name="arrow"..i;
					InitCommand=function(self)
						iPageArrow = i;
						if iPageArrow == 1  then
							iPageArrow = 3;
						elseif iPageArrow == 2  then
							iPageArrow = 4;
						elseif iPageArrow == 3  then
							iPageArrow = 5;
						elseif iPageArrow == 4  then
							iPageArrow = 1;
						elseif iPageArrow == 5  then
							iPageArrow = 2;
						elseif iPageArrow == 6  then
							iPageArrow = 3;
						end;
						self:animate(false);
						self:setstate(iPageArrow-1);
						self:x(0 + (i*paddingPos));
						self:zoom(zoomArrows);


					end;
				};
			end;


		else

			--grid for this
			local gridColor="#ffffff";
			for i=1,11 do
			    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
			      InitCommand=function(self) 
			      	self:zoomto(2, 190):diffuse(color(gridColor));
			      	self:y(75);
			      	self:x(-23 + (i*paddingPos));
			      end;
			    };
			end;

			local iPageArrow = 1;
			for i = 1,10 do 
				arrowsPlaces[#arrowsPlaces+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrowsDetail 1x5"))..{
					Name="arrow"..i;
					InitCommand=function(self)
						iPageArrow = i;
						if iPageArrow > 5 then
							iPageArrow = iPageArrow - 5;
						end;
						self:animate(false);
						self:setstate(iPageArrow-1);
						self:x(0 + (i*paddingPos));
						self:zoom(zoomArrows);


					end;
				};
			end;


			for i=1,5 do
			    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
			      InitCommand=function(self) 
			      	self:zoomto(530,1):diffuse(color(gridColor));
			      	self:y(43 + ( (i-1)*24));
			      	self:x(205);
			      	self:diffusealpha(0.5);
			      end;
			    };
			end;

		end;
	else
		--grid for this
		local gridColor="#ffffff";
		for i=1,6 do
		    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
		      InitCommand=function(self) 
		      	self:zoomto(2, 190):diffuse(color(gridColor));
		      	self:y(75);
		      	self:x(-23 + (i*paddingPos));
		      end;
		    };
		end;

		for i = 1,5 do 
			arrowsPlaces[#arrowsPlaces+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrowsDetail 1x5"))..{
				Name="arrow"..i;
				InitCommand=function(self)
					self:animate(false);
					self:setstate(i-1);
					self:x(0 + (i*paddingPos));
					self:zoom(zoomArrows);
				end;
			};
		end;

		for i=1,5 do
		    arrowsPlaces[#arrowsPlaces+1] = Def.Quad{
		      InitCommand=function(self) 
		      	self:zoomto(330,1):diffuse(color(gridColor));
		      	self:y(43 + ( (i-1)*24));
		      	self:x(80);
		      	self:diffusealpha(0.5);
		      end;
		    };
		end;

	end;

	--:::::::::::::::::::::::::::::--
	--           STATS
	--:::::::::::::::::::::::::::::--
	
	--here we do something more fucked, 
	--5 col - 5 rows = single
	--10 col - 5 rows = double
	--6 col - 5 rows = single

	--stat data
	local matrixData = createMatrixStats(player);

	--stat main frame
	local matrixFrame = Def.ActorFrame{
		OnCommand=function(self)
			self:zoom(1);
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				local isHalf = GAMESTATE:GetCurrentStyle():GetName() == "halfdouble";
				if isHalf then
					self:x(-92);
				else
					self:x(-142);
				end;
			else
				self:x(-78);
			end;
		end;
	};

	local xPlaceSelected=0;
	local marginStats = 38;
	local yBaseMargin = 20;

	local colorAlert = {
		good = "#fcff00",
		bad = "#f702b2",
		miss="#f70202"
	}

	for i=1,5 do -- perfect -> miss
		for x=1,#matrixData["matrix"]["pf"] do 
			local defValue=0;
			local rowName = "pf";
			if i == 2 then rowName = "gr"; end;
			if i == 3 then rowName = "gd"; end;
			if i == 4 then rowName = "bd"; end;
			if i == 5 then rowName = "ms"; end;

			if matrixData["matrix"][rowName][x] > 0 then
				defValue = matrixData["matrix"][rowName][x];
			end;


			if defValue >= 2 and i > 2 then

					local colorSelected = "";
					local diffuseValue=0.2;
					if i == 3 then
						colorSelected = colorAlert["good"];
					elseif i == 4 then
						colorSelected = colorAlert["bad"];
					elseif i == 5 then
						colorSelected = colorAlert["miss"];
					end;

					if defValue >= 2 then
						diffuseValue=0.3;
					end;

					if defValue >= 5 then
						diffuseValue=0.4;
					end;

					if defValue >= 10 then
						diffuseValue=0.6;
					end;


					matrixFrame[#matrixFrame+1] = Def.Quad {
						InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.3);
						OnCommand=function(self)
							self:zoomto(35,18);
							self:x( (xPlaceSelected+1) + ( (x-1) * marginStats ) );
							self:y(yPlaceBase + (yBaseMargin * (i-1) ));
							self:diffuse(color(colorSelected));
							--self:blend("BlendMode_Add");
							self:fadeleft(0.25);
							self:faderight(0.25);
							self:diffusealpha(diffuseValue);
							self:blend("BlendMode_Add");
						end;
					};
			end;


			matrixFrame[#matrixFrame+1] = LoadFont("xolonium 20px")..{	
				OnCommand=function(self)
					self:zoom(0.5);					

					self:settext(defValue);
					self:x(xPlaceSelected + ( (x-1) * marginStats ));
					self:y(yPlaceBase + (yBaseMargin * (i-1) ));
					self:horizalign(center);
					if i <= 2 or defValue == 0 then
						self:diffusealpha(0.4);
					end;
					self:shadowlength(1);
					self:shadowcolor(color("#000000"));
				end;
				FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
			};
		end;
	end;


	for i=1,#matrixData["matrix"]["pf"] do
		
		--here we judg every col because why not.
		local maxScoreCol = 1000000;
		local maxNotesCol = 0;
		local maxPointsCol = 0;
		local actualPoints = 0;
		local actualScore = 0;
		local visibleSprite = true;

		local pf=matrixData["matrix"]["pf"][i];
		local gr=matrixData["matrix"]["gr"][i];
		local gd=matrixData["matrix"]["gd"][i];
		local bd=matrixData["matrix"]["bd"][i];
		local mss=matrixData["matrix"]["ms"][i];

		maxNotesCol = pf + gr + gd + bd + mss;
		if maxNotesCol > 0 then

			--p=3, g=2 , gd = 1 , bad = 0
			maxPointsCol = maxNotesCol * 3;
			actualPoints = pf*3 + gr*2 + gd*1;

			if actualPoints == maxPointsCol then
				actualScore = 1000000;
			else
				actualScore = actualPoints / maxPointsCol * 1000000;		
			end;
			local stateForGrade = gradeTransformState(actualScore);
			

			-- grade per col
			matrixFrame[#matrixFrame+1] = LoadActor(THEME:GetPathG("","ScreenEvaluation/information/gradeGameplay 1x17"))..{
			Name="gradeCol";
			OnCommand=function(self)
				self:y(75);
				self:x(xPlaceSelected + ( (i-1) * marginStats ));
				self:diffusealpha(1);
				self:zoom(0.45);
				self:animate(false);
				self:setstate(stateForGrade);
				self:visible(visibleSprite);
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.02;diffusealpha,0);
			};

		end;


	end;

	--:::::::::::::::::::::--
	-- CREATE THE ACTOR FRAME
	--:::::::::::::::::::::--

	--:::::::::::::::::::::::::::::--
	--           ACTOR
	--:::::::::::::::::::::::::::::--
	local finalActor = Def.ActorFrame {
		OnCommand=function(self)
			self:zoom(1);
		end;
	    Def.Quad{
	      InitCommand=function(self)
	        self:zoomto(width-3, height+40):diffuse(0,0,0,0.65):diffusebottomedge(0,0,0,0.8):x(-2);
	      end
	    };
	};	

	--ADD JUDG
	finalActor[#finalActor+1] = judgments;
	--ADD ARROWS
	finalActor[#finalActor+1] = arrowsPlaces;
	--ADD STATS
	finalActor[#finalActor+1] = matrixFrame;

	return finalActor;

end;

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

		LoadActor(THEME:GetPathG("","ScreenEvaluation/information/title_gameplay"))..{
			OnCommand=function(self)
				self:y(yPlace-78);
				self:x(xPlace+placesBarOptionInfo[4]);
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
		--Gameplay
		getGameplayCard(PLAYER)..{
			OnCommand=function(self)
			self:y(yPlace+10);
			self:x(xPlace+28);
			self:zoom(0.8);
			cardActorGameplayList[PLAYER] = self;
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