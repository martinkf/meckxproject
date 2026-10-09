local function GetPath()
	local bgpath = GAMESTATE:GetCurrentSong():GetBackgroundPath();
	
	if not bgpath then
		return (THEME:GetPathG("Common", "fallback background.png"));
	else
		if FILEMAN:DoesFileExist(bgpath) then
			return bgpath;
		else
			return (THEME:GetPathG("Common", "fallback background.png"));
		end;
	end;
end;

function Actor:TITLE()
	local ratio = PREFSMAN:GetPreference("DisplayAspectRatio");
	local stretchBG = PREFSMAN:GetPreference("StretchBackgrounds")
	
	if (ratio > 1.5) then
		if stretchBG then
			self:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		else
			self:scaletofit(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
	else
		self:scale_or_crop_background();
	end;
end;

local t = Def.ActorFrame {};

t[#t+1] = LoadActor(GetPath())..{
	InitCommand=cmd(TITLE);
};

--NSCENTER
-- we fix the speed from the gamemode itself because we can change it between songs :o
if isNonstopCenterModeActive() then
		t[#t+1] = Def.ActorFrame{
			OnCommand=function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				    local ps = GAMESTATE:GetPlayerState(PLAYER_1);			   
				    local playerIsAv = playerIsAvNonstopCenterMode(PLAYER_1);
					if playerIsAv == false or getAvSpeedNonstopCenterMode(PLAYER_2) == 0 then
						--speed
					else
						--av
						local avPlayer = getAvSpeedNonstopCenterMode(PLAYER_1);
						ps:GetPlayerOptions("ModsLevel_Preferred"):MMod(avPlayer);
					end;
				end;

				if GAMESTATE:IsHumanPlayer(PLAYER_2) then
					local ps = GAMESTATE:GetPlayerState(PLAYER_2);
					local playerIsAv = playerIsAvNonstopCenterMode(PLAYER_2);					
					if playerIsAv == false or getAvSpeedNonstopCenterMode(PLAYER_2) == 0 then
						--speed
					else
						--av
						local avPlayer = getAvSpeedNonstopCenterMode(PLAYER_2);
						ps:GetPlayerOptions("ModsLevel_Preferred"):MMod(avPlayer);
					end;
				end;
			end;
		};
end;

return t;