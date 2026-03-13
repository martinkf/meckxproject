local t = Def.ActorFrame {}
local zoomBaseVs=1;
--[[
if GAMESTATE:GetNumSidesJoined() == 2 then
	if GAMESTATE:Env()["vsMode"] == nil then

	end;
end;
]]


local p1PerfilTmp = PROFILEMAN:GetProfile(PLAYER_1):GetGUID();
local p2PerfilTmp = PROFILEMAN:GetProfile(PLAYER_2):GetGUID();

t[#t+1] = Def.ActorFrame
{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X+5,SCREEN_CENTER_Y-280);
			self:queuecommand("updateVs");			
		end;

		ProfileWindowCloseMessageCommand=function(self,params)
			self:queuecommand("checkChangeProfile");
		end;	

		checkChangeProfileCommand=function(self)
			local p1PerfilChange = PROFILEMAN:GetProfile(PLAYER_1):GetGUID();
			local p2PerfilChange = PROFILEMAN:GetProfile(PLAYER_2):GetGUID();
			if p1PerfilChange ~= p1PerfilTmp then
				GAMESTATE:Env()["p1vsCount"] = 0;
				GAMESTATE:Env()["p2vsCount"] = 0;
				p1PerfilTmp=p1PerfilChange;
				restartVsHistory();
			end;

			if p2PerfilChange ~= p2PerfilTmp then
				GAMESTATE:Env()["p1vsCount"] = 0;
				GAMESTATE:Env()["p2vsCount"] = 0;
				p2PerfilTmp = p2PerfilChange;
				restartVsHistory();
			end;
			MESSAGEMAN:Broadcast("checkSlotHistoryVs", {})
			self:queuecommand("updateVs");
		end;

		CheckSelectedMessageCommand=function(self,params)
			if GAMESTATE:Env()["vsMode"] == false then
				self:visible(false);		
				restartVsHistory();		
			elseif GAMESTATE:Env()["vsMode"] then
				self:visible(true);
				self:queuecommand("updateVs");
			end;
		end;

		updateVsCommand=function(self)
			if GAMESTATE:GetNumSidesJoined() == 2 and GAMESTATE:Env()["vsMode"] then
				
				if GAMESTATE:Env()["p1vsCount"] == nil then
					GAMESTATE:Env()["p1vsCount"] = 0;
				end;
				if GAMESTATE:Env()["p2vsCount"] == nil then
					GAMESTATE:Env()["p2vsCount"] = 0;
				end;

				if GAMESTATE:Env()["p1vsCount"] ~= nil and GAMESTATE:Env()["p2vsCount"] ~= nil then
					local p1Count = tonumber(GAMESTATE:Env()["p1vsCount"]);
					local p2Count = tonumber(GAMESTATE:Env()["p2vsCount"]);

					self:GetChild("p1TextVs"):settext(p1Count);
					self:GetChild("p2TextVs"):settext(p2Count);

					--flamita de te voy ganando
					local winnerStreak = 3;
					if (tonumber(p1Count) - tonumber(p2Count)) >= winnerStreak then
						self:GetChild("fireWinner"):x(-90);
						self:GetChild("fireWinner"):visible(true);
					elseif (tonumber(p2Count) - tonumber(p1Count)) >= winnerStreak then
						self:GetChild("fireWinner"):x(80);
						self:GetChild("fireWinner"):visible(true);
					else
						self:GetChild("fireWinner"):visible(false);
					end;
					self:visible(true);
				end;
			else
				self:visible(false);
			end;
		end;

		LoadActor( THEME:GetPathG("","vsmode/vs_frame") )..{
				InitCommand=function(self)
					self:zoom(zoomBaseVs);
				end;
		};

		Def.Sprite {
			Name="fireWinner";
			Texture=THEME:GetPathG("","vsmode/fire_sprite 12x1");
			InitCommand=cmd(zoom,0.45;y,-32;x,-91;horizalign,center;visible,true;);
			Frame0000=0;
			Delay0000=0.11;
			Frame0001=1;
			Delay0001=0.11;
			Frame0002=2;
			Delay0002=0.11;
			Frame0003=3;
			Delay0003=0.11;
			Frame0004=4;
			Delay0004=0.11;	
			Frame0005=5;
			Delay0005=0.11;		
			Frame0006=6;
			Delay0006=0.11;		
			Frame0007=7;
			Delay0007=0.11;				
			Frame0007=8;
			Delay0007=0.11;		
			Frame0007=9;
			Delay0007=0.11;		
			Frame0007=10;
			Delay0007=0.11;		
			Frame0007=11;
			Delay0007=0.11;
		};


		LoadFont("avnormal")..{
			Name="p1TextVs";
			InitCommand=cmd(zoom,0.6;shadowlength,2;y,-14;x,-90;horizalign,center;visible,true;);
			OffCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("avnormal")..{
			Name="p2TextVs";
			InitCommand=cmd(zoom,0.6;shadowlength,2;y,-14;x,78;horizalign,center;visible,true;);
			OffCommand=cmd(finishtweening;visible,false);
		};	



};


local p1Placex=-450;
local p2Placex=450;
local baseYHistory=-220;
local maxHistory=6;

for i=1,maxHistory do

	t[#t+1] = Def.ActorFrame
	{
			OnCommand=function(self)
				self:x(SCREEN_CENTER_X);
				self:y(SCREEN_CENTER_Y+baseYHistory + ( 50*(i-1) ) );
				self:visible(false);				
				self:queuecommand("refreshSlots");
			end;

			CommandWindowOpenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:GetChild("songNameHP1"):diffusealpha(0);
					self:GetChild("lvHP1"):diffusealpha(0);
					self:GetChild("scoreHP1"):diffusealpha(0);
					self:GetChild("gradeFailedHP1"):diffusealpha(0);
					self:GetChild("gradeHP1"):diffusealpha(0);
					self:GetChild("vsresP1"):diffusealpha(0);
					self:GetChild("baseHP1"):diffusealpha(0);
				end;

				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:GetChild("songNameHP2"):diffusealpha(0);
					self:GetChild("lvHP2"):diffusealpha(0);
					self:GetChild("scoreHP2"):diffusealpha(0);

					self:GetChild("gradeFailedHP2"):diffusealpha(0);
					self:GetChild("gradeHP2"):diffusealpha(0);

					self:GetChild("vsresP2"):diffusealpha(0);
					self:GetChild("baseHP2"):diffusealpha(0);
				end;			
			end;

			CommandWindowOptionCancelMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					self:stoptweening();
					self:GetChild("songNameHP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("lvHP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("scoreHP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("gradeFailedHP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("gradeHP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("vsresP1"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("baseHP1"):stoptweening():linear(0.15):diffusealpha(1);
				end;

				if params.Player == PLAYER_2 then
					self:stoptweening();
					self:GetChild("songNameHP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("lvHP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("scoreHP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("gradeFailedHP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("gradeHP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("vsresP2"):stoptweening():linear(0.15):diffusealpha(1);
					self:GetChild("baseHP2"):stoptweening():linear(0.15):diffusealpha(1);
				end;

			end;

			checkSlotHistoryVsMessageCommand=function(self)
				self:queuecommand("refreshSlots");
			end;

			CheckSelectedMessageCommand=function(self,params)
				self:queuecommand("refreshSlots");
			end;

			refreshSlotsCommand=function(self)
				
				if i <= #GAMESTATE:Env()["vsModeHistory"] then
					local gameHistory = GAMESTATE:Env()["vsModeHistory"][i];
					
					self:GetChild("songNameHP1"):settext(shortTextHelper(gameHistory["song"],25));
					self:GetChild("songNameHP2"):settext(shortTextHelper(gameHistory["song"],25));

					self:GetChild("lvHP1"):settext("S"..gameHistory["levelp1"]);
					self:GetChild("lvHP2"):settext("S"..gameHistory["levelp2"]);

					self:GetChild("scoreHP1"):settext(gameHistory["scoreP1"]);
					self:GetChild("scoreHP2"):settext(gameHistory["scoreP2"]);

					--is failed or not?
					--p1
					local letterP1 = gradeTransformState(gameHistory["scoreP1"]);
					local letterP2 = gradeTransformState(gameHistory["scoreP2"]);
					if gameHistory["failedP1"] then
						self:GetChild("gradeFailedHP1"):setstate(letterP1);
						self:GetChild("gradeFailedHP1"):visible(true);
					else
						self:GetChild("gradeHP1"):setstate(letterP1);
						self:GetChild("gradeHP1"):visible(true);
					end;

					if gameHistory["failedP2"] then
						self:GetChild("gradeFailedHP2"):setstate(letterP2);
						self:GetChild("gradeFailedHP2"):visible(true);
					else
						self:GetChild("gradeHP2"):setstate(letterP2);
						self:GetChild("gradeHP2"):visible(true);
					end;

					--check who win
						self:GetChild("vsresP1"):zoom(0.24);
						self:GetChild("vsresP2"):zoom(0.24);
					if gameHistory["draw"] then
						self:GetChild("vsresP1"):setstate(2);
						self:GetChild("vsresP2"):setstate(2);

						self:GetChild("vsresP1"):zoom(0.22);
						self:GetChild("vsresP2"):zoom(0.22);

						self:GetChild("baseHP1"):setstate(0);
						self:GetChild("baseHP2"):setstate(0);
					elseif gameHistory["winP1"] then
						self:GetChild("vsresP1"):setstate(0);
						self:GetChild("vsresP2"):setstate(1);

						self:GetChild("baseHP1"):setstate(0);
						self:GetChild("baseHP2"):setstate(1);

					elseif gameHistory["winP2"] then
						self:GetChild("vsresP1"):setstate(1);
						self:GetChild("vsresP2"):setstate(0);

						self:GetChild("baseHP1"):setstate(1);
						self:GetChild("baseHP2"):setstate(0);

					end;

					self:visible(true);
				else
					self:visible(false);
				end;


			end;

			--PLAYER 1
			LoadActor( THEME:GetPathG("","vsmode/historybase") )..{	
					Name="baseHP1";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(1);
						self:zoom(0.65);
						self:x(p1Placex-20);
					end;			
			};	

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade") )..{
					Name="gradeHP1";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(0);
						self:zoom(0.6);
						self:x(p1Placex-3);
						self:y(7);
						self:visible(false);
					end;			
			};	

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade") )..{
					Name="gradeFailedHP1";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(0);
						self:zoom(0.6);
						self:x(p1Placex-3);
						self:y(7);
						self:visible(false);
					end;			
			};

			LoadFont('_open sans semibold')..
			{		
				Name="songNameHP1";
				OnCommand=function(self,params)

					self:x(p1Placex-82):y(-10):horizalign(left):zoom(0.42);
					local songName="Hyperion Hyperion Hyperion";
					songName = shortTextHelper(songName,25);
					self:settext(songName);
				end;
			};
			LoadFont('_open sans semibold')..
			{
				Name="lvHP1";
				OnCommand=function(self,params)
					self:x(p1Placex-106):y(-10):horizalign(left):zoom(0.42);
					self:settext("S21");
				end;
			};		

			LoadFont("avnormal")..{
				Name="scoreHP1";
				InitCommand=cmd(zoom,0.4;shadowlength,2;x,p1Placex-68;horizalign,center;settext,"1000000");
				OffCommand=cmd(finishtweening;visible,false);
			};	

			LoadActor( THEME:GetPathG("","vsmode/vsresult") )..{
				Name="vsresP1";
				InitCommand=function(self)
					self:animate(false);
					self:setstate(1);
					self:zoom(0.24);
					self:x(p1Placex+45);
					self:y(7);
				end;			
			};	



			--PLAYER 2
			LoadActor( THEME:GetPathG("","vsmode/historybase") )..{
					Name="baseHP2";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(1);
						self:zoom(0.65);
						self:x(p2Placex-20);
					end;			
			};	

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/sl_grade") )..{
					Name="gradeHP2";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(0);
						self:zoom(0.6);
						self:x(p2Placex-3);
						self:y(7);
						self:visible(false);
					end;			
			};	

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/break_sl_grade") )..{
					Name="gradeFailedHP2";
					InitCommand=function(self)
						self:animate(false);
						self:setstate(0);
						self:zoom(0.6);
						self:x(p2Placex-3);
						self:y(7);
						self:visible(false);
					end;			
			};				

			LoadFont('_open sans semibold')..
			{			
				Name="songNameHP2";
				OnCommand=function(self,params)
					self:x(p2Placex-82):y(-10):horizalign(left):zoom(0.42);
					local songName="Hyperion Hyperion Hyperion";
					songName = shortTextHelper(songName,25);
					self:settext(songName);
				end;
			};
			LoadFont('_open sans semibold')..
			{
				Name="lvHP2";
				OnCommand=function(self,params)
					self:x(p2Placex-106):y(-10):horizalign(left):zoom(0.42);
					self:settext("S21");
				end;
			};		

			LoadFont("avnormal")..{
				Name="scoreHP2";
				InitCommand=cmd(zoom,0.4;shadowlength,2;x,p2Placex-68;horizalign,center;settext,"785985");
				OffCommand=cmd(finishtweening;visible,false);
			};	

			LoadActor( THEME:GetPathG("","vsmode/vsresult") )..{
				Name="vsresP2";
				InitCommand=function(self)
					self:animate(false);
					self:setstate(0);
					self:zoom(0.24);
					self:x(p2Placex+45);
					self:y(7);
				end;			
			};	
	}
end;



return t;