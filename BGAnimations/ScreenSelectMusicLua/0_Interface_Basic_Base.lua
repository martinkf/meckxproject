-- JNC (Most of the things here in Fullmode were changed, so please, dont hate me)
local titlechannel;

local TrainTypeBall = "pump-single";

currentChan = nil;

function createHelper(player)

	local xpos=SCREEN_CENTER_X;

	if player == PLAYER_1 then
		xpos=SCREEN_CENTER_X-450;
	end;

	if player == PLAYER_2 then
		xpos=SCREEN_CENTER_X+450;
	end;

	return  Def.ActorFrame
	{
		OnCommand=cmd(x,xpos;y,SCREEN_CENTER_Y-80;zoom,0.8;visible,true;queuecommand,"startInfo");
		SelectChannelMessageCommand=function(self)
			self:visible(false);
		end;
		ChannelChosenMessageCommand=function(self)
			self:visible(true);
		end;

		startInfoCommand=function(self)
				self:GetChild("tback"):diffusealpha(0.2);
				self:GetChild("tselect"):diffusealpha(1);
				self:GetChild("tshift"):diffusealpha(1);

				self:GetChild("arred"):diffusealpha(0);
				self:GetChild("acenter"):diffusealpha(1);
				self:GetChild("ablue"):diffusealpha(1);				
		end;


		SongChosenMessageCommand=function(self,params)
				self:GetChild("tback"):diffusealpha(1);
				self:GetChild("tselect"):diffusealpha(1);
				self:GetChild("tshift"):diffusealpha(1);

				self:GetChild("arred"):diffusealpha(1);
				self:GetChild("acenter"):diffusealpha(1);
				self:GetChild("ablue"):diffusealpha(1);				
		end;

		SongUnchosenMessageCommand=function(self)
				self:GetChild("tback"):diffusealpha(0.2);
				self:GetChild("tselect"):diffusealpha(1);
				self:GetChild("tshift"):diffusealpha(1);

				self:GetChild("arred"):diffusealpha(0);
				self:GetChild("acenter"):diffusealpha(1);
				self:GetChild("ablue"):diffusealpha(1);
		end;

		StepsChosenMessageCommand=function(self,params)
			if params.Player == player then 
				self:GetChild("tback"):diffusealpha(0.2);
				self:GetChild("tselect"):diffusealpha(1);
				self:GetChild("tshift"):diffusealpha(0.2);

				self:GetChild("arred"):diffusealpha(0);
				self:GetChild("acenter"):diffusealpha(1);
				self:GetChild("ablue"):diffusealpha(0);	
			end;				
		end;	

		StepsUnchosenMessageCommand=function(self,params)
			if params.Player == player then
				local topScreen = SCREENMAN:GetTopScreen();
				--SelectingSong <- con esto para ocultar.
				self:GetChild("tback"):diffusealpha(1);
				self:GetChild("tselect"):diffusealpha(1);
				self:GetChild("tshift"):diffusealpha(1);

				self:GetChild("arred"):diffusealpha(1);
				self:GetChild("acenter"):diffusealpha(1);
				self:GetChild("ablue"):diffusealpha(1);				



				if topScreen:GetSelectionState() == "SelectingSong" then
						self:GetChild("tback"):diffusealpha(0.2);
						self:GetChild("tselect"):diffusealpha(1);
						self:GetChild("tshift"):diffusealpha(1);

						self:GetChild("arred"):diffusealpha(0);
						self:GetChild("acenter"):diffusealpha(1);
						self:GetChild("ablue"):diffusealpha(1);						
				end;
			end;			

		end;

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/baseHelper"))..{
			InitCommand=cmd(zoom,0.8);
		};	

		--back
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/arrgreyback"))..{
			InitCommand=cmd(zoom,0.8;diffusealpha,0.5);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(-50);					
				end;				
				if player == PLAYER_2 then
					self:addx(50);
				end;
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/tback"))..{
			Name="tback";
			InitCommand=cmd(zoom,0.8;diffusealpha,0.2);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(62);	
					self:addy(-30);
				end;				
				if player == PLAYER_2 then
					self:addx(-62);
					self:addy(-30);
				end;
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/tselect"))..{
			Name="tselect";
			InitCommand=cmd(zoom,0.8;diffusealpha,0.2);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(62);	
				end;				
				if player == PLAYER_2 then
					self:addx(-62);
				end;
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/tshift"))..{
			Name="tshift";
			InitCommand=cmd(zoom,0.8;diffusealpha,0.2);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(62);	
					self:addy(30);					
				end;				
				if player == PLAYER_2 then
					self:addx(-62);
					self:addy(30);					
				end;
			end;
		};	


		--arrows
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/redarrowhelper"))..{
			Name="arred";
			InitCommand=cmd(zoom,0.8;diffusealpha,0);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(-50);				
				end;				
				if player == PLAYER_2 then
					self:addx(50);
				end;
				self:addy(-30);
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/centerarrowhelper"))..{
			Name="acenter";
			InitCommand=cmd(zoom,0.8;diffusealpha,0);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(-50);
				end;				
				if player == PLAYER_2 then
					self:addx(50);
				end;
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/BASICMODE/bluearrowhelper"))..{
			Name="ablue";
			InitCommand=cmd(zoom,0.8;diffusealpha,0);
			OnCommand=function(self)
				if player == PLAYER_1 then
					self:addx(-50);					
				end;				
				if player == PLAYER_2 then
					self:addx(50);
				end;
				self:addy(30);
			end;
		};	


	};

