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
			local externalAnnouncerPath = getExternalAnnouncerPath();
			if #externalAnnouncerPath > 0 then				
				local pathSound = checkIfAnnouncerSoundExists(externalAnnouncerPath,"STAGEBREAK");
				if #pathSound == 0 then
					SOUND:PlayOnce(THEME:GetPathS("","STAGEBREAK"));
				else
					SOUND:PlayOnce(pathSound);
				end;				
			else
				SOUND:PlayOnce(THEME:GetPathS("","STAGEBREAK"));
			end;
			
		end;
	};
};
return t;