function GetFileExtension(url)
	return url:match("^.+(%..+)$")
end;

function escape_lua_pattern(s)
    return s:gsub("([^%w])", "%%%1")
end

function FolderExists(path)
    local success, result = pcall(function()
        local listing = FILEMAN:GetDirListing(path, false, true)
        return listing ~= nil
    end)
    return success and result
end

function translateOldeGadeToNewGrade(grade)
	local gradeArray = {
		sss = 1,
		ss = 3,
		s = 5,
		a = 11,
		b = 12,
		c = 13,
		d = 14,
		f = 15,
	};

	if grade == "Grade_Tier01" then
		return gradeArray["sss"];
	elseif grade == "Grade_Tier02" then
		return gradeArray["ss"];
	elseif grade == "Grade_Tier03" then
		return gradeArray["s"];
	elseif grade == "Grade_Tier04" then
		return gradeArray["a"];
	elseif grade == "Grade_Tier05" then
		return gradeArray["b"];
	elseif grade == "Grade_Tier06" then
		return gradeArray["c"];
	elseif grade == "Grade_Tier07" then
		return gradeArray["d"];
	elseif grade == "Grade_Tier08" then
		return gradeArray["f"];
	end;
end;

function GetBannerFromSong(song)		
	local dataBannerSong = {generic=0,bpath=""};
	if (song ~= nil) then
		local sbackground = song:GetBannerPath();
		--local sbackground = song:GetBackgroundPath();
		if (sbackground ~= nil) then
			if FILEMAN:DoesFileExist( sbackground ) then
				--self:LoadFromCachedBanner( sbackground );
				dataBannerSong["generic"]=0;
				dataBannerSong["bpath"]=sbackground;
				return dataBannerSong;
			else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
			end;
		else
				dataBannerSong["generic"]=1;
				dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
				return dataBannerSong;					
		end;	
	end;	

    if not song then
		dataBannerSong["generic"]=1;
		dataBannerSong["bpath"]=PREFSMAN:GetPreference("GenericPreview") and THEME:GetPathG("", "GenericPreview") or THEME:GetPathG("", "Common nopreview");
		return dataBannerSong;					
    end;
end;

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

--This functions will return the level of the chart
--chart: songchart, tryDisplayMeter: if this is true, we will check if there is data on the
--#DISPLAYMETER tag, this is a string try to mind that, meanwhile GetMeter is an int.
--if there is no data, getMeter() will be returned.
function DisplayLV_New(chart)

	if chart == nil then
		return 0;
	end;

	local displayMeter = chart:GetDisplayMeter();
	if displayMeter == nil or displayMeter == "" then
		--same as always
		local chartLv = chart:GetMeter();

		if chartLv == 51 then
			return "!!";
		end;

		return chartLv >= 35 and "??" or string.format("%02i",chartLv);
	else
		return displayMeter;
	end;


end;

--*******MOD FOLDER********--
local modsFolderGame = "/Mods";
--*************************--

local pathModList = {
	commandwindow = modsFolderGame.."/CommandWindow/",
	difficultyList = modsFolderGame.."/DifficultyList/",
	frameSkin = modsFolderGame.."/FrameSkins/",
	judgmentSkin = modsFolderGame.."/JudgmentSkins/",
}

function removeExternalInternalTagPlugin(name)
	local procName = string.gsub(name, "e_", "");
	local procName = string.gsub(procName, "i_", "");
	return procName;
end;

-- Command window Mod
function getCommandWindowModPath()
	return pathModList["commandwindow"];
end;

function getCommandWindowModList()	
    local commandWindowModPath = getCommandWindowModPath();
    local entriesMods = FILEMAN:GetDirListing(commandWindowModPath, true, false);
    local folders = {};
    
    table.insert(folders,"default");

    for _, entry in ipairs(entriesMods) do
        table.insert(folders,entry);
    end;
    return folders;
end;

function getPathCommandWindowModSelected(player)
	local name = getCustomOptionValuePlayer(player,"commandWindowMod");
	if name =="default" then
		return "";
	end;
	return getCommandWindowModPath()..name.."/";
end;

function getDataCommandWindowMod(name)
	local basePath = getCommandWindowModPath()..name.."/";
	local data = {
		lua = basePath.."default.lua",
		preview = basePath.."preview.png",
		basePath = basePath,
		name = name
	}
	return data;
end;

--

function getDifficultyListModPath()
	return modsFolderGame.."/DifficultyList/";
end;

function getPathDifficultyListPlugins()
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenSelectMusic/DifficultyList/";
    return directory;
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

    --here we search for the external plugin list.
    local frameSkinExternalPath = getDifficultyListModPath();
    local entriesMods = FILEMAN:GetDirListing(frameSkinExternalPath, true, false);
    for _, entry in ipairs(entriesMods) do
        table.insert(folders, "e_"..entry);
    end;

    return folders;
end;

function getDificultyListFullPath(name)
	local isExternal = string.find(name, "e_");
	local fullPath = "";	
	if isExternal then
		local procName = string.gsub(name, "e_", "");
		fullPath = getDifficultyListModPath()..procName.."/";
	else
		local directoryBase = "/Themes/" .. THEME:GetCurThemeName() .. "/BGAnimations/ScreenSelectMusicLua/Interface_Full_DifficultyList/";
		fullPath = directoryBase..name.."/";
	end;

	return {path=fullPath,isExternal=isExternal};
end;

function getDificultyListFullPathByPlayer(player)
	local name = getCustomOptionValuePlayer(player,"difficultyListMode");
	local isExternal = string.find(name, "e_");
	local procName="";
	local fullPath = "";	
	if isExternal then
		procName = string.gsub(name, "e_", "");
		fullPath = getDifficultyListModPath()..procName.."/";
	else
		procName = name;
		local directoryBase = "/Themes/" .. THEME:GetCurThemeName() .. "/BGAnimations/ScreenSelectMusicLua/Interface_Full_DifficultyList/";
		fullPath = directoryBase..name.."/";
	end;
	return {path=fullPath,isExternal=isExternal,name=procName};
