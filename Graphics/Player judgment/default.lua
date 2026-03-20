--S�E ando usando judge premiere para el themekit �Y qu�E
local player = Var "Player"
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");


--########################################--
--##			JUDGMENT SKIN        	##--
--obtenemos el skin que esta usando el player
local skinSelected = "sanity"; -- por defecto
local zoomSkinSelected = 1; -- entre 1 y 0.
local skinExterno = false; -- si se encuentran en la raiz del juego en la carpeta /judgmentsSkins

--obtenemos y procesamos el nombre del skin para saber si es externo o no.
local skinSelectedProfile = getCustomOptionValuePlayer(player,"judgmentSkin");

--Si por alguna razon, esto esta nil.
if skinSelectedProfile == nil then
	skinSelectedProfile = "i_sanity";
end;

local esExterno = string.find(skinSelectedProfile, "e_");
if esExterno ~= nil then
	skinExterno = true;
end;


--procesamos el nombre del perfil para obtener el nombre limpio.
local skinSelectedProfileProc = string.gsub(skinSelectedProfile, "e_", "");
skinSelectedProfileProc = string.gsub(skinSelectedProfileProc, "i_", "");

--Asignamos el skin
skinSelected = skinSelectedProfileProc;

--Obtenemos el zoom
local zoomSelectedProfile = getCustomOptionValuePlayer(player,"judgmentZoom");

if zoomSelectedProfile ~= nil then
	--asignamos el zoom
	zoomSkinSelected = zoomSelectedProfile / 100; 
end;

--if it have a default.lua we will take that and not use the base lua for the animations and etc...
local skinHasLua = judgmentHasLua(skinSelected,skinExterno);
if skinHasLua ~= "-" then
	local luafilepath = "";
	if skinExterno then
		local judgExternalPath = GetJudgSkinExternalPath();
		luafilepath = judgExternalPath..skinSelected.."/"..skinHasLua;
	else  	 
		local activeTheme = THEME:GetCurThemeName();
		luafilepath = "/Themes/"..activeTheme.."/Graphics/Player judgment/skins/"..skinSelected.."/"..skinHasLua;
	end;				
	return LoadActor(luafilepath){ name=skinSelected,zoom= zoomSkinSelected}
else
	--Trace("#PLAYER JUDGMENT ::: NO TIENE LUA, CONTINUA DEFAULT");
end;


-- File.Write("etc.txt",GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode());
-- blah
--if not getenv then getenv = function() return false end end
local missComboSB = StageBreakCombo();
local extraJudgment = GAMESTATE:GetExtraJudgment();

--frame correspondiente de cada judgment
local TNSframe = {
		TapNoteScore_CheckpointHit = 0;
		TapNoteScore_W1 = 0;
		TapNoteScore_W2 = 0;
		TapNoteScore_W3 = 2;
		TapNoteScore_W4 = 3;
		TapNoteScore_W5 = 4;
		TapNoteScore_Miss = 5;
		TapNoteScore_CheckpointMiss = 5;
}

--frames para RG
local TNSframeReversed = {
		TapNoteScore_CheckpointHit = 5;
		TapNoteScore_W1 = 5;
		TapNoteScore_W2 = 5;
		TapNoteScore_W3 = 3;
		TapNoteScore_W4 = 2;
		TapNoteScore_W5 = 1;
		TapNoteScore_Miss = 0;
		TapNoteScore_CheckpointMiss = 0;
}

if extraJudgment then
	--frame correspondiente de cada judgment
	TNSframe = {
		TapNoteScore_CheckpointHit = 0;
		TapNoteScore_W1 = 0;
		TapNoteScore_W2 = 1;
		TapNoteScore_W3 = 2;
		TapNoteScore_W4 = 3;
		TapNoteScore_W5 = 4;
		TapNoteScore_Miss = 5;
		TapNoteScore_CheckpointMiss = 5;
	}

	--frames para RG
	TNSframeReversed = {
		TapNoteScore_CheckpointHit = 5;
		TapNoteScore_W1 = 5;
		TapNoteScore_W2 = 4;
		TapNoteScore_W3 = 3;
		TapNoteScore_W4 = 2;
		TapNoteScore_W5 = 1;
		TapNoteScore_Miss = 0;
		TapNoteScore_CheckpointMiss = 0;
	}
end

local ynxmode = 0;
local zoomaux=0.5;
local auxvisible=false;



