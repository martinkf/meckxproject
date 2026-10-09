-- JNC (Most of the things here in Fullmode were changed, so please, dont hate me)
local titlechannel;

local TrainTypeBall = "pump-single";

currentChan = nil;

local function GetFixedChannelName(path)
	currentChan = path;
	if (arrChannelTitle[path] ~= nil) then
		return arrChannelTitle[path]
	else
		return path
	end
end;

collectgarbage();


local t = Def.ActorFrame{};

--*************************************************
--         DIFFICULTY LIST TYPE 
--*************************************************
--Here we load the Difficult list to the interface.
--for example, we can load the sanity default or the XX type with the balls or whatever.
local defaultList=defaultDifficultyListSkin(); --02 THEME.lua
local diffListSelected = defaultList;


function checkIfDiffListExist(diffSkinName)
	local diffList = getDificultyListPlugins();

	for i = 1,#diffList do
		if diffList[i] == diffSkinName then
			return true;
		end;
	end;

	return false;
end;

if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local dfsp1 = getCustomOptionValuePlayer(PLAYER_1,"difficultyListMode");
	local dfsp2 = getCustomOptionValuePlayer(PLAYER_2,"difficultyListMode");

	-- we check if one of the players is a guest, if yes, we will treat this as 1 player.
	local p1Profile=false;
	local p2Profile=false;

	if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
		p1Profile = true;
	end;
	if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
		p2Profile = true;
	end;

	if dfsp1 == nil then
		dfsp1 = defaultList;
	end;

	if dfsp2 == nil then
		dfsp2 = defaultList;
	end;

	if p1Profile and p2Profile then

		if dfsp1 == dfsp2 then
			diffListSelected = dfsp1;
		else
			diffListSelected = defaultList;
		end;
	elseif p1Profile == false and p2Profile then
		diffListSelected = dfsp2;
	elseif p1Profile and p2Profile == false then
		diffListSelected = dfsp1;
	end;


else
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		local dfsp1 = getCustomOptionValuePlayer(PLAYER_1,"difficultyListMode");
		if dfsp1 == nil then
			diffListSelected = defaultList;
		else
			local skinExists = checkIfDiffListExist(dfsp1);
			if skinExists == false then
				dfsp1 = defaultList;
				setCustomOptionValuePlayer(PLAYER_1,"difficultyListMode",defaultList);
			end;
			diffListSelected = dfsp1;
		end;
	else
		local dfsp2 = getCustomOptionValuePlayer(PLAYER_2,"difficultyListMode");
		if dfsp2 == nil then
			diffListSelected = defaultList;
		else

			local skinExists = checkIfDiffListExist(dfsp2);
			if skinExists == false then
				dfsp2 = defaultList;
				setCustomOptionValuePlayer(PLAYER_2,"difficultyListMode",defaultList);
			end;
			diffListSelected = dfsp2;
		end;
	end;
end;

--test typeA
--diffListSelected = "prime";

--we get the path of the diff list.
local fullPathDiffList = getDificultyListFullPath(diffListSelected);
if not FILEMAN:DoesFileExist(fullPathDiffList["path"].."init.lua") then

	pathToDiffTypePlug = "Interface_Full_DifficultyList/"..defaultList.."/init.lua";
	t[#t+1] = LoadActor(pathToDiffTypePlug)..{
		OnCommand=function(self)
			self:draworder(10);
		end;
	};

else
	if fullPathDiffList["isExternal"] then
		setDifficultyListPathSelected(fullPathDiffList["path"]);
		t[#t+1] = LoadActor(fullPathDiffList["path"].."init.lua")..{
			OnCommand=function(self)
				self:draworder(10);
			end;
		};
	else
		local pathToDiffTypePlug = "Interface_Full_DifficultyList/"..diffListSelected.."/init.lua";
		t[#t+1] = LoadActor(pathToDiffTypePlug)..{
			OnCommand=function(self)
				self:draworder(10);
			end;
		};
	end;
end;


--*************************************************
--     channel?
--*************************************************
local channelNameYBase= SCREEN_HEIGHT - 200;
if isAspectRatio1610() then
	channelNameYBase= SCREEN_HEIGHT - 260;
end;

if isAspectRatio43() then
	channelNameYBase= SCREEN_CENTER_Y+160;
end;