end;

--this shit is only for the external xD 
--they need the path for easy access lol
--this is just crap code but im to tired lol
function setDifficultyListPathSelected(path)
	GAMESTATE:Env()["difficultyListSelectedPath"] = path;
end;
function getDifficultyListPathSelected()
	return GAMESTATE:Env()["difficultyListSelectedPath"];
end;

function getPathEvaluationSkinTheme()
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenEvaluation/Skins/";
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

function getPerformanceModeType()
		if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
			local perfp1 = 0;
			local perfp2 = 0;

			if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
				perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode_type");
			end;

			if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
				perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode_type");
			end;
			
			if perfp1 == nil or perfp1 > 3 then
				perfp1 = 0;				
			end;

			if perfp2 == nil or perfp2 > 3 then
				perfp2 = 0;
			end;

			if perfp1 == perfp2 then
				return perfp1;

			end;

			if perfp1 > perfp2 then
				return perfp1;
			end;

			if perfp2 > perfp1 then
				return perfp2;
			end;

		else
			if PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) then
				performanceTypeSelected = getCustomOptionValuePlayer(GAMESTATE:GetMasterPlayerNumber(),"performance_mode_type");
				if performanceTypeSelected == nil or performanceTypeSelected > 3 then
					performanceTypeSelected = 0;
				end;
				return performanceTypeSelected;
			else
				return 0;
			end;

		end;

		return 0;
end;

function changePerformanceModeType()
	if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
		local performanceSelected = 0;
		local perfp1 = 0;
		local perfp2 = 0;

		if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			perfp1 = getCustomOptionValuePlayer(PLAYER_1,"performance_mode_type");
		end;

		if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
			perfp2 = getCustomOptionValuePlayer(PLAYER_2,"performance_mode_type");
		end;

		if perfp1 == nil or perfp1 > 3 then
			perfp1 = 0;				
		end;

		if perfp2 == nil or perfp2 > 3 then
			perfp2 = 0;
		end;

		if perfp1 == perfp2 then
			performanceSelected = perfp1;

		end;

		if perfp1 > perfp2 then
			performanceSelected = perfp1;
		end;

		if perfp2 > perfp1 then
			
			performanceSelected = perfp2;
		end;

		performanceSelected = performanceSelected + 1;
		if performanceSelected > 3 then
			performanceSelected = 0;
		end;

		if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			setCustomOptionValuePlayer(PLAYER_1,"performance_mode_type",performanceSelected);
		end;

		if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
			setCustomOptionValuePlayer(PLAYER_2,"performance_mode_type",performanceSelected);
		end;

	else
		local performanceTypeSelected = 0;
		if PROFILEMAN:IsPersistentProfile(GAMESTATE:GetMasterPlayerNumber()) then
			performanceTypeSelected = getCustomOptionValuePlayer(GAMESTATE:GetMasterPlayerNumber(),"performance_mode_type");
		end;

		if performanceTypeSelected == nil or performanceTypeSelected > 3 then
			performanceTypeSelected = 0;
		end;

		performanceTypeSelected = performanceTypeSelected + 1;
		if performanceTypeSelected > 3 then
			performanceTypeSelected = 0;
		end;

		setCustomOptionValuePlayer(GAMESTATE:GetMasterPlayerNumber(),"performance_mode_type",performanceTypeSelected);
	end;
end;

--***** MISSION AND OTHER THINGS FROM PIU ORIG - OBJ FILES *****--
function checkForObjFilesPiuContent()
	local actualCheck = 0;

	local fileLua = FindFileWithPatternOnDirectory("/GameData/","INDT.obj");
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	fileLua = FindFileWithPatternOnDirectory("/GameData/","WMDT.obj");
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	fileLua = FindFileWithPatternOnDirectory("/GameData/","WMSF.obj");
	if fileLua ~= "-" then
		actualCheck = actualCheck + 1;
	end;

	if actualCheck > 1 then
		return true;
	else
		return false;
	end;
end;

--******** mod info ********--
function getModInfo(pathFolderMod)
	local modInfo = {};

	if pathFolderMod == nil or #pathFolderMod == 0 then
		return nil;
	end;

	if FILEMAN:DoesFileExist(pathFolderMod.."mod_info.lua") then
		local modInfoFunction = LoadActor(pathFolderMod.."mod_info.lua");
		modInfo = modInfoFunction();
		local procData = {};
		if modInfo["Name"] ~= nil then
			procData["Name"] = modInfo["Name"];
		else
			procData["Name"] = "No Name";
		end;
		if modInfo["Author"] ~= nil then
			procData["Author"] = modInfo["Author"];
		else
			procData["Author"] = "N/A";
		end;
		if modInfo["Description"] ~= nil then
			procData["Description"] = modInfo["Description"];
		else
			procData["Description"] = "-";
		end;
		if modInfo["Version"] ~= nil then
			procData["Version"] = modInfo["Version"];
		else
			procData["Version"] = "-";
		end;
		return procData;
	else
		return nil;
	end;
end;

--****** ProfileSkins******---
local profileSkinExternalPath = modsFolderGame.."/ProfileSkins/";
local defaultProfileSkin = "default";
function getProfileSkinExternalPath()
	return profileSkinExternalPath;
end;

function getDefaultProfileSkin()
	return defaultProfileSkin;
end;

function getProfileSkinsInstalled()
    local directoryExternal = getProfileSkinExternalPath();
    local entriesExternal = FILEMAN:GetDirListing(directoryExternal, true, false);
    local folders = {};
    table.insert(folders, "default");
    for _, entry in ipairs(entriesExternal) do
        table.insert(folders, entry);
    end;
    return folders;
end;

