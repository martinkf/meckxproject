local t = Def.ActorFrame {};

--MAX LIMIT FOR THE TIMING ADJUSTMENT
local limitTiming = {3,-3};

--For tabs with unknown number of items, insert duplicates until at least this many items are present to make everything look good
local minNumItemsCW = 7


local function addStep(value, step)
    local factor = 1 / step
    -- normalizamos al múltiplo más cercano
    value = math.floor(value * factor + 0.5) / factor
    -- sumamos y aseguramos upper
    return math.ceil((value + step) * factor - 1e-9) / factor
end

-- Resta con ajuste al lower
local function subStep(value, step)
    local factor = 1 / step
    -- normalizamos al múltiplo más cercano
    value = math.floor(value * factor + 0.5) / factor
    -- restamos y aseguramos lower
    return math.floor((value - step) * factor + 1e-9) / factor
end

--############################--
--			Noteskins 	 	  --
--############################--
PAVenabled={};
local notelist = GetNoteSkinList();
local notelistPrimaryNum = GetPrimaryNoteSkinNum();
local tmpNoteSkin={"",""};

local judgeSkinList = GetJudgSkinList(); -- las carpetas vienen con i_/e_ donde i_=en el theme - e_= en la raiz del juego
local lifebarSkinList = getLifeBarSkinList(); -- las carpetas vienen con i_/e_ donde i_=en el theme - e_= en la raiz del juego

local function FindFileWithPattern(directory, pattern)
    -- Obtener todos los archivos del directorio
    local files = FILEMAN:GetDirListing(directory, false,false) -- Solo archivos
    for _, file in ipairs(files) do
        if string.find(file, pattern) then
            return directory .. "/" .. file -- Devolver la ruta completa
        end
    end
    --return 'xxxxxxxxxxxxxxxxxxxxxxxxxxx' -- No se encontró el archivo
    return THEME:GetPathG("", "_blank.png");
end

local function FindFileWithPatternCheck(directory, pattern)
    -- Obtener todos los archivos del directorio
    local files = FILEMAN:GetDirListing(directory, false,false) -- Solo archivos
    for _, file in ipairs(files) do
        if string.find(file, pattern) then
            return true;
        end
    end
    --return 'xxxxxxxxxxxxxxxxxxxxxxxxxxx' -- No se encontró el archivo
    return false;
end



--############################--
--      PREVIEW GAMEZONE      --
--############################--


local lifebarSpriteObject = {};
local judgmentSpriteObject = {};
function getIndexModSelectedFromModList(list,actualSelection)
	for i = 1, #list do
		
		--Trace("#list "..i..":"..list[i].command);
		if list[i].command == actualSelection then
			return i;
		end;
	end;
	return 1;
end;



function getSkinJudgmentPreview(player)
	local skinPlayer = getCustomOptionValuePlayer(player,"judgmentSkin");

	if skinPlayer == nil then
		skinPlayer = "i_sanity";
	end;

	local skinExterno=false;

	local esExterno = string.find(skinPlayer, "e_");
	if esExterno ~= nil then
		skinExterno = true;
	end;

	local skinSelectedProfileProc = string.gsub(skinPlayer, "e_", "");
	skinSelectedProfileProc = string.gsub(skinSelectedProfileProc, "i_", "");

	--comprobamos archivo por archivo si existe para mostrarse.
	local skinJudgText = getSkinJudgmentTemplateNew("judgments",skinSelectedProfileProc,skinExterno);
	local skinComboLabel = getSkinJudgmentTemplateNew("combo",skinSelectedProfileProc,skinExterno);
	local skinComboNumber = getSkinJudgmentTemplateNew("comboNumber",skinSelectedProfileProc,skinExterno);
	local skinIcon = getSkinJudgmentTemplateNew("icon",skinSelectedProfileProc,skinExterno);
	local skinSelected = {skinJudgText,skinComboLabel,skinComboNumber,skinIcon};
	return skinSelected;
end;

function getLifebarSkinIconData(player)
		local lifeBarSkinPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");

		if lifeBarSkinPlayer == nil or lifeBarSkinPlayer == "" then
			lifeBarSkinPlayer = "i_default";
		end;

		local lifebarPath = getPathSkinLifeBar(lifeBarSkinPlayer);
		--we check if the icon exist.
		if FILEMAN:DoesFileExist(lifebarPath.."/icon.png") then
			return lifebarPath.."/icon.png";
		elseif FILEMAN:DoesFileExist(lifebarPath.."/Icon.png") then
			return lifebarPath.."/Icon.png";
		elseif FILEMAN:DoesFileExist(lifebarPath.."/Icon.jpg") then
			return lifebarPath.."/Icon.png";
		elseif FILEMAN:DoesFileExist(lifebarPath.."/icon.jpg") then
			return lifebarPath.."/icon.png";
		else
			return THEME:GetPathG("","_blank");
		end;
end;


function getSkinJudgmentPreviewBySkinName(skinPlayer)
	if skinPlayer == nil then
		skinPlayer = "i_sanity";
	end;

	local skinExterno=false;

	local esExterno = string.find(skinPlayer, "e_");
	if esExterno ~= nil then
		skinExterno = true;
	end;

	local skinSelectedProfileProc = string.gsub(skinPlayer, "e_", "");
	skinSelectedProfileProc = string.gsub(skinSelectedProfileProc, "i_", "");

	--comprobamos archivo por archivo si existe para mostrarse.
	local skinJudgText = getSkinJudgmentTemplateNew("judgments",skinSelectedProfileProc,skinExterno);
	local skinComboLabel = getSkinJudgmentTemplateNew("combo",skinSelectedProfileProc,skinExterno);
	local skinComboNumber = getSkinJudgmentTemplateNew("comboNumber",skinSelectedProfileProc,skinExterno);
	local skinSelected = {skinJudgText,skinComboLabel,skinComboNumber};
	return skinSelected;
end;

function getTimeSpeedPrev(player)

	local beatprev=16; --16b? idk
	local STATE = GAMESTATE:GetPlayerState(player);
	local bpm = GAMESTATE:GetCurrentSong():GetCustomBPM()  -- BPM actual del gameplay

	local velPlayer = STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod();
	local avPlayer = STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod();
	
	if avPlayer == nil then
		avPlayer = 0;
		bpm = velPlayer * bpm;
	else
		bpm = avPlayer;
	end;

	local tiempoPorBeat = 60 / bpm
	local tiempoRealGameplay = tiempoPorBeat * beatprev 

	-- Rango del gameplay y previsualización
	local rangoGameplay = (SCREEN_HEIGHT - 148) - (-256)  -- gameplay
	local rangoPrevisualizacion = 255 - (-255)  		  -- 510 cw
	local escala = rangoPrevisualizacion / rangoGameplay 

	-- Tiempo ajustado para la previsualización
	speedModTiming = tiempoRealGameplay * escala

	return speedModTiming;

end;

function shuffleArray(arr)
    -- Copiar el array original a uno nuevo
    local shuffled = {}
    for i = 1, #arr do
        shuffled[i] = arr[i]
    end

    -- Aplicar el algoritmo de Fisher-Yates para revolver
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i) -- Escoge un índice aleatorio
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i] -- Intercambia los elementos
    end

    return shuffled -- Retornar el nuevo array mezclado
end

