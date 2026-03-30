function GetUsb()
	local ARRAY={};
	ARRAY[-1]=PLAYER_1;
	ARRAY[1]=PLAYER_2;
	
	local xWidth={};
	xWidth[-1]=100;
	xWidth[1]=100;

	local yPosFix = ProfileBase_Y;
	
	local fixp1pf=20+ProfileOverlayP1_Y;
	local fixp2pf=-20+ProfileOverlayP2_Y;

	
	local t = Def.ActorFrame{};
	for p=-1,1,2 do

		local x={};
		x[0] = p == -1 and -318+fixp1pf or 318+fixp2pf; --laneskin
		x[1] = p == -1 and -296+fixp1pf or 340+fixp2pf; --laneskin
		x[2] = p == -1 and -439+fixp1pf or 197+fixp2pf; -- profile

		x[3] = p == -1 and -403+fixp1pf or 232+fixp2pf; --lv text
		x[4] = p == -1 and -375+fixp1pf or 260+fixp2pf; --lv numero 
		x[5] = p == -1 and -403+fixp1pf or 232+fixp2pf; -- nom player 
		x[6] = p == -1 and -354+fixp1pf or 354+fixp2pf; -- corazones 


		t[#t+1] = Def.ActorFrame{
		
			OffCommand=function(self)
				self:linear(.4):addy(-200);
			end;
		
			LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
				
				OnCommand=cmd(Center;zoom,.62;addx,x[0];y,yPosFix;animate,false;setstate,0;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)
					self:diffusealpha(0.5);
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};	

			LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
				
				OnCommand=cmd(Center;zoom,.62;addx,x[0];y,yPosFix;animate,false;setstate,0;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)
					self:blend('BlendMode_Add');
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};


			
			------------------------------------------------------------------------------------------------------------

			LoadActor(THEME:GetPathG("","_blank"))..{
				OnCommand=cmd(Center;addx,x[1];y,yPosFix;diffusealpha,1;MaskDest;scaletoclipped,243,44;queuecommand,"Profile");
				ProfileCommand=function(self)
						
					--this is bad xD but it removes the bug with 2 videos at the same time.
					local isLowRate=false;
					if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
						profileP1 = PROFILEMAN:GetProfile(PLAYER_1);
						profileP2 = PROFILEMAN:GetProfile(PLAYER_2);

						local usbskinplayerP1 = profileP1:GetSkinUsbFile();
						local usbskinplayerP2 = profileP2:GetSkinUsbFile();

						local p1Video = "";
						local p2Video = "";

						if string.find(usbskinplayerP1, "_video%.png") then
							local videoFile = string.gsub(usbskinplayerP1, ".png", ".mp4")			
							if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
								p1Video = videoFile;
							end;
						end;

						if string.find(usbskinplayerP2, "_video%.png") then
							local videoFile = string.gsub(usbskinplayerP2, ".png", ".mp4")			
							if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
								p2Video = videoFile;
							end;
						end;

						if #p1Video > 0 and #p2Video > 0 then

							if p1Video == p2Video then
								isLowRate = true;
							end;

						end;
					end;					


					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then

						self:finishtweening();
						profile = PROFILEMAN:GetProfile(ARRAY[p]);

						local level = profile:GetUserLevel();
						if (level >= 0) then


							if not PROFILEMAN:IsPersistentProfile(ARRAY[p]) then
								self:Load(THEME:GetPathG("","profiles/b_guest_2.png"));
							else
								--[[
								self:visible(true);
								local arrSkinsUsb = GAMESTATE:GetSkinUsbFolder();
								local testLane=math.random(1,#arrSkinsUsb);
								self:Load("/UsbSkins/"..arrSkinsUsb[testLane]);
								]]

								local usbskinplayer = profile:GetSkinUsbFile();
								if usbskinplayer == "0_blank.png" then
									self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
								else									
									if string.find(usbskinplayer, "_video%.png") then
										local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
										if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
											self:Load("/UsbSkins/" .. videoFile);
											if isLowRate then
												self:rate(0.5);
											else
												self:rate(1);
											end;
											self:play();
										else
											self:Load(THEME:GetPathG("","_blank"));
										end;
									else
										if FILEMAN:DoesFileExist("/UsbSkins/" .. usbskinplayer) then
											self:Load("/UsbSkins/" .. usbskinplayer);
										else
											self:Load(THEME:GetPathG("","_blank"));
										end;
									end;								
								end;



							end;
						else
							self:visible(false);
						end;



					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};
			------------------------------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------------------------------
			--PROFILE IMAGE
			LoadActor(THEME:GetPathG("","_blank"))..{
				OnCommand=cmd(Center;addx,x[2];scaletoclipped,45,44;y,AvatarPic_Y;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileMessageCommand=function(self,params)
					if params.Player == player then
						self:finishtweening();
						profile = PROFILEMAN:GetProfile(ARRAY[p]);
						local sFile = profile:GetAvatarFile();


							if not PROFILEMAN:IsPersistentProfile(ARRAY[p]) then
								self:Load(THEME:GetPathG("","profiles/base_profile.png"));
							else
								if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
									self:Load("/Avatars/" .. sFile);
								else
									self:Load(THEME:GetPathG("","profiles/base_profile.png"));
								end;
							end;


						
					end;
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				CardDisconnectedMessageCommand=function(self,params)
					if params.Player == player then
						self:y(SCREEN_CENTER_Y+437);
					end;
				end;
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};


			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,x[3];y,yPosFix+8;zoom,0.7;horizalign,left;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)

					if (p == -1 ) then

					end;

					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening():stopeffect();
						xWidth[p] = self:GetWidth();
						
						if not PROFILEMAN:IsPersistentProfile(ARRAY[p]) then
							self:settext("GUEST PLAYER");
						else
							self:settext("LV");	
						end;


						
					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};

			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,x[4];y,yPosFix+8;zoom,0.62;horizalign,left;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Profile");
				ProfileCommand=function(self)

					if (p == -1 ) then
						
					end;

					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then


						self:finishtweening():stopeffect();

						if not PROFILEMAN:IsPersistentProfile(ARRAY[p]) then
							self:visible(false);
						else
							self:SetLevelProperties(profile);
							xWidth[p] = self:GetWidth();
							--self:settext( SetLevelProperties(PROFILEMAN:GetProfile(ARRAY[p])));
						end;




					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;
			};			

			LoadFont("_XoloPlayer")..{
				OnCommand=cmd(Center;addx,x[5];y,yPosFix-30;zoom,.75;shadowlength,1;shadowcolor,0,0,0,1;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);horizalign,p == 1 and left or left;queuecommand,"Profile");
				ProfileCommand=function(self)
					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then
						self:finishtweening():stopeffect();
						profile = PROFILEMAN:GetProfile(ARRAY[p]);

						if p == 1 then
							self:y(yPosFix-12);
						else
							self:y(yPosFix-12);
						end;
						self:settext(string.upper(profile:GetDisplayName()));
					end;				
				end;
				PlayerJoinedMessageCommand=cmd(queuecommand,"On");
				ProfileWindowCloseMessageCommand=function(self,params)
					self:queuecommand("On");
				end;

				ChangeOnlineNameProfileMessageCommand = function(self, params)
				    if params then
				        self:settext(params.name)
				    end
				end;
			};	
			--[[
			LoadActor(THEME:GetPathG("","SaniNet/signal"))..{
				OnCommand=cmd(zoom,0.3;y,yPosFix);
				ChangeOnlineNameProfileMessageCommand = function(self, params)

					if GAMESTATE:IsHumanPlayer(ARRAY[p]) then

					    if params then
							if p == 1 then
								self:x(SCREEN_CENTER_X+430);
							else
								self:x(SCREEN_CENTER_X-166);
							end;

					    	if #params.name > 0 then
					    		self:visible(true);
					    	end;
					    end;

					end;


				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
			};		
			]]
		};

		-- Corazones [idea principal]
		--   No deberian existir.
		--   Pienso mas en el gameplay que en emular como funciona la piu arcade
		--   si que evitemos todo tipo de cosas que emulen el "arcade", queremos jugar sin parar como lo hacen los juegos de pc.
		--   arka

		-- igual quieren los corazones ¬¬
		-- not show hearts when in event mode.
		if not GAMESTATE:IsEventMode() then
			for h=1,5,1 do
				
				t[#t+1]=LoadActor(THEME:GetPathG("","ScreenSelectMusic/perfiles/scorazones")) .. {
					InitCommand=cmd(diffusealpha,1);
					OnCommand=function(self)
						self:Center():addx((x[6] + 20 * (h*p))+Scorazones_XOffsetBase+(Scorazones_XOffsetBias*p)):y(Scorazones_Y):zoom(0.85):animate(false):setstate(0):visible(GAMESTATE:IsHumanPlayer(ARRAY[p]));
					end;
					OffCommand=function(self)
						self:linear(.4):addy(-200);
					end;
				};
			end;

			for h=1,PREFSMAN:GetPreference("SongsPerPlay"),1 do
				t[#t+1]=LoadActor(THEME:GetPathG("","ScreenSelectMusic/perfiles/scorazones")) .. {
					InitCommand=cmd(diffusealpha,0);
					OnCommand=function(self)
						self:Center():addx((x[6] + 20 * (h*p))+Scorazones_XOffsetBase+(Scorazones_XOffsetBias*p)):y(Scorazones_Y):zoom(0.85):animate(false):setstate(1):visible(GAMESTATE:IsHumanPlayer(ARRAY[p])):diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,1"));
						if SCREENMAN:GetTopScreen():GetName() == "ScreenSelectMusic" then
							self:queuecommand("Check");
						end;
						self:diffusealpha(0);
						if h <= GAMESTATE:GetNumStagesLeft(ARRAY[p]) then
							self:diffusealpha(1);
						end;
					end;
					CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"Check");
					CheckCommand=function(self)
						if SCREENMAN:GetTopScreen():GetSelectionState() ~= 'SelectingChannel' then
							
							if GAMESTATE:GetCurrentSong() ~= nil then
								local heart = GAMESTATE:GetCurrentSong():GetHearts();
								self:effectcolor2(color("1,1,1,1"));
								if GAMESTATE:GetNumStagesLeft(ARRAY[p])-h < heart then
								self:effectcolor2(color("1,0,0,0"));
								end;
								self:effectperiod(2);
							end;
						end;
					end;
					SelectChannelMessageCommand=cmd(finishtweening;effectcolor2,color("1,1,1,1"));
					ChannelChosenMessageCommand=cmd(finishtweening;queuecommand,"Check");
					PlayerJoinedMessageCommand=cmd(queuecommand,"On");
					OffCommand=function(self)
						self:linear(.4):addy(-200);
					end;
				};
			end;

			for h=1, PREFSMAN:GetPreference("SongsPerPlay"),1 do

				t[#t+1]=LoadActor(THEME:GetPathG("","ScreenSelectMusic/perfiles/scorazones")) .. {
					InitCommand=cmd(diffusealpha,0);
					OnCommand=cmd(diffusealpha,0;Center;addx,(x[6] + 20 * (h*p))+Scorazones_XOffsetBase+(Scorazones_XOffsetBias*p);y,Scorazones_Y;zoom,0.85;animate,false;setstate,1;visible,GAMESTATE:IsHumanPlayer(ARRAY[p]);queuecommand,"Check");
					CheckCommand=function(self)
						if GAMESTATE:GetCurrentSong() ~= nil then
							local heart = GAMESTATE:GetCurrentSong():GetHearts();
							if h < GAMESTATE:GetNumStagesLeft(ARRAY[p]) then
								self:diffusealpha(0);
							end;
						end;
					end;
					FakeRecoverHeartMessageCommand=function(self,params)
						if params.Player == ARRAY[p] then
							local heart = GAMESTATE:GetCurrentSong():GetHearts();						
							if h <= params.Hearts then	
								self:diffusealpha(1);
							end;
						end;
					end;
					
					RecoverHeartMessageCommand=function(self,params)
						if params.Player == ARRAY[p] then
							if GAMESTATE:GetCurrentSong() ~= nil then
								local heart = GAMESTATE:GetCurrentSong():GetHearts();						
								if h > GAMESTATE:GetNumStagesLeft(ARRAY[p]) and h <= GAMESTATE:GetNumStagesLeft(ARRAY[p]) + params.Hearts then	
									self:y(Scorazones_Y):zoom(1):linear(0.5):zoom(0.85):y(Scorazones_Y):diffusealpha(1);
								end;
							end;
						end;
					end;
					PlayerJoinedMessageCommand=cmd(queuecommand,"On");
					OffCommand=function(self)
						self:linear(.4):addy(-200);
					end;
				};
			end;
		end;


	end;


	return t;
end;


local t = Def.ActorFrame {};

t[#t+1] = GetUsb();

return t;