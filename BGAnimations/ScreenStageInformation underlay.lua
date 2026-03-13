local function GetPath()
	local bgpath = GAMESTATE:GetCurrentSong():GetBackgroundPath();
	
	if not bgpath then
		return (THEME:GetPathG("Common", "fallback background"));
	else
		
		-- Fix anti-idiotas, para futuros wns que quieran hacer steps y no pongan el '/' antes para redir
		local str = string.sub (bgpath, 1, 6);
		str = string.lower(str);
		if str == "songs/" then
			return "/" .. bgpath;
		end;
	
		if FILEMAN:DoesFileExist(bgpath) then
			return bgpath;
		else
			return (THEME:GetPathG("Common", "fallback background"));
		end;
	end;
end;

function Actor:TITLE()
	local ratio = PREFSMAN:GetPreference("DisplayAspectRatio");
	local stretchBG = PREFSMAN:GetPreference("StretchBackgrounds")
	
	if (ratio > 1.5) then
		if stretchBG then
			self:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT )
		else
			self:scaletofit(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
	else
		self:scale_or_crop_background();
	end;
end;

local t = Def.ActorFrame { };

t[#t+1] = LoadActor(GetPath())..{
	InitCommand=cmd(TITLE);
};


t[#t+1] = Def.ActorFrame { 
		OnCommand=function(self)
			self:visible(true);
			self:diffusealpha(1);
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+310);

			if GAMESTATE:IsSideJoined(PLAYER_1) then				
				local CurrentStepP1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
				local stepArtistP1 = CurrentStepP1:GetAuthorCredit();
				if #stepArtistP1 > 0 then
					self:GetChild("sap1"):visible(true);
					self:GetChild("textsap1"):settext(stepArtistP1);
				else
					self:GetChild("sap1"):visible(false);
					self:GetChild("textsap1"):settext("");
				end;
				


			end;

			if GAMESTATE:IsSideJoined(PLAYER_2) then
				local CurrentStepP2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
				local stepArtistP2 = CurrentStepP2:GetAuthorCredit();
				if #stepArtistP2 > 0 then
					self:GetChild("sap2"):visible(true);
					self:GetChild("textsap2"):settext(stepArtistP2);
				else
					self:GetChild("sap2"):visible(false);
					self:GetChild("textsap2"):settext("");
				end;
			end;

		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepartistsprite"))..{
				Name="sap1";
				InitCommand=function(self)
					self:zoom(0.8);
					self:x(-500);
					self:visible(false);
				end;

		};

		LoadFont("_century gothic")..{
			Name="textsap1";
			OnCommand=cmd(x,-510;y,-3;zoom,0.8;horizalign,left);
		};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/stepartistsprite"))..{
			Name="sap2";
			InitCommand=function(self)
				self:zoom(0.8);
				self:x(500);
				self:visible(false);
			end;
		};

		LoadFont("_century gothic")..{
			Name="textsap2";
			OnCommand=cmd(x,490;y,-3;zoom,0.8;horizalign,left);
		};

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			--self:linear(0.05);
			self:diffusealpha(0);
		end;
		OffCommand=function(self)
			self:stoptweening();
			--self:linear(0.05);
			self:diffusealpha(0);
		end;

};


return t;