local t = Def.ActorFrame {}
local timeoutExit=0.3;
local zoomBase = 0.7;

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
	elseif style=='StepsType_Pump_Double' or style=='StepsType_Pump_Halfdouble' or style == "StepsType_Pump_Double_P" then 
		return 2;
	end;

	return 0;
end;

--HEADER


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/HG") )..{
		InitCommand=function(self)
			self:zoom(zoomBase);
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-333);

			if isAspectRatio1610() then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-370);
			end;

		end;
}


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/headerstype 1x2") )..{
	InitCommand=function(self)
		self:animate(false);
		self:setstate(0);
		self:zoom(zoomBase);
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-333);		
	end;

	OnCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:setstate(0);

			if PREFSMAN:GetPreference("MenuTimer") then

				if GAMESTATE:IsEventMode() then
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(true);			
			end;	

		else
			local pndata="";
			if GAMESTATE:IsSideJoined(PLAYER_1) then 
				pndata=PLAYER_1;
			end;
			if GAMESTATE:IsSideJoined(PLAYER_2) then 
				pndata=PLAYER_2;
			end;

			local tipoStep = checkTypeStepData(pndata);

			if tipoStep == 1 then
				self:setstate(0);
			else
				self:setstate(1);
			end;		

			if PREFSMAN:GetPreference("MenuTimer") then
				if GAMESTATE:IsEventMode() then
					self:visible(true);
				else
					self:visible(false);
				end;
			else
				self:visible(true);		
			end;	
					
		end;		



	end;

	ChangeStepsMessageCommand=function(self)

		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:setstate(0);
		else
			local pndata="";
			if GAMESTATE:IsSideJoined(PLAYER_1) then 
				pndata=PLAYER_1;
			end;
			if GAMESTATE:IsSideJoined(PLAYER_2) then 
				pndata=PLAYER_2;
			end;

			local tipoStep = checkTypeStepData(pndata);

			if tipoStep == 1 then
				self:setstate(0);
			else
				self:setstate(1);
			end;	
		end;
	end;

	StartSelectingStepsMessageCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:setstate(0);
		else
			local pndata="";
			if GAMESTATE:IsSideJoined(PLAYER_1) then 
				pndata=PLAYER_1;
			end;
			if GAMESTATE:IsSideJoined(PLAYER_2) then 
				pndata=PLAYER_2;
			end;

			local tipoStep = checkTypeStepData(pndata);

			if tipoStep == 1 then
				self:setstate(0);
			else
				self:setstate(1);
			end;		
		end;		
	end;

}

return t;