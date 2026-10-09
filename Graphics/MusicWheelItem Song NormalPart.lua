local t =  Def.ActorFrame{	};
local actualSong = "";
local actualPos=0;


t[#t+1] = Def.ActorFrame {
	CurrentSongChangedMessageCommand = function(self) 
		self:stoptweening();		
		local text = self:GetChild("nameSong"):GetChild("textName"):GetText();
		local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
		if text == songtitle then
			self:GetChild("nameSong"):visible(false);
		else
			self:GetChild("nameSong"):visible(true);
		end;

		self:sleep(0.01);
		self:queuecommand("updateName");	
	end;
	updateNameCommand=function(self)
		local actualPos = self:GetParent():GetParent():GetX();
		if actualPos > 0 then
			self:GetChild("nameSong"):GetChild("textName"):horizalign("right"):x(121);
		else
			self:GetChild("nameSong"):GetChild("textName"):horizalign("left"):x(-121);
		end;
	end;

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

			local titleSong = params.Song:GetDisplayMainTitle();
			actualSong = titleSong;
			self:GetChild("nameSong"):GetChild("textName"):settext(titleSong);

			--self:GetChild("blurBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256*.64,160*.64);			
			--self:GetChild("gBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256+4,160+8);			
			--self:GetChild("nBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256,160);


		   self:GetChild("gBanner"):visible(false);


		   --check size of the banner without scaletoclipped
		   self:GetChild("rBanner"):LoadFromCachedBanner(bpath);
			local is43image=false;
			local rBanner = self:GetChild("rBanner");
			-- the nBanner was getting forced to the scaletoclipped size, so 
			-- loading the thing on a new banner do the trick.
			-- because we are from the cache, the size is not the real one
			-- and we don't want to load anything from disk.
			-- after checking, most of the 4:3 images are saved below the 400w 
			-- ill go with that.
			local tw = rBanner:GetWidth();
			local th = rBanner:GetHeight();

			if tw < 400 then
				is43image = true;
			end;

			--load banner
		    self:GetChild("nBanner"):LoadFromCachedBanner(bpath):visible(false);	
			if is43image then
				self:GetChild("gBanner"):LoadFromCachedBanner(bpath):scaletoclipped(256+4,160+8):visible(true);	
				self:GetChild("nBanner"):scaletoclipped(212,160):visible(true); --4:3
			else
			   self:GetChild("gBanner"):Load(nil):visible(false);
			   self:GetChild("nBanner"):scaletoclipped(256,160):visible(true);				
			end;


			self:GetChild("Random"):visible(false);
		else
			--self:GetChild("blurBanner"):Load(nil);
			self:GetChild("gBanner"):Load(nil);
			self:GetChild("nBanner"):Load(nil);
			self:GetChild("Random"):visible(true);
		end;
	end;
	
	favStarCommand=function(self)

	end;

	--[[
	Def.Banner {	Name="blurBanner";
		InitCommand=cmd(scaletoclipped,256,160;xy,0,-10;z,-120;croptop,0.2;blend,Blend.Add;diffusealpha,.24;
			diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF9B");
			effectclock,'beat';effectperiod,5;fadeleft,0.1;faderight,0.1;visible,false);
	};
	]]
	
	Def.Quad {		Name="bBack2";
		InitCommand=cmd(zoomto,256+6,160+8;diffuse,color("#000000FF");shadowlength,3;);
	};



	Def.Quad {		Name="bBack";
		InitCommand=cmd(zoomto,256,160;diffuse,color("#000000FF"););
		OnCommand=function(self)
			self:diffuseleftedge(color("#333333AA"));
			self:diffuserightedge(color("#333333AA"));
		end;
	};

	
	Def.Banner {	Name="gBanner";
		InitCommand=cmd(scaletoclipped,256+2,160+4;xy,0,0;blend,Blend.Add;diffusealpha,0.12;);
	};

	Def.Banner {	Name="nBanner";
		InitCommand=cmd(scaletoclipped,256-2,160-2;xy,0,0;);
	};

	Def.Banner {	Name="rBanner";
		InitCommand=cmd(xy,0,0;diffusealpha,0;visible,false);
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

	Def.ActorFrame{
		Name="nameSong";
		OnCommand=function(self)
			self:x(0);
			self:y(70);
		end;

	    Def.Quad {
	    	Name="base";
	        InitCommand = function(self)
	            self:zoomto(256, 23):diffuse(color("#242424")):diffusealpha(0.8):y(-1);
	        end;
	    };
		LoadFont("_century gothic")..{
			Name="textName";
			OnCommand=cmd(horizalign,center;maxwidth,200;zoom,0.75;y,-3;shadowlength,1;shadowcolor,0,0,0,1;);
			OffCommand=cmd(finishtweening;linear,0.2;diffusealpha,0);
		};	



	}

	
};

return t;