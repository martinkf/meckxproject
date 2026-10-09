local t = Def.ActorFrame{};

function createSpeedModifierPlugin(player,useBase)

	local nameP = "";
	local placeX=0;
	if player == PLAYER_1 then
		nameP = "speedBase1";
		placeX = -113;
	else
		nameP = "speedBase2";
		placeX = 113;
	end;

	local isAvVisible=true;
	local isSpeedVisible=false;


	return Def.ActorFrame{
			Name=nameP;
			OnCommand=function(self)
				self:y(-40);
				self:x(placeX);
				
				if getAvSpeedNonstopCenterMode(player) == 0 then
					isAvVisible=false;
					isSpeedVisible = true;
					local xSpeedPlayer = getSpeedNonstopCenterMode(player);
					--self:GetChild("speedGroup"):GetChild("speedIcon"):setstate(0);
					--here we need to get if this is .25 or .5 or .75 etc xd
					if xSpeedPlayer >= 7 then
						xSpeedPlayer = 1;
					elseif xSpeedPlayer < 1 then 
						xSpeedPlayer = 1;
					end;

					local basex = math.floor(xSpeedPlayer);
					self:GetChild("speedGroup"):GetChild("speedIcon"):setstate(basex-1);

					if xSpeedPlayer % 1 == 0.25 then
						self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(false);
					end;

					if xSpeedPlayer % 1 == 0.5 then
						self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(false);
					end;
					
					if xSpeedPlayer % 1 == 0.75 then
						self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(false);
						self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(false);
					end;

					GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred' ):XMod(xSpeedPlayer);
					MESSAGEMAN:Broadcast("CodeMod", {Player = player, Command = "speed"} );
				else
					local playerSpeedBase = getAvSpeedNonstopCenterMode(player);
					self:GetChild("AvGroup"):GetChild("AVText"):settext(playerSpeedBase);
					GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):MMod(playerSpeedBase);
					MESSAGEMAN:Broadcast("EnableAV", {Player = player} );
				end;				
			end;

			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

			updateAvTextCommand=function(self)
				local playerSpeedBase = getAvSpeedNonstopCenterMode(player);
				self:GetChild("AvGroup"):GetChild("AVText"):settext(playerSpeedBase);
			end;

			updateSpeedCommand=function(self)
				local playerSpeedBase = getSpeedNonstopCenterMode(player);
				local basex = math.floor(playerSpeedBase);
				self:GetChild("speedGroup"):GetChild("speedIcon"):setstate(basex-1);

				if playerSpeedBase % 1 == 0.25 then
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(false);
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(true);
				elseif playerSpeedBase % 1 == 0.5 then
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(true);
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(false);
				elseif playerSpeedBase % 1 == 0.75 then
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(false);
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(false);
				else
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon25"):visible(true);
					self:GetChild("speedGroup"):GetChild("activeSpeedIcon50"):visible(true);
				end;
			end;


			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/arrowAction") )..{
					Name="arrorLeft";
					InitCommand=function(self)
						self:zoom(0.35);
						self:x(-38);
					end;
			};

			LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/arrowAction") )..{
					Name="arrowRight";
					InitCommand=function(self)
						self:zoom(0.35);
						self:x(38);
						self:rotationy(180);
					end;
			};
			Def.ActorFrame{
				Name="AvGroup";
				OnCommand=function(self)
					self:visible(isAvVisible);
				end;
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/AVicon") )..{
						Name="avIcon";
						InitCommand=function(self)
							self:zoom(0.5);
							self:x(0);
							self:y(50);
						end;
				};

				LoadFont("interphase/InterNumber numbers").. {
						Name="AVText";
						InitCommand=cmd(zoom,.4);
						OnCommand=function(self)
							self:horizalign(center);
							
							self:y(45);
							self:x(0);
						end;
				};


				LoadFont("_TitleXolonium")..{
					Name="avMinus";
					Text="-10";
					InitCommand=cmd(zoom,0.35);
					OnCommand=function(self)
						self:y(15);
						self:x(-30);
					end;
				};

				LoadFont("_TitleXolonium")..{
					Name="avPlus";
					Text="+10";
					InitCommand=cmd(zoom,0.35);
					OnCommand=function(self)
						self:y(15);
						self:x(30);
					end;
				};
			};


			--speed section ¬¬ who uses this omg
			Def.ActorFrame{
				Name="speedGroup";
				OnCommand=function(self)
					self:visible(isSpeedVisible);
				end;
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/Icons02 13x1") )..{
						Name="speedIcon";
						InitCommand=function(self)
							self:zoom(0.4);
							self:animate(false);
							self:setstate(0);
							self:x(0);
							self:y(45);
						end;
				};	
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/Icons02 13x1") )..{
						Name="speed25Icon";
						InitCommand=function(self)
							self:zoom(0.3);
							self:animate(false);
							self:setstate(6);
							self:x(-30);
							self:y(80);
						end;
				};	
				LoadActor( THEME:GetPathG("","ScreenCreateOwnTrain/RESULT/Icons02 13x1") )..{
						Name="speed50Icon";
						InitCommand=function(self)
							self:zoom(0.3);
							self:animate(false);
							self:setstate(7);
							self:x(30);
							self:y(80);
						end;
				};	

				Def.Quad {	
					Name="activeSpeedIcon25";	
					OnCommand=function(self)
						self:zoomto(38,24);
						self:diffuse(color("#000000"));
						self:diffusealpha(0.8);
						self:x(-30);
						self:y(80);
					end;
				};
				Def.Quad {	
					Name="activeSpeedIcon50";		
					OnCommand=function(self)
						self:zoomto(38,24);
						self:diffuse(color("#000000"));
						self:diffusealpha(0.8);
						self:x(30);
						self:y(80);
					end;
				};

				LoadFont("_TitleXolonium")..{
					Name="speedMinus";
					Text="-0.25";
					InitCommand=cmd(zoom,0.35);
					OnCommand=function(self)
						self:y(15);
						self:x(-30);
					end;
				};

				LoadFont("_TitleXolonium")..{
					Name="speedPlus";
					Text="+0.25";
					InitCommand=cmd(zoom,0.35);
					OnCommand=function(self)
						self:y(15);
						self:x(30);
					end;
				};

			}
		};
