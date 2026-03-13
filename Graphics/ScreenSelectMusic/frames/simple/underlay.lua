local t = Def.ActorFrame { };


function createTriangleBack1(xInput,yInput,colorTr,blendItems,applyAnimation)

	return Def.ActorFrame{
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta1";
			InitCommand=cmd(diffusealpha,0.15;zoom,0.5;x,SCREEN_CENTER_X-150+xInput;y,SCREEN_CENTER_Y+40+yInput;diffusealpha,0.2;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(2.5):addy(8):linear(3):addy(-8):linear(2.5):addy(8):linear(3.2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta2";
			InitCommand=cmd(diffusealpha,0.25;zoom,0.35;x,SCREEN_CENTER_X-90+xInput;y,SCREEN_CENTER_Y-80+yInput;diffusealpha,0.2;diffusecolor,color(colorTr);rotationx,180;queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(1.5):addy(-8):linear(2):addy(8):linear(2.5):addy(-8):linear(1.2):addy(8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta3";
			InitCommand=cmd(diffusealpha,0.15;zoom,0.35;x,SCREEN_CENTER_X+20+xInput;y,SCREEN_CENTER_Y-80+yInput;diffusealpha,0.2;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(2.4):addy(-8):linear(1.3):addy(8):linear(2.4):addy(-8):linear(1):addy(8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta4";
			InitCommand=cmd(diffusealpha,0.25;zoom,0.3;x,SCREEN_CENTER_X+25+xInput;y,SCREEN_CENTER_Y+140+yInput;diffusealpha,0.2;diffusecolor,color(colorTr);rotationx,180;queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(3):addy(8):linear(2):addy(-8):linear(3):addy(8):linear(2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta5";
			InitCommand=cmd(diffusealpha,0.25;zoom,0.2;x,SCREEN_CENTER_X+105+xInput;y,SCREEN_CENTER_Y+65+yInput;diffusealpha,0.2;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(3):addy(8):linear(2):addy(-8):linear(3):addy(8):linear(2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta6";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.3;x,SCREEN_CENTER_X+90+xInput;y,SCREEN_CENTER_Y-20+yInput;diffusealpha,0.3;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(1.5):addy(-8):linear(2.5):addy(8):linear(1.5):addy(-8):linear(2.5):addy(8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};					

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="ta7";
			InitCommand=cmd(diffusealpha,0.25;zoom,0.15;x,SCREEN_CENTER_X+75+xInput;y,SCREEN_CENTER_Y-95+yInput;diffusealpha,0.15;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(2.2):addy(-8):linear(3):addy(8):linear(2.4):addy(-8):linear(3):addy(8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;				
		};	

		OnCommand=function(self)
			if blendItems then
				self:GetChild("ta1"):blend("BlendMode_Add");
				self:GetChild("ta2"):blend("BlendMode_Add");
				self:GetChild("ta3"):blend("BlendMode_Add");
				self:GetChild("ta4"):blend("BlendMode_Add");
				self:GetChild("ta5"):blend("BlendMode_Add");
				self:GetChild("ta6"):blend("BlendMode_Add");
				self:GetChild("ta7"):blend("BlendMode_Add");
			end;


			if applyAnimation then
				self:GetChild("ta1"):diffusealpha(0);
				self:GetChild("ta2"):diffusealpha(0);
				self:GetChild("ta3"):diffusealpha(0);
				self:GetChild("ta4"):diffusealpha(0);
				self:GetChild("ta5"):diffusealpha(0);
				self:GetChild("ta6"):diffusealpha(0);
				self:GetChild("ta7"):diffusealpha(0);
			end;
		end;

		ChangeChannelMessageCommand=function(self)
			local appearSpeed=0.08;
			local dissapearSpeed=0.15;
			local maxDiffuse=0.6;
			if applyAnimation then
				self:GetChild("ta1"):stoptweening():sleep(0.09):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta2"):stoptweening():sleep(0.11):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta3"):stoptweening():sleep(0.07):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta4"):stoptweening():sleep(0.12):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta5"):stoptweening():sleep(0.14):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta6"):stoptweening():sleep(0.06):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("ta7"):stoptweening():sleep(0.09):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
			end;
		end;
		FinalizedMessageCommand=function(self)
				self:GetChild("ta1"):stoptweening():diffusealpha(0);
				self:GetChild("ta2"):stoptweening():diffusealpha(0);
				self:GetChild("ta3"):stoptweening():diffusealpha(0);
				self:GetChild("ta4"):stoptweening():diffusealpha(0);
				self:GetChild("ta5"):stoptweening():diffusealpha(0);
				self:GetChild("ta6"):stoptweening():diffusealpha(0);
				self:GetChild("ta7"):stoptweening():diffusealpha(0);
		end;

	};

end;

function createTriangleBack2(xInput,yInput,colorTr,blendItems,applyAnimation)

	return Def.ActorFrame{
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb1";
			InitCommand=cmd(diffusealpha,0.8;zoom,0.3;x,SCREEN_CENTER_X-125+xInput;y,SCREEN_CENTER_Y+60+yInput;diffusealpha,0.8;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(4.2):addy(-8):linear(3):addy(8):linear(4):addy(8):linear(3.2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb2";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.3;x,SCREEN_CENTER_X+25+xInput;y,SCREEN_CENTER_Y+10+yInput;diffusealpha,0.8;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(3):addy(-8):linear(2):addy(8):linear(3.9):addy(8):linear(2.8):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};		

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb3";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.1;x,SCREEN_CENTER_X-50+xInput;y,SCREEN_CENTER_Y-70+yInput;diffusealpha,0.8;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(4):addy(-8):linear(3):addy(8):linear(2):addy(8):linear(4):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};		
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb4";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.1;x,SCREEN_CENTER_X-60+xInput;y,SCREEN_CENTER_Y+40+yInput;diffusealpha,0.8;rotationx,180;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(3.2):addy(-8):linear(2):addy(8):linear(4):addy(8):linear(2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};	

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb5";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.08;x,SCREEN_CENTER_X+125+xInput;y,SCREEN_CENTER_Y+50+yInput;diffusealpha,0.5;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(4.5):addy(-8):linear(2.8):addy(8):linear(4):addy(8):linear(3.5):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb6";
			InitCommand=cmd(diffusealpha,0.9;zoom,0.1;x,SCREEN_CENTER_X+110+xInput;y,SCREEN_CENTER_Y-120+yInput;diffusealpha,0.8;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(6):addy(-8):linear(3):addy(8):linear(4):addy(8):linear(2):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};

		LoadActor( THEME:GetPathG("","ScreenSelectMusic/artifacts/chtriangleback") )..{
			Name="tb7";
			InitCommand=cmd(diffusealpha,0.15;zoom,0.25;x,SCREEN_CENTER_X-5+xInput;y,SCREEN_CENTER_Y-160+yInput;diffusealpha,0.3;diffusecolor,color(colorTr);queuecommand,"Ani");
			AniCommand=function(self)
				self:stoptweening():linear(3):addy(-8):linear(5):addy(8):linear(6):addy(8):linear(6):addy(-8);
				self:sleep(0.1);
				self:queuecommand("Ani");
			end;			
		};			

		OnCommand=function(self)
			if blendItems then
				self:GetChild("tb1"):blend("BlendMode_Add");
				self:GetChild("tb2"):blend("BlendMode_Add");
				self:GetChild("tb3"):blend("BlendMode_Add");
				self:GetChild("tb4"):blend("BlendMode_Add");
				self:GetChild("tb5"):blend("BlendMode_Add");
				self:GetChild("tb6"):blend("BlendMode_Add");
				self:GetChild("tb7"):blend("BlendMode_Add");

				if applyAnimation then
					self:GetChild("tb1"):diffusealpha(0);
					self:GetChild("tb2"):diffusealpha(0);
					self:GetChild("tb3"):diffusealpha(0);
					self:GetChild("tb4"):diffusealpha(0);
					self:GetChild("tb5"):diffusealpha(0);
					self:GetChild("tb6"):diffusealpha(0);
					self:GetChild("tb7"):diffusealpha(0);
				end;
			end;
		end;

		ChangeChannelMessageCommand=function(self)
			local appearSpeed=0.08;
			local dissapearSpeed=0.2;
			local maxDiffuse=0.6;
			if applyAnimation then
				self:GetChild("tb1"):stoptweening():sleep(0.03):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb2"):stoptweening():sleep(0.05):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb3"):stoptweening():sleep(0.02):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb4"):stoptweening():sleep(0.05):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb5"):stoptweening():sleep(0.01):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb6"):stoptweening():sleep(0.08):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
				self:GetChild("tb7"):stoptweening():sleep(0.04):linear(appearSpeed):diffusealpha(maxDiffuse):linear(dissapearSpeed):diffusealpha(0);
			end;
		end;

		FinalizedMessageCommand=function(self)
				self:GetChild("tb1"):stoptweening():diffusealpha(0);
				self:GetChild("tb2"):stoptweening():diffusealpha(0);
				self:GetChild("tb3"):stoptweening():diffusealpha(0);
				self:GetChild("tb4"):stoptweening():diffusealpha(0);
				self:GetChild("tb5"):stoptweening():diffusealpha(0);
				self:GetChild("tb6"):stoptweening():diffusealpha(0);
				self:GetChild("tb7"):stoptweening():diffusealpha(0);
		end;

	};

end;


t[#t+1] = createTriangleBack1(25,-35,"#00deff",true,false)..{
	OnCommand=function(self)
		self:visible(false);
		self:diffusealpha(0.8);
		self:linear(6);
		self:addy(3);
		self:linear(0);		
		self:queuecommand("Ani");
	end;
	AniCommand=function(self)
		self:linear(6);
		self:addy(-6);	
		self:linear(6);
		self:addy(6);
		self:queuecommand("Ani");
	end;

	SelectChannelMessageCommand=cmd(visible,true);
	ChannelChosenMessageCommand=cmd(stoptweening;visible,false);
	FinalizedMessageCommand=cmd(stoptweening;visible,false);

};


t[#t+1] = createTriangleBack2(25,-35,"#ff005a",true,false)..{
	OnCommand=function(self)
		self:visible(false);
		self:diffusealpha(0.8);
		self:sleep(0.2);
		self:linear(8);
		self:addy(3);
		self:linear(0);		
		self:queuecommand("Ani");
	end;
	AniCommand=function(self)
		self:linear(8);
		self:addy(-6);	
		self:linear(8);
		self:addy(6);
		self:queuecommand("Ani");
	end;
	SelectChannelMessageCommand=cmd(stoptweening;visible,true);
	ChannelChosenMessageCommand=cmd(stoptweening;visible,false);
	FinalizedMessageCommand=cmd(stoptweening;visible,false);
};

t[#t+1] = createTriangleBack2(25,-35,"#ffd200",true,true)..{
	OnCommand=function(self)
		self:visible(false);
		self:sleep(0.2);
		self:linear(8);
		self:addy(3);
		self:linear(0);		
		self:queuecommand("Ani");
	end;
	AniCommand=function(self)
		self:linear(8);
		self:addy(-6);	
		self:linear(8);
		self:addy(6);
		self:queuecommand("Ani");
	end;
	SelectChannelMessageCommand=cmd(stoptweening;visible,true);
	ChannelChosenMessageCommand=cmd(stoptweening;visible,false);	
	FinalizedMessageCommand=cmd(stoptweening;visible,false);
};

t[#t+1] = createTriangleBack1(25,-35,"#ff005a",true,true)..{
	OnCommand=function(self)
		self:visible(false);
		self:linear(6);
		self:addy(3);
		self:linear(0);		
		self:queuecommand("Ani");
	end;
	AniCommand=function(self)
		self:linear(6);
		self:addy(-6);	
		self:linear(6);
		self:addy(6);
		self:queuecommand("Ani");
	end;
	SelectChannelMessageCommand=cmd(stoptweening;visible,true);
	ChannelChosenMessageCommand=cmd(stoptweening;visible,false);	
	FinalizedMessageCommand=cmd(stoptweening;visible,false);
};


local numParticles = 70  -- Cambia este valor para más o menos partículas

local performanceStatus = checkPerformanceModeState();
if performanceStatus then
	numParticles = 20;
end;

local screenW = SCREEN_WIDTH
local screenH = SCREEN_HEIGHT
local minSpeed = 5
local maxSpeed = 30

local minSpeedF = 20
local maxSpeedF = 60

local iTmp=1;



-- Función que crea una sola partícula
local function makeParticle(index)
	local firstTimeParticle = true;
    return LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/simple/deco"))..{
        Name = "particle" .. index,
        InitCommand = function(self)
        	self:animate(false);
        	self:setstate(0);
            self:zoomto(16, 16)                         -- Tamaño del cuadrado
            self:diffuse(1, 1, 1, 0.7)                -- Color blanco semitransparente
            self:visible(false);
            self:queuecommand("Reset")
            
        end;

        ResetCommand = function(self)
        		-- random de color
        		local rcolorcomplete=false;
        		
        		local centerArrow = math.random() <= 0.01;
        		if centerArrow then
        			self:setstate(1);
        		else
        			self:setstate(0);
        		end;

        		--random size
        		local miniArrow = math.random() <= 0.1;
        		if miniArrow then        			
        			local microArrow = math.random() <= 0.5;
        			if microArrow then
        				self:zoomto(8, 8);
        			else
        				self:zoomto(12, 12);
        			end;
        		else
        			 self:zoomto(16, 16);
        		end;

        		if centerArrow then
	        		self:blend("BlendMode_Add");
					self:diffuseblink()
					self:effectcolor1(color("#fcff00")) 
					self:effectcolor2(color("#ffcc00"))  
					self:effectperiod(2)
					self:effecttiming(1, 0.1, 1, 0.1)
        		else
	        		local redc = math.random() <= 0.03;
	        		if redc and rcolorcomplete == false then
	        		self:blend("BlendMode_Add");
					self:diffuseblink()
					self:effectcolor1(color("#ff3600")) 
					self:effectcolor2(color("#ff7800"))  
					self:effectperiod(2)
					self:effecttiming(1, 0.1, 1, 0.1)
	        			rcolorcomplete=true;
	        		end;

	        		local bluec = math.random() <= 0.03;
	        		if bluec and rcolorcomplete == false then
							self:diffuseblink()
							self:effectcolor1(color("#00c0ff"))  
							self:effectcolor2(color("#00fffc"))  
							self:effectperiod(2)
							self:effecttiming(1, 0.1, 1, 0.1)
	        			rcolorcomplete=true;
	        		end;
        		end;


        		local arcoiris = math.random() <= 0.01;
        		if arcoiris and rcolorcomplete == false then
						self:rainbow();
        			rcolorcomplete=true;
        		end;

                -- Parte desde abajo hacia arriba
                local startX = math.random(-350, screenW);
                local endingX = startX+420;

                local startY = screenH + 10

                local speed = 0;

                if iTmp == 1 then
                	speed = math.random(minSpeed, maxSpeed)
                else
                	speed = math.random(minSpeedF, maxSpeedF)
                end;

			    iTmp = iTmp + 1;
			    if iTmp > 2 then
			    	iTmp = 1;
			    end;                

                local travelTime = (screenH + 20) / speed


        		if firstTimeParticle then
        			firstTimeParticle = false;
					-- Simular que ya ha avanzado algo
					local simulatedTime = math.random() * travelTime -- tiempo aleatorio entre 0 y travelTime
					local progress = simulatedTime / travelTime

					local currentX = startX + (endingX - startX) * progress
					local currentY = startY + (-10 - startY) * progress
					local remainingTime = travelTime - simulatedTime

					self:xy(currentX, currentY)
					self:stoptweening()
					self:linear(remainingTime):xy(endingX, -10):queuecommand("Reset")
        		else
	                self:xy(startX, startY)
	                self:stoptweening()
	                self:linear(travelTime):xy(endingX,-10):queuecommand("Reset")
        		end;



        end;

		SelectChannelMessageCommand=function(self)
			self:visible(true);

		end;

		ChannelChosenMessageCommand=function(self)
			self:visible(false);
		end;
		FinalizedMessageCommand = function(self)	
			self:stoptweening():visible(false);
		end;        
    }
end

-- Crear todas las partículas y agregarlas al ActorFrame
for i = 1, numParticles do
    t[#t + 1] = makeParticle(i);
end

return t;