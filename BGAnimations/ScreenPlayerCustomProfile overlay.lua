local t = Def.ActorFrame {};

local arrAvatars = GAMESTATE:GetAvatarFolder();
local arrSkinsUsb = GAMESTATE:GetSkinUsbFolder();
local arrDifficultyListPlugins = getDificultyListPlugins();

local optPlayerActive = {1,1};
local optEntered = {false,false};
local optExitReady = {false,false};

local avatarPlayerSelectedIndex = {"",""};
local tempAvatarPlayerSelectedIndex = {"",""};

local backgroundPlayerSelectedIndex = {"",""};
local tempBackgroundPlayerSelectedIndex = {"",""};

local pathDiffListPlugins = getPathDifficultyListPlugins();
local difficultyListSelectedIndex = {"",""};
local tempDifficultyListSelectedIndex = {"",""};


local dataOptions=
{
	{order="1",name="banner",index=1,imgfile="text_opt_1.png",active=true,exit=false,lang_en="Select your profile banner",lang_es="Selecciona el banner de tu perfil",lang_pt="Selecione o banner para o seu perfil"},
	{order="2",name="background",index=2,imgfile="text_opt_2.png",active=true,exit=false,lang_en="Select your background profile",lang_es="Selecciona el fondo de tu perfil",lang_pt="Selecione o fundo do seu perfil"},
	{order="3",name="difficulty",index=3,imgfile="text_opt_3.png",active=true,exit=false,lang_en="Select your profile’s difficulty list type",lang_es="Selecciona el tipo de lista de difficultad para tu perfil",lang_pt="Selecione o tipo de lista de dificuldade para o seu perfil"},
	{order="4",name="cover",index=4,imgfile="text_opt_4.png",active=false,exit=false,lang_en="",lang_es="",lang_pt=""},
	{order="5",name="exit",index=5,imgfile="text_opt_5.png",active=true,exit=true,lang_en="Save and exit",lang_es="Guardar y salir",lang_pt="Save and exit"},
};

local avatar_list= {};
local background_list= {};

--avatars 
for i=1,#arrAvatars do
	table.insert(avatar_list, {file=arrAvatars[i], display_name="Avatar " .. i } );
end;

--backgrounds
for i=1,#arrSkinsUsb do
	table.insert(background_list, {file=arrSkinsUsb[i], display_name="Background " .. i } );
end;


function getLangActive()
	local langGame = gLANG();
	local langSelected = "en";
	if langGame == "" then
		langSelected = "es";
	elseif langGame == "EN" then
		langSelected = "en"
	elseif langGame == "PT" then
		langSelected = "pt";
	else
		langSelected = "en"
	end;

	return langSelected;
end;

