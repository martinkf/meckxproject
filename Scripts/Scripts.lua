function GetFileExtension(url)
	return url:match("^.+(%..+)$")
end;

function FolderExists(path)
    local success, result = pcall(function()
        local listing = FILEMAN:GetDirListing(path, false, true)
        return listing ~= nil
    end)
    return success and result
end

function getColorByStepType(stepType,numPlayers)
	if numPlayers > 1 then
		return color("#f6ed00"); --coop
	else
		if stepType == 'StepsType_Pump_Single' then
			return color("#eb1b00");
		end;
		if stepType == 'StepsType_Pump_Double' then
			return color("#21a305");
		end;
		if stepType == 'StepsType_Pump_Single_P' then
			return color("#7e0c7e");
		end;
		if stepType == 'StepsType_Pump_Double_P' then
			return color("#003391");
		end;
		if  stepType == 'StepsType_Pump_Halfdouble' then
			return color("#007272");
		end;

		return color("#eb1b00");
	end;
end;

function getDificultyListPlugins()
	local lista = {};
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/BGAnimations/ScreenSelectMusicLua/Interface_Full_DifficultyList/";
    local entries = FILEMAN:GetDirListing(directory, true, false);
    local folders = {};

    for _, entry in ipairs(entries) do
        table.insert(folders, entry);
    end;

    return folders;
end;

function getPathDifficultyListPlugins()
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenSelectMusic/DifficultyList/";
    return directory;
end;

function FindFileWithPatternOnDirectory(directory, pattern)
    local files = FILEMAN:GetDirListing(directory, false,false) -- Solo archivos
    for _, file in ipairs(files) do
        if string.find(file, pattern) then
            return file;
        end
    end
    return "-";
end

function getFilesWithPatternOnDirectory(directory, pattern)
    local files = FILEMAN:GetDirListing(directory, false,false) -- Solo archivos
    local filesSelected = {};
    for _, file in ipairs(files) do
    	for x = 1,#pattern do
	        if string.find(file, pattern[x]) then
            	table.insert(filesSelected,file);
        	end
    	end;

    end
    return filesSelected;
end

function formatNumberWithDots(n)
    local formatted = tostring(n)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1.%2")
        if k == 0 then break end
    end
    return formatted
end

function truncateToTwoDecimals(num)
    return math.floor(num * 100) / 100
end


