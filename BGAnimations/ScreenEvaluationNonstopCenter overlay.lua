local t = Def.ActorFrame{
		CodeMessageCommand=function(self, params)
			

			if GAMESTATE:GetNumSidesJoined() == 2 then
				if params.Name == "Center" then
					self:GetChild("Out"):linear(0.15):diffusealpha(1);
					self:sleep(0.2);
					self:queuecommand("ChangeScreen");
				end;
			else
				local masterPlayer = GAMESTATE:GetMasterPlayerNumber();
				if params.PlayerNumber == masterPlayer and params.Name == "Center" then
					self:GetChild("Out"):linear(0.15):diffusealpha(1);
					self:sleep(0.2);
					self:queuecommand("ChangeScreen");
				end;
			end;

		end;

		ChangeScreenCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			screen:SetNextScreenName("ScreenSelectMusic");
			screen:StartTransitioningScreen("SM_GoToNextScreen");
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

		FinalizedMessageCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;	
};



t[#t+1] = LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/BG") )..{
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y);
			self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
		OffCommand=function(self)
			self:stoptweening():linear(0.15):diffusealpha(0);
		end;
};

t[#t+1] =  LoadActor(THEME:GetPathS("","xsanity/eval/eval_song")) .. {
	OnCommand=cmd(queuecommand,"Lot");
	LotCommand=function(self)
			self:play();
	end;
	FinalizedMessageCommand=function(self)
		self:stop()
	end;		
	OffCommand=function(self)
		self:stop()
	end;
};

t[#t+1] = LoadActor("profile/default")..{};

t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_TOP+20);
			self:zoom(1);
		end;

		LoadFont("_TitleXolonium")..{
			Name="Title_up";
			Text="NONSTOP";
			InitCommand=cmd(zoom,1);
		};
		LoadFont("_TitleXolonium")..{
			Name="Title_down";
			Text="RESULT";
			InitCommand=cmd(zoom,0.5;y,25);
		};
};

local colorSet = 
{
	single = color("#f50202"),
	double = color("#02f504"),
	singleperformance = color("#9808c0"),
	doubleperformance = color("#0e66b8"),
	halfdouble = color("#029c7d"),
	coop = color("#B45F04"),
	questdisable = color ("#1B5E20")
};

local function GetBannerSong(song)		
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


function createResultPlayer(player,indexSong)

local xPlayer = 0;
local playerStringDataArray = "";
local passRessSprite="pass_res 1x16";
local isPfc=false;
local isFc=false;
local isEfc=false;
local is2Player = false;
local statusVs = 0;
local vsPosX=0;


if player == PLAYER_1 then
	xPlayer = -200;
	vsPosX=50;
	playerStringDataArray ="NC_player_1_StageData";
	
else
	xPlayer = 205;
	vsPosX=-50;
	playerStringDataArray ="NC_player_2_StageData";
end;

--we get all the things here


local playerStageData = GAMESTATE:Env()["NONSTOPCENTER"][playerStringDataArray][indexSong];
if playerStageData["isFailed"] then
	passRessSprite = "fail_pass_res 1x16";
end;

local scoreBackNumber = getZeroStringFromScore(playerStageData["score"]);


if GAMESTATE:GetNumSidesJoined() == 2 then
	is2Player = true;
	if playerStageData["isWin"] then
		statusVs = 0;
	else
		statusVs = 1;
	end;

	if playerStageData["isDraw"] then
		statusVs = 2;
	end;
end;

return Def.ActorFrame{
	OnCommand=function(self)
		self:x(xPlayer);
	end;

	LoadActor( THEME:GetPathG("","ScreenEvaluation/"..passRessSprite) )..{
			Name="letter";
			OnCommand=function(self)
				self:zoom(0.25);
				self:animate(false);
				self:setstate(playerStageData["gradeId"]);
				self:y(-10);
			end;
	};


	Def.Quad {		
		OnCommand=function(self)
			self:x(-2);
			self:y(30);
			self:zoomto(145,20);
			self:diffuse(color("#4a4a4a"));
			self:fadeleft(0.1);
			self:faderight(0.1);
		end;
	};

	LoadFont("scorebg")..{	
			Name="scoreBackMyBest";
			OnCommand=cmd(queuecommand,"SetPos");
			SetPosCommand=function(self)
				self:diffusecolor(color("#787878"));
				self:zoom(0.5);
				self:horizalign("left");
				self:settext(scoreBackNumber);
				self:y(25);
				self:x(-70);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};

	LoadFont("scorebg")..{	
			Name="scoreFrontMyBest";
			OnCommand=cmd(queuecommand,"SetPos");
			SetPosCommand=function(self)
				self:zoom(0.5);
				self:horizalign("right");
				self:settext(playerStageData["score"]);
				self:y(25);
				self:x(64);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};



	LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/vsresult 1x3") )..{
			Name="vsres";
			OnCommand=function(self)
				self:zoom(0.3);
				self:animate(false);
				self:setstate(statusVs);
				self:y(10);
				self:x(vsPosX);
				self:visible(is2Player);
			end;
	};

	LoadActor( THEME:GetPathG("","ScreenSelectMusic/pfg") )..{
			Name="pfc";
			OnCommand=function(self)
				self:zoom(0.5);
				self:y(0);
				--self:x(60);
				self:visible(playerStageData["isPfc"]);
			end;
	};

	LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullcombo") )..{
			Name="fc";
			OnCommand=function(self)
				self:zoom(0.45);
				self:y(5);
				--self:x(60);
				self:visible(playerStageData["isFc"]);
			end;
	};
	LoadActor( THEME:GetPathG("","ScreenSelectMusic/nomiss") )..{
			Name="efc";
			OnCommand=function(self)
				self:zoom(0.45);
				self:y(5);
				--self:x(60);
				self:visible(playerStageData["isEfc"]);
			end;
	};

	LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/nrecord_label") )..{
			Name="newrecord";
			OnCommand=function(self)
				self:zoom(0.4);
				self:y(42);
				self:visible(playerStageData["isNewRecord"]);
			end;
	};

	LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/autoplay") )..{
			Name="autoplay";
			OnCommand=function(self)
				self:zoom(0.35);
				self:y(-10);		
				self:visible(playerStageData["isAutoPlay"]);		
			end;
	};
};

