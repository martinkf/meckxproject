local t = Def.ActorFrame {};

-- Ejemplo de uso
--## BASE ALL
function shuffled_copy(tbl)
    -- Copiar el array original
    local copy = {}
    for i = 1, #tbl do
        copy[i] = tbl[i]
    end

    -- Aplicar Fisher–Yates sobre la copia
    for i = #copy, 2, -1 do
        local j = math.random(i)
        copy[i], copy[j] = copy[j], copy[i]
    end

    return copy
end

-- Función que crea una sola partícula
local numParticles = 30  -- Cambia este valor para más o menos partículas
local screenW = SCREEN_WIDTH
local screenH = SCREEN_HEIGHT
local minSpeed = 5
local maxSpeed = 30

local minSpeedF = 20
local maxSpeedF = 60

local iTmp=1;
local function makeParticle(index)
	local firstTimeParticle = true;
    return LoadActor(THEME:GetPathG("","ScreenSelectMusic/frames/simple/deco"))..{
        Name = "particle" .. index,
        InitCommand = function(self)
        	self:animate(false);
        	self:setstate(0);
            self:zoomto(16, 16)                         -- Tamaño del cuadrado
            self:diffuse(1, 1, 1, 0.15)                -- Color blanco semitransparente
            self:visible(true);
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

		FinalizedMessageCommand = function(self)	
			self:stoptweening():visible(false);
		end;        
    }
end

-- Crear todas las partículas y agregarlas al ActorFrame

for i = 1, numParticles do
    t[#t + 1] = makeParticle(i);
end


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/back2.png") )..{
	InitCommand=cmd(y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;zoom,1;diffusealpha,1);
	OnCommand=function(self)

	end;
}

local function getSectorMapsAni(xFromCenter,YfromCenter,initSleepMs,zoomBase)
	local initSleep=0.5;
	local timeOnScreen=4;
	local extraDelayExecution = 3;
	return Def.ActorFrame {

		OnCommand=function(self)
			self:x(SCREEN_CENTER_X+xFromCenter);
			self:y(SCREEN_CENTER_Y+YfromCenter);
			self:sleep(timeOnScreen+extraDelayExecution);
			self:queuecommand("Animate");
		end;

		AnimateCommand=function(self)
			local xPosTrRan = math.random(-500,500);
			local yPosTrRan = math.random(-500,500);
			self:x(SCREEN_CENTER_X+xPosTrRan);
			self:y(SCREEN_CENTER_Y+yPosTrRan);
			self:GetChild("txts"):queuecommand("On");
			self:GetChild("trsector"):queuecommand("On");
			self:sleep(timeOnScreen+extraDelayExecution);
			self:queuecommand("Animate");
		end;

		FinalizedMessageCommand = function(self)	
			self:stoptweening():diffusealpha(0);
		end;        

		LoadActor( THEME:GetPathG("","LOGO/nlogo2/txt_sector.png") ).. {
			Name="txts";
			InitCommand=cmd(zoom,0.6+zoomBase;diffusealpha,0;addx,-35);
			OnCommand=function(self)
				self:sleep(initSleep);
				self:diffusealpha(1);
				self:sleep(timeOnScreen);
				self:linear(0);
				self:diffusealpha(0);				
			end;
		};


		LoadActor( THEME:GetPathG("","LOGO/nlogo2/saddress.png") ).. {
			Name="trsector";
			InitCommand=cmd(zoom,0.4+zoomBase;diffusealpha,0);
			OnCommand=function(self)
				self:rotationz(45);
				self:sleep(initSleep);
				self:sleep(0.12);
				self:diffusealpha(1);
				self:decelerate(0.3);
				self:rotationz(0);
				self:sleep(timeOnScreen);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0.05);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0.05);
				self:diffusealpha(0);
				self:linear(0.05);
				self:diffusealpha(1);
				self:linear(0);
				self:diffusealpha(0);
			end;	
			FinalizedMessageCommand = function(self)	
				self:stoptweening():diffusealpha(0);
			end;      
		};
	};
end;

local ranTrMin = 30;
local ranTrMax = 90; 

