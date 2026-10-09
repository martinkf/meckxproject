local t = Def.ActorFrame {};

local showDebug=true;
function debugMensaje(mensaje)

	if showDebug then
		Trace(":DEBUG:: "..mensaje);
	end;

end;

-- this have all the song objects used for the grid.

local songGridObjects = {};

function getRandomSongFromGroup(groupName)
	local stepsOnGroup = SONGMAN:GetSongsInGroup(groupName) or {};
	if #stepsOnGroup == 0 then
		return nil;
	end;
	return stepsOnGroup[math.random(1, #stepsOnGroup)];
end;

function processSongList(groupName)
	--we want to delete some of the weird folders...
	local songsOnGroup = SONGMAN:GetSongsInGroup(groupName);
	local procList = {};
	for i=1,#songsOnGroup do
		if songsOnGroup[i]:GetDisplayMainTitle() ~= "info" then
			table.insert(procList,songsOnGroup[i]);
		end;
	end;
	return procList;
end;

local function GetBannerSong(song)		
	local dataBannerSong = {generic=0,bpath=""};
	if (song ~= nil) then
		local sbackground = song:GetBannerPath();
		--local sbackground = song:GetBackgroundPath();
		if (sbackground ~= nil) then
			if FILEMAN:DoesFileExist( sbackground ) then
				--self:LoadFromCachedBanner( sbackground );
				dataBannerSong["generic"]=0;
				dataBannerSong["bpath"]=sbackground;
				return dataBannerSong;
			else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
			end;
		else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
		end;	
	end;	

    if not song then
		dataBannerSong["generic"]=1;
		dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
		return dataBannerSong;					
    end;
end;


function getAllSongGroups()
	local bannedPacks = {"00-00SYS","FAVORITES","MUSICTRAIN","PROGRESSIVEMODE","WM","SKILLUP ZONE","00.BASIC MODE","13.XXQUESTZONE","INFINITYMISSIONS","12.PRIME2QUESTZONE","Quest",""};
	local songGroupListRaw = SONGMAN:GetSongGroupNames();
	local finalSongPack = {};
	for i=1,#songGroupListRaw do
		local exist = false;
		for x=1,#bannedPacks do
			if string.lower(songGroupListRaw[i]) == string.lower(bannedPacks[x]) then
				exist=true;
			end;
		end;

		if exist == false then
			table.insert(finalSongPack,songGroupListRaw[i]);
		end;
	end;
	return finalSongPack;
end;


function sortChartFromSong(chartListSong)
--we sort the chart as
--[S1...SN][D1...DN][HF1...HFN][COOP1...COOPN][SP1...SPN][DP1...DPN]
	local singleList ={};
	local doubleList ={};
	local halfList ={};
	local coopList={};
	local spList={};
	local dpList={};
	local sortedList={};

	local is2Player = false;
	if GAMESTATE:GetNumSidesJoined() == 2 then
		is2Player = true;
	end;

	for i=1,#chartListSong do
		local meterText = chartListSong[i]:GetMeter();
		if chartListSong[i]:GetPlayers() ~= 1 and is2Player == false then
				table.insert(coopList,{step=chartListSong[i],meter=0});
		else
			if chartListSong[i]:GetStepsType() == 'StepsType_Pump_Single' then
				table.insert(singleList,{step=chartListSong[i],meter=meterText});
			elseif chartListSong[i]:GetStepsType() == 'StepsType_Pump_Single_P' then
				table.insert(spList,{step=chartListSong[i],meter=meterText});
			elseif chartListSong[i]:GetStepsType() == 'StepsType_Pump_Halfdouble' and is2Player == false then
				table.insert(halfList,{step=chartListSong[i],meter=meterText});
			elseif chartListSong[i]:GetStepsType() == 'StepsType_Pump_Double' and is2Player == false then
				table.insert(doubleList,{step=chartListSong[i],meter=meterText});
			elseif chartListSong[i]:GetStepsType() == 'StepsType_Pump_Double_P' and is2Player == false then	
				table.insert(dpList,{step=chartListSong[i],meter=meterText});
			end;
		end;
	end;

	if #singleList > 0 then
		table.sort(singleList, function(a, b)
		    return a.meter < b.meter
		end)
		for i=1,#singleList do
			table.insert(sortedList,singleList[i]["step"]);
		end;
	end;

	if #doubleList > 0 then
		table.sort(doubleList, function(a, b)
		    return a.meter < b.meter
		end)
		for i=1,#doubleList do
			table.insert(sortedList,doubleList[i]["step"]);
		end;
	end;

	if #halfList > 0 then
		table.sort(halfList, function(a, b)
		    return a.meter < b.meter
		end)
		for i=1,#halfList do
			table.insert(sortedList,halfList[i]["step"]);
		end;
	end;

	if #coopList > 0 then
		for i=1,#coopList do
			table.insert(sortedList,coopList[i]["step"]);
		end;
	end;

	if #spList > 0 then
		table.sort(spList, function(a, b)
		    return a.meter < b.meter
		end)
		for i=1,#spList do
			table.insert(sortedList,spList[i]["step"]);
		end;
	end;


	if #dpList > 0 then
		table.sort(dpList, function(a, b)
		    return a.meter < b.meter
		end)
		for i=1,#dpList do
			table.insert(sortedList,dpList[i]["step"]);
		end;
	end;
	return sortedList;
end;


t[#t+1] =LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/BG") )..{
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y);
			self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
		OffCommand=function(self)
			self:stoptweening():linear(0.15):diffusealpha(0);
		end;
};


t[#t+1] = 	LoadFont("_TitleXolonium")..{
			Name="Title";
			Text="NONSTOP CENTER";
			InitCommand=cmd(zoom,1;xy,SCREEN_CENTER_X,SCREEN_TOP+20;);
};



t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
	 self:sleep(0.05);	
	 self:queuecommand("startGrid");
	end;

	startGridCommand=function(self)
		MESSAGEMAN:Broadcast("CheckChangeForItem");
		MESSAGEMAN:Broadcast("UpdateTimeNonstop");
	end;

	LoadActor(THEME:GetPathS("","Command move")) .. {
		playMenuMoveMessageCommand=function(self)
			self:play();
		end;
	};

	LoadActor(THEME:GetPathS("","Command INOUT")) .. {
		playMenuINOUTMessageCommand=function(self)
			self:play();
		end;
	};

	LoadActor(THEME:GetPathS("","Command set")) .. {
		playMenuSETMessageCommand=function(self)
			self:play();
		end;
	};

	LoadActor(THEME:GetPathS("","xsanity/chosen")) .. {
		readyEnterSoundMessageCommand=function(self)
			self:play();
		end;
	};	

	LoadActor(THEME:GetPathS("","JoinGamePlay")) .. {
		readyStartSoundMessageCommand=function(self)
			self:play();
		end;
	};
};


