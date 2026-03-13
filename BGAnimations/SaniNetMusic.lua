--[[
	shitty thing but meanwhile is how ill fix this xD 
]]

local userIsDisconected = false;
local actualRoomSize = 0;

local saninetConnectionIdProcessed = false;
if GAMESTATE:Env()["saninetConnectionId"] == nil then
	GAMESTATE:Env()["saninetConnectionId"] = "";
end; 

if GAMESTATE:Env()["saninetUsername"] == nil then
	GAMESTATE:Env()["saninetUsername"] = "";
end; 

if saninetConnectionIdProcessed == false and #GAMESTATE:Env()["saninetConnectionId"] > 0 then
	saninetConnectionIdProcessed = true;
end;

function assignSaninetUsername(name)
	GAMESTATE:Env()["saninetUsername"] = name;
end;


function assignSaninetConnectionIdToGame(id)
	if saninetConnectionIdProcessed == false and #GAMESTATE:Env()["saninetConnectionId"] == 0 then
		GAMESTATE:Env()["saninetConnectionId"] = id;
	end;	
end;

function isMySanityID(id)	
	if id == GAMESTATE:Env()["saninetConnectionId"] then
		return true
	end;
	return false;
end;

function showMySaninetId()
	Trace(":::::: ASSIGNED SANINET CONNECTION ID: "..GAMESTATE:Env()["saninetConnectionId"]);
end;

local initResetTimes = 0;


local Message = {'', '', '', '', '', '', '', '' };
local maxChatTextRows = 7;
local myClientId="";
local colorSet = 
{
	single = color("#f50202"),
	double = color("#02f504"),
	singleperformance = color("#9808c0"),
	doubleperformance = color("#0e66b8"),
	halfdouble = color("#029c7d"),
	coop = color("#B45F04"),
	questdisable = color ("#1B5E20")
};

function getSongFolderFromBanner(path)
	local splitdata = {}
	for part in string.gmatch(path, "[^/]+") do
	    table.insert(splitdata, part)
	end
	return splitdata;
end;

-- X base where everything will be place.
local baseXPlayer = {400,-430};

--************************************************--
--** INIT
--************************************************--

local t = Def.ActorFrame{
	
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- SANINET
	OnCommand=function(self)
		self:visible(false);
	end;
	SaniNetClientStateMessageCommand=function(self,params)
		assignSaninetConnectionIdToGame(params["ConnectionId"]);
		assignSaninetUsername(params["Username"]);

		if #params["Username"] > 0 then
			MESSAGEMAN:Broadcast("ChangeOnlineNameProfile", {
			    name = params["Username"]
			});
		end;

		showMySaninetId();

		if params.Username ~= '' then
			self:visible(true);	
			MESSAGEMAN:Broadcast("ChangeOnlineNameProfile", {
			    name = params["Username"]
			});
		end;
	end;


	Def.Quad{
		-- self:finishtweening():diffuse(color('1,1,1,0.5')):linear(0.125):diffuse(color('0,0,0,0.75'));
		OnCommand=cmd(xy,0,0;setsize,1,1);
		SaniNetMessageMessageCommand=function(self,params)
			if params.Status == 1 then
				table.insert(Message, 1, '[#'..params.Username..'] '..params.Message);
			elseif params.Status == 11 then
				table.insert(Message, 1, '('..params.Username..') You are the new room master');
			elseif params.Status == 12 then
				table.insert(Message, 1, '('..params.Username..') Please go back to "Select Music"');
			end;
			if #Message > 8 then
				table.remove(Message, 9);
			end;
			MESSAGEMAN:Broadcast("MessageUpdate");
		end;
		SaniNetClientStateMessageCommand=function(self,params)
			if params.Room ~= nil then
				table.insert(Message, 1, '('..params.Username..') Joined to room ('..params.Room..')');
			end;
			MESSAGEMAN:Broadcast("MessageUpdate");
		end;
		SaniNetRoomMessageCommand=function(self,params)
			--printInLogParamsData("msgParams",params);
			if params.Action == 0 then
				Message = {'', '', '', '', '', '', '', '' };
				table.insert(Message, 1, '('..params.Username..') Created the room ('..params.Room..')');
			elseif params.Action == 1 then

				if isMySanityID(params["ConnectionId"]) then
					Message = {'', '', '', '', '', '', '', '' };	
				end;		

				table.insert(Message, 1, '('..params.Username..') Joined to room ('..params.Room..')');
			elseif params.Action == 2 or params.Action == 3 then
				--Message = {'', '', '', '', '', '', '', '' };
				table.insert(Message, 1, '('..params.Username..') Left the room ('..params.Room..')');
			elseif params.Action == 11 then
				table.insert(Message, 1, '('..params.Username..') Already in room ('..params.Room..')');
			elseif params.Action == 12 then
				table.insert(Message, 1, '('..params.Username..') Room does not exists ('..params.Room..')');
			end;
			
			if #Message > 8 then
				table.remove(Message, 9);
			end;
			
			MESSAGEMAN:Broadcast("MessageUpdate");
		end;
	};
};

