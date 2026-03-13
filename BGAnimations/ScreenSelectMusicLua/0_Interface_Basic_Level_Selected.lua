local dl_distance =190;
local dl_q = 3;

local AuxChosen={};

AuxChosen[PLAYER_1]=false;
AuxChosen[PLAYER_2]=false;

local t = Def.ActorFrame{};

local function METER( a,b ) 
	return a:GetMeter() < b:GetMeter() 
end
local function StringDifficulty(d)
	if d == "Difficulty_Beginner" then
		return false;
	elseif d == "Difficulty_Easy" then
		return false;
	elseif d == "Difficulty_Medium" then
		return false;
	elseif d == "Difficulty_Hard" then
		return false;
	elseif d == "Difficulty_Challenge" then
		return false;
	end;
	return true;
end;

function CreatePlayer(player)
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
		end;
		ChangeStepsMessageCommand=function(self)
			self:finishtweening();
			self:queuecommand("Refresh");
		end;
		
		
		CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"Refresh");
		StepsChosenMessageCommand=function(self, params)
			AuxChosen[params.Player] = true;
			self:finishtweening():queuecommand("Refresh")
		end;
		StepsUnchosenMessageCommand=function(self, params)
			AuxChosen[params.Player] = false;
			self:finishtweening():queuecommand("Refresh")
		end;
		SongUnchosenMessageCommand=function(self)
			for i=0,dl_q,1 do
				self:GetParent():GetChild('dln'..i):finishtweening():visible(false);
				self:GetParent():GetChild('dlf'..i):finishtweening():visible(false);
				self:GetParent():GetChild('dlbf'..i):finishtweening():visible(false);
				
			end;
		end;
		SongChosenMessageCommand=function(self)
			for i=0,dl_q,1 do
				self:GetParent():GetChild('dln'..i):finishtweening():visible(true):addx(500 * (player == PLAYER_2 and 1 or -1)):linear(.1 + (i /16)):addx(500 * (player == PLAYER_2 and -1 or 1)):diffusealpha(0.4);
				self:GetParent():GetChild('dlf'..i):finishtweening():visible(true):addx(500 * (player == PLAYER_2 and 1 or -1)):linear(.1 + (i /16)):addx(500 * (player == PLAYER_2 and -1 or 1)):diffusealpha(0.4);
				self:GetParent():GetChild('dlbf'..i):finishtweening():visible(true):addx(500 * (player == PLAYER_2 and 1 or -1)):linear(.1 + (i /16)):addx(500 * (player == PLAYER_2 and -1 or 1)):diffusealpha(0.4);
			end;
			self:finishtweening():queuecommand("Refresh")
		end;
		RefreshCommand=function(self)
			if GAMESTATE:GetGameMode() == 'Basic' then
				local CurrentStep = GAMESTATE:GetCurrentSteps(player);		
				local count=0;			
				for i=0,dl_q,1 do
					self:GetParent():GetChild('dlf'..i):settext("");
					self:GetParent():GetChild('dlbf'..i):settext("");
				end;		
				if GAMESTATE:GetNumPlayersEnabled() == 2 then 
					dl_q = 2;
				end;
				local vpSteps = GAMESTATE:GetCurrentSong():GetAllSteps();
				
				table.sort(vpSteps,METER)
				for i=1,#vpSteps,1 do
					if vpSteps[i]:GetStepsType() == 'StepsType_Pump_Double' then
						table.insert(vpSteps,vpSteps[i]);
						table.remove(vpSteps,i);
						i=1;
					end;
				end;
				
				for i=#vpSteps, 1, -1 do
					if vpSteps[i]:GetStepsType() == "StepsType_Pump_Single" and StringDifficulty(vpSteps[i]:GetDifficulty()) then
						table.remove(vpSteps,i);
						i = #vpSteps;
					end;
				end;
				for i=#vpSteps, 1, -1 do
					if vpSteps[i]:GetStepsType() == "StepsType_Pump_Double" and vpSteps[i]:GetDifficulty() ~= "Difficulty_Beginner" then
						table.remove(vpSteps,i);
						i = #vpSteps;
					end;
				end;
				for i=#vpSteps, 1, -1 do
					if vpSteps[i]:GetStepsType() == "StepsType_Pump_Double" and GAMESTATE:GetNumPlayersEnabled() == 2 then
						table.remove(vpSteps,i);
						i = #vpSteps;
					end;
				end;
				
				for i=#vpSteps, 1, -1 do
					if vpSteps[i]:GetStepsType() == "StepsType_Pump_Single_P" or vpSteps[i]:GetStepsType() == "StepsType_Pump_Double_P" then
						table.remove(vpSteps,i);
						i = #vpSteps;
					end;
				end;

				for i=1 ,#vpSteps , 1 do
					self:GetParent():GetChild('dlbf'..count):diffuse(color("#18327e"));
					self:GetParent():GetChild('dln'..count):setstate(0);
					--self:GetParent():GetChild('dln'..count):diffusealpha(1);
					self:GetParent():GetChild('dln'..count):x(count*dl_distance - ((dl_distance*dl_q)/2));
					--self:GetParent():GetChild('dlf'..count):diffusealpha(1);
					self:GetParent():GetChild('dlf'..count):x(count*dl_distance - ((dl_distance*dl_q)/2));
					--self:GetParent():GetChild('dlbf'..count):diffusealpha(1);
					self:GetParent():GetChild('dlbf'..count):x(count*dl_distance - ((dl_distance*dl_q)/2));


					local modeStateColorLevel = basicModeLevelStateAndColor(vpSteps[i]:GetMeter(),vpSteps[i]:GetStepsType());
					self:GetParent():GetChild('dln'..count):setstate(modeStateColorLevel["state"]);
					self:GetParent():GetChild('dlbf'..count):diffuse(color(modeStateColorLevel["color"]));

					self:GetParent():GetChild('dlf'..count):settext(string.format("%02i", vpSteps[i]:GetMeter()));
					self:GetParent():GetChild('dlbf'..count):settext(string.format("%02i", vpSteps[i]:GetMeter()));

					self:GetParent():GetChild('dln'..count):diffusealpha(0.4);
					self:GetParent():GetChild('dlf'..count):diffusealpha(0.4);
					self:GetParent():GetChild('dlbf'..count):diffusealpha(0.4);

					if GAMESTATE:IsHumanPlayer(player) then
						if CurrentStep:GetMeter() == vpSteps[i]:GetMeter() and CurrentStep:GetStepsType() == vpSteps[i]:GetStepsType() then
							if player == PLAYER_1 then
								self:GetParent():GetChild('CURSORP'..player..'0'):setstate(0);
							end;
							if player == PLAYER_2 then
								self:GetParent():GetChild('CURSORP'..player..'0'):setstate(1);
							end;

							self:GetParent():GetChild('CURSORP'..player..'0'):x(dl_distance*count - ((dl_distance*dl_q)/2) - 3);
							--self:GetParent():GetChild('CURSORP'..player..'1'):x(dl_distance*count - ((dl_distance*dl_q)/2) + 85);
							
							self:GetParent():GetChild('dln'..count):diffusealpha(1);
							self:GetParent():GetChild('dlf'..count):diffusealpha(1);
							self:GetParent():GetChild('dlbf'..count):diffusealpha(1);

						else
							--[[
							if AuxChosen[player] then
								self:GetParent():GetChild('dln'..count):diffusealpha(1);
								self:GetParent():GetChild('dlf'..count):diffusealpha(1);
								self:GetParent():GetChild('dlbf'..count):diffusealpha(1);
							end;
							]]
						end;			
					end;			
					count = count + 1;
				end;
				
				if count < dl_q+1 then
					for i=count,dl_q,1 do
						self:GetParent():GetChild('dlf'..count):settext("");
						self:GetParent():GetChild('dlbf'..count):settext("");
						self:GetParent():GetChild('dln'..count):diffusealpha(0);
						count=count+1;
					end;
				end;
				if GAMESTATE:GetNumPlayersEnabled() == 2 then
					self:GetParent():GetChild('dln3'):visible(false);
					self:GetParent():GetChild('dlf3'):settext("");
					self:GetParent():GetChild('dlbf3'):settext("");
					self:GetParent():GetChild('dln'..count):diffusealpha(0);
				end;
			end;
		end;
	};
	
	for i = 0, dl_q, 1 do
			
		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/basicBacklv"))..{
			Name="dln"..i;
			OnCommand=function(self)
				self:animate(false):visible(false):zoom(0.85):addy(-7);
			end;
		};
		
		t[#t+1] = LoadFont("level")..{
			Name="dlf"..i;
			OnCommand=function(self)
				self:animate(false):visible(false):zoom(.74):y(-10):shadowlength(2):shadowcolor(color("0,0,0,.8"));
			end;
		};
		t[#t+1] = LoadFont("borderlevel")..{
			Name="dlbf"..i;
			OnCommand=function(self)
				self:animate(false):visible(false):zoom(.74):y(-10);
			end;
		};

	end;


	local p = 0;
	if player == PLAYER_2 then
		p=2;
	end;


		t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/pselector 1x2"))..{
			Name = "CURSORP"..player.."0";
			OnCommand=cmd(diffusealpha,0;zoom,0.95;animate,false;setstate,0;addy,55);
			SongChosenMessageCommand=function(self)
				if GAMESTATE:IsHumanPlayer(player) then
					self:finishtweening():sleep(0.25):diffusealpha(1);
				end;
			end;
			SongUnchosenMessageCommand=function(self)
				self:finishtweening();
				self:effectperiod(1);
				self:diffusealpha(0);
			end;
			StepsChosenMessageCommand=function(self,params)
				if params.Player == player then
					self:effectperiod(0.15);
				end;
			end;
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == player then
					self:effectperiod(1);
				end;
			end;
			PlayerJoinedMessageCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingSteps' or SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
					if GAMESTATE:IsHumanPlayer(player) then
						self:finishtweening():sleep(0.25):diffusealpha(1);
					end;
				end;
			end;
			FinalizedMessageCommand=cmd(finishtweening;linear,0.125;diffusealpha,0)
		};


		for s = 0,1,1 do