t[#t+1] = Def.ActorFrame{
	StepsChosenMessageCommand=function(self,params)
		if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
			GAMESTATE:GetTrainInfo(GAMESTATE:GetCurrentSong(), true);
		end;
	end;
	
	SongChosenMessageCommand=function(self,params)
		if GAMESTATE:GetRandomTrainChannel() then
			GAMESTATE:AddRandomTrain();
		end;
	end;
	
	LoadFont("_century gothic")..{
		--OnCommand=cmd(xy,SCREEN_CENTER_X, SCREEN_HEIGHT - 200;diffusealpha,0;shadowcolor,color("0,0,0,1");shadowlength,2;zoom,1.2);
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X, channelNameYBase);
			self:diffusealpha(0);
			self:shadowcolor(color("0,0,0,1"));
			self:shadowlength(2);
			self:zoom(1.2);	
		end;


		ChangeChannelMessageCommand=cmd(settext,CHGetDescription());
		SelectChannelMessageCommand=cmd(finishtweening;y,channelNameYBase;linear,0.18;diffusealpha,1;y,channelNameYBase+18);
		ChannelChosenMessageCommand=cmd(finishtweening;linear,0.125;diffusealpha,0);
	};
};


--*************************************************
--[CW]	        COMMAND WINDOW MOD
--*************************************************
--first we check if we are using the default one
--if we are using a mod, we load that default.lua.

--and we have 2 routes, mods and default
--default is from the theme.

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	local nameCW = getCustomOptionValuePlayer(PLAYER_1,"commandWindowMod");
	local isDefault = false;
	local loadDefault = true;
	local dataCw;

	if PROFILEMAN:IsPersistentProfile(PLAYER_1) == false then
		nameCW="default";
	end;

	if nameCW == nil or nameCW == "default" then
		isDefault = true;
	else
		dataCw = getDataCommandWindowMod(nameCW);
	end;
	--****---

	if isDefault == false then
		loadDefault = false;
		
		if FILEMAN:DoesFileExist(dataCw["lua"]) == false then
			loadDefault = true;
		end;
	end;
	--****---
	if loadDefault == false then
		t[#t+1] = LoadActor(dataCw["lua"])..{
			CreateCommandForPlayer(PLAYER_1);
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X -800,SCREEN_CENTER_Y-70);
				self:visible(false);
			end;		
			CommandWindowOpenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:visible(true);
					self:finishtweening():linear(0.125);
					self:x(SCREEN_CENTER_X -430);
					self:linear(0.125);
					self:x(SCREEN_CENTER_X -440);				
					self:queuecommand("AuxOpen");
				end;
			end;
			AuxOpenCommand=function(self)
				MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_1} );
			end;
			CommandWindowOptionCancelMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:finishtweening():linear(0.125);
					self:x(SCREEN_CENTER_X -430);
					self:linear(0.125);
					self:x(SCREEN_CENTER_X -800);
					self:queuecommand("AuxClose");
				end;
			end;
			AuxCloseCommand=function(self)
				MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_1} );
				self:visible(false);
			end;
		};
	else
		--default
		t[#t+1] = Def.ActorFrame{

			Def.Quad{
				Name="BackBlackA";
				OnCommand=function(self)
					self:zoomto(SCREEN_WIDTH/2,SCREEN_HEIGHT);
					self:xy(SCREEN_CENTER_X -350,SCREEN_CENTER_Y);			
					self:diffuse(color("#000000"));
					self:diffusealpha(0);
					self:faderight(0.25);

				end;

				CommandWindowOpenMessageCommand=function(self,params)
					if params.Player == PLAYER_1 then
						self:stoptweening();
						self:linear(0.25):diffusealpha(0.8);
					end;
				end;

				CommandWindowOptionCancelMessageCommand=function(self,params)
					if params.Player == PLAYER_1 then
						self:stoptweening();
						self:linear(0.25):diffusealpha(0);
					end;
				end;
			};

			LoadActor("0_Interface_Full_Command_Window")..{
				CreateCommandForPlayer(PLAYER_1);
				InitCommand=function(self)
					self:zoom(1.2);
					self:xy(SCREEN_CENTER_X -800,SCREEN_CENTER_Y-40);
					self:visible(false);
					self:diffusealpha(0);
				end;		
				CommandWindowOpenMessageCommand=function(self,params)
					if params.Player == PLAYER_1 then
						self:visible(true);
						self:finishtweening():linear(0.1);
						self:x(SCREEN_CENTER_X -370);
						self:diffusealpha(1);
						self:linear(0.125);
						self:x(SCREEN_CENTER_X -380);				
						self:queuecommand("AuxOpen");
					end;
				end;
				AuxOpenCommand=function(self)
					MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_1} );
				end;
				CommandWindowOptionCancelMessageCommand=function(self,params)
					if params.Player == PLAYER_1 then
						self:finishtweening():linear(0.1);
						self:x(SCREEN_CENTER_X -800);
						self:diffusealpha(0);
						self:queuecommand("AuxClose");
					end;
				end;
				AuxCloseCommand=function(self)
					MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_1} );
					self:visible(false);
				end;
			};

		};
	end;

