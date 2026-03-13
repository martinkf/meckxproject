local t = Def.ActorFrame {
-- COMMON BACKGROUND
--header.
Def.ActorFrame {

	LoadActor(THEME:GetPathG("","commonBackground/backch"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
	};


	LoadActor( THEME:GetPathG("","commonBackground/bbluesm") )..{
		InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.4;visible,true);
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
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
	};	


	LoadActor(THEME:GetPathG("","commonBackground/back3"))..{
		OnCommand=cmd(zoom,0.8;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,1);
	};	
};

	


	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(glow,color("1,1,1,1");Center;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,1);
	};	

	LoadActor(THEME:GetPathG("","ScreenJoin/hcnc"))..{
		OnCommand=cmd(blend,Blend.Add;glow,color("1,1,1,1");Center;addx,-1;zoom,0.6;addy,-500;linear,0.125;y,380;glow,color("1,1,1,0");sleep,0.03;diffusealpha,0;sleep,0.03;diffusealpha,1;sleep,0.03;diffusealpha,0;sleep,0.03;glow,color("1,1,1,0.25");sleep,0.03;glow,color("1,1,1,0");diffusealpha,0.5;linear,0.125;diffusealpha,0.6;queuecommand,"Ani");
		AniCommand=function(self)
			self:linear(2);
			self:faderight(1);
			self:linear(1);
			self:fadeleft(1);	
			self:linear(1);
			self:fadeleft(0);
			self:linear(1);
			self:faderight(0);
			self:queuecommand("Ani");

			--self:queuecommand("Ani");
		end;

		FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);		
	};	

	--[[
	LoadActor(THEME:GetPathS("","GAME_MODE (loop)")) .. {
		OnCommand=cmd(play);
	};
	]]
};