--if you want to add a new icon preview selected, here is your place.
function getActorPreviewOptionSelected(player,typeActor)
	local speedLoad = 0.08;

	if typeActor == "timing" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "timingadj" then
						self:queuecommand("LoadTimingPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadTimingPreviewCommand=function(self,params)
				local timingAdjCustomOption = getCustomOptionValuePlayer(player,"timing_adjustment");
				local timingPlayer = 0.0;

				timingPlayer = tonumber(timingAdjCustomOption) or 0.0;

				local sign="";
				if timingPlayer > 0 then
					sign = "+";
				end;

				if timingPlayer == 0 then
					timingPlayer = "0.0";
				end;

				self:GetChild("timingPreviewCw"):settext(sign..timingPlayer);
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				local timingAdjCustomOption = getCustomOptionValuePlayer(player,"timing_adjustment");
				local timingPlayer = 0.0;

				timingPlayer = tonumber(timingAdjCustomOption) or 0.0;

				local sign="";
				if timingPlayer > 0 then
					sign = "+";
				end;

				if timingPlayer == 0 then
					timingPlayer = "0.0";
				end;

				self:GetChild("timingPreviewCw"):settext(sign..timingPlayer);									
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadFont("interphase/WhiteInterNumber numbers")..{
				Name="timingPreviewCw";
				InitCommand=cmd(y,-48;zoom,0.55;horizalign,center;settext,"0.0";visible,true);
			};	
		};
	end;

	if typeActor == "judgeskin" then
		--judgeskin
		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "judgeskin" then
						self:queuecommand("LoadSkinPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				local judgSkinData = getSkinJudgmentPreview(player);
				self:GetChild("iconJudg"):Load(judgSkinData[4]);			
			end;

			LoadSkinPreviewCommand=function(self,params)
				local judgSkinData = getSkinJudgmentPreview(player);
				self:GetChild("iconJudg"):Load(judgSkinData[4]);
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			Def.Sprite{
					Name="iconJudg";
				    InitCommand=function(self)
				    		self:y(-30);	
				    		self:scaletoclipped(60,50);
				    end;
			};
		};
			
	end;

	if typeActor == "lifebarskin" then
		--judgeskin
		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "lifebarskin" then
						self:queuecommand("LoadLifebarSkinPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				local lifebarSkinData = getLifebarSkinIconData(player);
				self:GetChild("iconLifebar"):Load(lifebarSkinData);			
			end;

			LoadLifebarSkinPreviewCommand=function(self,params)
				local lifebarSkinData = getLifebarSkinIconData(player);
				self:GetChild("iconLifebar"):Load(lifebarSkinData);
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			Def.Sprite{
					Name="iconLifebar";
				    InitCommand=function(self)
				    		self:y(-31);	
				    		self:scaletoclipped(44,34);
				    end;
			};
		};
			
	end;


	if typeActor == "zoom" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "judgeskinzoom" then
						self:queuecommand("LoadZoomPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				local zoomPlayer = getCustomOptionValuePlayer(player,"judgmentZoom") or 100;				
				self:GetChild("zoomPreviewCw"):settext(zoomPlayer.."%");
			end;

			LoadZoomPreviewCommand=function(self,params)
				local zoomPlayer = getCustomOptionValuePlayer(player,"judgmentZoom") or 100;				
				self:GetChild("zoomPreviewCw"):settext(zoomPlayer.."%");
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadFont("interphase/WhiteInterNumber numbers")..{
				Name="zoomPreviewCw";
				InitCommand=cmd(y,-48;zoom,0.55;horizalign,center;settext,"0.0";visible,true);
			};	
		};
	end;


	if typeActor == "lifebarSettings" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "lifebarsettings" then
						self:queuecommand("LoadLifeBarSettingsPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadLifeBarSettingsPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkOptSelectedPreview");
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkOptSelectedPreview");
			end;

			checkOptSelectedPreviewCommand=function(self,params)
				local STATE = GAMESTATE:GetPlayerState(player);
				local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();

				local isBreakOn = false;
				if failSetting == "FailType_Immediate" then
					isBreakOn = true;
				end;	

				if isBreakOn == nil or isBreakOn == false then
					self:GetChild("opt_breakon"):visible(true);
				else
					self:GetChild("opt_breakon"):visible(false);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/lifebarSettings"))..{
				OnCommand=function(self)
					self:zoom(0.27);
					self:y(-31);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.27);
					self:y(-32);
				end;
			};

		    Def.Quad {
		    	Name="opt_breakon";
		        InitCommand = function(self)
		            self:zoomto(32, 23):diffuse(0, 0, 0, 0.6):x(0):y(-32);
		        end;
		    };
		};


	end;

	if typeActor == "gameplayinfo" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "info" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkOptSelectedPreview");
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkOptSelectedPreview");
			end;

			checkOptSelectedPreviewCommand=function(self,params)
				local fastslowUi = getCustomOptionValuePlayer(player,"gameplay_fastslow");
				local breakIconUi = getCustomOptionValuePlayer(player,"gameplay_break_icon_ui");			
				local scoreUi = getCustomOptionValuePlayer(player,"gameplay_score_ui");
				local scoreUiPercentaje = getCustomOptionValuePlayer(player,"gameplay_score_percentaje_ui");
				local judgeDataUi = getCustomOptionValuePlayer(player,"gameplay_stats_ui");
				local songTimeUi = getCustomOptionValuePlayer(player,"gameplay_song_time_ui");
				local stepLvUi = getCustomOptionValuePlayer(player,"gameplay_lv_ui");
				local timingbar = getCustomOptionValuePlayer(player,"gameplay_timingbar");

				if fastslowUi == nil or fastslowUi == false then
					self:GetChild("opt_timing"):visible(true);
				else
					self:GetChild("opt_timing"):visible(false);
				end;

				if breakIconUi == nil or breakIconUi == false then
					self:GetChild("opt_breaktiming"):visible(true);
				else
					self:GetChild("opt_breaktiming"):visible(false);
				end;

				if scoreUi == nil or scoreUi == false then
					self:GetChild("opt_score"):visible(true);
				else
					self:GetChild("opt_score"):visible(false);
				end;

				if scoreUiPercentaje == nil or scoreUiPercentaje == false then
					self:GetChild("opt_scorepercent"):visible(true);
				else
					self:GetChild("opt_scorepercent"):visible(false);
				end;

				if judgeDataUi == nil or judgeDataUi == false then
					self:GetChild("opt_judgdata"):visible(true);
				else
					self:GetChild("opt_judgdata"):visible(false);
				end;

				if songTimeUi == nil or songTimeUi == false then
					self:GetChild("opt_musicduration"):visible(true);
				else
					self:GetChild("opt_musicduration"):visible(false);
				end;

				if stepLvUi == nil or stepLvUi == false then
					self:GetChild("opt_steplv"):visible(true);
				else
					self:GetChild("opt_steplv"):visible(false);
				end;

				if timingbar == nil or timingbar == false then
					self:GetChild("opt_timingbar"):visible(true);
				else
					self:GetChild("opt_timingbar"):visible(false);
				end;

			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.636);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/gamePlayIcons"))..{
				OnCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
			};

		    Def.Quad {
		    	Name="opt_timing";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-121):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_breaktiming";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-86):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_score";
		        InitCommand = function(self)
		            self:zoomto(32.5, 21):diffuse(0, 0, 0, 0.6):x(-52):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_scorepercent";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-17):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_judgdata";
		        InitCommand = function(self)
		            self:zoomto(32.5, 21):diffuse(0, 0, 0, 0.6):x(18):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_musicduration";
		        InitCommand = function(self)
		            self:zoomto(32.5, 21):diffuse(0, 0, 0, 0.6):x(52):y(-30);
		        end;
		    };
		    Def.Quad {
		    	Name="opt_steplv";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(86):y(-30);
		        end;
		    };

		    Def.Quad {
		    	Name="opt_timingbar";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(121):y(-30);
		        end;
		    };
		};
	end;

	--speed
	if typeActor == "speed" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "speed" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkSpeedSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkSpeedSelectedPreview");
			end;

			checkSpeedSelectedPreviewCommand=function(self,params)
					local STATE = GAMESTATE:GetPlayerState(player);
					local velPlayer = STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod();
					local avPlayer = STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod();
					local esExpand = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(); -- 1 / 0
				    local esAccel = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(); -- 1 / 0
					local esDecel = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(); -- 1 / 0
				  	local esRandomVel = STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(); -- true / false

				  	if avPlayer == nil then
						self:GetChild("opt_av"):visible(true);
					else
						self:GetChild("opt_av"):visible(false);
						self:GetChild("opt_x1"):visible(true);
						self:GetChild("opt_x2"):visible(true);
						self:GetChild("opt_x3"):visible(true);
						self:GetChild("opt_x4"):visible(true);
						self:GetChild("opt_x5"):visible(true);
						self:GetChild("opt_x6"):visible(true);
						self:GetChild("opt_x025"):visible(true);
						self:GetChild("opt_x05"):visible(true);
						self:GetChild("opt_ew"):visible(true);
						self:GetChild("opt_rv"):visible(true);
						self:GetChild("opt_ac"):visible(true);
						self:GetChild("opt_dc"):visible(true);

						return;
					end;

					local noX = string.gsub(GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod(),"x","");
					self:GetChild("opt_x025"):visible(true);
					self:GetChild("opt_x05"):visible(true);

					if tonumber(noX) % 1 == .25 then
						self:GetChild("opt_x025"):visible(false);
						self:GetChild("opt_x05"):visible(true);
					elseif tonumber(noX) % 1 == .5 then 	--es decimal
						self:GetChild("opt_x05"):visible(false);
						self:GetChild("opt_x025"):visible(true);
					elseif tonumber(noX) % 1 == .75 then 	--es decimal
						self:GetChild("opt_x025"):visible(false);
						self:GetChild("opt_x05"):visible(false);
					end;

					noX =  math.floor(tonumber(noX));

					if tonumber(noX) == 1 then
						self:GetChild("opt_x1"):visible(false);
					else
						self:GetChild("opt_x1"):visible(true);
					end;

					if tonumber(noX) == 2 then
						self:GetChild("opt_x2"):visible(false);
					else
						self:GetChild("opt_x2"):visible(true);
					end;


					if tonumber(noX) == 3 then
						self:GetChild("opt_x3"):visible(false);
					else
						self:GetChild("opt_x3"):visible(true);
					end;


					if tonumber(noX) == 4 then
						self:GetChild("opt_x4"):visible(false);
					else
						self:GetChild("opt_x4"):visible(true);
					end;


					if tonumber(noX) == 5 then
						self:GetChild("opt_x5"):visible(false);
					else
						self:GetChild("opt_x5"):visible(true);
					end;


					if tonumber(noX) == 6 then
						self:GetChild("opt_x6"):visible(false);
					else
						self:GetChild("opt_x6"):visible(true);
					end;


					if esExpand == 1 then
						self:GetChild("opt_ew"):visible(false);
					else
						self:GetChild("opt_ew"):visible(true);
					end;

					if esRandomVel then
						self:GetChild("opt_rv"):visible(false);
					else
						self:GetChild("opt_rv"):visible(true);
					end;


					if esAccel == 1 then
						self:GetChild("opt_ac"):visible(false);
					else
						self:GetChild("opt_ac"):visible(true);
					end;

					if esDecel == 1 then
						self:GetChild("opt_dc"):visible(false);
					else
						self:GetChild("opt_dc"):visible(true);
					end;

			end;


			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("opt_x1"):visible(true);
					self:GetChild("opt_x2"):visible(false);
					self:GetChild("opt_x3"):visible(true);
					self:GetChild("opt_x4"):visible(true);
					self:GetChild("opt_x5"):visible(true);
					self:GetChild("opt_x6"):visible(true);
					self:GetChild("opt_x025"):visible(true);
					self:GetChild("opt_x05"):visible(true);
					self:GetChild("opt_ew"):visible(true);
					self:GetChild("opt_rv"):visible(true);
					self:GetChild("opt_ac"):visible(true);
					self:GetChild("opt_dc"):visible(true);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.62);
					self:zoomx(0.636);					
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.62);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/speedIcons_01"))..{
				OnCommand=function(self)
					self:zoom(0.2);
					self:y(-40);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.2);
					self:y(-40);
				end;
			};



			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/speedIcons_02"))..{
				OnCommand=function(self)
					self:zoom(0.2);
					self:y(-20);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.2);
					self:y(-20);
				end;
			};

			--speeds
			Def.Quad {
		    	Name="opt_x1";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-89):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x2";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-64):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x3";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-38):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x4";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-13):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x5";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(13):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x6";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(38):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x025";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(64):y(-40);
		        end;
		    };
			Def.Quad {
		    	Name="opt_x05";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(89):y(-40);
		        end;
		    };
			--mods
			Def.Quad {
		    	Name="opt_ew";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-51):y(-20);
		        end;
		    };
			Def.Quad {
		    	Name="opt_rv";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(-26):y(-20);
		        end;
		    };
			Def.Quad {
		    	Name="opt_av";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(0):y(-20);
		        end;
		    };
			Def.Quad {
		    	Name="opt_ac";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(26):y(-20);
		        end;
		    };
			Def.Quad {
		    	Name="opt_dc";
		        InitCommand = function(self)
		            self:zoomto(24, 16):diffuse(0, 0, 0, 0.6):x(51):y(-20);
		        end;
		    };
		};

	end;


	--display
	if typeActor == "display" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "display" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkOptSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkOptSelectedPreview");
			end;

			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("opt_bgaoff"):visible(true);
					self:GetChild("opt_bgadark"):visible(true);
					self:GetChild("opt_bgapartial"):visible(true);
					self:GetChild("opt_vanish"):visible(true);
					self:GetChild("opt_ap"):visible(true);
					self:GetChild("opt_ns"):visible(true);
					self:GetChild("opt_fd"):visible(true);
					self:GetChild("opt_fl"):visible(true);
					self:GetChild("opt_rskin"):visible(true);
					self:GetChild("opt_mi"):visible(true);
				end;
			end;

			checkOptSelectedPreviewCommand=function(self,params)

				local STATE = GAMESTATE:GetPlayerState(player);
				local bgaoff = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff();
				local bgadark = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark();	
				local bgapartial = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial();
				local esVanish = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish();
				local esAppear = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear();
				local esNonstep = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Nonstep();
				local esFlash = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Flash();
				local esMini = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini();
				local esFreedom = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Dark();
				local esrandomnote = STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomNote();

				if bgaoff then
					self:GetChild("opt_bgaoff"):visible(false);
				else
					self:GetChild("opt_bgaoff"):visible(true);
				end;

				if bgadark then
					self:GetChild("opt_bgadark"):visible(false);
				else
					self:GetChild("opt_bgadark"):visible(true);
				end;

				if bgapartial then
					self:GetChild("opt_bgapartial"):visible(false);
				else
					self:GetChild("opt_bgapartial"):visible(true);
				end;

				if esVanish == 1 then					
					self:GetChild("opt_vanish"):visible(false);
				else
					self:GetChild("opt_vanish"):visible(true);
				end;

				if esAppear == 1 then
					self:GetChild("opt_ap"):visible(false);
				else
					self:GetChild("opt_ap"):visible(true);
				end;

				if esNonstep == 1 then
					self:GetChild("opt_ns"):visible(false);
				else
					self:GetChild("opt_ns"):visible(true);
				end;

				if esFreedom == 1 then
					self:GetChild("opt_fd"):visible(false);
				else
					self:GetChild("opt_fd"):visible(true);
				end;

				if esFlash == 1 then
					self:GetChild("opt_fl"):visible(false);
				else
					self:GetChild("opt_fl"):visible(true);
				end;

				if esrandomnote then
					self:GetChild("opt_rskin"):visible(false);
				else
					self:GetChild("opt_rskin"):visible(true);
				end;

				if esMini > 0 then
					self:GetChild("opt_mi"):visible(false);
				else
					self:GetChild("opt_mi"):visible(true);
				end;

			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.636);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.636);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/displayIcons"))..{
				OnCommand=function(self)
					self:zoom(0.232);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.232);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_bgaoff";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(-136):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_bgadark";
		        InitCommand = function(self)
		            self:zoomto(28.5, 19):diffuse(0, 0, 0, 0.6):x(-105):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_bgapartial";
		        InitCommand = function(self)
		            self:zoomto(28.5, 19):diffuse(0, 0, 0, 0.6):x(-76):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_vanish";
		        InitCommand = function(self)
		            self:zoomto(28.5, 19):diffuse(0, 0, 0, 0.6):x(-45):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_ap";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(-15):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_ns";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(15):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_fd";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(45):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_fl";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(75):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_rskin";
		        InitCommand = function(self)
		            self:zoomto(28.5, 19):diffuse(0, 0, 0, 0.6):x(105):y(-30);
		        end;
		    };
			Def.Quad {
		    	Name="opt_mi";
		        InitCommand = function(self)
		            self:zoomto(28, 19):diffuse(0, 0, 0, 0.6):x(136):y(-30);
		        end;
		    };
		};

	end;


	if typeActor == "note skin" then
		--judgeskin
		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "note skin" then
						self:queuecommand("LoadnoteskinPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
	    		local STATE = GAMESTATE:GetPlayerState(player);
	    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();

	    		local checkExistIcon = FindFileWithPatternCheck("NoteSkins/pump/".. noteSkinSelected.."/","logo");
	    		local checkExistIconB = FindFileWithPatternCheck("NoteSkins/pump/".. noteSkinSelected.."/","Logo");

	    		if checkExistIcon then
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/","logo");
					self:GetChild("noteskinSprite"):Load(nomArchivoFull);
	    		elseif checkExistIconB then
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/","Logo");
					self:GetChild("noteskinSprite"):Load(nomArchivoFull);
				else
					self:GetChild("noteskinSprite"):Load(THEME:GetPathG("", "_blank.png"));
	    		end;

			end;

			LoadnoteskinPreviewCommand=function(self,params)
	    		local STATE = GAMESTATE:GetPlayerState(player);
	    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();

	    		local checkExistIcon = FindFileWithPatternCheck("NoteSkins/pump/".. noteSkinSelected.."/","logo");
	    		local checkExistIconB = FindFileWithPatternCheck("NoteSkins/pump/".. noteSkinSelected.."/","Logo");

	    		if checkExistIcon then
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/","logo");
					self:GetChild("noteskinSprite"):Load(nomArchivoFull);
	    		elseif checkExistIconB then
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/","Logo");
					self:GetChild("noteskinSprite"):Load(nomArchivoFull);
				else
					self:GetChild("noteskinSprite"):Load(THEME:GetPathG("", "_blank.png"));
	    		end;

				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			Def.Sprite{
					Name="noteskinSprite";
				    InitCommand=function(self)
				    		self:y(-31);	
				    		self:scaletoclipped(44,34);
				    end;
			};
		};
			
	end;


	--path
	if typeActor == "path" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "path" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkPathOptSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkPathOptSelectedPreview");
			end;

			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("opt_x"):visible(true);
					self:GetChild("opt_nx"):visible(true);
					self:GetChild("opt_ua"):visible(true);
					self:GetChild("opt_dr"):visible(true);
					self:GetChild("opt_ri"):visible(true);
					self:GetChild("opt_sn"):visible(true);
					self:GetChild("opt_zz"):visible(true);
				end;
			end;

			checkPathOptSelectedPreviewCommand=function(self,params)
				local STATE = GAMESTATE:GetPlayerState(player);
				local esXmode = STATE:GetPlayerOptions('ModsLevel_Preferred'):Xmode();
				local esNxMode = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NXMode();
				local esUA = STATE:GetPlayerOptions('ModsLevel_Preferred' ):UnderAttack();
				local esDropMode = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Drop();
				local esRiseOrSink = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Rise();
				local esSnake = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Snake();
				local esZigZag = STATE:GetPlayerOptions('ModsLevel_Preferred' ):ZigZag();

				if esXmode == 1 then
					self:GetChild("opt_x"):visible(false);
				else
					self:GetChild("opt_x"):visible(true);
				end;

				if esNxMode  then
					self:GetChild("opt_nx"):visible(false);
				else
					self:GetChild("opt_nx"):visible(true);
				end;

				if esUA then
					self:GetChild("opt_ua"):visible(false);
				else
					self:GetChild("opt_ua"):visible(true);
				end;

				if esDropMode then
					self:GetChild("opt_dr"):visible(false);
				else
					self:GetChild("opt_dr"):visible(true);
				end;

				if esRiseOrSink > 0 then
					self:GetChild("opt_ri"):visible(false);
				else
					self:GetChild("opt_ri"):visible(true);
				end;

				if esRiseOrSink < 0 then
					self:GetChild("opt_si"):visible(false);
				else
					self:GetChild("opt_si"):visible(true);
				end;


				if esSnake then
					self:GetChild("opt_sn"):visible(false);
				else
					self:GetChild("opt_sn"):visible(true);
				end;

				if esZigZag then
					self:GetChild("opt_zz"):visible(false);
				else
					self:GetChild("opt_zz"):visible(true);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.636);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.636);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/pathIcons"))..{
				OnCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_x";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-121):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_nx";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-86):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_ua";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-52):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_dr";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-17):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_si";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(17):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_ri";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(52):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_sn";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(86):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_zz";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(121):y(-30);
		        end;
		    };

		};

	end;


	--alternate
	if typeActor == "alternate" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "alternate" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkAlternateSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkAlternateSelectedPreview");
			end;

			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("opt_rs"):visible(true);
					self:GetChild("opt_ss"):visible(true);
					self:GetChild("opt_m"):visible(true);
				end;
			end;

			checkAlternateSelectedPreviewCommand=function(self,params)
				local STATE = GAMESTATE:GetPlayerState(player);
				local esBackwards = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards();
				local esSuperShufle = STATE:GetPlayerOptions('ModsLevel_Preferred' ):SuperShuffle();
				local esMirror = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mirror();

				if esSuperShufle then
					self:GetChild("opt_rs"):visible(false);
				else
					self:GetChild("opt_rs"):visible(true);
				end;

				if esBackwards then
					self:GetChild("opt_ss"):visible(false);
				else
					self:GetChild("opt_ss"):visible(true);
				end;

				if esMirror then
					self:GetChild("opt_m"):visible(false);
				else
					self:GetChild("opt_m"):visible(true);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.3);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.3);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/alternateIcons"))..{
				OnCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_ss";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-35):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_rs";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_m";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(35):y(-30);
		        end;
		    };

		};

	end;


	--judge
	if typeActor == "judge" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "judge" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkJudgSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkJudgSelectedPreview");
			end;

			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("opt_jr"):visible(true);
					self:GetChild("opt_hj"):visible(true);
					self:GetChild("opt_vj"):visible(true);
					self:GetChild("opt_xj"):visible(true);
					self:GetChild("opt_uj"):visible(true);
				end;
			end;

			checkJudgSelectedPreviewCommand=function(self,params)
				local STATE = GAMESTATE:GetPlayerState(player);
				local esJr = STATE:GetPlayerOptions('ModsLevel_Preferred' ):JudgeReverse();
				local esHj = STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement();
				local esVj = STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement();
				local esXj = STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement();
				local esUj = STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement();
				

				if esJr then
					self:GetChild("opt_jr"):visible(false);
				else
					self:GetChild("opt_jr"):visible(true);
				end;

				if esHj then
					self:GetChild("opt_hj"):visible(false);
				else
					self:GetChild("opt_hj"):visible(true);
				end;

				if esVj then
					self:GetChild("opt_vj"):visible(false);
				else
					self:GetChild("opt_vj"):visible(true);
				end;

				if esXj then
					self:GetChild("opt_xj"):visible(false);
				else
					self:GetChild("opt_xj"):visible(true);
				end;

				if esUj then
					self:GetChild("opt_uj"):visible(false);
				else
					self:GetChild("opt_uj"):visible(true);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/bigBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.44);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:zoomx(0.44);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/judgIcons"))..{
				OnCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.27);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_jr";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-69):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_hj";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(-35):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_vj";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_xj";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(35):y(-30);
		        end;
		    };

			Def.Quad {
		    	Name="opt_uj";
		        InitCommand = function(self)
		            self:zoomto(32, 21):diffuse(0, 0, 0, 0.6):x(69):y(-30);
		        end;
		    };

		};
	end;


	--rush
	if typeActor == "rush" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "rush" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkRushSelectedPreview");
			end;


			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkRushSelectedPreview");
			end;

			CommandWindowResetMessageCommand=function(self, params)
				if params.Player == player then
					self:GetChild("rushIcons"):setstate(4);
				end;
			end;

			checkRushSelectedPreviewCommand=function(self,params)
				local STATE = GAMESTATE:GetPlayerState(player);
				local rushActivo = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate();
				if rushActivo == 1 then 
					self:GetChild("rushIcons"):setstate(4); 
				else
					if rushActivo >= 0.6 and rushActivo <= 0.68 then 
						self:GetChild("rushIcons"):setstate(0); 
					elseif rushActivo > 0.68 and rushActivo <= 0.78 then 
						self:GetChild("rushIcons"):setstate(1); 
					elseif rushActivo > 0.78 and rushActivo <= 0.88 then 
						self:GetChild("rushIcons"):setstate(2); 
					elseif rushActivo > 0.88 and rushActivo <= 0.98 then 
						self:GetChild("rushIcons"):setstate(3); 
					elseif rushActivo > 1 and rushActivo <= 1.19 then 
						self:GetChild("rushIcons"):setstate(5); 
					elseif rushActivo >= 1.2 and rushActivo <= 1.28 then 
						self:GetChild("rushIcons"):setstate(6); 
					elseif rushActivo > 1.28 and rushActivo <= 1.38 then 
						self:GetChild("rushIcons"):setstate(7); 
					elseif rushActivo > 1.38 and rushActivo <= 1.48 then 
						self:GetChild("rushIcons"):setstate(8); 
					elseif rushActivo > 1.48 and rushActivo <= 1.58 then 
						self:GetChild("rushIcons"):setstate(9); 
					elseif rushActivo > 1.58 and rushActivo <= 1.68 then 
						self:GetChild("rushIcons"):setstate(10); 
					elseif rushActivo > 1.68 then 
						self:GetChild("rushIcons"):setstate(11); 
					end;
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/rushIcons"))..{
				Name="rushIcons";
				OnCommand=function(self)
					self:animate(false);
					self:setstate(4);
					self:zoom(0.32);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
			};

		};

	end;


	--sort
	if typeActor == "sort" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "sort" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkSortSelectedPreview");
			end;

			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkSortSelectedPreview");
			end;

			checkSortSelectedPreviewCommand=function(self,params)
				local isSortTitle = GAMESTATE:GetSortTitle();
				if isSortTitle then
					self:GetChild("opt_title"):visible(false);
				else
					self:GetChild("opt_title"):visible(true);
				end;

			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/sortIcons"))..{
				OnCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_title";
		        InitCommand = function(self)
		            self:zoomto(38, 26):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

		};
	end;

	--rank
	if typeActor == "rank" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "rank" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkRankSelectedPreview");
			end;


			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkRankSelectedPreview");
			end;

			checkRankSelectedPreviewCommand=function(self,params)
				local esRankMode = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode()

				if esRankMode then
					self:GetChild("opt_rank"):visible(false);
				else
					self:GetChild("opt_rank"):visible(true);
				end;
			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/rankIcon"))..{
				OnCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_rank";
		        InitCommand = function(self)
		            self:zoomto(38, 26):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

		};
	end;


	--vsMode
	if typeActor == "vsmode" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "vsmode" then
						self:queuecommand("LoadGamePlayInfoPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadGamePlayInfoPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkVsModeSelectedPreview");
			end;


			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				self:queuecommand("checkVsModeSelectedPreview");
			end;

			checkVsModeSelectedPreviewCommand=function(self,params)

				if checkVsMode() then
					self:GetChild("opt_vs"):visible(false);
				else
					self:GetChild("opt_vs"):visible(true);
				end;

			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/vsIcon"))..{
				OnCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.32);
					self:y(-30);
				end;
			};

			Def.Quad {
		    	Name="opt_vs";
		        InitCommand = function(self)
		            self:zoomto(38, 26):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

		};
	end;


	if typeActor == "av" then

		return Def.ActorFrame{

			OnCommand=function(self)
				self:zoomx(0);				
			end;

			CheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					if params.Title == "av" then
						self:queuecommand("LoadAvPreview");
					else
						self:linear(0.05);
						self:zoomx(0);
					end;
				end;
			end;

			LoadAvPreviewCommand=function(self,params)
				self:zoomx(0);
				self:linear(speedLoad);
				self:zoomx(1);
				self:queuecommand("checkAvPreview");
			end;


			CloseCheckPreviewSelectedMessageCommand=function(self, params)
				if params.Player == player then
					self:queuecommand("closePreviewProc");
				end;
			end;

			closePreviewProcCommand=function(self)
				self:linear(0.025);
				self:zoomx(0);
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:queuecommand("checkAvPreview");
				end;
			end;

			checkAvPreviewCommand=function(self,params)
				local avPlayer = tostring(GetAV(player));
				if #avPlayer > 0 then
					self:GetChild("avPreview"):settext(GetAV(player));
					self:GetChild("av_obj"):visible(false);
				else
					self:GetChild("avPreview"):settext("");
					self:GetChild("av_obj"):visible(true);
				end;

			end;

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/minBase"))..{
				OnCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.52);
					self:y(-30);
				end;
			};

			LoadActor(THEME:GetPathG( "","CommandWindow/previewResume/AVicon"))..{
				OnCommand=function(self)
					self:zoom(0.35);
					self:y(-30);
				end;
				CWOpenMessageCommand=function(self,params)
					if params.Player == player then
						self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
					end;
				end;
				FullModeMessageCommand=function(self)
					self:zoom(0.35);
					self:y(-30);
				end;
			};
 

 	 		LoadFont("interphase/InterNumber numbers").. {
 	 			Name="avPreview";
				InitCommand=cmd(y,-34;horizalign,center;settext,"300";zoom,0.3);
			};

			Def.Quad {
		    	Name="av_obj";
		        InitCommand = function(self)
		            self:zoomto(40, 28):diffuse(0, 0, 0, 0.6):x(0):y(-30);
		        end;
		    };

		};
	end;


end;


