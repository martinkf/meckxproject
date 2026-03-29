return function(params)

	-- params

	-- levers

	-- drawing
	local t = Def.ActorFrame {};

	t[#t+1] = Def.ActorFrame {
		Def.Sprite {
			Name="VideoBackground",
			InitCommand=function(self)
				self:x(SCREEN_CENTER_X)
				self:y(SCREEN_CENTER_Y)
			end,
			OnCommand=function(self)
				self:Load(THEME:GetPathG("","commonBackground/bredsm.mp4"))
				self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
				self:play()
			end,
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/bg/back3"))..{
			Name="GrayGridThatEffectsTheVideoPreview";
			InitCommand=function(self)
				self:x(SCREEN_CENTER_X)
				self:y(SCREEN_CENTER_Y)
				self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
				self:diffusealpha(0.8)
			end;
		};
	};

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			self:y(1)
		end;

		Def.Quad {
			Name="BeReadyQuad";
			InitCommand=function(self)
				self:valign(0)
				self:setsize(670,48)
				self:diffuse(0,0,0,0.9)
				self:fadeleft(0.2)
				self:faderight(0.2)
			end;
		};

		LoadFont("_TitleXolonium")..{
			Name="BeReadyText";
			Text="BE READY FOR...";
			InitCommand=function(self)
				self:y(22)
				self:valign(0.5)
				self:zoom(1.5)
				self:diffuse(1,0,0,1)
				self:maxwidth(960)
			end;
		};

	};

	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y+170)
		end;

		Def.Quad {
			Name="SongImageBackgroundBox";
			InitCommand=function(self)
				self:x(SCREEN_CENTER_X)
				self:zoomto(438,252)
				self:diffuse(0,0,0,0.8)
			end;
		};

		Def.Sprite {
			Name="SongImageDuplicateFor43";
			OnCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					local bg = song:GetBackgroundPath()
					if bg then
						self:Load(bg)
						self:x(SCREEN_CENTER_X)
						self:zoomto(426,240)
						self:diffuse(0.15,0.15,0.15,1)
					end
				end
			end
		};

		Def.Sprite {
			Name="SongImage";
			OnCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					local bg = song:GetBackgroundPath()
					if bg then
						self:Load(bg)
						self:x(SCREEN_CENTER_X)
						local targetH = 240
						self:zoom( targetH / self:GetHeight() )
					end
				end
			end
		};
	};

	--t[#t+1] = Def.ActorFrame {
		--Def.Quad {
			--Name="BottomMeckxArt";
			--InitCommand=function(self)
				--self:x(SCREEN_CENTER_X)
				--self:y(SCREEN_BOTTOM-12)
				--self:zoomto(SCREEN_WIDTH,24)
				--self:diffuse(0,0,0,0.9)
			--end;
		--};
	--};

	return t

end