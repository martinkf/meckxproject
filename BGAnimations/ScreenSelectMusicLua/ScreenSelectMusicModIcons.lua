local t = Def.ActorFrame {};

local cur_scr;

local function GetCommandTitles()



	local array=
	{
		{name="rank",index=1},
		{name="speed",index=2},
		--{name="display",index=3,customdimension="6x3"},
		{name="display",index=3},
		{name="note skin",index=4},
		{name="path",index=5},
		{name="alternate",index=6},
		{name="judge",index=7},	
		{name="sort",index=8},	
		{name="nouse",index=9},
		{name="info",index=10},
		{name="judgeskin",index=11},
		{name="judgeskinzoom",index=12},
		{name="lifebarskin",index=13},
		{name="lifebarsettings",index=14},
		{name="vsmode",index=15},
		{name="timingadj",index=16},

		--{name="rank",index=1},	
	};



	--companions | we are always the last of the list.
	local companionsInstalled = getNumberOfCompanionInstalled();
	if companionsInstalled > 0 then
		local lastIndexArray = array[#array]["index"];
		table.insert(array,{name="companion",index=lastIndexArray+1});
	end;

	return array;
end;
local function GetModTitles()
	local array=
	{
		{
			{"RANK", command="rank"},
		},
		{
			{command="1x"},
			{command="2x"},
			{command="3x"},
			{command="4x"},
			{command="5x"},
			{command="6x"},
			{command="0.25"},
			{command="0.5"},	
			{command="expand"},
			{command="randomvel"},			
			{command="m550"},
			{command="accel"},
			{command="decel"}
		},
		{
			{command="vanish"},
			{command="appear"},
			{command="nonstep"},
			{command="dark"},
			{command="flash"},
			{command="randomnote"},
			{command="mini"},
			{command="bgaoff"},
			{command="bgaoffrank"},
			{command="bgadark"},
			{command="bgadarkrank"},
			{command="bgapartial"},
			{command="bgapartialrank"},
			{command="footguide"},
		},
		{
			
		},
		{
			{command="xmode"},
			{command="nxmode"},
			{command="underattack"},
			{command="drop"},
			{command="sink"},
			{command="rise"},
			{command="snake"},
			{command="piuzigzag"},
		},
		{
			{command="backwards"},
			{command="supershuffle"},
			{command="mirror"},
		},
		{
			{command="hardjudgement"},
			{command="judgereverse"},
			{command="veryhardjudgement"},
		},
		
		{
			{command="title"},
		},
		{
			-- no use?
		},
		{
			{command="stageinfooptionbasic"},
			{command="stageinfooptionfull"},
			{command="stageinfooptionmax"},			
		},
		{ -- skin judg
			
		},		
		{ -- skin zoom
			
		},
		{ -- lifebar skin

		},
		{ -- lifebar settings
			{command="breakonlifebarc"}
		},
		{ -- vs mode
			{command="vsmode"}
		},
		{
			-- timing adj
		}	


	}

	--companions | we are always the last of the list.
	--only if there is 1 at least.
	local companionsInstalled = getNumberOfCompanionInstalled();
	if companionsInstalled > 0 then
		table.insert(array,{});
	end;

	

	if PREFSMAN:GetPreference('UnlockJudgeCW') then
		table.insert(array[7], {command="extrajudgement",});
		table.insert(array[7], {command="ultrahardjudgement",});
	end;
	table.insert(array[7], {command="0.6",});
	table.insert(array[7], {command="0.7",});
	table.insert(array[7], {command="0.8",});
	table.insert(array[7], {command="0.9",});
	table.insert(array[7], {command="1.1",});
	table.insert(array[7], {command="1.2",});
	table.insert(array[7], {command="1.3",});
	table.insert(array[7], {command="1.4",});
	table.insert(array[7], {command="1.5",});
	table.insert(array[7], {command="1.6",});
	table.insert(array[7], {command="1.7",});
	
	table.insert(array[7], {command="0.6rank",});
	table.insert(array[7], {command="easyjudgement",});
	--[[table.insert(array[7], {command="0.8rank",});
	table.insert(array[7], {command="0.9rank",});
	table.insert(array[7], {command="1.1rank",});
	table.insert(array[7], {command="1.2rank",});
	table.insert(array[7], {command="1.3rank",});
	table.insert(array[7], {command="1.4rank",});
	table.insert(array[7], {command="1.5rank",});]]
	--NoteLabels
	--local notelist = GetNoteSkinList();
	--for x=1,#notelist do
	--	table.insert(array[4], {command=notelist[x],});
	--end;
	
	
	return array;	
end;

local function IsModSelected( index , modTitle , player)
	
	if ( index ~= nil ) then
		if GetCommandTitles()[ index ].name == "note skin" then
			local noteskin = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
			if modTitle ~= noteskin then
				return true;
			end;
		end;
	end;
	
	local GAMEMODE = GAMESTATE:GetGameMode();
	local STATE = GAMESTATE:GetPlayerState(player);
	if GAMEMODE == 'Basic' and modTitle == "basic" then
		return false;
	end;
	
	if modTitle == "" then
		return false;
	end;	
	
	local SONGOPTIONS = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred');
	local STATE = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred');
	--Agregar comprobaciones de nuevas opciones acá.
	--como no tengo acceso a guardar opciones, que sean variables de entorno
	--Esto mismo esta en ScreenSelectMusicModIcons.lua
	-- local playerAfixInfo="";
	-- if player == PLAYER_1 then
	-- 	playerAfixInfo="infop1";			
	-- end;

	-- if player == PLAYER_2 then				
	-- 	playerAfixInfo="infop2";
	-- end;
	-- if modTitle == "stageinfooptionbasic" and STATE:StageInfoOption() == 1 then
	-- 	-- if GAMESTATE:Env()[playerAfixInfo] == 1 then
	-- 	return true;
	-- end;

	-- if modTitle == "stageinfooptionfull" and STATE:StageInfoOption() == 2 then
	-- 	-- if GAMESTATE:Env()[playerAfixInfo] == 2 then
	-- 	return true;
	-- end;

	-- if modTitle == "stageinfooptionmax" and STATE:StageInfoOption() == 3 then
	-- 	-- if GAMESTATE:Env()[playerAfixInfo] == 3 then
	-- 	return true;
	-- end;		

	--fin nuevas comprobaciones.	

	if modTitle == "vsmode" and GAMESTATE:Env()["vsMode"] then
		return true;
	end;

	if modTitle == "title" and GAMESTATE:GetSortTitle() and cur_scr ~= "ScreenEvaluation" then
		return true;
	elseif modTitle == "rank" and GAMESTATE:GetGameMode() == 'Rank' then
		return true;
	elseif modTitle == "bgaoff" and SONGOPTIONS:BgaOff()  then
		return true;
	elseif modTitle == "bgadark" and SONGOPTIONS:BgaDark() then
		return true;
	elseif modTitle == "bgapartial" and SONGOPTIONS:BgaPartial() then
		return true;
	elseif string.lower(modTitle)==string.lower(round2(SONGOPTIONS:MusicRate(),1)) then
		return true;
	end;
	
	if GAMEMODE == 'Rank' and GAMESTATE:IsHumanPlayer(player) and modTitle == "veryhardjudgement" then
		return true;
	end;
	
	if GAMESTATE:IsHumanPlayer(player) and modTitle == "veryhardjudgement" and STATE:VeryHardJudgement() then
		return true;
	end;
	
	if GAMESTATE:IsHumanPlayer(player) and modTitle == "extrajudgement"  and STATE:ExtraJudgement() then
		return true;
	end;
	
	if GAMESTATE:IsHumanPlayer(player) and modTitle == "ultrahardjudgement"  and STATE:UltraHardJudgement() then
		return true;
	end;

	if GAMESTATE:IsHumanPlayer(player) and modTitle == "easyjudgement"  and STATE:EasyJudgement() then
		return true;
	end;
	
	--[[
	for i=1,#statePlayerArray do
		if GAMESTATE:IsHumanPlayer(player) and modTitle == "easyjudgment" and statePlayerArray == "EasyJudgment" then
			return true;
		end;
	end;

	if GAMESTATE:IsHumanPlayer(player) and modTitle == "easyjudgement"  and STATE:EasyJudgement() then		
		return true;
	end;
	]]
	
	if GAMESTATE:IsHumanPlayer(player) and modTitle == "mini" and STATE:Mini() > 0.0 then
		return true;
	end;
	
	if GAMESTATE:IsHumanPlayer(player) and modTitle == "footguide" and STATE:Guide() then
		return true;
	end;
	
	if modTitle == "rise" and STATE:Rise() > 0.0 then
		return true;
	end;
	
	if modTitle == "sink" and STATE:Rise() < 0.0 then
		return true;
	end;
	
	local noX = 0;
	if STATE:XMod() then
		noX = string.gsub(STATE:XMod(),"x","");
	end;
	
	if tonumber(noX) % 1 == .25 then
		if modTitle == "0.25" then
			return true;
		end;	
		
		noX = math.floor(tonumber(noX));
		if tostring(noX).."x" == modTitle then
			return true;
		end;
	elseif tonumber(noX) % 1 == .5 then 	--es decimal
		if modTitle == "0.5" then
			return true;
		end;
		
		noX = math.floor(tonumber(noX));
		if tostring(noX).."x" == modTitle then
			return true;
		end;
	elseif tonumber(noX) % 1 == .75 then 	--es decimal
		if modTitle == "0.25" then
			return true;
		end;
		
		if modTitle == "0.5" then
			return true;
		end;
		
		noX = math.floor(tonumber(noX));
		if tostring(noX).."x" == modTitle then
			return true;
		end;
	end;
	
	if (STATE:RandomVel() or STATE:Expand() == 1) and ( modTitle == "2x" or STATE:MMod() ) then
		return false;
	end;

	
	local mods = GAMESTATE:GetPlayerState(player):GetPlayerOptionsArray( 'ModsLevel_Preferred' );
	for i=1,#mods,1 do
		if string.lower(mods[i]) == string.lower(modTitle) then
			return true;
		end;
	end;
	
	return false;
end;

local xAuxPos = 60;


local function getAVNum(player)
	if GAMESTATE:IsPlayerEnabled(player) then
		local STATE = GAMESTATE:GetPlayerState(player);
		local AV = STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod()
		if AV == nil then return nil; end;
		return AV;
	else
		return nil
	end;
end;

local function getCVNum(player)
	if GAMESTATE:IsPlayerEnabled(player) then
		local STATE = GAMESTATE:GetPlayerState(player);
		local AV = STATE:GetPlayerOptions('ModsLevel_Preferred'):CMod()
		if AV == nil then return nil; end;
		return AV;
	else
		return nil
	end;
end;
				
t[#t+1] =  Def.ActorFrame{
	
	OnCommand=function(self)
		cur_scr = SCREENMAN:GetTopScreen():GetName();
	end;
}

function CreateModForPlayer(player)
	
	t[#t+1] =  Def.ActorFrame{
		SpeedUpMessageCommand=function(self,params)
			if player == params.Player then
				local x = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod();
				local STATE = GAMESTATE:GetPlayerState(player);	
				if STATE:GetPlayerOptions('ModsLevel_Preferred'):IsAvEnabled() > 0 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(1);
					STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod(nil);
					PAVenabled[player] = false;
					MESSAGEMAN:Broadcast("CommandWindowAV", {Player = player} );
					MESSAGEMAN:Broadcast("CodeMod", {Player = params.Player, Command = "speed"} )		
				else
					x = x + 1;				
					if x ~= GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod() then
						if tonumber(x) >= 7 then
							x=1;
						end;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(x)
						MESSAGEMAN:Broadcast("CodeMod", {Player = params.Player, Command = "speed"} )					
					end;
				end;
			end;
		end;
		SpeedDownMessageCommand=function(self,params)
			if player == params.Player then
				local x = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod();
				local STATE = GAMESTATE:GetPlayerState(player);		
				if STATE:GetPlayerOptions('ModsLevel_Preferred'):IsAvEnabled() > 0 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(6);
					STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod(nil);
					PAVenabled[player] = false;
					MESSAGEMAN:Broadcast("CommandWindowAV", {Player = player} );
					MESSAGEMAN:Broadcast("CodeMod", {Player = params.Player, Command = "speed"} )		
				else
					x = x - 1;				
					if x ~= GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod() then
						if tonumber(x) < 1 then
							x=6;
						end;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(x)
						MESSAGEMAN:Broadcast("CodeMod", {Player = params.Player, Command = "speed"} )					
					end;
				end;
			end;
		end;		
	};
	
	t.GlowIconModMessageCommand=function(self, params)
		if params.Player == player and GAMESTATE:IsHumanPlayer(player) then
			local Title = params.Section;
			self:GetChild(Title .. "Glow1"):stoptweening():queuecommand("AnimateAux");
			self:GetChild(Title .. "Glow2"):stoptweening():queuecommand("AnimateAux");
			self:GetChild(Title .. "Glow3"):stoptweening():queuecommand("AnimateAux");
			self:GetChild(Title .. "Glow4"):stoptweening():queuecommand("AnimateAux");
		end;
	end;
	
	t.CheckNoteSkinMessageCommand=function(self, params)
		if (params.Mod == nil) then return; end;
		
		if params.Player == player then
		
			if GetSkinName(player) == NOTESKIN:GetDefaultGameNoteSkin() then
				self:GetChild("noteskin"):Load(nil):visible(false);
				self:GetChild("backnoteskin"):stoptweening():queuecommand("Hide");
			else
				self:GetChild("noteskin"):visible(true):Load(GetNoteSkinLabel(player));
				self:GetChild("noteskin"):setsize(60 ,46);
				self:GetChild("backnoteskin"):visible(true):stoptweening():queuecommand("Show");
			end;
			MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = "note skin" });
		end;
	end;

	for m=1, #GetCommandTitles(), 1  do
		
		local array={};
		local int=1;
		local bool=true;	
		if GetCommandTitles()[m].name == "note skin" then
			
			--meckx note - this is the background asset for the modicon of noteskin if you want to replace it for a quad later
			t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/BackIcon"))..{
				Name="backnoteskin";
				InitCommand=cmd(x, 4 * xAuxPos-1;visible,false);
		
				OnCommand=function(self, params)
					if GAMESTATE:GetGameMode() ~= 'Basic' then
						
						local goVisible = GAMESTATE:IsHumanPlayer(player);
						
						if GAMESTATE:GetCurrentSong() then
							if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST" or GetSkinName(player) == NOTESKIN:GetDefaultGameNoteSkin() then 
								goVisible = false;
							end;
						   
						end;
						
						self:visible( goVisible );
						self:zoom(0.98);
					end;
				end;
				HideCommand=cmd(stoptweening;zoom,1.0625;diffusealpha,1;linear,.25;zoom,0.98;diffusealpha,0);
				ShowCommand=cmd(stoptweening;visible,true;zoom,1.0625;diffusealpha,0.25;linear,.25;zoom,0.98;diffusealpha,1);
				RandomSkinEnabledMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					self:stoptweening():queuecommand("Hide");
		 
				end;
				CommandWindowResetMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					
					if self:GetDiffuseAlpha() ~= 0 then
						self:stoptweening():queuecommand("Hide");
					end;
				end;
	
			};
			
			t[#t+1] = LoadActor(THEME:GetPathG("","_blank"))..{
				Name="noteskin";
				InitCommand=cmd(x, 4 * xAuxPos-1;visible,false);
				OnCommand=function(self, params)
		
							
					if GAMESTATE:GetGameMode() ~= 'Basic' then
						
						local goVisible = GAMESTATE:IsHumanPlayer(player);
						
						if GAMESTATE:GetCurrentSong() then
							if GAMESTATE:GetCurrentSong():GetSpecial() == "QUEST" or GetSkinName(player) == NOTESKIN:GetDefaultGameNoteSkin() then 
								goVisible = false;
							end;
						end;
						
						if goVisible then
							self:Load(GetNoteSkinLabel(player));
							self:setsize(60 ,46);
							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = GetCommandTitles()[m].name});
						end;
						
						self:visible( goVisible );
						self:zoom(0.98);
					end;
				end;

				RandomSkinEnabledMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					
					--if GetSkinName(player) ~= NOTESKIN:GetDefaultGameNoteSkin() then
					self:stoptweening():visible(false);
					MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section ="note skin"});
				end;
				
				CommandWindowResetMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					
					if self:GetVisible() then
						MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section ="note skin"});
					end;
					
					self:stoptweening():visible(false);
				end;
	
			};
		elseif GetCommandTitles()[m].name == "judgeskin" then
		elseif GetCommandTitles()[m].name == "judgeskinzoom" then
		elseif GetCommandTitles()[m].name == "info" then
		elseif GetCommandTitles()[m].name == "lifebarskin" then	
		elseif GetCommandTitles()[m].name == "lifebarsettings" then
		elseif GetCommandTitles()[m].name == "vsmode" then
		elseif GetCommandTitles()[m].name == "timingadj" then
		elseif GetCommandTitles()[m].name == "companion" then
		else
			local FileSprite = "icons0" .. m .. " " .. #GetModTitles()[m] .. "x1";
			if (GetCommandTitles()[m].customdimension ~= nil ) then
				FileSprite = "icons0" .. m .. " " .. GetCommandTitles()[m].customdimension;
			end;
			
			t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/" .. FileSprite ))..{
				Name=GetCommandTitles()[m].name;
				InitCommand=cmd( zoom,0.5;animate,false;x,m * xAuxPos;visible,false);
				OnCommand=function(self)
					self:zoom(0.5);
					if m==3 then self:y(1.3) end
					MESSAGEMAN:Broadcast("FileSprite->".."CommandWindow/".. FileSprite);					
					for i=0, #array do array[i]=nil; end;
					int=1;
					bool=true;
					
					for i=1,#GetModTitles()[m],1 do
						
						if IsModSelected(m, GetModTitles()[m][i].command, player)  then

							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = GetCommandTitles()[m].name });

							if GAMESTATE:GetGameMode() == 'Rank' and (GetModTitles()[m][i].command == "bgaoff" or GetModTitles()[m][i].command == "bgadark" or GetModTitles()[m][i].command == "bgapartial" )  then
								array[#array+1]=i;
							elseif GAMESTATE:GetGameMode() == 'Rank' and 
								(GetModTitles()[m][i].command == "0.6" or 
								GetModTitles()[m][i].command == "0.7" or 
								GetModTitles()[m][i].command == "0.8" or 
								GetModTitles()[m][i].command == "0.9" or 
								GetModTitles()[m][i].command == "1.1" or 
								GetModTitles()[m][i].command == "1.2" or 
								GetModTitles()[m][i].command == "1.3" or 
								GetModTitles()[m][i].command == "1.4" or
								GetModTitles()[m][i].command == "1.5" or
								GetModTitles()[m][i].command == "1.6" or
								GetModTitles()[m][i].command == "1.7") then

								if PREFSMAN:GetPreference('UnlockJudgeCW') then
									array[#array+1]=16;
								else
									array[#array+1]=14;
								end;
								
							else
								array[#array+1]=i-1;
							end;
						else
							MESSAGEMAN:Broadcast("Mod not selected?!->"..GetModTitles()[m][i].command);
						end;
						
					end;
					
					
					int=1;
					
					if #array > 0 then
						self:visible(GAMESTATE:IsHumanPlayer(player));
						self:finishtweening();
						self:queuecommand("loop");
					else
						self:finishtweening();
						self:diffusealpha(0);
					end;
					
				end;
				
				loopCommand=function(self)
					self:finishtweening();	
					self:zoom(0.5);
					if (CHGetCategory(0) ~= "ORIGINAL") and m == 7 and GAMESTATE:GetGameMode() ~= 'Rank' and PREFSMAN:GetPreference("LockRush") then
				
						if array[int] > 1 and  array[int] < 9 then
							self:setstate(array[int] + 8);
						else
							self:setstate(array[int]);
						end;
					else
						self:setstate(array[int]);
						
					end;
						
					

					if bool then
						self:diffusealpha(0.25);
						self:zoom(.2);
						self:linear(0.2);
						self:zoom(.5);
						self:diffusealpha(1);
						bool = false;
					end;
					self:sleep(1);
					int=int+1;
					if int > #array then
						int=1;
					end;		
					self:queuecommand("loop");
				end;
				
				CodeModMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					
					local title = params.Command;
					if title == self:GetName() then
						self:stoptweening():queuecommand("On");

					end;
		 
				end;
				
				CheckSelectedMessageCommand=function(self, params)
					
					if params.Player ~= player then return; end;
					if (params.Mod == nil) then return; end;
					MESSAGEMAN:Broadcast("CheckSelected->Mod->"..params.Mod);
					MESSAGEMAN:Broadcast("CheckSelected->Command->"..params.Command);
					local mod = params.Mod;
					local title = GetCommandTitles()[ params.Command ].name;
					if title == self:GetName() then
						self:stoptweening():queuecommand("On");
					end;
					
					if title == "speed" then
						if mod == "m550" or string.find(mod,"av") then
							return;
						end;
					end;
	
					MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = title });
				end;
				
				ResetRandomSkinMessageCommand=function(self, params)
					if params.Player ~= player then return; end;
					
					if self:GetName() == "display" then
						self:stoptweening():queuecommand("On");
						MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = "display" });
					end;
				end;
				
				ResetBGAMessageCommand=function(self, params)
					if self:GetName() == "display" then
						self:stoptweening():queuecommand("On");
						MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = "display" });
					end;
				end;
				ResetRushMessageCommand=function(self, params)
					if self:GetName() == "judge" then
						self:stoptweening():queuecommand("On");
						MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = "judge" });
		  
					end;
				end;
				
				ResetTitleMessageCommand=function(self, params)

					if self:GetName() == "sort" then
						self:stoptweening():queuecommand("On");
						MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = "sort" });
					end;
				end;
				
				CommandWindowResetMessageCommand=function(self, params)
				
					if params.Player == player then
						
						local name = self:GetName();
						if self:GetDiffuseAlpha() ~= 0 or name == "speed" then
							self:stoptweening():queuecommand("On");
							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = name});
						end;
					end;
					
				end;
				
				GlobalModMessageCommand=function(self, params)
					if GAMESTATE:IsHumanPlayer(player) then
						
						local title = params.Title;
						local mod = params.Mod;
						
						if title == "rush" then title = "judge"; end;
						
						if self:GetName() == title then
							self:stoptweening():queuecommand("On");
							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = title });
						end;
					end;
				end;
				
				RankModeCWMessageCommand=function(self)
					local name = self:GetName();
					
					if name == "rank" or name == "judge" or name == "display" then
						self:stoptweening():queuecommand("On");
						
						if name == "display" and self:GetDiffuseAlpha() ~= 0 then
							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = name});
						end;
					end;
				end;

				FullModeCWMessageCommand=function(self)
					local name = self:GetName();
					if name == "rank" or name == "judge" or name == "display" then
						self:stoptweening():queuecommand("On");
						
						if name == "display" then
							if self:GetDiffuseAlpha() ~= 0 then
								MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = name});
							end;
						else
							MESSAGEMAN:Broadcast("GlowIconMod", {Player = player, Section = name});
						end;
						
					end;
				end;
			};
			
		end;

		
		t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
			Name=GetCommandTitles()[m].name .. "Glow1";
			InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;diffusealpha,0;x,m*xAuxPos);
			AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1;sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
			Name=GetCommandTitles()[m].name .. "Glow2";
			InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;diffusealpha,0;x,m*xAuxPos);
			AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1;sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125);
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
			Name=GetCommandTitles()[m].name .. "Glow3";
			InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;diffusealpha,0;x,m*xAuxPos);
			AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1 - (1*0.5);sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125 + (1*0.2));
		};
		
		t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
			Name=GetCommandTitles()[m].name .. "Glow4";
			InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;diffusealpha,0;x,m*xAuxPos);
			AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1 - (1*0.5);sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125 + (1*0.2));
		};	
		
	end;
	-- ------- VS MODE -------
	t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/Icons20"))..{
		Name="vsmode";
		InitCommand=cmd(visible,true;zoom,0.5);
		OnCommand=function(self)
			self:setstate(0);
			self:animate(false);
			self:visible(false);

			if GAMESTATE:Env()["vsMode"] then
				self:visible(true);
			end;			
		end;

		CheckSelectedMessageCommand=function(self, params)

			if params.Command == nil then return; end;
			local title = GetCommandTitles()[ params.Command ].name;
			if title == "vsmode" then
				if GAMESTATE:Env()["vsMode"] then
					self:visible(true);
				else
					self:visible(false);
				end;	
			end;
		end;

	};

	
	-- ------- AV -------------
  
	t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/AVicon"))..{
		Name="AVBack";
		InitCommand=cmd(visible,false;x,2*xAuxPos;zoom,0.5);
		OnCommand=function(self)
			if getAVNum(player) ~= nil then
				self:diffusealpha(0.25);
				self:zoom(0.5);
				self:linear(0.25);				
				self:diffusealpha(1);
				self:visible(GAMESTATE:IsHumanPlayer(player));	
			else
				self:visible(false);
			end;
		end;
		CheckSelectedMessageCommand=function(self, params)
			self:zoom(0.5);
			if params.Player ~= player then return; end;
			if (params.Mod == nil) then return; end;
			
			local mod = params.Mod;
			local title = GetCommandTitles()[ params.Command ].name;
			

			if title == "speed" then
				if getAVNum(player) then
					self:stoptweening():visible(true);
				else
					self:stoptweening():visible(false);
				end;
			end;

		end;

		CodeModMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			if params.Command == "speed" then
				self:stoptweening():visible(false);
			end;
		end;

		
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:visible(true);
		end;
		CommandWindowResetMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:visible(false);
		end;
	};

	t[#t+1] = LoadFont("interphase/InterNumber numbers").. {
		Name="AVText";
		InitCommand=cmd(visible,false;x,2*xAuxPos - 1;zoom,.42;);
		OnCommand=function(self)
			self:horizalign(center);
			self:y(-5);
			if getAVNum(player) ~= nil then
				self:settext(getAVNum(player));
			else
				self:settext("");
			end;
			self:visible(GAMESTATE:IsHumanPlayer(player));
		end;

		CodeModMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			if params.Command == "speed" then
				self:stoptweening():visible(false);
			end;
		end;

		CheckSelectedMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
									 
			if (params.Mod == nil) then return; end;
			
			local mod = params.Mod;			
			local title = GetCommandTitles()[ params.Command ].name;
		  
			if title == "speed" then
				if getAVNum(player) then
					self:stoptweening():queuecommand("On");
				else
					self:stoptweening():visible(false);
				end;
			end;
		end;
		
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;
		CommandWindowResetMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/CVicon"))..{
		Name="CVBack";
		InitCommand=cmd(visible,false;x,2*xAuxPos;zoom,0.5);
		OnCommand=function(self)
			if getCVNum(player) ~= nil then
				self:diffusealpha(0.25);
				self:zoom(0.5);
				self:linear(0.25);				
				self:diffusealpha(1);
				self:visible(GAMESTATE:IsHumanPlayer(player));	
			else
				self:visible(false);
			end;
		end;
		CheckSelectedMessageCommand=function(self, params)
			self:zoom(0.5);
			if params.Player ~= player then return; end;
			if (params.Mod == nil) then return; end;
			
			local mod = params.Mod;
			local title = GetCommandTitles()[ params.Command ].name;
			

			if title == "speed" or title == "av" then
				if getCVNum(player) then
					self:stoptweening():visible(true);
				else
					self:stoptweening():visible(false);
				end;
			end;

		end;

		CodeModMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			if params.Command == "speed" or  params.Command == "av" then
				self:stoptweening():visible(false);
			end;
		end;

		
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:visible(false);
		end;

		EnableCVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;

		CommandWindowResetMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:visible(false);
		end;
	};

	t[#t+1] = LoadFont("interphase/InterNumber numbers").. {
		Name="CVText";
		InitCommand=cmd(visible,false;x,2*xAuxPos - 1;zoom,.42;);
		OnCommand=function(self)
			self:horizalign(center);
			self:y(-5);
			if getCVNum(player) ~= nil then
				self:settext(getCVNum(player));
			else
				self:settext("");
			end;
			self:visible(GAMESTATE:IsHumanPlayer(player));
		end;

		CodeModMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			if params.Command == "speed" then
				self:stoptweening():visible(false);
			end;
		end;

		CheckSelectedMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
									 
			if (params.Mod == nil) then return; end;
			
			local mod = params.Mod;			
			local title = GetCommandTitles()[ params.Command ].name;
		  
			if title == "speed" then
				if getCVNum(player) then
					self:stoptweening():queuecommand("On");
				else
					self:stoptweening():visible(false);
				end;
			end;

			if title == "av" then
				if getCVNum(player) then
					self:stoptweening():queuecommand("On");
				else
					self:stoptweening():visible(false);
				end;
			end;
		end;
		
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;
		
		EnableCVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;

		CommandWindowResetMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("On");
		end;
	};


	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
		Name="AVGlow1";
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;diffusealpha,0;x,2*xAuxPos);
		AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1;sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125);
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("AnimateAux");
		end;
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
		Name="AVGlow2";
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;diffusealpha,0;x,2*xAuxPos);
		AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1 - (1*0.5);sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125 + (1*0.2));
		EnableAVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("AnimateAux");
		end;
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
		Name="CVGlow1";
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;diffusealpha,0;x,2*xAuxPos);
		AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1;sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125);
		EnableCVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("AnimateAux");
		end;
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
		Name="CVGlow2";
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;diffusealpha,0;x,2*xAuxPos);
		AnimateAuxCommand=cmd(finishtweening;zoom,1;diffusealpha,1 - (1*0.5);sleep,0.1;linear,0.4;diffusealpha,0;zoom,1.125 + (1*0.2));
		EnableCVMessageCommand=function(self, params)
			if params.Player ~= player then return; end;
			self:stoptweening():queuecommand("AnimateAux");
		end;
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/AUTOicon"))..{
		InitCommand=cmd(visible,false;x,xAuxPos);
		OnCommand=function(self)
			if (GAMESTATE:IsHumanPlayer(player)) then
				local cur_scr = SCREENMAN:GetTopScreen():GetName();
				local vStats = STATSMAN:GetCurStageStats();
				local pnStageStats = vStats:GetPlayerStageStats( player );
				self:stoptweening();
				self:visible(cur_scr == "ScreenEvaluation" and pnStageStats:GetAutoPlay() );	
				self:diffusealpha(0.25);
				self:zoom(1.0625);
				self:linear(0.25);
				self:zoom(0.5);
				self:diffusealpha(1);
			end;
		end;
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","THEME-EFFECT_GLOW"))..{
		InitCommand=cmd(x,xAuxPos;animate,false;setstate,0;blend,Blend.Add;diffusealpha,0);
		OnCommand=function(self)
			if (GAMESTATE:IsHumanPlayer(player)) then
				local cur_scr = SCREENMAN:GetTopScreen():GetName();
				local vStats = STATSMAN:GetCurStageStats();
				local pnStageStats = vStats:GetPlayerStageStats( player );
				self:visible(cur_scr == "ScreenEvaluation" and pnStageStats:GetAutoPlay());
				self:finishtweening();
				self:zoom(1);
				self:diffusealpha(1);
				self:sleep(0.1);
				self:linear(0.4);
				self:diffusealpha(0);
				self:zoom(1.125);
			end;
		end;
	}
	
end;

return t;