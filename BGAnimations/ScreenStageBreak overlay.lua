local t = Def.ActorFrame{};

local luaFrameSkinSelectedStageBreak = getFrameSkinForPlayers("overlay","ScreenStageBreak");
if luaFrameSkinSelectedStageBreak["isDefault"] == false then
	-- we load the external lua :)
	local sbScreenFunction = LoadActor(luaFrameSkinSelectedStageBreak["lua"]);
	t[#t+1] = sbScreenFunction(luaFrameSkinSelectedStageBreak["path"]);
	return t;
end;


t[#t+1] = Def.ActorFrame
{
	LoadActor("ScreenBreak/breakAni")..{};

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