function getProfileSkinPlayer(player)
	local skinData = {
		isDefault = true,
		luaPath = "",
		basePathSkin = ""
	};

	local skinSelected=getCustomOptionValuePlayer(player,"profileSkin");
	if skinSelected == nil or skinSelected == "" then
		return skinData;
	end;

	if skinSelected == "default" then
		return skinData;
	end;

	if FILEMAN:DoesFileExist(getProfileSkinExternalPath()..skinSelected.."/default.lua") then
		skinData["isDefault"] = false;
		skinData["luaPath"] = getProfileSkinExternalPath()..skinSelected.."/default.lua";
		skinData["basePathSkin"] = getProfileSkinExternalPath()..skinSelected.."/";
		return skinData;
	else
		return skinData;
	end;
end;

function getDataFromProfileSkin(skinSelected)

	local skinData = {
		isDefault = true,
		luaPath = "",
		basePathSkin = "",
		hasPreview = false,
		previewPath = "",
		hasModInfo = false,
		modInfoPath =""
	};

	if skinSelected == "default" then
		return skinData;
	end;

	if FILEMAN:DoesFileExist(getProfileSkinExternalPath()..skinSelected.."/default.lua") then
		skinData["isDefault"] = false;
		skinData["luaPath"] = getProfileSkinExternalPath()..skinSelected.."/default.lua";
		skinData["basePathSkin"] = getProfileSkinExternalPath()..skinSelected.."/";

		if FILEMAN:DoesFileExist(getProfileSkinExternalPath()..skinSelected.."/preview.png") then
			skinData["hasPreview"] = true;
			skinData["previewPath"] = getProfileSkinExternalPath()..skinSelected.."/preview.png";
		end;

		if FILEMAN:DoesFileExist(getProfileSkinExternalPath()..skinSelected.."/mod_info.lua") then
			skinData["hasModInfo"] = true;
			skinData["modInfoPath"] = getProfileSkinExternalPath()..skinSelected.."/mod_info.lua";
		end;
		return skinData;
	else
		return skinData;
	end;
end;

--****** Profile Titles *****--
local profileTitlesExternalPath = modsFolderGame.."/ProfileTitles/";

function getProfileTitlesExternalPath()
	return profileTitlesExternalPath;
end;

function getProfileTitlesModInstalled()
	local folders = {};
	local foldersReorder = {};
    local directoryExternal = getProfileTitlesExternalPath();
    local entriesExternal = FILEMAN:GetDirListing(directoryExternal, true, false);

    for _, entry in ipairs(entriesExternal) do       
        if entry == "Xsanity" or entry == "xsanity" or entry == "XSanity" then
        	table.insert(foldersReorder,entry);
        else
        	table.insert(folders,entry);
        end;
    end;

    for i=1,#folders do
    	table.insert(foldersReorder,folders[i]);
    end;

    return foldersReorder;
end;

--here we return every mod with titles because we will need this for the profile editor
function getAllTitlesRegistered(player)
	local arrayTitlesRegistered = {};
	--here we will create all the list available
	local titlesInstalled = getProfileTitlesModInstalled();

	--check if we have mods installed
	if #titlesInstalled == 0 then
		return arrayTitlesRegistered;
	end;

	--there are mods, we get the list
	for i=1,#titlesInstalled do
		if FILEMAN:DoesFileExist(getProfileTitlesExternalPath()..titlesInstalled[i].."/default.lua") then
			local pathMod = getProfileTitlesExternalPath()..titlesInstalled[i].."/";
			local modTitles = dofile(getProfileTitlesExternalPath()..titlesInstalled[i].."/default.lua");
			local titlesData = modTitles(player,0);

			--a little extraction of data here.
			local unlocked = 0;
			local total = #titlesData;

			for x=1,#titlesData do

				if titlesData[x]["usable"] then
					unlocked = unlocked + 1;
				end;
				--we create the img path correctly here
				if titlesData[x]["img"] ~= nil and #titlesData[x]["img"] > 0 then
					local imgData = pathMod..titlesData[x]["img"];
					--check if exists.
					if FILEMAN:DoesFileExist(imgData) then
						titlesData[x]["img"] = imgData;
					else
						titlesData[x]["img"] = "";
					end;
				end;
				if titlesData[x]["frame_img"] ~= nil and #titlesData[x]["frame_img"] > 0 then
					local imgDataFrame = pathMod..titlesData[x]["frame_img"];
					if FILEMAN:DoesFileExist(imgDataFrame) then
						titlesData[x]["frame_img"] = imgDataFrame;
					else
						titlesData[x]["frame_img"] = "";
					end;
				end;


			end;

			table.insert(arrayTitlesRegistered,{mod=titlesInstalled[i],data=titlesData,total=total,unlocked=unlocked});
		end;
	end;

	return arrayTitlesRegistered;
end;

--nil if no exists.
function getTitleFromPlayer(player)

	local profileTitleMod = getCustomOptionValuePlayer(player,"profileTitleMod");
	local profileTitleId = getCustomOptionValuePlayer(player,"profileTitleModId");

	-- check if we have a profileTitleMod.
	if profileTitleMod == nil or #profileTitleMod == 0 then
		return nil;
	end;
	
	if profileTitleMod == "none" then
		return nil;
	end;

	-- do exist, now we check if the ID exists, if not. we return null.
	if profileTitleId == nil or profileTitleId == 0 then
		return nil;
	end;

	local titlesInstalled = getProfileTitlesModInstalled();

	--check if we have mods installed
	if #titlesInstalled == 0 then
		return nil;
	end;

	--search for the mod, if not, return null.
	local modReady = false;

	for i=1,#titlesInstalled do
		if titlesInstalled[i] == profileTitleMod then
			modReady = true;
			break;
		end;
	end;

	--we don't have the title installed. please select one installed :P
	if modReady == false then
		return nil;
	end;


	if FILEMAN:DoesFileExist(getProfileTitlesExternalPath()..profileTitleMod.."/default.lua") then
		local imgTitle = "";
		local frameTitle = "";
		local nomTitle = "";

		local modTitles = dofile(getProfileTitlesExternalPath()..profileTitleMod.."/default.lua");
		local titlesData = modTitles(player,profileTitleId);

		if titlesData ~= nil and titlesData.title ~= nil then
			if titlesData.img ~= nil and #titlesData.img > 0 then
				imgTitle = getProfileTitlesExternalPath()..profileTitleMod.."/"..titlesData.img;
			end;

			if titlesData.frame_img ~= nil and #titlesData.frame_img > 0 then
				frameTitle = getProfileTitlesExternalPath()..profileTitleMod.."/"..titlesData.frame_img;
			end;

			if #titlesData.title > 0 then
				nomTitle = titlesData.title;
			end;
		else
			return nil;
		end;

		return {title=nomTitle,img=imgTitle,img_frame=frameTitle};
	else
		return nil;
	end;