end;

if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	local nameCW = getCustomOptionValuePlayer(PLAYER_2,"commandWindowMod");
	local isDefault = false;
	local loadDefault = true;
	local dataCw;

	if PROFILEMAN:IsPersistentProfile(PLAYER_2) == false then
		nameCW="default";
	end;

	if nameCW == nil or nameCW == "default" then
		isDefault = true;
	else
		dataCw = getDataCommandWindowMod(nameCW);
	end;
	--****---

	if isDefault == false then
		loadDefault = false;
		
		if FILEMAN:DoesFileExist(dataCw["lua"]) == false then
			loadDefault = true;
		end;
	end;

	if loadDefault == false then
		--first we check if the load exists.
		t[#t+1] = LoadActor(dataCw["lua"])..{
			CreateCommandForPlayer(PLAYER_2);
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X + 800,SCREEN_CENTER_Y-70);
				self:visible(false);
			end;
			CommandWindowOpenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					self:finishtweening():linear(0.125);
					self:x(SCREEN_CENTER_X + 430);
					self:linear(0.125);
					self:x(SCREEN_CENTER_X + 440);				
					self:queuecommand("AuxOpen");
				end;
			end;
			AuxOpenCommand=function(self)
				MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_2} );
			end;
			CommandWindowOptionCancelMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					self:finishtweening():linear(0.125);
					self:x(SCREEN_CENTER_X + 430);
					self:linear(0.125);
					self:x(SCREEN_CENTER_X + 800);
					self:queuecommand("AuxClose");
				end;
			end;
			AuxCloseCommand=function(self)
				MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_2} );
				self:visible(false);
			end;
		};

	else
		--default
		t[#t+1] = Def.ActorFrame{
			Def.Quad{
				Name="BackBlackB";
				OnCommand=function(self)
					self:zoomto(SCREEN_WIDTH/2,SCREEN_HEIGHT);
					self:xy(SCREEN_CENTER_X + 350,SCREEN_CENTER_Y);
					self:diffuse(color("#000000"));
					self:diffusealpha(0);
					self:fadeleft(0.25);
				end;

				CommandWindowOpenMessageCommand=function(self,params)
					if params.Player == PLAYER_2 then
						self:stoptweening();
						self:linear(0.25):diffusealpha(0.8);
					end;
				end;

				CommandWindowOptionCancelMessageCommand=function(self,params)
					if params.Player == PLAYER_2 then
						self:stoptweening();
						self:linear(0.25):diffusealpha(0);
					end;
				end;
			};
			
			LoadActor("0_Interface_Full_Command_Window")..{
				CreateCommandForPlayer(PLAYER_2);
				InitCommand=function(self)
					self:zoom(1.2);
					self:xy(SCREEN_CENTER_X + 800,SCREEN_CENTER_Y-40);
					self:visible(false);
					self:diffusealpha(0);
				end;
				CommandWindowOpenMessageCommand=function(self,params)
					if params.Player == PLAYER_2 then
						self:visible(true);
						self:finishtweening():linear(0.1);
						self:diffusealpha(1);
						self:x(SCREEN_CENTER_X + 370);
						self:linear(0.125);
						self:x(SCREEN_CENTER_X + 380);				
						self:queuecommand("AuxOpen");
					end;
				end;
				AuxOpenCommand=function(self)
					MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_2} );
				end;
				CommandWindowOptionCancelMessageCommand=function(self,params)
					if params.Player == PLAYER_2 then
						self:finishtweening():linear(0.1);
						self:x(SCREEN_CENTER_X + 800);
						self:diffusealpha(0);
						self:queuecommand("AuxClose");
					end;
				end;
				AuxCloseCommand=function(self)
					MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_2} );
					self:visible(false);
				end;		
			};
		};
	end;

end;

