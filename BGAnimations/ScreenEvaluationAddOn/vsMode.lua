local t = Def.ActorFrame {}
local zoomBaseVs=0.75;
local sleepToShow = 1.6;

t[#t+1] = Def.ActorFrame
{
		OnCommand=function(self)

			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y+240);

			local vStats = STATSMAN:GetCurStageStats();
			local pnStageStatsP1 = vStats:GetPlayerStageStats( PLAYER_1 );
			local pnStageStatsP2 = vStats:GetPlayerStageStats( PLAYER_2 );


			--si es el mismo chart mostramos las cosas.
			local stepPlayedP1 = pnStageStatsP1:GetPlayedSteps();
			local stepPlayedP2 = pnStageStatsP2:GetPlayedSteps();

			local hashChartP1 = stepPlayedP1[#stepPlayedP1]:GetHash();
			local hashChartP2 = stepPlayedP2[#stepPlayedP2]:GetHash();

			if hashChartP1 == hashChartP2 then

				local scoreP1 = pnStageStatsP1:GetScore();
				local scoreP2 = pnStageStatsP2:GetScore();

				local playerCount = {GAMESTATE:Env()["p1vsCount"],GAMESTATE:Env()["p2vsCount"]};


				if (playerCount[1] - playerCount[2]) >= 3 then
					self:GetChild("fireWinner"):x(-82);
				elseif (playerCount[2] - playerCount[1]) >= 3 then
					self:GetChild("fireWinner"):x(80);
				else
					self:GetChild("fireWinner"):visible(false);
				end;

				if scoreP1 == scoreP2 then

					self:GetChild("vresultp1"):setstate(2);
					self:GetChild("vresultp2"):setstate(2);
					self:GetChild("p1TextVs"):settext(playerCount[1]);
					self:GetChild("p2TextVs"):settext(playerCount[2]);
				elseif scoreP1 > scoreP2 then

					self:GetChild("vresultp1"):setstate(0);
					self:GetChild("vresultp2"):setstate(1);
					self:GetChild("p1TextVs"):settext(playerCount[1]+1);
					self:GetChild("p2TextVs"):settext(playerCount[2]);
				elseif scoreP1 < scoreP2 then

					self:GetChild("vresultp1"):setstate(1);
					self:GetChild("vresultp2"):setstate(0);

					self:GetChild("p1TextVs"):settext(playerCount[1]);
					self:GetChild("p2TextVs"):settext(playerCount[2]+1);
				end;

			else
				self:visible(false);
			end;

		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.2);
			self:diffusealpha(0);
		end;



		LoadActor( THEME:GetPathG("","vsmode/vsresult") )..{
			Name="vresultp1";
			InitCommand=function(self)
				self:zoom(zoomBaseVs);
				self:diffusealpha(0);
				self:animate(false);
				self:setstate(0);
				self:x(-90);
				self:sleep(sleepToShow);
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:zoom(zoomBaseVs+2);
				self:linear(0.1);
				self:diffusealpha(1);
				self:zoom(zoomBaseVs);
			end;
		};

		LoadActor( THEME:GetPathG("","vsmode/vsresult") )..{
			Name="vresultp2";
			InitCommand=function(self)
				self:zoom(zoomBaseVs);
				self:diffusealpha(0);
				self:animate(false);
				self:setstate(1);
				self:x(90);
				self:sleep(sleepToShow);
				self:queuecommand("Ani");
			end;
			AniCommand=function(self)
				self:zoom(zoomBaseVs+2);
				self:linear(0.1);
				self:diffusealpha(1);
				self:zoom(zoomBaseVs);
			end;
		};		


		LoadActor( THEME:GetPathG("","vsmode/vs_frame") )..{
			Name="";
			InitCommand=function(self)
				self:zoom(1);
				self:y(60);
				self:x(4);
			end;
		};			

		Def.Sprite {
			Name="fireWinner";
			Texture=THEME:GetPathG("","vsmode/fire_sprite 12x1");
			InitCommand=cmd(zoom,0.4;x,0;y,30;horizalign,center;visible,true;);
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
			InitCommand=cmd(zoom,0.6;shadowlength,2;y,46;x,-85;horizalign,center;visible,true;settext,"2");
			OffCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("avnormal")..{
			Name="p2TextVs";
			InitCommand=cmd(zoom,0.6;shadowlength,2;y,46;x,78;horizalign,center;visible,true;settext,"1");
			OffCommand=cmd(finishtweening;visible,false);
		};	
}

return t;