function GetPreview(player)
	--INIT
	local yPosPrevBase = 40;
	local yStartLifeBar=yPosPrevBase+18;
	local yStartReceptor=yPosPrevBase+39;
	local yStartChart=yPosPrevBase+39;
	local xPosNoteFieldPrevBase = 0;

	local yInfoPanel= yPosPrevBase+77;
	local xInfoPanel = 110;
	local inSelectChannel=false;


	--THEMES APLICADOS.
	--Rellenar con el indicado para mostrar en pantalla.
	--local themeLifeBar = "default";
	--lifebar
	local profileSkinLifeBar = getCustomOptionValuePlayer(player,"lifebarSkin");

	if profileSkinLifeBar == nil then
		profileSkinLifeBar = "i_default";
	end;

	local dataLifebarSkin = getLifebarSkinDataParsed(profileSkinLifeBar);
	--CHART DEMO PREVIEW


	local defaultChartShow = 
	{
		{1,0,0,0,0},
		{0,0,0,0,1},
		{0,1,0,0,0},
		{0,0,1,1,0},
		{0,1,0,0,0},
		{0,0,0,0,0},
		{0,0,0,0,0},
		{0,0,0,0,0},		
	};

	local defaultMirrorShow = 
	{
		{0,0,0,0,1},
		{1,0,0,0,0},
		{0,0,0,1,0},
		{0,1,1,0,0},
		{0,0,0,1,0},
		{0,0,0,0,0},
		{0,0,0,0,0},
		{0,0,0,0,0},		
	};

	local defaultRandomShow = 
	{
		{0,0,0,0,1},
		{0,0,0,0,1},
		{0,0,1,0,0},
		{1,1,0,0,0},
		{0,0,0,1,0},
		{0,0,0,0,0},
		{0,0,0,0,0},
		{0,0,0,0,0},		
	};

	local defaultBackwardsShow = 
	{
		{0,0,0,1,0},
		{0,1,0,0,0},
		{0,0,0,0,1},
		{1,0,1,0,0},
		{0,0,0,0,1},
		{0,0,0,0,0},
		{0,0,0,0,0},
		{0,0,0,0,0},
	};

	local chartDisplayed = defaultChartShow;

	local af = Def.ActorFrame {};
	--Agregamos el banner de la canción para mostrar de fondo.
    table.insert(af,Def.Banner{
		    InitCommand=function(self)
		    	self:zoomto(275, 135);
		    	self:setsize(275, 135);
		    	self:addy(yPosPrevBase + 78);
		    	self:visible(false);
		    	self:queuecommand("CheckCambio");
		    end;

		    CWOpenMessageCommand=function(self)
		    	self:zoomto(275, 135);
		    	self:visible(true);
		    end;

			CurrentSongChangedMessageCommand=function(self)
				self:queuecommand("loadBackgroundSongCw");
			end;

			SelectChannelMessageCommand=function(self)
				inSelectChannel = true;
				self:queuecommand("noBackground");
			end;
			ChannelChosenMessageCommand=function(self)
				inSelectChannel = false;
				self:queuecommand("loadBackgroundSongCw");
			end;		
			
			noBackgroundCommand=function(self)
				self:LoadFromCachedBanner( THEME:GetPathG("","CommandWindow/bg/nobg.png") );
			end;	

			loadBackgroundSongCwCommand=function(self)
				--if in performance mode, we don't show anything.
				local performanceStatus = checkPerformanceModeState();
				if performanceStatus then
					self:queuecommand("noBackground");
					return;
				end;

				self:zoomto(275, 135);
		    	self:setsize(275, 135);
		    	
				if inSelectChannel then
					
				else
			        local song = GAMESTATE:GetCurrentSong(); -- Obtén la canción actual
			        if song then		        	
			        	local sBanner = song:GetBannerPath();

			        	if sBanner == nil then
			        		self:LoadFromCachedBanner( THEME:GetPathG("Common", "nopreview") );
			        	else
							if FILEMAN:DoesFileExist( sBanner ) then
								self:LoadFromCachedBanner( sBanner );
							else
								self:LoadFromCachedBanner( THEME:GetPathG("Common", "nopreview") );
							end;
			        	end;


			        else
			            self:visible(false); -- Si no hay canción, oculta el Sprite
			        end	
				end;
			
			end;


		    --Aca hay que evaluar las opciones para aplicarlas al menu.
		    --si hay que mover las flechas o cosas
			CommandWindowSelectModMessageCommand=function(self,params)
				self:queuecommand("CheckCambio");
			end;

			--Comprobaciones de MODS para el preview
			CheckCambioCommand = function(self)

			end;
	});

    --BGA OFF/DARK/PARCIAL
	af[#af+1] = Def.Quad {
	    InitCommand = function(self)
	    	self:addy(yPosPrevBase + 78);
	    	self:visible(false);
	    	self:queuecommand("CheckCambio");
	    	self:addx(xPosNoteFieldPrevBase);
	    end,
	    OnCommand = function(self)
	        self:zoomto(275, 135) -- Escala el rectángulo a 270x130
	        self:diffuse(color("0,0,0,1")) -- Color negro opaco
	    end;

	    --Aca hay que evaluar las opciones para aplicarlas al menu.
	    --si hay que mover las flechas o cosas
		CommandWindowSelectModMessageCommand=function(self,params)
			self:queuecommand("CheckCambio");
		end;

		--Comprobaciones de MODS para el preview
		CheckCambioCommand = function(self)
			local STATE = GAMESTATE:GetPlayerState(player);
			self:zoomto(275, 135); -- Escala el rectángulo a 270x130
			self:visible(false);
			self:fadetop(0);
			self:fadebottom(0);
			self:diffusealpha(1);
			self:diffuse(color("0,0,0,1"));

			--bgaoff
			local esbgaoff = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff();							
			if esbgaoff == true then
				self:visible(true);
				self:diffuse(color("0,0,0,1")) -- Color negro opaco
			end;	

			--bgadark
			local esbgadark = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark();							
			if esbgadark == true then
				self:visible(true);
				self:diffuse(color("0,0,0,0.7")) -- Color negro opaco
			end;

			--bgapartial
			local esbgapartial = GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial();							
			if esbgapartial == true then
				self:visible(true);
				self:zoomto(140, 135); -- Escala el rectángulo a 270x130
				self:diffuse(color("0,0,0,0.7")) -- Color negro opaco
			end;
		end;

	};

    --Agregamos los receptores.
    local receptorArrayNames = {"DownLeft Ready Receptor","UpLeft Ready Receptor","Center Ready Receptor"}
    
    
    local posXBaseChart = {-52,-26,0,26,52};
    -- different types
	local posXBaseChartNormal = {-52,-26,0,26,52};    
	local posXBaseChartMirror = {52,26,0,-26,-52};

    local posXBaseChartMini = {-37,-19,0,19,37};
        -- different types
    local posXBaseChartMini = {-37,-19,0,19,37};
    local posXBaseChartMini = {-37,-19,0,19,37};

    local zoomOnMini = 0.35;
	for i=1,5 do

		local receptorNameFile = "";
		local rotationYReceptor = 0;
		local xPosReceptor = 0;

		if i == 1 then
			receptorNameFile = receptorArrayNames[1];
			rotationYReceptor = 0;
			xPosReceptor = -52;
		end;

		if i == 2 then
			receptorNameFile = receptorArrayNames[2];
			rotationYReceptor = 0;
			xPosReceptor = -26;
		end;
		
		if i == 3 then
			receptorNameFile = receptorArrayNames[3];
			rotationYReceptor = 0;
			xPosReceptor = 0;
		end;
			
		if i == 4 then
			receptorNameFile = receptorArrayNames[2];
			rotationYReceptor = 180;
			xPosReceptor = 26;
		end;

		if i == 5 then
			receptorNameFile = receptorArrayNames[1];
			rotationYReceptor = 180;
			xPosReceptor = 52;
		end;


	    af[#af+1] = Def.Sprite{
		    InitCommand=function(self)
		    		local STATE = GAMESTATE:GetPlayerState(player);
		    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",receptorNameFile);

		    		self:Load(nomArchivoFull);
		    		self:rotationy(rotationYReceptor);
		            self:pause(); -- Muestra solo el segundo frame (Frame 1)
		            self:zoomto(32, 32);
		            self:addy(yStartReceptor);
		            self:addx(xPosNoteFieldPrevBase+xPosReceptor);
		            self:queuecommand("CheckCambio");
		    end;

			CheckNoteSkinMessageCommand = function(self,params)
				if params.Player == player then
		    		local STATE = GAMESTATE:GetPlayerState(player);
		    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",receptorNameFile);
					self:Load(nomArchivoFull);
				end;
			end;	

			CodeModMessageCommand=function(self,params)
				if params.Player == player then
		    		local STATE = GAMESTATE:GetPlayerState(player);
		    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",receptorNameFile);
					self:Load(nomArchivoFull);
				end;
			end;

			CwNavigatePreviewMessageCommand=function(self,params)
				if params.Player == player then
		    		local STATE = GAMESTATE:GetPlayerState(player);
		    		local noteSkinSelected = params.Mod;
					local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",receptorNameFile);
					self:Load(nomArchivoFull);
				end;
			end;

		    --Aca hay que evaluar las opciones para aplicarlas al menu.
		    --si hay que mover las flechas o cosas
			CommandWindowSelectModMessageCommand=function(self,params)
				self:queuecommand("CheckCambio");
			end;

			--Comprobaciones de MODS para el preview
			CheckCambioCommand = function(self)
				local STATE = GAMESTATE:GetPlayerState(player);
				self:fadetop(0);
				self:fadebottom(0);
				self:diffusealpha(1);

				--FREEDOM
				local esFreedom = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Dark();							
				if esFreedom == 1 then
					self:diffusealpha(0);
				end;								



				local esNxMode = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NXMode();
				if esNxMode then
					--esto esta raro tengo que acostar las flechas y el receptor D:
					self:rotationx(60);
					self:x(posXBaseChart[i]-((i-1)*-1));
				else
					self:rotationx(0);
					self:x(posXBaseChart[i]);
				end;	

				local esDropMode = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Drop();
				if esDropMode then
					self:y(yStartReceptor+88);
				else
					self:y(yStartReceptor);
				end;			

				--Mini
				local esMini = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini();							
				if esMini > 0 then
					self:zoom(zoomOnMini);
					self:x(posXBaseChartMini[i]);
				else
					self:zoom(0.5);
					self:x(posXBaseChart[i]);
				end;	

			end;


		};

	end;


	-- new idea for printing chart preview.
	--first we create the notes and then we placethem.
	--we are recteating so we will use 6 rows maximum.
	local chartActor = Def.ActorFrame{

		OnCommand=function(self,params)
			self:queuecommand("CheckCambio");
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			self:queuecommand("CheckCambio");
		end;

		CheckCambioCommand = function(self)
			local STATE = GAMESTATE:GetPlayerState(player);
			self:diffusealpha(1);
			--we read the chart used.
			local isMirror = STATE:GetPlayerOptions('ModsLevel_Preferred'):Mirror();
			if isMirror then
				chartDisplayed = defaultMirrorShow;
			end;

			local isRandom = STATE:GetPlayerOptions('ModsLevel_Preferred'):SuperShuffle();
			if isRandom then
				chartDisplayed = defaultRandomShow;
			end;

			local isBackward = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards();
			if isBackward then
				chartDisplayed = defaultBackwardsShow;
			end;

			if isMirror == false and isRandom == false and isBackward == false then
				chartDisplayed = defaultChartShow;
			end;

			local isVanish = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish();
			local IsAppear = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear();
			local isNonstep = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Nonstep();
			local isFlash = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Flash();	
			local isXmode = STATE:GetPlayerOptions('ModsLevel_Preferred'):Xmode();
			local isNxMode = STATE:GetPlayerOptions('ModsLevel_Preferred'):NXMode();
			local isSIMode = STATE:GetPlayerOptions('ModsLevel_Preferred'):Drop();
			local isRIMode = STATE:GetPlayerOptions('ModsLevel_Preferred'):Rise();
			local isMini = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini();	
			
			if isMini > 0 then
				self:zoom(zoomOnMini+0.35);
				self:y(23);

			end;	
			if isMini == 0 then
				self:zoom(1);
				self:y(0);
			end;
			


			-- we read the chart and we display the chart.
			for i=1,5 do
				for x=1,5 do
					if chartDisplayed[i][x] == 1 then
						self:GetChild("arrow"..i.."-"..x):visible(true);
						self:GetChild("arrow"..i.."-"..x):diffusealpha(1);
						self:GetChild("arrow"..i.."-"..x):fadetop(0);
						self:GetChild("arrow"..i.."-"..x):fadebottom(0);

						if isVanish == 1 then
							if i < 3 then
								self:GetChild("arrow"..i.."-"..x):diffusealpha(0);
							end;
							if i == 3 then
								self:GetChild("arrow"..i.."-"..x):fadetop(1);
							end;
						end;

						if IsAppear == 1 then

							if i == 3 then
								self:GetChild("arrow"..i.."-"..x):fadebottom(0.7);
							end;

							if i > 3 then
								self:GetChild("arrow"..i.."-"..x):diffusealpha(0);
							end;
						end;

						if isNonstep == 1 then
							self:diffusealpha(0);
						end;	

						if isFlash == 1 then
							self:GetChild("arrow"..i.."-"..x):diffuseshift();
							self:GetChild("arrow"..i.."-"..x):effectcolor1(Color.White)
							self:GetChild("arrow"..i.."-"..x):effectcolor2(color("0,0,0,0"))
							self:GetChild("arrow"..i.."-"..x):effectperiod(1);
						else
							self:GetChild("arrow"..i.."-"..x):stopeffect();
						end;


						if isXmode > 0 then
							local newPos = 0;
							if player == PLAYER_1 then
								newPos = posXBaseChart[x]+((i-1)*14);
							else
								newPos = posXBaseChart[x]+((i-1)*-14);	
							end;
							self:GetChild("arrow"..i.."-"..x):x(newPos);
						end;			
						if isXmode == 0 then
							self:GetChild("arrow"..i.."-"..x):x(posXBaseChart[x]);
						end;

						if isNxMode then
							--esto esta raro tengo que acostar las flechas y el receptor D:
							self:GetChild("arrow"..i.."-"..x):rotationx(60);
						else
							self:GetChild("arrow"..i.."-"..x):rotationx(0);
						end;

						if isRIMode > 0 or isRIMode < 0 then

								if isRIMode > 0 then
									if i <= 5 then
										self:GetChild("arrow"..i.."-"..x):x( posXBaseChart[x]+((i-1)*-4) );
									end;
									self:GetChild("arrow"..i.."-"..x):zoom(0.5 - (i/60));
								elseif isRIMode < 0 then
									if i <= 5 then
										self:GetChild("arrow"..i.."-"..x):x( posXBaseChart[x]+((i-1)*4) );
									end;
									self:GetChild("arrow"..i.."-"..x):zoom(0.5 + (i/40));
								end;
						else
							self:GetChild("arrow"..i.."-"..x):zoom(0.5);
						end;




					else
						self:GetChild("arrow"..i.."-"..x):visible(false);
					end;
				end;
			end;



		end;



	};

	for i=1,6 do
		for x = 1,5 do

			local archivoNote="";
			local rotazionNote = 0;
			local addxNote = 0;	
			local distPerArrow = 22;		

			if x == 1 then
				archivoNote = "DownLeft Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[1];
			end;

			if x == 2 then
				archivoNote = "UpLeft Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[2];					
			end;

			if x == 3 then
				archivoNote = "Center Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[3];					
			end;	

			if x == 4 then
				archivoNote = "UpLeft Tap Note";
				rotazionNote = 180;
				addxNote = posXBaseChart[4];
			end;	

			if x == 5 then
				archivoNote = "DownLeft Tap Note";
				rotazionNote = 180;
				addxNote = posXBaseChart[5];
			end;

			chartActor[#chartActor+1] = Def.Sprite{
						Name="arrow"..i.."-"..x;
					    InitCommand=function(self)					    	
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);
					    		self:Load(nomArchivoFull);
					            self:zoomto(32, 32);
					            self:rotationy(rotazionNote);
					            self:addy(yStartChart+((i-1)*distPerArrow));
					            self:x(xPosNoteFieldPrevBase+addxNote);
					            self:visible(false);
					    end;

						CheckNoteSkinMessageCommand = function(self,params)
							if params.Player == player then
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);
								self:Load(nomArchivoFull);
							end;
						end;

						CwNavigatePreviewMessageCommand=function(self,params)
							if params.Player == player then
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = params.Mod;
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);
								self:Load(nomArchivoFull);
							end;
						end;

			};



			
		end;
	end;

	af[#af+1] = chartActor;




--[[

    --buscamos el chart por fila
	for i=1, #defaultChartShow do
		--buscamos la flechas por col
		for x=1,5 do
			local archivoNote="";
			local rotazionNote = 0;
			local addxNote = 0;	
			local distPerArrow = 22;		

			if x == 1 then
				archivoNote = "DownLeft Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[1];
			end;

			if x == 2 then
				archivoNote = "UpLeft Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[2];					
			end;

			if x == 3 then
				archivoNote = "Center Tap Note";
				rotazionNote = 0;
				addxNote = posXBaseChart[3];					
			end;	

			if x == 4 then
				archivoNote = "UpLeft Tap Note";
				rotazionNote = 180;
				addxNote = posXBaseChart[4];
			end;	

			if x == 5 then
				archivoNote = "DownLeft Tap Note";
				rotazionNote = 180;
				addxNote = posXBaseChart[5];
			end;

			if defaultChartShow[i][x] == 1 then

			     af[#af+1] = Def.Sprite{
					    InitCommand=function(self)
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);

					    		self:Load(nomArchivoFull);
					            --self:pause();
					            self:zoomto(32, 32);
					            self:rotationy(rotazionNote);
					            self:addy(yStartChart+((i-1)*distPerArrow));
					            self:x(xPosNoteFieldPrevBase+addxNote);

					            self:queuecommand("CheckCambio");
					    end;

						OnCommand=function(self,params)
							self:queuecommand("CheckCambio");
						end;

						CodeModMessageCommand=function(self,params)
							if params.Player == player then
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);
								self:Load(nomArchivoFull);
							end;
						end;

					    --Aca hay que evaluar las opciones para aplicarlas al menu.
					    --si hay que mover las flechas o cosas
						CommandWindowSelectModMessageCommand=function(self,params)
							self:queuecommand("CheckCambio");
						end;

						--Comprobaciones de MODS para el preview
						CheckCambioCommand = function(self)
							local STATE = GAMESTATE:GetPlayerState(player);
							self:fadetop(0);
							self:fadebottom(0);
							self:diffusealpha(1);

							--MIRROR
							local esMirror = STATE:GetPlayerOptions('ModsLevel_Preferred'):Mirror();
							if esMirror then
								if rotazionNote == 180 then
					            	self:rotationy(0);
					        	else
					        		self:rotationy(180);
					        	end;

					        	if i == 1 then					        		
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[5]);
					        	end;
					        	if i == 2 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[1]);
					        	end;
					        	if i == 3 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[3]);
					        	end;
					        	if i == 4 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[2]);
					        	end;
					        	if i == 5 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[4]);
					        	end;
					        	if i == 6 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[3]);
					        	end;
					        	if i == 7 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[5]);
					        	end;
					        	if i == 8 then
					        		self:x(xPosNoteFieldPrevBase+posXBaseChart[1]);
					        	end;	

							else
								self:rotationy(rotazionNote);
							end;

							--VANISH
							local esVanish = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish();							
							if esVanish == 1 then

								if i < 4 then
									self:diffusealpha(0);
								end;

								if i == 4 then
									self:fadetop(0.7);
								end;

								if i > 4 then
									self:diffusealpha(1);
								end;								
							end;

							--APPEAR
							local esAppear = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear();							
							if esAppear == 1 then

								if i == 4 then
									self:fadebottom(0.7);
								end;

								if i > 4 then
									self:diffusealpha(0);
								end;
							end;

							--NONSTEP
							local esNonstep = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Nonstep();							
							if esNonstep == 1 then
								self:diffusealpha(0);
							end;	

							--FLASH
							local esFlash = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Flash();							
							if esFlash == 1 then
								self:diffuseshift();
								self:effectcolor1(Color.White)
								self:effectcolor2(color("0,0,0,0"))
								self:effectperiod(1);
							end;	
							if esFlash == 0 then
								self:stopeffect();
							end;

	

							--La segunda tanda de mods para el preview.
							local esXmode = STATE:GetPlayerOptions('ModsLevel_Preferred'):Xmode();
							if esXmode > 0 then
								--modificamos como se ven las flechas :o
								self:x((xPosNoteFieldPrevBase+addxNote)-((i-1)*10));
							end;			
							if esXmode == 0 then
								self:x(xPosNoteFieldPrevBase+addxNote);
							end;	

							local esNxMode = STATE:GetPlayerOptions('ModsLevel_Preferred'):NXMode();
							if esNxMode then
								--esto esta raro tengo que acostar las flechas y el receptor D:
								self:rotationx(60);
							else
								self:rotationx(0);
							end;			

							local numSiMod = STATE:GetPlayerOptions('ModsLevel_Preferred'):Rise();
							if numSiMod < 0 then
									self:x((xPosNoteFieldPrevBase+addxNote)+((i-1)*1.5));
									self:zoom(0.5 + (i/50));
							end;

							local numSiMod = STATE:GetPlayerOptions('ModsLevel_Preferred'):Rise();
							if numSiMod > 0 then
									self:x((xPosNoteFieldPrevBase+addxNote)+((i-1)*0.5));
									self:zoom(0.5 - (i/50));
							end;							

							
							local esMini = STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini();							
							if esMini > 0 then
								self:zoom(zoomOnMini);
								self:x(posXBaseChartMini[x]);

							end;	
							if esMini == 0 then
								self:zoom(0.5);
								self:x(posXBaseChart[x]);
							end;
							

						end;

						CheckNoteSkinMessageCommand = function(self,params)
							if params.Player == player then
					    		local STATE = GAMESTATE:GetPlayerState(player);
					    		local noteSkinSelected = STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin();
								local nomArchivoFull = FindFileWithPattern("NoteSkins/pump/".. noteSkinSelected.."/",archivoNote);
								self:Load(nomArchivoFull);
							end;
						end;


				};
			    --yStartChart = yStartChart + 20;
			end;
		end;	

	end;

]]



	--Agregamos los items de información.
    af[#af+1] = Def.ActorFrame{ 	
		Def.Sprite{
				Name="heart_ui";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/heart 2x1"));
			    		self:pause();
			    		self:setstate(1);
			    		self:zoom(0.16);
			    		self:y(yInfoPanel-59);
			    		self:x(xInfoPanel-36);
			    		self:visible(false);
			    end;
		};


		LoadFont("_karnivore lite white").. {
			Name="timeFont_ui";
			InitCommand=cmd(y,yInfoPanel+63;horizalign,center;settext,"00:00";zoom,0.45);
			OnCommand=function(self)
			end;
		};

		--
	    Def.Sprite{
	    	Name="judgedata_ui";
		    InitCommand=function(self)
		    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/judg_b"));
		    		self:zoom(0.36);
		    		self:y(yInfoPanel-27);
		    		self:x(xInfoPanel);
		    		self:visible(false);
		    end;
		};	

	    Def.Sprite{
	    	Name="scoredata_ui";
		    InitCommand=function(self)
		    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/scoredata"));
		    		self:zoom(0.36);
		    		self:y(yInfoPanel+23.5);
		    		self:x(xInfoPanel);
		    		self:visible(false);
		    end;
		};	

	    Def.Sprite{
	    	Name="fastslow_ui";
		    InitCommand=function(self)
		    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/fastslowdata"));
		    		self:zoom(0.36);
		    		self:y(yInfoPanel+52);
		    		self:x(xInfoPanel);
		    		self:visible(false);
		    end;
		};

		Def.Sprite{
				Name="fastslow_text_ui";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/textfastslow"));
			    		self:zoom(0.24);
			    		self:y(yInfoPanel-14);
			    		self:visible(false);
			    		self:draworder(1);
			    end;
		};

		Def.Sprite{
				Name="timingbar_ui";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/info/preview_tbar"));
			    		self:zoom(0.2);
			    		self:y(yInfoPanel-21);
			    		self:visible(false);
			    		self:draworder(1);
			    end;
		};


		OnCommand=function(self)
			self:queuecommand("ProcInfo");
		end;

    	CommandWindowSelectModMessageCommand=function(self,params)
    		--[[
		    for key, value in pairs(params) do
		        print(key, value)
		    end    		
			]]
    		self:queuecommand("ProcInfo");
		end;

		ProcInfoCommand=function(self)
			local this = self:GetChildren();
			local STATE = GAMESTATE:GetPlayerState(player);
			if player == PLAYER_1 then
				-- playerAfix="infop1";	
				this.heart_ui:x((xInfoPanel*-1)+36);	
				this.fastslow_ui:x((xInfoPanel*-1));
				this.judgedata_ui:x((xInfoPanel*-1));
				this.scoredata_ui:x((xInfoPanel*-1));


			end;
			if player == PLAYER_2 then				
				-- playerAfix="infop2";
			end;

			local fastslowUi = getCustomOptionValuePlayer(player,"gameplay_fastslow");
			local breakIconUi = getCustomOptionValuePlayer(player,"gameplay_break_icon_ui");			
			local scoreUi = getCustomOptionValuePlayer(player,"gameplay_score_ui");
			local scoreUiPercentaje = getCustomOptionValuePlayer(player,"gameplay_score_percentaje_ui");
			local judgeDataUi = getCustomOptionValuePlayer(player,"gameplay_stats_ui");
			local songTimeUi = getCustomOptionValuePlayer(player,"gameplay_song_time_ui");
			local stepLvUi = getCustomOptionValuePlayer(player,"gameplay_lv_ui");
			local timingBarUi = getCustomOptionValuePlayer(player,"gameplay_timingbar");

			if fastslowUi ~= nil then
				if fastslowUi then
					this.fastslow_ui:visible(true);
					this.fastslow_text_ui:visible(true);
				else
					this.fastslow_ui:visible(false);
					this.fastslow_text_ui:visible(false);
				end;
			end;	

			if timingBarUi ~= nil then
				if timingBarUi then
					this.timingbar_ui:visible(true);
				else
					this.timingbar_ui:visible(false);
				end;
			end;	

			if breakIconUi ~= nil then
				if breakIconUi then
					this.heart_ui:visible(true);
				else
					this.heart_ui:visible(false);
				end;
			end;

			if songTimeUi ~= nil then
				if songTimeUi then
					this.timeFont_ui:visible(true);
				else
					this.timeFont_ui:visible(false);
				end;
			end;

			if judgeDataUi ~= nil then
				if judgeDataUi then
					this.judgedata_ui:visible(true);
				else
					this.judgedata_ui:visible(false);
				end;
			end;

			if scoreUi ~= nil or scoreUiPercentaje ~= nil then
				if scoreUi or scoreUiPercentaje then
					this.scoredata_ui:visible(true);
				else
					this.scoredata_ui:visible(false);
				end;
			end;

		end;
    };	


	--####JUDGMENT#### 
	af[#af+1] = Def.Quad {
	    InitCommand = function(self)
	    	self:addy(yPosPrevBase + 78);
	    	self:visible(false);
	    	self:addx(xPosNoteFieldPrevBase);
	    end,
	    OnCommand = function(self)
	        self:zoomto(275, 135) -- Escala el rectángulo a 270x130
	        self:diffuse(color("0,0,0,0.9"));
	        self:visible(false);
	    end;
		CommandWindowSelectOptionMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("RefreshCwData");
			end;
		end;

		CommandWindowModCancelMessageCommand=function(self,params)
			if params.Player == player then
				self:visible(false);
			end;
		end;
		RefreshCwDataCommand=function(self)
				self:sleep(0.1);
				local data = getEnvPlayer(player,"playercwmenu");	
				if data == "judgeskin" or data == "judgeskinzoom" then
					self:visible(true);
				end;
		end;
	};
	



	--Agregamos el preview del judgment
	af[#af+1] = Def.ActorFrame{ 

		Def.Sprite{
				Name="judg_text";
			    InitCommand=function(self)
			    		local skinActual = getSkinJudgmentPreview(player);

			    		self:Load(skinActual[1]);
			    		self:pause();
			    		self:setstate(1);
			    		self:zoom(0.26);
			    		self:y(3);
			    		--self:y(yInfoPanel-10);
			    		--self:x(xInfoPanel-110);
			    		self:visible(false);
			    end;
		};
		
		Def.Sprite{
				Name="judg_combo_text";
			    InitCommand=function(self)
			    		local skinActual = getSkinJudgmentPreview(player);
			    		self:Load(skinActual[2]);
			    		self:zoom(0.26);
			    		self:y(15);
			    		--self:x(xInfoPanel-110);
			    		self:visible(false);
			    end;
		};

		

		OnCommand=function(self)
			self:y(yInfoPanel-5);
			self:vertalign("VertAlign_Top");
			judgmentSpriteObject[player] = self;
			self:queuecommand("ProcCheck");
		end;

		ProcCheckCommand=function(self,params)

			local passedSkinNameParameter = "-";
			if params.judgskincw then
				passedSkinNameParameter = params.judgskincw;
			end;

			local this = self:GetChildren();

			local skinActual = "";
			if passedSkinNameParameter == "-" then
				skinActual = getSkinJudgmentPreview(player);
			else
				skinActual = getSkinJudgmentPreviewBySkinName(passedSkinNameParameter);
			end;

			local zoomPlayer = getCustomOptionValuePlayer(player,"judgmentZoom");
			if zoomPlayer  == nil then
				zoomPlayer = 100;
				local zoomPlayer = setCustomOptionValuePlayer(player,"judgmentZoom",100);				
			end;
			local zoomSetPlayer = getZoomSkinJudgCwPlayer(zoomPlayer,1);			

			this.judg_text:Load(skinActual[1]);
			this.judg_combo_text:Load(skinActual[2]);

			self:zoom(zoomSetPlayer);
			if zoomSetPlayer < 1 then

			end;

			this.judg_text:visible(true);
			this.judg_combo_text:visible(true);
		end;

		CommandWindowModCancelMessageCommand=function(self,params)
			if params.Player == player then
				local judgSkinPlayer = getCustomOptionValuePlayer(player,"judgmentSkin");
				self:playcommand("ProcCheck",{judgskincw = judgSkinPlayer});
			end;
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			self:queuecommand("ProcCheck");
		end;

		CheckSelectedMessageCommand=function(self,params)
			self:queuecommand("ProcCheck");
		end;
	};
	--####END JUDGMENT####

	--####LIFEBAR####
	--background para Lifebar
	af[#af+1] = Def.Quad {
	    InitCommand = function(self)
	    	self:addy(yPosPrevBase + 78);
	    	self:visible(false);
	    	self:addx(xPosNoteFieldPrevBase);
	    end,

	    OnCommand = function(self)
	        self:zoomto(275, 135) -- Escala el rectángulo a 270x130
	        self:diffuse(color("0,0,0,0.9"));
	        self:visible(false);
	    end;

		CommandWindowSelectOptionMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("RefreshCwData");
			end;
		end;

		CommandWindowModCancelMessageCommand=function(self,params)
			if params.Player == player then
				self:visible(false);
			end;
		end;

		RefreshCwDataCommand=function(self)
				self:sleep(0.1);
				local data = getEnvPlayer(player,"playercwmenu");
				if data == "lifebarskin" then
					self:visible(true);
				else
					self:visible(false);
				end;
		end;
	};


	--Agregamos el preview lifebar
	af[#af+1] = Def.ActorFrame{ 


			Def.Sprite{
				Name="backTextureLifebar";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-BACKBARONE"));
			    		self:pause();
			    		self:setstate(0);
			    		self:zoom(0.34);
			    		self:y(yStartLifeBar);
			    end;
			};

			Def.Sprite{
				Name="midTextureLifebar";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-GLOWBARONEP"));
			    		self:pause();
			    		self:setstate(2);
			    		self:zoom(0.34);
			    		self:y(yStartLifeBar);
			    end;
			};		
		
			Def.Sprite{
				Name="barTextureLifebar";
		    	InitCommand=function(self)
		    		self:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-REALBARONE"));
		    		self:pause();
		    		self:setstate(0);
		    		self:zoom(0.34);
		    		self:zoomy(0.26);
		    		self:y(yStartLifeBar);
		    		self:x(-2);
		    		self:cropleft(0.5);
		    	end;
			};

		InitCommand=function(self)
			lifebarSpriteObject[player] = self;
			self:queuecommand("ReloadLifebarSkin");
		end;

		CommandWindowSelectOptionMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("RefreshCwData");
			end;
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			if params.Player == player then
				--aca tenemos que saber 2 cosas, 1 esto es externom, si lo es, ocultamos todo, si no,
				--cargamos los sprites y mostramos la barra, si es una barra lua deberia cargar otro sprite
				--con la imagen preview.
				self:queuecommand("ReloadLifebarSkin");
			end;
		end;

		ReloadLifebarSkinCommand=function(self,params)


			local pasedSkinNameParameter = "-";
			if params.lifebarskincw then
				pasedSkinNameParameter = params.lifebarskincw;
			end;



			--aca tenemos que comprobar si es interno o externo para saber donde hacer el load?
			local lifeBarSkinPlayer = "";
			if pasedSkinNameParameter == "-" then
				lifeBarSkinPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");
			else
				lifeBarSkinPlayer = pasedSkinNameParameter;
			end;

			if lifeBarSkinPlayer == nil then
				lifeBarSkinPlayer = "i_default";
			end;
			local pathSkin = "";
			local lifebarSkinData = getLifebarSkinDataParsed(lifeBarSkinPlayer);		
			local this = self:GetChildren();

			if lifebarSkinData["isExternal"] then
				local lifebarSkinExternalPath = GetLifebarSkinExternalPath();
				pathSkin = lifebarSkinExternalPath..lifebarSkinData["name"].."/";	
				local existeSkinLua = FindFileWithPatternOnDirectory(pathSkin,"default.lua");

				local esSkinLua = false;
				if existeSkinLua ~= "-" then
					esSkinLua = true;
				end;

				if esSkinLua then
					this.backTextureLifebar:diffusealpha(1);
					this.midTextureLifebar:diffusealpha(0);
					this.barTextureLifebar:diffusealpha(0);
					--check if preview image exists, if not, we put the default one

					local previewImage = FindFileWithPatternOnDirectory(pathSkin,"preview.png");
					if previewImage ~= "-" then
						this.backTextureLifebar:Load(pathSkin.."preview.png");
						this.backTextureLifebar:pause();						
					else
						this.backTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/nopreview"));
						this.backTextureLifebar:pause();
					end;

				else
					this.backTextureLifebar:diffusealpha(1);
					this.midTextureLifebar:diffusealpha(1);
					this.barTextureLifebar:diffusealpha(1);

					--we need to check every image, if not, we put the default one.
					if FILEMAN:DoesFileExist(pathSkin.."SG-BACKBARONE 1x2.png") then
						this.backTextureLifebar:Load(pathSkin.."SG-BACKBARONE 1x2.png");
					else
						this.backTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-BACKBARONE"));
					end;
					this.backTextureLifebar:pause();
					this.backTextureLifebar:setstate(0);

					if FILEMAN:DoesFileExist(pathSkin.."SG-GLOWBARONEP 1x4.png") then
						this.midTextureLifebar:Load(pathSkin.."SG-GLOWBARONEP 1x4.png");
					else
						this.midTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-GLOWBARONEP"));
					end;					
					this.midTextureLifebar:pause();
					this.midTextureLifebar:setstate(2);	

					if FILEMAN:DoesFileExist(pathSkin.."SG-REALBARONE 1x3.png") then
						this.barTextureLifebar:Load(pathSkin.."SG-REALBARONE 1x3.png");
					else
						this.barTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/default/SG-REALBARONE"));
					end;					
					this.barTextureLifebar:pause();
					this.barTextureLifebar:setstate(0);	
				end;

			else
				local activeTheme = THEME:GetCurThemeName();
				pathSkin = "/Themes/"..activeTheme.."/Graphics/ScreenGamePlay_ui/lifebar/"..lifebarSkinData["name"].."/";	
				local existeSkinLua = FindFileWithPatternOnDirectory(pathSkin,"default.lua");

				local esSkinLua = false;
				if existeSkinLua ~= "-" then
					esSkinLua = true;
				end;

				if esSkinLua then
					this.midTextureLifebar:diffusealpha(0);
					this.barTextureLifebar:diffusealpha(0);
					--revisamos si existe la imagen preview.
					local previewImage = FindFileWithPatternOnDirectory(pathSkin,"preview.png");
					if previewImage ~= "-" then
						this.backTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/"..lifebarSkinData["name"].."/preview"));
						this.backTextureLifebar:pause();						
					else
						this.backTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/nopreview"));
						this.backTextureLifebar:pause();
					end;
				else
					this.midTextureLifebar:diffusealpha(1);
					this.barTextureLifebar:diffusealpha(1);

					this.backTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/"..lifebarSkinData["name"].."/SG-BACKBARONE"));
					this.backTextureLifebar:pause();
					this.backTextureLifebar:setstate(0);
					this.midTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/"..lifebarSkinData["name"].."/SG-GLOWBARONEP"));
					this.midTextureLifebar:pause();
					this.midTextureLifebar:setstate(2);				
					this.barTextureLifebar:Load(THEME:GetPathG("","ScreenGamePlay_ui/lifebar/"..lifebarSkinData["name"].."/SG-REALBARONE"));
					this.barTextureLifebar:pause();
					this.barTextureLifebar:setstate(0);	
				end;			
			end			 
		end;

		CommandWindowSelectOptionMessageCommand=function(self,params)
			if params.Player == player then
				self:queuecommand("RefreshCwData");
			end;
		end;

		CommandWindowModCancelMessageCommand=function(self,params)
			if params.Player == player then
				lifeBarSkinPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");
				self:playcommand("ReloadLifebarSkin",{lifebarskincw = lifeBarSkinPlayer});
				self:diffusealpha(1);
				self:zoom(1);
				self:y(0);
			end;
		end;

		RefreshCwDataCommand=function(self)
				self:sleep(0.05);
				local data = getEnvPlayer(player,"playercwmenu");
				if data == "judgeskin" or data == "judgeskinzoom" then
					self:diffusealpha(0.4);
				else 
					self:diffusealpha(1);

					if data == "lifebarskin" then
						self:zoom(1.8);
						self:y(3);
					else
						lifeBarSkinPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");
						self:playcommand("ReloadLifebarSkin",{lifebarskincw = lifeBarSkinPlayer});
						self:zoom(1);
						self:y(0);
					end;
					
				end;
		end;
	};
	
	--####END LIFEBAR####

	--#### timing preview
	af[#af+1] = Def.ActorFrame{ 


			Def.Sprite{
				Name="backgroundT";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","CommandWindow/timing/blackback"));
			    		self:zoom(0.55);
			    		self:y(118);
			    end;
			};

			Def.Sprite{
				Name="arrowtimingreceptor";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","CommandWindow/timing/receptor"));
			    		self:zoom(0.6);
			    		self:y(70);
			    end;
			};	

			Def.Sprite{
				Name="arrowtiming";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","CommandWindow/timing/arrex"));
			    		self:zoom(0.6);
			    		self:y(118);
			    end;
			};			

			Def.Sprite{
				Name="gametiming";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","CommandWindow/timing/RECTBASE"));
			    		self:zoom(0.55);
			    		self:y(118);
			    end;
			};

			Def.Sprite{
				Name="playertiming";
			    InitCommand=function(self)
			    		self:Load(THEME:GetPathG("","CommandWindow/timing/RECTPLAYER"));
			    		self:zoom(0.5);
			    		self:zoomx(0.55);
			    		self:y(116);
			    		self:x(67);
			    end;
			};

			InitCommand=function(self)
				self:diffusealpha(0);
				self:queuecommand("moveDataTiming");
			end;

			CommandWindowSelectModMessageCommand=function(self,params)
				if params.Player == player then
					self:queuecommand("moveDataTiming");
				end;
			end;

			moveDataTimingCommand=function(self)
				if GAMESTATE:IsSideJoined(player) == false then					
					return;
				end;
				local timingAdjCustomOption = getCustomOptionValuePlayer(player,"timing_adjustment");
				local timingPlayer = 0.0;

				timingPlayer = tonumber(timingAdjCustomOption) or 0.0;

				--we need to think about the movement, we can move the
				local basePixelMov = 0.5;
				local placeTiming = timingPlayer / 0.1;
				local finalPlace = basePixelMov * placeTiming;

				self:GetChild("playertiming"):y(116+(finalPlace));
				self:GetChild("arrowtiming"):y(118+(finalPlace));
			end;

			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					self:queuecommand("RefreshCwData");
				end;
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:diffusealpha(0);
					self:zoom(1);
					self:y(0);
				end;
			end;

			RefreshCwDataCommand=function(self)
					self:sleep(0.05);
					local data = getEnvPlayer(player,"playercwmenu");
					if data == "timingadj" then
						self:diffusealpha(1);
					else 
						self:diffusealpha(0);						
					end;
			end;

	};


	return af;

