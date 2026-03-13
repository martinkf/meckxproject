if GAMESTATE:Env()["saninet_roomsize_game"] == nil then
	GAMESTATE:Env()["saninet_roomsize_game"] = 0;
end; 

function assignSaninetRoomSizeGame(roomSize)
	local size = 0;
	if roomSize ~= nil then 
		size = roomSize;
	end;
	GAMESTATE:Env()["saninet_roomsize_game"] = size;
	Trace("############################## :: THE ROOM SIZE OF THIS GAME:"..GAMESTATE:Env()["saninet_roomsize_game"]);
end;

function checkRoomSize()
	return GAMESTATE:Env()["saninet_roomsize_game"];
end;

if GAMESTATE:Env()["myPosOnRoom"] == nil then
	GAMESTATE:Env()["myPosOnRoom"] = -1;
end; 

function assignSaninetMyPosOnRoom(pos)
	local myPos = -1;
	if pos ~= nil then 
		myPos = pos;
	end;
	GAMESTATE:Env()["myPosOnRoom"] = myPos;
	Trace("############################## :: MY POSITION IN THIS ROOM IS :"..GAMESTATE:Env()["myPosOnRoom"]);
end;

local firstActionOcurred = false;

-- COMBO (only for 1v1)
local mcomboYoffset = 110;
local isVisibleMpCombo=false;
local myPosOnRoomMcombo=-1;
local singlePlayRoom = false;

--INIT
local isCenteredPlay = false;
local isDoublePlay = false;
local is2PlayersPlay = false;


if PREFSMAN:GetPreference("Center1Player") then
    isCenteredPlay = true;
end

if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
	isDoublePlay = true;
end;

if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2)  then
	is2PlayersPlay = true;
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
		self:visible(false);
	end;
	SaniNetClientStateMessageCommand=function(self,params)
		--printInLogParamsData("header",params);
		if params.Username ~= '' then
			self:visible(true);

			if params["saninetConnectionId"] == GAMESTATE:Env()["ConnectionId"] then
				myPosOnRoomMcombo = params["Position"];
				assignSaninetMyPosOnRoom(myPosOnRoomMcombo); --we need the position on the room.
				assignSaninetRoomSizeGame(params["PartyCount"]);				
			end;
		end;
	end;
};

--###########################--
--GLOBAL STATUS.
--###########################--

local isReadyPlayer = {false,false,false,false,false,false,false,false};




--###########################--
--COMBO 1V1. : COMBO OF THE RIVAL BELOW OUR COMBO
--###########################--
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
			self:zoom(1.2);

			if GAMESTATE:IsSideJoined(PLAYER_1) then
				if isDoublePlay == false and isCenteredPlay == false then
					self:x(SCREEN_CENTER_X-242);
					self:y(SCREEN_CENTER_Y+mcomboYoffset);
				elseif isDoublePlay == true or isCenteredPlay == true then
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y+mcomboYoffset);
				end;
			end;

			if GAMESTATE:IsSideJoined(PLAYER_2) then
				if isDoublePlay == false and isCenteredPlay == false then
					self:x(SCREEN_CENTER_X+242);
					self:y(SCREEN_CENTER_Y+mcomboYoffset);
				elseif isDoublePlay == true or isCenteredPlay == true then
					self:x(SCREEN_CENTER_X);
					self:y(SCREEN_CENTER_Y+mcomboYoffset);
				end;
			end;

			self:diffusealpha(1);
	end;

	SaniNetClientStateMessageCommand=function(self,params)

		if params["ConnectionId"] == GAMESTATE:Env()["saninetConnectionId"] then
			myPosOnRoomMcombo = params["Position"];
			assignSaninetMyPosOnRoom(myPosOnRoomMcombo); --we need the position on the room.				
		end;

		if params["PartyCount"] == 2 then
			self:visible(false);
			isVisibleMpCombo = true;
		else
			self:visible(false);
		end;
	end;

	LoadFont('_mpcombo')..
	{
		Name="mcombo";
		OnCommand=function(self)			
			self:zoom(1):horizalign(center);
			self:settext("");
		end;
	};	

	SaniNetStatsMessageCommand=function(self,params)
		if isVisibleMpCombo then
			if myPosOnRoomMcombo ~= params.Position then
				self:visible(true);

				if firstActionOcurred == false then
					--this prevent the bug when the game resend at the start the last message sended :s
					--showing the max combo of the last gameplay, we don't want that.
					firstActionOcurred = true;
					self:GetChild("mcombo"):settext("000"):zoom(1);
					return;
				end;


				if params["Combo"] > 0 then
					local comboInit = "00";
					if params["Combo"] > 9 and params["Combo"] < 100 then
						comboInit = "0";
					elseif params["Combo"] >= 100 then
						comboInit = "";
					end;	
					local comboText = comboInit..params["Combo"];
					Trace("#### Combo Text:"..comboText);

					self:GetChild("mcombo"):settext(comboText):stoptweening():zoom(1.15):linear(0.2):zoom(1);
				else
					self:GetChild("mcombo"):settext("000"):zoom(1);
				end;



			else

			end;

		end;
	end;

};