--************************************************--
--** NO ROOM
--************************************************--
--asset when there is no room but you are connected.
--event mode lang
local eventmodelang = PREFSMAN:GetPreference('Language').."_eventmsg";
t[#t+1] =  Def.ActorFrame{
		OnCommand=function(self)

		local baseX=0;

		if GAMESTATE:IsSideJoined(PLAYER_1) then
			baseX = baseXPlayer[1];
		else
			baseX = baseXPlayer[2];
		end;		

		self:xy(baseX, SCREEN_CENTER_Y);

	end;


		SaniNetRoomMessageCommand=function(self,params)
			if params.Action == 0 or params.Action == 1 then

				self:visible(false);

			end;
			if params.Action == 2 or params.Action == 3 then

				local itsmy = isMySanityID(params["ConnectionId"]);
				if itsmy then
					self:visible(true);
				end;
				
			end;
		end;

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Room ~= nil then
				self:visible(false);
			else
				self:visible(true);
			end;
			
		end;

	LoadActor(THEME:GetPathG("","SaniNet/"..PREFSMAN:GetPreference('Language').."_infokeyroom"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-280);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/glownoroommsg"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:zoomy(0.45);
			self:y(-280);
			self:x(-274);
			self:blend("BlendMode_Add");
			self:diffusealpha(0);
			self:queuecommand("Ani");

			if not GAMESTATE:IsEventMode() then
				self:visible(false);
			else
				self:visible(true);
			end;

		end;
		AniCommand=function(self)
			self:accelerate(0.6);
			self:diffusealpha(0.6);
			self:decelerate(1);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/glownoroommsg"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:zoomy(0.45);
			self:y(-280);
			self:x(274);
			self:blend("BlendMode_Add");
			self:diffusealpha(0);
			self:queuecommand("Ani");

			if not GAMESTATE:IsEventMode() then
				self:visible(false);
			else
				self:visible(true);
			end;

		end;
		AniCommand=function(self)
			self:accelerate(0.6);
			self:diffusealpha(0.6);
			self:decelerate(1);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};


	LoadActor(THEME:GetPathG("","SaniNet/event_infokey"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-280);

			if not GAMESTATE:IsEventMode() then
				self:visible(true);
			else
				self:visible(false);
			end;

		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/"..eventmodelang))..
	{
		OnCommand=function(self,params)
			self:zoom(0.89);
			self:y(-250);

			if not GAMESTATE:IsEventMode() then
				self:visible(true);
			else
				self:visible(false);
			end;

		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

}

--************************************************--


--************************************************--
--** ROOM BASE ASSETS
--************************************************--
--we load de assets of the room

t[#t+1] =  Def.ActorFrame{

	OnCommand=function(self)

		local baseX=0;
		if GAMESTATE:IsSideJoined(PLAYER_1) then
			baseX = baseXPlayer[1];
		else
			baseX = baseXPlayer[2];
		end;		

		self:xy(baseX, SCREEN_CENTER_Y-5);

	end;

	SelectChannelMessageCommand=function(self)
		self:GetChild("backUserBase"):linear(0.1):diffusealpha(0.05);
		self:GetChild("chatBase"):linear(0.1):diffusealpha(0.2);
	end;

	ChannelChosenMessageCommand=function(self)
		self:GetChild("backUserBase"):linear(0.1):diffusealpha(1);
		self:GetChild("chatBase"):linear(0.1):diffusealpha(1);
	end;	

	SaniNetRoomMessageCommand=function(self,params)

		--Trace("#####################################################");
		--printInLogParamsData("SaniNetRoomMessageCommand",params);
		self:GetChild("usercount"):settext(params.PartyCount.."/"..params.RoomSize);

		if params["Action"] ~= 12 then
			self:GetChild("roomid"):settext(params.Room);
		end;

		if params.Action == 0 or params.Action == 1 then

			self:visible(true);

		end;
		if params.Action == 2 or params.Action == 3 then

			local itsmy = isMySanityID(params["ConnectionId"]);
			if itsmy then
				self:visible(false);
			end;
		end;

	end;

	SaniNetClientStateMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetClientStateMessageCommand",params);
		if params.Room ~= nil then
			if params["Action"] ~= 12 then
				self:GetChild("roomid"):settext(params.Room);
			end;
			self:GetChild("usercount"):settext(params.PartyCount.."/"..params.RoomSize);
			actualRoomSize = params.RoomSize;
			self:visible(true);
		else
			self:GetChild("roomid"):settext("");
			self:GetChild("usercount"):settext("");
			self:visible(false);

		end;
	end;

	SaniNetHostMessageMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetHostMessageMessageCommand",params);
	end;

	SaniNetSongInfoMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetSongInfoMessageCommand",params);
		if params["State"] == 0 then
			local numPRoom = 1;
			if params["PartyCount"] == nil or params["PartyCount"] == 0 then
				numPRoom = 1;
			else
				numPRoom = params["PartyCount"];
			end;
			local roomsize = 0;
			if params.RoomSize ~= nil then
				roomsize = params.RoomSize;
			end;
			self:GetChild("usercount"):settext(numPRoom.."/"..roomsize);
		end;
	end;

	LoadActor(THEME:GetPathG("","SaniNet/"..PREFSMAN:GetPreference('Language').."_headerbase"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-290);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/glowhbase"))..
	{
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-280);
			self:faderight(1);
			self:queuecommand("Ani");
		end;

		SaniNetHostMessageMessageCommand=function(self,params)

		end;

		AniCommand=function(self)
			self:linear(6);
			self:diffusealpha(0.8);
			self:faderight(1);
			self:linear(6);
			self:faderight(0);
			self:linear(6);
			self:fadeleft(1);
			self:linear(6);
			self:diffusealpha(0);
			self:fadeleft(0);
			self:queuecommand("Ani");
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
	};

	LoadActor(THEME:GetPathG("","SaniNet/backuser"))..
	{
		Name="backUserBase";
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-178);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};	

	LoadActor(THEME:GetPathG("","SaniNet/chatbase"))..
	{
		Name="chatBase";
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-22);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};	

	LoadFont('_open sans semibold')..
	{
		Name="roomid";
		OnCommand=function(self,params)
			self:y(-281):horizalign(left):zoom(0.7);
			self:x(-196);
		end;
	};

		LoadFont('_open sans semibold')..
	{
		Name="usercount";
		OnCommand=function(self,params)
			self:y(-281):horizalign(left):zoom(0.7);
			self:x(230);
			self:settext("0/4");
		end;
	};

};