end;


--Crea la vista de comandos para un player especifico.
function CreateCommandForPlayer(player)

	local function GetCommandTitles()

		-- ** STRUCT **
		-- order = Imagen con el nombre de la opcion -> /Graphics/CommandWindow/[order]_title.png
		-- name = nombre de la opción
		-- index = ???
		-- imgfile = sprite con opciones-> Icons[] NxN

		-- ** Every option here needs to have the list of in the same index.
		-- ** For example: speed is the index 1, on the Mod array all the options needs to be on the index 1
		local array=
		{
			{order="01",name="speed",index=2,imgfile="Icons02 13x1"},
			{order="11",name="av",index=2,imgfile="Icons11 6x1"},
			{order="02",name="display",index=3,imgfile="Icons03 13x1"},
			{order="03",name="note skin",index=4,imgfile=nil},
			{order="04",name="path",index=5,imgfile="Icons05 8x1"},
			{order="05",name="alternate",index=6,imgfile="Icons06 3x1"},
			{order="06",name="judge",index=7,imgfile="Icons07 17x1"},
			{order="07",name="rush",index=7,imgfile="Icons07 17x1"},
			{order="12",name="sort",index=8,imgfile="Icons08 1x1"},
			{order="08",name="reset",index=0,imgfile=nil},
		};

		--############################--
		--		OPCIONES NUEVAS 	  --
		--############################--
		table.insert(array,{order="19",name="vsmode",index=15,imgfile="Icons20 2x1"});		
		table.insert(array,{order="14",name="info",index=10,imgfile="Icons09 11x1"});
		table.insert(array,{order="15",name="judgeskin",index=11,imgfile=nil});
		table.insert(array,{order="16",name="judgeskinzoom",index=12,imgfile="Icons16 6x1"});
		table.insert(array,{order="17",name="lifebarskin",index=13,imgfile=nil});
		table.insert(array,{order="18",name="lifebarsettings",index=14,imgfile="Icons19 4x1"});
		table.insert(array,{order="20",name="timingadj",index=16,imgfile="Icons21 6x1"});

		
		
		
		
		return array;
	end;

	local function GetModTitles()
		local array ={};
		local Titles = GetCommandTitles();
		--agregamos los mods de a uno, para que por ultimo se sienta un orden

		--##Struct##
		-- order => name
		-- command => command
		--stateindex => state of the sprite for this item
		--disablestate => the state in the sprite where the img shows a disable state of this item


		-- 1: SPEED
		table.insert(array,
			{	
				{order="1X", command="1x", },
				{order="2X", command="2x",},
				{order="3X", command="3x",},
				{order="4X", command="4x",},
				{order="5X", command="5x",},
				{order="6X", command="6x",},
				{order="+0.25", command="0.25",},	
				{order="+0.5", command="0.5",},	
				{order="EW", command="expand",},
				{order="RV", command="randomvel",},
				{order="AV", command="m550",},
				{order="AC", command="accel",},
				{order="DC", command="decel",}
			}
		);

		-- 2: AV
		table.insert(array,
			{	
				{order="100", command="av+100", stateindex=0},
				{order="10", command="av+10", stateindex=1},
				{order="1", command="av+1", stateindex=2},
				{order="-1", command="av-1", stateindex=3},
				{order="-10", command="av-10", stateindex=4},
				{order="-100", command="av-100", stateindex=5},
				{order="100", command="av+100", stateindex=0},
				{order="10", command="av+10", stateindex=1},
				{order="1", command="av+1", stateindex=2},
				{order="-1", command="av-1", stateindex=3},
				{order="-10", command="av-10", stateindex=4},
				{order="-100", command="av-100", stateindex=5}
			}
		);

		-- 3: DISPLAY
		table.insert(array,
			{	
				{order="V", command="vanish",},
				{order="AP", command="appear",},
				{order="NS", command="nonstep",},
				{order="FD", command="dark",},
				{order="FL", command="flash",},
				{order="RANDOM NOTE", command="randomnote",},
				{order="MI", command="mini" },
				{order="BGA OFF", command="bgaoff", stateindex=7, disablestate=8, },
				{order="BGA DARK", command="bgadark", stateindex=9, disablestate=10, },
				{order="BGA PARTIAL", command="bgapartial", stateindex=11, disablestate=12, },
			}
		);

		-- 4: NOTESKIN
		table.insert(array,{});

		local noteindex = 0;
		for ind=1,#Titles, 1 do
			if (Titles[ind].name == "note skin") then
				noteindex = ind;
			end;
		end;

		--Se agregan los NoteLabels a la opción noteskin
		for x=1,#notelist do
			local fixedName = string.upper(notelist[x]);
			fixedName = string.gsub(fixedName, "-", " ");
			fixedName = string.gsub(fixedName, "_", " ");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array[noteindex], {order=fixedName, command=notelist[x],});
		end;

		--Insert additional noteskin copies to fill missing spots
		while #array[noteindex] < minNumItemsCW do
			for x=1,#notelist do
				table.insert(array[noteindex], array[noteindex][x])
			end
		end


		-- 5: PATH
		table.insert(array,
			{	
				{order="X", command="xmode",},
				{order="NX", command="nxmode",},
				{order="UA", command="underattack",},
				{order="DR", command="drop",},
				{order="SI", command="sink",},
				{order="RI", command="rise",},
				{order="SN", command="snake",},	
				{order="ZZ", command="zigzag",},
			}
		);		

		-- 6: ALTERNATE
		table.insert(array,
			{	
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 },
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 },
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 }
			}
		);	


		-- 7: JUDGEMENT
		table.insert(array,
			{	
				{order="HJ", command="hardjudgement",stateindex=0, },
				{order="VJ", command="veryhardjudgement",stateindex=2,},
				{order="XJ", command="extrajudgement",stateindex=3,},
				{order="UJ", command="ultrahardjudgement",stateindex=4,},
				{order="JR", command="judgereverse",stateindex=1, },
				{order="HJ", command="hardjudgement",stateindex=0, },
				{order="VJ", command="veryhardjudgement",stateindex=2,},
				{order="XJ", command="extrajudgement",stateindex=3,},
				{order="UJ", command="ultrahardjudgement",stateindex=4,},
				{order="JR", command="judgereverse",stateindex=1, },
			}
		);
		-- 8: RUSH
		table.insert(array,
			{	
				{order="60", command="0.6", stateindex=5, disablestate=16, },
				{order="70", command="0.7", stateindex=6, disablestate=16, },
				{order="80", command="0.8", stateindex=7, disablestate=16, },
				{order="90", command="0.9", stateindex=8, disablestate=16, },
				{order="110", command="1.1", stateindex=9, disablestate=16, },
				{order="120", command="1.2", stateindex=10, disablestate=16, },
				{order="130", command="1.3", stateindex=11, disablestate=16, },
				{order="140", command="1.4", stateindex=12, disablestate=16, },
				{order="150", command="1.5", stateindex=13, disablestate=16, },
				{order="160", command="1.6", stateindex=14, disablestate=16, },
				{order="170", command="1.7", stateindex=15, disablestate=16, },
			}
		);
		
		-- 9: SORT (ORDEN DE WHEEL)
		table.insert(array,
			{	
				{order="TITLE", command="title",},
			}
		);	
		-- 10: RESET
		table.insert(array,{});

		--[[
		-- 11: RANK
		table.insert(array,
			{	
				{order="RANK", command="rank",stateindex=0}
			}
		);	
		]]

		--12
		-- vs mode
		table.insert(array,
			{
				{order="VSMODE", command="vsmode", stateindex=0,disablestate=1},
			}
		);		

		-- 13: INFO
		table.insert(array,
			{	
				{order="TIMING", command="timingui",stateindex=0},
				{order="TIMINGBAR", command="timingbar",stateindex=10},
				{order="BREAKICON", command="breakiconui",stateindex=1},
				{order="SCORE", command="scoreui",stateindex=2},
				{order="SCOREPERCENTAJE", command="scorepercentajeui",stateindex=9},
				{order="JUDGEDATA", command="judgedataui",stateindex=3},
				{order="MUSICDURATION", command="musicdurationui",stateindex=4},
				{order="STEPLV", command="steplvui",stateindex=5},
				--{order="RANKDATA", command="rankdataui",stateindex=6},
				{order="ALL", command="allui",stateindex=7},
				{order="NONE", command="noneui",stateindex=8}
			}
		);

		-- 14: judg skins
		table.insert(array,{});

		local judgeindex = 0;
		for ind=1,#Titles, 1 do
			if (Titles[ind].name == "judgeskin") then
				judgeindex = ind;
			end;
		end;

		--Agregamos la lista de skins disponibles a las opciones
		--we need to fix the skin list with the same thing.

		for x=1,#judgeSkinList do
			local fixedName = string.upper(judgeSkinList[x]);
			fixedName = string.gsub(fixedName, "i_", "");
			fixedName = string.gsub(fixedName, "e_", "");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array[judgeindex], {order=fixedName, command=judgeSkinList[x],});
		end;	



		--Insert additional judgeskin copies to fill missing spots
		-- we update the base list to reflect those copies, the CW have a miss match of data :o
		if #judgeSkinList > 0 then
			while #array[judgeindex] < minNumItemsCW do
				for x=1,#judgeSkinList do
					table.insert(array[judgeindex], array[judgeindex][x])
				end
			end
		end

		-- 15: judg zoom
		table.insert(array,
			{
				{order="25", command="zoomjdg+25", stateindex=0},
				{order="10", command="zoomjdg+10", stateindex=1},
				{order="1", command="zoomjdg+1", stateindex=2},
				{order="-1", command="zoomjdg-1", stateindex=3},
				{order="-10", command="zoomjdg-10", stateindex=4},
				{order="-25", command="zoomjdg-25", stateindex=5},
				{order="25", command="zoomjdg+25", stateindex=0},
				{order="10", command="zoomjdg+10", stateindex=1},
				{order="1", command="zoomjdg+1", stateindex=2},
				{order="-1", command="zoomjdg-1", stateindex=3},
				{order="-10", command="zoomjdg-10", stateindex=4},
				{order="-25", command="zoomjdg-25", stateindex=5}
			}
		);	

		-- 16: lifebar skins
		table.insert(array,{});

		local lifebarindex = 0;
		for ind=1,#Titles, 1 do
			if (Titles[ind].name == "lifebarskin") then
				lifebarindex = ind;
			end;
		end;

		--Agregamos la lista de skins disponibles a las opciones
		for x=1,#lifebarSkinList do
			local fixedName = string.upper(lifebarSkinList[x]);
			fixedName = string.gsub(fixedName, "i_", "");
			fixedName = string.gsub(fixedName, "e_", "");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array[lifebarindex], {order=fixedName, command=lifebarSkinList[x],});
		end;			

		--Insert additional lifebarskin copies to fill missing spots
		if #lifebarSkinList > 0 then
			while #array[lifebarindex] < minNumItemsCW do
				for x=1,#lifebarSkinList do
					table.insert(array[lifebarindex], array[lifebarindex][x])
				end
			end
		end


		-- 17: judg zoom
		table.insert(array,
			{
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0}
				--[[
				{order="SUDDEND", command="suddendeath", stateindex=1}, -- 1 miss break
				{order="5MISSMAX", command="5missmax", stateindex=2}, -- max 5 miss, 6 miss = break
				{order="PFCMODE", command="pfcmode", stateindex=3}, -- only Perfect, any other TNS is break.
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},--repeat to fill the list xD
				{order="SUDDEND", command="suddendeath", stateindex=1},
				{order="5MISSMAX", command="5missmax", stateindex=2},
				{order="PFCMODE", command="pfcmode", stateindex=3},	
				]]			
			}
		);	
	
		-- 18: timing adj
		table.insert(array,
			{
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},

				--{order="005", command="timing+005", stateindex=4},
				--{order="001", command="timing+001", stateindex=5},				
				--{order="-001", command="timing-001", stateindex=0},
				--{order="-005", command="timing-005", stateindex=1},
				--{order="-01", command="timing-01", stateindex=2},

			}
		);	

		local STATE = GAMESTATE:GetPlayerState(player);
		if STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() ~= nil then
			PAVenabled[player] = true;
		else
			PAVenabled[player] = false;
		end;
	
		return array;

	end;


	local function GetModTitlesByName()
		local array ={};
		--##Struct##
		-- order => name
		-- command => command
		--stateindex => state of the sprite for this item
		--disablestate => the state in the sprite where the img shows a disable state of this item


		-- 1: SPEED
		array["speed"] = {	
				{order="1X", command="1x", },
				{order="2X", command="2x",},
				{order="3X", command="3x",},
				{order="4X", command="4x",},
				{order="5X", command="5x",},
				{order="6X", command="6x",},
				{order="+0.25", command="0.25",},	
				{order="+0.5", command="0.5",},	
				{order="EW", command="expand",},
				{order="RV", command="randomvel",},
				{order="AV", command="m550",},
				{order="AC", command="accel",},
				{order="DC", command="decel",}
		};

		-- 2: AV
		array["av"] = {
				{order="100", command="av+100", stateindex=0},
				{order="10", command="av+10", stateindex=1},
				{order="1", command="av+1", stateindex=2},
				{order="-1", command="av-1", stateindex=3},
				{order="-10", command="av-10", stateindex=4},
				{order="-100", command="av-100", stateindex=5},
				{order="100", command="av+100", stateindex=0},
				{order="10", command="av+10", stateindex=1},
				{order="1", command="av+1", stateindex=2},
				{order="-1", command="av-1", stateindex=3},
				{order="-10", command="av-10", stateindex=4},
				{order="-100", command="av-100", stateindex=5}
		};

		-- 3: DISPLAY
		array["display"] = {	
				{order="V", command="vanish",},
				{order="AP", command="appear",},
				{order="NS", command="nonstep",},
				{order="FD", command="dark",},
				{order="FL", command="flash",},
				{order="RANDOM NOTE", command="randomnote",},
				{order="MI", command="mini" },
				{order="BGA OFF", command="bgaoff", stateindex=7, disablestate=8, },
				{order="BGA DARK", command="bgadark", stateindex=9, disablestate=10, },
				{order="BGA PARTIAL", command="bgapartial", stateindex=11, disablestate=12, },
		};

		-- 4: NOTESKIN
		array["note skin"] = {};

		for x=1,#notelist do
			local fixedName = string.upper(notelist[x]);
			fixedName = string.gsub(fixedName, "-", " ");
			fixedName = string.gsub(fixedName, "_", " ");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array["note skin"], {order=fixedName, command=notelist[x],});
		end;

		--Insert additional noteskin copies to fill missing spots
		while #array["note skin"] < minNumItemsCW do
			for x=1,#notelist do
				table.insert(array["note skin"], array["note skin"][x])
			end
		end

		-- 5: PATH
		array["path"] = {	
				{order="X", command="xmode",},
				{order="NX", command="nxmode",},
				{order="UA", command="underattack",},
				{order="DR", command="drop",},
				{order="SI", command="sink",},
				{order="RI", command="rise",},
				{order="SN", command="snake",},	
				{order="ZZ", command="zigzag",},
		};

		-- 6: ALTERNATE
		array["alternate"] = {
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 },
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 },
				{order="M", command="backwards", stateindex=0 },
				{order="RS", command="supershuffle", stateindex=1 },
				{order="SS", command="mirror", stateindex=2 }
			};

		-- 7: JUDGEMENT
		array["judge"] = {
				{order="HJ", command="hardjudgement",stateindex=0, },
				{order="VJ", command="veryhardjudgement",stateindex=2,},
				{order="XJ", command="extrajudgement",stateindex=3,},
				{order="UJ", command="ultrahardjudgement",stateindex=4,},
				{order="JR", command="judgereverse",stateindex=1, },
				{order="HJ", command="hardjudgement",stateindex=0, },
				{order="VJ", command="veryhardjudgement",stateindex=2,},
				{order="XJ", command="extrajudgement",stateindex=3,},
				{order="UJ", command="ultrahardjudgement",stateindex=4,},
				{order="JR", command="judgereverse",stateindex=1, },
			};

		-- 8: RUSH
		array["rush"] = {
				{order="60", command="0.6", stateindex=5, disablestate=16, },
				{order="70", command="0.7", stateindex=6, disablestate=16, },
				{order="80", command="0.8", stateindex=7, disablestate=16, },
				{order="90", command="0.9", stateindex=8, disablestate=16, },
				{order="110", command="1.1", stateindex=9, disablestate=16, },
				{order="120", command="1.2", stateindex=10, disablestate=16, },
				{order="130", command="1.3", stateindex=11, disablestate=16, },
				{order="140", command="1.4", stateindex=12, disablestate=16, },
				{order="150", command="1.5", stateindex=13, disablestate=16, },
				{order="160", command="1.6", stateindex=14, disablestate=16, },
				{order="170", command="1.7", stateindex=15, disablestate=16, },
		};

		--SORT (ORDEN DE WHEEL)
		array["sort"] = {
			{order="TITLE", command="title",},
		};		
		--RESET
		array["reset"] = {};

		--RANK
		array["rank"] = {
			{order="RANK", command="rank",stateindex=0}
		};

		--vs mode
		array["vsmode"] = {
			{order="VSMODE", command="vsmode", stateindex=0,disablestate=1},
		};

		--INFO
		array["info"] = {
			{order="TIMING", command="timingui",stateindex=0},
			{order="TIMINGBAR", command="timingbar",stateindex=10},
			{order="BREAKICON", command="breakiconui",stateindex=1},
			{order="SCORE", command="scoreui",stateindex=2},
			{order="SCOREPERCENTAJE", command="scorepercentajeui",stateindex=9},
			{order="JUDGEDATA", command="judgedataui",stateindex=3},
			{order="MUSICDURATION", command="musicdurationui",stateindex=4},
			{order="STEPLV", command="steplvui",stateindex=5},
			--{order="RANKDATA", command="rankdataui",stateindex=6},
			{order="ALL", command="allui",stateindex=7},
			{order="NONE", command="noneui",stateindex=8}
		};

		-- 14: judg skins
		array["judgeskin"] = {};
		for x=1,#judgeSkinList do
			local fixedName = string.upper(judgeSkinList[x]);
			fixedName = string.gsub(fixedName, "i_", "");
			fixedName = string.gsub(fixedName, "e_", "");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array["judgeskin"], {order=fixedName, command=judgeSkinList[x],});
		end;	

		--Insert additional judgeskin copies to fill missing spots
		-- we update the base list to reflect those copies, the CW have a miss match of data :o
		if #judgeSkinList > 0 then
			while #array["judgeskin"] < minNumItemsCW do
				for x=1,#judgeSkinList do
					table.insert(array["judgeskin"], array["judgeskin"][x])
				end
			end
		end

		-- 15: judg zoom
		array["judgeskinzoom"] = {
				{order="25", command="zoomjdg+25", stateindex=0},
				{order="10", command="zoomjdg+10", stateindex=1},
				{order="1", command="zoomjdg+1", stateindex=2},
				{order="-1", command="zoomjdg-1", stateindex=3},
				{order="-10", command="zoomjdg-10", stateindex=4},
				{order="-25", command="zoomjdg-25", stateindex=5},
				{order="25", command="zoomjdg+25", stateindex=0},
				{order="10", command="zoomjdg+10", stateindex=1},
				{order="1", command="zoomjdg+1", stateindex=2},
				{order="-1", command="zoomjdg-1", stateindex=3},
				{order="-10", command="zoomjdg-10", stateindex=4},
				{order="-25", command="zoomjdg-25", stateindex=5}
		};

		--Lifebar skins
		array["lifebarskin"] = {};
		--Agregamos la lista de skins disponibles a las opciones
		for x=1,#lifebarSkinList do
			local fixedName = string.upper(lifebarSkinList[x]);
			fixedName = string.gsub(fixedName, "i_", "");
			fixedName = string.gsub(fixedName, "e_", "");
			if (string.len(fixedName) > 15) then
				fixedName = string.sub(fixedName, 1, 15) .. "...";
			end;

			table.insert(array["lifebarskin"], {order=fixedName, command=lifebarSkinList[x],});
		end;			

		--Insert additional lifebarskin copies to fill missing spots
		if #lifebarSkinList > 0 then
			while #array["lifebarskin"] < minNumItemsCW do
				for x=1,#lifebarSkinList do
					table.insert(array["lifebarskin"], array["lifebarskin"][x])
				end
			end
		end

		--Judg zoom
		array["lifebarsettings"] = {
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0},
				{order="BREAKONLIFEBAR", command="breakonlifebarc", stateindex=0}
		};

		-- 18: timing adj
		array["timingadj"] = {
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},
				{order="01", command="timing+01", stateindex=3},
				{order="-01", command="timing-01", stateindex=2},
		};

		local STATE = GAMESTATE:GetPlayerState(player);
		if STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() ~= nil then
			PAVenabled[player] = true;
		else
			PAVenabled[player] = false;
		end;
	
		return array;

	end;
	

	local function IsSelected(mod,player)
		local STATE = GAMESTATE:GetPlayerState(player);
		if mod == nil then
			return false;
		end;
		
		if mod.command == "" then
			return false;
		end;
		
		if mod.command == "title" and GAMESTATE:GetSortTitle() then
			return true;
		end;


		--Agregar comprobaciones de nuevas opciones acá.
		--como no tengo acceso a guardar opciones, que sean variables de entorno
		--Esto mismo esta en ScreenSelectMusicModIcons.lua
		-- local playerAfixInfo="";
		-- if player == PLAYER_1 then
			-- playerAfixInfo="infop1";			
		-- end;

		-- if player == PLAYER_2 then				
			-- playerAfixInfo="infop2";
		-- end;


		--UI
		if mod.command == "timingui" then
			local fastslowUi = getCustomOptionValuePlayer(player,"gameplay_fastslow");
			
			if fastslowUi == nil then
				return false;
			else
				return fastslowUi;
			end;
		end;

		if mod.command == "timingbar" then
			local timingBar = getCustomOptionValuePlayer(player,"gameplay_timingbar");
			if timingBar == nil then
				return false;
			else
				return timingBar;
			end;			
		end;

		if mod.command == "breakiconui" then
			local breakIconUi = getCustomOptionValuePlayer(player,"gameplay_break_icon_ui");
			if breakIconUi == nil then
				return false;
			else
				return breakIconUi;
			end;			
		end;

		if mod.command == "scoreui" then
			local scoreUi = getCustomOptionValuePlayer(player,"gameplay_score_ui");
			if scoreUi == nil then
				return false;
			else
				return scoreUi;
			end;
		end;

		if mod.command == "scorepercentajeui" then
			local scorePercentajeUi = getCustomOptionValuePlayer(player,"gameplay_score_percentaje_ui");
			if scorePercentajeUi == nil then
				return false;
			else
				return scorePercentajeUi;
			end;
		end;		

		if mod.command == "judgedataui" then
			local judgeDataUi = getCustomOptionValuePlayer(player,"gameplay_stats_ui");
			
			if judgeDataUi == nil then
				return false;
			else
				return judgeDataUi;
			end;
		end;

		if mod.command == "musicdurationui" then
			local songTimeUi = getCustomOptionValuePlayer(player,"gameplay_song_time_ui");
			if songTimeUi == nil then
				return false;
			else
				return songTimeUi;
			end;
		end;		

		if mod.command == "steplvui" then
				local stepLvUi = getCustomOptionValuePlayer(player,"gameplay_lv_ui");
				if stepLvUi == nil then
					return false;
				else
					return stepLvUi;
				end;
		end;	

		if mod.command == "allui" or mod.command == "noneui"  then
				return true;
		end;			

		if string.find(mod.command, "zoomjdg") then
		    return true;
		end

		if string.find(mod.command, "timing") then
		    return true;
		end
		
		
		--LIFEBAR SETTINGS
		if mod.command == "breakonlifebarc" then
			--1 INMEDIATE
			--4 OFF
			local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();
			if failSetting == "FailType_Immediate" then
				return true;
			else
				return false;
			end;
		end;

		if mod.command == "suddendeath" then
			local lifebarExtramode = getCustomOptionValuePlayer(player,"lifebar_extra_mode");
			if lifebarExtramode == nil then 
				return false; 
			end;

			if lifebarExtramode == "none" then
				return false;
			end;

			if lifebarExtramode == "suddendeath" then 
				return true;
			end;
		end;	

		if mod.command == "5missmax" then
			local lifebarExtramode = getCustomOptionValuePlayer(player,"lifebar_extra_mode");
			if lifebarExtramode == nil then 
				return false; 
			end;

			if lifebarExtramode == "none" then
				return false;
			end;

			if lifebarExtramode == "5missmax" then 
				return true;
			end;
		end;

		if mod.command == "pfcmode" then
			local lifebarExtramode = getCustomOptionValuePlayer(player,"lifebar_extra_mode");
			if lifebarExtramode == nil then 
				return false; 
			end;

			if lifebarExtramode == "none" then
				return false;
			end;

			if lifebarExtramode == "pfcmode" then 
				return true;
			end;
		end;


		--[[
		if mod.command == "infobasic" then
			-- if GAMESTATE:Env()[playerAfixInfo] == 1 then
			if STATE:GetPlayerOptions('ModsLevel_Preferred' ):StageInfoOption() == 1 then
				return true;
			end;
		end;

		if mod.command == "infofull" then
			-- if GAMESTATE:Env()[playerAfixInfo] == 2 then
			if STATE:GetPlayerOptions('ModsLevel_Preferred' ):StageInfoOption() == 2 then
				return true;
			end;
		end;

		if mod.command == "infoextra" then
			-- if GAMESTATE:Env()[playerAfixInfo] == 3 then
			if STATE:GetPlayerOptions('ModsLevel_Preferred' ):StageInfoOption() == 3 then
				return true;
			end;
		end;	
		]]	

		if mod.command == "vsmode" then
			if checkVsMode() then
				return true;
			end;
		end;

		--fin nuevas comprobaciones.

		--if mod.command == "title" and sortMode ~= 0 then
		--	return true;
		if mod.command == "rank" and GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
			return true;
		elseif mod.command == "bgaoff" and GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff() then
			return true;
		elseif mod.command == "bgadark" and GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark() then
			return true;
		elseif mod.command == "bgapartial" and GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial() then
			return true;
		elseif string.lower(mod.command)==string.lower(round2(GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred'):MusicRate(),1)) then
			return true;
		elseif mod.command:sub(1, 2) == "av" then
			return true;
		end;

		if mod.command == "note skin" and GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin() then
			return true;
		end;

		if mod.command == "rise" and GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Rise() > 0.0 then
			return true;
		end;
		
		if mod.command == "sink" and GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Rise() < 0.0 then
			return true;
		end;

		if mod.command == "mini" and GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Mini() > 0.0 then
			return true;
		end;
		
		local noX = string.gsub(GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod(),"x","");
		
		if tonumber(noX) % 1 == .25 then
			if mod.command == "0.25" then
				return true;
			end;	
			
			noX = math.floor(tonumber(noX));
			if tostring(noX).."x" == mod.command then
				return true;
			end;
		elseif tonumber(noX) % 1 == .5 then 	--es decimal
			if mod.command == "0.5" then
				return true;
			end;
			
			noX = math.floor(tonumber(noX));
			if tostring(noX).."x" == mod.command then
				return true;
			end;
		elseif tonumber(noX) % 1 == .75 then 	--es decimal
			if mod.command == "0.25" then
				return true;
			end;
			
			if mod.command == "0.5" then
				return true;
			end;
			
			noX = math.floor(tonumber(noX));
			if tostring(noX).."x" == mod.command then
				return true;
			end;
		end;
		
		local mods = GAMESTATE:GetPlayerState(player):GetPlayerOptionsArray( 'ModsLevel_Preferred' );
		
		if (GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):RandomVel() or GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Expand() == 1) and ( mod.command == "2x" or GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):MMod() ) then
			return false;
		end;
		
		for i=1,#mods,1 do
			if string.lower(mods[i]) == string.lower(mod.command) then
				return true;
			end;
		end;
		
		return false;
	end;


	--00--
	local Titles = GetCommandTitles();
	local Mods = GetModTitles();
	local ModsAc = GetModTitlesByName();
	local seted={};

	local function ApplyAV(Splayer, Savcommand)

		local STATE = GAMESTATE:GetPlayerState(Splayer);
	
		
		local avchange = tonumber(Savcommand:sub(4));
		if Savcommand:sub(3, 3) == "-" then
			avchange = -avchange
		end
		PAVenabled[Splayer] = true;
		if (Savcommand == "av+0") then 
			if (STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() == GAMESTATE:GetSavedAV(Splayer)) then return; end;
			STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod(GAMESTATE:GetSavedAV(Splayer));
		end;
		local newMMod = (STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() or 300) + avchange;
		
		if newMMod < 300 then
			newMMod = 300;
		elseif newMMod > 999 then
			newMMod = 999;
		end;
		STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod(newMMod);
		STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
		STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
		STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(0);
		STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(0);
		MESSAGEMAN:Broadcast("CommandWindowAV", {Player = Splayer} );
		
	end;

	local function ApplyMods(Scommand,Smod,Splayer)

		local STATE = GAMESTATE:GetPlayerState(Splayer);	
			
		for c=1,#Mods, 1 do 
			seted[c]={};
			for m=1,#Mods[c], 1 do
				seted[c][m] = IsSelected(Mods[c][m],Splayer);
			end;
		end;

		--NEW MODS--
			--agregar acá los nuevos if y sus acciones a los nuevos mods.
			--Recordar agregar los datos nuevos a:		
			-- function GetCommandTitles()
			-- function GetModTitles()
			-- function IsSelected()

		--MENU DE INFO PARA GAMEPLAY.
		if Titles[Scommand].name == "info" then	
			if Mods[Scommand][Smod].command == "timingui" then	
				local fastslowUi = getCustomOptionValuePlayer(Splayer,"gameplay_fastslow");

				if fastslowUi == nil then
					seted[Scommand][Smod] = false;
				else
					if fastslowUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_fastslow",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_fastslow",true);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "timingbar" then	
				local timingBar = getCustomOptionValuePlayer(Splayer,"gameplay_timingbar");
				if timingBar == nil then
					seted[Scommand][Smod] = false;
				else
					if timingBar then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_timingbar",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_timingbar",true);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "breakiconui" then	
				local breakIconUi = getCustomOptionValuePlayer(Splayer,"gameplay_break_icon_ui");
				if breakIconUi == nil then
					seted[Scommand][Smod] = false;
				else
					if breakIconUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_break_icon_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_break_icon_ui",true);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "scoreui" then	
				local scoreUi = getCustomOptionValuePlayer(Splayer,"gameplay_score_ui");
				--[[
				local offsetPlayer = GAMESTATE:GetPlayerState(Splayer):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming();
				offsetPlayer = offsetPlayer + 1;
				GAMESTATE:GetPlayerState(Splayer):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming(0.5);
				]]
				if scoreUi == nil then
					seted[Scommand][Smod] = false;
				else
					if scoreUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_score_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_score_ui",true);
						setCustomOptionValuePlayer(Splayer,"gameplay_score_percentaje_ui",false);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "scorepercentajeui" then	
				local scorePercentajeUi = getCustomOptionValuePlayer(Splayer,"gameplay_score_percentaje_ui");
				--[[
				local offsetPlayer = GAMESTATE:GetPlayerState(Splayer):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming();
				offsetPlayer = offsetPlayer - 1;
				GAMESTATE:GetPlayerState(Splayer):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming(-0.5);
				]]
				
				if scorePercentajeUi == nil then
					seted[Scommand][Smod] = false;
				else
					if scorePercentajeUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_score_percentaje_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_score_percentaje_ui",true);
						setCustomOptionValuePlayer(Splayer,"gameplay_score_ui",false);

					end;
				end;
			end;


			if Mods[Scommand][Smod].command == "judgedataui" then	
				local judgeDataUi = getCustomOptionValuePlayer(Splayer,"gameplay_stats_ui");
				if judgeDataUi == nil then
					seted[Scommand][Smod] = false;
				else
					if judgeDataUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_stats_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_stats_ui",true);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "musicdurationui" then	
				local songTimeUi = getCustomOptionValuePlayer(Splayer,"gameplay_song_time_ui");
				if songTimeUi == nil then
					seted[Scommand][Smod] = false;
				else
					if songTimeUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_song_time_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_song_time_ui",true);
					end;
				end;
			end;

			if Mods[Scommand][Smod].command == "steplvui" then	
				local stepLvUi = getCustomOptionValuePlayer(Splayer,"gameplay_lv_ui");
				if stepLvUi == nil then
					seted[Scommand][Smod] = false;
				else
					if stepLvUi then
						seted[Scommand][Smod] = false;
						setCustomOptionValuePlayer(Splayer,"gameplay_lv_ui",false);
					else
						seted[Scommand][Smod] = true;
						setCustomOptionValuePlayer(Splayer,"gameplay_lv_ui",true);
					end;
				end;
			end;			

			if Mods[Scommand][Smod].command == "allui" then
				seted[Scommand][Smod] = false;
				setCustomOptionValuePlayer(Splayer,"gameplay_fastslow",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_break_icon_ui",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_score_ui",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_stats_ui",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_song_time_ui",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_lv_ui",true);
				setCustomOptionValuePlayer(Splayer,"gameplay_timingbar",true);
			end;	

			if Mods[Scommand][Smod].command == "noneui" then
				seted[Scommand][Smod] = false;
				setCustomOptionValuePlayer(Splayer,"gameplay_fastslow",false);
				setCustomOptionValuePlayer(Splayer,"gameplay_break_icon_ui",false);
				setCustomOptionValuePlayer(Splayer,"gameplay_score_ui",false);
				setCustomOptionValuePlayer(Splayer,"gameplay_stats_ui",false);
				setCustomOptionValuePlayer(Splayer,"gameplay_song_time_ui",false);
				setCustomOptionValuePlayer(Splayer,"gameplay_lv_ui",false);	
				setCustomOptionValuePlayer(Splayer,"gameplay_timingbar",false);			

			end;				

		end;


		if Titles[Scommand].name == "judgeskin" then			
			--ocuparemos siempre "sanity" como defecto.			
			local judgSkinActiva = getCustomOptionValuePlayer(Splayer,"judgmentSkin");
			
			--si ya lo tiene seleccionado entonces lo sacamos.
			if Mods[Scommand][Smod].command == judgSkinActiva then
				seted[Scommand][Smod] = false;	
				setCustomOptionValuePlayer(Splayer,"judgmentSkin","sanity");		
			else
				seted[Scommand][Smod] = true;
				local judgeSkinSelected = Mods[Scommand][Smod].command;			
				setCustomOptionValuePlayer(Splayer,"judgmentSkin",judgeSkinSelected);		
			end;
		end;	

		if Titles[Scommand].name == "lifebarskin" then			
			--ocuparemos siempre "default" como defecto.			
			local lifebarActiva = getCustomOptionValuePlayer(Splayer,"lifebarSkin");
			
			--si no viene con e_ o i_ (de externo o interno), colocamos por defecto.

			local esExterno = string.find(lifebarActiva, "e_");
			if esExterno ~= nil then
				esExterno = true;
			else
				esExterno = false;
			end;			

			local esInterno = string.find(lifebarActiva, "i_");
			if esInterno ~= nil then
				esInterno = true;
			else
				esInterno = false;
			end;

			if esExterno == false and esInterno == false then
				seted[Scommand][Smod] = false;	
				setCustomOptionValuePlayer(Splayer,"lifebarSkin","i_default");	
			end;

			--si ya lo tiene seleccionado entonces lo sacamos.
			if Mods[Scommand][Smod].command == lifebarActiva then
				seted[Scommand][Smod] = false;	
				setCustomOptionValuePlayer(Splayer,"lifebarSkin","i_default");			
			else
				seted[Scommand][Smod] = true;
				local LifebarSkinselected = Mods[Scommand][Smod].command;
				setCustomOptionValuePlayer(Splayer,"lifebarSkin",LifebarSkinselected);				
			end;
		end;				

		if Titles[Scommand].name == "judgeskinzoom" then			
			--ocuparemos siempre 1 como defecto.			
			local judgZoomActiva = getCustomOptionValuePlayer(Splayer,"judgmentZoom");
						
			if judgZoomActiva == nil or judgZoomActiva > 100 or judgZoomActiva < 0 then
				judgZoomActiva = 100;
			end;			

			if Mods[Scommand][Smod].command == "zoomjdg+25" then
				if (judgZoomActiva + 25) > 100 then 
					judgZoomActiva = 100; 
				else
					judgZoomActiva = judgZoomActiva + 25;	
				end;
				
			end;

			if Mods[Scommand][Smod].command == "zoomjdg+10" then
				if (judgZoomActiva + 10) > 100 then 
					judgZoomActiva = 100; 
				else
					judgZoomActiva = judgZoomActiva + 10;	
				end;
				
			end;			

			if Mods[Scommand][Smod].command == "zoomjdg+1" then
				if (judgZoomActiva + 1) > 100 then 
					judgZoomActiva = 100; 
				else
					judgZoomActiva = judgZoomActiva + 1;	
				end;
				
			end;

			if Mods[Scommand][Smod].command == "zoomjdg-1" then
				if (judgZoomActiva - 1) < 0 then 
					judgZoomActiva = 0; 
				else
					judgZoomActiva = judgZoomActiva - 1;	
				end;
				
			end;

			if Mods[Scommand][Smod].command == "zoomjdg-10" then
				if (judgZoomActiva - 10) < 0 then 
					judgZoomActiva = 0; 
				else
					judgZoomActiva = judgZoomActiva - 10;	
				end;
				
			end;

			if Mods[Scommand][Smod].command == "zoomjdg-25" then
				if (judgZoomActiva - 25) < 0 then
					judgZoomActiva = 0; 
				else
					judgZoomActiva = judgZoomActiva - 25;	
				end;
			end;
			
			setCustomOptionValuePlayer(Splayer,"judgmentZoom",judgZoomActiva);
		end;		


		if Titles[Scommand].name == "lifebarsettings" then	

			if Mods[Scommand][Smod].command == "breakonlifebarc" then					
				--1 INMEDIATE --4 OFF
				local failSetting = STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting();
				if failSetting == "FailType_Immediate" then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(4);
				else
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(1);
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","none");
				end;
			end;

			if Mods[Scommand][Smod].command == "suddendeath" then		
				--1 INMEDIATE --4 OFF
				local typeLifeBarExtra = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");

				if typeLifeBarExtra == "suddendeath" then
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","none");
				else
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","suddendeath");
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(4); -- break on.
				end;

				local lifebarExtraSelected = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");
			end;

			if Mods[Scommand][Smod].command == "5missmax" then		
				local typeLifeBarExtra = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");

				if typeLifeBarExtra == "5missmax" then
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","none");
				else
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","5missmax");
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(4); -- break on.
				end;

				local lifebarExtraSelected = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");
			end;	

			if Mods[Scommand][Smod].command == "pfcmode" then		
				local typeLifeBarExtra = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");

				if typeLifeBarExtra == "pfcmode" then
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","none");
				else
					setCustomOptionValuePlayer(Splayer,"lifebar_extra_mode","pfcmode");
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):FailSetting(4); -- break on.
				end;

				local lifebarExtraSelected = getCustomOptionValuePlayer(Splayer,"lifebar_extra_mode");
			end;

		end;


		if Titles[Scommand].name == "timingadj" then
			local timingAdjCustomOption = getCustomOptionValuePlayer(Splayer,"timing_adjustment");
			offsetPlayer = tonumber(timingAdjCustomOption);


			if offsetPlayer == nil then
				offsetPlayer = 0;
			end;					

			if Mods[Scommand][Smod].command == "timing+001" then
				if (addStep(offsetPlayer,0.01)) > limitTiming[1] then 
					offsetPlayer = limitTiming[1]; 
				else
					offsetPlayer = addStep(offsetPlayer,0.01);
				end;
			end;

			if Mods[Scommand][Smod].command == "timing+005" then
				if (addStep(offsetPlayer,0.05)) > limitTiming[1] then 
					offsetPlayer = limitTiming[1]; 
				else
					offsetPlayer = addStep(offsetPlayer,0.05)
				end;
			end;			

			if Mods[Scommand][Smod].command == "timing+01" then
				if (addStep(offsetPlayer,0.1)) > limitTiming[1] then 
					offsetPlayer = limitTiming[1]; 
				else
					offsetPlayer = addStep(offsetPlayer,0.1);
				end;
			end;	

			if Mods[Scommand][Smod].command == "timing-01" then

				if (subStep(offsetPlayer,0.1)) < limitTiming[2] then 
					offsetPlayer = limitTiming[2]; 
				else
					offsetPlayer = subStep(offsetPlayer,0.1);
				end;
			end;				

			if Mods[Scommand][Smod].command == "timing-005" then
				if (subStep(offsetPlayer,0.05)) < limitTiming[2] then 
					offsetPlayer = limitTiming[2]; 
				else
					offsetPlayer = subStep(offsetPlayer,0.05);
				end;
			end;	
			
			if Mods[Scommand][Smod].command == "timing-001" then
				if (subStep(offsetPlayer,0.01)) < limitTiming[2] then 
					offsetPlayer = limitTiming[2]; 
				else
					offsetPlayer = subStep(offsetPlayer,0.01);
				end;
			end;	

			local offsetPlayerProc = math.floor(offsetPlayer * 100) / 100;
			setCustomOptionValuePlayer(Splayer,"timing_adjustment",tostring(offsetPlayerProc));
			GAMESTATE:GetPlayerState(Splayer):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming(offsetPlayerProc);
		end;


		--END NEW MODS--

		--SPEED
		if Titles[Scommand].name == "speed" then
			local xm = 2;
			if Mods[Scommand][Smod].command == "1x" or
			   Mods[Scommand][Smod].command == "2x" or
			   Mods[Scommand][Smod].command == "3x" or
			   Mods[Scommand][Smod].command == "4x" or
			   Mods[Scommand][Smod].command == "5x" or
			   Mods[Scommand][Smod].command == "6x" then			
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(string.gsub(Mods[Scommand][Smod].command,"x",""));
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
				xm = string.gsub(Mods[Scommand][Smod].command,"x","");
			end;
			if Mods[Scommand][Smod].command == "0.25" then
				local noX = string.gsub(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(),"x","");
				
				if tonumber(noX) % 1 == .25 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()-0.25)
				elseif tonumber(noX) % 1 == .75 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()-0.25)
				else
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()+0.25)
				end;
				
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
			end;
			if Mods[Scommand][Smod].command == "0.5" then
				local noX = string.gsub(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(),"x","");
				
				if tonumber(noX) % 1 == .5 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()-0.5)
				elseif tonumber(noX) % 1 == .75 then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()-0.5)
				else
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod()+0.5)
				end;
				
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
			end;
			if Mods[Scommand][Smod].command == "m550" then
				if seted[Scommand][Smod] or PAVenabled[Splayer] then
					seted[Scommand][Smod] = false;				
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(nil);		
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(2);
				else
					seted[Scommand][Smod] = true;
					MESSAGEMAN:Broadcast("EnableAV", {Player = Splayer} );
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(550);	
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(0);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(0);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
				end;
			end;
			if Mods[Scommand][Smod].command == "expand" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;				
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);				
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(1);
				end;
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(nil);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(2);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
			end;
			if Mods[Scommand][Smod].command == "accel" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(1);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(0);
					
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(nil);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
				end;
			end;
			if Mods[Scommand][Smod].command == "decel" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Decel(1);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Accel(0);
					
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(nil);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
				end;
			end;
			if Mods[Scommand][Smod].command == "randomvel" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(2);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomVel(true);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(2);
				end;
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):Expand(0);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):MMod(nil);
			end;
			if PAVenabled[Splayer] then
				STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod(nil);
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):XMod(xm);
			end;
			PAVenabled[Splayer] = false;
			MESSAGEMAN:Broadcast("CommandWindowAV", {Player = Splayer} );
		end;

		-- AV
		if Titles[Scommand].name == "av" then
			ApplyAV(Splayer, Mods[Scommand][Smod].command);
		end;

		-- DISPLAY
		if Titles[Scommand].name == "display" then
			if Mods[Scommand][Smod].command == "vanish" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish(1);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear(0);
				end;
			end;
			if Mods[Scommand][Smod].command == "appear" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Appear(1);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Vanish(0);
				end;
			end;
			if Mods[Scommand][Smod].command == "nonstep" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Nonstep(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Nonstep(1);
				end;
			end;
			if Mods[Scommand][Smod].command == "dark" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Dark(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Dark(1);
				end;
			end;
			if Mods[Scommand][Smod].command == "flash" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Flash(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Flash(1);
				end;
			end;
			if Mods[Scommand][Smod].command == "randomnote" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomNote(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomNote(true);
					
					if STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin() ~= NOTESKIN:GetDefaultGameNoteSkin() then
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin( NOTESKIN:GetDefaultGameNoteSkin() );
						MESSAGEMAN:Broadcast("RandomSkinEnabled", {Player = player} );
					end;
				
				end;
			end;
			if Mods[Scommand][Smod].command == "bgaoff" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(false);
				else
					seted[Scommand][Smod] = true;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(true);
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(false);
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial(false);
				end;
			end;
			if Mods[Scommand][Smod].command == "bgadark" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(false);
				else
					seted[Scommand][Smod] = true;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(true);
					--if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff() then
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(false);
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial(false);
					--end;
				end;
			end;
			if Mods[Scommand][Smod].command == "bgapartial" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial(false);
				else
					seted[Scommand][Smod] = true;
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(false);
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaOff(false);
					GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaPartial(true);
				end;
			end;
			
			if Mods[Scommand][Smod].command == "mini" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini(0.0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mini(0.25);
				end;
			end;
			
		end;	
		if Titles[Scommand].name == "path" then
			if Mods[Scommand][Smod].command == "xmode" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Xmode(0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Xmode(1);
				end;
			end;
			if Mods[Scommand][Smod].command == "nxmode" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):NXMode(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):NXMode(true);
				end;
			end;
			if Mods[Scommand][Smod].command == "underattack" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):UnderAttack(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):UnderAttack(true);
				end;			
			end;
			if Mods[Scommand][Smod].command == "drop" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Drop(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Drop(true);
				end;
			end;
			if Mods[Scommand][Smod].command == "sink" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Rise(0.0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Rise(-1.0);			
				end;
			end;
			if Mods[Scommand][Smod].command == "rise" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Rise(0.0);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Rise(1.0);
				end;
			end;
			if Mods[Scommand][Smod].command == "snake" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Snake(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Snake(true);
				end;
			end;
			if Mods[Scommand][Smod].command == "zigzag" then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):ZigZag(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):ZigZag(true);
				end;
			end;
			
		end;	
		if Titles[Scommand].name == "alternate" then
			if Mods[Scommand][Smod].command == "backwards" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards(true);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mirror(false);
				end;
			end;
			if Mods[Scommand][Smod].command == "supershuffle" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):SuperShuffle(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):SuperShuffle(true);
				end;
			end;
			if Mods[Scommand][Smod].command == "mirror" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mirror(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mirror(true);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards(false);
				end;
			end;
		end;
		if Titles[Scommand].name == "judge" then
			if Mods[Scommand][Smod].command == "hardjudgement" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(true);
					
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false);
					
				end;
			end;
			if Mods[Scommand][Smod].command == "judgereverse" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if seted[Scommand][Smod] then
					seted[Scommand][Smod] = false;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):JudgeReverse(false);
				else
					seted[Scommand][Smod] = true;
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):JudgeReverse(true);
				end;
			end;
			
			if Mods[Scommand][Smod].command == "veryhardjudgement" then
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() == false then
					if seted[Scommand][Smod] then
						seted[Scommand][Smod] = false;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(false);
					else
						seted[Scommand][Smod] = true;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(true);
						
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false);
					end;
				end;
			end;
			
			if Mods[Scommand][Smod].command == "extrajudgement" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() == false then
					if seted[Scommand][Smod] then
						seted[Scommand][Smod] = false;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false);
					else
						seted[Scommand][Smod] = true;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(true);
						
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false);
					end;
				end;
			end;
			
			if Mods[Scommand][Smod].command == "ultrahardjudgement" and not GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() == false then
					if seted[Scommand][Smod] then
						seted[Scommand][Smod] = false;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false);
					else
						seted[Scommand][Smod] = true;
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(true);
						
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(false);
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false);
					end;
				end;
			end;
			
			
		end;
		if Titles[Scommand].name == "note skin" or Titles[Scommand].name == "rank" or Titles[Scommand].name == "rush" then
			if seted[Scommand][Smod] then
				seted[Scommand][Smod] = false;
			else
				seted[Scommand][Smod] = true;
			end;
			for i=1, #seted[Scommand] do
				if i ~= Smod then
					seted[Scommand][i]=false;
				end;
			end;
			
			if Titles[Scommand].name == "note skin" then
				
				if  STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomNote() then
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):RandomNote(false);
					MESSAGEMAN:Broadcast("ResetRandomSkin", {Player = player} );
				end;
			
				STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin( NOTESKIN:GetDefaultGameNoteSkin() );
				for m=1,#Mods[Scommand], 1 do
					if seted[Scommand][m] then
						STATE:GetPlayerOptions('ModsLevel_Preferred' ):NoteSkin(Mods[Scommand][m].command);
					end;
				end;
			end;
			if Titles[Scommand].name == "rush" then
				GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate("1.0");
				
				for m=1,#Mods[Scommand], 1 do
					if seted[Scommand][m] then
						GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(Mods[Scommand][m].command);
					end;
				end;

				
			end;
			if Titles[Scommand].name == "rank" then
				GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode(false);
				GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode(seted[Scommand][Smod]);
				
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() and GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark() then
					 GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):BgaDark(true);
				end;

					
					
				if GAMESTATE:GetSongOptionsObject('ModsLevel_Preferred' ):RankMode() then
				
					if STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement() then STATE:GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false); end;
					if STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement() then STATE:GetPlayerOptions('ModsLevel_Preferred' ):VeryHardJudgement(false); end;
					if STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement() then STATE:GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false); end;
					if STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement() then STATE:GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false); end;
					
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Backwards(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):SuperShuffle(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):JudgeReverse(false);
					STATE:GetPlayerOptions('ModsLevel_Preferred' ):Mirror(false);
				end;
				
			end;
		end;	

		--VSMODE
		if Titles[Scommand].name == "vsmode" then
			if Mods[Scommand][Smod].command == "vsmode" then
				if GAMESTATE:GetNumSidesJoined() == 2 then
					if checkVsMode() == nil then
						setVsmodeValue(false);
						seted[Scommand][Smod] = false;
						restartVsHistory();
					else
						if checkVsMode() then
							setVsmodeValue(false);
							seted[Scommand][Smod] = false;
							restartVsHistory();
						else
							setVsmodeValue(true);
							seted[Scommand][Smod] = true;
						end;
					end;
				end;
			end;
		end;


