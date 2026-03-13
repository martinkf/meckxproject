


local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		OnCommand=cmd(linear,0.5;diffusealpha,1);
	};
	
	--[[OffCommand=function(self)
	
		for pn in ivalues(PlayerNumber) do 
			if GAMESTATE:IsPlayerEnabled(pn) then
				GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin("default");
				GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred' ):XMod(2);
			end;
		end;

	end;]]
};

return t;