--CENTER INFORMATION
t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);			
		    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
		    	if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_space" then
		       		local resp = removeLastSongNonstopCenterNonstopCenter();
		       		MESSAGEMAN:Broadcast("CheckChangeForItem");
		       		self:GetChild("KeyShortcutsNs"):GetChild("deleteLastSongBarHotkey"):GetChild("deleteLastKeySprite"):stoptweening():queuecommand("press");
		      	end;
		    	if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F11" then
		    		removeSecondsToPauseNonstopCenter();

					local secondsPause = GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
					if secondsPause == 0 then
						self:GetChild("PauseBetweenSongsObject"):GetChild("PBSOpt"):settext("NO PAUSE");
					else
						self:GetChild("PauseBetweenSongsObject"):GetChild("PBSOpt"):settext(secondsPause.."s");
					end;
		    		
		      	end;
		    	if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_F12" then
		    		addSecondsToPauseNonstopCenter();
		    		local secondsPause = GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
					if secondsPause == 0 then
						self:GetChild("PauseBetweenSongsObject"):GetChild("PBSOpt"):settext("NO PAUSE");
					else
						self:GetChild("PauseBetweenSongsObject"):GetChild("PBSOpt"):settext(secondsPause.."s");
					end;

		      	end;
		      	return false
		    end)

		end;

		Def.ActorFrame{
			Name="PauseBetweenSongsObject";

			OnCommand=function(self)
				self:y(-150);
			end;

			LoadFont("_TitleXolonium")..{
				Name="PBSTitle";
				OnCommand=function(self)
					self:y(-30);
					self:zoom(0.55);
					self:horizalign("center");
					self:maxwidth(500);
			        self:shadowlength(2);
			        self:shadowcolor(0,0,0,1);
					self:settext("Pause Duration Between Songs");
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="PBSOpt";
				OnCommand=function(self)
					self:y(0);
					self:zoom(0.55);
					self:horizalign("center");
					self:maxwidth(500);
			        self:shadowlength(2);
			        self:shadowcolor(0,0,0,1);

		    		local secondsPause = GAMESTATE:Env()["NONSTOPCENTER"]["NC_SegBeforeContinue"];
					if secondsPause == 0 then
						self:settext("NO PAUSE");
					else
						self:settext(secondsPause.."s");
					end;

				end;
			};

			Def.ActorFrame{
				Name="KeyF11Object";
				OnCommand=function(self)
					self:x(-90);
				end;
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/key_small") )..{
						Name="base";
						OnCommand=function(self)
							self:zoom(0.7);
							self:zoomx(1);
							self:x(-1);
							self:y(1);
						end;

						pressCommand=function(self)

						end;
				};
				LoadFont("_TitleXolonium")..{
					Name="text";
					OnCommand=function(self)
						self:zoom(0.5);
						self:horizalign("center");
						self:maxwidth(400);
				        self:shadowlength(2);
				        self:shadowcolor(0,0,0,1);
						self:settext("F11");
					end;
				};

			};

			Def.ActorFrame{
				Name="KeyF12Object";
				OnCommand=function(self)
					self:x(90);
				end;
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/key_small") )..{
						Name="base";
						OnCommand=function(self)
							self:zoom(0.7);
							self:zoomx(1);
							self:x(-1);
							self:y(1);
						end;

						pressCommand=function(self)

						end;
				};
				LoadFont("_TitleXolonium")..{
					Name="text";
					OnCommand=function(self)
						self:zoom(0.5);
						self:horizalign("center");
						self:maxwidth(400);
				        self:shadowlength(2);
				        self:shadowcolor(0,0,0,1);
						self:settext("F12");
					end;
				};

			};

		};

		Def.ActorFrame{
			Name="KeyShortcutsNs";
			OnCommand=function(self)
				self:y(-10);
			end;
			LoadFont("_TitleXolonium")..{
				Name="titleKeyShortcuts";
				OnCommand=function(self)
					self:y(-50);
					self:zoom(0.55);
					self:horizalign("center");
					self:maxwidth(400);
			        self:shadowlength(2);
			        self:shadowcolor(0,0,0,1);
					self:settext(getNonstopCenterText("keyshortcuts"));
				end;
			};

			--spacebar
			Def.ActorFrame{
				Name="deleteLastSongBarHotkey";
				OnCommand=function(self)
					self:y(-40);
				end;

				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/key_big") )..{
						Name="deleteLastKeySprite";
						OnCommand=function(self)
							self:zoom(0.8);
							self:zoomx(1.25);
							self:y(16);
							local lang = PREFSMAN:GetPreference('Language');
							if lang == "es" or lang == "pt" then
								self:zoomx(2);
							end;
						end;

						pressCommand=function(self)
							if lang == "es" or lang == "pt" then
								self:linear(0.05);
								self:zoom(0.85);
								self:zoomx(2.05);
								self:linear(0.05);
								self:zoom(0.8);
								self:zoomx(2);
							else
								self:linear(0.05);
								self:zoom(0.85);
								self:zoomx(1.3);
								self:linear(0.05);
								self:zoom(0.8);
								self:zoomx(1.25);
							end;
						end;
				};

				LoadFont("_TitleXolonium")..{
					Name="deleteLastSongKey";
					OnCommand=function(self)
						self:y(15);
						self:zoom(0.55);
						self:horizalign("center");
						self:maxwidth(400);
				        self:shadowlength(2);
				        self:shadowcolor(0,0,0,1);
						self:settext(getNonstopCenterText("keyshortcuts_deletelastKey"));
						local lang = PREFSMAN:GetPreference('Language');
						if lang == "ko" then
							self:zoom(0.8);
							self:y(12);
						end;
					end;
				};

				LoadFont("_myriad pro")..{
					Name="deleteLastSongText";
					OnCommand=function(self)
						self:y(40);
						self:zoom(0.75);
						self:horizalign("center");
						self:maxwidth(400);
				        self:shadowlength(2);
				        self:shadowcolor(0,0,0,1);
						self:settext(getNonstopCenterText("keyshortcuts_deletelast"));
						local lang = PREFSMAN:GetPreference('Language');
						if lang == "ko" then
							self:zoom(0.6);
							self:y(46);
						end;
					end;
				};
			}

		};

		Def.ActorFrame{
			Name="timeDurationSection";
			OnCommand=function(self)
				self:y(70);
			end;

			Def.Quad {		
				Name="backTotalTime";
				OnCommand=function(self)
					self:zoomto(250,20);
					self:diffuse(color("#029c99"));
					self:y(1);
					self:fadeleft(0.4);
					self:faderight(0.4);
				end;
			};

			Def.Quad {
				OnCommand=function(self)
					self:zoomto(250,18);
					self:diffuse(color("#000000"));
					self:y(0);
					self:fadeleft(0.4);
					self:faderight(0.4);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="titleTotalTime";
				OnCommand=function(self)
					self:y(-20);
					self:zoom(0.55);
					self:horizalign("center");
					self:maxwidth(400);
			        self:shadowlength(2);
			        self:shadowcolor(0,0,0,1);
					self:settext(getNonstopCenterText("nsduration"));

					local lang = PREFSMAN:GetPreference('Language');
					if lang == "ko" then
						self:zoom(0.7);
						self:y(-26);
					end;
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="totalTimeNonstop";
				OnCommand=function(self)
					self:y(0);
					self:zoom(0.55);
					self:horizalign("center");
					self:maxwidth(400);
			        self:shadowlength(2);
			        self:shadowcolor(0,0,0,1);
				end;

				UpdateTimeNonstopMessageCommand=function(self)
					local totalTime = totalTimeOfSongsNonstopCenter();
					self:settext(totalTime["formated"]);
				
				    local parent = self:GetParent();
				    local backTotalTime = parent:GetChild("backTotalTime");
				    if totalTime["hours"] >= 1 then
				    	backTotalTime:diffuse(color("#ff0000"));
				    	return;
				    end;

					if totalTime["minutes"] > 0 then
						backTotalTime:diffuse(color("#029c99"));
					end;
					if totalTime["minutes"] >= 14 then
						backTotalTime:diffuse(color("#c4b700"));
					end;
					if totalTime["minutes"] >= 20 then
						backTotalTime:diffuse(color("#ffab3d"));
					end;
					if totalTime["minutes"] >= 30 then
						backTotalTime:diffuse(color("#ff0000"));
					end;
				end;
			};
		}

}

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

local playerReadyToPlay = {false,false};
local player_opt = {5,5}; --default on the first entry. --this is the "id" on the list of base options.
local player_on_option = {false,false}; -- with this we can identify if we need to do something on the header or the body.
local player_submenu_opt = {"",""};

--::: IMPORTANT SHIT :::---
local numMaxSongs = 12;

local subMenuObjectRegister = {};

local subMenuObjectRegister_p1 = {};
local subMenuObjectRegister_p2 = {};

local songGroupList = getAllSongGroups();
local songGroupPlayer = {1,1};




--******************
--SONG SUB-MENU VARS
--******************
local arrowPosSongSubMenu = {-88,-20,105,140 };
local playerSongSubMenuStatus = {0,0};

local playerSongSubMenuSongIndex = {1,1};
local playerSongSubMenuChartIndex = {1,1};

local pageActiveSongCharts=1;
local indexPageChart=1;

local pageActiveSongChartsPlayers = {1,1};
local indexPageChartPlayers ={1,1};

local allSongsOnGroupSelectedTmpPlayers = {nil,nil};
local tmpChartsFromSongsPlayers = {nil,nil}
local songSubMenuTmpGroupSelectPlayers ={"",""};
local songSubMenuSelectedPlayers = {nil,nil};
--local listLevelObjectList = {};

local listLevelObjectList_p1 = {};
local listLevelObjectList_p2 = {};

local pointersPlayerLevelList = {nil,nil};
local chartsToShowLevelList=0;
local chartsToShowLvListPlayers = {0,0}

local backLvListvObject = {nil,nil};



--::::OPTIONS::::--
--when adding a new option, remember to put the index, it needs to be the same index on the list.
local menu_BaseOptions = {
	{index=1,name="songs",expand_to="songSubMenu",img_text="text_1.png"}, --1
	{index=2,name="listopt",expand_to="listOptSubmenu",img_text="text_2.png"},
	{index=3,name="ready",expand_to="readySubMenu",img_text="text_3.png"},
	{index=4,name="exit",expand_to="exit",img_text="text_4.png"}, --4

	{index=5,name="songs",expand_to="songSubMenu",img_text="text_1.png"},
	{index=6,name="listopt",expand_to="listOptSubmenu",img_text="text_2.png"},
	{index=7,name="ready",expand_to="readySubMenu",img_text="text_3.png"},
	{index=8,name="exit",expand_to="exit",img_text="text_4.png"} --8
};


--::::MENU HEADER HELPERS::::--
--we want to know if is visible or not
function getStatusPlaceOption(playerOption,indexOption)

	local posOption = indexOption - playerOption;
	--we need to check for the edge cases  pos 1 and pos #list.
	if playerOption == 1 and indexOption == #menu_BaseOptions then
		return 2;
	end;
	if playerOption == #menu_BaseOptions and indexOption == 1 then
		return 4;
	end;

	if posOption  < -1 then		--out
		return 1;
	elseif posOption == -1 then --left
		return 2;
	elseif posOption == 0 then  --center
		return 3;
	elseif posOption == 1 then  --right
		return 4;
	elseif posOption > 1 then   --out
		return 5;
	end;
end;

function movePosPlayerOpt(mov,playerPointerPos)
	if mov == 1 then
		if player_opt[playerPointerPos] + 1 > #menu_BaseOptions then
			player_opt[playerPointerPos] = 1;
			return 1;
		else
			player_opt[playerPointerPos] = player_opt[playerPointerPos] + 1;
			return player_opt[playerPointerPos];
		end;
	else
		if player_opt[playerPointerPos] - 1 < 1 then
			player_opt[playerPointerPos] = #menu_BaseOptions;
			return #menu_BaseOptions;
		else
			player_opt[playerPointerPos] = player_opt[playerPointerPos] - 1;
			return player_opt[playerPointerPos];
		end;
	end;
end;