end;


function GetPNGLabel(ns)
	if FILEMAN:DoesFileExist("NoteSkins/pump/".. ns.."/logo.png") then	--notelist[x]
		return "../../../../NoteSkins/pump/".. ns .."/logo.*";
	else
		return THEME:GetPathG("","_blank");
	end;
end;

function GetPNGFileNoteSkin(ns,file)
	if FILEMAN:DoesFileExist("NoteSkins/pump/".. ns.."/"..file) then	--notelist[x]
		return "NoteSkins/pump/".. ns .."/"..file;
	else
		return THEME:GetPathG("","_blank");
	end;
end;

function GetPNGIconLifebarSkin(skinName)
	--tenemos que saber a donde hay que buscar el path
	local esExterno = string.find(skinName, "e_");
	local pathIcon = "";
	local skinNameProcesado = "";
	if esExterno ~= nil then
		skinNameProcesado = string.gsub(skinName, "e_", "");
		local lifebarSkinExternalPath = GetLifebarSkinExternalPath();
		pathIcon = lifebarSkinExternalPath..skinNameProcesado.."/Icon.";		
	else
	  	local activeTheme = THEME:GetCurThemeName();
	  	skinNameProcesado = string.gsub(skinName, "i_", "");
	  	pathIcon = "/Themes/"..activeTheme.."/Graphics/ScreenGamePlay_ui/lifebar/"..skinNameProcesado.."/Icon.";	  	
	end;

	
	if FILEMAN:DoesFileExist(pathIcon.."png") then
		return pathIcon.."*";
	else
		return THEME:GetPathG("","_blank");
	end;		