--************************************************--
--** ROOM CHAT TEXT
--************************************************--
--we load de assets of the room
local spacingTextChat=15;
--Text Chat
for i = maxChatTextRows, 1, -1 do
	t[#t+1] = LoadFont('_open sans semibold')..
	{
		OnCommand=function(self,params)

			local baseX=0;
			if GAMESTATE:IsSideJoined(PLAYER_1) then
				baseX = 140;
			else
				baseX = -346*2;
			end;		

			self:xy(baseX, SCREEN_CENTER_Y);

			self:vertalign(bottom):xy(baseX, 391 - (spacingTextChat * i)):horizalign(left):zoom(0.5);
		end;
		MessageUpdateMessageCommand=function(self,params)
			if i == 1 then
				self:diffuse(color('1,1,0,1'));
			else
				self:diffuse(color('1,1,1,1'));
			end;
			self:settext(Message[i]);
		end;


		SaniNetRoomMessageCommand=function(self,params)
			if params.Action == 0 or params.Action == 1 then
				self:visible(true);
			end;
			if params.Action == 2 or params.Action == 3 then
				local itsmy = isMySanityID(params["ConnectionId"]);
				if itsmy then
					self:visible(false);
				end;
			end;
		end;

		SaniNetClientStateMessageCommand=function(self,params)
			if params.Room ~= nil then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;		

	};
end;

--************************************************--
--** ROOM PLAYER ASSETS
--************************************************--
--we load de assets of the room

--PLAYERS
local maxTextPpos=28;
local playersPlaceY=SCREEN_CENTER_Y-7;
local roomPlayersData = {};

--4 players 
local firstloadRoomPlayers = {3,3,3,3};
for i = 1, 4 do

t[#t+1] =  Def.ActorFrame{

	OnCommand=function(self)
		local baseX=0;

		if GAMESTATE:IsSideJoined(PLAYER_1) then
			baseX = baseXPlayer[1]+5;
		else
			baseX = baseXPlayer[2];
		end;

		if i <= 2 then
			local ctrli = i - 1 ;
			self:xy(baseX + (260*ctrli), playersPlaceY);
		elseif i <= 4 then
			local ctrli = i - 3 ;
			self:xy(baseX + (260*ctrli), playersPlaceY+74);
		elseif i <= 6 then
			local ctrli = i - 5 ;
			self:xy(baseX + (260*ctrli), playersPlaceY+(74*2));
		elseif i <= 8 then
			local ctrli = i - 7 ;
			self:xy(baseX + (260*ctrli), playersPlaceY+(74*3));
		end;

--[[
		if i < 3 then
			local ctrli = i - 1 ;
			self:xy(baseX + (260*ctrli), playersPlaceY);
		else
			local ctrli = i - 3 ;
			self:xy(baseX + (260*ctrli), playersPlaceY+74);
		end;
]]

		if i == 1 then
			self:GetChild("owner"):visible(true);
		else
			self:GetChild("owner"):visible(false);
		end;		
		self:GetChild("innerUserBase"):diffusealpha(0.3);

		self:GetChild("songname"):settext("");
		self:GetChild("artist"):settext("");
		self:GetChild("folder"):settext("");
		self:GetChild("banner"):visible(false);
		self:GetChild("status"):visible(false);	
		self:GetChild("cusername"):settext("");
		self:GetChild("innerUserBase"):diffusealpha(0.3);

	end;

	SelectChannelMessageCommand=function(self)
		self:linear(0.1):diffusealpha(0.25);
	end;

	ChannelChosenMessageCommand=function(self)
		self:linear(0.1):diffusealpha(1);
	end;		

	SaniNetSongInfoMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetSongInfoMessageCommand :: i->"..i,params);
		if (i - 1) == params.Position then
			--Trace("### PARTY COUNT : "..params.PartyCount);
			firstloadRoomPlayers[i] = 3;
			self:GetChild("noSongText"):visible(false);
			self:GetChild("songNotAvailable"):visible(false);
			self:GetChild("innerUserBase"):diffusealpha(1);
			self:GetChild("cusername"):settext(string.upper(params.Username));

			local songNameProc = string.sub(params.SongTitle, 1, math.min(#params.SongTitle, maxTextPpos))
			if #params.SongTitle > maxTextPpos then songNameProc = songNameProc.."..."; end;
			self:GetChild("songname"):settext(songNameProc);

			local artistProc = string.sub(params.SongArtist, 1, math.min(#params.SongArtist, 35))
			if #params.SongArtist > maxTextPpos-3 then artistProc = artistProc.."..."; end;
			self:GetChild("artist"):settext(artistProc);				

			local pathSongFolder = getSongFolderFromBanner(params.SongBanner);
			self:GetChild("folder"):settext("/"..pathSongFolder[2]);

			--banner
			if params.Step ~= nil then
				if (i - 1) == params.Position then
					local banner = params.SongBanner;
					if FILEMAN:DoesFileExist(banner) then
						-- Trace("EXIST");
						self:GetChild("banner"):LoadFromCachedBanner( banner ):setsize(84,56):visible(true);
					end;
				end;
			end;	

			--status
			self:GetChild("status"):setstate(params.State):visible(true);
			if params.State == 2 then
				self:GetChild("innerUserReady"):visible(true);			
			else			
				self:GetChild("innerUserReady"):visible(false);
			end;
		end;

		if params.PartyCount == nil or i > params.PartyCount then
			self:GetChild("songname"):settext("");
			self:GetChild("artist"):settext("");
			self:GetChild("folder"):settext("");
			self:GetChild("banner"):visible(false);
			self:GetChild("status"):visible(false);	
			self:GetChild("cusername"):settext("");
			self:GetChild("innerUserBase"):diffusealpha(0.3); 
			self:GetChild("innerUserReady"):visible(false);
			self:GetChild("lvsm"):settext("");
			self:GetChild("lvbsm"):settext("");
		end;


	end;

	SaniNetSongInfoEmptyMessageCommand=function(self,params)
			if (i - 1) == params.Position then
				--printInLogParamsData("SaniNetSongInfoEmptyMessageCommand :: i->"..i,params);
					if i <= params.PartyCount then
						self:GetChild("cusername"):settext(string.upper(params["Username"]));
						self:GetChild("songname"):settext("");
						self:GetChild("noSongText"):visible(true);
						self:GetChild("songNotAvailable"):visible(true);					
						self:GetChild("artist"):settext("");
						self:GetChild("folder"):settext("");

					else 
						self:GetChild("songname"):settext("");
						self:GetChild("artist"):settext("");
						self:GetChild("folder"):settext("");
					end;
					self:GetChild("banner"):visible(false);
					self:GetChild("status"):visible(true);	
			end;
	end;

	SaniNetStepInfoMessageCommand=function(self,params)
		if (i - 1) == params.Position then
				self:GetChild("status"):setstate(params.State):visible(true);
		end;
	end;


	SaniNetSongCanceledMessageCommand=function(self,params)
		if (i - 1) == params.Position then
			self:GetChild("status"):setstate(params.State):visible(true);
		end;
	end;

	SaniNetPlayerReadyMessageCommand=function(self,params)

		if i > actualRoomSize then
			return;
		end;

		--if (i - 1) == params.Position then
			-- if params.State >= 2 then
				-- self:setstate(4):visible(true);
			-- else
				self:GetChild("status"):setstate(params.State):visible(true);
			-- end;
			
			if params.AllMatch then
				if not params.AllReady then
					table.insert(Message, 1, '('..params.Username..') All player must be in Confirm Steps state');
					self:GetChild("status"):setstate(1);
					self:GetChild("innerUserReady"):visible(false);
				end;
			else
				table.insert(Message, 1, '('..params.Username..') Song/Step must match for all the players in room');
				self:GetChild("status"):setstate(1);
				self:GetChild("innerUserReady"):visible(false);		
			end;
			--mensaje del chat.
			if #Message > maxChatTextRows then
				table.remove(Message, 8);
			end;
			MESSAGEMAN:Broadcast("MessageUpdate");
		--end;
	end;	

	SaniNetRoomMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetRoomMessageCommand :: i->"..i,params);
		local itsmy = isMySanityID(params["ConnectionId"]);

		if params.Action == 0 or params.Action == 1 then
			self:visible(true);
		end;
			
		-- Trace('the action '..params.Action);
		--LEAVE THE ROOM
		--HERE WE CLEAR THE PLAYER SLOT
		if params.Action == 3 then
			self:GetChild("songname"):settext("");
			self:GetChild("artist"):settext("");
			self:GetChild("folder"):settext("");
			self:GetChild("banner"):visible(false);
			self:GetChild("status"):visible(false);	
			self:GetChild("cusername"):settext("");
			self:GetChild("innerUserBase"):diffusealpha(0.3);
			self:GetChild("innerUserReady"):visible(false);
			self:visible(false);
		elseif params.Action == 2 then
			if (i - 1) == params.Position then
				self:GetChild("songname"):settext("");
				self:GetChild("artist"):settext("");
				self:GetChild("folder"):settext("");
				self:GetChild("banner"):visible(false);
				self:GetChild("status"):visible(false);	
				self:GetChild("cusername"):settext("");
				self:GetChild("innerUserBase"):diffusealpha(0.3);
				self:GetChild("innerUserReady"):visible(false);
			end;

			--we need to know if iam leaving, if not, we don't do anything.
			if itsmy then
				self:visible(false);
			end;			
		
		end;
	end;



	SaniNetClientStateMessageCommand=function(self,params)
		--printInLogParamsData("SaniNetRoomMessageCommand :: i->"..i,params);
		if (i - 1) == params.Position then
			self:GetChild("cusername"):settext(string.upper(params.Username));
		end;

		if params.Room ~= nil then
			self:visible(true);
		else
			self:visible(false);
			return;
		end;

		if i <= params.PartyCount then
				self:GetChild("songname"):settext("Loading");
				self:GetChild("artist"):settext("Loading");
				self:GetChild("folder"):settext("Loading");
		end;
	end;


	LoadActor(THEME:GetPathG("","SaniNet/innseruser"))..
	{
		Name="innerUserBase";
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-210);
			self:x(-135);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/readyinnseruser"))..
	{
		Name="innerUserReady";
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-210);
			self:x(-135);
			self:blend("BlendMode_Add");
			self:visible(false);
		end;
	};		

	--client username
	LoadFont('_open sans semibold')..
	{
		Name="cusername";
		OnCommand=function(self,params)
			self:x(-163):y(-233):horizalign(left):zoom(0.6);
		end;
	};
	--
	LoadFont('_open sans semibold')..
	{
		Name="noSongText";
		OnCommand=function(self,params)
			self:x(-163):y(-208):horizalign(left):zoom(0.42):visible(false);
			self:settext("This player selected a song\nyou don't have installed.");
		end;
	};

	--Song name
	LoadFont('_open sans semibold')..
	{
		Name="songname";
		OnCommand=function(self,params)
			self:x(-163):y(-219):horizalign(left):zoom(0.42);
		end;
	};

	--Artist
	LoadFont('_open sans semibold')..
	{
		Name="artist";
		OnCommand=function(self,params)
			self:x(-163):y(-208):horizalign(left):zoom(0.3);
		end;
	};

	--Folder
	LoadFont('_open sans semibold')..
	{
		Name="folder";
		OnCommand=function(self,params)
			self:x(-163):y(-198):horizalign(left):zoom(0.3);
		end;
	};

	Def.Banner{
			Name="banner";
			OnCommand=function(self,params)
				self:x(-252):y(-210):horizalign(left):visible(false);
			end;
	};






	LoadActor(THEME:GetPathG("","SaniNet/statusClient 1x4"))..
	{
		Name="status";
		OnCommand=function(self,params)
			self:x(-14):y(-185):horizalign(right):zoom(0.35):animate(false):visible(false);
		end;
	};

	Def.Quad{
	    InitCommand=function(self)
	    	self:x(-185):y(-192);
	        self:zoomto(33, 20)         -- tamaño: 50x50
	            :diffuse(color("0,0,0,1"))  -- color negro (RGB)
	            :diffusealpha(0.8)
	    end
	};

	LoadActor(THEME:GetPathG("","SaniNet/songNotAvailable"))..
	{
		Name="songNotAvailable";
		OnCommand=function(self,params)
			self:zoom(0.7);
			self:y(-210);
			self:x(-210);
			self:visible(false);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/owner"))..
	{
		Name="owner";
		OnCommand=function(self,params)
			self:zoom(0.6);
			self:y(-240);
			self:x(-240);
		end;
		SaniNetHostMessageMessageCommand=function(self,params)

		end;
	};

	--step and level detail.
	LoadFont('_LevelSmall')..
	{
		Name="lvsm";
		OnCommand=function(self,params)
			self:x(-184):y(-192):zoom(0.45);
		end;
		SaniNetSongInfoMessageCommand=function(self,params)
			if params.Step ~= nil then
				if (i - 1) == params.Position then
					local meter = string.format("%02i", params.Step:GetMeter());
					if params.Step:GetPlayers() ~= 1 then
						meter = "x"..params.Step:GetPlayers();
					else
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						if params.Step:GetPlayers() ~= 1 then
							meter = "x"..params.Step:GetPlayers();
						end;
					end;
					self:settext(meter);
				end;

				if params.PartyCount == nil or i > params.PartyCount then
					self:settext("");
				end;

			end;
		end;
		SaniNetSongInfoEmptyMessageCommand=function(self,params)
			if (i - 1) == params.Position then
				self:settext('');
			end;
		end;
		SaniNetRoomMessageCommand=function(self,params)
			if params.Action == 3 then
				self:settext('');
			elseif params.Action == 2 then
				if (i - 1) == params.Position then
					self:settext('');
				end;
			end;
		end;
		SaniNetStepInfoMessageCommand=function(self,params)
			if params.Step ~= nil then
				if (i - 1) == params.Position then
					local meter = string.format("%02i", params.Step:GetMeter());
					if params.Step:GetPlayers() ~= 1 then
						meter = "x"..params.Step:GetPlayers();
					else
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						if params.Step:GetPlayers() ~= 1 then
							meter = "x"..params.Step:GetPlayers();
						end;
					end;
					self:settext(meter);
				end;
			end;
		end;
	};

	LoadFont('_LevelBorderSmall')..
	{
		Name="lvbsm";
		OnCommand=function(self,params)
			self:x(-184):y(-192):zoom(0.45);
		end;
		SaniNetSongInfoMessageCommand=function(self,params)
			if params.Step ~= nil then
				if (i - 1) == params.Position then
					if params.Step:GetPlayers() ~= 1 then
						self:diffuse(colorSet.coop);
					else
						if params.Step:GetStepsType() == 'StepsType_Pump_Single' then
							self:diffuse(colorSet.single);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Single_P' then
							self:diffuse(colorSet.singleperformance);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Halfdouble' then
							self:diffuse(colorSet.halfdouble);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Double' then
							self:diffuse(colorSet.double);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Double_P' then	
							self:diffuse(colorSet.doubleperformance);
						end;
					end;
				
					local meter = string.format("%02i", params.Step:GetMeter());
					if params.Step:GetPlayers() ~= 1 then
						meter = "x"..params.Step:GetPlayers();
					else
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						if params.Step:GetPlayers() ~= 1 then
							meter = "x"..params.Step:GetPlayers();
						end;
					end;
					self:settext(meter);

					if  i > params.PartyCount then
						self:settext("");
					end;
				end;
			end;
		end;

		SaniNetSongInfoEmptyMessageCommand=function(self,params)
			if (i - 1) == params.Position then
				self:settext('');
			end;
		end;
		SaniNetRoomMessageCommand=function(self,params)
			if params.Action == 3 then
				self:settext('');
			elseif params.Action == 2 then
				if (i - 1) == params.Position then
					self:settext('');
				end;
			end;
		end;
		
		SaniNetStepInfoMessageCommand=function(self,params)
			if params.Step ~= nil then
				if (i - 1) == params.Position then
					if params.Step:GetPlayers() ~= 1 then
						self:diffuse(colorSet.coop);
					else
						if params.Step:GetStepsType() == 'StepsType_Pump_Single' then
							self:diffuse(colorSet.single);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Single_P' then
							self:diffuse(colorSet.singleperformance);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Halfdouble' then
							self:diffuse(colorSet.halfdouble);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Double' then
							self:diffuse(colorSet.double);
						elseif params.Step:GetStepsType() == 'StepsType_Pump_Double_P' then	
							self:diffuse(colorSet.doubleperformance);
						end;
					end;
					
					local meter = string.format("%02i", params.Step:GetMeter());
					if params.Step:GetPlayers() ~= 1 then
						meter = "x"..params.Step:GetPlayers();
					else
						if (meter == "49" or meter == "50" or meter == "99") then
							meter = "??";
						end;
						if meter == "51" then
							meter = "!!";
						end;
						if params.Step:GetPlayers() ~= 1 then
							meter = "x"..params.Step:GetPlayers();
						end;
					end;
					self:settext(meter);
				end;
			end;
		end;
	};


};

end;



local MainMenu=
{
	'Create Room',
	'Join Room'
};

function MenuCodeToString(code, room)
	if code == 0 then
		local text = getSaninetTextLang("room-create");
		return text;
	elseif code == 1 then
		local text = getSaninetTextLang("room-join-room");
		return text;
	elseif code == 2 then
		local text = getSaninetTextLang("room-join-public-room");
		return text;
	elseif code == 3 then
		local text = getSaninetTextLang("room-join-public-room");
		return text;
	elseif code == 4 then
		--return 'Leave Room('..room..')';
		local text = getSaninetTextLang("room-leave-room");
		return text;
	end;
end;

local menuSelected = 1;

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		self:visible(false);
	end;
	SaniNetMainMenuMessageCommand=function(self,params)
		if params.Action == 1 then
			self:visible(true);

			if params.RoomInfo == nil or #params.RoomInfo == 0 then
				self:GetChild("publicRooms1v1Bg"):visible(false);
				self:GetChild("publicRooms1v1BgText"):visible(false);
			end; 

		else
			self:visible(false);
		end;
	end;

	SaniNetMainMenuSelectMessageCommand=function(self,params)
		self:visible(false);
	end;

	Def.Quad{
		Name="bgCoverBlack";
		InitCommand=cmd(zoomto,2000,1200;diffuse,color("0,0,0,0.7");x,0;y,SCREEN_CENTER_Y+120);
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/bground"))..
	{
		Name="bground";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-42):visible(true):zoom(0.65);
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/menudots"))..
	{
		Name="bground";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-42):visible(true):zoom(0.65);
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/listBackground"))..
	{
		Name="bgoptions";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-20):visible(true):zoom(0.65);
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/keys"))..
	{
		Name="keys";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-82):visible(true):zoom(0.65);
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/text_room_close"))..
	{
		Name="keys";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y+50):visible(true):zoom(0.65);
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/menu/text_room_menu"))..
	{
		Name="title";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-105):visible(true):zoom(0.6);
		end;
	};

	
	--public rooms
	LoadActor(THEME:GetPathG("","SaniNet/menu/backroompublic2"))..
	{		
		Name="publicRooms1v1Bg";
		OnCommand=function(self,params)
			self:x(-500):y(SCREEN_CENTER_Y):visible(true):zoom(0.98);
		end;
	};

	LoadFont("_XoloPlayer")..{
		Name="publicRooms1v1BgText";
		OnCommand=cmd(zoom,0.9;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"PUBLIC ROOMS 1v1";y,SCREEN_CENTER_Y-210;x,-500);
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};
	


}


--WE MAKE THE 9 PUBLIC ROOM SPACES FOR 1V1

local xStartRow1v1=-705;
local xMarginRow1v1=205;

local yMarginCol1v1=130;
local yBaseRow1v1=SCREEN_CENTER_Y-135;

local indexLoop1v1 = 0;
local items1v1Info = {};

t[#t+1] = Def.ActorFrame {

		SaniNetMainMenuMessageCommand=function(self,params)

			if params.RoomInfo ~= nil then
				--Trace("########:::::::"..params.RoomInfo);

				if #params.RoomInfo == 0 then
					return;
				end;

				for i = 1,#params.RoomInfo do

					items1v1Info[i]:GetChild("NameRoom"):settext(params.RoomInfo[i]["roomName"]);
					items1v1Info[i]:GetChild("codeRoom"):settext("Room ID: "..params.RoomInfo[i]["id"]);
					items1v1Info[i]:GetChild("playeInRoom"):settext(params.RoomInfo[i]["clientsText"]);

					local playersName = split("|", params.RoomInfo[i]["players"]);

					for x=1,#playersName do
						--Trace("---------> PLAYER "..x..":"..playersName[x]);
						items1v1Info[i]:GetChild("playerpos"..x):settext(playersName[x]);
					end;

					items1v1Info[i]:visible(true);
				end;
			end;



		end;	

}


for i=1,9 do
	local tempXCol1v1 = 0;
	if i >= 1 and i < 4 then
		tempXCol1v1 = xStartRow1v1 + (xMarginRow1v1 * 0);
	end;

	if i >= 4  and i < 7 then
		tempXCol1v1 = xStartRow1v1 + (xMarginRow1v1 * 1);
	end;

	if i >= 7 then
		tempXCol1v1 = xStartRow1v1 + (xMarginRow1v1 * 2);
	end;	

	t[#t+1] = Def.ActorFrame {
		
		OnCommand=function(self)

			if indexLoop1v1 == 3 then
				indexLoop1v1 = 0;
			end;

			if indexLoop1v1 == 6 then
				indexLoop1v1 = 0;
			end;	

			self:x(tempXCol1v1);
			self:y(yBaseRow1v1 + ( yMarginCol1v1 * (indexLoop1v1) ));
			indexLoop1v1 = indexLoop1v1 +1;
			self:visible(false);
			table.insert(items1v1Info,self);

		end;

		SaniNetMainMenuMessageCommand=function(self,params)
			if params.Action == 1 then

				if params.RoomInfo == nil or #params.RoomInfo == 0 then
					return;
				end;

				self:visible(true);
			else
				self:visible(false);
			end;
		end;


		SaniNetRoomMessageCommand=function(self,params)

		end;

		LoadActor(THEME:GetPathG("","SaniNet/menu/roomdatapublic2"))..
		{
			Name="roomPlace";
			OnCommand=function(self,params)
				self:x(0):y(0):visible(true):zoom(1);
			end;

		};

		LoadFont("_XoloPlayer")..{
			Name="NameRoom";
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"";y,-45;x,0);
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadFont("_XoloPlayer")..{
			Name="codeRoom";
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"";y,-25;x,0);
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadFont("_XoloPlayer")..{
			Name="playeInRoom";
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"";y,43;x,0);
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};



		LoadFont("_XoloPlayer")..{
			Name="playerpos1";
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"";y,1);
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadFont("_XoloPlayer")..{
			Name="playerpos2";
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;settext,"";y,22);
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

	};

end;


--[[
for i=1,9 do

end;
]]




--###########--


for i=1,2 do
	t[#t+1] = Def.ActorFrame {
		--MENU
		Def.Quad{
			InitCommand=cmd(xy,0,SCREEN_CENTER_Y - 80 + 40 * i;setsize,300,40;diffuse,color('0,0,0,0'));
			SaniNetMainMenuMessageCommand=function(self,params)
				if params.Action == 1 then
					menuSelected = 1;
					if i == menuSelected then
						self:finishtweening():diffuse(color('1,1,1,0.75')):linear(0.125):diffuse(color('0.25,0.25,0.25,0.9'));
						
					else
						self:finishtweening():diffuse(color('1,1,1,0.75')):linear(0.125):diffuse(color('0,0,0,0.9'));
					end;
				else
					self:finishtweening():linear(0.125):diffuse(color('0,0,0,0'));
				end;
				
			end;
			SaniNetRoomCancelMessageCommand=function(self,params)
				self:finishtweening():linear(0.125):diffuse(color('0,0,0,0'));
			end;
			SaniNetMainMenuChangeMessageCommand=function(self,params)
				menuSelected = params.Index;
				if i == params.Index then
					self:finishtweening():diffuse(color('0.25,0.25,0.25,0.9'));
					
				else
					self:finishtweening():diffuse(color('0,0,0,0.95'));
				end;
			end;
			SaniNetMainMenuSelectMessageCommand=function(self,params)
				self:finishtweening():linear(0.125):diffuse(color('0,0,0,0'));
			end;
		};
		LoadFont('normalxolonium')..{
			InitCommand=cmd(xy,0,SCREEN_CENTER_Y - 89 + 42 * i;diffusealpha,0;vertalign,top;zoom,0.8);
			SaniNetMainMenuMessageCommand=function(self,params)				
				if params.Action == 1 then
					for i=1,#params.Status do
						MainMenu[i] = MenuCodeToString(params.Status[i], params.Room);
						-- Trace('menu :'..params.Status[i]);
					end;
					menuSelected = 1;
					self:settext(MainMenu[i]);
					if i == menuSelected then
						self:finishtweening():diffusealpha(1);
					else
						self:finishtweening():diffusealpha(0.25);
					end;
				else
					self:finishtweening():diffusealpha(0);
				end;
				
			end;
			-- SaniNetMainMenuCloseMessageCommand=function(self,params)
				-- self:finishtweening():diffusealpha(0);
			-- end;
			SaniNetRoomCancelMessageCommand=function(self,params)
				self:finishtweening():diffusealpha(0);
			end;
			SaniNetMainMenuChangeMessageCommand=function(self,params)
				-- menuSelected = params.Index;
				if i == params.Index then
					self:finishtweening():diffusealpha(1);
				else
					self:finishtweening():diffusealpha(0.25);
				end;
			end;
			SaniNetMainMenuSelectMessageCommand=function(self,params)
				self:finishtweening():diffusealpha(0);
			end;
		};
		--MENU
	};
end;


t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		self:visible(false);
	end;
	SaniNetMainMenuMessageCommand=function(self,params)
		if params.Action == 1 then
			self:GetChild("dots"):stoptweening():y(SCREEN_CENTER_Y-40):queuecommand("animate");
			self:visible(true);
		else
			self:visible(false);
		end;
	end;

	SaniNetMainMenuChangeMessageCommand=function(self,params)
		--Trace("#"..params.Index.."#"); 
		if params.Index == 1 then
			self:GetChild("dots"):stoptweening():y(SCREEN_CENTER_Y-40):queuecommand("animate");
		elseif params.Index == 2 then
			self:GetChild("dots"):stoptweening():y(SCREEN_CENTER_Y+2):queuecommand("animate");
		end;

	end;

	SaniNetMainMenuSelectMessageCommand=function(self,params)
		self:visible(false);
	end;

	LoadActor(THEME:GetPathG("","SaniNet/menu/menudots"))..
	{
		Name="dots";
		OnCommand=function(self,params)
			self:x(0):y(SCREEN_CENTER_Y-40):visible(true):zoom(0.65);
			self:queuecommand("animate");
		end;

		animateCommand=function(self)
			self:stoptweening():linear(0.3):zoom(0.68):linear(0.3):zoom(0.65);
			self:queuecommand("animate");
		end;
	};

}


--[[
t[#t+1] = LoadActor(THEME:GetPathG("","SaniNet/2dx_news_window_02"))..
{
	OnCommand=function(self,params)
		self:xy(-802, 0):zoom(1):horizalign(0):vertalign(0);
	end;
	SaniNetHostMessageMessageCommand=function(self,params)
		if params.Type == 0 then
			self:rainbow();
		else
			self:stopeffect();
		end;
		self:finishtweening():linear(0.25):x(0):sleep(3):linear(0.25):x(-802);
		self:finishtweening():linear(0.25):x(0):sleep(3):linear(0.25):x(-802);
	end;
};
]]
t[#t+1] = LoadFont('_open sans semibold')..
{
	OnCommand=function(self,params)
		self:xy(130, 20):zoom(1.1):horizalign(0):vertalign(0):diffusealpha(0);
	end;
	SaniNetHostMessageMessageCommand=function(self,params)		
		self:finishtweening():settext(params.Sender):sleep(0.25):diffusealpha(1):sleep(3):diffusealpha(0);
	end;
};
t[#t+1] = LoadFont('_open sans semibold')..
{
	OnCommand=function(self,params)
		self:xy(150, 50):zoom(1):horizalign(0):vertalign(0):diffusealpha(0);
	end;
	SaniNetHostMessageMessageCommand=function(self,params)		
		self:finishtweening():settext(params.Message):sleep(0.25):diffusealpha(1):sleep(3):diffusealpha(0);
	end;
};

--[[
t[#t+1] = LoadFont('_open sans semibold')..
{
	OnCommand=function(self,params)
		self:xy(0, SCREEN_CENTER_Y):zoom(2):diffusealpha(1):settext("asdfasdfasdf");
	end;

	SaniNetSongInfoMessageCommand=function(self,params)
		self:settext(params.State);
	end;


};
]]

--RECORDS SONGS --
local baseXRecordSong = 0;
local zoomBaseRecord = 0.55;
local yBaseRecordsNet = SCREEN_CENTER_Y+260;
local showRecords = true;
local recordItems = {};
local diffListType = "";

if GAMESTATE:IsSideJoined(PLAYER_1) then
	baseXRecordSong = (baseXPlayer[1]+10)+4;
	diffListType = getCustomOptionValuePlayer(PLAYER_1,"difficultyListMode");
else
	baseXRecordSong = (baseXPlayer[2]-10)+4;
	diffListType = getCustomOptionValuePlayer(PLAYER_2,"difficultyListMode");
end;


if diffListType == nil or #diffListType == 0 then
	diffListType = defaultDifficultyListSkin();
end;

if diffListType == defaultDifficultyListSkin() then
	yBaseRecordsNet = SCREEN_CENTER_Y+260;
	zoomBaseRecord = 0.55;
elseif diffListType == "orbs" then
	yBaseRecordsNet = SCREEN_CENTER_Y+350;
	zoomBaseRecord = 0.42;
else
	yBaseRecordsNet = SCREEN_CENTER_Y+260;
	zoomBaseRecord = 0.55;
end;


t[#t+1] =  Def.ActorFrame {

	OnCommand=function(self)
		local baseX=baseXRecordSong;
		self:xy(baseX, yBaseRecordsNet);
		self:zoom(zoomBaseRecord);
		self:visible(false);
	end;	

	LoadActor(THEME:GetPathG("","SaniNet/eval/onlineranking_text"))..{			
		Name="logoRankingOnline";
		OnCommand=function(self)
		end;
	};

	SongUnchosenMessageCommand = function(self) 
		self:visible(false);
	end;

	--here we create our rank
	SaniNetSongInfoMessageCommand=function(self,params)
		--printInLogParamsData("rankOnlineData",params);
		--here we want only the data that is from us, not for the other players
		if isMySanityID(params["ConnectionId"]) == false then
			return;
		end;

		if SCREENMAN:GetTopScreen():GetSelectionState() == "SelectingSong" then
			return;
		end;

		if params.Step ~= nil then
			if params.State ~= 1 then
				return;
			else
				self:visible(true);
			end;

			--[[
			Trace(":::::::::: SaniNetSongInfo ::::: ");
			for k, v in pairs(params) do
			    Trace(":::::::::: Param " .. tostring(k) .. " = " .. tostring(v))
			end
			]]


			if  params.SongRanking == nil or #params.SongRanking == 0 then
				--empty
				for i=1,6 do
					recordItems[i]:visible(false);
				end;

				recordItems[1]:GetChild("wrRanking"):stoptweening():visible(false);
				recordItems[1]:GetChild("lampRankingGlow"):stoptweening():visible(false);
				recordItems[1]:GetChild("fcomboTag"):stoptweening():visible(false);
				recordItems[1]:GetChild("pfcTag"):stoptweening():visible(false);
				recordItems[1]:GetChild("typeClientRank"):visible(false);
				recordItems[1]:GetChild("judgPlayerRank"):visible(false);
				recordItems[1]:GetChild("meMarkRecord"):visible(false);

				recordItems[1]:GetChild("nodata"):visible(true);
				recordItems[1]:visible(true);

			else
				recordItems[1]:GetChild("nodata"):visible(false);
				for i=1,6 do
					if params.SongRanking[i] == nil then
						recordItems[i]:visible(false);
					else
						local place = params.SongRanking[i]["place"];
						local instanceType = params.SongRanking[i]["player_type"];
						local playerName = params.SongRanking[i]["player_name"];
						local itsFc = params.SongRanking[i]["fc"];
						local itsPfc = params.SongRanking[i]["pfc"]
						local judgRecord = params.SongRanking[i]["judg"];
						local scoreRecord = params.SongRanking[i]["score"];
						local dateRecord = params.SongRanking[i]["date"];
						local diffScore = params.SongRanking[i]["diff"];
						local itsMe = params.SongRanking[i]["me"];

						
						local stateLamp = 4;
						if tonumber(itsPfc) == 1 then
							stateLamp = 2;
							recordItems[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("0.549,0.894,1,0")):effectcolor2(color("0.549,0.894,1,0.5")):effectperiod(0.1):visible(true):diffusealpha(0.25);
							recordItems[i]:GetChild("pfcTag"):stoptweening():visible(true);
							recordItems[i]:GetChild("backr_1"):stoptweening():setstate(3);
						elseif tonumber(itsFc) == 1 then
							stateLamp = 1;
							recordItems[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("#FFA23900")):effectcolor2(color("#FFA239FF")):effectperiod(0.1):visible(true):diffusealpha(0.25);
							recordItems[i]:GetChild("fcomboTag"):stoptweening():visible(true);
							recordItems[i]:GetChild("backr_1"):stoptweening():setstate(2);
						else
							stateLamp = 4;
							recordItems[i]:GetChild("lampRankingGlow"):stoptweening():visible(false);
							recordItems[i]:GetChild("fcomboTag"):stoptweening():visible(false);
							recordItems[i]:GetChild("pfcTag"):stoptweening():visible(false);
							recordItems[i]:GetChild("backr_1"):stoptweening():setstate(1);
						end;

						recordItems[i]:GetChild("lampRanking"):stoptweening():setstate(stateLamp);

						-- i = 1 WR
						if i == 1 then
							recordItems[i]:GetChild("wrRanking"):stoptweening():visible(true);
							recordItems[i]:GetChild("placeRanking"):stoptweening():settext("");
							recordItems[i]:GetChild("backr_1"):stoptweening():setstate(0);
						else
							recordItems[i]:GetChild("wrRanking"):stoptweening():visible(false);
							recordItems[i]:GetChild("placeRanking"):stoptweening():settext(place);
						end;
						




						recordItems[i]:GetChild("nameRank"):stoptweening():settext(playerName);

						local stateRank = gradeTransformState(tonumber(scoreRecord));
						recordItems[i]:GetChild("passRes"):stoptweening():setstate(stateRank);

						local backScore = getZeroStringFromScore(scoreRecord);
						recordItems[i]:GetChild("scoreBackRank"):stoptweening():settext(backScore);
						recordItems[i]:GetChild("scoreFrontRank"):stoptweening():settext(scoreRecord);

						if judgRecord == "hj" then
							recordItems[i]:GetChild("judgPlayerRank"):setstate(1);
						elseif judgRecord == "vj" then
							recordItems[i]:GetChild("judgPlayerRank"):setstate(2);
						elseif judgRecord == "xj" then
							recordItems[i]:GetChild("judgPlayerRank"):setstate(3);
						elseif judgRecord == "uj" then
							recordItems[i]:GetChild("judgPlayerRank"):setstate(4);
						else
							recordItems[i]:GetChild("judgPlayerRank"):setstate(0);
						end;

						--[[
						local colorDif = "#FFFFFF";
						local textDiffScore = diffScore;

						if diffScore > 0 then
							colorDif = "#00fc1e";
							textDiffScore = "+"..diffScore;
						elseif diffScore == 0 then
							colorDif = "#FFFFFF";
							textDiffScore = "0";
						elseif diffScore < 0 then
							colorDif = "#FC0000";
							textDiffScore = diffScore;
						end;

						recordItems[i]:GetChild("diffRecord"):stoptweening():diffuse(color(colorDif)):settext(textDiffScore);
						]]

						--mark if it is my record
						recordItems[i]:GetChild("meMarkRecord"):visible(true);
						if itsMe then
							recordItems[i]:GetChild("meMarkRecord"):stoptweening():diffuse(color("#00f7ff"));
						else
							if i == 1 then
								recordItems[i]:GetChild("meMarkRecord"):stoptweening():diffuse(color("#ff7000"));
							else
								recordItems[i]:GetChild("meMarkRecord"):stoptweening():diffuse(color("#d9ffff"));
							end;
							
						end;
						recordItems[i]:GetChild("meMarkRecord"):stoptweening():queuecommand("Ani");

						recordItems[i]:GetChild("dateRecord"):stoptweening():settext(dateRecord)



						if instanceType == 0 then
							recordItems[i]:GetChild("typeClientRank"):setstate(1);
						elseif instanceType == 1 then
							recordItems[i]:GetChild("typeClientRank"):setstate(0);
						else
							recordItems[i]:GetChild("typeClientRank"):setstate(1);
						end;

						recordItems[i]:GetChild("judgPlayerRank"):visible(true);
						recordItems[i]:GetChild("typeClientRank"):visible(true);						
						recordItems[i]:visible(true);
						recordItems[i]:stoptweening():queuecommand("AniRecord");
					end;

				end;

			end;
		end;
	end;

};


for i=1,6 do

	t[#t+1] =  Def.ActorFrame {

		OnCommand=function(self)
			local baseX=baseXRecordSong;
			self:xy(baseX, yBaseRecordsNet);
			self:zoom(zoomBaseRecord);
			self:diffusealpha(0);
			self:queuecommand("AniRecord");
			self:visible(false);
			recordItems[i] = self;
		end;

		AniRecordCommand=function(self)
			self:sleep(0.025 * (i-1));
			self:diffusealpha(0.8);
			self:x(baseXRecordSong-2);
			self:decelerate(0.4);
			self:x(baseXRecordSong+2);
			self:diffusealpha(1);
		end;



		SaniNetSongInfoEmptyMessageCommand=function(self,params)
				if (i - 1) == params.Position then
					--[[
					Trace(":::::::::: SaniNetSongInfoEmpty ::::: ");
					for k, v in pairs(params) do
					    Trace(":::::::::: Param " .. tostring(k) .. " = " .. tostring(v))
					end
					]]
				end;
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

		LoadActor(THEME:GetPathG("","SaniNet/eval/bestbackrecord"))..{			
			Name="backr_1";
			OnCommand=function(self)
				self:animate(false);
				if i == 1 then
					self:setstate(0);
				else
					self:setstate(1);
				end;
				
				self:y(80 + (90 * (i-1) ));
				self:zoom(1.1);
			end;
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/wr"))..{			
			Name="wrRanking";
			InitCommand=cmd(x,-360);
			OnCommand=function(self)
				self:y(68 + (90 * (i-1) ));
				self:zoom(1);
				self:diffusealpha(1);

				if i > 1 then
					self:visible(false);
				end;
			end;

			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/lamp_ranking"))..{			
			Name="lampRanking";
			InitCommand=cmd(x,-280;animate,false;setstate,0);
			OnCommand=function(self)
				self:y(77 + (90 * (i-1) ));
				self:zoom(1.1);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/glow_lamp"))..{			
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
					self:x(-80);			
				end;

				OnCommand=function(self)
					self:y(56 + (90 * (i-1) ));
					self:zoom(0.9);
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
					self:y(56 + (90 * (i-1) ));
					self:zoom(0.9);
				end;	

				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

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

		LoadActor(THEME:GetPathG("","SaniNet/eval/judgPlayer"))..{
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

		LoadActor(THEME:GetPathG("","SaniNet/eval/typeClient"))..{
			Name="typeClientRank";
			OnCommand=function(self)
				self:x(415);
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

		LoadActor(THEME:GetPathG("","SaniNet/eval/pfg"))..{
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

		LoadActor(THEME:GetPathG("","SaniNet/eval/fullcombo"))..{
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

		LoadActor(THEME:GetPathG("","SaniNet/eval/bestbackrecord"))..{			
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