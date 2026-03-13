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

return t;