end;



local baseSelectors = Def.ActorFrame{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_BOTTOM-95);

		if getAvSpeedNonstopCenterMode(PLAYER_1) > 0 then
			MESSAGEMAN:Broadcast("EnableAVInGame", {Player = PLAYER_1} );
		end;
		if getAvSpeedNonstopCenterMode(PLAYER_2) > 0 then
			MESSAGEMAN:Broadcast("EnableAVInGame", {Player = PLAYER_2} );
		end;

    	if getActualNextSongGameplayNonstopCenter() ~= nil then
			--this only works with NSC at the moment :c
		    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
		    		--printInLogParamsData("event",event);	    		
		    	    if event.type == "InputEventType_FirstPress" and event.button == "UpLeft" then
		    	    	if event.PlayerNumber == PLAYER_1 and GAMESTATE:IsSideJoined(PLAYER_1) then
		    	    		if getAvSpeedNonstopCenterMode(PLAYER_1) > 0 then

		    	    			minusAvNonstopCenterMode(PLAYER_1);
		    	    			self:GetChild("speedBase1"):queuecommand("updateAvText");
		    	    			MESSAGEMAN:Broadcast("EnableAV", {Player = PLAYER_1} );
		    	    		else
		    	    			minusSpeedNonstopCenterMode(PLAYER_1);
		    	    			self:GetChild("speedBase2"):queuecommand("updateSpeed");
		    	    			MESSAGEMAN:Broadcast("CodeMod", {Player = PLAYER_1, Command = "speed"} );
		    	    		end;
		    	    	end;
		    	    	if event.PlayerNumber == PLAYER_2 and GAMESTATE:IsSideJoined(PLAYER_2) then
		    	    		if getAvSpeedNonstopCenterMode(PLAYER_2) > 0 then
		    	    			minusAvNonstopCenterMode(PLAYER_2);
		    	    			self:GetChild("speedBase2"):queuecommand("updateAvText");
		    	    			MESSAGEMAN:Broadcast("EnableAV", {Player = PLAYER_2} );	 
		    	    		else
		    	    			minusSpeedNonstopCenterMode(PLAYER_2);
		    	    			self:GetChild("speedBase2"):queuecommand("updateSpeed");
		    	    			MESSAGEMAN:Broadcast("CodeMod", {Player = PLAYER_2, Command = "speed"} );
		    	    		end;
		    	    	end;

		    	    	
				    end;
		    	    if event.type == "InputEventType_FirstPress" and event.button == "UpRight" then
		    	    	
		    	    	if event.PlayerNumber == PLAYER_1 and GAMESTATE:IsSideJoined(PLAYER_1) then
		    	    		if getAvSpeedNonstopCenterMode(PLAYER_1) > 0 then	    	    			
		    	    			addAvNonstopCenterMode(PLAYER_1);
		    	    			self:GetChild("speedBase1"):queuecommand("updateAvText");
		    	    			MESSAGEMAN:Broadcast("EnableAV", {Player = PLAYER_1} );	    
		    	    		else
		    	    			plusSpeedNonstopCenterMode(PLAYER_1);
		    	    			self:GetChild("speedBase2"):queuecommand("updateSpeed");
		    	    			MESSAGEMAN:Broadcast("CodeMod", {Player = PLAYER_1, Command = "speed"} );
		    	    		end;
		    	    	end;
		    	    	if event.PlayerNumber == PLAYER_2 and GAMESTATE:IsSideJoined(PLAYER_2) then
		    	    		if getAvSpeedNonstopCenterMode(PLAYER_2) > 0 then	    	    			
		    	    			addAvNonstopCenterMode(PLAYER_2);
		    	    			self:GetChild("speedBase2"):queuecommand("updateAvText");
		    	    			MESSAGEMAN:Broadcast("EnableAV", {Player = PLAYER_2} );	 
		    	    		else
		    	    			plusSpeedNonstopCenterMode(PLAYER_2);
		    	    			self:GetChild("speedBase2"):queuecommand("updateSpeed");
		    	    			MESSAGEMAN:Broadcast("CodeMod", {Player = PLAYER_2, Command = "speed"} );
		    	    		end;
		    	    	end;

				    end;

		      	return false;
		    end)
    	end;


	end;
};

if GAMESTATE:IsSideJoined(PLAYER_1) then

	baseSelectors[#baseSelectors+1] = createSpeedModifierPlugin(PLAYER_1,false);
end;
if GAMESTATE:IsSideJoined(PLAYER_2) then
	baseSelectors[#baseSelectors+1] = createSpeedModifierPlugin(PLAYER_2,false);
end;

t[#t+1] = baseSelectors;

return t;