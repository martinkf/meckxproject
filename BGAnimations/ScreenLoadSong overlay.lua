local t = Def.ActorFrame { };

t[#t+1] = LoadActor("Meckx/MeckxStageInformation.lua")( { } );

t[#t+1] = LoadActor("Meckx/MeckxSongTitleInfoBar.lua")( { YPosition = 136 } );

return t;