end;

local function GetFixedChannelName(path)
	currentChan = path;
	if (arrChannelTitle[path] ~= nil) then
		return arrChannelTitle[path]
	else
		return path
	end
end;

function PaneDisplay(player)
	if not GAMESTATE:IsHumanPlayer(player) then return Def.ActorFrame{} end
		local lastSteps = nil
		local lastMeter = nil
		local lastStepType = ""
		local lastRadar = {}
	
	local paneCategories = {
        { Category = 'RadarCategory_TapsAndHolds', Text = "STP", Color = color("1,1,1,1") },
        { Category = 'RadarCategory_Holds',        Text = "HLD", Color = color("0.75,0.75,1,1") },
        { Category = 'RadarCategory_Mines',        Text = "MNS", Color = color("1,0.75,0.75,1") },
        { Category = 'RadarCategory_Jumps',        Text = "JMP", Color = color("1,1,0.75,1") },
        { Category = 'RadarCategory_Hands',        Text = "TPL", Color = color("0.75,1,1,1") },
        { Category = 'RadarCategory_Rolls',        Text = "RLL", Color = color("0.75,1,0.75,1") }
    }
    local barMetrics = {
        { Category = 'RadarCategory_Stream',  Text = "STREAM",  Color = color("0.3,1,0.3,1") },
        { Category = 'RadarCategory_Voltage', Text = "VOLTAGE", Color = color("1,0.3,0.3,1") },
        { Category = 'RadarCategory_Chaos',   Text = "CHAOS",   Color = color("0.3,0.3,1,1") }
    }
	
	local tChilds = {};

	for i, cat in ipairs(paneCategories) do
        table.insert(tChilds, Def.ActorFrame {
			Name=cat.Text,
            InitCommand = function(self) 
				local fx = (i <= 3) and -1 or 1
                local fy = ((i - 1) % 3) - 1
                self:xy(fx * 46, fy * 20)
			end,
            LoadFont("Tomorrow/Tomorrow 40px") .. {
                Text=cat.Text,
				InitCommand=cmd(zoom,0.36;diffuse,cat.Color;horizalign,left;skewx,-0.2;x,-40)
            },
            LoadFont("Tomorrow/Tomorrow 40px") .. {
                Name="Value",	Text="000",
				InitCommand=cmd(zoom,0.45;diffuse,cat.Color;horizalign,right;x,40)
            }
        })
    end
	return Def.ActorFrame {
	InitCommand = function(self)
		self:visible(GAMESTATE:IsHumanPlayer(player))
			self:SetUpdateFunction(function()
			if not GAMESTATE:IsHumanPlayer(player)
			or GAMESTATE:GetGameMode() == 'Basic'
			or GAMESTATE:GetMusicTrainChannel()
			or GAMESTATE:GetProgressiveChannel()
			or GAMESTATE:GetRandomTrainChannel()
			or GAMESTATE:GetSurvivalChannel()
		--	or GAMESTATE:GetMissionChannel()
			or GAMESTATE:GetQuestZoneChannel() then
				self:visible(false)
				return
			end

			self:visible(true)
			local screen = SCREENMAN:GetTopScreen()
			if not (screen and screen:GetName() == "ScreenSelectMusic") then return end

			local state = screen:GetSelectionState()
			if state ~= "SelectingSteps" and state ~= "ConfirmSteps" then return end

			local steps = GAMESTATE:GetCurrentSteps(player)
			if not steps or steps == lastSteps then return end

			lastSteps = steps
			local radar = steps:GetRadarValues(player)

			-- Actualiza los valores de las categorías numéricas
			for _, cat in ipairs(paneCategories) do
				local value = radar:GetValue(cat.Category)
				self:GetChild(cat.Text):GetChild("Value"):settextf("%03i", value)
			end
		end)
		
	end,
		children = tChilds;
	};
