

function setCustomOptionValuePlayer(player,option,value)
    local profile = PROFILEMAN:GetProfile(player);    

    --HERE WE WORK ON ENV if WE ARE GUEST
    if not PROFILEMAN:IsPersistentProfile(player) then
        setCustomOptionGuest(player,option,value);
        return;
    end;

    profile:SetCustomOptionValue(option,value);
end;

function getCustomOptionValuePlayer(player,option)
    local profile = PROFILEMAN:GetProfile(player);

    --HERE WE WORK ON ENV if WE ARE GUEST
    if not PROFILEMAN:IsPersistentProfile(player) then
        return getCustomOptionGuest(player,option);
    end;

    return profile:GetCustomOptionValue(option);
end;


--##CUSTOM OPTIONS FOR GUEST PLAYER, everything in memory, we will not save any option.
--##it will be created at the screen select title, even if is not used..
function createCustomOptionEnvPlayers(player)
    --same as Other/option.json
    local customOptions = { 
        {Option = 'judgmentSkin', Value = 'i_default'},
        {Option = 'judgmentZoom', Value = 100},
        {Option = 'lifebarSkin', Value = 'i_default'},
        {Option = 'gameplay_stats_ui', Value = false},
        {Option = 'gameplay_score_ui', Value = false},
        {Option = 'gameplay_score_percentaje_ui', Value = false},
        {Option = 'gameplay_song_time_ui', Value = false},
        {Option = 'gameplay_break_icon_ui', Value = false},
        {Option = 'gameplay_lv_ui',  Value = false},
        {Option = 'gameplay_fastslow',  Value = false},
        {Option = 'lifebar_extra_mode',  Value = 'none'},
        {Option = 'channelMusic',  Value = 'default (loop).ogg'},
        {Option = 'channelMusic_type',  Value = 'internal.ogg'},
        {Option = 'performance_mode',  Value = false},
        {Option = 'difficultyListMode',  Value = "sanity"},
    };

    if player == PLAYER_1 then
        GAMESTATE:Env()["P1CUSTOMOPTIONS"] = customOptions;
    else
        GAMESTATE:Env()["P2CUSTOMOPTIONS"] = customOptions;
    end;
    return true;
end;

function getCustomOptionGuest(player,option)

    local envOptionPlayer = "";

    if player == PLAYER_1 then
        if GAMESTATE:Env()["P1CUSTOMOPTIONS"] == nil then
            createCustomOptionEnvPlayers(player);
        end;
         envOptionPlayer = "P1CUSTOMOPTIONS";
    end;

    if player == PLAYER_2 then
        if GAMESTATE:Env()["P2CUSTOMOPTIONS"] == nil then
            createCustomOptionEnvPlayers(player);
        end;
        envOptionPlayer = "P2CUSTOMOPTIONS";
    end;

    for i = 1,#GAMESTATE:Env()[envOptionPlayer] do
        if GAMESTATE:Env()[envOptionPlayer][i]["Option"] == option then
            return GAMESTATE:Env()[envOptionPlayer][i]["Value"];
        end;
    end;

    return false;

end;

function setCustomOptionGuest(player,option,value)

    local envOptionPlayer = "";
    if player == PLAYER_1 then
        if GAMESTATE:Env()["P1CUSTOMOPTIONS"] == nil then
            createCustomOptionEnvPlayers(player);
        end;
        envOptionPlayer = "P1CUSTOMOPTIONS";
    end;

    if player == PLAYER_2 then
        if GAMESTATE:Env()["P2CUSTOMOPTIONS"] == nil then
            createCustomOptionEnvPlayers(player);
        end;
        envOptionPlayer = "P2CUSTOMOPTIONS";
    end;

    for i = 1 ,#GAMESTATE:Env()[envOptionPlayer] do
        if GAMESTATE:Env()[envOptionPlayer][i]["Option"] == option then
            GAMESTATE:Env()[envOptionPlayer][i]["Value"] = value;
            return true;
        end;
    end; 

    return false;

end;

--##END CUSTOM OPTIONS FOR GUEST PLAYER


--por ahora utilizar variables de entorno para todo esto si que se inicializan siempre.
function createEnvPlayer(player,reset)
    local optionsPlayer = {
        --esto se ocupa en el CW
        {Option = 'playercwmenu',  Default = "", isenv=true}
    };

    local playerp = "";
    if player == PLAYER_1 then
        playerp="P1";
    else
        playerp="P2";
    end;

	for i, opPlayer in ipairs(optionsPlayer) do
        --consultamos el parametro
        local paramActualPlayer = GAMESTATE:Env()[opPlayer.Option..""..playerp];
        if paramActualPlayer == nil or reset then
            GAMESTATE:Env()[opPlayer.Option..""..playerp] = opPlayer.Default;
        end; 
    end;

    return true;
end;


function setEnvPlayer(player,option,value)
    local playerp = "";
    if player == PLAYER_1 then
        playerp="P1";
    else
        playerp="P2";
    end;

    GAMESTATE:Env()[option..""..playerp] = value;

end;

function getEnvPlayer(player,option)
    local playerp = "";
    if player == PLAYER_1 then
        playerp="P1";
    else
        playerp="P2";
    end;

    if GAMESTATE:Env()[option..""..playerp] == nil then
        createEnvPlayer(player,true);
    end;

    if GAMESTATE:Env()[option..""..playerp] == nil then
        return "";
    else
        return GAMESTATE:Env()[option..""..playerp];
    end;
end;


