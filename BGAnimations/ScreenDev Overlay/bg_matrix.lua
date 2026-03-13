local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame{

	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		self:zoom(1);
	end;

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/light4"))..{
		OnCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(color("#0027c4"));
			self:diffusealpha(0.4);
			self:x(-2000);
			self:zoom(2.5);
			self:queuecommand("Ani");
		end;

		AniCommand = function(self)
			self:x(-2000);
			self:linear(8);
			self:x(2000);
			self:queuecommand("Ani");
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


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/light4"))..{
		OnCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(color("#ff0073"));
			self:diffusealpha(0.4);
			self:x(2000);
			self:zoom(2.5);
			self:sleep(5);
			self:queuecommand("Ani");
		end;

		AniCommand = function(self)

			self:linear(7);
			self:x(-2000);
			self:queuecommand("Ani");
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


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/light4"))..{
		OnCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(color("#ff0073"));
			self:diffusealpha(0.4);
			self:zoom(3);
			self:x(800);
			self:y(1500);
			self:sleep(1);
			self:queuecommand("Ani");
		end;

		AniCommand = function(self)
			self:x(800);
			self:y(1500);			
			self:decelerate(15);
			self:x(-800);
			self:y(-1500);
			self:queuecommand("Ani");
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


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/light4"))..{
		OnCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(color("#00ffee"));
			self:diffusealpha(0.4);
			self:zoom(3);
			self:x(-800);
			self:y(1500);
			self:sleep(1);
			self:queuecommand("Ani");
		end;

		AniCommand = function(self)
			self:x(-800);
			self:y(1500);			
			self:decelerate(13);
			self:x(800);
			self:y(-1500);
			self:queuecommand("Ani");
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

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/light4"))..{
		OnCommand=function(self)
			self:blend("BlendMode_Add");
			self:diffuse(color("#ff5500"));
			self:diffusealpha(0.4);
			self:zoom(3);
			self:x(-800);
			self:y(-1500);
			self:sleep(1);
			self:queuecommand("Ani");
		end;

		AniCommand = function(self)
			self:x(-800);
			self:y(-1500);			
			self:decelerate(9);
			self:x(800);
			self:y(1500);
			self:queuecommand("Ani");
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

t[#t+1] = Def.ActorFrame{

	--[[
	CodeMessageCommand=function(self, params)
		self:GetChild("blueDownR"):playcommand("Ani");
	end;
	]]

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig05arr"))..{
			Name="blueDownL";
			OnCommand=function(self)
				self:x(80);
				self:y(680);
				self:blend("BlendMode_Add");
				self:diffuse(color("#ffffff"));
				self:diffusealpha(0.5);
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

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/pressglow"))..{
			Name="blueDownLGlow";
			OnCommand=function(self)
				self:x(60);
				self:y(660);
				self:diffuse(color("#0000ff"));
				self:blend("BlendMode_Add");
				self:diffusealpha(0.5);
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

			pressCommand=function(self)
				self:stoptweening();
				self:accelerate(0.05);
				self:diffusealpha(1);
			end;

			releaseCommand=function(self)
				self:stoptweening();
				self:accelerate(0.05);
				self:diffusealpha(0);
			end;
		};


		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig05arr"))..{
		Name="blueDownR";
		OnCommand=function(self)
			self:x(1200);
			self:y(680);
			self:blend("BlendMode_Add");
			self:diffuse(color("#ffffff"));
			self:diffusealpha(0.3);
			self:rotationz(270);
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

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/pressglow"))..{
		Name="blueDownRGlow";
		OnCommand=function(self)
			self:x(1220);
			self:y(660);
			self:diffuse(color("#0000ff"));
			self:blend("BlendMode_Add");
			self:diffusealpha(0.5);
			self:rotationz(270);
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

		pressCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(1);
		end;

		releaseCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(0);
		end;
	};	


	--******

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig05arr"))..{
		Name="redUpL";
		OnCommand=function(self)
			self:x(80);
			self:y(40);
			self:blend("BlendMode_Add");
			self:rotationz(90);
			self:diffuse(color("#ffffff"));
			self:diffusealpha(0.3);
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

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/pressglow"))..{
		Name="redUpLGlow";
		OnCommand=function(self)
			self:x(60);
			self:y(60);
			self:blend("BlendMode_Add");
			self:rotationz(90);
			self:diffuse(color("#ff0000"));
			self:diffusealpha(0.5);
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

		pressCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(1);
		end;
		releaseCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(0);
		end;
	};	


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig05arr"))..{
		Name="redUpR";
		OnCommand=function(self)
			self:x(1200);
			self:y(40);
			self:blend("BlendMode_Add");
			self:diffuse(color("#ffffff"));
			self:diffusealpha(0.3);
			self:rotationz(180);
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


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/pressglow"))..{
		Name="redUpR";
		OnCommand=function(self)
			self:x(1220);
			self:y(60);
			self:blend("BlendMode_Add");
			self:diffuse(color("#ff0000"));
			self:diffusealpha(0.5);
			self:rotationz(180);
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

		pressCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(1);
		end;
		releaseCommand=function(self)
			self:stoptweening();
			self:accelerate(0.05);
			self:diffusealpha(0);
		end;
	};

}