end;

function GetAV(player)
	if GAMESTATE:IsPlayerEnabled(player) then
		local STATE = GAMESTATE:GetPlayerState(player);
		if STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() == nil then return ""; end;
		return STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod();
	else
		return ""
	end;
end;

local function GetCommands(List, Current)
		local NumItems = #List;
		return { (Current-4)%NumItems+1, (Current-3)%NumItems+1, (Current-2)%NumItems+1, Current, Current%NumItems+1, (Current+1)%NumItems+1, (Current+2)%NumItems+1 };
end;

local SelectedTitle=1;
local SelectedMod=1;
local CurrentTitles = GetCommands(Titles, SelectedTitle);
local CurrentMods = GetCommands(Mods[1], SelectedMod);

local speedModTiming = 4;
local playerPos = 1;
if player == PLAYER_1 then
	playerPos = -1;
end;


-- para los titulos de los comandos
local zoomTitles=0.55;
local MovePosCommand = {
	(cmd(x,-155;zoom,zoomTitles-0.50;rotationy,90 ;z,-50;diffusealpha,0)),
	(cmd(x,-155;zoom,zoomTitles-0.50;rotationy,90 ;z,-50;diffusealpha,0)),
	(cmd(x,-110;zoom,zoomTitles-0.20;rotationy,0 ;z,-50;diffusealpha,0.6)),
	(cmd(x,0  ;zoom,zoomTitles;rotationy,0  ;z,0  ;diffusealpha,1)),--center
	(cmd(x,110 ;zoom,zoomTitles-0.20;rotationy,0;z,-50;diffusealpha,0.6)),
	(cmd(x,155 ;zoom,zoomTitles-0.50;rotationy,-90;z,-50;diffusealpha,0)),
	(cmd(x,155 ;zoom,zoomTitles-0.50;rotationy,-90;z,-50;diffusealpha,0))
};
--este es para los iconos de modificaciones ¬¬
local InitPosCommand = {
	(cmd(x,-155;rotationy,90 ;z,-100;diffusealpha,0)),
	(cmd(x,-125;rotationy,15 ;z,-50;diffusealpha,0.6)),
	(cmd(x,-64;rotationy,10 ;z,-50;diffusealpha,1)),
	(cmd(x,0  ;rotationy,0  ;z,0  ;diffusealpha,1)),--center
	(cmd(x,64 ;rotationy,-10;z,-50;diffusealpha,1)),
	(cmd(x,125 ;rotationy,-15;z,-50;diffusealpha,0.6)),
	(cmd(x,155 ;rotationy,-90;z,-100;diffusealpha,0))
};

