local t = Def.ActorFrame { };


function crearEstrellasBase()
	local linearBase=0.9; 
	return Def.ActorFrame { 

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.15;xy,SCREEN_CENTER_X-(560),SCREEN_CENTER_Y+75;decelerate,linearBase;diffusealpha,1;rotationz,5);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};		

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.11;xy,SCREEN_CENTER_X-(590),SCREEN_CENTER_Y+95;decelerate,linearBase;diffusealpha,1;rotationz,-20);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};		

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.08;xy,SCREEN_CENTER_X-(580),SCREEN_CENTER_Y+115;decelerate,linearBase;diffusealpha,1;rotationz,-25);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};	

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.15;xy,SCREEN_CENTER_X+(560),SCREEN_CENTER_Y+75;;rotationy,180;decelerate,linearBase;diffusealpha,1;rotationz,-5);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};		

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.11;xy,SCREEN_CENTER_X+(590),SCREEN_CENTER_Y+95;;rotationy,180;decelerate,linearBase;diffusealpha,1;rotationz,-20);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};		

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/effect_star0"))..{
			OnCommand=cmd(diffusealpha,0;zoom,0.08;xy,SCREEN_CENTER_X+(580),SCREEN_CENTER_Y+115;;rotationy,180;decelerate,linearBase;diffusealpha,1;rotationz,-25);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);
			};	

			SelectChannelMessageCommand=cmd(zoom,1;linear,0.08;y,60;diffusealpha,1);
			ChannelChosenMessageCommand=cmd(zoom,1;linear,0.05;y,0;diffusealpha,1);

	};
end;


t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/lvbase"))..{
			OnCommand=cmd(zoom,1;xy,SCREEN_CENTER_X-(500),SCREEN_CENTER_Y+129;diffusealpha,1);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);

			SelectChannelMessageCommand=cmd(zoom,1;linear,0.08;xy,SCREEN_CENTER_X-(500),SCREEN_CENTER_Y+200;diffusealpha,1);
			ChannelChosenMessageCommand=cmd(zoom,1;linear,0.05;xy,SCREEN_CENTER_X-(500),SCREEN_CENTER_Y+129;diffusealpha,1);

		};
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/colorful/lvbase"))..{
			OnCommand=cmd(zoom,1;xy,SCREEN_CENTER_X+(500),SCREEN_CENTER_Y+129;diffusealpha,1;rotationy,180);
			SongChosenMessageCommand=cmd(stoptweening;diffusealpha,0);
			SongUnchosenMessageCommand=cmd(stoptweening;diffusealpha,1);

			SelectChannelMessageCommand=cmd(zoom,1;linear,0.08;xy,SCREEN_CENTER_X+(500),SCREEN_CENTER_Y+200;diffusealpha,1;rotationy,180);
			ChannelChosenMessageCommand=cmd(zoom,1;linear,0.05;xy,SCREEN_CENTER_X+(500),SCREEN_CENTER_Y+129;diffusealpha,1;rotationy,180);			
};



--t[#t+1] = crearEstrellasBase();

return t;