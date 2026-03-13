local dl_distance =63;
local dl_q = 12;
local ARRAY={};
ARRAY[-1]=PLAYER_1;
ARRAY[1]=PLAYER_2;
local function FixMeter(meter)
	
	if meter == "!!" then
		meter = "51";
	end;
	if meter == "??" then
		meter = "99";
	end;
	
	meter = string.format("%02i", meter);
	if tonumber(meter) > 99 then
		meter = "99";
	end;
	return meter;
end;

local StepsType={'StepsType_Pump_Single','StepsType_Pump_Double','StepsType_Pump_Single_P','StepsType_Pump_Double_P'};
local t = Def.ActorFrame{};
for p=-1,1,2 do
	t[#t+1] = Def.ActorFrame{
		LoadActor(THEME:GetPathG("","THEME-HDDIFFBALLS"))..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):setstate(0):animate(false):x(198*p):y(430):zoom(.82):queuecommand("Show");				
			end;
			ShowCommand=cmd(stoptweening;linear,0.125;y,158);
			FinalizedMessageCommand=cmd(stoptweening;linear,0.125;y,150;linear,0.125;y,430);
			ChangeStepsMessageCommand=cmd(finishtweening);
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
		};
		LoadActor(THEME:GetPathG("","THEME-HDDIFFBALLS"))..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):setstate(0):animate(false):x(198*p):y(430):zoom(.82):queuecommand("Show");				
			end;
			ShowCommand=cmd(stoptweening;linear,0.125;y,158;playcommand,"Refresh");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.125;y,150;linear,0.125;y,430);
			ChangeStepsMessageCommand=cmd(finishtweening;playcommand,"Refresh");
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single' then
						self:setstate(1);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double' then
						self:setstate(3);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Single_P' then
						self:setstate(2);
					end;
					if CurrentStep:GetStepsType() == 'StepsType_Pump_Double_P' then
						self:setstate(4);
					end;
				end;
			end;
		};
		
		LoadFont("questlevel")..{
			OnCommand=function(self)
				self:visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):x(198*p):y(430):zoom(1.2):queuecommand("Show");				
			end;
			ShowCommand=cmd(stoptweening;linear,0.125;y,162;playcommand,"Refresh");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.125;y,154;linear,0.125;y,430);
			ChangeStepsMessageCommand=cmd(finishtweening;playcommand,"Refresh");
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On");
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					local meter = CurrentStep:GetMeter();
					meter = FixMeter(meter);
					self:settext(meter);
				end;
			end;
		};	
	
		LoadActor(THEME:GetPathG("","THEME-DIFFLABELS"))..{
			OnCommand=function(self)
				self:setstate(0):animate(false):x(197*p):y(88):zoom(1.1):sleep(0.125):queuecommand("Refresh");
			end;
			RefreshCommand=function(self)
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					local CurrentStep = GAMESTATE:GetCurrentSteps(ARRAY[p]);
					if CurrentStep:GetLabelType() == "LABELTYPE_S1" then
						self:setstate(4);
					end;
					if CurrentStep:GetLabelType() == "LABELTYPE_S2" then
						self:setstate(5);
					end;
					if CurrentStep:GetLabelType() == "LABELTYPE_S3" then
						self:setstate(6);
					end;
					if CurrentStep:GetLabelType() == "LABELTYPE_S4" then
						self:setstate(7);
					end;
				end;
			end;
			FinalizedMessageCommand=cmd(finishtweening;setstate,0);
		};
	};
end;


return t;