local InitPosCommandLess = {
	(cmd(x,-155;rotationy,90 ;z,-50;diffusealpha,0)),
	(cmd(x,-125;rotationy,15 ;z,-50;diffusealpha,0)),
	(cmd(x,-64;rotationy,10 ;z,-50;diffusealpha,1)),
	(cmd(x,0  ;rotationy,0  ;z,0  ;diffusealpha,1)),--center
	(cmd(x,64 ;rotationy,-10;z,-50;diffusealpha,1)),	
	(cmd(x,125 ;rotationy,-15;z,-50;diffusealpha,0)),
	(cmd(x,155 ;rotationy,-90;z,-50;diffusealpha,0))
};
	
	t[#t+1] = Def.ActorFrame 	{

		RankModeCWMessageCommand=function(self,params)
			local ARRAY={};
			ARRAY[-1]=PLAYER_1;
			ARRAY[1]=PLAYER_2;
			
			for p=-1,1,2 do
				if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):HardJudgement(false);
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):ExtraJudgement(false);
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):UltraHardJudgement(false);
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):Backwards(false);
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):SuperShuffle(false);
					GAMESTATE:GetPlayerState(ARRAY[p]):GetPlayerOptions('ModsLevel_Preferred' ):JudgeReverse(false);
				end;
			end;
		end;

		CommandWindowMoveOptionMessageCommand=function(self,params)
			if params.Player == player then
				
				SelectedTitle = SelectedTitle + params.Direction;
				if SelectedTitle < 1 then
					SelectedTitle = #Titles;
				end;
				if SelectedTitle > #Titles then
					SelectedTitle=1;
				end;
				CurrentTitles = GetCommands(Titles, SelectedTitle);
				SCREENMAN:GetTopScreen():SetCommand(params.Player,Titles[SelectedTitle].name);
				--Trace("### MOVED ###"..Titles[SelectedTitle].name);
				MESSAGEMAN:Broadcast("MoveTitles", {Player = params.Player} )
				MESSAGEMAN:Broadcast("CheckPreviewSelected" , {Player = params.Player, Title = Titles[SelectedTitle].name});			
			end;
		end;

		CWOpenMessageCommand=function(self,params)
			if params.Player == player then
				MESSAGEMAN:Broadcast("CheckPreviewSelected" , {Player = params.Player, Title = Titles[SelectedTitle].name});	
			end;
		end;

		CWCloseMessageCommand=function(self,params)
			if params.Player == player then
				MESSAGEMAN:Broadcast("CloseCheckPreviewSelected" , {Player = params.Player, Title = Titles[SelectedTitle].name});
			end;
		end;

		CommandWindowMoveModMessageCommand=function(self,params)
			if params.Player == player then
				SelectedMod = SelectedMod + params.Direction;
				if SelectedMod < 1 then
					SelectedMod = #Mods[SelectedTitle];
				end;
				if SelectedMod > #Mods[SelectedTitle] then
					SelectedMod=1;
				end;
				CurrentMods = GetCommands(Mods[SelectedTitle], SelectedMod);
				MESSAGEMAN:Broadcast("MoveMods", {Player = params.Player, Direction = params.Direction} );

				-- we reload the noteskin preview.
				local Title = Titles[SelectedTitle].name;				
				if Title == "note skin" then
					MESSAGEMAN:Broadcast("CwNavigatePreview" , {Player = params.Player, Mod = Mods[SelectedTitle][SelectedMod].command, Command = Titles[SelectedTitle].index } );
				end;

			end;
		end;

		CommandWindowSelectModMessageCommand=function(self,params)
			if params.Player == player then
				ApplyMods(SelectedTitle,SelectedMod,params.Player);
				
				local Title = Titles[SelectedTitle].name;
				
				if Title == "note skin" then
					MESSAGEMAN:Broadcast("CheckNoteSkin" , {Player = params.Player, Mod = Mods[SelectedTitle][SelectedMod].command, Command = Titles[SelectedTitle].index } );
				else
					MESSAGEMAN:Broadcast("CheckSelected" , {Player = params.Player, Mod = Mods[SelectedTitle][SelectedMod].command, Command = Titles[SelectedTitle].index } );
				end;
				
				local modname = Mods[SelectedTitle][SelectedMod].command;
				if Title == "rush" or modname == "bgapartial" or modname == "bgadark" or  modname == "bgaoff" or modname == "title" then
					MESSAGEMAN:Broadcast("GlobalMod", {Player = params.Player, Title = Titles[SelectedTitle].name,TitleIndex = Titles[SelectedTitle].index , Mod = Mods[SelectedTitle][SelectedMod].command, });
				end;
			end;
		end;

		CommandWindowModCancelMessageCommand=function(self,params)
			if params.Player == player then
				-- we reload the noteskin preview.
				MESSAGEMAN:Broadcast("CheckNoteSkin", {Player = player} );
			end;
		end;

		CommandWindowSelectOptionMessageCommand=function(self,params)
			if params.Player == player then
				SCREENMAN:GetTopScreen():SetCommand(params.Player,Titles[SelectedTitle].name);

				-- we reload the noteskin preview.
				local Title = Titles[SelectedTitle].name;				
				if Title == "note skin" then
					MESSAGEMAN:Broadcast("CwNavigatePreview" , {Player = params.Player, Mod = Mods[SelectedTitle][SelectedMod].command, Command = Titles[SelectedTitle].index } );
				end;

			end;
		end;
		


		LoadActor(THEME:GetPathG( "","CommandWindow/bg/bg_1"))..
		{
			OnCommand=function(self)
				self:zoom(0.7);
				self:addy(28);
			end;
			CWOpenMessageCommand=function(self,params)
				if params.Player == player then
					self:sleep(0.0625):glow(1,1,1,0.3):linear(0.0625):glow(1,1,1,0):diffusealpha(0.95);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:zoom(0.7);
				self:addy(-28);
			end;
		};

		LoadActor(THEME:GetPathG( "","CommandWindow/bg/glowbg_1"))..
		{
			OnCommand=function(self)
				self:zoom(0.7);
				self:addy(28);
			end;
			FullModeMessageCommand=function(self)
				self:zoom(0.7);
				self:addy(-28);
			end;			
			CWOpenMessageCommand=function(self,params)
				if params.Player == player then
					self:sleep(0.0625):glow(1,1,1,0.1):linear(0.0625):glow(1,1,1,0):blend("BlendMode_Add"):queuecommand("Ani");
				end;
			end;

			AniCommand=function(self)
				self:linear(0.8);
				self:diffusealpha(0.2);
				self:accelerate(0.6);
				self:diffusealpha(0.5);
				self:queuecommand("Ani");
			end;
		};

		--texto detalle sprite
		LoadActor(THEME:GetPathG( "","CommandWindow/bg/bg_3"))..
		{
			OnCommand=function(self)
				self:zoom(0.7);
				self:addy(15);
			end;
			CWOpenMessageCommand=function(self,params)
				if params.Player == player then
					self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:zoom(0.7);
				self:addy(-14);
			end;	
		};				

		--preview gamezone sprite
		LoadActor(THEME:GetPathG( "","CommandWindow/bg/bg_2"))..
		{
			OnCommand=function(self)
				self:zoom(0.7);
				self:addy(118);
			end;
			CWOpenMessageCommand=function(self,params)
				if params.Player == player then
					self:sleep(0.0625):glow(1,1,1,0.5):linear(0.0625):glow(1,1,1,0);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"On");
		};


		--PREVIEW SELECTED ICONS MODS --		
		Def.ActorFrame{

			CommandWindowSelectOptionMessageCommand=function(self,params)	
				if params.Player == player then
					self:linear(0.05);
					self:zoomx(0);				
				end;
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:linear(0.05);
					self:zoomx(1);
				end;


			end;

			getActorPreviewOptionSelected(player,"zoom");
			getActorPreviewOptionSelected(player,"timing");
			getActorPreviewOptionSelected(player,"gameplayinfo");
			getActorPreviewOptionSelected(player,"judgeskin");
			getActorPreviewOptionSelected(player,"lifebarskin");
			getActorPreviewOptionSelected(player,"lifebarSettings");
			getActorPreviewOptionSelected(player,"display");
			getActorPreviewOptionSelected(player,"note skin");
			getActorPreviewOptionSelected(player,"path");
			getActorPreviewOptionSelected(player,"alternate");
			getActorPreviewOptionSelected(player,"judge");
			getActorPreviewOptionSelected(player,"rush");
			getActorPreviewOptionSelected(player,"sort");
			getActorPreviewOptionSelected(player,"rank");
			getActorPreviewOptionSelected(player,"vsmode");
			getActorPreviewOptionSelected(player,"speed");
			getActorPreviewOptionSelected(player,"av");

		};

		--#################################--
		--		PREVIEW GAMEFIELD MODS
		--################################--
		--banner de la canción para el preview
		--este se ocupara cuando la opción que la requiera sea electa.
		GetPreview(player)..{
			OnCommand=function(self)
				self:zoom(1.1);
				self:y(-12);
			end;
		};


		--#################################--
		--			COMMAND WINDOW
		--################################--
		-- OPTIONS
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..
		{
			InitCommand=cmd(y,-80;animate,false;setstate,2;zoom,.85;zoomx,1.35;addx,-2);
			CommandWindowSelectOptionMessageCommand=function(self,params)

				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():linear(0.125):y( (sTitle == "av" and -32 or -50 ) );
					
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):y(-80);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		-- SUB OPTIONS
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..
		{
			InitCommand=cmd(y,-40;animate,false;setstate,2;diffusealpha,0;zoom,.88;zoomx,1.35;addx,-2);
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():linear(0.125):y(sTitle == "av" and -83 or -110):diffusealpha(1);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):y(-40):diffusealpha(0);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};


		LoadActor(THEME:GetPathG( "","CommandWindow/CW/ARRCW"))..{
			InitCommand=cmd(x,-135;y,223;diffusealpha,0;animate,false;setstate,0;zoom,0.68);
			CommandWindowMoveModMessageCommand=function(self, params)
				if params.Player == player then
					if params.Direction == -1 then
						self:finishtweening();
						self:linear(0.15);
						self:diffusealpha(1);
						self:linear(0.0425);
						self:diffusealpha(0);
					end;
				end;
			end;
			CommandWindowMoveOptionMessageCommand=function(self, params)
				if params.Player == player then
					if params.Direction == -1 then
						self:finishtweening();
						self:linear(0.15);
						self:diffusealpha(1);
						self:linear(0.0425);
						self:diffusealpha(0);
					end;
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/ARRCW"))..{
			InitCommand=cmd(x,137;y,223;diffusealpha,0;animate,false;setstate,1;zoom,0.68);
			CommandWindowMoveModMessageCommand=function(self, params)
				if params.Player == player then
					if params.Direction == 1 then
						self:finishtweening();
						self:linear(0.15);
						self:diffusealpha(1);
						self:linear(0.0425);
						self:diffusealpha(0);
					end;
				end;
			end;
			CommandWindowMoveOptionMessageCommand=function(self, params)
				if params.Player == player then
					if params.Direction == 1 then
						self:finishtweening();
						self:linear(0.15);
						self:diffusealpha(1);
						self:linear(0.0425);
						self:diffusealpha(0);
					end;
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};	
		
		--FX DESCRIPTION
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..{
			InitCommand=cmd(y,71;queuecommand,"Recover";animate,false;setstate,0);
			RecoverCommand=cmd(cropleft,0;cropright,0;fadeleft,0;faderight,0;diffusealpha,1;diffuseshift;effectcolor1,color("0,1,1,0");effectcolor2,color("0,1,1,.25");effectperiod,2);
			MoveModsMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening():stopeffect():visible(true):diffusealpha(1):diffusecolor(0,1,1,.6):linear(.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			MoveTitlesMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening():stopeffect():diffusealpha(1):diffusecolor(0,1,1,.6):linear(0.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect():queuecommand("Recover");
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect():diffusealpha(0):queuecommand("Recover");
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		-- FX OPTIONS
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..{
			InitCommand=cmd(y,-38;visible,true;animate,false;setstate,1;queuecommand,"Recover");
			RecoverCommand=cmd(cropleft,0;cropright,0;fadeleft,0;faderight,0;diffusealpha,1;diffuseshift;effectcolor1,color("0,1,1,0");effectcolor2,color("0,1,1,.25");effectperiod,2);
			MoveModsMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening():stopeffect():visible(true):diffusealpha(1):diffusecolor(0,1,1,.6):linear(.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			MoveTitlesMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening():stopeffect():y(-38):diffusealpha(1):diffusecolor(0,1,1,.6):linear(0.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():stopeffect():y(sTitle == "av" and 13 or -10):queuecommand("Recover");
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect():y(-38):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		
		-- FX BUTTON MODS
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..{
			InitCommand=cmd(y,-72;visible,false;animate,false;setstate,1;queuecommand,"Recover");
			RecoverCommand=cmd(cropleft,0;cropright,0;fadeleft,0;faderight,0;diffusealpha,1;diffuseshift;effectcolor1,color("0,1,1,0");effectcolor2,color("0,1,1,.25");effectperiod,2);
			MoveModsMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening():stopeffect():visible(true):diffusealpha(1):diffusecolor(0,1,1,.6):linear(.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():stopeffect():y(sTitle == "av" and -32 or -72):visible(true):queuecommand("Recover");
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect():diffusealpha(0);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		
		-- AV TITLE
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..
		{
			InitCommand=cmd(y,-80;animate,false;visible,false;setstate,2;zoomy,.6;zoomx,1.35;addx,-2);
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():diffusealpha(1):y(-52):linear(.2):y(-128);
					self:visible(sTitle == "av" and true or false);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():y(-81):linear(.2):y(-52):visible(false);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		-- AV FX
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/FXCW"))..
		{
			InitCommand=cmd(y,-80;animate,false;visible,false;setstate,0;zoomy,.75;zoomx,.98);
			RecoverCommand=cmd(cropleft,0;cropright,0;fadeleft,0;faderight,0;diffusealpha,1;diffuseshift;effectcolor1,color("0,1,1,0");effectcolor2,color("0,1,1,.25");effectperiod,2);
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:finishtweening():stopeffect():y(-80):visible(sTitle == "av" and true or false):diffusealpha(1):diffusecolor(0,1,1,.6):linear(.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			MoveModsMessageCommand=function(self, params)
				local sTitle = Titles[SelectedTitle].name;
				if params.Player == player and (sTitle == "av") then
					self:finishtweening():stopeffect():visible(true):diffusealpha(1):diffusecolor(0,1,1,.6):linear(.3):diffusealpha(0):queuecommand("Recover");
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():stopeffect():visible(false);
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
		};
		
		LoadActor(THEME:GetPathG( "","CommandWindow/bg/cbpm"))..
		{
			InitCommand=cmd(y,-123;animate,false;visible,false);
			InitCommand=function(self)
				self:addx(-45);
				self:y(-128);
				self:animate(false);
				self:visible(false);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local sTitle = Titles[SelectedTitle].name;
					self:visible(sTitle == "av" and true or false):zoom(0.75):zoomx(0):linear(.13):zoomx(0.75);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:zoomx(0.75):linear(.13):zoomx(0);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:addx(0);
				self:animate(false);
				self:visible(false);
			end;
		};
		
		
		--TEXTO AV (el numerito)
		LoadFont("interphase/InterNumber numbers").. {
			InitCommand=cmd(y,-148;zoomx,0;zoomy,0.6;horizalign,center;settext,"300";addx,74;);
			CommandWindowSelectOptionMessageCommand=function(self,params)
				local sTitle = Titles[SelectedTitle].name;
				if params.Player == player and sTitle == "av" then
					self:settext(GetAV(player)):zoomx(0):linear(.13):zoomx(.6);
				end;
			end;
			UpdateAVCommand=cmd(settext,GetAV(player);zoom,.6);
			CommandWindowAVMessageCommand=function(self,params)
				local sTitle = Titles[SelectedTitle].name;
				if params.Player == player and sTitle == "av" then
					self:stoptweening();
					self:queuecommand("UpdateAV");
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				local sTitle = Titles[SelectedTitle].name;
				if params.Player == player and sTitle == "av" then
					self:zoomx(.6):linear(.08):zoomx(0);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:addx(0);
			end;
		};

		-- texto zoom judgskin (numerito y sprite)
		LoadActor(THEME:GetPathG( "","CommandWindow/bg/zoomtext"))..
		{
			--InitCommand=cmd(y,3;visible,false);
			InitCommand=function(self)
				self:addx(-45);
				self:y(15);
				self:zoom(0.42);
				self:diffusealpha(1);
				self:visible(false);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "judgeskinzoom" then
					self:visible(true);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "judgeskinzoom" then
					self:visible(false);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:addx(0);
			end;
		};

		LoadFont("interphase/WhiteInterNumber numbers").. {
			InitCommand=cmd(y,-4;zoom,0.58;horizalign,center;settext,"100";addx,55;visible,false);

			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "judgeskinzoom" then
					self:visible(true);
					self:queuecommand("UpdateZoomText");
				end;
			end;
			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "judgeskinzoom" then
					self:queuecommand("UpdateZoomText");
				end;
			end;

			UpdateZoomTextCommand=function(self)
					local zoomPlayer = getCustomOptionValuePlayer(player,"judgmentZoom");
					
					if zoomPlayer == nil then
						zoomPlayer = 100;
						setCustomOptionValuePlayer(Splayer,"judgmentZoom",zoomPlayer);
					end;
					zoomPlayer = getCustomOptionValuePlayer(player,"judgmentZoom");				
					self:settext(zoomPlayer.."%")					
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "judgeskinzoom" then
					self:visible(false);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:addx(0);
			end;
		};		

		--WE ADD THE TMING ADJUSTMENT TEXT
		LoadFont("interphase/WhiteInterNumber numbers").. {
			InitCommand=cmd(y,-4;zoom,0.58;horizalign,center;settext,"-";addx,0;visible,false);

			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "timingadj" then
					self:visible(true);
					self:queuecommand("UpdateTimingText");
				end;
			end;
			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "timingadj" then
					self:queuecommand("UpdateTimingText");
				end;
			end;

			UpdateTimingTextCommand=function(self)

					local timingAdjCustomOption = getCustomOptionValuePlayer(player,"timing_adjustment");

					--local timingPlayer = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):JudgeTiming();

					local timingPlayer = tonumber(timingAdjCustomOption);

					local textTiming = string.format("%.1f", timingPlayer)
					if timingPlayer > 0 then 						
						textTiming = "+"..textTiming;
					elseif timingPlayer == 0 then
						textTiming = "0.0";
					end;

					self:settext(textTiming)					
			end;

			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player and Titles[SelectedTitle].name  == "timingadj" then
					self:visible(false);
				end;
			end;
			FullModeMessageCommand=function(self)
				self:addx(0);
			end;
		};	


		--flechitas selección opciones
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/CURCW"))..{
			InitCommand=cmd(y,-80;diffusealpha,0;animate,false;setstate,0);
			CWOpenMessageCommand=function(self, params)
				if params.Player == player then
					self:finishtweening();
					self:linear(0.125);
					self:zoom(0.665);
					self:diffusealpha(1)
					self:queuecommand("Effect");
				end;
			end;
			CWCloseMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:linear(0.25);
					self:zoom(1.125);
					self:diffusealpha(0);
				end;
			end;
			
			CommandWindowMoveOptionMessageCommand=function(self, params)
				if params.Player == player then				
					self:finishtweening();
					self:stopeffect();
					self:zoom(1);
					self:linear(0.125);
					self:zoom(1.1);
					self:linear(0.125);
					self:zoom(1);
					self:queuecommand("Effect");
				end;
			end;
			FullModeMessageCommand=cmd(playcommand,"Init");
			EffectCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.5");effectperiod,1;queuecommand,"Zoom");
			ZoomCommand=cmd(finishtweening;zoom,1;linear,0.4;zoom,0.93;linear,0.4;zoom,1;queuecommand,"Zoom");
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:linear(0.0625);
					self:zoom(0.8325);
					self:diffusealpha(0)
					self:linear(0.0625);
					self:zoom(1);	
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:sleep(0.125);
					self:linear(0.125);
					self:zoom(0.665);
					self:diffusealpha(1)
					self:queuecommand("Effect");
				end;
			end
		};
		
		--flechitas selección Modificadores
		LoadActor(THEME:GetPathG( "","CommandWindow/CW/CURCW"))..{
			InitCommand=cmd(y,-110;diffusealpha,0;animate,false;setstate,1;addx,-1);
			FullModeMessageCommand=cmd(playcommand,"Init");
			CommandWindowMoveModMessageCommand=function(self, params)
				if params.Player == player then				
					self:finishtweening();
					self:stopeffect();
					self:zoom(1);
					self:linear(0.125);
					self:zoom(1.1);
					self:linear(0.125);
					self:zoom(1);
					self:queuecommand("Effect");
				end;
			end;
			EffectCommand=cmd(diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.5");effectperiod,1;queuecommand,"Zoom");
			ZoomCommand=cmd(finishtweening;zoom,1;linear,0.4;zoom,0.93;linear,0.4;zoom,1;queuecommand,"Zoom");
			
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:linear(0.0625);
					self:zoom(0.8325);				
					self:diffusealpha(0)
					self:linear(0.0625);
					self:zoom(1);	
				end;
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					local sTitle = Titles[SelectedTitle].name;
					self:y((sTitle == "av" and -85 or -111 ));		
					self:sleep(0.125);
					self:linear(0.125);
					self:zoom(1);
					self:diffusealpha(1)
					self:queuecommand("Effect");
					
				end;
			end;
		};
		
		
		--Descripcion de opcion o mod
		LoadFont("_myriad pro").. 
		{
			InitCommand=cmd(y,15;zoom,0.8;);
			FullModeMessageCommand=cmd(playcommand,"Init");
			OnCommand=function(self)
		        self:wrapwidthpixels(380)  -- Limita el ancho en píxeles donde el texto se ajustará automáticamente.
		        self:maxheight(100)        -- Establece el máximo espacio vertical que puede ocupar el texto.
		        self:vertspacing(-2)       -- Ajusta el espacio entre líneas (opcional).			
			end;
			MoveModsMessageCommand=function(self, params)
				if params.Player == player then		
					local nameDesc = getCWText(Titles[SelectedTitle].name .. "/" .. Mods[SelectedTitle][SelectedMod].order);
					self:settext(nameDesc);
				end;
			end;
			MoveTitlesMessageCommand=function(self, params)
				if params.Player == player then
					self:settext(getCWText(Titles[SelectedTitle].name));
				end;
			end;

			CommandWindowModCancelMessageCommand=function(self, params)
				if params.Player == player then
					self:settext(getCWText(Titles[SelectedTitle].name));
				end;
			end;
			
			InitModsMessageCommand=function(self, params)
				if params.Player == player then
					self:settext(getCWText(Titles[SelectedTitle].name .. "/" .. Mods[SelectedTitle][SelectedMod].order));
				end;
			end;
			
		};
	};
	
	--TITULOS DE OPCIONES 
	for i=1,#Titles do
		t[#t+1] = LoadActor(THEME:GetPathG( "","CommandWindow/"..Titles[i].order.."_title.png"))..
		{
			InitCommand=function(self,params)
				self:y(-80);
				MESSAGEMAN:Broadcast("MoveTitles", {Player = player} )
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then
					local STATE = GAMESTATE:GetPlayerState(player);
					
					local sTitle = Titles[SelectedTitle].name;

					--prueba de env para modificar el otro coso.
					setEnvPlayer(player,"playercwmenu",sTitle);

					if sTitle == "av" and STATE:GetPlayerOptions('ModsLevel_Preferred'):MMod() == nil then -- RESET AUTO VEOLICTY
						ApplyAV(player, "av+0");
						MESSAGEMAN:Broadcast("EnableAV", {Player = player} )
					end;
					
					SelectedMod=1;
					--check for the mod selected on the lifeskins.
					if sTitle == "lifebarskin" then
						SelectedMod = getIndexModSelectedFromModList(Mods[SelectedTitle],getCustomOptionValuePlayer(player,"lifebarSkin"));
					end;

					if sTitle == "judgeskin" then
						SelectedMod = getIndexModSelectedFromModList(Mods[SelectedTitle],getCustomOptionValuePlayer(player,"judgmentSkin"));
					end;

					CurrentMods = GetCommands(Mods[SelectedTitle], SelectedMod);					
					MESSAGEMAN:Broadcast("InitMods", {Player = params.Player} )
					
					if sTitle == "note skin" then
						MESSAGEMAN:Broadcast("CheckNoteSkin", {Player = player} )
					else
						MESSAGEMAN:Broadcast("CheckSelected", {Player = player} )
					end;
					
					self:finishtweening():linear(0.125):y((sTitle == "av" and -34 or -50 ));		
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):y(-80);
				end;
			end;
						
			MoveTitlesMessageCommand=function(self,params)
				if params.Player == player then				
					self:finishtweening(); --detiene todas las animaciones
					self:stopeffect();	--detiene el reset en caso de
					if 	    i==CurrentTitles[1] then self:linear(.18);(MovePosCommand[1])(self);
					elseif 	i==CurrentTitles[2] then self:linear(.18);(MovePosCommand[2])(self);
					elseif 	i==CurrentTitles[3] then self:linear(.18);(MovePosCommand[3])(self);
					elseif 	i==CurrentTitles[4] then self:linear(.18);(MovePosCommand[4])(self); --center
					elseif 	i==CurrentTitles[5] then self:linear(.18);(MovePosCommand[5])(self);
					elseif 	i==CurrentTitles[6] then self:linear(.18);(MovePosCommand[6])(self);
					elseif 	i==CurrentTitles[7] then self:linear(.18);(MovePosCommand[7])(self);
					else (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			CommandWindowResetMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:stopeffect();
					self:diffuseblink();
					self:effectcolor1(Color.White)
					self:effectcolor2(Color.Black)
					self:effectperiod(0.125);
					self:sleep(0.25);
					self:queuecommand("StopEffectAux");
					PAVenabled[player] = false;  
				end;
			end;
			StopEffectAuxCommand=cmd(stopeffect);
		};	
	end;

	local noteindex = 0;
	-- we search the index where is all the noteskin list in the mod array.
	for ind=1,#Titles, 1 do
		if (Titles[ind].name == "note skin") then
			noteindex = ind;
		end;
	end;
	
	-- Draw icon
	-- Insert additional noteskin copies to fill missing spots
	for pos=1,#notelist*math.ceil(minNumItemsCW/#notelist) do
		local x = (pos-1)%#notelist+1

		t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/BackIcon"))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(1);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == noteindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == noteindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			CheckNoteSkinMessageCommand=function(self,params)
				if params.Player == player then
					local noteskin = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
					if noteskin == string.lower(notelist[x]) then
						self:diffusecolor(color("#ffffff"));
					else
						self:diffusecolor(color("#555555"));
					end;
				end;
			end;
		};
	
		t[#t+1] = LoadActor(GetPNGLabel(notelist[x]))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(.9);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == noteindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == noteindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;

					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			CheckNoteSkinMessageCommand=function(self,params)
				local noteskin = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
				if noteskin == string.lower(notelist[x]) then
					self:diffusecolor(color("#ffffff"));
				else
					self:diffusecolor(color("#555555"));
				end;
			end;
		};
	end;

	local judgeindex = 0; -- Este indica a que indice de la lista de titulos le pertenece estos objetos cargados dinamicamente.
	-- we search of the correct index where all the skin list is listed.
	for ind=1,#Titles, 1 do
		if (Titles[ind].name == "judgeskin") then
			judgeindex = ind;
		end;
	end;

	-- Draw judgmentkins options
	-- Insert additional judgeskin copies to fill missing spots
	for pos=1,#judgeSkinList*math.ceil(minNumItemsCW/#judgeSkinList) do
		local x = (pos-1)%#judgeSkinList+1

		t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/BackIcon"))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(1);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == judgeindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == judgeindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;

			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player then
					self:diffusecolor(color("#555555"));
					--probando con el getProfile y no por el index.
					local skinloop = judgeSkinList[x];					
					local skinPlayer = getCustomOptionValuePlayer(player,"judgmentSkin");

					if skinPlayer ~= nil then
						if skinloop ==  skinPlayer then
							self:diffusecolor(color("#ffffff"));
						end;
					end;

				end;
			end;
		};
	

		t[#t+1] = LoadActor(GetPNGIconJudgSkin(judgeSkinList[x]))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(.9);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == judgeindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						judgmentSpriteObject[player]:playcommand("ProcCheck",{judgskincw = judgeSkinList[CurrentMods[4]]});

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == judgeindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;

					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;

					self:diffusecolor(color("#555555"));
				end;
			end;

			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player then
					self:diffusecolor(color("#555555"));
					--probando con el getProfile y no por el index.
					local skinloop = judgeSkinList[x];					
					local skinPlayer = getCustomOptionValuePlayer(player,"judgmentSkin");
				
					if skinPlayer ~= nil then
						if skinloop ==  skinPlayer then
							self:diffusecolor(color("#ffffff"));
						end;
					end;

				end;
			end;

		};
	end;

	local lifebarindex = 0; -- This indicates where in the mods list is all the skin for the CW
	--here we search of the correct index of the list
	for ind=1,#Titles, 1 do
		if (Titles[ind].name == "lifebarskin") then
			lifebarindex = ind;
		end;
	end;

	--lifebar skins
	-- Insert additional lifebarskin copies to fill missing spots
	for pos=1,#lifebarSkinList*math.ceil(minNumItemsCW/#lifebarSkinList) do
		local x = (pos-1)%#lifebarSkinList+1

		t[#t+1] = LoadActor(THEME:GetPathG("","CommandWindow/BackIcon"))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(1);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)

				if params.Player == player then
					if SelectedTitle == lifebarindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == lifebarindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;

			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player then
					self:diffusecolor(color("#555555"));
					--probando con el getProfile y no por el index.
					local skinloop = lifebarSkinList[x];					
					local skinLifeBarPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");
										
					if skinLifeBarPlayer ~= nil then
						if skinloop ==  skinLifeBarPlayer then
							self:diffusecolor(color("#ffffff"));
						end;
					end;

				end;
			end;
		};
	

		t[#t+1] = LoadActor(GetPNGIconLifebarSkin(lifebarSkinList[x]))..
		{
			InitCommand=function(self,params)
				--self:scaletoclipped(59 ,46);
				self:y(-110):zoom(0);
			end;
			CommandWindowSelectOptionMessageCommand=function(self,params)
				if params.Player == player then					
					self:finishtweening():linear(0.125):zoom(.9);
				end;
			end;
			CommandWindowModCancelMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening():linear(0.125):zoom(0);
				end;
			end;
						
			MoveModsMessageCommand=function(self,params)

				if params.Player == player then	
					if SelectedTitle == lifebarindex then
						self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						--lifebarSpriteObject[player].lifebarSkinCw = lifebarSkinList[CurrentMods[4]];
						--lifebarSpriteObject[player]:queuecommand("ReloadLifebarSkin");

						--Trace("::::WOAP::: current lifebar-> ".. lifebarSkinList[CurrentMods[4]]);
						lifebarSpriteObject[player]:playcommand("ReloadLifebarSkin",{lifebarskincw = lifebarSkinList[CurrentMods[4]]});

						if	pos==CurrentMods[1] then self:linear(.18);(InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then self:linear(.18);(InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then self:linear(.18);(InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then self:linear(.18);(InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then self:linear(.18);(InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then self:linear(.18);(InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then self:linear(.18);(InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;
					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;
				end;
			end;
			InitModsMessageCommand=function(self,params)
				if params.Player == player then	
					if SelectedTitle == lifebarindex then
						-- self:finishtweening(); --detiene todas las animaciones
						self:stopeffect();	--detiene el reset en caso de

						if	pos==CurrentMods[1] then (InitPosCommand[1])(self);
						elseif	pos==CurrentMods[2] then (InitPosCommand[2])(self);
						elseif	pos==CurrentMods[3] then (InitPosCommand[3])(self);
						elseif	pos==CurrentMods[4] then (InitPosCommand[4])(self); --center
						elseif	pos==CurrentMods[5] then (InitPosCommand[5])(self);
						elseif	pos==CurrentMods[6] then (InitPosCommand[6])(self);
						elseif	pos==CurrentMods[7] then (InitPosCommand[7])(self);
						else (cmd(finishtweening;diffusealpha,0))(self);
						end;

					else
						 (cmd(finishtweening;diffusealpha,0))(self);
					end;

					self:diffusecolor(color("#555555"));
				end;
			end;

			CheckSelectedMessageCommand=function(self,params)
				if params.Player == player then
					self:diffusecolor(color("#555555"));
					--probando con el getProfile y no por el index.
					local skinloop = lifebarSkinList[x];					
					local skinlifebarPlayer = getCustomOptionValuePlayer(player,"lifebarSkin");
					
					if skinlifebarPlayer ~= nil then
						if skinloop ==  skinlifebarPlayer then
							self:diffusecolor(color("#ffffff"));
						end;
					end;

				end;
			end;

		};
	end;

	--estos son los iconos de los mods
	for ind=1,#Titles, 1 do 
	
		if (Titles[ind].name ~= "note skin") then
			--we switch C for the id asign for mods.
			--with this we can switch the pos without much trouble
			--local c = Titles[ind]["indexInArrayModTitles"];
			local c = ind;
			for m=1,#Mods[c], 1 do 
				if (GetCommandTitles()[c].imgfile ~=nil ) then
				
					--t[#t+1] = LoadActor(THEME:GetPathG( "","CommandWindow/"..GetCommandTitles()[c].order.."/"..Mods[c][m].order..".*"))..
					t[#t+1] = LoadActor(THEME:GetPathG( "","CommandWindow/".. GetCommandTitles()[c].imgfile))..
					{
						InitCommand=function(self,params)
							self:y(-110):zoom(0):animate(false);

							if ( Mods[c][m].stateindex ~= nil ) then
								self:setstate(Mods[c][m].stateindex);
							else
								self:setstate( m - 1 );
							end;

							if Mods[c][m].command == "vsmode" then
								if GAMESTATE:GetNumSidesJoined() == 1 then
									self:setstate(Mods[c][m].disablestate);
								end;
							end;
							
							if GAMESTATE:GetGameMode() == 'Rank' then
								if Mods[c][m].disablestate ~= nil then
									self:setstate(  Mods[c][m].disablestate );
								end;
							end;
						end;				
						CommandWindowSelectOptionMessageCommand=function(self,params)
							if params.Player == player then					
								local sTitle = Titles[SelectedTitle].name;
								self:finishtweening():linear(0.125):zoom(.5):y(sTitle == "av" and -84 or -110);
							end;	
						end;
						CommandWindowModCancelMessageCommand=function(self,params)
							if params.Player == player then
								self:finishtweening():linear(0.125):zoom(0);
							end;
						end;
						-- Disabler Icon xd
						RankModeCWMessageCommand=function(self,params)
							if Mods[c][m].disablestate ~= nil then
								self:setstate(  Mods[c][m].disablestate );
							end;
						end;
						ResetIconsCommand=function(self)
							if ( Mods[c][m].stateindex ~= nil ) then
								self:setstate(Mods[c][m].stateindex);
							else
								self:setstate( m - 1 );
							end;
						end;
						FullModeCWMessageCommand=cmd(queuecommand,"ResetIcons");
						CommandWindowResetMessageCommand=function(self,params)
							if params.Player == player then
								self:queuecommand("ResetIcons");
							end;
						end;
						MoveModsMessageCommand=function(self,params)
							if params.Player == player then	
								if SelectedTitle == c then
									self:finishtweening(); --detiene todas las animaciones
									self:stopeffect();	--detiene el reset en caso de

									local initPosCommandProc = InitPosCommand;
									if #Mods[c] < 5 then
										initPosCommandProc = InitPosCommandLess;
									end;

									if Titles[SelectedTitle].name == "sort" or Titles[SelectedTitle].name == "vsmode" then
										(InitPosCommand[4])(self);
									else
										if 	    m==CurrentMods[1] then self:linear(.18);(initPosCommandProc[1])(self);
										elseif 	m==CurrentMods[2] then self:linear(.18);(initPosCommandProc[2])(self);
										elseif 	m==CurrentMods[3] then self:linear(.18);(initPosCommandProc[3])(self);
										elseif 	m==CurrentMods[4] then self:linear(.18);(initPosCommandProc[4])(self); --center
										elseif 	m==CurrentMods[5] then self:linear(.18);(initPosCommandProc[5])(self);
										elseif 	m==CurrentMods[6] then self:linear(.18);(initPosCommandProc[6])(self);
										elseif 	m==CurrentMods[7] then self:linear(.18);(initPosCommandProc[7])(self);
										else (cmd(finishtweening;diffusealpha,0))(self);
										end;
									end;
								else
									 (cmd(finishtweening;diffusealpha,0))(self);
								end;
							end;
						end;
						InitModsMessageCommand=function(self,params)
							if params.Player == player then
								if SelectedTitle == c then
									-- self:finishtweening(); --detiene todas las animaciones
									self:stopeffect();	--detiene el reset en caso de

									local initPosCommandProc = InitPosCommand;
									if #Mods[c] < 5 then
										initPosCommandProc = InitPosCommandLess;
									end;

									if Titles[SelectedTitle].name == "rank" or  Titles[SelectedTitle].name == "sort" or Titles[SelectedTitle].name == "vsmode" then
										(InitPosCommand[4])(self);
									else
										if 	    m==CurrentMods[1] then (initPosCommandProc[1])(self);
										elseif 	m==CurrentMods[2] then (initPosCommandProc[2])(self);
										elseif 	m==CurrentMods[3] then (initPosCommandProc[3])(self);
										elseif 	m==CurrentMods[4] then (initPosCommandProc[4])(self); --center
										elseif 	m==CurrentMods[5] then (initPosCommandProc[5])(self);
										elseif 	m==CurrentMods[6] then (initPosCommandProc[6])(self);
										elseif 	m==CurrentMods[7] then (initPosCommandProc[7])(self);
										else (cmd(finishtweening;diffusealpha,0))(self);
										end;
									end;
								else
									 (cmd(finishtweening;diffusealpha,0))(self);
								end;
							end;
						end;
						CheckSelectedMessageCommand=function(self,params)
							if params.Player == player then
								self:diffusecolor(color("#555555"));
									
								if IsSelected(Mods[c][m], params.Player) then
									self:diffusecolor(color("#ffffff"));
								end;
							end;
						end;
					};
				
				end;

			end;
			
		end;
	end;
end;



return t;