end;


--****** FrameSkins *****--
local defaultFrameSkin = "i_simple";
local frameSkinExternalPath = modsFolderGame.."/FrameSkins/";

function GetFrameSkinExternalPath()
	return frameSkinExternalPath;
end;
function getDefaultFrameSkin()
	return defaultFrameSkin;
end;

function GetFrameSkinsInstalled()
	local folders = {};
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenSelectMusic/frames/";
    local entries = FILEMAN:GetDirListing(directory, true, false);

    for _, entry in ipairs(entries) do
        table.insert(folders, "i_"..entry);
    end;

    local directoryExternal = GetFrameSkinExternalPath();
    local entriesExternal = FILEMAN:GetDirListing(directoryExternal, true, false);

    for _, entry in ipairs(entriesExternal) do
        table.insert(folders, "e_"..entry);
    end;

    return folders;
end;

function getFrameSkinForPlayers(type,screenName)

	local localframeSkinSelected = getDefaultFrameSkin();
	if GAMESTATE:GetNumSidesJoined() == 2 then

		--if one player is a guest, we will treat this like if there is 1 player
		local p1IsProfile=false;
		local p2IsProfile=false;
		if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			p1IsProfile = true;
		end;
		if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
			p2IsProfile = true;
		end;

		-- get data
		local p1Selected=getCustomOptionValuePlayer(PLAYER_1,"frameSkin");
		local p2Selected=getCustomOptionValuePlayer(PLAYER_2,"frameSkin");

		if p1Selected == nil then
			p1Selected = localframeSkinSelected;
		end;
		if p2Selected == nil then
			p2Selected = localframeSkinSelected;
		end;

		if p1IsProfile and p2IsProfile == false then
			localframeSkinSelected = p1Selected;
		elseif p2IsProfile and p1IsProfile == false then
			localframeSkinSelected = p2Selected;
		elseif p2IsProfile and p1IsProfile then
			--if both are profiles and have the same skin.
			if p1Selected == p2Selected then
				localframeSkinSelected = p1Selected;
			end;			
		end;

	else
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			local p1Selected=getCustomOptionValuePlayer(PLAYER_1,"frameSkin");
			if p1Selected == nil or p1Selected == false then
				p1Selected = localframeSkinSelected;
			end;

			localframeSkinSelected = p1Selected;
		end;
		if GAMESTATE:IsHumanPlayer(PLAYER_2) then
			local p2Selected=getCustomOptionValuePlayer(PLAYER_2,"frameSkin");
			if p2Selected == nil or p2Selected == false then
				p2Selected = localframeSkinSelected;
			end;

			localframeSkinSelected = p2Selected;
		end;
	end;

	if localframeSkinSelected == getDefaultFrameSkin() then
		return {isDefault = true,lua = "--", path="--"};
	end;


	if screenName == "ScreenSelectMusic" then
		local luaPathRequired = getFrameSkinLuaData(type,localframeSkinSelected);
		return {isDefault = luaPathRequired["defaultSkin"],lua = luaPathRequired["lua"],path=luaPathRequired["path"]};	
	end;

	if screenName == "ScreenStageBreak" then
		local luaPathRequired = getFrameSkinStageBreakScreen(type,localframeSkinSelected);
		return {isDefault = luaPathRequired["defaultSkin"],lua = luaPathRequired["lua"],path=luaPathRequired["path"]};
	end;

	if screenName == "ScreenGamePlay" then
		local luaPathRequired = getFrameSkinGamePlayScreen(type,localframeSkinSelected);
		return {isDefault = luaPathRequired["defaultSkin"],lua = luaPathRequired["lua"],path=luaPathRequired["path"]};
	end;

	return {isDefault = true,lua = "-",path="-"};

end;

function getFrameSkinLuaData(type,skinName)
    local themeName = THEME:GetCurThemeName();
	local internalPath="/Themes/" .. themeName .. "/Graphics/ScreenSelectMusic/frames/";
	local externalPath = GetFrameSkinExternalPath();
	local finalPathSkin = "";
	local luaPathSkin = "";
	local defaultPathSkin ="";
	local usingDefaultSkin = false;

	local isExternal = string.find(skinName, "e_");
	local isInternal = string.find(skinName, "i_");

	-- we generate the default full path.
		procSkinNameDefault = string.gsub(getDefaultFrameSkin(), "i_", "");
		defaultPathSkin = internalPath..procSkinNameDefault.."/";

	if isExternal == nil and isInternal == nil then
		finalPathSkin = defaultPathSkin;
	else
		if isExternal ~= nil then
			procSkinName = string.gsub(skinName, "e_", "");
			finalPathSkin = externalPath..procSkinName.."/";		
		end;

		if isInternal ~= nil then
			procSkinName = string.gsub(skinName, "i_", "");
			finalPathSkin = internalPath..procSkinName.."/";		
		end;
	end;


	if type == "overlay" then
		-- we check if exists, if not we return the default.
		if FILEMAN:DoesFileExist(finalPathSkin.."overlay.lua") then
			luaPathSkin = finalPathSkin.."overlay.lua";
		elseif FILEMAN:DoesFileExist(finalPathSkin.."ScreenSelectMusic/overlay.lua") then
			luaPathSkin = finalPathSkin.."ScreenSelectMusic/overlay.lua";
			finalPathSkin = finalPathSkin.."ScreenSelectMusic/";
		else
			finalPathSkin = defaultPathSkin;
			luaPathSkin = finalPathSkin.."overlay.lua";
			usingDefaultSkin = true;
		end;

	elseif type =="underlay" then
		if FILEMAN:DoesFileExist(finalPathSkin.."underlay.lua") then
			luaPathSkin = finalPathSkin.."underlay.lua";
		elseif FILEMAN:DoesFileExist(finalPathSkin.."ScreenSelectMusic/underlay.lua") then
			luaPathSkin = finalPathSkin.."ScreenSelectMusic/underlay.lua";
			finalPathSkin = finalPathSkin.."ScreenSelectMusic/";
		else
			finalPathSkin = defaultPathSkin;
			luaPathSkin = finalPathSkin.."underlay.lua";
			usingDefaultSkin = true;
		end;
	end;

	return {lua =luaPathSkin , path = finalPathSkin, defaultSkin = usingDefaultSkin};