--###########################--
--1 PLAYER NO CENTER. SCOREBOARD
--###########################--

local playerDataNoCenter = {};
local positionDataPlayersNoCenter = {};

if isCenteredPlay == false and isDoublePlay == false and is2PlayersPlay == false then

	local posXBaseItems = SCREEN_CENTER_X;
	local posYBaseItems = SCREEN_CENTER_Y-120;

	if GAMESTATE:IsSideJoined(PLAYER_1) then
		posXBaseItems = posXBaseItems + 330;
	else
		posXBaseItems = posXBaseItems - 330;
	end;

	--Base Sprites
	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)
			self:x(posXBaseItems);
			self:y(posYBaseItems);
		end;

		LoadActor(THEME:GetPathG("","SaniNet/pbox/4vsBase"))..{
			Name="4vsBase";
			OnCommand=function(self)
				self:zoom(0.6);
			end;
		};

		LoadActor(THEME:GetPathG("","SaniNet/pbox/gp_combo"))..{
			Name="gp_combo";
			OnCommand=function(self)
				self:zoom(0.32);
				self:x(204);
				self:y(-56);
			end;
		};

		SaniNetClientStateMessageCommand=function(self,params)
			local roomSize = 0;
			if params["PartyCount"] ~= nil then
				roomSize = params["PartyCount"];
			end;

			if roomSize == 0 then
				self:visible(false);
				return;
			end;

		end;
	};


	-- we create te position beforehand so we can switch the items when we want
	local playerItemMargin = 30; 
	for i=1,4 do
		positionDataPlayersNoCenter[i] = {x=posXBaseItems,y=(posYBaseItems - 30) + (playerItemMargin * (i-1))};
	end;

	-- 4 slots for players, can be more.
	for i=1,4 do			
		local yPlacementNumbers=-1;
		t[#t+1] = Def.ActorFrame{

			OnCommand=function(self)
				self:x(posXBaseItems);
				self:y(positionDataPlayersNoCenter[i]["y"]);
				self:visible(false);
				playerDataNoCenter[i] = self;
			end;

			SaniNetStatsMessageCommand=function(self,params)
				if (i - 1) == params.Position then

					if checkRoomSize() == 0 then
						self:visible(false);
						return;
					end;

					self:visible(true);
					if isReadyPlayer[i] == false then
						self:GetChild("playerName"):settext(params.Username);
						isReadyPlayer[i] = true;
					end;

					self:GetChild("perfect"):settext(params["Perfect"]);
					self:GetChild("great"):settext(params["Great"]);
					self:GetChild("good"):settext(params["Good"]);
					self:GetChild("bad"):settext(params["Bad"]);
					self:GetChild("miss"):settext(params["Miss"]);


					local comboInit = "00";
					if params["Combo"] > 9 and params["Combo"] < 100 then
						comboInit = "0";
					elseif params["Combo"] >= 100 then
						comboInit = "";
					end;	

					if params["Combo"] > 0 then
						self:GetChild("combo"):stoptweening():settext(comboInit..params["Combo"]):linear(0.025):zoom(1):linear(0.015):zoom(0.85);
					else
						self:GetChild("combo"):stoptweening():zoom(0.85):settext(comboInit..params["Combo"]);
					end;

					--things
					if params["Perfect"] > 0 and params["Great"] == 0 and params["Good"] == 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("pfg"):visible(true);
						self:GetChild("fc"):visible(false);
					elseif params["Perfect"] > 0 and params["Great"] >=0 and params["Good"] >= 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("fc"):visible(true);
						self:GetChild("pfg"):visible(false);
					else
						self:GetChild("fc"):visible(false);
						self:GetChild("pfg"):visible(false);
					end;

				end;
			end;

			Def.Quad{
				OnCommand=function(self)
					self:zoomto(520,25);
					self:diffuse(color("#000000"));
					self:diffusealpha(0.5);
				end;
			};

			LoadFont('_XoloPlayer')..
			{
				Name="playerName";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(left):uppercase(true):x(-252):y(yPlacementNumbers);
					self:settext("-");
				end;

			};	

			LoadFont('_arial black')..
			{
				Name="perfect";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(-123):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="great";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(-61):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="good";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(1):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="bad";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(62):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="miss";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(124):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="combo";
				OnCommand=function(self)			
					self:zoom(0.85):horizalign(center):uppercase(true):x(202):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_pfg"))..{
				Name="pfg";
				OnCommand=function(self)
					self:zoom(0.6);
					self:x(-260);
					self:y(-4);
					self:rotationz(270);
					self:visible(false);
				end;
			};

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_fullcombo"))..{
				Name="fc";
				OnCommand=function(self)
					self:zoom(0.5);
					self:x(-260);
					self:y(-4);
					self:rotationz(270);
					self:visible(false);
				end;
			};

		};
	end;
