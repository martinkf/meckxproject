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


return function(pathFolderSkin,player)
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
    local xBase = 0;
    local yBase = SCREEN_CENTER_Y-15;
    local zoomBase = 1;
    local extraJudgment = GAMESTATE:GetExtraJudgment();



    local bjActor = Def.ActorFrame
    {
        OnCommand=function(self)
            self:Center();
            self:x(xBase);
            self:y(yBase);
            self:zoom(zoomBase);
        end;
    };

    if extraJudgment then

        --Marvelous Perfect
        bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."extrajudg_evalab.png")..{
            OnCommand=cmd(Center;zoom,0.6;y,-108 + (35*1);zoomy,0;sleep,0.03;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
            FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
        };

        bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."extrajudg_text_evalab 1x2.png")..{
            OnCommand=cmd(Center;zoom,0.6;addx,4;y,-108+ (35*1);animate,false;setstate,0;zoomy,0;sleep,0.03;linear,0.3;zoomy,0.6;diffusealpha,1);
            FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
        }; 

        bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."extrajudg_evalab.png")..{
            OnCommand=cmd(Center;zoom,0.6;y,-107 + (35*2);zoomy,0;sleep,0.03;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
            FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
        };

        bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."extrajudg_text_evalab 1x2.png")..{
            OnCommand=cmd(Center;zoom,0.6;addx,4;y,-107+ (35*2);animate,false;setstate,1;zoomy,0;sleep,0.03;linear,0.3;zoomy,0.6;diffusealpha,1);
            FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
        }; 


        -- Normal Judgments.
        for i=2,6 do
            bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."Evalab_full 1x9.png")..{
                OnCommand=cmd(Center;zoom,0.6;y,(-110+36.4*i)+35;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
                FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
            };

            bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."text_Evalab_full 1x9.png")..{
                OnCommand=cmd(Center;zoom,0.6;y,(-107+36*i)+32;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;diffusealpha,1);
                FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
            };  
        end;

    else

        -- Normal Judgments.
        for i=1,6 do
            bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."Evalab_full 1x9.png")..{
                OnCommand=cmd(Center;zoom,0.6;y,-88+36*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;faderight,0.9;fadeleft,0.9;diffusealpha,0.8);
                FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
            };

            bjActor[#bjActor+1] = LoadActor(pathFolderSkin.."text_Evalab_full 1x9.png")..{
                OnCommand=cmd(Center;zoom,0.6;y,-88+36*i;animate,false;setstate,i-1;zoomy,0;sleep,0.03*i;linear,0.3;zoomy,0.6;diffusealpha,1);
                FinalizedMessageCommand=cmd(finishtweening;linear,0.2;zoomy,0)
            };  
        end;

    end;

    return bjActor;
    
end;