end;

function getFrameSkinStageBreakScreen(type,skinName)
    local themeName = THEME:GetCurThemeName();
	local externalPath = GetFrameSkinExternalPath();
	local finalPathSkin = "";

	local luaPathSkin = "";

	local isExternal = string.find(skinName, "e_");

	if isExternal ~= nil then
		procSkinName = string.gsub(skinName, "e_", "");
		finalPathSkin = externalPath..procSkinName.."/ScreenStageBreak/";
	else
		return {lua ="", path = "", defaultSkin=true};
	end;

	--we check if the folder /ScreenStageBreak and file overlay.lua
	if type == "overlay" then
		if FILEMAN:DoesFileExist(finalPathSkin.."overlay.lua") then
			luaPathSkin = finalPathSkin.."overlay.lua";
		else
			return {lua ="", path = "", defaultSkin=true};
		end;
	elseif type == "underlay" then
		if FILEMAN:DoesFileExist(finalPathSkin.."underlay.lua") then
			luaPathSkin = finalPathSkin.."underlay.lua";
		else
			return {lua ="", path = "", defaultSkin=true};
		end;
	else
		return {lua ="", path = "", defaultSkin=true};
	end;

	return {lua=luaPathSkin, path = finalPathSkin, defaultSkin=false};
end;

function getFrameSkinGamePlayScreen(type,skinName)
    local themeName = THEME:GetCurThemeName();
	local externalPath = GetFrameSkinExternalPath();
	local finalPathSkin = "";

	local luaPathSkin = "";

	local isExternal = string.find(skinName, "e_");

	if isExternal ~= nil then
		procSkinName = string.gsub(skinName, "e_", "");
		finalPathSkin = externalPath..procSkinName.."/ScreenGamePlay/";
	else
		return {lua ="", path = "", defaultSkin=true};
	end;

	--we check if the folder /ScreenGamePlay and file overlay.lua
	if type == "overlay" then
		if FILEMAN:DoesFileExist(finalPathSkin.."overlay.lua") then
			luaPathSkin = finalPathSkin.."overlay.lua";
		else
			return {lua ="", path = "", defaultSkin=true};
		end;
	elseif type == "underlay" then
		if FILEMAN:DoesFileExist(finalPathSkin.."underlay.lua") then
			luaPathSkin = finalPathSkin.."underlay.lua";
		else
			return {lua ="", path = "", defaultSkin=true};
		end;
	else
		return {lua ="", path = "", defaultSkin=true};
	end;

	return {lua=luaPathSkin, path = finalPathSkin, defaultSkin=false};
end;


function getPreviewImageFrameSkin(skinName)
    local themeName = THEME:GetCurThemeName();
	local internalPath="/Themes/" .. themeName .. "/Graphics/ScreenSelectMusic/frames/";
	local externalPath = GetFrameSkinExternalPath();
	local skinBasePath = "";
	local returnPath = "";
	local procSkinName ="";

	local isExternal = string.find(skinName, "e_");
	local isInternal = string.find(skinName, "i_");

	if isExternal == nil and isInternal == nil then 
		 returnPath = internalPath.."preview.png";
	else
		if isExternal ~= nil then
			procSkinName = string.gsub(skinName, "e_", "");
			finalPathSkin = externalPath..procSkinName.."/preview.png";	
			if FILEMAN:DoesFileExist(finalPathSkin) then
				returnPath = finalPathSkin;
				skinBasePath = externalPath..procSkinName.."/";
			else
				returnPath = internalPath.."preview.png";
			end;
		end;

		if isInternal ~= nil then
			procSkinName = string.gsub(skinName, "i_", "");
			finalPathSkin = internalPath..procSkinName.."/preview.png";
			if FILEMAN:DoesFileExist(finalPathSkin) then
				returnPath = finalPathSkin;
				skinBasePath = internalPath..procSkinName.."/";
			else
				returnPath = internalPath.."preview.png";
			end;
		end;		
	end;

	return {name=procSkinName,preview=returnPath,path=skinBasePath};

end;

function checkTypeStepData(pndata)
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps(pndata);

	style = cur_steps:GetStepsType();
	if style=='StepsType_Pump_Single' --[[and string.find( description,"SP" )]] then 
		return 1;
	elseif style=='StepsType_Pump_Single' then 
		return 1;
	elseif style=='StepsType_Pump_Couple' then 
		return 2;
	elseif ( style=='StepsType_Pump_Double' --[[ and string.find( description,"DP" ) ]] ) or style=='StepsType_Pump_Routine'  then 
		return 2;
	elseif style=='StepsType_Pump_Double' or style=='StepsType_Pump_Halfdouble' or style == "StepsType_Pump_Double_P" then 
		return 2;
	end;

	return 0;
end;

