-- USO / USAGE --
--[[
    **** EN:
    The filenames for the grades are fixed and cannot be changed.
    Pass grade: pass_res 1x16.png
    Fail grade: fail_pass_res 1x16.png
    The theme will look for these files and use them wherever a grade is displayed (rankings, Screen Select Music, etc.).

    The grade_letters.lua file returns an actor responsible for displaying the obtained grade.
    Other than these two files required by the theme, you are free to create the actor however you like, using any sprites you consider appropriate.

    **** ES:
    El nombre de los archivos para los grados son fijos, no pueden tener otro nombre.
    Pass grade - pass_res 1x16.png 
    Fail Grade-  fail_pass_res 1x16.png
    el theme los buscara para utilizarlos donde se muestre algun grado (rankings, screen select music, etc).

    Este archivo grade_letters.lua retorna un actor que debe mostrar el grado obtenido.
    Fuera de esos 2 archivos que el theme necesita, puedes crear como quieras el actor con los sprites que estimes conveniente.

    ARKA.
]]


return function(pathFolderSkin,player,indexGradeSprite,playerJudgments,extraJudgment)
    --[[
        *** Structure of playerJudgments and extraJudgment array.
        *** the more you know :D
        playerJudgments = {
            Perfect     = pnStageStats:GetTapNoteScores("TapNoteScore_W1") +
                          pnStageStats:GetTapNoteScores("TapNoteScore_W2") +
                          pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointHit");      
            Great       = pnStageStats:GetTapNoteScores('TapNoteScore_W3');
            Good        = pnStageStats:GetTapNoteScores('TapNoteScore_W4');
            Bad         = pnStageStats:GetTapNoteScores('TapNoteScore_W5');
            Miss        = pnStageStats:GetTapNoteScores("TapNoteScore_Miss") +
                          pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
            MaxCombo    = pnStageStats:MaxCombo();
            Score       = pnStageStats:GetScore();
            Kcal        = pnStageStats:GetCaloriesBurned();
            Grade       = pnStageStats:GetGrade();
            Failed      = pnStageStats:GetFailedAux();
        };

        extraJudgment = {
            MPerfectExtraJudg = pnStageStats:GetTapNoteScores("TapNoteScore_W1") + pnStageStats:GetTapNoteScores("TapNoteScore_CheckpointHit");
            PerfectExtraJudg = pnStageStats:GetTapNoteScores("TapNoteScore_W2");
        };
    ]]

    --X/Y used as base for the actorFrame
    local DelayGradeShow = 3.1;
    
    local xBase = SCREEN_CENTER_X;
    local yBase = SCREEN_CENTER_Y;
    if player == PLAYER_1 then
        xBase = SCREEN_CENTER_X-375;
    else
        xBase = SCREEN_CENTER_X+375;
    end;

    -- Message below the Grade Letter.
    local clearStatus = 7;
    
    --RG
    if playerJudgments["Miss"] > 20 then
    	clearStatus = 7;
    elseif playerJudgments["Miss"] <= 5 then
    	clearStatus = 4;
    elseif playerJudgments["Miss"] <= 10 then
    	clearStatus = 5;
    elseif playerJudgments["Miss"] <= 20 then
    	clearStatus = 6;
    end;

    --ap
    if playerJudgments["Perfect"] > 0 and playerJudgments["Great"] == 0 and playerJudgments["Good"] == 0 and playerJudgments["Bad"] == 0 and playerJudgments["Miss"] == 0 then
    	clearStatus = 0;
    end;

    --UG
    if playerJudgments["Perfect"] > 0 and playerJudgments["Great"] > 0 and playerJudgments["Good"] == 0 and playerJudgments["Bad"] == 0 and playerJudgments["Miss"] == 0 then
    	clearStatus = 1;
    end;

    --EG
    if playerJudgments["Perfect"] > 0 and playerJudgments["Great"] >= 0 and playerJudgments["Good"] > 0 and playerJudgments["Bad"] == 0 and playerJudgments["Miss"] == 0 then
    	clearStatus = 2;
    end;

    --superb
    if playerJudgments["Perfect"] > 0 and playerJudgments["Great"] >= 0 and playerJudgments["Good"] >= 0 and playerJudgments["Bad"] > 0 and playerJudgments["Miss"] == 0 then
    	clearStatus = 3;
    end;

    if playerJudgments["Failed"] then
        return Def.ActorFrame
        {
            OnCommand=function(self)
                self:Center();
                self:x(xBase);
                self:y(yBase);
            end;

            LoadActor(pathFolderSkin.."fail_pass_res")..{
                OnCommand=cmd(animate,false;setstate,indexGradeSprite;zoom,1.2;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.95;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);			
                FinalizedMessageCommand=cmd(finishtweening;visible,false);
            };
        };
    else
        return Def.ActorFrame
        {
            OnCommand=function(self)
                self:Center();
                self:x(xBase);
                self:y(yBase);
            end;

            LoadActor(pathFolderSkin.."pass_res")..{
                OnCommand=cmd(animate,false;setstate,indexGradeSprite;zoom,1.4;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.85);			
                FinalizedMessageCommand=cmd(finishtweening;visible,false);
            };
            
            LoadActor(pathFolderSkin.."pass_res")..{
                OnCommand=cmd(addy,0;animate,false;setstate,indexGradeSprite;zoom,0.4325;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.2;diffusealpha,1;zoom,0.95;linear,0.4;zoom,1.8;diffusealpha,0;blend,Blend.Add);
                FinalizedMessageCommand=cmd(finishtweening;visible,false);
            };

            LoadActor(pathFolderSkin.."ac_play")..{
                OnCommand=cmd(addy,110;animate,false;setstate,clearStatus;zoom,1.4;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.65);			
                FinalizedMessageCommand=cmd(finishtweening;visible,false);
            };

        };

    end;

end;