end;

local function checkTypeStepData(pndata)
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps(pndata);

	style = cur_steps:GetStepsType();

	if style=='StepsType_Pump_Single' --[[and string.find( description,"SP" )]] then 
		return 1;
	elseif style=='StepsType_Pump_Single' then 
		return 1;
	elseif style=='StepsType_Pump_Couple' then 
		return 2;
	elseif ( style=='StepsType_Pump_Double' --[[ and string.find( description,"DP" ) ]] ) or style=='StepsType_Pump_Routine'  then 
		return 2;
	elseif style=='StepsType_Pump_Double' or style=='StepsType_Pump_Halfdouble' then 
		return 2;
	end;

	return 0;
end;

collectgarbage();


local t = Def.ActorFrame{};

local StepsColor = {
	StepsType_Pump_Single 		= color("#ff001e"),
	StepsType_Pump_Double 		= color("#66e172"),
	StepsType_Pump_Single_P		= color("#fe2cae"),
	StepsType_Pump_Double_P	= color("#2553ff"),
--	StepsType_Pump_Double_Px		= color("#8f752e"),
	StepsType_Pump_Halfdouble	= color("#25fcff"),
};

if GAMESTATE:IsHumanPlayer(PLAYER_1) then

t[#t+1] = createHelper(PLAYER_1);

t[#t+1] = LoadActor("0_Interface_Basic_Level_Selected")..
{
	CreatePlayer(PLAYER_1);
	OnCommand=cmd(diffusealpha,0;xy,SCREEN_CENTER_X - 280 ,SCREEN_CENTER_Y+500;zoom,0.8;linear,0.25;y,SCREEN_CENTER_Y+210;diffusealpha,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"checkPlace");

	checkPlaceCommand=function(self)
		if GAMESTATE:GetNumPlayersEnabled() == 1 then
			self:x(SCREEN_CENTER_X);
			self:addy(-40);	
		else
			self:x(SCREEN_CENTER_X - 350);
		end;
	end;

	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == PLAYER_1 then self:visible(true) end		
		if bIsOnScreen then
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingSteps' then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					self:stoptweening():linear(0.25):Center():addy(220):zoom(1);
				elseif GAMESTATE:GetNumPlayersEnabled() == 2 then
					self:stoptweening():xy(SCREEN_CENTER_X-850,SCREEN_CENTER_Y+220):zoom(1):linear(0.25):x(SCREEN_CENTER_X-230);
				end;
			end;
		end;
		self:queuecommand("checkPlace");
	end;
	FinalizedMessageCommand=cmd(linear,0.25;addy,-10;linear,0.25;addy,200;diffusealpha,0);
};	

t[#t+1] = Def.ActorFrame{	--PLAYER1
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.6;);
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*-1.2;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-1.2;decelerate,0.18;x,SCREEN_CENTER_X*-.36;queuecommand,"changeColor");
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*-.36;accelerate,0.15;x,SCREEN_CENTER_X*-1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ReadyPlayer"))..{
			InitCommand=cmd(x,-95;y,90; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if PREFSMAN:GetPreference("MenuTimer") then
							self:y(-230);
						else
							self:y(-200);
						end;
						self:linear(0.08);
						self:x(235);
						self:diffusealpha(1);
					else
						self:linear(0.08);
						self:x(-120);					
						self:diffusealpha(1);
					end;
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);						
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);						
						self:diffusealpha(0);
					end;

				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_1 then

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;


				end;
			end;
			SongUnchosenMessageCommand=function(self,params)

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;


			end;			
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;


				end;
			end;						
		};		

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ReadyPlayer"))..{
			InitCommand=cmd(x,-95;y,90; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;blend,"BlendMode_Add";draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if PREFSMAN:GetPreference("MenuTimer") then
							self:y(-230);
						else
							self:y(-200);
						end;
						self:linear(0.08);
						self:x(235);
						self:diffusealpha(1);
						self:queuecommand("Animate");
					else
						self:linear(0.08);
						self:x(-120);					
						self:diffusealpha(1);
						self:queuecommand("Animate");
					end;

				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;
				end;
			end;	
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;
				end;
			end;	
			SongUnchosenMessageCommand=function(self,params)
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(205);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(-145);											
						self:diffusealpha(0);
					end;
			end;	

			AnimateCommand=function(self)
				self:diffusealpha(0);
				self:linear(0.02);
				self:diffusealpha(1);
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
};
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then

