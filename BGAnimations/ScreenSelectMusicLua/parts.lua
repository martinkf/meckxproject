local t = Def.ActorFrame {}
local timeoutExit=0.3;
local zoomBase = 0.7;

--HEADER


	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:zoom(zoomBase);
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-333);

			if isAspectRatio1610() then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-370);
			end;

			if isAspectRatio43() then
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-445);
			end;			
		end;
		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/HG"))..{
				InitCommand=function(self)
				end;
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/headerstype 1x2"))..{
			InitCommand=function(self)
				self:animate(false);
				self:setstate(0);		
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
					elseif GAMESTATE:IsSideJoined(PLAYER_2) then 
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
					elseif GAMESTATE:IsSideJoined(PLAYER_2) then 
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
					elseif GAMESTATE:IsSideJoined(PLAYER_2) then 
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

		};


	};

return t;