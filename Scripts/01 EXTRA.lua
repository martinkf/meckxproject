-- JNC - all
nxtstg = -1;

BGDir = "/GameData/Media/prime";
XXBGDir = "/GameData/Media/xx";
XTRADir = "/GameData/Media/XTRA";

function gLANG()
	
	if PREFSMAN:GetPreference('Language') == nil or PREFSMAN:GetPreference('Language') == "" then
		PREFSMAN:SetPreference('Language', "en");
	end;
	
	if PREFSMAN:GetPreference('Language') == "es" then
		return ""
	else
		return string.upper(PREFSMAN:GetPreference('Language')) .. "-"
	end
end



function bIsModded()
	return PREFSMAN:GetPreference("DisableVanilla")
end

function GetMachineName()
	if PREFSMAN:GetPreference('MachineName') ~= "" then
		return PREFSMAN:GetPreference('MachineName')
	else
		return "UNKNOWN"
	end
end

function getBannerValue()
	if PREFSMAN:GetPreference('BannerCache') ~= "Off" then
		return true;
	else
		return false;
	end;
end;
bBannerCache = getBannerValue();

function StageBreakCombo()
	return THEME:GetMetric("ScreenGameplay", "FailOnMissCombo")
end

function round2(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num));
end;

function gethround(num)
	local result
	result = round(num)
	if (num > round(num)) then
		result = round(num + 1)
	end
	return result
end

function getFloors(totalsteps)
	return gethround(totalsteps / 13)
end

function GetCurrentFloor(currentstep)
	return gethround(currentstep / 13)
end

function GetMaxNumberFloor(currentstep)
	local floorfix = GetCurrentFloor(currentstep) - 1
	if (floorfix < 1) then
		return 0
	else
		return (13*floorfix)
	end
end


function GetCurNSAlpha(player)
	local playerstate = GAMESTATE:GetPlayerState( player )
	local fDark = playerstate:GetPlayerOptions('ModsLevel_Current' ):Dark();
	return 1.0 - fDark;
end;



local aFavReachedLimit = {
	["EN-REACHED"] = "Your favorite list its full.";
	["PT-REACHED"] = "Sua lista favorita está cheia.";
	["ES-REACHED"] = "Tu lista de favoritos está llena.";
}

function GetReachedMsg()
	local str = aFavReachedLimit[string.upper(PREFSMAN:GetPreference('Language')) .. "-REACHED"]
	return str
end

FirstBasic = false;

TipBanner = true;
local aTipText = {

	["EN-TIP_1"] = "Follow us in Facebook : facebook.com/PumpSanity";
	["EN-TIP_2"] = "In Rank Mode, there might be a game over from first stage.";
	["EN-TIP_3"] = "If you use AUTO VELOCITY command, you can adjust the speed more precisely.";
	["EN-TIP_4"] = "If you want to practice, use the RUSH command.";
	["EN-TIP_5"] = "If you use Level channel, you can find the target leveled song more faster.";
	["EN-TIP_6"] = "If you get over A grade, you will get bonus heart.";
	["EN-TIP_7"] = "You will get 1 bonus heart from Normal and Remix and 2 bonus hearts from Full Song.";
	["EN-TIP_8"] = "You need hearts to play: Shortcut - 1 heart, Normal - 2 hearts, Remix - 3 hearts and Full Song - 4 hearts.";
	["EN-TIP_9"] = "Visit our webpage: www.pumpsanity.net";
	["EN-TIP_10"] = "Join to our discord!";
	
	
	["ES-TIP_1"] = "Si utilizas el comando AUTO VELOCITY, puedes ajustar la velocidad más precisamente.";
	["ES-TIP_2"] = "Si usas el canal LEVEL, puedes encontrar el nivel especifico de una canción de forma rápida.";
	["ES-TIP_3"] = "Obtendrás un corazón adicional por obtener grado A o mayor.";
	["ES-TIP_4"] = "Obtendrás 1 corazón adicional de canciones Normales y en Remix y 2 corazones adicionales de una Full Song.";
	["ES-TIP_4"] = "Si tienes dificultad con alguna canción, prueba practicar con el comando RUSH.";
	["ES-TIP_5"] = "No olvides visitar la fanpage oficial de StepPrime :  facebook.com/PumpSanity";
	["ES-TIP_6"] = "Corazones para jugar; Shortcut = 1 corazon - 2 corazones, Remix - 3 corazones y FullSong - 4 Corazones.";
	["ES-TIP_7"] = "Puedes disfrutar de juego cooperativo con más de 2 personas en el canal CO-OP.";
	["ES-TIP_8"] = "No olvides visitar la fanpage oficial de StepPrime :  facebook.com/PumpSanity";
	["ES-TIP_9"] = "Visita nuestra pagina web: www.pumpsanity.net";
	["ES-TIP_10"] = "Unete a nuestro discord!";
	
	["PT-TIP_1"] = "Nos sigam no Facebook : facebook.com/PumpSanity";
	["PT-TIP_2"] = "No Rank Mode, pode haver game over na primeira jogada.";
	["PT-TIP_3"] = "Utilizando o comando AUTO VELOCITY, você pode ajustar a velocidade mais precisa.";
	["PT-TIP_4"] = "Se quiser praticar, utilize o comando RUSH.";
	["PT-TIP_5"] = "Utilize o canal de NÍVEIS, para encontrar a música rapidamente.";
	["PT-TIP_6"] = "Se tirar uma nota 'A', você ganhará um coração bônus.";
	["PT-TIP_7"] = "Você ganhará 1 coração bonus do modo Normal e Remix e 2 corações bonus de Full Song.";
	["PT-TIP_8"] = "Você precisa de corações para jogar: Shortcut - 1 coração, Normal - 2 corações, Remix - 3 corações e Full Song - 4 corações.";
	["PT-TIP_9"] = "Visite nossa página: www.pumpsanity.net";
	["PT-TIP_10"] = "Junte-se ao nosso discord";
	
	

}

