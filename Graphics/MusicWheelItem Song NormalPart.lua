local t =  Def.ActorFrame{	};
local actualSong = "";


t[#t+1] = Def.ActorFrame {
	SetMessageCommand=function(self,params)
		if params.Song then
			local bpath 	= GetSongBannerPath(params.Song);

			if GAMESTATE:IsSideJoined(PLAYER_1) then
				 if params.Song:GetFavorite(PLAYER_1) then
					self:GetChild("starp1"):visible(true);
				 else
				 	self:GetChild("starp1"):visible(false);
				 end
			end;

			if GAMESTATE:IsSideJoined(PLAYER_2) then
				 if params.Song:GetFavorite(PLAYER_2) then
					self:GetChild("starp2"):visible(true);
				 else
				 	self:GetChild("starp2"):visible(false);
				 end
			end;

			self:GetChild("blurBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256*.64,160*.64);
			self:GetChild("gBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256+4,160+8);
			self:GetChild("nBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256,160);
			self:GetChild("Random"):visible(false);
		else
			self:GetChild("blurBanner"):Load(nil);
			self:GetChild("gBanner"):Load(nil);
			self:GetChild("nBanner"):Load(nil);
			self:GetChild("Random"):visible(true);
		end;
	end;
	
	favStarCommand=function(self)

	end;

	Def.Banner {	Name="blurBanner";
		InitCommand=cmd(scaletoclipped,256,160;xy,0,-10;z,-120;croptop,0.2;blend,Blend.Add;diffusealpha,.24;
			diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF9B");
			effectclock,'beat';effectperiod,5;fadeleft,0.1;faderight,0.1;);
	};
	
	Def.Quad {		Name="bBack2";
		InitCommand=cmd(zoomto,256+4,160+8;diffuse,color("#000000FF");shadowlength,3;);
	};


	Def.Quad {		Name="bBack";
		InitCommand=cmd(zoomto,256,160;diffuse,color("#000000FF"););
	};
	Def.Banner {	Name="gBanner";
		InitCommand=cmd(scaletoclipped,256+2,160+4;xy,0,0;blend,Blend.Add;diffusealpha,0.4;);
	};
	Def.Banner {	Name="nBanner";
		InitCommand=cmd(scaletoclipped,256-2,160-2;xy,0,0;);
	};



	LoadActor(THEME:GetPathG("","ScreenSelectMusic/starfav")) .. {	
		Name="starp2";
		InitCommand=cmd(visible,false;zoom,0.8;y,95;x,5);
	};

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/starfav")) .. {	
		Name="starp1";
		InitCommand=cmd(visible,false;zoom,0.8;y,95;x,-5);

	};	

	LoadActor(THEME:GetPathG("","ScreenSelectMusic/Wheel_random")) .. {	Name="Random";
		InitCommand=cmd(visible,false;scaletoclipped,256-2,160-2);
	};
	
};

return t;