for i=1,15 do
	local xPosTrRan = math.random(-500,500);
	local yPosTrRan = math.random(-500,500);
	local zoomBaseTrRan = math.random(15,25)/100;
	t[#t+1] = getSectorMapsAni(xPosTrRan,yPosTrRan,(math.random(ranTrMin,ranTrMax)/100),zoomBaseTrRan);
end;


--##


--lineas azul primera animación
t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-85;zoomx,0;diffuse,color("#00f0ff"));
	OnCommand=function(self)
		self:sleep(0);
		self:scaletoclipped(250,2);
		self:zoomx(0);
		self:sleep(0.12);
		self:linear(0.16);
		self:zoomx(1);
		self:sleep(0.1);
		self:queuecommand("aniA");					
	end;
	aniACommand=function(self)
		self:linear(0.2)
		self:y(SCREEN_CENTER_Y-45);
		self:sleep(0.2);
		self:visible(false);		
	end;     
};
--lineas azul primera animación
t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+82;zoomx,0;diffuse,color("#00f0ff"));
	OnCommand=function(self)
		self:sleep(0);
		self:scaletoclipped(250,2);
		self:zoomx(0);
		self:sleep(0.12);
		self:linear(0.16);
		self:zoomx(1);	
		self:sleep(0.05);
		self:queuecommand("aniA");	
	end;

	aniACommand=function(self)
		self:linear(0.2)
		self:y(SCREEN_CENTER_Y+45);
		self:sleep(0.2);
		self:visible(false);
	end;  	
};


t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-400;diffuse,color("#06fff5"));--f0ff00
	OnCommand=function(self)
		self:sleep(0);
		self:scaletoclipped(70,300);
		self:linear(0.15);
		self:y(SCREEN_CENTER_Y-250);
		self:sleep(0.25);
		self:queuecommand("aniA");		
	end;

	aniACommand=function(self)
		self:sleep(0.05);
		self:decelerate(0.4);
		self:zoomx(0);	
	end;  
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+400;diffuse,color("#06fff5"));
	OnCommand=function(self)
		self:sleep(0);
		self:scaletoclipped(70,300);
		self:linear(0.15);
		self:y(SCREEN_CENTER_Y+250);
		self:sleep(0.25);
		self:queuecommand("aniA");		
	end;

	aniACommand=function(self)
		self:sleep(0.05);
		self:decelerate(0.4);
		self:zoomx(0);
	end;  
};


--############# LOGO ##################
local sleepLogo=0.7;
t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/cbase_3.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-33;x,SCREEN_CENTER_X+3;diffusealpha,1;zoom,0.48;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(sleepLogo+0.06);
		self:linear(0.1);
		self:cropright(0);	
	end;  
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/cbase_1.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-31;x,SCREEN_CENTER_X+2;diffusealpha,1;zoom,0.48;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(sleepLogo+0.06);
		self:linear(0.1);
		self:cropright(0);	
	end;  
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/logofullbase.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.6;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(sleepLogo+0.04);
		self:linear(0.1);
		self:cropright(0);	
	end;   
}


t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/xsanity.png") )..{
	InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.6;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(sleepLogo-0.02);
		self:linear(0.1);
		self:cropright(0);
	end;
}

t[#t+1] = LoadActor( THEME:GetPathG("","LOGO/nlogo2/sanita.png") )..{
	InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y+15;x,SCREEN_CENTER_X+340;diffusealpha,0.5;zoom,0.5;queuecommand,"Animate");
	AnimateCommand=function(self)
		self:cropright(1);
		self:sleep(sleepLogo+0.2);
		self:linear(0.1);
		self:cropright(0);	
		self:linear(0.4);
		self:diffusealpha(0.95);
	end;
	FinalizedMessageCommand = function(self)	
		self:stoptweening():linear(0.2):diffusealpha(0);
	end;    
}


