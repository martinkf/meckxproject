local function GetPath()

	local bgpath;
	if GAMESTATE:GetRandomTrainChannel() then
		--bgpath = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
		--if (string.find(bgpath, "SINGLE")) then
			bgpath = THEME:GetPathG("", "blackdot");
		--else
		--	bgpath = THEME:GetPathG("", "RTDOUBLE");
		--end;
	else
		bgpath = GAMESTATE:GetCurrentSong():GetBackgroundPath();
	end;
	
	
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
	self:diffusealpha(.2);
end;

local t = Def.ActorFrame {};

t[#t+1] = LoadActor(GetPath())..{
	InitCommand=cmd(TITLE);
};



	--[[
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BGUP"))..{	
		InitCommand=cmd(animate,false;setstate,(GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0;x,320;linear,.3;addy,77);
		OnCommand=cmd(setstate, (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0);
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BGUP"))..{	
		InitCommand=cmd(animate,false;setstate,(GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0;x,320;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,77);
		OnCommand=cmd(setstate, (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0);
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	---BASIC
	t[#t+1] = LoadActor(THEME:GetPathG("","SM_BASICUP"))..{	
		InitCommand=cmd(animate,false;visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false);x,320;linear,.3;addy,77);
		OnCommand=cmd(visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false));
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM_BASICUP"))..{	
		InitCommand=cmd(animate,false;visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false);x,320;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,77);
		OnCommand=cmd(visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false));
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,100;x,100;diffusealpha,0;diffusecolor,1,0,.7,1;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(0,1,.4,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,100;x,SCREEN_WIDTH-100;rotationy,-180;diffusealpha,0;diffusecolor,1,0,.7,1;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(0,1,.4,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	

	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,120;x,SCREEN_CENTER_X;diffusecolor,1,0,.15,1;diffusealpha,0;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.5;linear,.85;diffusealpha,1;queuecommand,"Effect");
		
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(0,1,.4,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	
	-- FULL-QUEST XX FOOTER BG
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BGDOWN"))..{	
		InitCommand=cmd(animate,false;setstate,(GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0;y,SCREEN_HEIGHT;x,320;linear,.3;addy,-189);
		OnCommand=cmd(setstate, (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0);
		OffCommand=cmd(finishtweening;linear,.2;addy,189);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BGDOWN"))..{	
		InitCommand=cmd(animate,false;setstate,(GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0;y,SCREEN_HEIGHT;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,-189);
		OnCommand=cmd(setstate, (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel() ) and 1 or 0);
		OffCommand=cmd(finishtweening;linear,.2;addy,189);
	};
	
	
	-- basic
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BASICDOWN"))..{	
		InitCommand=cmd(animate,false;visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false);y,SCREEN_HEIGHT;x,320;linear,.3;addy,-190);
		OnCommand=cmd(visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false));
		OffCommand=cmd(finishtweening;linear,.2;addy,190);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-BASICDOWN"))..{	
		InitCommand=cmd(animate,false;visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false);y,SCREEN_HEIGHT;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,-190);
		OnCommand=cmd(visible,(GAMESTATE:GetGameMode() == 'Basic' and true or false));
		OffCommand=cmd(finishtweening;linear,.2;addy,190);
	};
	
	
	
	-- GLOW DOWN -- ;blend,Blend.Add
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,SCREEN_HEIGHT-100;x,320;diffusecolor,1,0,.5,1;diffusealpha,0;sleep,.3;queuecommand,"Effect");
		EffectCommand=cmd(stoptweening;linear,.85;diffusealpha,.4;linear,.85;diffusealpha,.7;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(.3,1,0,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);	
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,SCREEN_HEIGHT-100;x,SCREEN_WIDTH-320;rotationy,-180;diffusecolor,1,0,.5,1;diffusealpha,0;sleep,.3;queuecommand,"Effect");
		EffectCommand=cmd(stoptweening;linear,.85;diffusealpha,.4;linear,.85;diffusealpha,.7;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(.3,1,0,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};


	t[#t+1] = LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,SCREEN_HEIGHT;x,320;diffusecolor,1,0,.8,1;diffusealpha,0;linear,.3;addy,-106;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,0;linear,.85;diffusealpha,1;queuecommand,"Effect");
		
		OnCommand=cmd(finishtweening;playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(.3,1,0,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,SCREEN_HEIGHT;x,SCREEN_WIDTH-320;rotationy,-180;diffusecolor,1,0,.8,1;diffusealpha,0;linear,.3;addy,-106;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,0;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(finishtweening;playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusealpha(0);
			if (GAMESTATE:GetQuestZoneChannel() or GAMESTATE:GetQuestWorldChannel()) then
				self:diffusecolor(.3,1,0,1);
			elseif GAMESTATE:GetGameMode() == 'Basic' then 
				self:diffusecolor(0,0,1,1);
			else
				self:diffusecolor(1,0,.7,1);
			end;
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	-------------------------------------------------------------------------------------------------
	]]--

return t;