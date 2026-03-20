local t = Def.ActorFrame 
{
	OnCommand=cmd(queuecommand,"ProfileUpdate";sleep,1);
	ProfileUpdateCommand=function(self)
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			--creamos las variables de entorno
			if GAMESTATE:Env()["inGameP1"] == false or GAMESTATE:Env()["inGameP1"] == nil then
				createEnvPlayer(PLAYER_1,true);
				GAMESTATE:Env()["inGameP1"] = true;
			end;

			if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
				PROFILEMAN:SaveProfile(PLAYER_1);
				checkPlayerEvaluationSkinExist(PLAYER_1);
			end;						
		end;
		if GAMESTATE:IsHumanPlayer(PLAYER_2) then

			--creamos las variables de entorno
			if GAMESTATE:Env()["inGameP2"] == false or GAMESTATE:Env()["inGameP2"] == nil then
				createEnvPlayer(PLAYER_2,true);
				GAMESTATE:Env()["inGameP2"] = true;
			end;

			if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
				PROFILEMAN:SaveProfile(PLAYER_2);
				checkPlayerEvaluationSkinExist(PLAYER_2);
			end;
				
		end;
	end;
};
return t;