t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/background20"))..{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);
			self:blend("BlendMode_Add");
			self:diffuse(color("#010a2c"));
			self:diffusealpha(0.3);
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

}



t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/background20"))..{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);
			self:blend("BlendMode_Add");
			self:diffuse(color("#010a2c"));
			self:diffusealpha(0.3);
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

}




t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/backgroundMatrix20"))..{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);
			self:blend("BlendMode_Add")
			self:diffusealpha(1);
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

}
--[[
local frameTimeFigs = 0.08;
local sleepBetweenShow = 1.2;
local numArrows = 1;
local secondsBeforeNextRound = 4;

for i = 1, numArrows do

	t[#t+1] = Def.ActorFrame{

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig02"))..{
			OnCommand=function(self)
				self:x(60);--  -100 / 1440
				self:y(SCREEN_CENTER_Y);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.8);
				self:fadeleft(0.5);
				self:sleep(sleepBetweenShow*(i-1));
				self:queuecommand("Ani");
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

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig02"))..{
			OnCommand=function(self)
				self:x(1220);--  -100 / 1440
				self:y(SCREEN_CENTER_Y-22);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.8);
				self:fadeleft(0.5);
				self:rotationz(180);
				self:sleep(sleepBetweenShow*(i-1));
				self:queuecommand("Ani");
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

	}

end;



for i = 1, numArrows do

	t[#t+1] = Def.ActorFrame{

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig02"))..{
			OnCommand=function(self)
				self:x(-100);--  -100 / 1440
				self:y(SCREEN_CENTER_Y);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.8);
				self:fadeleft(0.5);
				self:sleep(sleepBetweenShow*(i-1));
				self:queuecommand("Ani");
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

			AniCommand=function(self)
				self:sleep(frameTimeFigs);
				self:addx(20);
				if self:GetX() > 1440 then
					self:x(-100);
					self:sleep(secondsBeforeNextRound);
				end;

				self:queuecommand("Ani");
			end;
		};	

		LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig02"))..{
			OnCommand=function(self)
				self:x(1380);--  -100 / 1440
				self:y(SCREEN_CENTER_Y-22);
				self:blend("BlendMode_Add");
				self:diffusealpha(0.8);
				self:fadeleft(0.5);
				self:rotationz(180);
				self:sleep(sleepBetweenShow*(i-1));
				self:queuecommand("Ani");
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

			AniCommand=function(self)
				self:sleep(frameTimeFigs);
				self:addx(-20);
				if self:GetX() < -100 then
					self:x(1400);	
					self:sleep(secondsBeforeNextRound);			
				end;

				self:queuecommand("Ani");
			end;

		};	

	}

end;

]]



local blocksLinesTimes=0.2;
t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig04"))..{
		OnCommand=function(self)
			self:x(-90);--  -100 / 1440
			self:y(10);
			self:diffuse(color("#ffff00"));
			self:blend("BlendMode_Add");
			self:diffusealpha(0.8);
			self:queuecommand("Ani");
		end;

		AniCommand=function(self)
			self:sleep(blocksLinesTimes);
			self:diffusealpha(1);
			self:addx(20);
			if self:GetX() == 630 then
				self:x(-90);
			end;
			self:decelerate(0.125);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

	};

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig04"))..{
		OnCommand=function(self)
			self:x(-90);--  -100 / 1440
			self:y(710);
			self:diffuse(color("#ffff00"));
			self:blend("BlendMode_Add");
			self:diffusealpha(0.8);
			self:queuecommand("Ani");
		end;


		AniCommand=function(self)
			self:sleep(blocksLinesTimes);
			self:diffusealpha(1);
			self:addx(20);
			if self:GetX() == 630 then
				self:x(-90);
			end;
			self:decelerate(0.125);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

	};	

	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig04"))..{
		OnCommand=function(self)
			self:x(1370);--  -100 / 1440
			self:y(10);
			self:diffuse(color("#ffff00"));
			self:blend("BlendMode_Add");
			self:diffusealpha(0.8);
			self:queuecommand("Ani");
		end;


		AniCommand=function(self)
			self:sleep(blocksLinesTimes);
			self:diffusealpha(1);
			self:addx(-20);
			if self:GetX() == 650 then
				self:x(1370);
			end;
			self:decelerate(0.125);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

	};	


	LoadActor(THEME:GetPathG("","commonBackground/bg_matrix/fig04"))..{
		OnCommand=function(self)
			self:x(1370);--  -100 / 1440
			self:y(710);
			self:diffuse(color("#ffff00"));
			self:blend("BlendMode_Add");
			self:diffusealpha(0.8);
			self:queuecommand("Ani");
		end;


		AniCommand=function(self)
			self:sleep(blocksLinesTimes);
			self:diffusealpha(1);
			self:addx(-20);
			if self:GetX() == 650 then
				self:x(1370);
			end;
			self:decelerate(0.125);
			self:diffusealpha(0);
			self:queuecommand("Ani");
		end;

	};	

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