--****** Announcer ******--
function getExternalAnnouncerPath()
	--we check if there is a folder to select from the Mod/Announcers
	local announcerSelected = "piu";

	--we check if the folder exist
	local announcerModsPath = modsFolderGame.."/announcers/"..announcerSelected;
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

--****** Companions *****---
local CompanionExternalPath = modsFolderGame.."/Companions/";
function GetCompanionExternalPath()
	return CompanionExternalPath;
end;

function getCompanionsInstalled()
	local folders = {};
    local entriesExternal = FILEMAN:GetDirListing(CompanionExternalPath, true, false);

    for _, entry in ipairs(entriesExternal) do
    	--here we only add those companions with the companion.lua.
    	if FILEMAN:DoesFileExist(CompanionExternalPath..entry.."/companion.lua") then
        	table.insert(folders, entry);
        end;
    end;

    local numMinItems = 7;
    if #folders == 2 or #folders == 4 then
    	numMinItems = 8;
    elseif #folders == 3 then
    	numMinItems = 9;
    elseif #folders == 5 then
    	numMinItems = 10;
    elseif #folders == 6 then
    	numMinItems = 12;
    end;

    --here i can fix the thing that if there is less than 5 items
  	local finish=false;
  	if #folders > 0 and #folders < numMinItems then

	    while #folders < numMinItems do

	    	for i=1, #folders do
	    		if finish == false then
		    		table.insert(folders,folders[i]);
		    		if #folders >= numMinItems then
		    			finish = true;
		    		end;
	    		end;
	    	end;    	
	    end;

	end;

    return folders;
end;

function getNumberOfCompanionInstalled()
	local companionsInstalled = getCompanionsInstalled();
	return #companionsInstalled;
end;

function GetPNGICompanion(skinName)
	local pathIcon = "";
	pathIcon = CompanionExternalPath..skinName.."/Icon.";	
	if FILEMAN:DoesFileExist(pathIcon.."png") then
		return pathIcon.."*";
	else
		return THEME:GetPathG("","companion_default_icon");
	end;		
end;

function getCompanionIconData(player)
		local companionData = getCustomOptionValuePlayer(player,"companion");
		if companionData == nil or companionData == false or companionData == "none" or companionData == "" then
			return THEME:GetPathG("","companion_none_icon");
		end;

		local companionPath = GetCompanionExternalPath()..companionData.."/";

		--we check if the icon exist.
		if FILEMAN:DoesFileExist(companionPath.."icon.png") then
			return companionPath.."icon.png";
		elseif FILEMAN:DoesFileExist(companionPath.."Icon.png") then
			return companionPath.."Icon.png";
		else
			return THEME:GetPathG("","companion_default_icon");
		end;
end;

function getCompanionPreviewData(player)
		local companionData = getCustomOptionValuePlayer(player,"companion");
		if companionData == nil or companionData == false or companionData == "none" or companionData == "" then
			return THEME:GetPathG("","_blank");
		end;

		local companionPath = GetCompanionExternalPath()..companionData.."/";

		--we check if the icon exist.
		if FILEMAN:DoesFileExist(companionPath.."preview.png") then
			return companionPath.."preview.png";
		elseif FILEMAN:DoesFileExist(companionPath.."Preview.png") then
			return companionPath.."Preview.png";
		else
			return THEME:GetPathG("","_blank");
		end;
end;

function getCompanionPreviewDataByName(companionData)
		if companionData == nil or companionData == false or companionData == "none" or companionData == "" then
			return THEME:GetPathG("","_blank");
		end;

		local companionPath = GetCompanionExternalPath()..companionData.."/";

		--we check if the icon exist.
		if FILEMAN:DoesFileExist(companionPath.."preview.png") then
			return companionPath.."preview.png";
		elseif FILEMAN:DoesFileExist(companionPath.."Preview.png") then
			return companionPath.."Preview.png";
		else
			return THEME:GetPathG("","_blank");
		end;
end;


function checkIfCompanionInstalled()
	--if no companion is installed, we reset the state of that entry to the players.
	local numInstalled = getNumberOfCompanionInstalled();
	if numInstalled == 0 then

		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
				local companionSelected = getCustomOptionValuePlayer(PLAYER_1,"companion");

				if companionSelected == nil or companionSelected ~= "none" then
					setCustomOptionValuePlayer(PLAYER_1,"companion","none");	
				end;
			end;
		end;

		if GAMESTATE:IsHumanPlayer(PLAYER_2) then
			if PROFILEMAN:IsPersistentProfile(PLAYER_2) then

				local companionSelected = getCustomOptionValuePlayer(PLAYER_2,"companion");
				if companionSelected == nil or companionSelected ~= "none" then
					setCustomOptionValuePlayer(PLAYER_2,"companion","none");	
				end;

			end;
		end;	
	else
		local companionsInstalled = getCompanionsInstalled();
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			local companionSelected = getCustomOptionValuePlayer(PLAYER_1,"companion");
			local isInstalled=false;
			for i=1,#companionsInstalled do
				if companionsInstalled[i] == companionSelected then
					isInstalled = true;
					break;
				end;
			end;

			if isInstalled == false then
				setCustomOptionValuePlayer(PLAYER_1,"companion","none");
			end;
		end;

		if GAMESTATE:IsHumanPlayer(PLAYER_2) then
			local companionSelected = getCustomOptionValuePlayer(PLAYER_2,"companion");
			local isInstalled=false;
			for i=1,#companionsInstalled do
				if companionsInstalled[i] == companionSelected then
					isInstalled = true;
					break;
				end;
			end;

			if isInstalled == false then
				setCustomOptionValuePlayer(PLAYER_2,"companion","none");
			end;
		end;

	end;
end;