function scorecap(n) --[[ credit http://richard.warburton.it ]]		--herencia de piu delta
local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$');
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right;
end;

function counterformat(n)			-- administra numeros y los formatea: < 1000 --> 001 | > 1000 --> 1,000
	if tonumber(n) then return n > 999 and scorecap(n) or string.format("%03i",n); end;
return 0;
end;

--***** MISSION AND OTHER THINGS FROM PIU ORIG - OBJ FILES *****--
function checkForObjFilesPiuContent()
	local checkPass = 3;
	local actualCheck = 0;

	local fileLua = FindFileWithPatternOnDirectory("/GameData/","INDT.obj");
	Trace(":::FILE LUA:::-> "..fileLua);
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	fileLua = FindFileWithPatternOnDirectory("/GameData/","WMDT.obj");
	Trace(":::FILE LUA:::-> "..fileLua);
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	fileLua = FindFileWithPatternOnDirectory("/GameData/","WMSF.obj");
	Trace(":::FILE LUA:::-> "..fileLua);
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	if checkPass == actualCheck then
		return true;
	else
		return false;
	end;

end;

--****** Announcer ******--
function getExternalAnnouncerPath()
	--we check if there is a folder to select from the Mod/Announcers
	local announcerSelected = "piu";

	--we check if the folder exist
	local announcerModsPath = "/Mods/announcers/"..announcerSelected;
	if FolderExists(announcerModsPath) then
		return announcerModsPath.."/"
	else		
		return "";
	end;
end;

function checkIfAnnouncerSoundExists(path,sound)
	if FILEMAN:DoesFileExist(path..sound..".mp3") then
		return path..sound..".mp3";
	end;	
	if FILEMAN:DoesFileExist(path..sound..".ogg") then
		return path..sound..".ogg";
	end;	
	if FILEMAN:DoesFileExist(path..sound..".wav") then
		return path..sound..".wav";
	end;	

	--fallback to the themes sound.
	return "";
end;

--****** Channel music ******--
local ChannelMusicExternalPath = "/Mod/ChannelMusic/";
function GetChannelMusicExternalPath()
	return ChannelMusicExternalPath;
end;

--****** LIFEBARSKIN *****--
local lifebarSkinExternal = "/Mods/LifebarSkins/";
function GetLifebarSkinExternalPath()
	return lifebarSkinExternal;
end;

function getPathSkinLifeBar(skinName)
	local activeTheme = THEME:GetCurThemeName();

	if skinName == "none" then
		pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenGamePlay_ui/lifebar/default";
	end;

		--tenemos que saber a donde hay que buscar el path
	local esExterno = string.find(skinName, "e_");
	local esInterno = string.find(skinName, "i_");
	local pathSkin = "";
	local skinNameProcesado = "";
	if esExterno ~= nil then
		skinNameProcesado = string.gsub(skinName, "e_", "");
		local lifebarSkinExternalPath = GetLifebarSkinExternalPath();
		pathSkin = lifebarSkinExternalPath..skinNameProcesado;		
	end;

	if esInterno ~= nil then
	  	skinNameProcesado = string.gsub(skinName, "i_", "");
	  	pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenGamePlay_ui/lifebar/"..skinNameProcesado;	  	
	end;

	if esExterno == nil and esInterno == nil then		
		pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenGamePlay_ui/lifebar/default";
	end;

	return pathSkin;
end;

--****** JUDGMENT *****--
local judgmentSkinExternal = "/Mods/JudgmentSkins/";

function GetJudgSkinExternalPath()
	return judgmentSkinExternal;
end;

function GetPNGIconJudgSkin(skinName)
	local esExterno = string.find(skinName, "e_");
	local pathIcon = "";
	local skinNameProcesado = "";
	if esExterno ~= nil then
		skinNameProcesado = string.gsub(skinName, "e_", "");
		pathIcon = judgmentSkinExternal..skinNameProcesado.."/Icon.";		
	else
	  	local activeTheme = THEME:GetCurThemeName();
	  	skinNameProcesado = string.gsub(skinName, "i_", "");
	  	pathIcon = "/Themes/"..activeTheme.."/Graphics/Player judgment/skins/"..skinNameProcesado.."/Icon.";	  	
	end;

	
	if FILEMAN:DoesFileExist(pathIcon.."png") then
		return pathIcon.."*";
	else
		return THEME:GetPathG("","_blank");
	end;		
end;

function judgmentHasLua(name,external)
	local defaultFolder="sanity";
	local pathJudgSkins = "";
	if name == "default" or #name == 0 or name == nil then
  		return "-";
  	end;

  if external then
  	pathJudgSkins = judgmentSkinExternal;
  else  	 
  	local activeTheme = THEME:GetCurThemeName();
  	pathJudgSkins = "/Themes/"..activeTheme.."/Graphics/Player judgment/skins/";
  end;

	--local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/","default.lua");
	local judgmentFileTemplate = "-";
	for i=1,3 do
		if i == 1 then
			fileLua = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/","default.lua");
			if fileLua ~= "-" then
				judgmentFileTemplate = fileLua;
				break;
			end;
		elseif i == 2 then
			fileLua = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/","Default.lua");
			if fileLua ~= "-" then
				judgmentFileTemplate = fileLua;
				break;
			end;			
		elseif i == 3 then
			fileLua = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/","DEFAULT.lua");
			if fileLua ~= "-" then
				judgmentFileTemplate = fileLua;
				break;
			end;			
		end;
	end;


	if judgmentFileTemplate == "-" then
	 	return "-";
	 else
	 	return judgmentFileTemplate;
	end;
end;

function getSkinJudgmentTemplateNew(type,name,external)

	--primero escaneamos la carpeta para obtener los archivos, seremos medios estrictos con los nombres de archivos
	-- Judgments : representa los judg
	-- Extra_text : Fast Slow
	-- Label : Texto combo
	-- Combo numbers.ini : numeros para el combo
	-- Icon : icono por si se quiere utilizar en algo, que se yo xD
	local defaultFolder="sanity";
	local pathJudgSkins = "";

  if external then
  	pathJudgSkins = judgmentSkinExternal;
  else  	 
  	local activeTheme = THEME:GetCurThemeName();
  	pathJudgSkins = "/Themes/"..activeTheme.."/Graphics/Player judgment/skins/";
  end;

  local spritePatterns ={"Judgment","Extra_text","Label","ini","Icon"};


  local judgmentSprite = "Judgments 1x6.png";
  local extraTextSprite = "Extra_text 1x2.png";
  local labelSprite = "Label (doubleres).png";
  local comboNumberFont = "Combo numbers.ini";
  local iconSprite = "Icon.png";

  if name == "default" or #name == 0 or name == nil then
  	name = defaultFolder;
  end;

	if type == "judgments" then
			local returnPath = "";
		  local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/",spritePatterns[1]);
		  if judgmentFileTemplate == "-" then
		  	return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..judgmentSprite);
		  else
		  	return pathJudgSkins..name.."/"..judgmentFileTemplate;
		  end;		  
		  return returnPath;
	elseif type == "extra" then
			local returnPath = "";
		  local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/",spritePatterns[2]);
		  if judgmentFileTemplate == "-" then
		  	return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..extraTextSprite);
		  else
		  	return pathJudgSkins..name.."/"..judgmentFileTemplate;	
		  end;		  
	elseif type == "combo" then
			local returnPath = "";
		  local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/",spritePatterns[3]);
		  --Trace("return pattern combo:"..judgmentFileTemplate);
		  if judgmentFileTemplate == "-" then
		  	return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..labelSprite);
		  else
		  	return pathJudgSkins..name.."/"..judgmentFileTemplate;
		  end;
	elseif type == "comboNumber" then
			if external then
				if not FILEMAN:DoesFileExist(pathJudgSkins.."/"..name.."/"..comboNumberFont) then
					return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..comboNumberFont);
				end;				
				return pathJudgSkins.."/"..name.."/"..comboNumberFont;				
			else
				local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/",spritePatterns[4]);
				if judgmentFileTemplate == "-" then
					return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..comboNumberFont);
				end;				
				return THEME:GetPathG("","Player judgment/skins/"..name.."/"..comboNumberFont);
			end;		 
	elseif type == "icon" then		
			local returnPath = "";
		  local judgmentFileTemplate = FindFileWithPatternOnDirectory(pathJudgSkins..name.."/",spritePatterns[5]);
		  if judgmentFileTemplate == "-" then
		  	return THEME:GetPathG("","Player judgment/skins/"..defaultFolder.."/"..iconSprite);
		  else
		  	return pathJudgSkins..name.."/"..judgmentFileTemplate;
		  end;
	else
		return THEME:GetPathG("","_blank");
	end;
