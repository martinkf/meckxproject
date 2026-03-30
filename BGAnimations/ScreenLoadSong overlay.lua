local t = Def.ActorFrame { };

t[#t+1] = Def.ActorFrame {
    InitCommand=function(self)
        self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1):sleep(3):linear(0.25):diffusealpha(0)
    end;
    LoadActor("Meckx/MeckxStageInformation.lua")( { } );
};

t[#t+1] = Def.ActorFrame {
    InitCommand=function(self)
        self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1):sleep(3):linear(0.25):diffusealpha(0)
    end;
    LoadActor("Meckx/MeckxSongTitleInfoBar.lua")( { YPosition = 136 } );
};

for p=-1,1,2 do
    if GAMESTATE:IsPlayerEnabled((p == -1) and PLAYER_1 or PLAYER_2) then
        t[#t+1] = Def.ActorFrame {
            InitCommand=function(self)
                self:finishtweening():diffusealpha(0):sleep(0.25):linear(0.25):diffusealpha(1):sleep(3):linear(0.25):diffusealpha(0)
            end;
            LoadActor("Meckx/MeckxChartDetailsInfoBar.lua")( { XBasal = 640, XBiased = 320, YPosition = 274, Player = p } );
        };
    end;
end;

return t;