t[#t+1] = createHelper(PLAYER_2);

t[#t+1] = LoadActor("0_Interface_Basic_Level_Selected")..
{
	CreatePlayer(PLAYER_2);
	OnCommand=cmd(diffusealpha,0;xy,SCREEN_CENTER_X + 380,SCREEN_CENTER_Y+500;zoom,0.8;linear,0.25;y,SCREEN_CENTER_Y+210;diffusealpha,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"checkPlace");
	checkPlaceCommand=function(self)
		if GAMESTATE:GetNumPlayersEnabled() == 1 then
			self:x(SCREEN_CENTER_X);
			self:addy(-40);
		else
			self:x(SCREEN_CENTER_X + 350);
		end;
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == PLAYER_2 then self:visible(true) end
		if bIsOnScreen then
			if SCREENMAN:GetTopScreen():GetSelectionState() == 'SelectingSteps' then
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					self:stoptweening():linear(0.25):Center():addy(220):zoom(1);
				elseif GAMESTATE:GetNumPlayersEnabled() == 2 then
					self:stoptweening():xy(SCREEN_CENTER_X+850,SCREEN_CENTER_Y+220):zoom(1):linear(0.25):x(SCREEN_CENTER_X+230);
				end;
			end;
		end;
		self:queuecommand("checkPlace");
	end;
	FinalizedMessageCommand=cmd(linear,0.25;addy,-10;linear,0.25;addy,200;diffusealpha,0);
};	

t[#t+1] = Def.ActorFrame{	--PLAYER2
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*1.6;);
	Def.ActorFrame{
		OnCommand=cmd(x,SCREEN_CENTER_X*1.2;);
		SongChosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*1.2;decelerate,0.18;x,SCREEN_CENTER_X*.36;queuecommand,"changeColor");
		SongUnchosenMessageCommand=cmd(stoptweening;x,SCREEN_CENTER_X*.36;accelerate,0.15;x,SCREEN_CENTER_X*1.2;);
		FinalizedMessageCommand=cmd(finishtweening;playcommand,"SongUnchosen");

	
		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ReadyPlayer"))..{
			InitCommand=cmd(x,95;y,90; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						if PREFSMAN:GetPreference("MenuTimer") then
							self:y(-230);
						else
							self:y(-200);
						end;
						
						self:linear(0.08);
						self:x(-220);
						self:diffusealpha(1);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(120);
						self:diffusealpha(1);
					end;
				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;

				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
				end;
			end;		
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
				end;
			end;

			SongUnchosenMessageCommand=function(self,params)
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
			end;
		};	

		LoadActor(THEME:GetPathG("","ScreenSelectMusic/ReadyPlayer"))..{
			InitCommand=cmd(x,95;y,90; zoomy,0.55;zoomx,0.9*0.9;diffusealpha,0;blend,"BlendMode_Add";draworder,1000);
			StepsChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						if PREFSMAN:GetPreference("MenuTimer") then
							self:y(-230);
						else
							self:y(-200);
						end;
						self:linear(0.08);
						self:x(-220);
						self:diffusealpha(1);
						self:queuecommand("Animate");
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(120);
						self:diffusealpha(1);
						self:queuecommand("Animate");
					end;

				end;
			end;	
			StepsUnchosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
				end;
			end;	
			ChangeCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
				end;
			end;		
			SongChosenMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
				end;
			end;
			SongUnchosenMessageCommand=function(self,params)

					if GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:stoptweening();
						self:linear(0.08);
						self:x(-195);											
						self:diffusealpha(0);
					else
						self:stoptweening();
						self:linear(0.08);
						self:x(145);					
						self:diffusealpha(0);
					end;
			end;


			AnimateCommand=function(self)
				self:diffusealpha(0);
				self:linear(0.02);
				self:diffusealpha(1);
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


};
end;


--	LoadActor("parts");



t[#t+1] = GetPlatSm() .. {
		OnCommand=cmd(Center;addy,220;zoom,.9;visible,false);
		StepsChosenMessageCommand=function(self, params)
			if params.Booth then
				self:visible(true);
			end;
		end;
		StepsUnchosenMessageCommand=cmd(visible,false);
		FinalizedMessageCommand=cmd(finishtweening;visible,false);
	};


return t;