--*************************************************
--        CW
--*************************************************
--[[
t[#t+1] = Def.ActorFrame{

	StepsChosenMessageCommand=function(self,params)
		if GAMESTATE:GetMusicTrainChannel() or GAMESTATE:GetProgressiveChannel() then
			GAMESTATE:GetTrainInfo(GAMESTATE:GetCurrentSong(), true);
		end;
	end;
	
	SongChosenMessageCommand=function(self,params)
		if GAMESTATE:GetRandomTrainChannel() then
			GAMESTATE:AddRandomTrain();
		end;
	end;
	
	LoadFont("_century gothic")..{
		--OnCommand=cmd(xy,SCREEN_CENTER_X, SCREEN_HEIGHT - 200;diffusealpha,0;shadowcolor,color("0,0,0,1");shadowlength,2;zoom,1.2);
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X, channelNameYBase);
			self:diffusealpha(0);
			self:shadowcolor(color("0,0,0,1"));
			self:shadowlength(2);
			self:zoom(1.2);	
		end;


		ChangeChannelMessageCommand=cmd(settext,CHGetDescription());
		SelectChannelMessageCommand=cmd(finishtweening;y,channelNameYBase;linear,0.18;diffusealpha,1;y,channelNameYBase+18);
		ChannelChosenMessageCommand=cmd(finishtweening;linear,0.125;diffusealpha,0);
	};

	Def.Quad{
		Name="BackBlackA";
		OnCommand=function(self)
			self:zoomto(SCREEN_WIDTH/2,SCREEN_HEIGHT);
			self:xy(SCREEN_CENTER_X -350,SCREEN_CENTER_Y);			
			self:diffuse(color("#000000"));
			self:diffusealpha(0);
			self:faderight(0.25);

		end;

		CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:stoptweening();
				self:linear(0.25):diffusealpha(0.8);
			end;
		end;

		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:stoptweening();
				self:linear(0.25):diffusealpha(0);
			end;
		end;
	};

	LoadActor("0_Interface_Full_Command_Window")..{
		CreateCommandForPlayer(PLAYER_1);
		InitCommand=function(self)
			self:zoom(1.2);
			self:xy(SCREEN_CENTER_X -800,SCREEN_CENTER_Y-40);
			self:visible(false);
			self:diffusealpha(0);
		end;		
		CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:visible(true);
				self:finishtweening():linear(0.1);
				self:x(SCREEN_CENTER_X -370);
				self:diffusealpha(1);
				self:linear(0.125);
				self:x(SCREEN_CENTER_X -380);				
				self:queuecommand("AuxOpen");
			end;
		end;
		AuxOpenCommand=function(self)
			MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_1} );
		end;
		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:finishtweening():linear(0.1);
				self:x(SCREEN_CENTER_X -800);
				self:diffusealpha(0);
				self:queuecommand("AuxClose");
			end;
		end;
		AuxCloseCommand=function(self)
			MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_1} );
			self:visible(false);
		end;
	};


	Def.Quad{
		Name="BackBlackB";
		OnCommand=function(self)
			self:zoomto(SCREEN_WIDTH/2,SCREEN_HEIGHT);
			self:xy(SCREEN_CENTER_X + 350,SCREEN_CENTER_Y);
			self:diffuse(color("#000000"));
			self:diffusealpha(0);
			self:fadeleft(0.25);
		end;

		CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:stoptweening();
				self:linear(0.25):diffusealpha(0.8);
			end;
		end;

		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:stoptweening();
				self:linear(0.25):diffusealpha(0);
			end;
		end;
	};
	
	LoadActor("0_Interface_Full_Command_Window")..{
		CreateCommandForPlayer(PLAYER_2);
		InitCommand=function(self)
			self:zoom(1.2);
			self:xy(SCREEN_CENTER_X + 800,SCREEN_CENTER_Y-40);
			self:visible(false);
			self:diffusealpha(0);
		end;
		CommandWindowOpenMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:visible(true);
				self:finishtweening():linear(0.1);
				self:diffusealpha(1);
				self:x(SCREEN_CENTER_X + 370);
				self:linear(0.125);
				self:x(SCREEN_CENTER_X + 380);				
				self:queuecommand("AuxOpen");
			end;
		end;
		AuxOpenCommand=function(self)
			MESSAGEMAN:Broadcast("CWOpen", {Player = PLAYER_2} );
		end;
		CommandWindowOptionCancelMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				self:finishtweening():linear(0.1);
				self:x(SCREEN_CENTER_X + 800);
				self:diffusealpha(0);
				self:queuecommand("AuxClose");
			end;
		end;
		AuxCloseCommand=function(self)
			MESSAGEMAN:Broadcast("CWClose", {Player = PLAYER_2} );
			self:visible(false);
		end;		
	};
};
]]

--*************************************************
--  PROFILE
--*************************************************

t[#t+1] = GetPlatSm() .. {
		OnCommand=cmd(Center;addy,220;zoom,.9;visible,false);
		StepsChosenMessageCommand=function(self, params)
			if params.Booth then
				self:visible(true);
			end;
		end;
		StepsUnchosenMessageCommand=cmd(visible,false);
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


return t;