--bajada
local timingArrowEntrance = 1;
local sleepBajada = 1.1;
t[#t+1] = Def.ActorFrame {
	LoadActor( THEME:GetPathG("","LOGO/nlogo2/arrow_bajada.png") )..{
		InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y+120;x,SCREEN_CENTER_X-20;diffusealpha,1;zoom,0.6;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:cropright(1);
			self:sleep(timingArrowEntrance);
			self:cropright(0);

			self:sleep(sleepBajada-timingArrowEntrance);
			self:decelerate(0.1);
			self:x(SCREEN_CENTER_X-270);			
		end;
		FinalizedMessageCommand = function(self)	
			self:stoptweening():linear(0.2):diffusealpha(0);
		end;    
	};

	LoadActor( THEME:GetPathG("","LOGO/nlogo2/arrow_bajada.png") )..{
		InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y+120;x,SCREEN_CENTER_X+20;diffusealpha,1;zoom,0.6;rotationz,180;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:cropright(1);
			self:sleep(timingArrowEntrance);
			self:cropright(0);

			self:sleep(sleepBajada-timingArrowEntrance);
			self:decelerate(0.1);
			self:x(SCREEN_CENTER_X+270);
		end;
		FinalizedMessageCommand = function(self)	
			self:stoptweening():linear(0.2):diffusealpha(0);
		end;    
	};	

	LoadActor( THEME:GetPathG("","LOGO/nlogo2/texto_bajada.png") )..{
		InitCommand=cmd(diffusealpha,0;y,SCREEN_CENTER_Y+120;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.6;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:cropleft(0.5);
			self:cropright(0.5);
			self:diffusealpha(0);
			self:sleep(sleepBajada);
			self:diffusealpha(1);
			self:linear(0.2);
			self:cropleft(0);
			self:cropright(0);
		end;
		FinalizedMessageCommand = function(self)	
			self:stoptweening():linear(0.2):diffusealpha(0);
		end;    
	};	

	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X+221;y,SCREEN_CENTER_Y+132;diffuse,color("#ffffff");diffusealpha,1;zoomto,21,3;diffusealpha,0);
		OnCommand=function(self)
			self:sleep(sleepBajada+0.3);
			self:diffusealpha(1);
			self:queuecommand("Animate");
		end;

		AnimateCommand=function(self)
			self:diffusealpha(0);
			self:linear(0.05);
			self:diffusealpha(1);
			self:linear(0.05);
			self:diffusealpha(0);
			self:linear(0.05);
			self:diffusealpha(1);
			self:linear(0.05);
			self:diffusealpha(0);
			self:linear(0.05);
			self:diffusealpha(1);
			self:queuecommand("Animate");
		end;
		FinalizedMessageCommand = function(self)	
			self:stoptweening():diffusealpha(0);
		end;    
	};


};


