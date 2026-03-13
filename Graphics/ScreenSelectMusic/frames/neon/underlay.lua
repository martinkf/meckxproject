local t = Def.ActorFrame { };

--header.
local zoomgeneralTop=0.7;
local topArrangeY=25;
local topArrangeX=360;
	t[#t+1] = Def.ActorFrame {

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topbase"))..{
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X-(topArrangeX+20),SCREEN_TOP+topArrangeY+5;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topbase"))..{
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X+(topArrangeX+20),SCREEN_TOP+topArrangeY+5;diffusealpha,1;rotationy,180);
		};		


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/toplbold"))..{
			Name="baselighta";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X-(topArrangeX+8),SCREEN_TOP+topArrangeY;diffusealpha,0.2);
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topglowbold"))..{
			Name="Neona";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X-(topArrangeX+8),SCREEN_TOP+topArrangeY;diffusealpha,1;blend,"BlendMode_Add";diffusecolor,color("#ff0081"));
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topltin"))..{
			Name="baselightb";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X-(topArrangeX+15),SCREEN_TOP+topArrangeY+10;diffusealpha,1;blend,"BlendMode_Add";diffusecolor,color("#ff0081"));
		};





		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/toplbold"))..{
			Name="baselightb";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X+(topArrangeX+8),SCREEN_TOP+topArrangeY;diffusealpha,0.2;rotationy,180;blend,"BlendMode_Add");
		};

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topglowbold"))..{
			Name="Neonb";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X+(topArrangeX+8),SCREEN_TOP+topArrangeY;diffusealpha,1;rotationy,180;blend,"BlendMode_Add";diffusecolor,color("#ff0081"));
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/topltin"))..{
			Name="baselightb";
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X+(topArrangeX+8),SCREEN_TOP+topArrangeY+10;diffusealpha,1;rotationy,180;blend,"BlendMode_Add";diffusecolor,color("#ff0081"));
		};


		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/lv"))..{
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X-(topArrangeX+150),SCREEN_CENTER_Y+135;diffusealpha,1);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
		};
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/neon/lv"))..{
			OnCommand=cmd(zoom,zoomgeneralTop;xy,SCREEN_CENTER_X+(topArrangeX+150),SCREEN_CENTER_Y+135;diffusealpha,1;rotationy,180);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
		};		

		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0);


	};
	

return t;