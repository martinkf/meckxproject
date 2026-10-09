--You can register options for your theme, it will show on the "Profile Editor Screen".
--For the moment all options will be boleans as "True" or "False" option.
function getRegisteredThemeOptions()
    --This options are All Booleans, so try to put things that can be toggle on or off.
    local options = {
        {   
            name = "Song Step Graph",
            statusFunction=function(p) return ThemeOption_getStatusShowGraph(p) end,
            actionFunction=function(p) return ThemeOption_changeStatusShowSongGraph(p, s) end,
            text_en="Display the selected song's chart graph.",
            text_es="Muestra el grafico de los steps cuando seleccionas una canción",
            text_pt="Exibir o gráfico do chart da música selecionada.",
            text_kr="선택한 곡의 채보 그래프를 표시합니다.",
            --it will try to load the image from graphics/
            preview="ScreenPlayerProfileCustom/themeOptions/graphSongPreview",
        },

    }
    return options;
end;

--Show Graph.
function ThemeOption_getStatusShowGraph(player)
    local status = getCustomOptionValuePlayer(player,"theme_show_song_graph");
    if status == nil then
        return true; --true by default :P
    end;
    return status;
end;

function ThemeOption_changeStatusShowSongGraph(player)
    local skinPlayer = getCustomOptionValuePlayer(player,"theme_show_song_graph");
    if skinPlayer == nil then
        setCustomOptionValuePlayer(player,"theme_show_song_graph",true);
        return true;
    end;

    if skinPlayer then
        setCustomOptionValuePlayer(player,"theme_show_song_graph",false);
        return false;
    else
        setCustomOptionValuePlayer(player,"theme_show_song_graph",true);
        return true;
    end;    
end;

