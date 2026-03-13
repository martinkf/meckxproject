return function(args)
	args = args or {}
	local zoomSkinSelected = args.zoom or 1;
	local skinSelected = "newsanity";

	local player = Var "Player"
	local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
	local missComboSB = StageBreakCombo();
	local extraJudgment = GAMESTATE:GetExtraJudgment();
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
			Texture="Judgments 1x6.png";
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


		Def.Sprite {
		-- LoadActor("_judgments")..{
			Name="judgmrainbow";
			--Texture=spriteJudgmentJudment();
			Texture="j_rainbowperfect 4x1";
			Frame0000=0;
			Delay0000=0.025;
			Frame0001=1;
			Delay0001=0.025;
			Frame0002=2;
			Delay0002=0.025;
			Frame0003=3;
			Delay0003=0.025;
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
				self:blend("BlendMode_Add");
				self:diffusealpha(0):y(-64+ynxmode):zoom(.75);
			end;
			--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-64+ynxmode;linear,.1;zoom,.5;y,-53+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);
			--NormalCommand=cmd(diffusealpha,1;zoom,.75;y,-64+ynxmode;linear,.1;zoom,.5;y,-53+ynxmode;linear,.3;diffusealpha,.8;sleep,0;linear,.3;diffusealpha,0;zoomx,1;zoomy,0);

			NormalCommand=function(self)
			    local function scale(val)
			        return val * zoomSkinSelected;
			    end
			    
				self:diffusealpha(0.6);
				self:zoom(scale(.75));
				self:y(scale(-64+ynxmode));
				self:linear(.1);
				self:zoom(scale(0.5));
				self:y(scale(-53+ynxmode));
				self:linear(.3);
				self:diffusealpha(0.4);
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
			Texture="Extra_text 1x2.png";
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
			Texture="Label (doubleres).png";
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
			File = "Combo numbers.ini";
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


			if iTns == 0 then
				this.judgmrainbow:visible(true);
				this.judgmrainbow:stoptweening();
				this.judgmrainbow:queuecommand("Normal");
			else
				this.judgmrainbow:visible(false);
			end;

			this.judgm:stoptweening();
			this.judgm:visible(true);			
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
end;