-- INIT MATRIX
local matrixHorizontalBlocks = 66;
local matrixVerticalBlocks = 36;
-- Total Pixels : 66x36 = 2376

-- SPACING OF EACH PIXEL
local matrixSpacingX=20;
local matrixSpacingY=20;

--MIN PLACE 
local matrixMinX=10;
local matrixMinY=10;



local planeA = Def.ActorFrame{
	Name="PlaneA";
	turnOffAllPixelsCommand=function(self)
		for i = 1, matrixHorizontalBlocks do -- H
			for x = 1, matrixVerticalBlocks do -- V
				local nameC="px_"..i.."_"..x;
				self:GetChild(nameC):stoptweening():diffusealpha(0);
			end;
		end;

	end;

	turnOnAllPixelsCommand=function(self)
		for i = 1, matrixHorizontalBlocks do -- H
			for x = 1, matrixVerticalBlocks do -- V
				local nameC="px_"..i.."_"..x;
				self:GetChild(nameC):stoptweening():diffusealpha(1);
			end;
		end;
	end;

	randomPixelOnCommand=function(self)
		local h = math.random(1, matrixHorizontalBlocks);
		local v = math.random(1, matrixVerticalBlocks);
		local timeSleep = 0.3;
		local speedFadeIn = 0.1;
		local speedFadeOut = 0.8;
		local diffusealphaItem = 0.1;
		local nameC="px_"..h.."_"..v;
		self:GetChild(nameC):stoptweening():diffuse(color("#ffffff")):diffusealpha(0):linear(speedFadeIn):diffusealpha(diffusealphaItem):sleep(timeSleep):linear(speedFadeOut):diffusealpha(0);
	end;

	linearVWaveCommand=function(self)
		local colorAvailable = {"#F1F864","#4300FF","#FF0B55","#00CAFF"};
		local indexColorSelected = math.random(1, #colorAvailable);
		local vplace = math.random(1, matrixVerticalBlocks);
		local sFadeIn = 0.2;
		local sFadeOut = 1;
		local bTsleep = 0.5;

		for i=1, matrixHorizontalBlocks do
			local nameC="px_"..i.."_"..vplace;
			self:GetChild(nameC):stoptweening():sleep(0.2 * i):diffuse(color(colorAvailable[indexColorSelected])):diffusealpha(0):linear(sFadeIn):diffusealpha(0.5):sleep(bTsleep):linear(sFadeOut):diffusealpha(0);
		end;
	end;

	linearRVWaveCommand=function(self)
		local colorAvailable = {"#F1F864","#4300FF","#FF0B55","#00CAFF"};
		local indexColorSelected = math.random(1, #colorAvailable);
		local vplace = math.random(1, matrixVerticalBlocks);
		local sFadeIn = 0.2;
		local sFadeOut = 1;
		local bTsleep = 0.5;

		for i=1, matrixHorizontalBlocks do
			local RIndex = matrixHorizontalBlocks - (i-1);
			local nameC="px_"..RIndex.."_"..vplace;
			self:GetChild(nameC):stoptweening():sleep(0.2 * i):diffuse(color(colorAvailable[indexColorSelected])):diffusealpha(0):linear(sFadeIn):diffusealpha(0.5):sleep(bTsleep):linear(sFadeOut):diffusealpha(0);
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

}

for i = 1, matrixHorizontalBlocks do -- H
	for x = 1, matrixVerticalBlocks do -- V

		-- ex: px_1_36
		local pixelNamePos = "px_"..i.."_"..x;
		planeA[#planeA+1] = Def.Quad {
				Name=pixelNamePos;
				OnCommand=function(self)
					self:x(matrixMinX + (matrixSpacingX * (i-1))); -- min:10 | spacing 20
					self:y(matrixMinY + (matrixSpacingY * (x-1))); -- min:10 | spacing 20 
					self:zoomto(16, 16);
					self:blend("BlendMode_Add");
					self:diffuse(color("#ffffff"));
					self:diffusealpha(0);
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

	end;
end;

t[#t+1] = planeA;



-- ############################################################################# --
-- ############################################################################# --
-- ############################################################################# --


local switchedOff=0;
t[#t+1] = Def.Quad {

	OnCommand = function(self)
		self:queuecommand("Ani");
	end;

	AniCommand=function(self)
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");		
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");		
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");		
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");		
		self:GetParent():GetChild("PlaneA"):playcommand("randomPixelOn");
		self:sleep(0.2);
		self:queuecommand("Ani");
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

t[#t+1] = Def.Quad {

	OnCommand = function(self)
		self:queuecommand("Ani");		
	end;

	AniCommand=function(self)
		self:GetParent():GetChild("PlaneA"):playcommand("linearVWave");
		self:GetParent():GetChild("PlaneA"):playcommand("linearRVWave");
		self:sleep(5);
		self:queuecommand("Ani");
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


return t;