end;




--type:judgments,extra,combo,icon
--name: nombre de la carpeta del skin
--external: si va a revisar a alguna carpeta que sea externa para custom skins de usuarios :o
function getSkinJudgmentTemplate(type,name,external)

	local fileSkin = "";

	if type == "judgments" then
		fileSkin = "Judgments 1x6.png";
	elseif type == "extra" then
		fileSkin = "Extra_text 1x2.png";
	elseif type == "combo" then
		fileSkin = "Label.png";
	elseif type == "comboNumber" then
		fileSkin = "Combo numbers.ini";
	elseif type == "icon" then
		fileSkin = "Icon.png";
	else
		return THEME:GetPathG("","_blank");
	end;

  if external then
  	local pathSprite = judgmentSkinExternal..name.."/"..fileSkin;
		if not FILEMAN:DoesFileExist(pathSprite) then
			return THEME:GetPathG("","Player judgment/skins/sanity/"..fileSkin);
		end;
		return pathSprite;
  else
  	local pathSprite = "Player judgment/skins/"..name.."/"..fileSkin;
		if not FILEMAN:DoesFileExist(THEME:GetPathG("",pathSprite)) then
			return THEME:GetPathG("","Player judgment/skins/sanity/"..fileSkin);
		end;
		return THEME:GetPathG("",pathSprite);
  end;
end;


function spriteJudgmentJudment()
	if GAMESTATE:GetGameMode() == "WorldMax" then
		return THEME:GetPathG("","Player judgment/_NXAjudgments");
	elseif GAMESTATE:GetGameMode() == "QuestWorld" then
		return THEME:GetPathG("","Player judgment/_FIESTAEXjudgments");
	elseif GAMESTATE:GetExtraJudgment() then
		return THEME:GetPathG("","Player judgment/_extrajudgments");
	else
		return THEME:GetPathG("","Player judgment/_judgments");
	end;
end;
function spriteJudgmentCombo()
	if GAMESTATE:GetGameMode() == "WorldMax" then
		return THEME:GetPathG("","Player judgment/_NXAcombo");
	elseif GAMESTATE:GetGameMode() == "QuestWorld" then
		return THEME:GetPathG("","Player judgment/_FIESTAEXcombo");
	else
		return THEME:GetPathG("","Player judgment/_combo");
	end;
end;
function spriteJudgmentComboNumbers()
	if GAMESTATE:GetGameMode() == "WorldMax" then
		return THEME:GetPathF("","NXACombo numbers.ini");
	elseif GAMESTATE:GetGameMode() == "QuestWorld" then
		return THEME:GetPathF("","FIESTAEXCombo numbers.ini");
	else
		return THEME:GetPathF("","Combo numbers.ini");
	end;