function checkIfCompanionInstalledByPlayer(player)
	--if no companion is installed, we reset the state of that entry to the players.
	local numInstalled = getNumberOfCompanionInstalled();
	if numInstalled == 0 then
			local companionSelected = getCustomOptionValuePlayer(player,"companion");
			if companionSelected == nil or companionSelected ~= "none" then
				setCustomOptionValuePlayer(player,"companion","none");	
			end;	
	else
		local companionsInstalled = getCompanionsInstalled();
		
		local companionSelected = getCustomOptionValuePlayer(player,"companion");
		if companionSelected == nil then
			setCustomOptionValuePlayer(player,"companion","none");	
			return;
		end;	

		local isInstalled=false;
		for i=1,#companionsInstalled do
			if companionsInstalled[i] == companionSelected then
				isInstalled = true;
				break;
			end;
		end;

		if isInstalled == false then
			setCustomOptionValuePlayer(player,"companion","none");
		end;
	end;
end;


--****** Channel music ******--
local ChannelMusicExternalPath = modsFolderGame.."/ChannelMusic/";
function GetChannelMusicExternalPath()
	return ChannelMusicExternalPath;
end;

--****** LIFEBARSKIN *****--
local lifebarSkinExternal = modsFolderGame.."/LifebarSkins/";
function GetLifebarSkinExternalPath()
	return lifebarSkinExternal;
end;

--***** Evaluation skin *****--
local defaultEvaluationSkin = "i_xsanity";
local gradePassImgName = "pass_res 1x16.png";
local gradeFailImgName = "fail_pass_res 1x16.png";

local evaluationSkinExternal = modsFolderGame.."/EvaluationSkins/";
function GetEvaluationSkinExternalPath()
	return evaluationSkinExternal;
end;

function GetEvaluationSkinInstalled()
	local folders = {};
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenEvaluation/Skins/";
    local entries = FILEMAN:GetDirListing(directory, true, false);

    for _, entry in ipairs(entries) do
        table.insert(folders, "i_"..entry);
    end;

    local directoryExternal = GetEvaluationSkinExternalPath();
    local entriesExternal = FILEMAN:GetDirListing(directoryExternal, true, false);

    for _, entry in ipairs(entriesExternal) do
        table.insert(folders, "e_"..entry);
    end;

    return folders;
end;

-- return the sprite of the evaluation skin
function GetGradeSpriteFromEvaluationSkin(failed,player)
		local dataSkinEvaluation = GetEvaluationSkinDataFromPlayer(player);
		local defaultData = CheckAndGetLuaEvaluationSkin(defaultEvaluationSkin);
		local spriteGrade = "";
		
		--we get the gradeSprite
		if failed then
			spriteGrade = dataSkinEvaluation["path_skin"]..gradeFailImgName;
			--we check if exists, if not, select the default of the theme.
			if FILEMAN:DoesFileExist(spriteGrade) then
				return spriteGrade;
			else
				--default
				return defaultData["path_skin"]..gradeFailImgName;
			end;


		else
			spriteGrade = dataSkinEvaluation["path_skin"]..gradePassImgName;
			--we check if exists, if not, select the default of the theme.
			if FILEMAN:DoesFileExist(spriteGrade) then
				return spriteGrade;
			else
				--default
				return defaultData["path_skin"]..gradePassImgName;
			end;
		end;
end;

--skinName: skinName to proc, default: skinName default if the skinName fails to exists.
function CheckAndGetLuaEvaluationSkin(skinName)
	if skinName == "" or skinName == false or skinName == nil then
		skinName = defaultEvaluationSkin;		
	end;

	local procSkinName="";
	local activeTheme = THEME:GetCurThemeName();
	--here there are 3 files, you can use all of them or only 1 idk xD
	-- ../grade_letters.lua
	-- ../grade_text.lua
	-- ../screen_sound.lua
	--if any of those doesn't exists, it will get the default instead.

	local pathSkin = "";
	local isExternal = string.find(skinName, "e_");
	local isInternal = string.find(skinName, "i_");

	if isExternal ~= nil then
		procSkinName = string.gsub(skinName, "e_", "");
		pathSkin = GetEvaluationSkinExternalPath()..procSkinName.."/";		
	end;

	if isInternal ~= nil then
		
		procSkinName = string.gsub(skinName, "i_", "");
		pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..procSkinName.."/";
	end;

	--default
	if isExternal == nil and isInternal == nil then	
		procSkinName = string.gsub(defaultEvaluationSkin, "i_", "");
		pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..procSkinName.."/";
	end;

	local evalSkinData = {};
	evalSkinData["skin_name"] = procSkinName;
	evalSkinData["full_skin_name"] = skinName;
	evalSkinData["path_skin"] = pathSkin;

	if FILEMAN:DoesFileExist(pathSkin.."screen_sound.lua") then
		evalSkinData["screen_sound"] = pathSkin.."screen_sound.lua";
	else
		evalSkinData["screen_sound"] = "";
	end;

	if FILEMAN:DoesFileExist(pathSkin.."grade_letters.lua") then
		evalSkinData["grade_lua"] = pathSkin.."grade_letters.lua";
	else
		evalSkinData["grade_lua"] = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..defaultEvaluationSkin.."/grade_letters.lua";
	end;

	if FILEMAN:DoesFileExist(pathSkin.."grade_text.lua") then
		evalSkinData["text_lua"] = pathSkin.."grade_text.lua";
	else
		evalSkinData["text_lua"] = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..defaultEvaluationSkin.."/grade_text.lua";
	end;

	if FILEMAN:DoesFileExist(pathSkin..gradePassImgName) then
		evalSkinData["grade_pass"] = pathSkin..gradePassImgName;
	else
		evalSkinData["grade_pass"] = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..defaultEvaluationSkin.."/"..gradePassImgName;
	end;

	if FILEMAN:DoesFileExist(pathSkin..gradeFailImgName) then
		evalSkinData["grade_pass_fail"] = pathSkin..gradeFailImgName;
	else
		evalSkinData["grade_pass_fail"] = "/Themes/"..activeTheme.."/Graphics/ScreenEvaluation/Skins/"..defaultEvaluationSkin.."/"..gradeFailImgName;
	end;

	return evalSkinData;

end;