function isAspectRatio1610()
	local curAspect = round(GetScreenAspectRatio(),5);
	if curAspect == 1.6 then -- 16:10
		return true;
	end;

	return false;
end;

function ReceptorYFixed()
	local curAspect = round(GetScreenAspectRatio(),5);
	if curAspect == 1.6 then -- 16:10
		return 198;
	end;
	if curAspect == 1.33333 then -- 4:3
		return 252;
	end;
	return 172;--172
end;

function fGetTipStr()
	
	local num = math.random(1,10)
	--Trace(gLANG() .. "TIP_" .. num);
	
	local str = aTipText[string.upper(PREFSMAN:GetPreference('Language')) .. "-" .. "TIP_" .. num]
	return str
end
-----------------------------------
----- CUSTOM PROFILE MOD JNC ------
-----------------------------------

--[[local ProfileFolder = "Save/LocalProfiles/";

function SaveCustomProfile(player)
	if GAMESTATE:IsHumanPlayer(player) and PROFILEMAN:IsPersistentProfile(player) then
		local arrval = {};
		local skn = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
		local bgc;
		local rval = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate();
		if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff() then
			bgc = "false";
		else
			if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark() then
				bgc = "dark";
			else
				bgc = "true";
			end;
		end;
		table.insert(arrval,{noteskin=skn, bga=bgc, rush=round2(rval, 1)});
		IniFile.WriteFile(ProfileFolder .. string.lower(PROFILEMAN:GetProfile(player):GetGUID()) .. ".ini", arrval)
	end;
end;


function LoadCustomProfile(player)
	if GAMESTATE:IsHumanPlayer(player) and FILEMAN:DoesFileExist(ProfileFolder .. string.lower(PROFILEMAN:GetProfile(player):GetGUID()) .. ".ini") and PROFILEMAN:IsPersistentProfile(player) then
		local cmods = IniFile.ReadFile(ProfileFolder .. string.lower(PROFILEMAN:GetProfile(player):GetGUID()) .. ".ini")

		if cmods["1"]["rush"] ~= nil then
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(cmods["1"]["rush"]);
		end;
		
		if cmods["1"]["bga"] ~= nil then
			local op = cmods["1"]["bga"];
			if op == "dark" then
				if bIsModded() and mBGADARK then GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(true); end;
				GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(false);
			else
				if op == "false" then
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(true);
				else
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(false);
				end;
				
				if bIsModded() and mBGADARK then GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(false); end;
			end;
		end;
		
		if cmods["1"]["noteskin"] ~= nil then
			GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin(cmods["1"]["noteskin"]);
		end;
		
	end;
end;]]
