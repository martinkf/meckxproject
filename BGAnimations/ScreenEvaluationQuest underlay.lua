local t = Def.ActorFrame
{
	Def.Sprite {
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song:HasBackground() then
				self:LoadBackground(song:GetBackgroundPath());
			end;
			self:Center();
			
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
			
			self:diffusealpha(0.17);
		end;
	};
	
	
	--[[LoadActor(THEME:GetPathG("","SM-BGUP"))..{	
		InitCommand=cmd(animate,false;setstate,1;x,320;linear,.3;addy,77);
		OnCommand=cmd(setstate, 1);
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	LoadActor(THEME:GetPathG("","SM-BGUP"))..{	
		InitCommand=cmd(animate,false;setstate,1;x,320;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,77);
		OnCommand=cmd(setstate,1);
		OffCommand=cmd(finishtweening;linear,.2;addy,-77);
	};
	
	
	LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,100;x,100;diffusealpha,0;diffusecolor,1,0,.7,1;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(0,1,.4,1);
			self:queuecommand("Effect");
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,100;x,SCREEN_WIDTH-100;rotationy,-180;diffusealpha,0;diffusecolor,1,0,.7,1;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(0,1,.4,1);
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	

	
	LoadActor(THEME:GetPathG("","SM-HEADERGLOW 1x2"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,120;x,SCREEN_CENTER_X;diffusecolor,1,0,.15,1;diffusealpha,0;linear,.3;diffusealpha,1;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,.5;linear,.85;diffusealpha,1;queuecommand,"Effect");
		
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(0,1,.4,1);
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	
	-- FULL-QUEST XX FOOTER BG
	LoadActor(THEME:GetPathG("","SM-BGDOWN"))..{	
		InitCommand=cmd(animate,false;setstate,1;y,SCREEN_HEIGHT;x,320;linear,.3;addy,-189);
		OnCommand=cmd(setstate, 1);
		OffCommand=cmd(finishtweening;linear,.2;addy,189);
	};
	
	LoadActor(THEME:GetPathG("","SM-BGDOWN"))..{	
		InitCommand=cmd(animate,false;setstate,1;y,SCREEN_HEIGHT;x,SCREEN_WIDTH-320;rotationy,-180;linear,.3;addy,-189);
		OnCommand=cmd(setstate, 1);
		OffCommand=cmd(finishtweening;linear,.2;addy,189);
	};
	
	
	
	-- GLOW DOWN -- ;blend,Blend.Add
	LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,SCREEN_HEIGHT-100;x,320;diffusecolor,1,0,.5,1;diffusealpha,0;sleep,.3;queuecommand,"Effect");
		EffectCommand=cmd(stoptweening;linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(.3,1,0,1);
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};

	LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,0;blend,Blend.Add;y,SCREEN_HEIGHT-100;x,SCREEN_WIDTH-320;rotationy,-180;diffusecolor,1,0,.5,1;diffusealpha,0;sleep,.3;queuecommand,"Effect");
		EffectCommand=cmd(stoptweening;linear,.85;diffusealpha,.4;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(.3,1,0,1);
			self:queuecommand("Effect");
		end;
		OffCommand=cmd(finishtweening;visible,false);
	};


	LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,SCREEN_HEIGHT;x,320;diffusecolor,1,0,.8,1;linear,.3;addy,-106;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,0;linear,.85;diffusealpha,1;queuecommand,"Effect");
		
		OnCommand=cmd(finishtweening;playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(.3,1,0,1);
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	};
	
	LoadActor(THEME:GetPathG("","SM-FOOTERGLOW"))..{	
		InitCommand=cmd(animate,false;setstate,1;blend,Blend.Add;y,SCREEN_HEIGHT;x,SCREEN_WIDTH-320;rotationy,-180;diffusecolor,1,0,.8,1;linear,.3;addy,-106;queuecommand,"Effect");
		EffectCommand=cmd(linear,.85;diffusealpha,0;linear,.85;diffusealpha,1;queuecommand,"Effect");
		OnCommand=cmd(finishtweening;playcommand,"GlowColor");
		
		GlowColorCommand=function(self)
			self:stoptweening();
			self:diffusecolor(.3,1,0,1);
			self:queuecommand("Effect");
		end;
		
		OffCommand=cmd(finishtweening;visible,false);
	}; ]]--
	-------------------------------------------------------------------------------------------------
	
	
};
return t;