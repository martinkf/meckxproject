local ARRAY={};
ARRAY[-1]=PLAYER_1;
ARRAY[1]=PLAYER_2;

local BGAPartialAlpha = 0.75;

local t = Def.ActorFrame { };

if GAMESTATE:GetGameMode() ~= 'Rank' then
	
	if GAMESTATE:GetNumPlayersEnabled() == 1 then 
		
		local BlackWidth = 1000;
		if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
			BlackWidth = 1900;
		end;
		
		t[#t+1] = LoadActor(THEME:GetPathG("","blackdot")) .. {
			InitCommand=cmd(diffusealpha,0;zoomto,BlackWidth,SCREEN_HEIGHT);
			OnCommand=function(self)
				
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial() then
					if PREFSMAN:GetPreference("Center1Player") or GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
						self:Center();
					else
						self:x( SCREEN_CENTER_X  + (GAMESTATE:IsHumanPlayer(PLAYER_1) and -240 or 240))
						self:y( SCREEN_CENTER_Y );
					end;
					
					self:diffusealpha(0):fadeleft(.3):faderight(.3);
					self:decelerate(1.5):diffusealpha( BGAPartialAlpha );
				end;
			end;
		};
		
	else
	
		for p=-1,1,2 do

			t[#t+1] = LoadActor(THEME:GetPathG("","blackdot")) .. {
				InitCommand=cmd(diffusealpha,0;zoomto,600,SCREEN_HEIGHT);
				OnCommand=function(self)
					if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial() then
						self:Center();
						self:x( SCREEN_CENTER_X  + (240 * p))
						self:diffusealpha(0):fadeleft(.2):faderight(.2);
						self:decelerate(1.5):diffusealpha( BGAPartialAlpha );
					end;
				end;
			};
			
		end;
	
	end;
	
end;


return t