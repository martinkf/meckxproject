local t = Def.ActorFrame
{

	LoadActor("ScreenBreak/breakAni")..{};

	--[[
	LoadActor(THEME:GetPathG("","VIDEO/STAGEBREAK"))..
	{
		OnCommand=cmd(Center;loop,false);
	};
	]]

	Def.Sound {	--BGM
		OnCommand=cmd(queuecommand,"Lot");
		LotCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("","STAGEBREAK"));
		end;
	};
};
return t;