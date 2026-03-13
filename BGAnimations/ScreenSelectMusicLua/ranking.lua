local t = Def.ActorFrame {}

function getRankList(player)

	local hslist = getAllRankingFromSong(player);
	local hlistProc = {};
	local maxNumRank = 5;
	local procRank = 0;

	local numRankInSistem = #hslist;
	if numRankInSistem > 5 then
		numRankInSistem = 5;
	end;

	for i=1,numRankInSistem do
		local typeLightStatus = "";
		local judgStateRecord = hslist[i]["judgState"];

		if hslist[i]["score"] == 1000000 then
			typeLightStatus = "pfc";
		end;

		if hslist[i]["failed"] == 1 then
			typeLightStatus = "failed";
		end;

		if hslist[i]["failed"] == 0 then
			typeLightStatus = "clear";
		end;	

		table.insert(hlistProc,{guid=hslist[i]["guid"],name=hslist[i]["name"],failed=hslist[i]["failed"],score=hslist[i]["score"],lightStatus=typeLightStatus,judg=judgStateRecord});
	end;

	return hlistProc;
end;

function createRanking()

	local playerActive;

	local xplace = 0;
	local baseZoom = 0.7;

	if GAMESTATE:IsSideJoined(PLAYER_1) then 
		xplace = 320;
		playerActive = PLAYER_1;
	end;
	if GAMESTATE:IsSideJoined(PLAYER_2) then 
		xplace = -320;
		playerActive = PLAYER_2;
	end;



	local rankActor = Def.ActorFrame{

			OnCommand=function(self)
				self:xy(SCREEN_CENTER_X+xplace,SCREEN_CENTER_Y+180);
				self:zoom(baseZoom);
				self:visible(false);

				--here we will check if we need to move the ranking because if the difficulty :s
				local typeOfDifficulty = getCustomOptionValuePlayer(playerActive,"difficultyListMode");
				if typeOfDifficulty == nil or #typeOfDifficulty == 0 then
					self:y(SCREEN_CENTER_Y+150); -- this is the default place
				else
					if typeOfDifficulty == defaultDifficultyListSkin() then
						self:y(SCREEN_CENTER_Y+150);
					elseif typeOfDifficulty == "orbs" then
						self:y(SCREEN_CENTER_Y+185);
					else
						self:y(SCREEN_CENTER_Y+150); -- this is the default place
					end;
				end;
			end;


			UpdateInfoCommand=function(self)
				local topScreen = SCREENMAN:GetTopScreen();				
				local recordsReg = getRankList(playerActive);

				self:GetChild("record_1"):visible(false);
				self:GetChild("record_2"):visible(false);
				self:GetChild("record_3"):visible(false);
				self:GetChild("record_4"):visible(false);
				self:GetChild("record_5"):visible(false);


				if #recordsReg == 0 then
					self:GetChild("nodata"):visible(true);
				else
					self:GetChild("nodata"):visible(false);

					for i = 1, #recordsReg do			
						self:GetChild("record_"..i):visible(true);
						--aca tenemos que actualizar la entrada.

						--lucesita PFC
						if recordsReg[i]["score"] ==  1000000 then
							self:GetChild("record_"..i):GetChild("pfc"):visible(true);
							self:GetChild("record_"..i):GetChild("pfc"):diffusealpha(1);
							self:GetChild("record_"..i):GetChild("pfc"):blend("BlendMode_Add");
							self:GetChild("record_"..i):GetChild("cstatus"):visible(false);
						else
							self:GetChild("record_"..i):GetChild("pfc"):visible(false);
							self:GetChild("record_"..i):GetChild("cstatus"):visible(true);
							--Lucesita
							self:GetChild("record_"..i):GetChild("cstatus"):stoptweening();
							if recordsReg[i]["lightStatus"] == "clear" then
								self:GetChild("record_"..i):GetChild("cstatus"):setstate(1);
								self:GetChild("record_"..i):GetChild("cstatus"):diffusealpha(1);
							elseif recordsReg[i]["lightStatus"] == "failed" then
								self:GetChild("record_"..i):GetChild("cstatus"):setstate(3);
								self:GetChild("record_"..i):GetChild("cstatus"):queuecommand("Ani");
							elseif recordsReg[i]["lightStatus"] == "fc" then
								self:GetChild("record_"..i):GetChild("cstatus"):setstate(2);
							else
								self:GetChild("record_"..i):GetChild("cstatus"):visible(false);
							end;

						end;


						local hsLength = string.len(tostring(recordsReg[i]["score"]));
						local backScore="";
						if (7-hsLength) > 0 then
							for i=1,(7-hsLength) do
								backScore = backScore.."0";
							end;
						end;	


						--Data
						self:GetChild("record_"..i):GetChild("placeRecord"):settext(i);
						self:GetChild("record_"..i):GetChild("scoreBackRecord"):settext(backScore);
						self:GetChild("record_"..i):GetChild("scoreFrontRecord"):settext(recordsReg[i]["score"]);
						self:GetChild("record_"..i):GetChild("nameRecord"):settext(recordsReg[i]["name"]);
						
						--getLetter
						local letterShowRecord = gradeTransformState(recordsReg[i]["score"]);
						self:GetChild("record_"..i):GetChild("LetterRecord"):visible(false);
						self:GetChild("record_"..i):GetChild("failLetterRecord"):visible(false);

						if recordsReg[i]["failed"] == 0 then
							self:GetChild("record_"..i):GetChild("LetterRecord"):setstate(letterShowRecord);
							self:GetChild("record_"..i):GetChild("LetterRecord"):visible(true);
						else
							self:GetChild("record_"..i):GetChild("failLetterRecord"):setstate(letterShowRecord);
							self:GetChild("record_"..i):GetChild("failLetterRecord"):visible(true);
						end;
						
						if recordsReg[i]["judg"] == -1 then
							self:GetChild("record_"..i):GetChild("judgeRecord"):visible(false);
						else
							self:GetChild("record_"..i):GetChild("judgeRecord"):visible(true);
							self:GetChild("record_"..i):GetChild("judgeRecord"):setstate(recordsReg[i]["judg"]);							
						end;


					end;


				end;

			end;


			ChangeStepsMessageCommand=function(self,param)
				local topScreen = SCREENMAN:GetTopScreen();
				if topScreen:GetSelectionState() == "SelectingSteps" then
					self:stoptweening():queuecommand("UpdateInfo");
				end;
			end;

			StepsUnchosenMessageCommand=function(self,param)
				local topScreen = SCREENMAN:GetTopScreen();
				--SelectingSong <- con esto para ocultar.
				if topScreen:GetSelectionState() == "ConfirmSteps" then
						self:stoptweening():queuecommand("UpdateInfo");
				end;

				if topScreen:GetSelectionState() == "SelectingSong" then
					self:stoptweening();
					self:visible(false);
				end;
			end;		

			SongChosenMessageCommand=function(self)
				local topScreen = SCREENMAN:GetTopScreen();
				self:stoptweening();
				self:visible(true);
				self:stoptweening():queuecommand("UpdateInfo");

			end;

			SongUnchosenMessageCommand=function(self)
					self:stoptweening();
					self:visible(false);
			end;

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/ranking/titulo") )..{
				InitCommand=function(self)
					self:zoom(0.4);
				end;
			}
	}

	for i = 1,5 do
		local namePlayer="-";
		local statusClear = "clear";
		rankActor[#rankActor+1] = Def.ActorFrame{
			Name="record_"..i;
			OnCommand=function(self)
			end;

			Def.Sprite {
			-- LoadActor("_judgments")..{
				Name="pfc";
				--Texture=spriteJudgmentJudment();
				Texture= THEME:GetPathG("","ScreenSelectMusic/ranking/cstatus");
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
					self:diffusealpha(1):zoom(.75);
					self:y(0);
					self:addy(38*i);
					self:x(-176);					
					self:zoom(0.65);		
					self:visible(false);
				end;
			};

			LoadActor(THEME:GetPathG("","ScreenSelectMusic/ranking/cstatus"))..{
				Name="cstatus";
				OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
				SetLetterCommand=function(self)
					if statusClear == "pfc" then
						self:visible(false);
					else
						self:diffusealpha(1):zoom(.75);
						self:y(0);
						self:addy(38*i);
						self:x(-176);					
						self:zoom(0.65);

						if statusClear == "fail" then
							self:setstate(3);
							self:queuecommand("Ani");
						elseif statusClear == "clear" then
							self:setstate(1);
						elseif statusClear == "fc" then
							self:setstate(2);
						end;
					end;

				end;

				AniCommand=function(self)
					self:diffusealpha(0);
					self:linear(0.04);
					self:diffusealpha(1);
					self:linear(0.04);
					self:diffusealpha(0);
					self:linear(0.04);
					self:diffusealpha(1);
					self:linear(0.04);
					self:diffusealpha(0);
					self:linear(0.04);
					self:diffusealpha(1);
					self:queuecommand("Ani");					
				end;

				FinalizedMessageCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;	
				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
			};	



			LoadActor( THEME:GetPathG("","CommandWindow/Icons07 17x1") )..{
					Name="judgeRecord";
					InitCommand=function(self)
						self:animate(false);
						self:zoom(0.4);
						self:addx(198);
						self:addy(38*i);
						self:setstate(2);
						self:visible(false);
					end;
			};
 

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/ranking/base") )..{
					Name="baseRecord";
					InitCommand=function(self)
						self:zoom(0.65);
						self:addy(38*i);
					end;
			};

			LoadFont("_TitleXolonium")..{	
					Name="placeRecord";
					OnCommand=cmd(queuecommand,"SetPos");
					SetPosCommand=function(self)
						self:y(-2);
						self:addy(38*i);
						self:x(-155);						
						self:zoom(0.6);
						self:horizalign("center");
						self:settext(i+7);

					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};	

			LoadFont("_TitleXolonium")..{	
					Name="nameRecord";
					OnCommand=cmd(queuecommand,"SetPos");
					SetPosCommand=function(self)
						self:y(-2);
						self:addy(38*i);
						self:x(-85);						
						self:zoom(0.5);
						self:horizalign("center");
						local recortado = string.sub(namePlayer, 1, 8)
						self:settext(recortado);

					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};			

			LoadFont("scorebg")..{	
					Name="scoreBackRecord";
					OnCommand=cmd(queuecommand,"SetPos");
					SetPosCommand=function(self)
						self:y(-6);
						self:addy(38*i);
						self:x(-23);
						self:diffusecolor(color("#787878"));
						self:zoom(0.5);
						self:horizalign("left");
						self:settext("0000000");
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};	

			LoadFont("scorebg")..{	
					Name="scoreFrontRecord";
					OnCommand=cmd(queuecommand,"SetPos");
					SetPosCommand=function(self)
						self:y(-6);
						self:addy(38*i);
						self:x(110);
						self:zoom(0.5);
						self:horizalign("right");
						self:settext("000");
					end;
					FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};

			LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
				Name="LetterRecord";
				OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
				SetLetterCommand=function(self)
					self:y(1);
					self:addy(38*i);
					self:x(145);					
					self:zoom(0.16);
					self:setstate(15);
					self:visible(false);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};

			LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
				Name="failLetterRecord";
				OnCommand=cmd(animate,false;setstate,0;queuecommand,"SetLetter");
				SetLetterCommand=function(self)
					self:y(1);
					self:addy(38*i);
					self:x(145);					
					self:zoom(0.16);
					self:setstate(15);	
					self:visible(false);
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};			

		};
	end;

	rankActor[#rankActor+1] = Def.ActorFrame{
		Name="nodata";
		OnCommand=function(self)
			self:y(38);
			self:visible(false);
		end;

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/ranking/base") )..{
				Name="baseRecord";
				InitCommand=function(self)
					self:zoom(0.65);
				end;
		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/ranking/warning") )..{
				Name="baseRecord";
				InitCommand=function(self)
					self:zoom(0.65);
				end;
		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/ranking/nodata") )..{
				Name="baseRecord";
				InitCommand=function(self)
					self:zoom(0.65);
				end;
		};
	};



	return rankActor;

end;


t[#t+1] = createRanking();

return t;