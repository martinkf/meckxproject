local t = Def.ActorFrame {};


local langHeader = PREFSMAN:GetPreference('Language');
local typeNotePos={x=SCREEN_CENTER_X-360,y=SCREEN_CENTER_Y+280};
local typeChannel={x=SCREEN_CENTER_X+360,y=SCREEN_CENTER_Y+280};

local typeChannelBasex=-20;

--type 1
t[#t+1] =  Def.ActorFrame
{
	OnCommand=cmd(x,typeNotePos["x"];y,typeNotePos["y"];zoom,0.8;visible,false;queuecommand,"checkNumPlayers");

	checkNumPlayersCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:GetChild("textAll"):diffusealpha(0.15);
			self:GetChild("textDouble"):diffusealpha(0.15);
		end;
	end;

	SelectChannelMessageCommand=function(self)
		self:visible(true);
	end;
	ChannelChosenMessageCommand=function(self)
		self:visible(false);
	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/background"))..{
		InitCommand=cmd(zoom,0.8;zoomx,0.85);
	};		

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeNoteType/"..langHeader.."_header"))..{
		InitCommand=cmd(zoom,0.8;y,-15);
	};	

	--base	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeNoteType/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,-113;y,10;queuecommand,"CheckPos");
		CheckPosCommand=function(self)

			if GAMESTATE:GetNumSidesJoined() == 2 then
				self:x(0);
				--self:GetChild("textAll"):diffusealpha(0.3);
				--self:GetChild("textDouble"):diffusealpha(0.3);
			else
				if (GAMESTATE:GetFilterOne() == 'FilterOne_Double') then
					self:x(113);
				elseif (GAMESTATE:GetFilterOne() == 'FilterOne_Single') then
					self:x(0);
				else
					self:x(-113);
				end;
			end;


		end;
		FilterOneMessageCommand=function(self, params)
			self:queuecommand("CheckPos");
		end;
	};	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/arrow_pink"))..{
		InitCommand=cmd(x,-78;y,-15;zoom,0.85;rotationz,180;rotationx,180);
		OnCommand=function(self)
			if langHeader == "es" then
				self:x(-53);
			elseif langHeader == "pt" then
				self:x(-39);
			end;
			
		end;
	};	

	--text
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeNoteType/text_ALL"))..{
		Name="textAll";
		InitCommand=cmd(zoom,0.85;x,-113;y,10);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeNoteType/text_SINGLE"))..{
		Name="textSingle";
		InitCommand=cmd(zoom,0.85;x,0;y,10);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeNoteType/text_DOUBLE"))..{
		Name="textDouble";
		InitCommand=cmd(zoom,0.85;x,113;y,10);
	};	
}


--type 2
t[#t+1] =  Def.ActorFrame
{
	OnCommand=cmd(x,typeChannel["x"];y,typeChannel["y"];zoom,0.8;visible,false;queuecommand,"checkNumPlayers");
	checkNumPlayersCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 2 then
			self:GetChild("textQuest"):diffusealpha(0.15);
		end;
	end;	
	SelectChannelMessageCommand=function(self)
		self:visible(true);
	end;
	ChannelChosenMessageCommand=function(self)
		self:visible(false);
	end;

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/background"))..{
		InitCommand=cmd(zoom,0.8;zoomx,0.95);
	};		

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/"..langHeader.."_header"))..{
		InitCommand=cmd(zoom,0.8;y,-15);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/arrow_pink"))..{
		InitCommand=cmd(x,-79;y,-15;zoom,0.85);
		OnCommand=function(self)
			if langHeader == "es" then
				self:x(-53);
			elseif langHeader == "pt" then
				self:x(-39);
			end;
			
		end;
	};	
	--base	
	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,-160;y,10;queuecommand,"CheckPos");
		CheckPosCommand=function(self)
			if (GAMESTATE:GetFilterTwo() == 'FilterTwo_Channel') then
				self:x(-160+typeChannelBasex);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Category') then
				self:x(-70+typeChannelBasex);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Level') then
				self:x(20+typeChannelBasex);
			elseif (GAMESTATE:GetFilterTwo() == 'FilterTwo_Quests') then
				self:x(110+typeChannelBasex);
			else
				self:x(200+typeChannelBasex);
			end;
		end;

		FilterTwoMessageCommand=function(self)
			self:queuecommand("CheckPos");
		end;

	};	

--[[
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,-160+typeChannelBasex;y,10;);
	};	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,-70+typeChannelBasex;y,10;);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,20+typeChannelBasex;y,10;);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,110+typeChannelBasex;y,10;);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/baseopt"))..{
		InitCommand=cmd(zoom,0.85;x,200+typeChannelBasex;y,10;);
	};	
	]]

	--text
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/txt_CHANNEL"))..{
		InitCommand=cmd(zoom,0.85;x,-160+typeChannelBasex;y,10);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/txt_CATEGORY"))..{
		InitCommand=cmd(zoom,0.85;x,-70+typeChannelBasex;y,10);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/txt_level"))..{
		InitCommand=cmd(zoom,0.85;x,20+typeChannelBasex;y,10);
	};	
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/txt_QUEST"))..{
		Name="textQuest";
		InitCommand=cmd(zoom,0.85;x,110+typeChannelBasex;y,10);
	};		
	LoadActor(THEME:GetPathG("","ScreenSelectMusic/modeFilter/TypeChannel/txt_ALL"))..{
		InitCommand=cmd(zoom,0.85;x,200+typeChannelBasex;y,10);
	};	

}

return t;