--############# INTRO X ##################
local repeatTriangleInitAni=0;
local zoomArrowAdornos=0.48;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		self:sleep(0.55);
		self:decelerate(0.18);
		self:addx(-380);
	end;
	LoadActor( THEME:GetPathG("","LOGO/nlogo2/base1.png") )..{
		InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.5;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:cropright(1);
			self:sleep(0.1);
			self:linear(0.1);
			self:cropright(0);
			self:linear(0.1);
		end;
	};


	LoadActor( THEME:GetPathG("","LOGO/nlogo2/xbase.png") )..{
		InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y;x,SCREEN_CENTER_X;diffusealpha,1;zoom,0.5;queuecommand,"Animate");
		AnimateCommand=function(self)
			self:cropleft(1);
			self:diffusealpha(1);
			self:sleep(0.48);
			self:linear(0.1);
			self:cropleft(0);
			self:linear(0.1);
		end;
	};

	--adornos de triangulitos.
	Def.ActorFrame {

		OnCommand=function(self)
			self:queuecommand("Animate");
		end;

		AnimateCommand=function(self)
			for i = 0, 5 do
			self:diffusealpha(0);
			self:linear(0.025);
			self:diffusealpha(1);
			self:linear(0.025);
			self:diffusealpha(0);
			self:linear(0.025);
			self:diffusealpha(1);
			self:linear(0.025);
			self:diffusealpha(0);
			self:linear(0.025);
			self:diffusealpha(1);
			end;

			self:sleep(2);
			self:queuecommand("AniTriangle");
		end;

		AniTriangleCommand=function(self)

			local listTriangle = {"upBaseArrowDeco","upXArrowDeco","botBaseArrowDeco","botXArrowDeco","lXArrowDeco","rXArrowDeco"}

			local listTriangleRandoms = {};
			listTriangleRandoms = shuffled_copy(listTriangle);

			local ran = math.random(5,10);
			local ranMultiple = math.random(1,100);
			self:sleep(ran);

			for i = 0, 5 do
				self:GetChild(listTriangleRandoms[1]):diffusealpha(0);
				self:GetChild(listTriangleRandoms[1]):linear(0.025);
				self:GetChild(listTriangleRandoms[1]):diffusealpha(1);
				self:GetChild(listTriangleRandoms[1]):linear(0.025);
				self:GetChild(listTriangleRandoms[1]):diffusealpha(0);
				self:GetChild(listTriangleRandoms[1]):linear(0.025);
				self:GetChild(listTriangleRandoms[1]):diffusealpha(1);
				self:GetChild(listTriangleRandoms[1]):linear(0.025);
				self:GetChild(listTriangleRandoms[1]):diffusealpha(0);
				self:GetChild(listTriangleRandoms[1]):linear(0.025);
				self:GetChild(listTriangleRandoms[1]):diffusealpha(1);

				if ranMultiple < 30 then

					self:GetChild(listTriangleRandoms[2]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[2]):linear(0.025);
					self:GetChild(listTriangleRandoms[2]):diffusealpha(1);
					self:GetChild(listTriangleRandoms[2]):linear(0.025);
					self:GetChild(listTriangleRandoms[2]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[2]):linear(0.025);
					self:GetChild(listTriangleRandoms[2]):diffusealpha(1);
					self:GetChild(listTriangleRandoms[2]):linear(0.025);
					self:GetChild(listTriangleRandoms[2]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[2]):linear(0.025);
					self:GetChild(listTriangleRandoms[2]):diffusealpha(1);

				end;

				if ranMultiple < 15 then

					self:GetChild(listTriangleRandoms[3]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[3]):linear(0.025);
					self:GetChild(listTriangleRandoms[3]):diffusealpha(1);
					self:GetChild(listTriangleRandoms[3]):linear(0.025);
					self:GetChild(listTriangleRandoms[3]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[3]):linear(0.025);
					self:GetChild(listTriangleRandoms[3]):diffusealpha(1);
					self:GetChild(listTriangleRandoms[3]):linear(0.025);
					self:GetChild(listTriangleRandoms[3]):diffusealpha(0);
					self:GetChild(listTriangleRandoms[3]):linear(0.025);
					self:GetChild(listTriangleRandoms[3]):diffusealpha(1);

				end;				

			end;

			self:sleep(3);
			self:queuecommand("AniTriangle");
		end;

		FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);

		--  v
		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="upBaseArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-73;x,SCREEN_CENTER_X;diffusealpha,1;zoom,zoomArrowAdornos;queuecommand,"Animate");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};

		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="upXArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-32;x,SCREEN_CENTER_X;diffusealpha,1;zoom,zoomArrowAdornos;queuecommand,"Animate");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};

		-- ^
		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="botBaseArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y+73;x,SCREEN_CENTER_X;diffusealpha,1;zoom,zoomArrowAdornos;rotationz,180;queuecommand,"Animate");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};		
		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="botXArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y+26;x,SCREEN_CENTER_X;diffusealpha,1;zoom,zoomArrowAdornos;rotationz,180;queuecommand,"Animate");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};		

		-- <
		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="lXArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-3;x,SCREEN_CENTER_X+42;diffusealpha,1;zoom,zoomArrowAdornos;rotationz,90;queuecommand,"Animate");
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);

		};			

		-- >
		LoadActor( THEME:GetPathG("","LOGO/nlogo2/tr_full_deco.png") )..{
			Name="rXArrowDeco";
			InitCommand=cmd(diffusealpha,1;y,SCREEN_CENTER_Y-3;x,SCREEN_CENTER_X-42;diffusealpha,1;zoom,zoomArrowAdornos;rotationz,-90;queuecommand,"Animate");
			AnimateCommand=function(self)

			end;
			FinalizedMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);
		};	

	};

};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("#ffffff");diffusealpha,0);
	OnCommand=function(self)
		self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
		self:sleep(1.2);
		self:linear(0.05);
		self:diffusealpha(0.5);
		self:linear(0.2);
		self:diffusealpha(0);
	end;
};

t[#t+1] = LoadActor(THEME:GetPathG("","LOGO/nlogo2/intro Ver_A.mp3"))..{
	InitCommand=cmd();
	OnCommand=function(self)
		self:play();
	end;
	

};


return t;