end;

function Sprite:LoadVideoPreview(song)
	local Path = THEME:GetPathG("","_blank.png");
	if song ~= nil and song:GetPreviewVidPath() ~= nil then
		local prev = song:GetPreviewVidPath();
		local ext = GetFileExtension(prev);
		
		if ext ~= ".png" and ext ~= ".jpg" then
			if FILEMAN:DoesFileExist(song:GetPreviewVidPath()) then
				Path = song:GetPreviewVidPath();
			end;
		end;
	end;
	self:LoadBackground( Path )
end;

-- JNC, esto que reemplace el scaletoclipped feo ctmmmmm
function Sprite:ScaleToCustom(ValWidth, ValHeight)
	local height = self:GetTexture():GetImageHeight();
	local width = self:GetTexture():GetImageWidth();

	if (height > 0 and width > 0) then
		height = self:GetTexture():GetImageHeight() / ValHeight;
		width = self:GetTexture():GetImageWidth() / ValWidth;
		
		if (height > 1) then height = (1 / height); else height = (ValHeight / self:GetTexture():GetImageHeight()) end;
		if (width > 1) then width = (1 / width); else width = (ValWidth / self:GetTexture():GetImageWidth()) end;
		self:zoomy(height);
		self:zoomx(width);
	end;
end;

function Sprite:LoadPreviewSongExtended(song)
	
	if song == nil then
		self:LoadBackground( THEME:GetPathG("","_blank.png") );
		return;
	end;
	
	local Path = "";
	
	if (song:GetPreviewVidPath() == nil or song:GetPreviewVidPath() == "") then
		Path = song:GetBackgroundPath();

		if Path == nil or Path == ""  or not FILEMAN:DoesFileExist( Path) then
			self:LoadBackground( THEME:GetPathG("","_blank.png") );
		else
			self:LoadBackground( Path );
		end;

		return;
	end;
	
	
	local sFileOnly = string.match(song:GetPreviewVidPath(), ".*/(.*)");
	local sFileNoExtension;
	-- Si hay extension
	if (string.find(sFileOnly, '.') > 0) then
		sFileNoExtension = string.sub(sFileOnly, 1, string.len(sFileOnly) - 4 )
	else
		sFileNoExtension = sFileOnly;
	end;
	
	local sPrevFolder = "/Previews_HD/";
	if (FILEMAN:DoesFileExist(sPrevFolder .. sFileNoExtension .. ".mp4"  ) ) then
		Path = sPrevFolder .. sFileNoExtension .. ".mp4";
	elseif (FILEMAN:DoesFileExist(sPrevFolder .. sFileNoExtension .. ".mpg")) then
		Path = sPrevFolder .. sFileNoExtension .. ".mpg";
	elseif (FILEMAN:DoesFileExist(sPrevFolder .. sFileNoExtension .. ".avi")) then
		Path = sPrevFolder .. sFileNoExtension .. ".avi";
	else
		if (song:HasPreviewVid()) and (FILEMAN:DoesFileExist(song:GetPreviewVidPath())) then
			Path = song:GetPreviewVidPath();
		else
			Path = song:GetBackgroundPath();
			if not FILEMAN:DoesFileExist( song:GetBackgroundPath()) then
				Path = THEME:GetPathG("","_blank.png");
			end;
		end;
	end;
	self:LoadBackground( Path );
	
end;

function Sprite:oldLoadVideoPreview(song)
	local Path = ""
	if song ~= nil then
		local prevPath = string.gsub(song:GetSongDir(), '/Songs/'..song:GetGroupName()..'/','Previews/')
		prevPath = string.sub(prevPath, 1, string.len(prevPath)-1)
		if (FILEMAN:DoesFileExist(prevPath.."_P.mpg")) then
			Path = prevPath.."_P.mpg"
		elseif (FILEMAN:DoesFileExist(prevPath.."_P.avi")) then
			Path = prevPath.."_P.avi"
		elseif (FILEMAN:DoesFileExist(prevPath.."_P.mpeg")) then
			Path = prevPath.."_P.mpeg"
		elseif (FILEMAN:DoesFileExist(prevPath.."_P.mp4")) then
			Path = prevPath.."_P.mp4"
		else
			if (song:HasPreviewVid()) and (FILEMAN:DoesFileExist(song:GetPreviewVidPath())) then
			Path = song:GetPreviewVidPath();
			end;
		end
		if Path == "" or not Path then
			Path = THEME:GetPathG("","_blank.png");
		end
	else
		Path = THEME:GetPathG("","_blank.png");
	end;
	self:LoadBackground( Path )