end;

--###########################--
--1 PLAYER CENTER.
--###########################--


local playerDataCenter = {};
local positionDataPlayersCenter = {};
local zoomBaseCenter =0.7;

if isCenteredPlay == true and isDoublePlay == false and is2PlayersPlay == false then

	local posXBaseItems = SCREEN_CENTER_X;
	local posYBaseItems = SCREEN_CENTER_Y-240;

	if GAMESTATE:IsSideJoined(PLAYER_1) then
		posXBaseItems = posXBaseItems + 420;
	else
		posXBaseItems = posXBaseItems - 420;
	end;

	--Base Sprites
	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)
			self:x(posXBaseItems);
			self:y(posYBaseItems);
			self:zoom(zoomBaseCenter);
		end;

		LoadActor(THEME:GetPathG("","SaniNet/pbox/4vsBase"))..{
			Name="4vsBase";
			OnCommand=function(self)
				self:zoom(0.6);
			end;
		};

		LoadActor(THEME:GetPathG("","SaniNet/pbox/gp_combo"))..{
			Name="gp_combo";
			OnCommand=function(self)
				self:zoom(0.32);
				self:x(204);
				self:y(-56);
			end;
		};

		SaniNetClientStateMessageCommand=function(self,params)

			local roomSize = 0;
			if params["PartyCount"] ~= nil then
				roomSize = params["PartyCount"];
			end;

			if roomSize == 0 then
				self:visible(false);
				return;
			end;
		end;
	};


	-- we create te position beforehand so we can switch the items when we want
	local playerItemMargin = 20; 
	for i=1,4 do
		positionDataPlayersCenter[i] = {x=posXBaseItems,y=(posYBaseItems - 20) + (playerItemMargin * (i-1))};
	end;

	-- 4 slots for players, can be more.
	for i=1,4 do			
		local yPlacementNumbers=-1;
		t[#t+1] = Def.ActorFrame{

			OnCommand=function(self)
				self:x(posXBaseItems);
				self:y(positionDataPlayersCenter[i]["y"]);
				self:visible(false);
				playerDataCenter[i] = self;
				self:zoom(zoomBaseCenter);
			end;

			SaniNetClientStateMessageCommand=function(self,params)

				local roomSize = 0;
				if params["PartyCount"] ~= nil then
					roomSize = params["PartyCount"];
				end;

				if roomSize == 0 then
					self:visible(false);
					return;
				end;
			end;

			SaniNetStatsMessageCommand=function(self,params)
				if (i - 1) == params.Position then

					if checkRoomSize() == 0 then
						self:visible(false);
						return;
					end;

					self:visible(true);
					if isReadyPlayer[i] == false then
						self:GetChild("playerName"):settext(params.Username);
						isReadyPlayer[i] = true;
					end;

					self:GetChild("perfect"):settext(params["Perfect"]);
					self:GetChild("great"):settext(params["Great"]);
					self:GetChild("good"):settext(params["Good"]);
					self:GetChild("bad"):settext(params["Bad"]);
					self:GetChild("miss"):settext(params["Miss"]);


					local comboInit = "00";
					if params["Combo"] > 9 and params["Combo"] < 100 then
						comboInit = "0";
					elseif params["Combo"] >= 100 then
						comboInit = "";
					end;	

					if params["Combo"] > 0 then
						self:GetChild("combo"):stoptweening():settext(comboInit..params["Combo"]):linear(0.025):zoom(1):linear(0.015):zoom(0.85);
					else
						self:GetChild("combo"):stoptweening():zoom(0.85):settext(comboInit..params["Combo"]);
					end;

					--things
					if params["Perfect"] > 0 and params["Great"] == 0 and params["Good"] == 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("pfg"):visible(true);
						self:GetChild("fc"):visible(false);
					elseif params["Perfect"] > 0 and params["Great"] >=0 and params["Good"] >= 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("fc"):visible(true);
						self:GetChild("pfg"):visible(false);
					else
						self:GetChild("fc"):visible(false);
						self:GetChild("pfg"):visible(false);
					end;

				end;
			end;

			Def.Quad{
				OnCommand=function(self)
					self:zoomto(520,25);
					self:diffuse(color("#000000"));
					self:diffusealpha(0.5);
				end;
			};

			LoadFont('_XoloPlayer')..
			{
				Name="playerName";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(left):uppercase(true):x(-252):y(yPlacementNumbers);
					self:settext("-");
				end;

			};	

			LoadFont('_arial black')..
			{
				Name="perfect";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(-123):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="great";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(-61):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="good";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(1):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="bad";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(62):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="miss";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(124):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadFont('_arial black')..
			{
				Name="combo";
				OnCommand=function(self)			
					self:zoom(0.85):horizalign(center):uppercase(true):x(202):y(yPlacementNumbers);
					self:settext("-");
				end;
			};	

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_pfg"))..{
				Name="pfg";
				OnCommand=function(self)
					self:zoom(0.6);
					self:x(-260);
					self:y(-4);
					self:rotationz(270);
					self:visible(false);
				end;
			};

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_fullcombo"))..{
				Name="fc";
				OnCommand=function(self)
					self:zoom(0.5);
					self:x(-260);
					self:y(-4);
					self:rotationz(270);
					self:visible(false);
				end;
			};

		};
	end;
