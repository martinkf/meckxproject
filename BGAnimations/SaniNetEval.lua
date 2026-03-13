local t = Def.ActorFrame{
	OnCommand=function(self)
		self:visible(false);
	end;
	SaniNetClientStateMessageCommand=function(self,params)
		if params.Username ~= '' then
			self:visible(true);
			--Trace("[HEADER] LOGIN :"..params.Username);
			--Trace("[HEADER] CLIENT :"..params.ConnectionId);
			--Trace("[HEADER] CLIENT ENV :"..GAMESTATE:Env()["saninetConnectionId"]);
			
			if #params.Username > 0 then
				MESSAGEMAN:Broadcast("ChangeOnlineNameProfile", {
				    name = GAMESTATE:Env()["saninetUsername"]
				});
			end;
			
		end;
	end;
};


function processPlayerOptions(mods)
	--Trace("PRE MODS PROC:"..mods);
	local modsPlayer = split(",",string.lower(mods));

	--Trace("POST MODS PROC 1:"..modsPlayer[1]);
	--Trace("POST MODS PROC 2:"..modsPlayer[2]);
	--Trace("POST MODS PROC 3:"..modsPlayer[3]);
	--Trace("POST MODS PROC 4:"..modsPlayer[4]);
	--Trace("POST MODS PROC 5:"..modsPlayer[5]);

	local modsProc = {type="",speed=0,decimal=-1,av=0,judg=-1}

	if modsPlayer[1] == "speed" then

		modsProc["type"]="speed";
		if modsPlayer[2] == "1" then
			modsProc["speed"] = 0;
		elseif modsPlayer[2] == "2" then
			modsProc["speed"] = 1;
		elseif modsPlayer[2] == "3" then
			modsProc["speed"] = 2;
		elseif modsPlayer[2] == "4" then
			modsProc["speed"] = 3;
		elseif modsPlayer[2] == "5" then
			modsProc["speed"] = 4;
		elseif modsPlayer[2] == "6" then
			modsProc["speed"] = 5;
		end;

		if modsPlayer[3] == "decimal" then

			if modsPlayer[4] == "25" then
				modsProc["decimal"] = 0;
			elseif modsPlayer[4] == "5" then
				modsProc["decimal"] = 1;
			elseif modsPlayer[4] == "75" then
				modsProc["decimal"] = 2;
			end;

		end;

	end;


	if modsPlayer[1] == "av" then
		modsProc["type"]="av";
		modsProc["av"] = modsPlayer[2];
	end;

	if modsPlayer[5] == "nj" then
		modsProc["judg"]=-1;
	elseif modsPlayer[5] == "hj" then
		modsProc["judg"]=0;
	elseif modsPlayer[5] == "vj" then
		modsProc["judg"]=2;
	elseif modsPlayer[5] == "xj" then
		modsProc["judg"]=3;
	elseif modsPlayer[5] == "uj" then
		modsProc["judg"]=4;
	end;

	return modsProc;
end;


local timerScreen = 99;

--:: 2 PLAYERS ::--
--we are simulating the normal behavior of the evaluation numbers here xD
--arka
local digits = {};
local extra="";
local score_s = "";

local cur_text = "";
local cur_text_digits = "";
local cur_digit = 1;
local cur_loop_digit = 0;