function checkPlayerEvaluationSkinExist(player)
	--here we check if the skin of the player exist. in the case that not exist. 
	--we put back the default one.
	local playerProfileCustomSkinSelected = getCustomOptionValuePlayer(player,"evaluationSkin");

	if playerProfileCustomSkinSelected == nil then
		setCustomOptionValuePlayer(player,"evaluationSkin",defaultEvaluationSkin);
	else
		local skinsInstalled = GetEvaluationSkinInstalled();
		local exist = false;
		for i=1,#skinsInstalled do
			if playerProfileCustomSkinSelected == skinsInstalled[i] then
				exist = true;
			end;
		end;

		if exist == false then
			setCustomOptionValuePlayer(player,"evaluationSkin",defaultEvaluationSkin);
		end;
	end;


	
end;

function GetEvaluationSkinDataFromPlayer(player)
	local playerProfileCustomSkinSelected = getCustomOptionValuePlayer(player,"evaluationSkin");
	if playerProfileCustomSkinSelected == nil then
		playerProfileCustomSkinSelected = defaultEvaluationSkin;
	end;
	return CheckAndGetLuaEvaluationSkin(playerProfileCustomSkinSelected);
end;

function GetDefaultEvaluationSkin()
	playerProfileCustomSkinSelected = defaultEvaluationSkin;
	return CheckAndGetLuaEvaluationSkin(playerProfileCustomSkinSelected);
end;

function GetDefaultEvaluationSkinName()
	return defaultEvaluationSkin;
end;



--** skin lifebar **--
function isHalfDoubleSkinPositionItemsLua()

	--THEME LIFEBAR
	--CAMBIAR AL QUE SE QUIERA AGREGANDO LA CARPETA CORRESPONDIENTE CON LOS ARCHIVOS CORRESPONDIENTES
	local profileLifeBar = getCustomOptionValuePlayer(GAMESTATE:GetMasterPlayerNumber(),"lifebarSkin");

	if profileLifeBar == nil then
		profileLifeBar = "none";
	end;

	local themeLifeBar = getPathSkinLifeBar(profileLifeBar);
	local luaFileSkin = FindFileWithPatternOnDirectory(themeLifeBar.."/","default_half.lua");
	if luaFileSkin ~= "-" then
		return true;
	else
		--if this skin doesn't have half, select the double file.
		local luaFileSkin = FindFileWithPatternOnDirectory(themeLifeBar.."/","default_double.lua");
		if luaFileSkin ~= "-" then
			return false;
		else
			return nil;
		end;
	end;
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
local judgmentSkinExternal = modsFolderGame.."/JudgmentSkins/";

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

--**********************
--**** InfoScheme SKINS
--**********************
function getInfoSchemeModPath()
	return modsFolderGame.."/InfoSchemes/";
end;

function getInfoSchemeModList()	
    local commandWindowModPath = getInfoSchemeModPath();
    local entriesMods = FILEMAN:GetDirListing(commandWindowModPath, true, false);
    local folders = {};
    
    table.insert(folders,"default");

    for _, entry in ipairs(entriesMods) do
        table.insert(folders,entry);
    end;
    return folders;
end;

function getSkinSelectedInfoSchemePath(player)
	local respuesta={
		default=false,
		pathLua="",
		name=""
	};
	--CUSTOM SKINS FOR THIS THING 
	local infoSchemeName="default";

	local iSchemeSelected = getCustomOptionValuePlayer(player,"infoSchemeSkin");
	if iSchemeSelected ~= nil and iSchemeSelected ~= "" then
		infoSchemeName = iSchemeSelected;
	end;

	if infoSchemeName == "default" then
		respuesta["default"] = true;
		respuesta["name"] = "default";
		return respuesta;
	end;

	respuesta["pathLua"] = getInfoSchemeModPath()..infoSchemeName.."/";
	respuesta["name"] = infoSchemeName;
	
	return respuesta;
end;

function getInfoSchemePreviewFromName(name)
	local respuesta={
		hasPreview=false,
		pathPreview="",
		pathBase=getInfoSchemeModPath()..name.."/"
	};

	if FILEMAN:DoesFileExist(getInfoSchemeModPath()..name.."/preview.png") then
		respuesta["hasPreview"] = true;
		respuesta["pathPreview"] = getInfoSchemeModPath()..name.."/preview.png";
	end;

	return respuesta;
end;

function checkLuaSkinSelectedInfoScheme(skinPath,folderName)
	--default.lua is the entry point of any of this skins.
	if FILEMAN:DoesFileExist(skinPath..folderName.."/default.lua") then
		return true;
	else
		return false;
	end;
end;

function checkPreviewImgSkinSelectedInfoScheme(skinPath,folderName,player)
	--default.lua is the entry point of any of this skins.
	local response = {
		valid=false,
		path=""
	};

	local nameImage = "";

	if player == PLAYER_1 then
		nameImage = "preview_p1.png";
	else
		nameImage = "preview_p2.png";
	end;

	if FILEMAN:DoesFileExist(skinPath..folderName.."/"..nameImage) then		
		response["valid"]=true;
		response["path"]=skinPath..folderName.."/"..nameImage;
		return response;
	else
		return response;
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

--[DEBUG] PRINT TABLE
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

function formatSecondsFull(totalSeconds)
    local h = math.floor(totalSeconds / 3600)
    local m = math.floor((totalSeconds % 3600) / 60)
    local s = totalSeconds % 60

    return string.format("%02d:%02d:%02d", h, m, s)
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

--//This BS, for some reaseon i need to reapply the mod if not, it's fucked on the next song if the player doesn't change anything on the CW, weird.
function reApplyCVOption(player)
	local STATE = GAMESTATE:GetPlayerState(player);
	local cvModData = STATE:GetPlayerOptions('ModsLevel_Preferred'):CMod();
	if cvModData ~= nil then
		STATE:GetPlayerOptions('ModsLevel_Preferred' ):CMod(cvModData);
	end;
end;