local function CreateUsbForPlayer(player)
	
	local x={};
	
	x[0] = player == PLAYER_1 and -300 or 300;
	x[1] = player == PLAYER_1 and -365 or 363;
	x[2] = player == PLAYER_1 and -500 or 308;
	x[3] = player == PLAYER_1 and -450 or 358;
	x[4] = player == PLAYER_1 and -155 or 270;
	
	x[5] = player == PLAYER_1 and -427 or 172;
	x[6] = player == PLAYER_1 and -396 or 204;

	local xWidth = 100;
	t[#t+1] =  Def.ActorFrame{			
		OnCommand=function(self)
			self:zoom(1.2);
			self:y(80);
			self:x(-120);
		end;	
		
		CodeMessageCommand=function(self, params)
			
		end;			

		LoadActor(THEME:GetPathG("","profiles/th_base_perfil")) .. {
			OnCommand=cmd(zoom,0.65;xy,SCREEN_CENTER_X+x[0],27;);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();
					self:y(27);
					self:diffusealpha(1);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-26);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};
		

		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[5] - (player == PLAYER_1 and -150 or -150),27;diffusealpha,1;MaskDest;scaletoclipped,254,44);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();	
					local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);				
					local level = profile:GetUserLevel();
					if (level >= 0) then

						self:x(SCREEN_CENTER_X+x[5] - (player == PLAYER_1 and -150 or -150));
						self:visible(true);

						if params.Index < 0 then
							self:Load(THEME:GetPathG("","profiles/b_guest_2.png"));
						else

							--[[
							local arrSkinsUsb = GAMESTATE:GetSkinUsbFolder();
							local testLane=math.random(1,#arrSkinsUsb);
							self:Load("/UsbSkins/"..arrSkinsUsb[testLane]);
													--self:diffusebottomedge(.4,1,1,1);
							]]
							local usbskinplayer = profile:GetSkinUsbFile();
							if usbskinplayer == "0_blank.png" then
								self:Load(THEME:GetPathG("","profiles/b_guest_1.png"));
							else								
								if string.find(usbskinplayer, "_video%.png") then
									local videoFile = string.gsub(usbskinplayer, ".png", ".mp4")			
									if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
										self:Load("/UsbSkins/" .. videoFile);
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
						self:y(27);						
					else
						self:visible(false);
					end;
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-30);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};

		-- esta wea es horrible :( pero funciona y no va a joder memoria (espero)
		LoadActor(THEME:GetPathG("","_blank"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[5],27;scaletoclipped,45,45);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					self:finishtweening();

					self:x(SCREEN_CENTER_X+x[5]);
					local profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);


					if params.Index < 0 then
						self:Load(THEME:GetPathG("","profiles/base_profile.png"));
					else
						local sFile = profile:GetAvatarFile();
						if (FILEMAN:DoesFileExist("/Avatars/" .. sFile)) then
							self:Load("/Avatars/" .. sFile);
						else
							self:Load(THEME:GetPathG("","profiles/base_profile.png"));
						end;
					end;



					self:scaletoclipped(45,45);
					self:y(27);
					--self:linear(0.2):addy(58);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};

		-- cositas
		LoadActor(THEME:GetPathG("","ScreenJoin/sp"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0],-15;zoom,0.8);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};	

		--*-- arrows
		LoadActor(THEME:GetPathG("","ScreenJoin/movearrow"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0]+135,85;zoom,0.6);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};	

		LoadActor(THEME:GetPathG("","ScreenJoin/movearrow"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0]-135,85;zoom,0.6);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
					self:rotationy(180);
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};	

		--*--shift message
		LoadActor(THEME:GetPathG("","ScreenJoin/shift"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0]+127,65;zoom,0.6);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};	


		LoadActor(THEME:GetPathG("","ScreenJoin/shift"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0]-127,65;zoom,0.6);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
		};	


		LoadActor(THEME:GetPathG("","ScreenJoin/screenjoin_text"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0],70;zoom,0.8);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);
			OffCommand=cmd(stoptweening;linear,0.3;diffusealpha,0;);			
		};	

		LoadActor(THEME:GetPathG("","ScreenJoin/screenjoin_center"))..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[0],90;zoom,0.8;queuecommand,"Animate");
			ProfileMessageCommand=function(self,params)
				if params.Player == player then
					
				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-31);
				end;
			end;

			AnimateCommand=function(self)
				self:linear(0.6);
				self:y(87);
				self:linear(0.6);
				self:y(90);
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



		------------------------------------------------------------------------------------------------------------------
		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6],35;zoom,0.75;horizalign,left);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then

					self:finishtweening();

					if params.Index < 0 then
						self:settext("GUEST PLAYER");
					else
						self:settext("LV");
					end;

					self:diffusealpha(0);
					self:y(-8);
					xWidth = self:GetWidth();
					self:linear(0.05):y(35):diffusealpha(1);
				end;
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
		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6]+28,35;zoom,0.75;horizalign,left);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then

					if player == PLAYER_1 then
						self:x(SCREEN_CENTER_X+x[6]+28);
					else
						self:x(SCREEN_CENTER_X+x[6]+28);
					end;

					self:finishtweening();
					profile = PROFILEMAN:GetLocalProfileFromIndex(params.Index);
					self:diffusealpha(0);

					if params.Index < 0 then
						self:visible(false);
					else
						self:visible(true);
						self:SetLevelProperties(profile);
						self:y(-8);
						xWidth = self:GetWidth();
						self:linear(0.05):y(35):diffusealpha(1);						
					end;

				end;
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

		--------------------------------------------------------------------------------------------------------------------
		
		
		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(xy,SCREEN_CENTER_X+x[6],15;zoom,.78;shadowlength,1;shadowcolor,0,0,0,1;horizalign,left);
			ProfileMessageCommand=function(self,params)
				if params.Player == player then

					self:finishtweening():stopeffect();
					self:settext(string.upper(PROFILEMAN:GetLocalProfileFromIndex(params.Index):GetDisplayName()));
					self:diffusealpha(0);
					self:y(-9);
					self:linear(0.05):y(15):diffusealpha(1);

				end;
			end;
			CardDisconnectedMessageCommand=function(self,params)
				if params.Player == player then
					self:y(-47);
				end;
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
end;



CreateUsbForPlayer(PLAYER_1);
CreateUsbForPlayer(PLAYER_2);

	
return t;