function createProfileEditor(player)

	local optIndexPlayer = 1;
	if player == PLAYER_1 then
		optIndexPlayer = 1;
	else
		optIndexPlayer = 2;
	end;

	local xBase=0;
	local yBase=SCREEN_CENTER_Y+20;	
	local zoomBase=1;

	if player == PLAYER_1 then
		xBase = SCREEN_CENTER_X - 300;
	else
		xBase = SCREEN_CENTER_X + 300;
	end;

	--arrow Positions
	local arrLX=-170;
	local arrRX=170;

	--preview Y base
	local yPreviewProfile = -250;

	--header Options
	local zoomHeaderOptions=0.4;
	local xHoptions = -155;
	local yHoptions = -184;
	local xHmarginOptions=78;

	return Def.ActorFrame {

		OnCommand=function(self)
			self:x(xBase);
			self:y(yBase);
			self:zoom(zoomBase);
			local langSelected = getLangActive();

			--we load the default things for the preview
			local this = self:GetChildren();

			this.descOptions:settext(dataOptions[1]["lang_"..langSelected]);
			this.avatarImg:Load(THEME:GetPathG("","profiles/base_profile.png"));
			this.backgroundImg:Load(THEME:GetPathG("","profiles/b_guest_1.png"));

			--now we load everything from the player.
			local profile = PROFILEMAN:GetProfile(player);
			local avatarProfile = profile:GetAvatarFile();
			local backgroundProfile = profile:GetSkinUsbFile();
			local profileName = profile:GetDisplayName();

			--Text Name preview
			this.textPlayerName:settext(profileName);



			--Banner preview
			--we save to a global because we will use this data later.
			for i=1,#avatar_list do
				if avatar_list[i]["file"] == avatarProfile then
					avatarPlayerSelectedIndex[optIndexPlayer] = i;
					tempAvatarPlayerSelectedIndex[optIndexPlayer] = i;
				end;
			end;


			--Background preview
			for i=1,#background_list do
				if background_list[i]["file"] == backgroundProfile then
					backgroundPlayerSelectedIndex[optIndexPlayer] = i;
					tempBackgroundPlayerSelectedIndex[optIndexPlayer] = i;
				end;
			end;


			--Difficulty preview
			local diffListPlayer = getCustomOptionValuePlayer(player,"difficultyListMode");
			local defaultIdDiffList = 1;
			local difListOk=false;

			if diffListPlayer == nil or #diffListPlayer == 0 then
				diffListPlayer = defaultDifficultyListSkin();
			end;

			for i=1,#arrDifficultyListPlugins do

				if arrDifficultyListPlugins[i] == defaultDifficultyListSkin() then
					defaultIdDiffList = i;
				end;

				if arrDifficultyListPlugins[i] == diffListPlayer then
					difficultyListSelectedIndex[optIndexPlayer] = i;
					tempDifficultyListSelectedIndex[optIndexPlayer] = i;
					difListOk = true;
				end;

			end;
			if difListOk == false then
					difficultyListSelectedIndex[optIndexPlayer] = defaultIdDiffList;
					tempDifficultyListSelectedIndex[optIndexPlayer] = defaultIdDiffList;
			end;

			this.difficultyListActor:GetChild("nomDiffPlugin"):settext(diffListPlayer);


			


			--this.difficultyListActor:GetChild("previewDiff"):Load();


			--Cover (titles)


			--task
			self:queuecommand("reloadAvatar");
			self:queuecommand("reloadBackground");
			self:queuecommand("reloadDiffList");

		end;

		reloadDiffListCommand=function(self)		
			local this = self:GetChildren();
			local nomPlugin = arrDifficultyListPlugins[difficultyListSelectedIndex[optIndexPlayer]];
			local finalPath = pathDiffListPlugins..nomPlugin.."/preview.png";
			if FILEMAN:DoesFileExist(finalPath) then
				this.difficultyListActor:GetChild("previewDiff"):Load(finalPath);
			else
				this.difficultyListActor:GetChild("previewDiff"):Load(pathDiffListPlugins.."nopreview.png");
			end;
			this.difficultyListActor:GetChild("nomDiffPlugin"):settext(nomPlugin);

		end;

		reloadOptionDiffListCommand=function(self)
			local this = self:GetChildren();
			local nomPlugin = arrDifficultyListPlugins[tempDifficultyListSelectedIndex[optIndexPlayer]];
			local finalPath = pathDiffListPlugins..nomPlugin.."/preview.png";
			if FILEMAN:DoesFileExist(finalPath) then
				this.difficultyListActor:GetChild("previewDiff"):Load(finalPath);
			else
				this.difficultyListActor:GetChild("previewDiff"):Load(pathDiffListPlugins.."nopreview.png");
			end;
			this.difficultyListActor:GetChild("nomDiffPlugin"):settext(nomPlugin);
			
		end;		

		reloadAvatarCommand=function(self)
				local this = self:GetChildren();

				if avatar_list[avatarPlayerSelectedIndex[optIndexPlayer]] == nil then
						this.avatarImg:Load(THEME:GetPathG("","profiles/base_profile.png"));					
						this.AvatarActor:GetChild("avatarOptionImage"):Load(THEME:GetPathG("","profiles/base_profile.png"));
						tempAvatarPlayerSelectedIndex[optIndexPlayer] = 1;
				else
					local fileAvatar = avatar_list[avatarPlayerSelectedIndex[optIndexPlayer]]["file"];
					if (FILEMAN:DoesFileExist("/Avatars/" .. fileAvatar)) then
						this.avatarImg:Load("/Avatars/" .. fileAvatar);
						this.AvatarActor:GetChild("avatarOptionImage"):Load("/Avatars/" .. fileAvatar);
					else
						this.avatarImg:Load(THEME:GetPathG("","profiles/base_profile.png"));					
						this.AvatarActor:GetChild("avatarOptionImage"):Load(THEME:GetPathG("","profiles/base_profile.png"));					
					end;
				end;


				this.avatarImg:scaletoclipped(100,100);					
				this.avatarImg:zoom(0.65);
		end;


		reloadBackgroundCommand=function(self)
			local this = self:GetChildren();
			local fileBackground = background_list[backgroundPlayerSelectedIndex[optIndexPlayer]]["file"];

			if fileBackground == "0_blank.png" then
				this.backgroundImg:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
				this.BackgroundActor:GetChild("backgroundOption"):Load(THEME:GetPathG("","profiles/b_guest_1.png"));

			else
				-- if we encounter a file with the _video thing, we will asume there is a mp4 file with the same name
				if string.find(fileBackground, "_video%.png") then
					local videoFile = string.gsub(fileBackground, ".png", ".mp4");
					if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
						this.backgroundImg:Load("/UsbSkins/" .. videoFile);
						this.backgroundImg:play();
						--this only need to apply when it's the same on the preview.
						this.backgroundImg:rate(0.5);

						this.BackgroundActor:GetChild("backgroundOption"):Load("/UsbSkins/" .. videoFile);
						this.BackgroundActor:GetChild("backgroundOption"):play();

						--this only need to apply when it's the same on the preview.
						this.BackgroundActor:GetChild("backgroundOption"):rate(0.5);
					else
						this.backgroundActor:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						this.backgroundActorPreview:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
					end;							
				else
					if FILEMAN:DoesFileExist("/UsbSkins/" .. fileBackground) then
						this.backgroundImg:Load("/UsbSkins/" .. fileBackground);
						this.BackgroundActor:GetChild("backgroundOption"):Load("/UsbSkins/" .. fileBackground);
					else
						this.backgroundImg:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
						this.BackgroundActor:GetChild("backgroundOption"):Load(THEME:GetPathG("","profiles/b_guest_1.png"));
					end;
				end;
			end;
		end;

		--this reload only the graphic on the option, not the preview
		reloadBackgroundOptionCommand=function(self)
			local this = self:GetChildren();
			local fileBackground = background_list[tempBackgroundPlayerSelectedIndex[optIndexPlayer]]["file"];

			if fileBackground == "0_blank.png" then
				this.BackgroundActor:GetChild("backgroundOption"):Load(THEME:GetPathG("","profiles/b_guest_1.png"));
			else
				-- if we encounter a file with the _video thing, we will asume there is a mp4 file with the same name
				if string.find(fileBackground, "_video%.png") then
					local videoFile = string.gsub(fileBackground, ".png", ".mp4");
					if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
						this.BackgroundActor:GetChild("backgroundOption"):Load("/UsbSkins/" .. videoFile);
						this.BackgroundActor:GetChild("backgroundOption"):play();

						--this only need to apply when it's the same on the preview.	
						if tempBackgroundPlayerSelectedIndex[optIndexPlayer] == backgroundPlayerSelectedIndex[optIndexPlayer] then
							this.BackgroundActor:GetChild("backgroundOption"):rate(0.5);
							this.backgroundImg:rate(0.5);
						else
							this.BackgroundActor:GetChild("backgroundOption"):rate(1);	
							this.backgroundImg:rate(1);
						end;
						
					else
						this.backgroundActorPreview:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
					end;							
				else
					if FILEMAN:DoesFileExist("/UsbSkins/" .. fileBackground) then
						this.BackgroundActor:GetChild("backgroundOption"):Load("/UsbSkins/" .. fileBackground);
					else
						this.BackgroundActor:GetChild("backgroundOption"):Load(THEME:GetPathG("","profiles/b_guest_1.png"));
					end;
				end;
			end;
		end;


		--BANNER - BACKGROUND PREVIEW::
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt.png") )..{
			OnCommand=function(self)
				self:x(32);
				self:y(yPreviewProfile);	
				self:zoom(0.6);			
				self:scaletoclipped(338,65);
			end;
		};	
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt.png") )..{
			Name="backgroundImg";
			OnCommand=function(self)
				self:x(32);
				self:y(yPreviewProfile);	
				self:zoom(0.6);			
				self:scaletoclipped(338,66);
			end;
		};
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_banner_opt.png") )..{
			OnCommand=function(self)
				self:zoom(0.45);
				self:x(-168);
				self:y(yPreviewProfile);
			end;
		};	
		LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/back_banner_opt.png"))..{
			Name="avatarImg";
			OnCommand=function(self)				
				self:scaletoclipped(100,100);
				self:zoom(0.65);
				self:x(-168);
				self:y(yPreviewProfile);
			end;
		};		

		LoadFont("_XoloPlayer")..{
			Name="textPlayerName";
			OnCommand=cmd(shadowlength,1;shadowcolor,0,0,0,1;horizalign,left;y,yPreviewProfile-20;x,-120);
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




		--BACK OPT MENU
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/base.png") )..{
			OnCommand=function(self)
				self:zoom(0.6);
			end;
		};			

		--HEADER OPTIONS
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/opt 1x5") )..{
			Name="hoption1";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(0);
				self:zoom(zoomHeaderOptions);
				self:y(yHoptions);
				self:x(xHoptions+(xHmarginOptions*0));
				self:diffusealpha(1);
			end;
		};	

		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/opt 1x5") )..{
			Name="hoption2";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(1);
				self:zoom(zoomHeaderOptions);
				self:y(yHoptions);
				self:x(xHoptions+(xHmarginOptions*1));
				self:diffusealpha(0.4);
			end;
		};	

		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/opt 1x5") )..{
			Name="hoption3";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(2);
				self:zoom(zoomHeaderOptions);
				self:y(yHoptions);
				self:x(xHoptions+(xHmarginOptions*2));
				self:diffusealpha(0.4);
			end;
		};	
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/opt 1x5") )..{
			Name="hoption4";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(3);
				self:zoom(zoomHeaderOptions);
				self:y(yHoptions);
				self:x(xHoptions+(xHmarginOptions*3));
				self:diffusealpha(0);
			end;
		};	
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/opt 1x5") )..{
			Name="hoption5";
			OnCommand=function(self)
				self:animate(false);
				self:setstate(4);
				self:zoom(zoomHeaderOptions);
				self:y(yHoptions);
				self:x(xHoptions+(xHmarginOptions*4));
				self:diffusealpha(0.4);
			end;
		};

		--CENTER TEXT OF OPTIONS.

		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/ws_arrow_to_left.png") )..{
			Name="arrLeft";
			OnCommand=function(self)
				self:zoom(0.6);
				self:x(arrLX);
			end;
		};	
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/ws_arrow_to_left.png") )..{
			Name="arrRight";
			OnCommand=function(self)
				self:rotationy(180);
				self:zoom(0.6);
				self:x(arrRX);
			end;
		};	

		Def.Sprite{
			Name="optTextName";
			OnCommand=function(self)
			 	self:zoom(0.8);		
				self:Load(THEME:GetPathG("","ScreenPlayerProfileCustom/"..dataOptions[optPlayerActive[optIndexPlayer]]["imgfile"]));
			end;
		};

		--READY
		LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/ReadyPlayer.png") )..{
			Name="readyPlayer";
			OnCommand=function(self)
				self:zoom(0.6);
				self:y(170);
				self:diffusealpha(0);
			end;
		};	

		--description
		LoadFont("_myriad pro")..{
			Name="descOptions";
			--OnCommand=cmd(shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;y,130;x,0;settext,"Probando la descripcion de texto");
			OnCommand=function(self)
		        self:wrapwidthpixels(380)  -- Limita el ancho en píxeles donde el texto se ajustará automáticamente.
		        self:maxheight(100)        -- Establece el máximo espacio vertical que puede ocupar el texto.
		        self:vertspacing(-2) 
		        self:shadowlength(1);
		        self:shadowcolor(0,0,0,1);
		        self:horizalign(center);
		        self:y(140);
		        self:x(0);
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


		-- opt 1 banners
		Def.ActorFrame {
			Name="AvatarActor";
			OnCommand=function(self)
				self:visible(false);
			end;

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/back_banner_opt_selected.png"))..{
				Name="selectedBannerImage";
				OnCommand=function(self)				
					self:scaletoclipped(151,151);			
				end;
			};	

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/back_banner_opt.png"))..{
				Name="avatarOptionImage";
				OnCommand=function(self)				
					self:scaletoclipped(145,145);			
				end;
			};	

		};

		-- opt 2 backgrounds
		Def.ActorFrame {
			Name="BackgroundActor";
			OnCommand=function(self)
				self:visible(false);
			end;

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt_selected.png") )..{
				Name="selectedBackgroundOption";
				OnCommand=function(self)	
					self:scaletoclipped(288,58);
					self:y(-2);
				end;
			};

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt.png") )..{
				Name="backgroundOption";
				OnCommand=function(self)	
					self:scaletoclipped(280,50);
					self:y(-2);
				end;
			};
		};

		-- opt 3 difficulty actors
		Def.ActorFrame {
			Name="difficultyListActor";
			OnCommand=function(self)
				self:visible(false);
			end;

			LoadActor( THEME:GetPathG("","ScreenPlayerProfileCustom/back_background_opt_selected.png") )..{
				Name="selectedDiffPlugin";
				OnCommand=function(self)	
					self:scaletoclipped(140,20);
					self:y(-98);
				end;
			};

			LoadFont("_TitleXolonium")..{
						Name="nomDiffPlugin";
						Text="-";
						OnCommand=function(self)
							self:y(-100);
							self:zoom(0.6);
						end;
			};

			Def.Sprite{
				Name="previewDiff";
				OnCommand=function(self)
				 	self:zoom(0.8);
				 	self:y(20);
				 	self:scaletoclipped(250,250);
				end;
			};
		};

		--action arrows (corners)
		Def.ActorFrame {
			Name="actionSpritesFrame";
			OnCommand=function(self)
				self:visible(true);
				self:zoom(0.65);
			end;

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/actions"))..{
				Name="uplAction";
				OnCommand=function(self)	
					self:animate(false);
					self:setstate(0);
					self:x(-270);
					self:y(-235);
					self:diffusealpha(0);
				end;
			};	

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/actions"))..{
				Name="uprAction";
				OnCommand=function(self)	
					self:animate(false);
					self:setstate(1);
					self:x(270);
					self:y(-235);
					self:diffusealpha(0);
				end;
			};	

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/actions"))..{
				Name="dlAction";
				OnCommand=function(self)	
					self:animate(false);
					self:setstate(2);
					self:x(-270);
					self:y(270);
				end;
			};

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/actions"))..{
				Name="drAction";
				OnCommand=function(self)	
					self:animate(false);
					self:setstate(3);
					self:x(270);
					self:y(270);
				end;
			};

			Def.Sound {
			    Name = "setSound";
			    File = THEME:GetPathS("", "sfx/set");
			    OnCommand=function(self)

			    end;
			};

			Def.Sound {
			    Name = "moveSound";
			    File = THEME:GetPathS("", "sfx/move");
			    OnCommand=function(self)
			    end;
			};

			Def.Sound {
			    Name = "changeSound";
			    File = THEME:GetPathS("", "sfx/change");
			    OnCommand=function(self)
			    end;
			};

			Def.Sound {
			    Name = "outSound";
			    File = THEME:GetPathS("", "sfx/inout");
			    OnCommand=function(self)
			    end;
			};

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/screenjoin_text"))..{
				OnCommand=cmd(xy,0,295;);
				FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
				OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);			
			};	

			LoadActor(THEME:GetPathG("","ScreenPlayerProfileCustom/screenjoin_center"))..{
				OnCommand=cmd(xy,0,275;zoom,1;queuecommand,"Animate");
				AnimateCommand=function(self)
					self:linear(0.5);
					self:y(275);
					self:linear(0.5);
					self:y(276);
					self:queuecommand("Animate");
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

		};


		CodeMessageCommand=function(self, params)

			local this = self:GetChildren();
			if params.PlayerNumber == player and params.Name == "Center" then

				if optEntered[optIndexPlayer] then					
					this.actionSpritesFrame:GetChild("setSound"):stoptweening():stop():play();
					--inside options
					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "banner" then
						--we select this option.
						avatarPlayerSelectedIndex[optIndexPlayer] = tempAvatarPlayerSelectedIndex[optIndexPlayer];
						this.AvatarActor:GetChild("selectedBannerImage"):stoptweening():linear(0.05):diffusealpha(1);
						self:queuecommand("reloadAvatar");
					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "background" then
						--we select this option.
						backgroundPlayerSelectedIndex[optIndexPlayer] = tempBackgroundPlayerSelectedIndex[optIndexPlayer];
						this.BackgroundActor:GetChild("selectedBackgroundOption"):stoptweening():linear(0.05):diffusealpha(1);
						self:queuecommand("reloadBackground");
					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "difficulty" then
						 difficultyListSelectedIndex[optIndexPlayer] = tempDifficultyListSelectedIndex[optIndexPlayer];
						 this.difficultyListActor:GetChild("selectedDiffPlugin"):diffusealpha(1);
					end;


				else
					--exit
					if dataOptions[optPlayerActive[optIndexPlayer]]["exit"] then
						optExitReady[optIndexPlayer] = true;
						this.readyPlayer:diffusealpha(1);


						--we check if both players are ready to exit, if there is one player, we just exit lol
						if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2)  then

							if optExitReady[1] and optExitReady[2] then
								--save and everything
								self:stoptweening();

								--save and exit
								local profilePlayerP1 = PROFILEMAN:GetProfile(PLAYER_1);
								local fileAvatarP1 = avatar_list[avatarPlayerSelectedIndex[1]]["file"];
								local fileBackgroundP1 = background_list[backgroundPlayerSelectedIndex[1]]["file"];
								profilePlayerP1:SetAvatarFile(fileAvatarP1);
								profilePlayerP1:SetSkinUsbFile(fileBackgroundP1);
								PROFILEMAN:SaveProfile(PLAYER_1);

								local profilePlayerP2 = PROFILEMAN:GetProfile(PLAYER_2);
								local fileAvatarP2 = avatar_list[avatarPlayerSelectedIndex[2]]["file"];
								local fileBackgroundP2 = background_list[backgroundPlayerSelectedIndex[2]]["file"];
								profilePlayerP2:SetAvatarFile(fileAvatarP2);
								profilePlayerP2:SetSkinUsbFile(fileBackgroundP2);
								PROFILEMAN:SaveProfile(PLAYER_2);

								local diffListTypeP1 = arrDifficultyListPlugins[difficultyListSelectedIndex[1]];
								setCustomOptionValuePlayer(PLAYER_1,"difficultyListMode",diffListTypeP1);

								local diffListTypeP2 = arrDifficultyListPlugins[difficultyListSelectedIndex[2]];
								setCustomOptionValuePlayer(PLAYER_2,"difficultyListMode",diffListTypeP2);

								SOUND:PlayOnce(THEME:GetPathS("Common", "Start"));
								SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
							end;
						else
							self:stoptweening();
							--save and exit

							local profilePlayer = PROFILEMAN:GetProfile(player);
							--obtenemos el skin y el background.
							local fileAvatar = avatar_list[avatarPlayerSelectedIndex[optIndexPlayer]]["file"];
							local fileBackground = background_list[backgroundPlayerSelectedIndex[optIndexPlayer]]["file"];
							profilePlayer:SetAvatarFile(fileAvatar);
							profilePlayer:SetSkinUsbFile(fileBackground);
							PROFILEMAN:SaveProfile(player);


							local diffListType = arrDifficultyListPlugins[difficultyListSelectedIndex[optIndexPlayer]];
							setCustomOptionValuePlayer(player,"difficultyListMode",diffListType);

							SOUND:PlayOnce(THEME:GetPathS("Common", "Start"));
							SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
						end;
					else
						--options.

						this.actionSpritesFrame:GetChild("uplAction"):stoptweening():linear(0.05):diffusealpha(1);
						this.actionSpritesFrame:GetChild("uprAction"):stoptweening():linear(0.05):diffusealpha(1);
						this.actionSpritesFrame:GetChild("changeSound"):stoptweening():stop():play();

						-- we move the title to the top when we enter a option.
						-- and we enter the the option.
						optEntered[optIndexPlayer] = true;
						this.optTextName:stoptweening();
						this.optTextName:linear(0.05):y(-150);

						if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "banner" then
							this.AvatarActor:visible(true);
						end;

						if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "background" then
							this.BackgroundActor:visible(true);
						end;

						if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "difficulty" then
							this.difficultyListActor:visible(true);
						end;

					end;
				end;

			end;

			if params.PlayerNumber == player and params.Name == "UpRight" then
				this.actionSpritesFrame:GetChild("uprAction"):stoptweening():linear(0.05):zoom(1.1):linear(0.05):zoom(1);
				--we are in a option, we need to exit and move everything to their place.
				if optEntered[optIndexPlayer] then
					this.actionSpritesFrame:GetChild("outSound"):stoptweening():stop():play();
					optEntered[optIndexPlayer] = false;
					this.optTextName:stoptweening();
					this.optTextName:linear(0.05):y(0);
					self:queuecommand("hideAllOption");

					this.actionSpritesFrame:GetChild("uplAction"):linear(0.05):diffusealpha(0);
					this.actionSpritesFrame:GetChild("uprAction"):linear(0.05):diffusealpha(0);

				end;
			end;

			if params.PlayerNumber == player and params.Name == "UpLeft" then
				this.actionSpritesFrame:GetChild("uplAction"):stoptweening():linear(0.05):zoom(1.1):linear(0.05):zoom(1);
				if optEntered[optIndexPlayer] then
					this.actionSpritesFrame:GetChild("outSound"):stoptweening():stop():play();
					optEntered[optIndexPlayer] = false;
					this.optTextName:stoptweening();
					this.optTextName:linear(0.05):y(0);
					self:queuecommand("hideAllOption");

					this.actionSpritesFrame:GetChild("uplAction"):linear(0.05):diffusealpha(0);
					this.actionSpritesFrame:GetChild("uprAction"):linear(0.05):diffusealpha(0);
				end;
			end;

			-- left
			if params.PlayerNumber == player and params.Name == "DownLeft" then
				this.actionSpritesFrame:GetChild("moveSound"):stoptweening():stop():play();
				this.actionSpritesFrame:GetChild("dlAction"):stoptweening():linear(0.05):zoom(1.1):linear(0.05):zoom(1);

				optExitReady[optIndexPlayer] = false;
				this.readyPlayer:diffusealpha(0);

				--a little movement for the arrows.
				this.arrLeft:stoptweening():x(arrLX);
				this.arrLeft:linear(0.05):addx(-5):linear(0.05):x(arrLX);

				--we check, if we are inside a option or in the main menu.
				if optEntered[optIndexPlayer] then
					
					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "banner" then
						--this is the selected thing, we need to remark that.
						if (tempAvatarPlayerSelectedIndex[optIndexPlayer] - 1) < 1 then
							tempAvatarPlayerSelectedIndex[optIndexPlayer] = #avatar_list;
						else
							tempAvatarPlayerSelectedIndex[optIndexPlayer]  = tempAvatarPlayerSelectedIndex[optIndexPlayer] - 1;
						end;

						--it's our avatar?
						if tempAvatarPlayerSelectedIndex[optIndexPlayer] == avatarPlayerSelectedIndex[optIndexPlayer] then
							this.AvatarActor:GetChild("selectedBannerImage"):stoptweening():linear(0.05):diffusealpha(1);
						else
							this.AvatarActor:GetChild("selectedBannerImage"):stoptweening():linear(0.05):diffusealpha(0);
						end;

						local fileAvatar = avatar_list[tempAvatarPlayerSelectedIndex[optIndexPlayer]]["file"];
						if (FILEMAN:DoesFileExist("/Avatars/" .. fileAvatar)) then
							this.AvatarActor:GetChild("avatarOptionImage"):Load("/Avatars/" .. fileAvatar);
						else
							this.AvatarActor:GetChild("avatarOptionImage"):Load(THEME:GetPathG("","profiles/base_profile.png"));					
						end;

					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "background" then

						if (tempBackgroundPlayerSelectedIndex[optIndexPlayer] - 1) < 1 then
							tempBackgroundPlayerSelectedIndex[optIndexPlayer] = #background_list;
						else
							tempBackgroundPlayerSelectedIndex[optIndexPlayer]  = tempBackgroundPlayerSelectedIndex[optIndexPlayer] - 1;
						end;

						--it's our avatar?
						if tempBackgroundPlayerSelectedIndex[optIndexPlayer] == backgroundPlayerSelectedIndex[optIndexPlayer] then
							this.BackgroundActor:GetChild("selectedBackgroundOption"):stoptweening():linear(0.05):diffusealpha(1);
						else
							this.BackgroundActor:GetChild("selectedBackgroundOption"):stoptweening():linear(0.05):diffusealpha(0);
						end;
						self:queuecommand("reloadBackgroundOption"); -- this reload only the option

					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "difficulty" then

						if (tempDifficultyListSelectedIndex[optIndexPlayer] - 1) < 1 then
							tempDifficultyListSelectedIndex[optIndexPlayer] = #arrDifficultyListPlugins;
						else
							tempDifficultyListSelectedIndex[optIndexPlayer]  = tempDifficultyListSelectedIndex[optIndexPlayer] - 1;
						end;

						--it's our option?
						if tempDifficultyListSelectedIndex[optIndexPlayer] == difficultyListSelectedIndex[optIndexPlayer] then
							this.difficultyListActor:GetChild("selectedDiffPlugin"):diffusealpha(1);
						else
							this.difficultyListActor:GetChild("selectedDiffPlugin"):diffusealpha(0);
						end;

						self:queuecommand("reloadOptionDiffList");
					end;


				else
					--main menu
					local optHeaderTemp = optPlayerActive[optIndexPlayer];
					if (optPlayerActive[optIndexPlayer]) - 1 < 1 then
						optPlayerActive[optIndexPlayer] = #dataOptions;
					else
						optPlayerActive[optIndexPlayer] = optPlayerActive[optIndexPlayer] - 1;
					end;

					--check if is activte
					if dataOptions[optPlayerActive[optIndexPlayer]]["active"] == false then

						if (optPlayerActive[optIndexPlayer]) - 1 < 1 then
							optPlayerActive[optIndexPlayer] = #dataOptions;
						else
							optPlayerActive[optIndexPlayer] = optPlayerActive[optIndexPlayer] - 1;
						end;
						
					end;

					--refresh things
					this.optTextName:Load(THEME:GetPathG("","ScreenPlayerProfileCustom/"..dataOptions[optPlayerActive[optIndexPlayer]]["imgfile"]));
					--refresh things
					self:GetChild("hoption"..optHeaderTemp):diffusealpha(0.4);
					this.optTextName:Load(THEME:GetPathG("","ScreenPlayerProfileCustom/"..dataOptions[optPlayerActive[optIndexPlayer]]["imgfile"]));
					self:GetChild("hoption"..optPlayerActive[optIndexPlayer]):diffusealpha(1);


					local langSelected = getLangActive();
					self:GetChild("descOptions"):settext(dataOptions[optPlayerActive[optIndexPlayer]]["lang_"..langSelected]);

				end;
			end;

			-- right
			if params.PlayerNumber == player and params.Name == "DownRight" then
				this.actionSpritesFrame:GetChild("moveSound"):stoptweening():stop():play();
				this.actionSpritesFrame:GetChild("drAction"):stoptweening():linear(0.05):zoom(1.1):linear(0.05):zoom(1);

				--exit things
				optExitReady[optIndexPlayer] = false;
				this.readyPlayer:diffusealpha(0);
				--a little movement for the arrows.
				this.arrRight:stoptweening():x(arrRX);
				this.arrRight:linear(0.05):addx(5):linear(0.05):x(arrRX);

				if optEntered[optIndexPlayer] then

					--inside options
					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "banner" then
						--this is the selected thing, we need to remark that.

						if (tempAvatarPlayerSelectedIndex[optIndexPlayer] + 1) > #avatar_list then
							tempAvatarPlayerSelectedIndex[optIndexPlayer] = 1;
						else
							tempAvatarPlayerSelectedIndex[optIndexPlayer]  = tempAvatarPlayerSelectedIndex[optIndexPlayer] + 1;							
						end;

						--it's our avatar?
						if tempAvatarPlayerSelectedIndex[optIndexPlayer] == avatarPlayerSelectedIndex[optIndexPlayer] then
							this.AvatarActor:GetChild("selectedBannerImage"):stoptweening():linear(0.05):diffusealpha(1);
						else
							this.AvatarActor:GetChild("selectedBannerImage"):stoptweening():linear(0.05):diffusealpha(0);
						end;

						local fileAvatar = avatar_list[tempAvatarPlayerSelectedIndex[optIndexPlayer]]["file"];
						if (FILEMAN:DoesFileExist("/Avatars/" .. fileAvatar)) then
							this.AvatarActor:GetChild("avatarOptionImage"):Load("/Avatars/" .. fileAvatar);
						else
							this.AvatarActor:GetChild("avatarOptionImage"):Load(THEME:GetPathG("","profiles/base_profile.png"));					
						end;

					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "background" then

						if (tempBackgroundPlayerSelectedIndex[optIndexPlayer] + 1) > #background_list then
							tempBackgroundPlayerSelectedIndex[optIndexPlayer] = 1;
						else
							tempBackgroundPlayerSelectedIndex[optIndexPlayer]  = tempBackgroundPlayerSelectedIndex[optIndexPlayer] + 1;
						end;

						--it's our avatar?
						if tempBackgroundPlayerSelectedIndex[optIndexPlayer] == backgroundPlayerSelectedIndex[optIndexPlayer] then
							this.BackgroundActor:GetChild("selectedBackgroundOption"):stoptweening():linear(0.05):diffusealpha(1);
						else
							this.BackgroundActor:GetChild("selectedBackgroundOption"):stoptweening():linear(0.05):diffusealpha(0);
						end;
						self:queuecommand("reloadBackgroundOption"); -- this reload only the option

					end;

					if dataOptions[optPlayerActive[optIndexPlayer]]["name"] == "difficulty" then

						if (tempDifficultyListSelectedIndex[optIndexPlayer] + 1) > #arrDifficultyListPlugins then
							tempDifficultyListSelectedIndex[optIndexPlayer] = 1;
						else
							tempDifficultyListSelectedIndex[optIndexPlayer]  = tempDifficultyListSelectedIndex[optIndexPlayer] + 1;
						end;

						--it's our option?
						if tempDifficultyListSelectedIndex[optIndexPlayer] == difficultyListSelectedIndex[optIndexPlayer] then
							this.difficultyListActor:GetChild("selectedDiffPlugin"):diffusealpha(1);
						else
							this.difficultyListActor:GetChild("selectedDiffPlugin"):diffusealpha(0);
						end;

						self:queuecommand("reloadOptionDiffList");
					end;

				else
					--main menu
					local optHeaderTemp = optPlayerActive[optIndexPlayer];
					if (optPlayerActive[optIndexPlayer]) + 1 > #dataOptions then
						optPlayerActive[optIndexPlayer] = 1;
					else
						optPlayerActive[optIndexPlayer] = optPlayerActive[optIndexPlayer] + 1;
					end;

					--check if is activte
					if dataOptions[optPlayerActive[optIndexPlayer]]["active"] == false then

						if (optPlayerActive[optIndexPlayer]) + 1 > #dataOptions then
							optPlayerActive[optIndexPlayer] = 1;
						else
							optPlayerActive[optIndexPlayer] = optPlayerActive[optIndexPlayer] + 1;
						end;

					end;

					--refresh things
					self:GetChild("hoption"..optHeaderTemp):diffusealpha(0.4);
					this.optTextName:Load(THEME:GetPathG("","ScreenPlayerProfileCustom/"..dataOptions[optPlayerActive[optIndexPlayer]]["imgfile"]));
					self:GetChild("hoption"..optPlayerActive[optIndexPlayer]):diffusealpha(1);

					local langSelected = getLangActive();
					self:GetChild("descOptions"):settext(dataOptions[optPlayerActive[optIndexPlayer]]["lang_"..langSelected]);

				end;
			end;



		end;

		hideAllOptionCommand=function(self)
			local this = self:GetChildren();
			this.AvatarActor:visible(false);
			this.BackgroundActor:visible(false);
			this.difficultyListActor:visible(false);

		end;

		refreshExitPlayerCommand=function(self)

		end;
	};

end;
















-- COMMON BACKGROUND
--header.
t[#t+1] = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
		OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};


	LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,1;visible,true);
		OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);		
	};	

	LoadActor( THEME:GetPathG("","commonBackground/bredsm.mp4") )..{
			InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;visible,true;queuecommand,"Ani");
			AniCommand=function(self)
				self:linear(12);
				self:diffusealpha(0.4);
				self:linear(12);
				self:diffusealpha(0.1);
				self:queuecommand("Ani");
			end;			
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};	


	LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
		OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};	

};

--[[
t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1);	
};
]]

t[#t+1] = 	LoadFont("_TitleXolonium")..{
			Name="Title";
			Text="PROFILE EDITOR";
			InitCommand=cmd(zoom,1;xy,SCREEN_CENTER_X,SCREEN_TOP+20;);
};

if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = createProfileEditor(PLAYER_1);
end;
if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = createProfileEditor(PLAYER_2);
end;

t[#t+1] = Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0);	
		OffCommand=function(self)
			self:linear(0.3);
			self:diffuse(0,0,0,1);
		end;
};


return t;