--::::NONSTOP PLAYER EDITOR::::--
function createNonstopEditor(player)
	local optPointerPlayer = 1;
	local baseXForPlayer = 0;
	local yBaseForPlayer = SCREEN_CENTER_Y;
	if player==PLAYER_1 then
		baseXForPlayer = SCREEN_CENTER_X-342;
		optPointerPlayer = 1;
	else
		baseXForPlayer = SCREEN_CENTER_X+342;
		optPointerPlayer = 2;
	end;

	--*******************************
	-- CONTAINER MENU and CONTROLLER
	--*******************************
	local editorActor = Def.ActorFrame{
		OnCommand = function(self)
			self:x(baseXForPlayer);
			self:y(yBaseForPlayer);
		end;

		CodeMessageCommand=function(self, params)
		--if menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "songs" then					
		--[[
			local songRandom = getRandomSongFromGroup("43 - TERMINUS MODPACK");
			local allStepsFromSong = songRandom:GetAllSteps();
			local ranStep = math.random(1,#allStepsFromSong);
			local stepSelected = allStepsFromSong[ranStep];
			table.insert(nonstopSongSelection,stepSelected);
			MESSAGEMAN:Broadcast("CheckChangeForItem");
		end;
		]]


			--cancel actions, just move everything 1 item backward
			if params.PlayerNumber == player and params.Name == "UpRight" then

			end;

			--cancel actions, just move everything 1 item backward
			if params.PlayerNumber == player and params.Name == "UpLeft" then

			end;


			if params.PlayerNumber == player and params.Name == "Center" then

				if player_on_option[optPointerPlayer] == false then
					--Base menu		
					--here we select where we want to enter, so we pass this to the submenu object
					--we dont wan't to have all the logic here, we will pass the logic
					--of doing things to the submenu object.
					--here we just control the movement of the header menu.
					if menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "songs" then
						player_on_option[optPointerPlayer] = true;
						player_submenu_opt[optPointerPlayer] = menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"];
						-- we call the object and show the submenu

						if player == PLAYER_1 then
							subMenuObjectRegister_p1[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
							subMenuObjectRegister_p1[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						else
							subMenuObjectRegister_p2[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
							subMenuObjectRegister_p2[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						end;


						--subMenuObjectRegister[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
						--subMenuObjectRegister[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						MESSAGEMAN:Broadcast("playMenuINOUT");
					end;

					if menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "ready" then						
						player_on_option[optPointerPlayer] = true;
						player_submenu_opt[optPointerPlayer] = menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"];

						if player == PLAYER_1 then
							subMenuObjectRegister_p1[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
							subMenuObjectRegister_p1[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						else
							subMenuObjectRegister_p2[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
							subMenuObjectRegister_p2[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						end;

						--subMenuObjectRegister[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:queuecommand("enterOption");
						--subMenuObjectRegister[menu_BaseOptions[player_opt[optPointerPlayer]]["expand_to"]]:visible(true);
						MESSAGEMAN:Broadcast("readyEnterSound");						
						-- setGameplayNonstopCenter();
						-- startGameplayNonstopCenter();

					end;
				else

				end;
			end;


			if params.PlayerNumber == player and params.Name == "DownLeft" then
				if player_on_option[optPointerPlayer] == false then
					--Base menu
					local newPos = movePosPlayerOpt(-1,optPointerPlayer);
					MESSAGEMAN:Broadcast("SwitchPosTitle");
					MESSAGEMAN:Broadcast("RewriteDescription");
					MESSAGEMAN:Broadcast("playMenuMove");
				else
					--Inside menu
				end;

			end;
			if params.PlayerNumber == player and params.Name == "DownRight" then
				if player_on_option[optPointerPlayer] == false then
					--Base menu
					local newPos = movePosPlayerOpt(1,optPointerPlayer);
					MESSAGEMAN:Broadcast("SwitchPosTitle");
					MESSAGEMAN:Broadcast("RewriteDescription");
					MESSAGEMAN:Broadcast("playMenuMove");
				else
					--Inside menu
				end;
			end;
		end;
	};

	----------------------
	--MENU HEADER 
	----------------------
	local animationSwitchTime = 0.1;
	local menuHeaderPosData = {
		{x=-150,diffuse=0}, --out
		{x=-100,diffuse=0.4}, --left opt
		{x=0,diffuse=1},    -- center
		{x=100,diffuse=0.4},  -- right opt
		{x=150,diffuse=0}  -- out
	};
	
	--Modify here if you want to move the header.
	local headMenuActor = Def.ActorFrame{
		OnCommand=function(self)
			self:y(-250);
		end;		
	};

	-- base header
	headMenuActor[#headMenuActor+1] = Def.ActorFrame{
		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/header_base") )..{
				OnCommand=function(self)
					self:zoom(0.6);
					self:y(10);
				end;
		};
	};

	-- description background
	headMenuActor[#headMenuActor+1] = Def.Quad {		
		OnCommand=function(self)
			self:x(0);
			self:y(30);
			self:zoomto(300,18);
			self:diffuse(color("#7B68EE"));
			self:fadeleft(0.4);
			self:faderight(0.4);
		end;
	};

	-- description text base
	headMenuActor[#headMenuActor+1] = LoadFont("_myriad pro")..{
		Name="descOptions";
		OnCommand=function(self)
			self:zoom(0.6);
	        self:wrapwidthpixels(380)  -- Limita el ancho en píxeles donde el texto se ajustará automáticamente.
	        self:maxheight(100)        -- Establece el máximo espacio vertical que puede ocupar el texto.
	        self:vertspacing(-2) 
	        self:shadowlength(1);
	        self:shadowcolor(0,0,0,1);
	        self:horizalign(center);
	        self:y(30);
	        self:x(0);

	        local indexPlayerOption = player_opt[optPointerPlayer];
	        local nameOptionSelected = menu_BaseOptions[indexPlayerOption]["name"];
	        local cwTextOption = getNonstopCenterText(nameOptionSelected);
	        self:settext(cwTextOption);

		end;

		RewriteDescriptionMessageCommand=function(self)

	        local indexPlayerOption = player_opt[optPointerPlayer];
	        local nameOptionSelected = menu_BaseOptions[indexPlayerOption]["name"];
	        local cwTextOption = getNonstopCenterText(nameOptionSelected);
	        self:settext(cwTextOption);

		end;


		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;
	};


	for i=1,#menu_BaseOptions do
		headMenuActor[#headMenuActor+1] = Def.ActorFrame{
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/"..menu_BaseOptions[i]["img_text"]) )..{
					Name="headeropt_"..i;
					OnCommand=function(self)
						self:zoom(0.6);
						local indexStatus = getStatusPlaceOption(player_opt[optPointerPlayer],i);
						self:x(menuHeaderPosData[indexStatus]["x"]);
						self:diffusealpha(menuHeaderPosData[indexStatus]["diffuse"]);
					end;

					SwitchPosTitleMessageCommand=function(self)
						local indexStatus = getStatusPlaceOption(player_opt[optPointerPlayer],i);
						self:stoptweening();
						self:linear(animationSwitchTime):x(menuHeaderPosData[indexStatus]["x"]):diffusealpha(menuHeaderPosData[indexStatus]["diffuse"]);
					end;
			};
		};		
	end;



	----------------------
	--BODY OF THE MENU
	--Here we have all the big menus of every option. the idea is to have everything separate 
	----------------------
	local bodyActorFrame = Def.ActorFrame{};

	--*************
	--SONG SUB-MENU
	--*************	
	-- local arrowPosSongSubMenu = {-88,-20,70,120 };
	-- local playerSongSubMenuStatus = {1,1};
	-- local playerSongSubMenuSongIndex = {1,1};

	--local songGroupList = getAllSongGroups();
	--local songGroupPlayer = {1,1};


	function normalizeMeterSong(lv)
		local lvProc = "00";
		if lv < 10 then
			lvProc = "0"..lv;
		else
			lvProc = lv;
		end;
		return lvProc;
	end;

	function moveGroupIndexPlayerSongMenu(movement,optPointerP)
		if movement == 1 then
			if (songGroupPlayer[optPointerP] + 1) > #songGroupList then
				songGroupPlayer[optPointerP] = 1;
			else
				songGroupPlayer[optPointerP] = songGroupPlayer[optPointerP] + 1;
			end;
		else
			if (songGroupPlayer[optPointerP] - 1) < 1 then
				songGroupPlayer[optPointerP] = #songGroupList;
			else
				songGroupPlayer[optPointerP] = songGroupPlayer[optPointerP] - 1;
			end;

		end;
	end;

--playerSongSubMenuSongIndex[optPointerPlayer]
	function moveSongIndexPlayerSongMenu(movement,optPointer)		
		if movement == 1 then
			if (playerSongSubMenuSongIndex[optPointer] + 1) > #allSongsOnGroupSelectedTmpPlayers[optPointer] then
				playerSongSubMenuSongIndex[optPointer] = 1;
			else
				playerSongSubMenuSongIndex[optPointer] = playerSongSubMenuSongIndex[optPointer] + 1;
			end;
		else
			if (playerSongSubMenuSongIndex[optPointer] - 1) < 1 then
				playerSongSubMenuSongIndex[optPointer] = #allSongsOnGroupSelectedTmpPlayers[optPointer];
			else
				playerSongSubMenuSongIndex[optPointer] = playerSongSubMenuSongIndex[optPointer] - 1;
			end;

		end;
	end;

	function moveChartIndexPlayer(movement,optPointer)
		if movement == 1 then
			if (playerSongSubMenuChartIndex[optPointer] + 1) > #tmpChartsFromSongsPlayers[optPointer] then
				playerSongSubMenuChartIndex[optPointer] = 1;
			else
				playerSongSubMenuChartIndex[optPointer] = playerSongSubMenuChartIndex[optPointer] + 1;
			end;
		else
			if (playerSongSubMenuChartIndex[optPointer] - 1) < 1 then
				playerSongSubMenuChartIndex[optPointer] = #tmpChartsFromSongsPlayers[optPointer];
			else
				playerSongSubMenuChartIndex[optPointer] = playerSongSubMenuChartIndex[optPointer] - 1;
			end;
		end;

		if playerSongSubMenuChartIndex[optPointerPlayer] > 21 then
			local activePage = math.floor(playerSongSubMenuChartIndex[optPointerPlayer] / 21) + 1;
			
			if (playerSongSubMenuChartIndex[optPointerPlayer] % 21) == 0 then
				activePage = activePage - 1;
			end;

			if activePage ~= pageActiveSongChartsPlayers[optPointer] then
				pageActiveSongChartsPlayers[optPointer] = activePage;
				updateTableLevelListSongSubMenu(optPointerPlayer);
			end;
		else
			local activePage = math.floor(playerSongSubMenuChartIndex[optPointerPlayer] / 21) + 1;
			if (playerSongSubMenuChartIndex[optPointerPlayer] % 21) == 0 then
				activePage = activePage - 1;
			end;

			if activePage ~= pageActiveSongChartsPlayers[optPointer] then
				pageActiveSongChartsPlayers[optPointer] = activePage;
				updateTableLevelListSongSubMenu(optPointerPlayer);
			end;
		end;
	end;



	function updateTableLevelListSongSubMenu(playerOptPointer)

		if tmpChartsFromSongsPlayers[playerOptPointer] == nil then
			debugMensaje("lista de charts null");
			return;
		end;

		local chartsFromSongSelectedTmp = tmpChartsFromSongsPlayers[playerOptPointer];
		if #chartsFromSongSelectedTmp == 0 then
			return;
		end;

		local chartsToShow = {};

		if pageActiveSongChartsPlayers[playerOptPointer] == 1 then
			indexPageChartPlayers[playerOptPointer] = 1;
		else
			indexPageChartPlayers[playerOptPointer] = (21*(pageActiveSongChartsPlayers[playerOptPointer]-1))+1;
		end;

		local numInserted = 0;	
		for i = indexPageChartPlayers[playerOptPointer], #chartsFromSongSelectedTmp do
			if numInserted == 21 then
				break;
			end;

			table.insert(chartsToShow,chartsFromSongSelectedTmp[i]);
			numInserted = numInserted + 1;
		end;

		local listLevelObjectList;
		if playerOptPointer == 1 then
			listLevelObjectList = listLevelObjectList_p1;
		else
			listLevelObjectList = listLevelObjectList_p2;
		end;

		for i=1,#listLevelObjectList do
			listLevelObjectList[i]:settext("");
		end;

		for i=1,#chartsToShow do
			if i > #listLevelObjectList then
				break;
			end;			

				local levelText = "";
				local meterText = chartsToShow[i]:GetMeter();
				local colorLevel;

				if meterText < 10 then
					meterText = "0"..meterText;
				end;

				if chartsToShow[i]:GetPlayers() ~= 1 then
						levelText = "Cx";
						meterText = chartsToShow[i]:GetPlayers(); 
						colorLevel = colorSet.coop;
				else
					if chartsToShow[i]:GetStepsType() == 'StepsType_Pump_Single' then
						levelText = "S";
						colorLevel = colorSet.single;
						--self:GetChild("levelSongOptionColor"):diffuse(colorSet.single);
					elseif chartsToShow[i]:GetStepsType() == 'StepsType_Pump_Single_P' then
						levelText = "s";
						--self:GetChild("levelSongOptionColor"):diffuse(colorSet.singleperformance);
						colorLevel = colorSet.singleperformance;
					elseif chartsToShow[i]:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						levelText = "H";
						--self:GetChild("levelSongOptionColor"):diffuse(colorSet.halfdouble);	
						colorLevel = colorSet.halfdouble;				
					elseif chartsToShow[i]:GetStepsType() == 'StepsType_Pump_Double' then
						levelText = "D";
						--self:GetChild("levelSongOptionColor"):diffuse(colorSet.double);
						colorLevel = color("#157810");	
					elseif chartsToShow[i]:GetStepsType() == 'StepsType_Pump_Double_P' then	
						levelText = "d";
						--self:GetChild("levelSongOptionColor"):diffuse(colorSet.doubleperformance);
						colorLevel = colorSet.doubleperformance;	
					end;
				end;

	        listLevelObjectList[i]:shadowlength(0.5);
			listLevelObjectList[i]:shadowcolor(colorLevel);
			listLevelObjectList[i]:settext(levelText..meterText);

			--place
			local spotXItem = 0;
			local startLvItem = 0;
			chartsToShowLvListPlayers[playerOptPointer] = #chartsToShow;

			if #chartsToShow > #listLevelObjectList then
				spotXItem = 21;
			else
				spotXItem = #chartsToShow;
			end;
			startLvItem = -8.95 * spotXItem-1;
			listLevelObjectList[i]:x(startLvItem + ((i-1)*18 ))
			movePointerListLevel(playerOptPointer);
			--we adjust the back sprite
			--MESSAGEMAN:Broadcast("ResizeBaseLvList");
		end;

	end;

	function movePointerListLevel(optPlayer)

			local indexPlayer = playerSongSubMenuChartIndex[optPlayer];

			if pageActiveSongChartsPlayers[optPlayer] > 1 then
				indexPlayer  = indexPlayer - (21 * (pageActiveSongChartsPlayers[optPlayer] - 1));
			end;
			local startLvItem = -8.95 * chartsToShowLvListPlayers[optPlayer]-1;
			pointersPlayerLevelList[optPlayer]:x(startLvItem + ((indexPlayer-1)*18 )):addx(7);
	end;

	function setSizeLvListBack(optPlayer)

		local zoomx = 0;
		if chartsToShowLvListPlayers[optPlayer] >= 19 then
			zoomx = 400;
		elseif chartsToShowLvListPlayers[optPlayer] >= 16 then
			zoomx = 330;
		elseif chartsToShowLvListPlayers[optPlayer] >= 13 then
			zoomx = 280;
		elseif chartsToShowLvListPlayers[optPlayer] >= 7 then
			zoomx = 240;
		elseif chartsToShowLvListPlayers[optPlayer] >3 then
			zoomx = 180;
		elseif chartsToShowLvListPlayers[optPlayer] <= 3 then
			zoomx = 140;
		end;

		backLvListvObject[optPlayer]:GetChild("baseGlowLvList"):zoomto(zoomx,24);
		backLvListvObject[optPlayer]:GetChild("baseLvList"):zoomto(zoomx,22);
	end;

	local songSubMenuLevelInfoYBase=86;

	local songSubMenuActorFrame = Def.ActorFrame{
		Name="songSubMenu";
		OnCommand=function(self)
			self:y(-80);
			self:visible(false);
			subMenuObjectRegister["songSubMenu"] = self; -- we want to register this object.

			if optPointerPlayer == 1 then
				subMenuObjectRegister_p1["songSubMenu"] = self; -- we want to register this object.
			else
				subMenuObjectRegister_p2["songSubMenu"] = self; -- we want to register this object.
			end;
		end;


		CodeMessageCommand=function(self, params)

			if params.PlayerNumber == player and player_on_option[optPointerPlayer] == true and menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "songs" then

				if params.Name == "UpLeft" then
					--MESSAGEMAN:Broadcast("leftUpArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("ulArrowAction"):queuecommand("leftUpArrowSongSubMovement");
				end;

				if params.Name == "UpRight" then
					--MESSAGEMAN:Broadcast("rightUpArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("urArrowAction"):queuecommand("rightUpArrowSongSubMovement");
				end;

				if params.Name == "UpRight" or params.Name == "UpLeft" then					
					--here if we are in the first floor (1), we close and go back to the main menu.
					if playerSongSubMenuStatus[optPointerPlayer] == 1 then
						playerSongSubMenuStatus[optPointerPlayer] = 0;
						playerSongSubMenuSongIndex[optPointerPlayer] = 1;
						player_on_option[optPointerPlayer] = false;
						player_submenu_opt[optPointerPlayer] = "";
						MESSAGEMAN:Broadcast("playMenuINOUT");
						self:visible(false);
					end;

					if playerSongSubMenuStatus[optPointerPlayer] == 2 then

						pageActiveSongChartsPlayers[optPointerPlayer] = 1;
						indexPageChartPlayers[optPointerPlayer] = 1 ;


						playerSongSubMenuStatus[optPointerPlayer] = 1;
						self:GetChild("ArrowsSelector"):y(arrowPosSongSubMenu[1]);
						playerSongSubMenuSongIndex[optPointerPlayer] = 1;
					end;

					if playerSongSubMenuStatus[optPointerPlayer] == 3 then

						pageActiveSongChartsPlayers[optPointerPlayer] = 1;						
						indexPageChartPlayers[optPointerPlayer] = 1 ;

						self:GetChild("ArrowsSelector"):GetChild("helpActionCenterText"):settext(getNonstopCenterText("songSubCenterSelect"));
						playerSongSubMenuStatus[optPointerPlayer] = 2;
						self:GetChild("ArrowsSelector"):y(arrowPosSongSubMenu[2]);
					end;

				end;


				if params.Name == "Center" then
					if playerSongSubMenuStatus[optPointerPlayer] == 1 then
						self:GetChild("ArrowsSelector"):GetChild("helpActionCenterText"):settext(getNonstopCenterText("songSubCenterSelect"));
						playerSongSubMenuStatus[optPointerPlayer] = 2;
						self:GetChild("ArrowsSelector"):y(arrowPosSongSubMenu[2]);
						MESSAGEMAN:Broadcast("playMenuSET");

					elseif playerSongSubMenuStatus[optPointerPlayer] == 2 then						
						self:GetChild("ArrowsSelector"):GetChild("helpActionCenterText"):settext(getNonstopCenterText("songSubCenterAdd"));
						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						playerSongSubMenuStatus[optPointerPlayer] = 3;
						self:GetChild("ArrowsSelector"):y(arrowPosSongSubMenu[3]);
						MESSAGEMAN:Broadcast("playMenuSET");

					elseif playerSongSubMenuStatus[optPointerPlayer] == 3 then
						self:GetChild("ArrowsSelector"):GetChild("helpActionCenterText"):settext(getNonstopCenterText("songSubCenterSelect"));
						debugMensaje("__----->SAVE SONG SELECTED")
						local stepSelectedPlayer = tmpChartsFromSongsPlayers[optPointerPlayer][playerSongSubMenuChartIndex[optPointerPlayer]];
						addSongsNonstopCenter(stepSelectedPlayer);
						MESSAGEMAN:Broadcast("playMenuSET");

						pageActiveSongChartsPlayers[optPointerPlayer] = 1;						
						indexPageChartPlayers[optPointerPlayer] = 1 ;

						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						playerSongSubMenuStatus[optPointerPlayer] = 2;
						self:GetChild("ArrowsSelector"):y(arrowPosSongSubMenu[2]);
						movePointerListLevel(optPointerPlayer);
						self:stoptweening():queuecommand("ChangeSelectedSteps");
						MESSAGEMAN:Broadcast("UpdateTimeNonstop");
						MESSAGEMAN:Broadcast("CheckChangeForItem");
					end;

					MESSAGEMAN:Broadcast("SelectAniSubMovement");
					--entering the first time.
					if playerSongSubMenuStatus[optPointerPlayer] == 0 then
						playerSongSubMenuStatus[optPointerPlayer] = 1;
						self:GetChild("ArrowsSelector"):GetChild("helpActionCenterText"):settext(getNonstopCenterText("songSubCenterSelect"));
					end;
				end;


				if params.Name == "DownLeft" then
					--we move groups
					if playerSongSubMenuStatus[optPointerPlayer] == 1 then
						moveGroupIndexPlayerSongMenu(-1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						self:stoptweening():queuecommand("ChangeSongGroup");
					end;
					--we move songs
					if playerSongSubMenuStatus[optPointerPlayer] == 2 then

						pageActiveSongChartsPlayers[optPointerPlayer] = 1;						
						indexPageChartPlayers[optPointerPlayer] = 1 ;

						moveSongIndexPlayerSongMenu(-1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						self:stoptweening():queuecommand("ChangeSelectedSong");
					end;			
					--we move steps
					if playerSongSubMenuStatus[optPointerPlayer] == 3 then
						moveChartIndexPlayer(-1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						self:stoptweening():queuecommand("ChangeSelectedSteps");
					end;
					--MESSAGEMAN:Broadcast("playMenuMove");
					--MESSAGEMAN:Broadcast("leftArrowSongSubMovement");

					self:GetChild("ArrowsSelector"):GetChild("leftArrow"):queuecommand("leftArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("dlArrowAction"):queuecommand("leftArrowSongSubMovement");

				end;

				if params.Name == "DownRight" then
					--we move groups
					if playerSongSubMenuStatus[optPointerPlayer] == 1 then
						moveGroupIndexPlayerSongMenu(1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						self:stoptweening():queuecommand("ChangeSongGroup");
					end;
					--we move songs
					if playerSongSubMenuStatus[optPointerPlayer] == 2 then

						pageActiveSongChartsPlayers[optPointerPlayer] = 1;						
						indexPageChartPlayers[optPointerPlayer] = 1 ;

						moveSongIndexPlayerSongMenu(1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						playerSongSubMenuChartIndex[optPointerPlayer] = 1;
						self:stoptweening():queuecommand("ChangeSelectedSong");
					end;			
					--we move steps
					if playerSongSubMenuStatus[optPointerPlayer] == 3 then
						moveChartIndexPlayer(1,optPointerPlayer);
						movePointerListLevel(optPointerPlayer);
						self:stoptweening():queuecommand("ChangeSelectedSteps");

					end;	
					--MESSAGEMAN:Broadcast("playMenuMove");
					--MESSAGEMAN:Broadcast("rightArrowSongSubMovement");
					self:GetChild("ArrowsSelector"):GetChild("rightArrow"):queuecommand("rightArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("drArrowAction"):queuecommand("rightArrowSongSubMovement");
				end;
			end;
		end;

		ShowSubMenuCommand=function(self)
			self:visible(true);
		end;
		HideSubMenuCommand=function(self)
			
		end;

		enterOptionCommand=function(self)
			self:queuecommand("ChangeSongGroup");

		end;

		ChangeSongGroupCommand=function(self)
				self:GetChild("groupNameSongOption"):stoptweening():settext(songGroupList[songGroupPlayer[optPointerPlayer]]);			
				local groupBanner = SONGMAN:GetSongGroupBannerPath(songGroupList[songGroupPlayer[optPointerPlayer]]);
				self:GetChild("groupBanner"):stoptweening():LoadFromCachedBanner(groupBanner);

				--fix 2 players
				songSubMenuTmpGroupSelectPlayers[optPointerPlayer] = songGroupList[songGroupPlayer[optPointerPlayer]]; 
				--allSongsOnGroupSelectedTmpPlayers[optPointerPlayer] = SONGMAN:GetSongsInGroup(songGroupList[songGroupPlayer[optPointerPlayer]]);
				allSongsOnGroupSelectedTmpPlayers[optPointerPlayer] = processSongList(songGroupList[songGroupPlayer[optPointerPlayer]]);

				songSubMenuSelectedPlayers[optPointerPlayer] = allSongsOnGroupSelectedTmpPlayers[optPointerPlayer][playerSongSubMenuSongIndex[optPointerPlayer]];

				local bannerNewPath = GetBannerSong(songSubMenuSelectedPlayers[optPointerPlayer]);
				self:GetChild("songBanner"):stoptweening():LoadFromCachedBanner(bannerNewPath["bpath"]);
				self:GetChild("nameSongOption"):settext(songSubMenuSelectedPlayers[optPointerPlayer]:GetDisplayMainTitle());

				local allStepsFromSong = songSubMenuSelectedPlayers[optPointerPlayer]:GetAllSteps();
				tmpChartsFromSongsPlayers[optPointerPlayer] = sortChartFromSong(allStepsFromSong);
				updateTableLevelListSongSubMenu(optPointerPlayer);
				setSizeLvListBack(optPointerPlayer);

				local firstStep = allStepsFromSong[1];
				local levelText = "";
				local meterText = normalizeMeterSong(firstStep:GetMeter());

				if firstStep:GetPlayers() ~= 1 then
						levelText = "C";
						levelNumber = firstStep:GetPlayers(); 
				else
					if firstStep:GetStepsType() == 'StepsType_Pump_Single' then
						levelText = "S";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.single);
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						levelText = "SP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.singleperformance);					
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						levelText = "H";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.halfdouble);					
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Double' then
						levelText = "D";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.double);
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Double_P' then	
						levelText = "DP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.doubleperformance);
					end;
				end;

				self:GetChild("levelSongOption"):settext(levelText..meterText);
				self:GetChild("levelSongOptionColor"):settext(levelText..meterText);
				self:GetChild("stepartistSongOption"):settext(firstStep:GetAuthorCredit());
	 			self:GetChild("chartNameSongOption"):settext(firstStep:GetChartName());
		end;

		ChangeSelectedSongCommand=function(self)
				local songSelected = allSongsOnGroupSelectedTmpPlayers[optPointerPlayer][playerSongSubMenuSongIndex[optPointerPlayer]];
				local bannerNewPath = GetBannerSong(songSelected);
				self:GetChild("songBanner"):stoptweening():LoadFromCachedBanner(bannerNewPath["bpath"]);
				self:GetChild("nameSongOption"):settext(songSelected:GetDisplayMainTitle());
				songSubMenuSelectedPlayers[optPointerPlayer] = songSelected;
				playerSongSubMenuChartIndex[optPointerPlayer] = 1;

				local allStepsFromSong = songSelected:GetAllSteps();
				tmpChartsFromSongsPlayers[optPointerPlayer] = sortChartFromSong(allStepsFromSong);
				updateTableLevelListSongSubMenu(optPointerPlayer);
				setSizeLvListBack(optPointerPlayer);

				local firstStep = tmpChartsFromSongsPlayers[optPointerPlayer][1];
				local levelText = "";
				local meterText = normalizeMeterSong(firstStep:GetMeter());

				if firstStep:GetPlayers() ~= 1 then
						levelText = "C";
						levelNumber = firstStep:GetPlayers(); 
				else
					if firstStep:GetStepsType() == 'StepsType_Pump_Single' then
						levelText = "S";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.single);
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						levelText = "SP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.singleperformance);					
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						levelText = "H";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.halfdouble);					
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Double' then
						levelText = "D";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.double);
					elseif firstStep:GetStepsType() == 'StepsType_Pump_Double_P' then	
						levelText = "DP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.doubleperformance);
					end;
				end;

				self:GetChild("levelSongOption"):settext(levelText..meterText);
				self:GetChild("levelSongOptionColor"):settext(levelText..meterText);
				self:GetChild("stepartistSongOption"):settext(firstStep:GetAuthorCredit());
	 			self:GetChild("chartNameSongOption"):settext(firstStep:GetChartName());
		end;

		ChangeSelectedStepsCommand=function(self)
				local stepSelected = tmpChartsFromSongsPlayers[optPointerPlayer][playerSongSubMenuChartIndex[optPointerPlayer]];
				local levelText = "";
				local meterText = normalizeMeterSong(stepSelected:GetMeter());

				if stepSelected:GetPlayers() ~= 1 then
						levelText = "COOPx";
						meterText = stepSelected:GetPlayers(); 
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.coop);
				else
					if stepSelected:GetStepsType() == 'StepsType_Pump_Single' then
						levelText = "S";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.single);
					elseif stepSelected:GetStepsType() == 'StepsType_Pump_Single_P' then
						levelText = "SP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.singleperformance);					
					elseif stepSelected:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						levelText = "H";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.halfdouble);					
					elseif stepSelected:GetStepsType() == 'StepsType_Pump_Double' then
						levelText = "D";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.double);
					elseif stepSelected:GetStepsType() == 'StepsType_Pump_Double_P' then	
						levelText = "DP";
						self:GetChild("levelSongOptionColor"):diffuse(colorSet.doubleperformance);
					end;
				end;

				self:GetChild("levelSongOption"):settext(levelText..meterText);
				self:GetChild("levelSongOptionColor"):settext(levelText..meterText);
				self:GetChild("stepartistSongOption"):settext(stepSelected:GetAuthorCredit());
	 			self:GetChild("chartNameSongOption"):settext(stepSelected:GetChartName());
		end;


		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/base_suboption") )..{
				OnCommand=function(self)
					self:zoom(0.6);
					self:zoomy(0.78);
					self:y(22);
				end;
		};


		--ARROWS
		Def.ActorFrame{
			Name="ArrowsSelector";
			OnCommand=function(self)
				self:y(arrowPosSongSubMenu[1]);
			end;


			Def.Quad {		
			Name="baseGlowLvList";
				OnCommand=function(self)
					self:x(0);
					self:zoomto(300,25);
					self:diffuse(color("#0894ff"));
					self:blend("BlendMode_Add");
					self:fadeleft(0.9);
					self:faderight(0.9);
					self:diffusealpha(0.3);
				end;
				SelectAniSubMovementMessageCommand=function(self)
					--self:linear(0.05);
					self:zoomto(300,50);
					self:linear(0.05);
					self:zoomto(300,25);
				end;
			};

			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/ws_left") )..{
					Name="leftArrow";
					OnCommand=function(self)
						self:zoom(0.4);
						self:x(-100);
						self:blend("BlendMode_Add");
					end;
					leftArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:x(-105);
						self:linear(0.05);
						self:x(-100);
					end;

			};

			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/ws_left") )..{
					Name="rightArrow";
					OnCommand=function(self)
						self:zoom(0.4);
						self:x(100);
						self:rotationy(180);
						self:blend("BlendMode_Add");
					end;
					rightArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:x(105);
						self:linear(0.05);
						self:x(100);
					end;
			};

			--help center step.
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/helpCenter") )..{
					Name="helpActionCenter";
					OnCommand=function(self)
						self:zoom(0.5);
						self:zoomx(0.62);
						self:y(-7);
						if optPointerPlayer == 1 then 
							self:x(-200);
						else
							self:x(200);
						end;
						
						self:queuecommand("ani");
					end;
					OffCommand=function(self)
						self:stoptweening():linear(0.15):diffusealpha(0);
					end;
			};


			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/centerStep") )..{
					Name="helpActionCenter";
					OnCommand=function(self)
						self:zoom(0.5);
						if optPointerPlayer == 1 then 
							self:x(-200);
						else
							self:x(200);
						end;
						
						self:queuecommand("ani");
					end;
					aniCommand=function(self)
						self:linear(0.5);
						self:y(2);
						self:linear(0.5);
						self:y(0);						
						self:queuecommand("ani");

					end;
					OffCommand=function(self)
						self:stoptweening():linear(0.15):diffusealpha(0);
					end;
			};

			LoadFont("_myriad pro")..{
				Name="helpActionCenterText";
				OnCommand=function(self)
					self:y(-16);
					if optPointerPlayer == 1 then 
						self:x(-200);
					else
						self:x(200);
					end;
					self:zoom(0.6);
					self:horizalign("center");
			        self:shadowlength(1.2);
			        self:shadowcolor(0,0,0,1);
					self:maxwidth(400);

					local lang=PREFSMAN:GetPreference('Language');
					if lang == "es" or lang == "pt" then
						self:zoom(0.48);
					end;

				end;
			};

		};


		-- GROUP
		Def.Quad {		
			Name="bgGroup";
			OnCommand=function(self)
				self:x(0);
				self:y(-94);
				self:zoomto(40,35);
				self:diffuse(color("#4a4a4a"));
			end;
		};

		Def.ActorFrame {
			Name="arrowsActionsBase";
			OnCommand=function(self)
			end;
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="ulArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(-145);
						self:y(-103);
						self:animate(false);
						self:setstate(0);
					end;
					leftUpArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="urArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(145);
						self:y(-103);
						self:animate(false);
						self:setstate(1);
					end;
					rightUpArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="dlArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(-145);
						self:y(147);
						self:animate(false);
						self:setstate(2);
					end;
					leftArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="drArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(145);
						self:y(147);
						self:animate(false);
						self:setstate(3);
					end;
					rightArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};

		};


		Def.Banner {	
			Name="groupBanner";	--banner standard,
			InitCommand=cmd(scaletoclipped,45,45;xy,0,-94;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};

		LoadFont("_myriad pro")..{
			Name="groupNameSongOption";
			OnCommand=function(self)
				self:y(-65);
				self:zoom(0.75);
				self:x(0);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};

		--SONG
		Def.Quad {		
			Name="bgSong";
			OnCommand=function(self)
				self:x(0);
				self:y(-25);
				self:zoomto(90,55);
				self:diffuse(color("#4a4a4a"));
			end;
		};

		Def.Banner {	
			Name="songBanner";	--banner standard,
			InitCommand=cmd(scaletoclipped,100,64;xy,0,-22;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};

		LoadFont("_TitleXolonium")..{
			Name="nameSongOption";
			OnCommand=function(self)
				self:y(24);
				self:zoom(0.55);
				self:x(0);
				self:horizalign("center");
				self:maxwidth(400);
			end;
		};

		--LEVEL
		LoadFont("_TitleXolonium")..{
			Name="levelSongOptionColor";
			OnCommand=function(self)
				self:y(songSubMenuLevelInfoYBase+2);
				self:zoom(1);
				self:x(2);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="levelSongOption";
			OnCommand=function(self)
				self:y(songSubMenuLevelInfoYBase);
				self:zoom(1);
				self:x(0);
			        self:shadowlength(0.95);
			        self:shadowcolor(0,0,0,1);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};


		LoadFont("_myriad pro")..{
			Name="stepartistText";
			Text="STEP ARTIST";
			OnCommand=function(self)
				self:y(songSubMenuLevelInfoYBase+28);
				self:zoom(0.65);
				self:x(0);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};
		LoadFont("_myriad pro")..{
			Name="stepartistSongOption";
			OnCommand=function(self)
				self:y(songSubMenuLevelInfoYBase+43);
				self:zoom(0.65);
				self:x(0);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};
		LoadFont("_myriad pro")..{
			Name="chartNameSongOption";
			OnCommand=function(self)
				self:y(songSubMenuLevelInfoYBase+58);
				self:zoom(0.65);
				self:x(0);
				self:horizalign("center");
				self:maxwidth(200);
			end;
		};

	};


	function getZoomByNumOfItemsLevelListBase()
		if chartsToShowLevelList >= 19 then
			return 400;
		elseif chartsToShowLevelList >= 16 then
			return 330;
		elseif chartsToShowLevelList >= 13 then
			return 280;
		elseif chartsToShowLevelList >= 7 then
			return 240;
		elseif chartsToShowLevelList >3 then
			return 180;
		elseif chartsToShowLevelList <= 3 then
			return 140;
		end;
	end;

	local tableLevelSongSubMenu = Def.ActorFrame{
		Name="tableLevelSongSubmenu";
		OnCommand=function(self)
			self:y(14);
			if optPointerPlayer == 1 then
				backLvListvObject[1] = self;
			else
				backLvListvObject[2] = self;
			end;
		end;	

		Def.Quad {		
			Name="baseGlowLvList";
			OnCommand=function(self)
				self:x(0);
				self:y(38);
				self:zoomto(400,28);
				self:diffuse(color("#0894ff"));
				self:fadeleft(0.25);
				self:faderight(0.25);
			end;
		};

		Def.Quad {		
			Name="baseLvList";
			OnCommand=function(self)
				self:x(0);
				self:y(38);
				self:zoomto(400,20);
				self:diffuse(color("#000000"));
				self:fadeleft(0.15);
				self:faderight(0.15);
			end;
		};

		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/lvlistPointer") )..{
				Name="pointerLvList";
				OnCommand=function(self)
					self:zoom(0.38);
					self:spin();
					self:x(0);
					self:y(38);

					if optPointerPlayer == 1 then
						pointersPlayerLevelList[1] = self;
					else
						pointersPlayerLevelList[2] = self;
					end;

				end;
		};
	};

	for i=1,21 do
	tableLevelSongSubMenu[#tableLevelSongSubMenu+1] = LoadFont("_myriad pro")..{
			Name="lvObjectSong_"..i;			
			OnCommand=function(self)
				self:y(38);
				self:zoom(0.46);
				self:x(-188 + ( (i-1)*18 ));
				self:horizalign("left");
				self:maxwidth(200);
				self:settext("-");

				if optPointerPlayer == 1 then
					table.insert(listLevelObjectList_p1,self);
				else
					table.insert(listLevelObjectList_p2,self);
				end;

				--table.insert(listLevelObjectList,self);
			end;
		};
	end;


	songSubMenuActorFrame[#songSubMenuActorFrame+1] = tableLevelSongSubMenu;

	bodyActorFrame[#bodyActorFrame+1] = songSubMenuActorFrame;



	--********************
	--LIST OPTION SUB-MENU
	--********************

	--********************
	--READY SUB-MENU
	--********************
	local readySubMenuActorFrame = Def.ActorFrame{
		Name="readySubMenu";
		OnCommand=function(self)
			self:y(-80);
			self:visible(false);
			subMenuObjectRegister["readySubMenu"] = self; -- we want to register this object.

			if optPointerPlayer == 1 then
				subMenuObjectRegister_p1["readySubMenu"] = self; -- we want to register this object.
			else
				subMenuObjectRegister_p2["readySubMenu"] = self; -- we want to register this object.
			end;

		end;

		checkReadyPlayersMessageCommand=function(self)
			if playerReadyToPlay[1] == false and playerReadyToPlay[2] then
				self:GetChild("AlertReadyPlayersActor"):visible(true);
			elseif playerReadyToPlay[1] and playerReadyToPlay[2] == false then
				self:GetChild("AlertReadyPlayersActor"):visible(true);
			elseif playerReadyToPlay[1] == false and playerReadyToPlay[2] == false then
				self:GetChild("AlertReadyPlayersActor"):visible(true);
			else
				self:GetChild("AlertReadyPlayersActor"):visible(false);
			end;
		end;

		CodeMessageCommand=function(self, params)

			if params.PlayerNumber == player and player_on_option[optPointerPlayer] == true and menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "ready" then

				--[[
				if params.Name == "UpLeft" then
					--MESSAGEMAN:Broadcast("leftUpArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("ulArrowAction"):queuecommand("leftUpArrowSongSubMovement");
				end;

				if params.Name == "UpRight" then
					--MESSAGEMAN:Broadcast("rightUpArrowSongSubMovement");
					self:GetChild("arrowsActionsBase"):GetChild("urArrowAction"):queuecommand("rightUpArrowSongSubMovement");
				end;
				]]

				if params.Name == "UpRight" or params.Name == "UpLeft" then	
					playerReadyToPlay[optPointerPlayer] = false;
					player_on_option[optPointerPlayer] = false;
					player_submenu_opt[optPointerPlayer] = "";
					MESSAGEMAN:Broadcast("playMenuINOUT");
					self:visible(false);

					if GAMESTATE:GetNumSidesJoined() == 2 then
						MESSAGEMAN:Broadcast("checkStatusForAllPlayer");
					end;
				end;


				if params.Name == "Center" then
					MESSAGEMAN:Broadcast("checkSongSelectedAlertReady");

					if GAMESTATE:GetNumSidesJoined() == 2 then							
							--2 PLAYERS							
							MESSAGEMAN:Broadcast("checkStatusForAllPlayer");

							if playerReadyToPlay[1] == false and playerReadyToPlay[2] then								
								--return;
							elseif playerReadyToPlay[1] and playerReadyToPlay[2] == false then
								--return;
							elseif playerReadyToPlay[1] == false and playerReadyToPlay[2] == false then
								--return;
							elseif playerReadyToPlay[1] and playerReadyToPlay[2] then

								if getNumSongRegisteredNonstopCenter() == 0 then
									return;
								end;

								MESSAGEMAN:Broadcast("readyStartSound");
								MESSAGEMAN:Broadcast("startExit");
								self:sleep(1.8);
								self:queuecommand("startGame");

							end;

							if playerReadyToPlay[optPointerPlayer] == false then
								playerReadyToPlay[optPointerPlayer] = true;
							end;
							MESSAGEMAN:Broadcast("checkStatusForAllPlayer");

					else
							--SINGLE PLAYER
							if playerReadyToPlay[optPointerPlayer] then

								if getNumSongRegisteredNonstopCenter() == 0 then
									return;
								end;

								MESSAGEMAN:Broadcast("readyStartSound");
								MESSAGEMAN:Broadcast("startExit");
								self:sleep(1.8);
								self:queuecommand("startGame");

							else
								--first enter. we put the player ready.
								playerReadyToPlay[optPointerPlayer] = true;
							end;
					end;

				end;


			end;

		end;

		startGameCommand=function(self)
			--here we save the speeds of the players!
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
				local avP1 = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred'):MMod();

				if avP1 == nil then
					--speed
					local xP1 = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Preferred' ):XMod();
					setSpeedNonstopCenterMode(PLAYER_1,xP1);
				else
					--av
					setAvSpeedNonstopCenterMode(PLAYER_1,avP1);
				end;

			end;
			if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
				local avP2 = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred'):MMod();
				if avP2 == nil then
					--speed
					local xP2 = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Preferred' ):XMod();					
					setSpeedNonstopCenterMode(PLAYER_2,xP2);
				else
					--av
					setAvSpeedNonstopCenterMode(PLAYER_2,avP2);
				end;

			end;

			setGameplayNonstopCenter();
			startGameplayNonstopCenter();
		end;

		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/base_suboption") )..{
			OnCommand=function(self)
				self:zoom(0.6);
				self:zoomy(0.4);
				self:y(22);
			end;
		};

		Def.ActorFrame {
			Name="arrowsActionsBase";
			OnCommand=function(self)
			end;
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="ulArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(-145);
						self:y(-35);
						self:animate(false);
						self:setstate(0);
					end;
					leftUpArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/arrowsActions 1x4") )..{
					Name="urArrowAction";
					OnCommand=function(self)
						self:zoom(0.5);
						self:x(145);
						self:y(-35);
						self:animate(false);
						self:setstate(1);
					end;
					rightUpArrowSongSubMovementCommand=function(self)
						self:stoptweening();
						self:linear(0.05);
						self:zoom(0.55);
						self:linear(0.05);
						self:zoom(0.5);
					end;
			};

		};


		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/ReadyPlayer") )..{
			OnCommand=function(self)
				self:zoom(0.6);
				self:y(10);
			end;
		};

		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/ReadyPlayer") )..{
			OnCommand=function(self)
				self:zoom(0.6);
				self:y(10);
				self:blend("BlendMode_Add");

				self:diffuseblink()
				    :effectcolor1(1,1,1,1) -- visible
				    :effectcolor2(1,1,1,0) -- invisible
				    :effectperiod(0.025);

			end;
			OffCommand=function(self)
				self:stoptweening():linear(0.15):diffusealpha(0);
			end;
		};

		LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/centerStep") )..{
			OnCommand=function(self)
				self:zoom(0.8);
				self:y(22);
				self:queuecommand("ani");
			end;
			aniCommand=function(self)
				self:linear(0.2);
				self:y(55);
				self:linear(0.2);
				self:y(52);						
				self:queuecommand("ani");

			end;
			OffCommand=function(self)
				self:stoptweening():linear(0.15):diffusealpha(0);
			end;
		};

		Def.ActorFrame{
			Name="AlertReadyPlayersActor";
			OnCommand=function(self)
				self:y(20);
				self:visible(false);
			end;

			checkStatusForAllPlayerMessageCommand=function(self)
				if playerReadyToPlay[1] == false and playerReadyToPlay[2] then
					self:visible(true);
					return;

				elseif playerReadyToPlay[1] and playerReadyToPlay[2] == false then
					self:visible(true);
					return;

				elseif playerReadyToPlay[1] == false and playerReadyToPlay[2] == false then
					self:visible(true);
					return;
				elseif playerReadyToPlay[1] and playerReadyToPlay[2] then
					self:visible(false);
					return;
				end;
			end;

			Def.Quad {		
				OnCommand=function(self)
					self:zoomto(340,30);
					self:diffuse(color("#000000"));
					self:fadeleft(0.25);
					self:faderight(0.25);
					self:diffusealpha(0.9);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="textAlertReady";
				OnCommand=function(self)
					self:zoom(0.5);
					self:horizalign("center");
					self:maxwidth(550);
					self:settext(getNonstopCenterText("readySubCenterAlert"));
				end;
			};
		};


		Def.ActorFrame{
			Name="noSongSelectedFrame";
			OnCommand=function(self)
				self:y(20);
				self:visible(false);
			end;

			checkSongSelectedAlertReadyMessageCommand=function(self)
				if getNumSongRegisteredNonstopCenter() == 0 then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;

			Def.Quad {		
				OnCommand=function(self)
					self:zoomto(340,30);
					self:diffuse(color("#ff0000"));
					self:fadeleft(0.25);
					self:faderight(0.25);
					self:diffusealpha(0.9);

					self:diffuseblink()
				    :effectcolor1(1,0,0,0.65) -- visible
				    :effectcolor2(1,1,1,0) -- invisible
				    :effectperiod(0.1);

				end;

				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;

			};

			Def.Quad {		
				OnCommand=function(self)
					self:zoomto(340,30);
					self:diffuse(color("#000000"));
					self:fadeleft(0.3);
					self:faderight(0.3);
					self:diffusealpha(0.9);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="textAlertReadyNoSong";
				OnCommand=function(self)
					self:zoom(0.5);
					self:horizalign("center");
					self:maxwidth(550);
					self:settext(getNonstopCenterText("readySubCenterSongAlert"));
				end;
			};
		};

	};

	bodyActorFrame[#bodyActorFrame+1] = readySubMenuActorFrame;

	--********************
	-- EXIT SUB-MENU
	--********************
	--here we just exit xD
	local exitSubMenuActorFrame = Def.ActorFrame{
		CodeMessageCommand=function(self, params)
			if params.PlayerNumber == player  and menu_BaseOptions[player_opt[optPointerPlayer]]["name"] == "exit" then
				if params.Name == "Center" then
					MESSAGEMAN:Broadcast("playMenuINOUT");
					MESSAGEMAN:Broadcast("startExit");
					self:sleep(0.5);
					self:queuecommand("exitGameMode");
				end;
			end;

		end;

		exitGameModeCommand=function(self)
			goBackFromNonstopCenter();
		end;
	};

	bodyActorFrame[#bodyActorFrame+1] = exitSubMenuActorFrame;



	-------------------------
	-- ADD ALL THE CONTAINERS
	-------------------------
	editorActor[#editorActor+1] = headMenuActor;	
	editorActor[#editorActor+1] = bodyActorFrame;
	return editorActor;

end;


-------------------------
-- SONG GRID
-------------------------


function createSongGrid()
	local gridColX = {-450,-150,150,450}
	local gridColYOffset = 84;

	local grid = Def.ActorFrame{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+125);
			self:zoom(1);
		end;

	};

	local actualColProc = 1;
	local tempIndexFor = 1;

	local numSongItems = 12;
	for i=1,numSongItems do

		grid[#grid+1] = Def.ActorFrame{
			Name="song_"..i;
			OnCommand=function(self)
				self:x(gridColX[actualColProc]);
				self:y(gridColYOffset*(tempIndexFor-1));

				songGridObjects["song_"..i] = self;

				if (i % 3) == 0 then
					actualColProc = actualColProc + 1;
					tempIndexFor = 1;
				else
					tempIndexFor = tempIndexFor + 1;
				end;

				self:GetChild("posSkin"):settext(i);
				self:queuecommand("hideObject");
			end;

			-- we check any change to update.
			CheckChangeForItemMessageCommand=function(self)
				local ListOfSongsSelected = ListOfSongsSelectedNonstopCenter(); --nonstopSongSelection[i]
				if ListOfSongsSelected[i] ~= nil then				
					local songBase = SONGMAN:GetSongFromSteps(ListOfSongsSelected[i]);
					local bannerNewPath = GetBannerSong(songBase);

					self:GetChild("songBanner"):stoptweening():LoadFromCachedBanner(bannerNewPath["bpath"]);
					self:GetChild("groupName"):settext(songBase:GetGroupName());
					self:GetChild("songName"):settext(songBase:GetDisplayMainTitle());
					self:GetChild("artistName"):settext(songBase:GetDisplayArtist());


					self:GetChild("stepName"):settext(ListOfSongsSelected[i]:GetChartName());
					self:GetChild("stepArtist"):settext(ListOfSongsSelected[i]:GetAuthorCredit());

					local levelText="";
					local levelNumber = ListOfSongsSelected[i]:GetMeter();

					if ListOfSongsSelected[i]:GetPlayers() ~= 1 then
							levelText = "Cx";
							levelNumber = ListOfSongsSelected[i]:GetPlayers(); 
							self:GetChild("songLevelColor"):diffuse(colorSet.coop);
							self:GetChild("backSong"):setstate(4);
					else
						if ListOfSongsSelected[i]:GetStepsType() == 'StepsType_Pump_Single' then
							levelText = "S";
							self:GetChild("songLevelColor"):diffuse(colorSet.single);
							self:GetChild("backSong"):setstate(1);
						elseif ListOfSongsSelected[i]:GetStepsType() == 'StepsType_Pump_Single_P' then
							levelText = "SP";
							self:GetChild("songLevelColor"):diffuse(colorSet.singleperformance);
							self:GetChild("backSong"):setstate(6);
						elseif ListOfSongsSelected[i]:GetStepsType() == 'StepsType_Pump_Halfdouble' then
							levelText = "H";
							self:GetChild("songLevelColor"):diffuse(colorSet.halfdouble);
							self:GetChild("backSong"):setstate(3);
						elseif ListOfSongsSelected[i]:GetStepsType() == 'StepsType_Pump_Double' then
							levelText = "D";
							self:GetChild("songLevelColor"):diffuse(colorSet.double);
							self:GetChild("backSong"):setstate(2);
						elseif ListOfSongsSelected[i]:GetStepsType() == 'StepsType_Pump_Double_P' then	
							levelText = "DP";
							self:GetChild("songLevelColor"):diffuse(colorSet.doubleperformance);
							self:GetChild("backSong"):setstate(5);
						end;
					end;

					self:GetChild("songLevel"):settext(levelText..levelNumber);
					self:GetChild("songLevelColor"):settext(levelText..levelNumber);
					self:queuecommand("showObject");
				else
					self:queuecommand("hideObject");
				end;
			end;

			hideObjectCommand=function(self)	
				self:GetChild("backSong"):setstate(0);			
				self:GetChild("songBanner"):visible(false);
				self:GetChild("groupName"):visible(false);
				self:GetChild("songName"):visible(false);
				self:GetChild("artistName"):visible(false);

				self:GetChild("songLevel"):visible(false);
				self:GetChild("songLevelColor"):visible(false);

				self:GetChild("stepName"):visible(false);
				self:GetChild("stepArtist"):visible(false);
				self:GetChild("stepArtist_option"):visible(false);

				self:GetChild("posSkin"):visible(false);
			end;

			showObjectCommand=function(self)			
				self:GetChild("songBanner"):visible(true);
				self:GetChild("groupName"):visible(true);
				self:GetChild("songName"):visible(true);
				self:GetChild("artistName"):visible(true);
				self:GetChild("songLevel"):visible(true);
				self:GetChild("songLevelColor"):visible(true);
				self:GetChild("stepName"):visible(true);
				self:GetChild("stepArtist"):visible(true);
				self:GetChild("stepArtist_option"):visible(true);
				self:GetChild("posSkin"):visible(true);
			end;


			--BASE IMAGE
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/stepBase 1x7") )..{
					Name="backSong";
					OnCommand=function(self)
						self:zoom(0.65);
						self:zoomy(0.75);
						self:animate(false);
						self:setstate(0);
					end;
			};

			LoadFont("_TitleXolonium")..{
						Name="posSkin";
						Text="-";
						OnCommand=function(self)
							self:y(-25);
							self:zoom(0.5);
							self:x(-138);
							self:horizalign("right");
						end;
			};

			Def.Quad {		
				OnCommand=function(self)
					self:x(-81);
					self:y(-1);
					self:zoomto(90,64);
					self:diffuse(color("#4a4a4a"));
					--self:fadeleft(0.4);
					--self:faderight(0.4);
				end;
			};

			--BANNER OF THE SONG
			Def.Banner {	
				Name="songBanner";	--banner standard,
				InitCommand=cmd(scaletoclipped,90,60;xy,-80,-1;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};

			--GROUP
			LoadFont("_myriad pro")..{
				Name="groupName";
				Text="-";
				OnCommand=function(self)
					self:y(-27);
					self:zoom(0.4);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songName";
				Text="-";
				OnCommand=function(self)
					self:y(-16);
					self:zoom(0.4);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};
			LoadFont("_TitleXolonium")..{
				Name="artistName";
				Text="-";
				OnCommand=function(self)
					self:y(-5);
					self:zoom(0.25);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songLevelColor";
				Text="-";
				OnCommand=function(self)
					self:y(15);
					self:zoom(0.85);
					self:x(-30);
					self:horizalign("left");
					self:maxwidth(400);
					
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songLevel";
				Text="-";
				OnCommand=function(self)
					self:y(14);
					self:zoom(0.85);
					self:x(-32);

			        self:shadowlength(0.95);
			        self:shadowcolor(0,0,0,1);

					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepName";
				Text="-";
				OnCommand=function(self)
					self:y(5);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(185);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepArtist_option";
				Text="STEP ARTIST:";
				OnCommand=function(self)
					self:y(15);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepArtist";
				Text="-";
				OnCommand=function(self)
					self:y(25);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(185);
				end;
			};


		};


	end;

	return grid;
end;


if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = createNonstopEditor(PLAYER_1);

	t[#t+1] = LoadActor("../ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_1);
		InitCommand=cmd(xy,SCREEN_CENTER_X-608,SCREEN_CENTER_Y-257);
		PlayerJoinedMessageCommand=cmd(queuecommand,"On");
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
	};

end;
if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = createNonstopEditor(PLAYER_2);

	t[#t+1] = LoadActor("../ScreenSelectMusicLua/ScreenSelectMusicModIcons") .. {
		CreateModForPlayer(PLAYER_2);
		InitCommand=cmd(xy,SCREEN_CENTER_X+610,SCREEN_CENTER_Y-257);
		PlayerJoinedMessageCommand=cmd(queuecommand,"On");
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);
	};
end;

t[#t+1] = createSongGrid();

t[#t+1] = Def.Quad{
	Name="OutScreenQuad";
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
		self:diffuse(color("#000000"));
		self:diffusealpha(0);
	end;
	startExitMessageCommand=function(self)
		self:linear(0.14);
		self:diffusealpha(1);
	end;
};




return t;