--[[
			t[#t+1] = LoadActor(THEME:GetPathG("","MusicWheel_Arrow"))..{
				Name = "CURSORP"..player..s;
				OnCommand=cmd(diffusealpha,0;zoom,.5;animate,false;rotationz,s == 1 and 0 or -180;pulse;effectmagnitude,0.95,1,1);
				SongChosenMessageCommand=function(self)
					if GAMESTATE:IsHumanPlayer(player) then
						self:finishtweening():sleep(0.25):diffusealpha(1);
					end;
				end;
				SongUnchosenMessageCommand=function(self)
					self:finishtweening();
					self:effectperiod(1);
					self:diffusealpha(0);
				end;
				StepsChosenMessageCommand=function(self,params)
					if params.Player == player then
						self:effectperiod(0.15);
					end;
				end;
				StepsUnchosenMessageCommand=function(self,params)
					if params.Player == player then
						self:effectperiod(1);
					end;
				end;
				PlayerJoinedMessageCommand=function(self)
					if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingSteps' or SCREENMAN:GetTopScreen():GetSelectionState() == 'ConfirmSteps' then
						if GAMESTATE:IsHumanPlayer(player) then
							self:finishtweening():sleep(0.25):diffusealpha(1);
						end;
					end;
				end;
				FinalizedMessageCommand=cmd(finishtweening;linear,0.125;diffusealpha,0)
			};
]]			
		end;
end;

return t;