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

local function checkTypeStepData(pndata)
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps(pndata);

	style = cur_steps:GetStepsType();

	if style=='StepsType_Pump_Single' --[[and string.find( description,"SP" )]] then 
		return 1;
	elseif style=='StepsType_Pump_Single' then 
		return 1;
	elseif style=='StepsType_Pump_Couple' then 
		return 2;
	elseif ( style=='StepsType_Pump_Double' --[[ and string.find( description,"DP" ) ]] ) or style=='StepsType_Pump_Routine'  then 
		return 2;
	elseif style=='StepsType_Pump_Double' or style=='StepsType_Pump_Halfdouble' then 
		return 2;
	end;

	return 0;
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

	if dfsp1 == nil or dfsp2 == nil then
		diffListSelected = defaultList;
	else
		if dfsp1 == dfsp2 then
			diffListSelected = dfsp1;
		else
			diffListSelected = defaultList;
		end;
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
local pathOfDiff="/Themes/" .. THEME:GetCurThemeName() .. "/BGAnimations/ScreenSelectMusicLua/";
local pathToDiffTypePlug = "Interface_Full_DifficultyList/"..diffListSelected.."/init.lua";

if not FILEMAN:DoesFileExist(pathOfDiff..pathToDiffTypePlug) then
	pathToDiffTypePlug = "Interface_Full_DifficultyList/"..defaultList.."/init.lua";
end;


t[#t+1] = LoadActor(pathToDiffTypePlug);


--*************************************************
--        CW
--*************************************************
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
		OnCommand=cmd(xy,SCREEN_CENTER_X, SCREEN_HEIGHT - 200;diffusealpha,0;shadowcolor,color("0,0,0,1");shadowlength,2;zoom,1.2);
		ChangeChannelMessageCommand=cmd(settext,CHGetDescription());
		SelectChannelMessageCommand=cmd(finishtweening;y,SCREEN_HEIGHT - 200;linear,0.18;diffusealpha,1;y,SCREEN_HEIGHT - 182);
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