end;


--###########################--
--1 PLAYER DOUBLE.
--###########################--
local playerDataDouble = {};
local positionDataPlayersDouble = {};
local zoomBaseDouble = 1;
local sizeBarsTns=38;
if isDoublePlay == true then

	local posXBaseItems = SCREEN_CENTER_X;
	local posYBaseItems = SCREEN_CENTER_Y-235;



	if GAMESTATE:IsSideJoined(PLAYER_1) then
		posXBaseItems = posXBaseItems + 565;
	else
		posXBaseItems = posXBaseItems - 565;
	end;

	--Base Sprites
	t[#t+1] = Def.ActorFrame{

		OnCommand=function(self)
			self:x(posXBaseItems);
			self:y(posYBaseItems);
			self:zoom(zoomBaseCenter);
		end;

		LoadActor(THEME:GetPathG("","SaniNet/pbox/double_scoreboard"))..{
			Name="baseScoreboard";
			OnCommand=function(self)
				self:zoom(0.8);
				self:y(-100);
				self:x(-10);
			end;
		};

		SaniNetClientStateMessageCommand=function(self,params)

			local roomSize = 0;
			if params["PartyCount"] ~= nil then
				roomSize = params["PartyCount"];
			end;

			if roomSize == 0 then
				self:visible(false);
				return;
			end;
		end;
	};


	local playerItemMargin = 75; 
	for i=1,4 do
		positionDataPlayersDouble[i] = {x=posXBaseItems,y=(posYBaseItems - 30) + (playerItemMargin * (i-1))};
	end;




	for i=1,4 do

		t[#t+1] = Def.ActorFrame{

			OnCommand=function(self)
				self:x(posXBaseItems);
				self:y(positionDataPlayersDouble[i]["y"]);
				self:visible(false);
				playerDataDouble[i] = self;
				self:zoom(zoomBaseDouble);
			end;

			SaniNetClientStateMessageCommand=function(self,params)	

				local roomSize = 0;
				if params["PartyCount"] ~= nil then
					roomSize = params["PartyCount"];
				end;
				
				if roomSize == 0 then
					self:visible(false);
					return;
				end;
			end;


			SaniNetStatsMessageCommand=function(self,params)
				if (i - 1) == params.Position then

					if checkRoomSize() == 0 then
						self:visible(false);
						return;
					end;

					self:visible(true);
					if isReadyPlayer[i] == false then
						self:GetChild("playerName"):settext(params.Username);
						isReadyPlayer[i] = true;
					end;

					local comboInit = "00";
					if params["Combo"] > 9 and params["Combo"] < 100 then
						comboInit = "0";
					elseif params["Combo"] >= 100 then
						comboInit = "";
					end;	

					--bars::
					local totalNotes = params["Perfect"] + params["Great"] + params["Good"] + params["Bad"] + params["Miss"];

					if params["Perfect"] > 0 then
						local pfPercent = params["Perfect"] * 100 / totalNotes ;
						local resPf = 1 - (pfPercent / 100);
						self:GetChild("pfbar"):croptop(resPf);
					end;
					if params["Great"] > 0 then
						local grPercent = params["Great"] * 100 / totalNotes ;
						local resGr = 1 - (grPercent / 100);
						self:GetChild("grbar"):croptop(resGr);
					end;
					if params["Good"] > 0 then
						local gdPercent = params["Good"] * 100 / totalNotes ;
						local resGd = 1 - (gdPercent / 100);
						self:GetChild("gdbar"):croptop(resGd);
					end;
					if params["Bad"] > 0 then
						local bdPercent = params["Bad"] * 100 / totalNotes ;
						local resBd = 1 - (bdPercent / 100);
						self:GetChild("bdbar"):croptop(resBd);
					end;
					if params["Miss"] > 0 then
						local missPercent = params["Miss"] * 100 / totalNotes ;
						local resMiss = 1 - (missPercent / 100);
						self:GetChild("missbar"):croptop(resMiss);
					end;

					if params["Combo"] > 0 then
						self:GetChild("combo"):stoptweening():settext(comboInit..params["Combo"]):linear(0.025):zoom(1):linear(0.015):zoom(0.85);
					else
						self:GetChild("combo"):stoptweening():zoom(0.85):settext(comboInit..params["Combo"]);
					end;

					--things
					if params["Perfect"] > 0 and params["Great"] == 0 and params["Good"] == 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("pfg"):visible(true);
						self:GetChild("fc"):visible(false);
					elseif params["Perfect"] > 0 and params["Great"] >=0 and params["Good"] >= 0 and params["Bad"] == 0 and params["Miss"] == 0 then
						self:GetChild("fc"):visible(true);
						self:GetChild("pfg"):visible(false);
					else
						self:GetChild("fc"):visible(false);
						self:GetChild("pfg"):visible(false);
					end;

				end;
			end;


			LoadActor(THEME:GetPathG("","SaniNet/pbox/double_base"))..{
				Name="baseRecordDouble";
				OnCommand=function(self)
					self:zoom(0.6);
					self:x(0);
					self:y(0);
				end;
			};


			LoadFont('_XoloPlayer')..
			{
				Name="playerName";
				OnCommand=function(self)			
					self:zoom(0.7):horizalign(center):uppercase(true):x(0):y(-20);
					self:settext("-");
				end;

			};				


			LoadActor(THEME:GetPathG("","SaniNet/pbox/gp_combo"))..{
				Name="4vsBase";
				OnCommand=function(self)
					self:zoom(0.32);
					self:x(0);
					self:y(0);
				end;
			};


			Def.Quad{
				Name="pfbar";
				OnCommand=function(self)
					self:zoomto(3,38);
					self:x(45);
					self:y(13);
					self:diffuse(color("#1FF2FF"));
					self:diffusealpha(1);
					self:croptop(1);
				end;
			};
			Def.Quad{
				Name="grbar";
				OnCommand=function(self)
					self:zoomto(3,38);
					self:x(49);
					self:y(13);
					self:diffuse(color("#1FFF26"));
					self:diffusealpha(1);
					self:croptop(1);
				end;
			};
			Def.Quad{
				Name="gdbar";
				OnCommand=function(self)
					self:zoomto(3,38);
					self:x(53);
					self:y(13);
					self:diffuse(color("#F4FF1F"));
					self:diffusealpha(1);
					self:croptop(1);
				end;
			};



			Def.Quad{
				Name="bdbar";
				OnCommand=function(self)
					self:zoomto(3,38);
					self:x(57);
					self:y(13);
					self:diffuse(color("#FF1FFB"));
					self:diffusealpha(1);
					self:croptop(1);
				end;
			};


			Def.Quad{
				Name="missbar";
				OnCommand=function(self)
					self:zoomto(3,38);
					self:x(61);
					self:y(13);
					self:diffuse(color("#FF1F1F"));
					self:diffusealpha(1);
					self:croptop(1);
				end;
			};
			LoadFont('_arial black')..
			{
				Name="combo";
				OnCommand=function(self)			
					self:zoom(0.85):horizalign(center):uppercase(true):x(0):y(18);
					self:settext("000");
				end;
			};

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_pfg"))..{
				Name="pfg";
				OnCommand=function(self)
					self:zoom(0.7);
					self:x(60);
					self:y(-28);
					self:visible(false);
				end;
			};

			LoadActor(THEME:GetPathG("","SaniNet/pbox/selector_fullcombo"))..{
				Name="fc";
				OnCommand=function(self)
					self:zoom(0.5);
					self:x(60);
					self:y(-28);

					self:visible(false);
				end;
			};


		};		

	end;




end;

--###########################--
--2 PLAYERS.
--###########################--




return t;