end;


function createResults()
	local chartPlayed = GAMESTATE:Env()["NONSTOPCENTER"]["NC_Songs"];
	local columnPlace = {-300,300}
	local actualColumn= 1;
	local indexItems = 1;

	local resultActorFrame = Def.ActorFrame{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+5);
			self:zoom(0.9);		

			if #chartPlayed <= 6 then
				self:zoom(1.05);
			end;				
		end;
	};


	for i=1,#chartPlayed do

		local songBase = SONGMAN:GetSongFromSteps(chartPlayed[i]);
		local bannerNewPath = GetBannerSong(songBase);


		local scoreActorFrame= Def.ActorFrame{
			OnCommand=function(self)
				self:diffusealpha(0);
				if i%7 == 0 then
					actualColumn = actualColumn + 1;
					indexItems = 1;
				end;
				local columnObject = columnPlace[actualColumn];
				
				if #chartPlayed <= 6 then
					columnObject = 0;
				end;
				


				self:y(-350 + (100*indexItems-1));		
				self:x(columnObject);

				indexItems = indexItems + 1;

				self:sleep(0.09*(i-1));
				self:x(columnObject-15);
				self:decelerate(0.4);
				self:diffusealpha(1);
				self:x(columnObject);

				self:GetChild("songBanner"):stoptweening():LoadFromCachedBanner(bannerNewPath["bpath"]);
				self:GetChild("groupName"):settext(songBase:GetGroupName());
				self:GetChild("songName"):settext(songBase:GetDisplayMainTitle());
				self:GetChild("artistName"):settext(songBase:GetDisplayArtist());
				self:GetChild("stepName"):settext(chartPlayed[i]:GetChartName());
				self:GetChild("stepArtist"):settext(chartPlayed[i]:GetAuthorCredit());

				local levelText="";
				local levelNumber = chartPlayed[i]:GetMeter();

				if chartPlayed[i]:GetPlayers() ~= 1 then
						levelText = "Cx";
						levelNumber = chartPlayed[i]:GetPlayers(); 
						self:GetChild("songLevelColor"):diffuse(colorSet.coop);
						self:GetChild("backSong"):setstate(4);
				else
					if chartPlayed[i]:GetStepsType() == 'StepsType_Pump_Single' then
						levelText = "S";
						self:GetChild("songLevelColor"):diffuse(colorSet.single);
						self:GetChild("backSong"):setstate(1);
					elseif chartPlayed[i]:GetStepsType() == 'StepsType_Pump_Single_P' then
						levelText = "SP";
						self:GetChild("songLevelColor"):diffuse(colorSet.singleperformance);
						self:GetChild("backSong"):setstate(6);
					elseif chartPlayed[i]:GetStepsType() == 'StepsType_Pump_Halfdouble' then
						levelText = "H";
						self:GetChild("songLevelColor"):diffuse(colorSet.halfdouble);
						self:GetChild("backSong"):setstate(3);
					elseif chartPlayed[i]:GetStepsType() == 'StepsType_Pump_Double' then
						levelText = "D";
						self:GetChild("songLevelColor"):diffuse(colorSet.double);
						self:GetChild("backSong"):setstate(2);
					elseif chartPlayed[i]:GetStepsType() == 'StepsType_Pump_Double_P' then	
						levelText = "DP";
						self:GetChild("songLevelColor"):diffuse(colorSet.doubleperformance);
						self:GetChild("backSong"):setstate(5);
					end;
				end;

				self:GetChild("songLevel"):settext(levelText..levelNumber);
				self:GetChild("songLevelColor"):settext(levelText..levelNumber);


			end;

			--BASE IMAGE
			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/stepBase 1x7") )..{
					Name="backSong";
					OnCommand=function(self)
						self:zoom(0.65);
						self:zoomy(0.75);
						self:animate(false);
					end;
			};

			Def.Quad {		
				OnCommand=function(self)
					self:x(-81);
					self:y(-1);
					self:zoomto(90,64);
					self:diffuse(color("#4a4a4a"));
					--self:fadeleft(0.4);
					--self:faderight(0.4);
				end;
			};

			--BANNER OF THE SONG
			Def.Banner {	
				Name="songBanner";	--banner standard,
				InitCommand=cmd(scaletoclipped,91,64;xy,-81,-1;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			};

			--GROUP
			LoadFont("_myriad pro")..{
				Name="groupName";
				Text="-";
				OnCommand=function(self)
					self:y(-27);
					self:zoom(0.4);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songName";
				Text="-";
				OnCommand=function(self)
					self:y(-16);
					self:zoom(0.4);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};
			LoadFont("_TitleXolonium")..{
				Name="artistName";
				Text="-";
				OnCommand=function(self)
					self:y(-5);
					self:zoom(0.25);
					self:x(-32);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songLevelColor";
				Text="-";
				OnCommand=function(self)
					self:y(15);
					self:zoom(0.85);
					self:x(-30);
					self:horizalign("left");
					self:maxwidth(400);
					
				end;
			};

			LoadFont("_TitleXolonium")..{
				Name="songLevel";
				Text="-";
				OnCommand=function(self)
					self:y(14);
					self:zoom(0.85);
					self:x(-32);

			        self:shadowlength(0.95);
			        self:shadowcolor(0,0,0,1);

					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepName";
				Text="-";
				OnCommand=function(self)
					self:y(5);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(185);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepArtist_option";
				Text="STEP ARTIST:";
				OnCommand=function(self)
					self:y(15);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(400);
				end;
			};

			LoadFont("_myriad pro")..{
				Name="stepArtist";
				Text="-";
				OnCommand=function(self)
					self:y(25);
					self:zoom(0.5);
					self:x(38);
					self:horizalign("left");
					self:maxwidth(185);
				end;
			};



		};

		if GAMESTATE:IsSideJoined(PLAYER_1) then
			--we check if the song exist first.
			local playerStageData = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_1_StageData"][i];
			if playerStageData ~= nil then
				scoreActorFrame[#scoreActorFrame+1] = createResultPlayer(PLAYER_1,i);
			end;
		end;
		if GAMESTATE:IsSideJoined(PLAYER_2) then
			local playerStageData = GAMESTATE:Env()["NONSTOPCENTER"]["NC_player_2_StageData"][i];
			if playerStageData ~= nil then
				scoreActorFrame[#scoreActorFrame+1] = createResultPlayer(PLAYER_2,i);
			end;
		end;

		resultActorFrame[#resultActorFrame+1] = scoreActorFrame;
	end;

	return resultActorFrame;
end;

function createFooter()

	local isSingleRow=false;
	if getNumSongRegisteredNonstopCenter() <= 6 then
		isSingleRow=true;
	end;

	return Def.ActorFrame{
			OnCommand=function(self)
				self:x(SCREEN_CENTER_X);
				self:y(SCREEN_CENTER_Y);

			end;

			Def.ActorFrame{
				OnCommand=function(self)
					self:y(290);
				end;

				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/c_vs_frame") )..{
						Name="vsPlate";
						OnCommand=function(self)
							self:zoom(0.45);
							if isSingleRow then
								self:y(30);
							end;
						end;
				};

				LoadFont("_TitleXolonium")..{
					Name="p1VsStatus";
					Text="11";
					OnCommand=function(self)
						self:zoom(0.6);
						self:x(-75);
						self:horizalign("center");
						self:y(-4);

						if isSingleRow then
							self:y(26);
						end;
						
					end;
				};
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/vsresult 1x3") )..{
						Name="vsresP1";
						OnCommand=function(self)
							self:zoom(0.8);
							self:animate(false);
							self:setstate(2);
							self:x(-285);
							self:y(20);

							if isSingleRow then
								self:x(-400);
							end;
						end;
				};


				LoadFont("_TitleXolonium")..{
					Name="p2VsStatus";
					Text="1";
					OnCommand=function(self)
						self:zoom(0.6);
						self:x(75);
						self:horizalign("center");
						self:y(-4);
						if isSingleRow then
							self:y(26);
						end;
					end;
				};
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/vsresult 1x3") )..{
						Name="vsresP2";
						OnCommand=function(self)
							self:zoom(0.8);
							self:animate(false);
							self:setstate(2);
							self:x(285);
							self:y(20);
							if isSingleRow then
								self:x(400);
							end;
						end;
				};



			};



	};
end;

t[#t+1] = createResults();

if GAMESTATE:GetNumSidesJoined() == 2 then
	t[#t+1] = createFooter();
end;

t[#t+1] = Def.Quad{
	Name="Out";
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
		self:diffuse(color("#000000"));
		self:diffusealpha(0);
	end;
};

return t;