function initializeDataForScrollingScore(score)
	score_s = string.format("%01d",score);
	local len = string.len(score_s);

	if len == 6 then
		extra = "?";
	elseif len == 5 then
		extra = "??";
	elseif len == 4 then
		extra = "???";
	elseif len == 3 then
		extra = "????";
	elseif len == 2 then
		extra = "?????";
	elseif len == 1 then
		extra = "??????";		
	elseif len == 0 then
		extra = "???????";	
	end;

	for i=1,len do
		digits[#digits+1]=string.sub(score_s,i,i);
	end;

end;


function DrawRollingScoreNew(x,y,horizalign,font)

return LoadFont(font)..{

	Name="fontScoreVs2Player";
	OnCommand=function(self)		
		self:x(x);
		self:y(y);
		self:horizalign(horizalign);
	end;

	UpdateBADCommand=function(self)
		
		self:settext(score_s);
	end;


	UpdateCommand=function(self)
		
		if( cur_loop_digit == 5 ) then
			cur_loop_digit = 0;
			cur_text_digits = cur_text_digits..digits[cur_digit];
			cur_digit = cur_digit + 1;
			
			if( cur_digit > #digits ) then
				self:settext(extra..""..cur_text_digits);
				return;
			end;
		end;

		
		cur_text = cur_text_digits..tostring(cur_loop_digit*2+1);

		local cur_text_tamanho = string.len(score_s);
		if cur_text_tamanho == 6 then
			cur_text = "?"..cur_text;
		elseif cur_text_tamanho == 5 then
			cur_text = "??"..cur_text;
		elseif cur_text_tamanho == 4 then
			cur_text = "???"..cur_text;
		elseif cur_text_tamanho == 3 then
			cur_text = "????"..cur_text;
		elseif cur_text_tamanho == 2 then
			cur_text = "?????"..cur_text;
		elseif cur_text_tamanho == 1 then
			cur_text = "??????"..cur_text;
		elseif cur_text_tamanho == 0 then
			cur_text = "????????"..cur_text;
		end;

		self:settext(cur_text);
		cur_loop_digit = cur_loop_digit +1;
		
		self:sleep(.03);
		self:queuecommand('Update');
	end;
	OffCommand=cmd(stoptweening;visible,false);
}
end;




local yStatPos = 269;
local zoomNumbers = 1.26;
local SnapDistance = 37;
local arrayOfRollNumbers = {};
local letterScoreVs2p;
local dataRollNumberMp = {0,0,0,0,0,0}

function createRollingNumbersVersus()

	for i=1,6 do
		t[#t+1] = LoadFont("xolonium 20px")..{
			Name="RnVs"..i.."";
			OnCommand=function(self)
				self:visible(false);
				self:diffusealpha(0);
				self:zoom(zoomNumbers);
				self:zoomy(0);				
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					self:x(SCREEN_CENTER_X+170);
				end;
				if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
					self:x(SCREEN_CENTER_X-170);
				end;

				self:y(yStatPos + SnapDistance * i);
				self:settext(dataRollNumberMp[i]);

				arrayOfRollNumbers["rollNumber"..i] = self;
			end;
			RollNumberTsCommand=function(self)
				--check if the number is less than 3 char.
				local numCharText = string.len(tostring(dataRollNumberMp[i]));
				local padding="";

				if(numCharText == 1) then 
					padding="00";
				elseif(numCharText == 2) then 
					padding="0";
				end;
				
				self:diffusealpha(0);
				self:sleep(1.1);
				self:sleep(0.2*(i-1))
				self:settext(padding..dataRollNumberMp[i]);
				self:visible(true);
				self:zoomy(0);
				self:linear(0.2);
				self:diffusealpha(1);
				self:zoomy(zoomNumbers);
			end;		
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
	end;

end;

function createEmptyLetterScore2PlayerDuel()
	local DelayGradeShow = 2.6;

	local sleepForSpeedIcons=1.05;
	local baseXMods = 0;
	local baseXLetter = 0;
	local baseXProfileVsOnline = 0;

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		baseXMods = SCREEN_CENTER_X+610;
		baseXLetter = SCREEN_CENTER_X+372;
		baseXProfileVsOnline = SCREEN_CENTER_X+298;
	end;
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		baseXMods = SCREEN_CENTER_X-610;
		baseXLetter = SCREEN_CENTER_X-372;
		baseXProfileVsOnline = SCREEN_CENTER_X-308;
	end;

	local videoBanner = "online_2";

	return Def.ActorFrame {
		Name="object2PlayerDuel";

		OnCommand=function(self)
			self:visible(false);
			letterScoreVs2p = self;
		end;

		LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			Name="failPassRes";
			OnCommand=cmd(visible,false;diffusealpha,0;animate,false;setstate,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
			AnimateCommand=cmd(visible,true;Center;x,baseXLetter;y,SCREEN_CENTER_Y;zoom,1.2;diffusealpha,0;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.85;rotationz,-4;accelerate,.1;rotationz,4;accelerate,.1;rotationz,-2;linear,.05;rotationz,2;linear,.05;rotationz,0);

		};
		
		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="passRes";
			OnCommand=cmd(visible,false;diffusealpha,0;animate,false;setstate,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
			AnimateCommand=cmd(visible,true;Center;x,baseXLetter;y,SCREEN_CENTER_Y;zoom,1.4;diffusealpha,0;sleep,DelayGradeShow+ 0.1;linear,0.13;diffusealpha,1;zoom,0.85);			
		};


		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="passResGlow";
			OnCommand=cmd(visible,false;diffusealpha,0;animate,false;setstate,0);	
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
			AnimateCommand=cmd(stoptweening,Center;x,baseXLetter;y,SCREEN_CENTER_Y;zoom,0.4325;diffusealpha,0;visible,true;sleep,DelayGradeShow + 0.1;linear,0.2;diffusealpha,1;zoom,0.95;linear,0.4;zoom,1.8;diffusealpha,0;blend,Blend.Add);
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/ac_play"))..{
			Name="acPlayStatus";
			OnCommand=cmd(visible,false;diffusealpha,0;animate,false;setstate,0);	
			AnimateCommand=cmd(stoptweening,Center;x,baseXLetter;y,SCREEN_CENTER_Y+110;animate,false;zoom,1.4;diffusealpha,0;visible,true;sleep,DelayGradeShow + 0.1;linear,0.13;diffusealpha,1;zoom,0.65);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadActor(THEME:GetPathG("","ScreenEvaluation/score_bg"))..{
			Name="scoreBg";
			OnCommand=cmd(zoom,0.6;zoomx,0.54;zoomy,0.57;diffusealpha,0.4;x,baseXLetter;y,SCREEN_CENTER_Y-150);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/texto-score"))..{
			Name="ScorePlayerBg";
			OnCommand=cmd(zoom,0.32;diffusealpha,1;x,baseXLetter;y,SCREEN_CENTER_Y-182);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		--estoy aca haciendo los rolling numbres del score, completalo!
		DrawRollingScoreNew(baseXLetter,SCREEN_CENTER_Y-162,"HorizAlign_Center","scorebg");

		LoadActor(THEME:GetPathG("","SaniNet/eval/pfg"))..{
			Name="pfgLabel";
			OnCommand=cmd(zoom,0.75;cropright,1;diffusealpha,1;y,SCREEN_CENTER_Y-115;x,baseXLetter;);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/fullcombo"))..{
			Name="fcLabel";
			OnCommand=cmd(zoom,0.75;cropright,1;diffusealpha,1;y,SCREEN_CENTER_Y-115;x,baseXLetter;);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/autoplay"))..{
			Name="autoplayBox";
			OnCommand=cmd(zoom,0.50;cropright,1;diffusealpha,1;y,SCREEN_CENTER_Y-210;x,baseXLetter;);
			AniCommand=function(self)
				self:sleep(0.3);
				self:linear(0.2);
				self:cropright(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		--PROFILE VS

		LoadActor(THEME:GetPathG("","SaniNet/eval/base_profile_vs"))..{
			Name="baseProfileVs";
			OnCommand=cmd(zoom,0.62;diffusealpha,1;x,baseXProfileVsOnline;y,SCREEN_CENTER_Y-328);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadActor( THEME:GetPathG("","SaniNet/eval/"..videoBanner) )..{
			Name="backgroundImg";
			OnCommand=function(self)
				self:x(baseXProfileVsOnline);
				self:y(SCREEN_CENTER_Y-328);			
				self:scaletoclipped(286,44);
				self:diffusealpha(0.6);
				self:play();
			end;
		};

		LoadActor(THEME:GetPathG("","SaniNet/signal"))..{
			Name="baseProfileVs";
			OnCommand=cmd(zoom,0.22;diffusealpha,0.9;x,baseXProfileVsOnline-135;y,SCREEN_CENTER_Y-342);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadFont("_XoloPlayer")..{
			OnCommand=cmd(zoom,0.7;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;y,SCREEN_CENTER_Y-340;x,baseXProfileVsOnline;settext,"VS");
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		LoadFont("_XoloPlayer")..{
			Name="playerNameVs";
			OnCommand=cmd(zoom,0.9;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;y,SCREEN_CENTER_Y-321;x,baseXProfileVsOnline;settext,"-");
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


		--AUTOICON
		LoadActor( THEME:GetPathG("","CommandWindow/AUTOicon") )..{
			Name="autoIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:x(baseXMods);
				self:y(SCREEN_CENTER_Y-210);
				self:zoom(0.5);
			end;
		};


		--here we add the basic mods, velocity and judgment.
		--velocity
		LoadActor( THEME:GetPathG("","CommandWindow/Icons02 13x1") )..{
			Name="speedIconModA";
			OnCommand=function(self)
				self:visible(false);
				self:animate(false);
				self:setstate(0);
				self:x(baseXMods);
				self:y(SCREEN_CENTER_Y-165);
				self:zoom(0.5);
			end;
		};
		--decimals
		LoadActor( THEME:GetPathG("","CommandWindow/Icons02 13x1") )..{
			Name="speedIconModB";
			OnCommand=function(self)
				self:visible(false);				
				self:animate(false);
				self:x(baseXMods);
				self:y(SCREEN_CENTER_Y-165);
				self:setstate(6);
				self:zoom(0.5);
				self:diffusealpha(0);
			end;
			AniCommand=function(self)
				self:setstate(6);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(1);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(0);
				self:queuecommand("Ani");
			end;

			AniBCommand=function(self)
				self:setstate(7);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(1);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(0);
				self:queuecommand("AniB");
			end;

			AniFullACommand=function(self)
				self:setstate(6);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(1);
				self:sleep(sleepForSpeedIcons);
				self:queuecommand("AniFullB");
			end;

			AniFullBCommand=function(self)
				self:setstate(7);
				self:sleep(sleepForSpeedIcons);
				self:diffusealpha(0);
				self:queuecommand("AniFullA");
			end;
			
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

		};

		--AV
		LoadActor( THEME:GetPathG("","CommandWindow/AVicon") )..{
			Name="avIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:x(baseXMods);
				self:y(SCREEN_CENTER_Y-165);
				self:zoom(0.5);
			end;
		};


		LoadFont("interphase/InterNumber numbers").. {
				Name="AVText";
				OnCommand=function(self)
					self:visible(false);
					self:horizalign(center);
					self:x(baseXMods-1);
					self:y(SCREEN_CENTER_Y-170);					
					self:zoom(0.42);
					self:settext("");

				end;
		};

		--judg
		LoadActor( THEME:GetPathG("","CommandWindow/Icons07 17x1") )..{
			Name="judgIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:animate(false);
				self:setstate(0);
				self:x(baseXMods);
				self:y(SCREEN_CENTER_Y+65);
				self:zoom(0.5);
			end;
		};

	}

end;

function UpdateGraphicsFor2PlayerDuel(playerStats)
	

	
	local place = playerStats["place"];
	local playerName = playerStats["player"];
	local pf = playerStats["perfect"];
	local gr = playerStats["great"];
	local gd = playerStats["good"];
	local bd = playerStats["bad"];
	local miss = playerStats["miss"];
	local combo = playerStats["maxCombo"];
	local score = playerStats["score"];
	local failed = playerStats["failed"];
	local autoPlay = playerStats["autoPlay"];

	local isDraw = playerStats["isDraw"];
	local drawPlace = playerStats["drawPlace"];

	local playerOptions = playerStats["playerOptions"];
	--Trace("modssss"..playerOptions);



	--process the mods to show.
	local modsProcData = processPlayerOptions(playerOptions);

	--Velocity
	--[[
	Trace("::::::TYPE::::::::"..modsProcData["type"]);
	Trace("::::::SPEED:::::::"..modsProcData["speed"]);
	Trace("::::::DECIMAL:::::::"..modsProcData["decimal"]);
	Trace("::::::AV:::::::"..modsProcData["av"]);
	Trace("::::::JUDG:::::::"..modsProcData["judg"]);
	]]


	if modsProcData["type"] == "speed" then
		letterScoreVs2p:GetChild("avIconMod"):visible(false);
		letterScoreVs2p:GetChild("speedIconModA"):setstate(modsProcData["speed"]);
		letterScoreVs2p:GetChild("speedIconModA"):visible(true);

		--decimals.
		if modsProcData["decimal"] > -1 then
			if modsProcData["decimal"] == 0 then				
				letterScoreVs2p:GetChild("speedIconModB"):visible(true);
				letterScoreVs2p:GetChild("speedIconModB"):playcommand("Ani");
			elseif modsProcData["decimal"] == 1 then
				letterScoreVs2p:GetChild("speedIconModB"):visible(true);
				letterScoreVs2p:GetChild("speedIconModB"):playcommand("AniB");
			elseif modsProcData["decimal"] == 2 then
				letterScoreVs2p:GetChild("speedIconModB"):visible(true);
				letterScoreVs2p:GetChild("speedIconModB"):playcommand("AniFullA");
			else
				letterScoreVs2p:GetChild("speedIconModB"):visible(false);
			end;
		end;
	elseif modsProcData["type"] == "av" then
		letterScoreVs2p:GetChild("avIconMod"):visible(true);
		letterScoreVs2p:GetChild("speedIconModA"):visible(false);
		letterScoreVs2p:GetChild("speedIconModB"):visible(false);
		letterScoreVs2p:GetChild("AVText"):settext(modsProcData["av"]);
		letterScoreVs2p:GetChild("AVText"):visible(true);
	end;

	--Judgment
	if modsProcData["judg"] == -1 then
		letterScoreVs2p:GetChild("judgIconMod"):visible(false);
	else
		letterScoreVs2p:GetChild("judgIconMod"):setstate(modsProcData["judg"]);
		letterScoreVs2p:GetChild("judgIconMod"):visible(true);
	end;
	


	--[[
	Trace("place:"..playerStats["place"]);
	Trace("playerName:"..playerStats["player"]);
	Trace("pf:"..playerStats["perfect"]);
	Trace("gr:"..playerStats["great"]);
	Trace("gd:"..playerStats["good"]);
	Trace("bad:"..playerStats["bad"]);
	Trace("miss:"..playerStats["miss"]);
	Trace("combo:"..playerStats["maxCombo"]);
	Trace("score:"..playerStats["score"]);
	]]
	--debug data
		--[[
	pf = 1200;
	gr = 350;
	gd = 450;
	bd = 20;
	miss = 40;
	combo = 750;
	]]
	--
	--what status is
    local clearStatus = -1;
    local isPfc=false;
    local isFc=false;
    
    if miss > 0 then
	    if miss > 20 then --RG  
	    	clearStatus = 7;
	    else
	    	if miss <= 5 then --MG
	    		clearStatus = 4;
	    	elseif miss <= 10 then --TG
	    		clearStatus = 5;
	    	elseif miss <= 20 then --FG
	    		clearStatus = 6;
	    	end;
	    end; 
	elseif pf == 0 and gr == 0 and gd == 0 and bd == 0 and miss == 0 then
		clearStatus = 4;
		isPfc = true;
	else
	    
	    if pf > 0 and gr == 0 and gd == 0 and bd == 0 and miss == 0 then --ap
	    	clearStatus = 0;
	    	isPfc = true;
	    elseif pf >= 0 and gr > 0 and gd == 0 and bd == 0 and miss == 0 then --UG
	    	clearStatus = 1;
	    	isFc = true;
	    elseif pf >= 0 and gr >= 0 and gd > 0 and bd == 0 and miss == 0 then --EG
	    	clearStatus = 2;
	    	isFc = true;
	    elseif pf >= 0 and gr >= 0 and gd >= 0 and bd > 0 and miss == 0 then --superb
	    	clearStatus = 3;
	    end;		
	end;

	if clearStatus == -1 then
		clearStatus = 0;
	end;


	-- :: PROFILE NAME :: --
	letterScoreVs2p:GetChild("playerNameVs"):settext(string.upper(playerName));


	-- :: UPDATE TS RESULT NUMBERS :: --
	dataRollNumberMp[1] = pf;
	dataRollNumberMp[2] = gr;
	dataRollNumberMp[3] = gd;
	dataRollNumberMp[4] = bd;
	dataRollNumberMp[5] = miss;
	dataRollNumberMp[6] = combo;
	

	letterScoreVs2p:visible(true);

	for i=1,6 do
		arrayOfRollNumbers["rollNumber"..i]:queuecommand("RollNumberTs");
	end;

	
	if autoPlay then
		--letterScoreVs2p:GetChild("autoplayBox"):queuecommand("Ani");
		letterScoreVs2p:GetChild("autoIconMod"):visible(true);
	end;

	-- :: UPDATE THE LETTER  AND SCORE :: --
	local stateLetter = gradeTransformState(score);
	if failed then
		letterScoreVs2p:GetChild("failPassRes"):setstate(stateLetter);
		letterScoreVs2p:GetChild("failPassRes"):queuecommand("Animate");
	else
		letterScoreVs2p:GetChild("passRes"):setstate(stateLetter);
		letterScoreVs2p:GetChild("passResGlow"):setstate(stateLetter);

		letterScoreVs2p:GetChild("passRes"):queuecommand("Animate");
		letterScoreVs2p:GetChild("passResGlow"):queuecommand("Animate");

		letterScoreVs2p:GetChild("acPlayStatus"):setstate(clearStatus);
		letterScoreVs2p:GetChild("acPlayStatus"):queuecommand("Animate");

		--
		if isPfc then
			letterScoreVs2p:GetChild("pfgLabel"):queuecommand("Ani");
		end;

		if isFc then
			letterScoreVs2p:GetChild("fcLabel"):queuecommand("Ani");
		end;

	end;

	-- :: UPDATE THE SCORE :: --
	initializeDataForScrollingScore(score);
	letterScoreVs2p:GetChild("fontScoreVs2Player"):sleep(1):queuecommand("Update");
end;




createRollingNumbersVersus();
t[#t+1] = createEmptyLetterScore2PlayerDuel();




--:: 3+ PLAYERS ::--

local numBoxes = 4;
local playerBoxesMp = {}; --this will save the boxes for multiplyaer with more than 2 players.
local baseX=0;
local baseYMult=140;
if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	baseX = SCREEN_CENTER_X + 380;
end;
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	baseX = SCREEN_CENTER_X - 380;
end;

function checkDraw(playerList)
	for i=1,#playerList do

	end;
end;



function createEmptyGraphicsForMpMultiResult(place)
	return Def.ActorFrame{

		OnCommand = function(self)
			self:x(baseX);
			self:y(SCREEN_CENTER_Y-160 + (place)* baseYMult);
			self:visible(false);

			self:GetChild("fullcombo"):diffusealpha(0):visible(false);
			self:GetChild("pfc"):diffusealpha(0):visible(false);
			self:GetChild("gradeScore"):diffusealpha(0):visible(false);	
			self:GetChild("gradeScoreFail"):diffusealpha(0):visible(false);


			self:GetChild("playerName"):settext("");
			self:GetChild("pf"):settext(0);
			self:GetChild("gr"):settext(0);
			self:GetChild("gd"):settext(0);
			self:GetChild("bad"):settext(0);
			self:GetChild("miss"):settext(0);
			self:GetChild("combo"):settext(0);
			self:GetChild("score"):settext(0);
			self:GetChild("placePlayer"):setstate(place);

			self:GetChild("gradeScore"):setstate(0);	
			self:GetChild("gradeScoreFail"):setstate(0);
			self:GetChild("gradeScore"):diffusealpha(1):visible(true);
			self:GetChild("gradeScoreFail"):diffusealpha(0):visible(false);	

			self:GetChild("fullcombo"):diffusealpha(0):visible(false);
			self:GetChild("pfc"):diffusealpha(0):visible(false);
			playerBoxesMp["mpBox"..place] = self;
		end;

		OffCommand=function(self)
			self:stoptweening();
			self:linear(0.15);
			self:diffusealpha(0);
		end;

		LoadActor(THEME:GetPathG("","SaniNet/eval/backevalplayer"))..{
			OnCommand=cmd(diffusealpha,1;zoom,0.68;);
			SaniNetEvaluationStatsMessageCommand=function(self,params)
			end;
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/score_text"))..{
			OnCommand=cmd(diffusealpha,1;zoom,0.2;y,-38;x,77);
			SaniNetEvaluationStatsMessageCommand=function(self,params)

			end;
		};

		LoadFont('_XoloPlayer')..
		{
			Name="playerName";
			OnCommand=function(self,params)
				self:x(0):y(-59):zoom(0.65):vertspacing(-8):horizalign(center):uppercase(true);
			end;			

		};	

		LoadFont('xolonium 20px')..
		{
			Name="pf";
			OnCommand=function(self,params)
				self:x(-55):y(-37):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};	

		LoadFont('xolonium 20px')..
		{
			Name="gr";
			OnCommand=function(self,params)
				self:x(-55):y(-19):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};	

		LoadFont('xolonium 20px')..
		{
			Name="gd";
			OnCommand=function(self,params)
				self:x(-55):y(0):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};		

		LoadFont('xolonium 20px')..
		{
			Name="bad";
			OnCommand=function(self,params)
				self:x(-55):y(19):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};	

		LoadFont('xolonium 20px')..
		{
			Name="miss";
			OnCommand=function(self,params)
				self:x(-55):y(37):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};		

		LoadFont('xolonium 20px')..
		{
			Name="combo";
			OnCommand=function(self,params)
				self:x(-55):y(55):zoom(0.6):vertspacing(-8):horizalign(left);
				self:settext(0);
			end;
		};	

		LoadFont('scorebg')..
		{
			Name="score";
			OnCommand=function(self,params)
				self:x(77):y(-23):zoom(0.5):vertspacing(10):horizalign(center);
				self:settext("0000000");
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="gradeScore";
			OnCommand=function(self)			
				self:diffusealpha(0);			
				self:animate(false);
				self:setstate(0);
				self:x(77);
				self:y(28);
				self:zoom(0.4);
				self:linear(0.1);
				self:zoom(0.3);
			end;
		};

		LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			Name="gradeScoreFail";
			OnCommand=function(self)			
				self:diffusealpha(0);			
				self:animate(false);
				self:setstate(0);
				self:x(77);
				self:y(28);
				self:zoom(0.4);
				self:linear(0.1);
				self:zoom(0.3);
			end;
		};

		--place
		LoadActor(THEME:GetPathG("","SaniNet/eval/places 1x8"))..{
			Name="placePlayer";
			OnCommand=function(self)
				self:x(185);
				self:y(-52);
				self:diffusealpha(1);
				self:zoom(0.5);
				self:animate(false);
				self:setstate(place);
			end;
		};

		--AUTOICON
		LoadActor( THEME:GetPathG("","CommandWindow/AUTOicon") )..{
			Name="autoIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:x(185);
				self:y(48);
				self:zoom(0.4);
			end;
		};

		--vel
		LoadActor( THEME:GetPathG("","CommandWindow/Icons02 13x1") )..{
			Name="speedIconModA";
			OnCommand=function(self)
				self:visible(false);
				self:animate(false);
				self:setstate(0);
				self:x(185);
				self:y(-20);
				self:zoom(0.4);
			end;
		};

		--decimals
		LoadActor( THEME:GetPathG("","CommandWindow/Icons02 13x1") )..{
			Name="speedIconModB";
			OnCommand=function(self)
				self:visible(true);				
				self:animate(false);
				self:x(185);
				self:y(-20);
				self:zoom(0.4);
				self:setstate(6);
				self:diffusealpha(0);
			end;
			AniCommand=function(self)
				self:setstate(6);
				self:sleep(1.3);
				self:diffusealpha(1);
				self:sleep(1.3);
				self:diffusealpha(0);
				self:queuecommand("Ani");
			end;

			AniBCommand=function(self)
				self:setstate(7);
				self:sleep(1.3);
				self:diffusealpha(1);
				self:sleep(1.3);
				self:diffusealpha(0);
				self:queuecommand("AniB");
			end;

			AniFullACommand=function(self)
				self:setstate(6);
				self:sleep(1.3);
				self:diffusealpha(1);
				self:sleep(1.3);
				self:queuecommand("AniFullB");
			end;

			AniFullBCommand=function(self)
				self:setstate(7);
				self:sleep(1.3);
				self:diffusealpha(0);
				self:queuecommand("AniFullA");
			end;
			
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;

		};

		Def.ActorFrame {			
			Name="waiting";
			LoadActor(THEME:GetPathG("","SaniNet/eval/back_waiting"))..{
				OnCommand=cmd(diffusealpha,1;zoom,0.68;);
			};

			LoadActor(THEME:GetPathG("","SaniNet/eval/result_waiting"))..{
				OnCommand=cmd(diffusealpha,1;zoom,0.68;queuecommand,"Ani");

				AniCommand=function(self)
					self:linear(0.5);
					self:diffusealpha(0.5);
					self:linear(0.5);
					self:diffusealpha(1);
					self:queuecommand("Ani");
				end;

				OffCommand=function(self)
					self:stoptweening();
					self:linear(0.15);
					self:diffusealpha(0);
				end;
			};

			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};

		--AV
		LoadActor( THEME:GetPathG("","CommandWindow/AVicon") )..{
			Name="avIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:x(185);
				self:y(-20);
				self:zoom(0.4);
			end;
		};


		LoadFont("interphase/InterNumber numbers").. {
				Name="AVText";
				OnCommand=function(self)
					self:visible(false);
					self:horizalign(center);
					self:x(183);
					self:y(-24);					
					self:zoom(0.32);
					self:settext("565");

				end;
		};

		--judg
		LoadActor( THEME:GetPathG("","CommandWindow/Icons07 17x1") )..{
			Name="judgIconMod";
			OnCommand=function(self)
				self:visible(false);
				self:animate(false);
				self:setstate(0);
				self:x(185);
				self:y(14);
				self:zoom(0.4);
			end;
		};

	    --fullcombo
		LoadActor(THEME:GetPathG("","SaniNet/eval/fullcombo"))..{
			Name="fullcombo";
			OnCommand=function(self)
				self:x(120);
				self:y(48);
				self:visible(false);
				self:diffusealpha(0);
				self:zoom(0.45);
				
			end;
		};
	    --pfc
		LoadActor(THEME:GetPathG("","SaniNet/eval/pfg"))..{
			Name="pfc";
			OnCommand=function(self)
				self:x(120);
				self:y(48);
				self:visible(false);
				self:diffusealpha(0);
				self:zoom(0.45);

			end;
		};


	};
end;

for i=1,numBoxes do
	t[#t+1] = createEmptyGraphicsForMpMultiResult(i-1);
end;


function updateBoxMpPlayerData(playerStats,placePlayer)

	

	local place = playerStats["place"];

	local playerName = playerStats["player"];
	local pf = playerStats["perfect"];
	local gr = playerStats["great"];
	local gd = playerStats["good"];
	local bd = playerStats["bad"];
	local miss = playerStats["miss"];
	local combo = playerStats["maxCombo"];
	local score = playerStats["score"];
	local failed = playerStats["failed"];
	local autoPlay = playerStats["autoPlay"];

	local isDraw = playerStats["isDraw"];
	local drawPlace = playerStats["drawPlace"];
	local playerOptions = playerStats["playerOptions"];

	local boxMp = playerBoxesMp["mpBox"..placePlayer];
	boxMp:stoptweening():visible(true):zoom(1):diffusealpha(1);
	boxMp:GetChild("waiting"):visible(false);

	local isPfc=false;
	local isFc=false;

	if pf > 0 and gr == 0 and gd == 0 and bd == 0 and miss == 0 then
		isPfc = true;
	elseif pf > 0 and gr > 0 and gd > 0 and bd == 0 and miss == 0 then
		isFc = true;
	end;


	--process the mods to show.
	local modsProcData = processPlayerOptions(playerOptions);

	--Velocity
	--[[
	Trace("::::::TYPE::::::::"..modsProcData["type"]);
	Trace("::::::SPEED:::::::"..modsProcData["speed"]);
	Trace("::::::DECIMAL:::::::"..modsProcData["decimal"]);
	Trace("::::::AV:::::::"..modsProcData["av"]);
	Trace("::::::JUDG:::::::"..modsProcData["judg"]);
	]]


	if modsProcData["type"] == "speed" then
		boxMp:GetChild("avIconMod"):visible(false);
		boxMp:GetChild("speedIconModA"):setstate(modsProcData["speed"]);
		boxMp:GetChild("speedIconModA"):visible(true);

		--decimals.
		if modsProcData["decimal"] > -1 then
			if modsProcData["decimal"] == 0 then				
				boxMp:GetChild("speedIconModB"):visible(true);
				boxMp:GetChild("speedIconModB"):playcommand("Ani");
			elseif modsProcData["decimal"] == 1 then
				boxMp:GetChild("speedIconModB"):visible(true);
				boxMp:GetChild("speedIconModB"):playcommand("AniB");
			elseif modsProcData["decimal"] == 2 then
				boxMp:GetChild("speedIconModB"):visible(true);
				boxMp:GetChild("speedIconModB"):playcommand("AniFullA");
			else
				boxMp:GetChild("speedIconModB"):visible(false);
			end;
		end;
	elseif modsProcData["type"] == "av" then
		boxMp:GetChild("avIconMod"):visible(true);
		boxMp:GetChild("speedIconModA"):visible(false);
		boxMp:GetChild("speedIconModB"):visible(false);
		boxMp:GetChild("AVText"):settext(modsProcData["av"]);
		boxMp:GetChild("AVText"):visible(true);
	end;

	--Judgment
	if modsProcData["judg"] == -1 then
		boxMp:GetChild("judgIconMod"):visible(false);
	else
		boxMp:GetChild("judgIconMod"):setstate(modsProcData["judg"]);
		boxMp:GetChild("judgIconMod"):visible(true);
	end;




	boxMp:GetChild("playerName"):settext(playerName);
	boxMp:GetChild("pf"):settext(pf);
	boxMp:GetChild("gr"):settext(gr);
	boxMp:GetChild("gd"):settext(gd);
	boxMp:GetChild("bad"):settext(bd);
	boxMp:GetChild("miss"):settext(miss);
	boxMp:GetChild("combo"):settext(combo);
	boxMp:GetChild("score"):settext(score);
	local letterState = gradeTransformState(tonumber(score));
	boxMp:GetChild("gradeScore"):setstate(letterState);	
	boxMp:GetChild("gradeScoreFail"):setstate(letterState);
	--boxMp:GetChild("placePlayer"):setstate(newPlace);



	if failed then
		boxMp:GetChild("gradeScore"):diffusealpha(0):visible(false);	
		boxMp:GetChild("gradeScoreFail"):diffusealpha(1):visible(true);
	else
		boxMp:GetChild("gradeScoreFail"):diffusealpha(0):visible(false);	
		boxMp:GetChild("gradeScore"):diffusealpha(1):visible(true);
	end;

	if autoPlay then				
		boxMp:GetChild("autoIconMod"):diffusealpha(1):visible(true);
	end;

	if isPfc then
		boxMp:GetChild("pfc"):diffusealpha(1):visible(true);
		boxMp:GetChild("fullcombo"):diffusealpha(0):visible(false);
	elseif isFc then
		boxMp:GetChild("fullcombo"):diffusealpha(1):visible(true);
		boxMp:GetChild("pfc"):diffusealpha(0):visible(false);
	else
		boxMp:GetChild("fullcombo"):diffusealpha(0):visible(false);
		boxMp:GetChild("pfc"):diffusealpha(0):visible(false);
	end;

	--boxMp:stoptweening():diffusealpha(0):zoom(1.2):visible(true):decelerate(0.15):zoom(1):diffusealpha(1);

end;

--all pos ready
local roomUserStatus = {0,0,0,0};
local usersIdProcesed = {};
local playerResultMp = {};
local userReadyToShow = false;

--4 players
--pos 0 to 3 (n-1);
for i=1,#roomUserStatus do
	t[#t+1] = Def.ActorFrame{
		SaniNetEvaluationStatsMessageCommand=function(self,params)
			if (i - 1) == params.Position then
				--we well use the parameter "Score" to have the place of the player 
				--and we well be using the ScorePhoenix to calc everything
				--until we have a parameter called "VsPlace" we'll be using "Score".

				local whatSideIam=0;
				local itsMe=false;
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
					whatSideIam = 1;
				end;
				if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
					whatSideIam = 2;
				end;


				if GAMESTATE:Env()["saninetConnectionId"] == params["ConnectionId"] then
					itsMe = true;
				end;

				local playerData = {					
					idUser = params["ConnectionId"],
					player = params["Username"],
					place = params["VsPlace"],
					slot_room = params.Position,
					perfect = params["Perfect"] + params["CheckpointHit"],
					great = params["Great"],
					good = params["Good"],
					bad = params["Bad"],
					miss = params["Miss"] + params["CheckpointMiss"],
					score = params["ScorePhoenix"],
					percentScore = params["ScorePercent"],
					maxCombo = params["MaxCombo"],
					autoPlay = params["AutoPlay"],
					failed = params["Failed"],
					playerOptions = params["PlayerOptions"],
					-- if this is a draw with a for example 2st place, it ill change this place (3rd) for the 2nd as draw
					-- and whill show a icon "DRAW".
					isDraw = false,
					drawPlace = 4,
					partyCount = params["PartyCount"],
					thisClientSide = whatSideIam,
					itsMyRecord = itsMe,
					statusUserSeval = params["EvaluationDataReady"]
				}


				if params["Perfect"] == 0 and params["Great"] == 0 and params["Good"] == 0 and params["Bad"] == 0 and params["Miss"] == 0 and params["MaxCombo"] == 0 and params["ScorePhoenix"] == 0 then
					--Trace("Datos recibidos del jugador:"..params["ConnectionId"]);
					--Trace(":: "..params["ConnectionId"].." ::SONG DATA EMPTY");
				else
					--[[
					for k, v in pairs(params) do
					    Trace(":"..params["ConnectionId"]..":::::::::: Param " .. tostring(k) .. " = " .. tostring(v))
					end
					]]

					--Trace("::::::::: "..params["ConnectionId"].."  :::::: Status of MP score -> "..playerData["statusUserSeval"]);
					if not playerData["statusUserSeval"] then
						--Trace("::::::::: "..params["ConnectionId"].."  :::::: rank is not ready");
						return;
					end;

					--we check if we already have this data for this user
					local isThisUserReady=false;

					for x=1,#usersIdProcesed do
						if usersIdProcesed[x] == params["ConnectionId"] then
							isThisUserReady = true;
						end;
					end;

					if isThisUserReady == false then
						table.insert(playerResultMp,playerData);
						if params["PartyCount"] == 2 and itsMe == false then
							UpdateGraphicsFor2PlayerDuel(playerData)
						end;

						roomUserStatus[i] = 1;
						table.insert(usersIdProcesed,params["ConnectionId"]);
					end;

				end; 
			end;
		end;
	};
end;

--:: alone with online records ::--

--max 7 records [3 above | me | 3 below]
local onlineRecordsObjects = {};
local xBaseOnlineRecords = SCREEN_CENTER_X;
local yBaseOnlineRecords = SCREEN_CENTER_Y-160;
local yBaseOffsetOnlineRecords = 50;
local enterOffset=0.05;

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	xBaseOnlineRecords = SCREEN_CENTER_X+380;
end;
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	xBaseOnlineRecords = SCREEN_CENTER_X-380;
end;

t[#t+1] = LoadActor(THEME:GetPathG("","SaniNet/eval/onlineranking_text"))..{			
	Name="logoRankingOnline";
	OnCommand=function(self)
		self:x(xBaseOnlineRecords);
		self:y(yBaseOnlineRecords-40);
		self:zoom(0.4);
		self:visible(false);
	end;

	SaniNetEvaluationStatsMessageCommand=function(self,params)

			--Trace("### PARAM RankingData:"..params["RankingData"]);
			local dataServer = params["RankingData"];
			local partyCount = params["PartyCount"];
			if #dataServer == 0 or partyCount > 0 then
				--no data
				self:visible(false);
				return;
			else
				self:visible(true);
			end;

			for i=1,#dataServer do
				local place = dataServer[i]["index"];
				local playerName = dataServer[i]["player_name"];
				local instanceType = dataServer[i]["player_type"];
				local judgRecord = dataServer[i]["judg"];
				local scoreRecord = dataServer[i]["score"];
				local dateRecord = dataServer[i]["date"];
				local diffScore =dataServer[i]["diff"];
				local itsMe = dataServer[i]["me"];
				local itsFc = dataServer[i]["fc"];
				local itsPfc = dataServer[i]["pfc"];



				--Place
				onlineRecordsObjects[i]:GetChild("placeRanking"):stoptweening():settext(place);

				--lights and tags-
				local stateLamp = 4;
				if scoreRecord == 1000000 or itsPfc then
					stateLamp = 2;
					onlineRecordsObjects[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("0.549,0.894,1,0")):effectcolor2(color("0.549,0.894,1,0.5")):effectperiod(0.1):visible(true):diffusealpha(0.25);
					onlineRecordsObjects[i]:GetChild("pfcTag"):stoptweening():visible(true);

					onlineRecordsObjects[i]:GetChild("backRecordOnline"):stoptweening():setstate(2);
				elseif itsFc then
					stateLamp = 1;
					onlineRecordsObjects[i]:GetChild("lampRankingGlow"):stoptweening():glowshift():effectcolor1(color("#FFA23900")):effectcolor2(color("#FFA239FF")):effectperiod(0.1):visible(true):diffusealpha(0.25);
					onlineRecordsObjects[i]:GetChild("fcomboTag"):stoptweening():visible(true);

					onlineRecordsObjects[i]:GetChild("backRecordOnline"):stoptweening():setstate(1);
				else
					stateLamp = 4;
					onlineRecordsObjects[i]:GetChild("lampRankingGlow"):stoptweening():visible(false);
					onlineRecordsObjects[i]:GetChild("fcomboTag"):stoptweening():visible(false);
					onlineRecordsObjects[i]:GetChild("pfcTag"):stoptweening():visible(false);

					onlineRecordsObjects[i]:GetChild("backRecordOnline"):stoptweening():setstate(0);
				end;

				onlineRecordsObjects[i]:GetChild("lampRanking"):stoptweening():setstate(stateLamp);

				--Name
				onlineRecordsObjects[i]:GetChild("nameRank"):stoptweening():settext(string.upper(playerName));
				--Letter
				local stateRank = gradeTransformState(scoreRecord);
				onlineRecordsObjects[i]:GetChild("passRes"):stoptweening():setstate(stateRank);
				--Score
				local backScore = getZeroStringFromScore(scoreRecord);
				onlineRecordsObjects[i]:GetChild("scoreBackRank"):stoptweening():settext(backScore);
				onlineRecordsObjects[i]:GetChild("scoreFrontRank"):stoptweening():settext(scoreRecord);

				--things
				local colorDif = "#FFFFFF";
				local textDiffScore = diffScore;

				if diffScore > 0 then
					colorDif = "#00fc1e";
					textDiffScore = "+"..diffScore;
				elseif diffScore == 0 then
					colorDif = "#FFFFFF";
					textDiffScore = "0";
				elseif diffScore < 0 then
					colorDif = "#FC0000";
					textDiffScore = diffScore;
				end;

				onlineRecordsObjects[i]:GetChild("diffRecord"):stoptweening():diffuse(color(colorDif)):settext(textDiffScore);

				--mark if it is my record
				if itsMe then
					onlineRecordsObjects[i]:GetChild("meMarkRecord"):stoptweening():queuecommand("Ani");
				end;

				--date
				
				onlineRecordsObjects[i]:GetChild("dateRecord"):stoptweening():settext(dateRecord)
				--judgment

				--type of client
				-- 0 keyboard
				-- 1 arcade
				if instanceType == 0 then
					onlineRecordsObjects[i]:GetChild("typeClientRank"):setstate(1);
				elseif instanceType == 1 then
					onlineRecordsObjects[i]:GetChild("typeClientRank"):setstate(0);
				else
					onlineRecordsObjects[i]:GetChild("typeClientRank"):setstate(1);
				end;

				if judgRecord == "hj" then
					onlineRecordsObjects[i]:GetChild("judgPlayerRank"):setstate(1);
				elseif judgRecord == "vj" then
					onlineRecordsObjects[i]:GetChild("judgPlayerRank"):setstate(2);
				elseif judgRecord == "xj" then
					onlineRecordsObjects[i]:GetChild("judgPlayerRank"):setstate(3);
				elseif judgRecord == "uj" then
					onlineRecordsObjects[i]:GetChild("judgPlayerRank"):setstate(4);
				else
					onlineRecordsObjects[i]:GetChild("judgPlayerRank"):setstate(0);
				end;

				--we show the rank
				onlineRecordsObjects[i]:stoptweening():queuecommand("AniEntrance");
			end;

	end;

	FinalizedMessageCommand=cmd(finishtweening;visible,false);
};

for i=1,9 do

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)			
			self:x(xBaseOnlineRecords);
			self:y(yBaseOnlineRecords+( (i-1)*yBaseOffsetOnlineRecords ));			
			self:zoom(0.6);
			self:visible(false);
			onlineRecordsObjects[i] = self;
		end;
		AniEntranceCommand=function(self)
			self:x(xBaseOnlineRecords-10);
			self:diffusealpha(0);
			self:visible(true);
			self:sleep(enterOffset*(i-1));
			self:linear(0.35);
			self:diffusealpha(1);
			self:x(xBaseOnlineRecords);
		end;
		FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);

		Def.Quad{
			Name="meMarkRecord";
			InitCommand=cmd(setsize,145,50;diffuse,color('1,1,1,1');visible,false;diffusealpha,1;x,-360;diffusealpha,0.4);
			AniCommand=function(self)
				self:fadeleft(0.7);
				self:cropleft(1);
				self:visible(true);
				self:linear(0.2);
				self:cropleft(0);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/backrecord"))..{			
			Name="backRecordOnline";
			InitCommand=cmd(zoom,1;zoomy,0.96;animate,false,setstate,0;y,2);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/lamp_ranking"))..{			
			Name="lampRanking";
			InitCommand=cmd(x,-259;zoom,1;animate,false;setstate,2);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		LoadActor(THEME:GetPathG("","SaniNet/eval/glow_lamp"))..{			
			Name="lampRankingGlow";
			InitCommand=cmd(x,-259;zoom,1;blend,"BlendMode_Add";visible,false);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};
		
		LoadActor(THEME:GetPathG("","ScreenEvaluation/fail_pass_res"))..{
			Name="failPassRes";
			InitCommand=cmd(zoom,0.3;x,209;visible,false;diffusealpha,0;animate,false;setstate,0);
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
			

		};
		
		LoadActor(THEME:GetPathG("","ScreenEvaluation/pass_res"))..{
			Name="passRes";
			InitCommand=cmd(zoom,0.3;x,209;visible,true;diffusealpha,1;animate,false;setstate,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};



		LoadFont("_TitleXolonium")..{	
				Name="nameRank";
				InitCommand=function(self)
					self:zoom(0.9);
					self:horizalign("left");
					self:x(-270);
					self:y(-2);
					self:settext("-");
					self:shadowlength(2);
					self:shadowcolor(color("#191919"));

				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};


		LoadFont("scorebg")..{	
				Name="scoreBackRank";
				InitCommand=function(self)
					self:diffusecolor(color("#787878"));
					self:zoom(0.9);
					self:horizalign("left");
					self:settext("0000000");
					self:x(-90);
					self:y(-20);				
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	

		LoadFont("scorebg")..{	
				Name="scoreFrontRank";
				InitCommand=function(self)
					self:zoom(0.9);
					self:horizalign("right");
					self:settext("");
					self:x(150);
					self:y(-20);	
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};

		LoadFont("xolonium 20px")..{
				Name="dateRecord";	
				OnCommand=cmd(zoom,0.9;y,18;x,-85;horizalign,left;shadowlength,1;shadowcolor,color("#191919");settext,"-");
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};


		LoadFont("xolonium 20px")..{
				Name="diffRecord";	
				OnCommand=cmd(zoom,0.9;y,18;x,148;horizalign,right;shadowlength,1;shadowcolor,color("#191919");diffuse,color("#00fc1e");settext,"-");
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};


		LoadFont("interphase/InterNumber numbers").. {
			Name="placeRanking";
			InitCommand=function(self)
				self:visible(true);
				self:zoom(1);
				self:y(-32);
				self:horizalign("right");
				self:settext("0");
				self:x(-298);
			end;
			FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};


		LoadActor(THEME:GetPathG("","SaniNet/eval/judgPlayer"))..{
			Name="judgPlayerRank";
			OnCommand=cmd(zoom,1;x,312;y,-20;visible,true;diffusealpha,1;animate,false;setstate,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/typeClient"))..{
			Name="typeClientRank";
			OnCommand=cmd(zoom,1;x,312;y,16;visible,true;diffusealpha,1;animate,false;setstate,0);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};


		LoadActor(THEME:GetPathG("","SaniNet/eval/pfg"))..{
			Name="pfcTag";
			OnCommand=cmd(zoom,0.65;x,242;y,10;visible,false;diffusealpha,1);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};

		LoadActor(THEME:GetPathG("","SaniNet/eval/fullcombo"))..{
			Name="fcomboTag";
			OnCommand=cmd(zoom,0.65;x,242;y,15;visible,false;diffusealpha,1);			
			FinalizedMessageCommand=cmd(finishtweening;visible,false);			
		};





	};
end;




--:: process the screen :: --
local timesChecked = 0;
local maxTimeChecked = 5;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		local roomSize = GAMESTATE:Env()["saninet_roomsize_game"]; 
		if roomSize > 2 then
			Trace("Room with more than 2 Player!");
			playerBoxesMp["mpBox0"]:visible(true);
			playerBoxesMp["mpBox1"]:visible(true);
			playerBoxesMp["mpBox2"]:visible(true);			
			if roomSize == 3 then
				playerBoxesMp["mpBox3"]:visible(false);
			else
				playerBoxesMp["mpBox3"]:visible(true);
			end;

			self:queuecommand("updateDataPlayer");
		else
			playerBoxesMp["mpBox0"]:visible(false);
			playerBoxesMp["mpBox1"]:visible(false);
			playerBoxesMp["mpBox2"]:visible(false);
			playerBoxesMp["mpBox3"]:visible(false);
		end;
	end;

	updateDataPlayerCommand=function(self)
		timesChecked = timesChecked + 1;
		self:sleep(0.4);
		if timesChecked < maxTimeChecked  then
			self:queuecommand("updateDataPlayer");
		else
			table.sort(playerResultMp, function(a, b)			    
			    return a.score > b.score
			end)

			for i=1,#playerResultMp do
				updateBoxMpPlayerData(playerResultMp[i],(i-1));
			end;
		end;
	end;
};

--::  TIMER  :: --
-- we are online and in a room, we don't want to stay in this screen for longer than 60 seconds, even when we have no timer.

t[#t+1] = Def.ActorFrame{

			OnCommand=function(self)
				if GAMESTATE:Env()["saninet_roomsize_game"] == 0 or GAMESTATE:Env()["saninet_roomsize_game"] == 1 then
					self:visible(false);
				end;
			end;

			LoadActor( THEME:GetPathG("","saninet/HG") )..{
					InitCommand=function(self)
						self:zoom(0.6);
						self:xy(SCREEN_CENTER_X,SCREEN_TOP+20);						
					end;
			};

			LoadFont("MenuTimer numbers")..{
			OnCommand=cmd(zoom,0.6;shadowlength,1;shadowcolor,0,0,0,1;horizalign,center;y,SCREEN_TOP+2 ;x,SCREEN_CENTER_X;settext,timerScreen;queuecommand,"timer");
			timerCommand=function(self)

				if GAMESTATE:Env()["saninet_roomsize_game"] == 0 or GAMESTATE:Env()["saninet_roomsize_game"] == 1 then
					return;
				end;

				self:sleep(1);
				timerScreen = timerScreen - 1;
				if timerScreen < 10 then
					self:settext("0"..timerScreen);
				else
					self:settext(timerScreen);	
				end;
				
				if timerScreen == 0 then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				else
					self:queuecommand("timer");
				end;
			end;
			FinalizedMessageCommand=cmd(stoptweening;visible,false);	
			OffCommand=function(self)
				self:stoptweening();
				self:linear(0.15);
				self:diffusealpha(0);
			end;
		};
};

return t;