return Def.ActorFrame {
	--init
	InitCommand=function(self)
		local this = self:GetChildren()
		this.judgm:pause();
		
		--this.judgm:y(-35);
		--this.combo:y(42);
		
		this.combo:vertalign(top);
		
		this.judgm:visible(false);
		this.combo:visible(false);
		this.label:visible(false);
		this.netcombo:visible(false);

		--self:runcommandsonleaves(cmd( SetTextureFiltering,false ))
	end;
	--parche
	OnCommand=function(self)
		-- Judgement in Editor
		--local current_screen = SCREENMAN:GetTopScreen():GetName();
		--if current_screen == "ScreenEdit" then
		--	zoomaux = 0.75;
		--end;
	
		self:sleep(1);
		self:queuecommand("MakeVisible");
	end;
	MakeVisibleCommand=function(self)
		auxvisible=true;
	end;

	--judges
	Def.Sprite {
	-- LoadActor("_judgments")..{
		Name="judgm";
		--Texture=spriteJudgmentJudment();
		Texture=getSkinJudgmentTemplateNew("judgments",skinSelected,skinExterno);
		--InitCommand=cmd(diffusealpha,0);
		InitCommand=function(self)
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode() then				
				ynxmode=-50;
				if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Drop() then
					ynxmode=140;
				end;
			else
				ynxmode=60;
			end;
			self:diffusealpha(0):y(-64+ynxmode):zoom(.75);
		end;
		--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-64+ynxmode;linear,.1;zoom,.5;y,-53+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);
		--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-64+ynxmode;linear,.1;zoom,.5;y,-53+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);

		NormalCommand=function(self)
		    local function scale(val)
		        return val * zoomSkinSelected;
		    end

			self:diffusealpha(1);
			self:zoom(scale(.75));
			self:y(scale(-64+ynxmode));
			self:linear(.1);
			self:zoom(scale(0.5));
			self:y(scale(-53+ynxmode));
			self:linear(.3);
			self:diffusealpha(0.8);
			self:sleep(0);
			self:linear(0.3);
			self:diffusealpha(0);
			self:zoomx(scale(1));
			self:zoomy(0);
		end;

	};

	--fast slow
	Def.Sprite {
		Name="extrajudgmtext";
		Texture=getSkinJudgmentTemplateNew("extra",skinSelected,skinExterno);
		InitCommand=function(self)
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode() then				
				ynxmode=-50;
				if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Drop() then
					ynxmode=140;
				end;
			else
				ynxmode=60;
			end;
			self:diffusealpha(0):y(-64+ynxmode):zoom(.75);
		end;
		--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-86+ynxmode;linear,.1;zoom,.5;y,-75+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);
		NormalCommand=function(self)
		    local function scale(val)
		        return val * zoomSkinSelected;
		    end

			self:diffusealpha(1);
			self:zoom(scale(.75));
			self:y(scale(-89+ynxmode));
			self:linear(.1);
			self:zoom(scale(0.5));
			self:y(scale(-78+ynxmode));
			self:linear(.3);
			self:diffusealpha(0.8);
			self:sleep(0);
			self:linear(0.3);
			self:diffusealpha(0);
			self:zoomx(scale(1));
			self:zoomy(0);
		end;
	};	
	
	
	--label
	Def.Sprite {
	-- LoadActor("_combo")..{
		Name="label";
		Texture=getSkinJudgmentTemplateNew("combo",skinSelected,skinExterno);
		--InitCommand=cmd(diffusealpha,0);
		InitCommand=function(self)
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode() then				
				ynxmode=-50;
				if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Drop() then
					ynxmode=140;
				end;
			else
				ynxmode=60;
			end;
			self:diffusealpha(0):y(-25+ynxmode):zoom(.75);
		end;

		--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-25+ynxmode;linear,.1;zoom,.5;y,-26+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);
		NormalCommand=function(self)
		    local function scale(val)
		        return val * zoomSkinSelected;
		    end

			self:diffusealpha(1);
			self:zoom(scale(.75));
			self:y(scale(-25+ynxmode));
			self:linear(.1);
			self:zoom(scale(0.5));
			self:y(scale(-26+ynxmode));
			self:linear(.3);
			self:diffusealpha(0.8);
			self:sleep(0);
			self:linear(0.3);
			self:diffusealpha(0);
			self:zoomx(scale(1));
			self:zoomy(0);
		end;		
	};
	--combo
	Def.BitmapText {
		File = getSkinJudgmentTemplateNew("comboNumber",skinSelected,skinExterno);
		Name="combo";
		InitCommand=function(self)
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode() then				
				ynxmode=-50;
				if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Drop() then
					ynxmode=140;
				end;
			else
				ynxmode=55;
			end;
			self:diffusealpha(0):y(ynxmode):zoom(1.4*zoomaux);
		end;
		--NormalCommand=cmd(diffusealpha,1;zoom,.74;y,-5+ynxmode;linear,.1;zoom,.7;y,-17+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0);
		NormalCommand=function(self)
		    local function scale(val)
		        return val * zoomSkinSelected;
		    end

			self:diffusealpha(1);
			self:zoom(scale(.74));
			self:y(scale(-5+ynxmode));
			self:linear(.1);
			self:zoom(scale(0.7));
			self:y(scale(-17+ynxmode));
			self:linear(.3);
			self:diffusealpha(0.8);
			self:sleep(0);
			self:linear(0.3);
			self:diffusealpha(0);
		end;		
	};
	
	Def.BitmapText {
		File = THEME:GetPathF("","_mpcombo.ini");
		Name="netcombo";
		InitCommand=function(self)
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):NXMode() then				
				ynxmode=-50;
				if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):Drop() then
					ynxmode=140;
				end;
			else
				ynxmode=55;
			end;
			self:diffusealpha(0):y(ynxmode):zoom(1.4*zoomaux);
		end;
		--NormalCommand=cmd(diffusealpha,1;zoom,.74;y,40+ynxmode;linear,.1;zoom,.7;y,28+ynxmode;linear,.3;diffusealpha,.8;sleep,0.09;linear,.3;diffusealpha,0);
		NormalCommand=function(self)
		    local function scale(val)
		        return val * zoomSkinSelected;
		    end

			self:diffusealpha(1);
			self:zoom(scale(.74));
			self:y(scale(40+ynxmode));
			self:linear(.1);
			self:zoom(scale(0.7));
			self:y(scale(28+ynxmode));
			self:linear(.3);
			self:diffusealpha(0.8);
			self:sleep(0.09);
			self:linear(0.3);
			self:diffusealpha(0);
		end;		
	};
	
	--"PERFECT"!
	JudgmentMessageCommand=function(self,param)
		local this = self:GetChildren()
		local iTns = TNSframe[param.TapNoteScore]
		local extraJudgStatus = 1;

		if extraJudgment then
			this.extrajudgmtext:stoptweening();
			this.extrajudgmtext:visible(false);
		end;

		if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Current'):JudgeReverse() then
			iTns = TNSframeReversed[param.TapNoteScore]
		end
		--no player, no job
		if param.Player ~= player then return end
		if param.HoldNoteScore then return end
		if not iTns then return end
		if not auxvisible then return end
		

		-- revisamos si quiere que se muestren los FAST y SLOW.
		local fastslowUi = getCustomOptionValuePlayer(player,"gameplay_fastslow");
		
		if fastslowUi == nil then
			fastslowUi = false;
		end;			

		if fastslowUi then
			if extraJudgment then
				if iTns > 0 and iTns < 5 then
					if param.Early then

						extraJudgStatus = 0;
					end;
					this.extrajudgmtext:animate(false);
					this.extrajudgmtext:visible(true);
					this.extrajudgmtext:stoptweening();
					this.extrajudgmtext:setstate(extraJudgStatus);
					this.extrajudgmtext:queuecommand("Normal");
				end;
			end;			
		end;



		this.judgm:visible(true);
		this.judgm:stoptweening();
		this.judgm:setstate(iTns);
		this.judgm:queuecommand("Normal");
		
	end;

	NetComboMessageCommand=function(self, param)
		local this = self:GetChildren()
		local combo = param.Combo or param.Misses;
		
		if not combo or combo < ShowComboAt then
			return;
		end;
		
		local ccolor;
		if param.Misses then
			ccolor = color("1,.1,.1,1");
		else
			ccolor = color("1,1,1,1");
		end;
		
		this.netcombo:visible( combo > 3 );
		this.netcombo:stoptweening();
		this.netcombo:settextf("%03i", combo);
		this.netcombo:diffuse(ccolor);
		this.netcombo:queuecommand("Normal");
	end;
	

	ComboCommand=function(self,param)

		local this = self:GetChildren()
		local combo = param.Misses or param.Combo;
		
		if not combo or combo < ShowComboAt then
			this.combo:visible(0);
			this.label:visible(0);
			return;
		end;
		
		if not auxvisible then return end
		--color misses o RG
		local ccolor
		if param.Misses then
			ccolor = color("1,.1,.1,1");
			--GradeReverse, combo misses no rojo
			--puedes cambiar userprefs por getenv
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Current' ):JudgeReverse() then
				ccolor = color("1,1,1,1");
			end
		else
			ccolor = color("1,1,1,1");
			--GradeReverse, combo rojo
			if GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Current' ):JudgeReverse() then
				ccolor = color("1,.1,.1,1");
			end
		end;
		
		this.combo:visible(combo >= 4);
		this.combo:stoptweening();
		this.combo:settextf("%03i",combo);
		this.combo:diffuse(ccolor);
		this.combo:queuecommand("Normal");

		this.label:visible(combo >= 4);
		this.label:stoptweening();
		this.label:diffuse(ccolor);
		this.label:queuecommand("Normal");	

	end;
}