end;

function Sprite:ChangeBack(path)
	self:LoadBackground(path)
end;
function round_function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
function RandomBga()
	local bgas={"000.mpg",
				"001.mpg",
				"002.mpg",
				"003.mpg",
				"004.mpg",
				"005.mpg",
				"006.mpg",
				"007.mpg",
				"008.mpg",
				"009.mpg"};
	return bgas[math.random(1,#bgas)];
end
function dot_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

-- JNC
function TierToState(grade)	

	if grade == "Grade_Tier01" then
		return 0; --SS	
	elseif grade == "Grade_Tier02" then
		return 1; --S
	elseif grade == "Grade_Tier03" then
		return 2; --s
	elseif grade == "Grade_Tier04" then
		return 3; --A
	elseif grade == "Grade_Tier05" then
		return 4; --B
	elseif grade == "Grade_Tier06" then
		return 5; --C
	elseif grade == "Grade_Tier07" then
		return 6; --D
	else
		return 7; --F
	end;
	
end;


function debugearTabla(tbl, indentLevel, visited, asString)	
    indentLevel = indentLevel or 0
    visited = visited or {}
    asString = asString or false

    local indent = string.rep("  ", indentLevel)
    local result = ""

    Trace("####### DEBUG TABLA #######");
    if visited[tbl] then
        local line = indent .. "*circular reference*"
        if asString then
            result = result .. line .. "\n"
        else
            Trace(line)
        end
        return result
    end

    visited[tbl] = true

    for k, v in pairs(tbl) do
        local keyStr = tostring(k)
        local valueType = type(v)

        if valueType == "table" then
            local line = indent .. keyStr .. " = {"
            if asString then
                result = result .. line .. "\n"
            else
                Trace(line)
            end

            result = result .. DumpTable(v, indentLevel + 1, visited, asString)

            local closeLine = indent .. "}"
            if asString then
                result = result .. closeLine .. "\n"
            else
                Trace(closeLine)
            end
        else
            local line = indent .. keyStr .. " = " .. tostring(v)
            if asString then
                result = result .. line .. "\n"
            else
                Trace(line)
            end
        end
    end
	  Trace("####### FIN DEBUG TABLA #######");
    return result
end

function printInLogParamsData(title,params)
	    Trace("=== "..title.." Param debug ===")
	    if not params then Trace("(nil)"); return end
	    for k, v in pairs(params) do
	        Trace(string.format("param[%s] = %s", tostring(k), tostring(v)))
	    end
end;

--Solo trae banner o BG
function GetSongBannerPath(song)
    if not song then
        return THEME:GetPathG("", "_blank.png");
    end;

    local bannerPath = 		song:GetBannerPath()
	local backgroundPath = 	song:GetBackgroundPath()
	 
    -- Fallback to song's preview video or background
	if bannerPath and FILEMAN:DoesFileExist(bannerPath) then
        return bannerPath
    elseif backgroundPath and FILEMAN:DoesFileExist(backgroundPath) then
        return backgroundPath
    end

    -- Fallback to theme defaults
    return PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview")
end

function shortTextHelper(text, maxLength)
    if #text > maxLength then
        return string.sub(text, 1, maxLength) .. "..."
    else
        return text
    end
end

function basicModeLevelStateAndColor(level,stepType)

local listLevelBasic = {
	["easy"] = 0;
	["normal"] = 1;
	["hard"] = 2;
	["veryhard"] =4;
	["double"] = 3;
}

local listLevelBasicColor = {
	["easy"] = "#04bbc2";
	["normal"] = "#f5b402";
	["hard"] = "#ff0000";
	["veryhard"] ="#cb0098";
	["double"] = "#21a305";
}

local resp = {state = 0,color = ""};

if stepType == "StepsType_Pump_Double" then
	resp["state"] = listLevelBasic["double"];
	resp["color"] = listLevelBasicColor["double"];
	return resp;
end;

if level >= 0 and level <= 2 then
	resp["state"] = listLevelBasic["easy"];
	resp["color"] = listLevelBasicColor["easy"];
elseif level >= 3 and level <= 4 then
	resp["state"] = listLevelBasic["normal"];
	resp["color"] = listLevelBasicColor["normal"];
elseif level >= 5 and level <=7 then
	resp["state"] = listLevelBasic["hard"];
	resp["color"] = listLevelBasicColor["hard"];	
elseif level >= 8 then
	resp["state"] = listLevelBasic["veryhard"];
	resp["color"] = listLevelBasicColor["veryhard"];
end;


return resp;

end;