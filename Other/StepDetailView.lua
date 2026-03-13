

function StepDetailView(pn,tdata)
--	if not pn or not GAMESTATE:IsHumanPlayer(pn) then return Def.ActorFrame{} end;
	local xpos = pn == PLAYER_1 and -1 or 1
	local chartInfo = {
		sltr = 6,
		lv = "00",
		sType = 1,
		stpartist = "StepArtist_Name_Here",
		dlabel = 2,
		clabel = 2,
	}
	
	if tdata then
		if tdata._type == "song" and tdata.step then	--necesitamos agregar los demas tipos
			if tdata.step then
				local step = tdata.step
				local iconstate = DirectIconLayer2(step);
				if pn == PLAYER_2 then
					if iconstate == 2 or iconstate == 4 then
						iconstate = iconstate+1
					end;
				end;
				local labeltype = string.lower(LabelTypeToMode(step:GetLabelType()))
				local clabeldesc = string.lower(DesCustomLabel(step:GetDescription()))
				
				chartInfo.sltr = DirectIconLayer(step);
				chartInfo.lv = DisplayLV(step:GetMeter());
				chartInfo.sType = iconstate;
				chartInfo.stpartist = FixedChartCreditNames(step:GetAuthorCredit());
				chartInfo.dlabel = (labeltype == "ucs" and 2) or (labeltype == "another" and 3) or 0;
				chartInfo.clabel = setNormalLabelState(labeltype, clabeldesc);
			end;
		end;
	end;

	return Def.ActorFrame{
		LoadActor(GetElement("lv_selector","SelectMusic"))..{
			Name = "Back",
			InitCommand = cmd(zoom,0.75;animate,false;setstate,chartInfo.sltr;rotationy,xpos == 1 and 180 or 0;
				shadowlengthx,6 * xpos;shadowlengthy,3.5;),
		},
		LoadActor(GetElement("lv_selector","SelectMusic"))..{
			Name = "BackGlow",
			InitCommand = cmd(zoom,0.75;animate,false;setstate,chartInfo.sltr;rotationy,xpos == 1 and 180 or 0;
				blend,Blend.Add;glowshift;effectcolor1,color("#ffffff12");effectcolor2,color("#00000012");fadebottom,0.6;),
		},
		Def.ActorFrame{
			Name = "Level",
			InitCommand = cmd(xy,-59 * xpos,-8;	),
			LoadFont("Russo_One/Russo One outline 40px")..{
				Name = "Text",
				Text = chartInfo.lv,
				InitCommand = cmd(xy,10.5,0;zoomx,0.96;shadowlengthx,3 * xpos;shadowlengthy,3;
					diffuseshift;effectperiod,1.5;effectcolor1,color("1,1,1,.9");effectcolor2,color("1,1,1,0.8");),
			},
			LoadFont("Russo_One/Russo One outline 40px")..{
				Name = "Label",
				Text = "lv",
				InitCommand = cmd(xy,-27.5,8;zoom,0.45;shadowlengthx,3 * xpos;shadowlengthy,3;
					diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0.9");),
			},
		},
		LoadActor(GetElement("Steptype Icons","SelectMusic"))..{
			Name = "TypeIcon",
			InitCommand = cmd(zoom,0.4;xy,6 * xpos,-6+2;animate,false;setstate,chartInfo.sType;shadowlengthx,3 * xpos;shadowlengthy,3;diffusealpha,.85;),
		},
		LoadFont("Tomorrow/Tomorrow outline 40px")..{
			Name = "StepArtistText",
			Text = chartInfo.stpartist,
			InitCommand = cmd(xy,-70 * xpos,16;zoom,0.42;zoomy,0.38;maxwidth,375;
				shadowlengthx,1 * xpos;shadowlengthy,1;horizalign,xpos == 1 and left or right;strokecolor,color("#00000088")),
		},
		Def.ActorFrame {
			Name = "StepArtistAnaglyph",
			InitCommand = cmd(xy,-78 * xpos,17),
			Def.Quad { InitCommand = cmd(xy,-1.5*xpos,-1; zoomto,9,9; diffuse,color("#00FFFF"); blend,Blend.Add) },
			Def.Quad { InitCommand = cmd(xy,1.5*xpos, 1; zoomto,9,9; diffuse,color("#FF0000"); blend,Blend.Add) },
			Def.Quad { InitCommand = cmd(zoomto,9,9; diffuse,color("#FFFFFF")) },
		},
		LoadActor(GetElement("DIFFLABELS","SelectMusic"))..{
			Name = "DLabel",
			InitCommand = cmd(zoom,0.6;xy,60 * xpos,-10;animate,false;setstate,chartInfo.dlabel;shadowlengthx,3 * xpos;shadowlengthy,3;),
		},
		LoadActor(GetElement("CUSLABELS","SelectMusic"))..{
			Name = "CLabel",
			InitCommand = cmd(zoom,0.6;xy,62 * xpos,3;animate,false;setstate,chartInfo.clabel;shadowlengthx,3 * xpos;shadowlengthy,3;),
		},
		LoadActor(GetElement("lv_selector","SelectMusic"))..{
			Name = "Glow",
			InitCommand = cmd(zoom,0.75;fadebottom,0.6;animate,false;setstate,chartInfo.sltr;rotationy,xpos == 1 and 180 or 0;blend,Blend.Add;
				diffuseshift;effectperiod,0.25;effectcolor2,color("1,1,1,0.6");visible,false;),
		},
		LoadActor(GetElement("lv_selector","SelectMusic"))..{
			Name = "Shadow",
			InitCommand = cmd(zoom,0.78;animate,false;setstate,6;rotationy,xpos == 1 and 180 or 0;diffuse,color("#000000bb");visible,false;),
		},
	}
end

--[[
local tdatap2 = {
	_type = "song",
	step = GAMESTATE:GetCurrentSteps(PLAYER_2)
};
return Def.ActorFrame {
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y*.8;fov,60;);
	
	StepDetailView(PLAYER_2,tdatap2)..{
		InitCommand=cmd(xy,0,80;zoom,1.2;rotationy,30;);
	};
};

--]]


function CreateEqualizer(numBars,minHeight,maxHeight,barWidth,spacing,speed,rainbow,tperiod,bcolor,bcolor2)
	numBars = numBars or 16;
	minHeight = minHeight or 10;
	maxHeight = maxHeight or 110;
		maxHeight = maxHeight-minHeight;
	barWidth = barWidth or 10;
	spacing = spacing or 2;
	speed   = speed or 3;
	rainbow = rainbow or false;
	tperiod = tperiod or 2;
	bcolor = bcolor or color("0,1,0,1");
	bcolor2= bcolor2 or color("1,0,0,1");
local t = Def.ActorFrame{}

for i = 1, numBars do
    t[#t+1] = Def.Quad{
        InitCommand=function(self)
            local xPos = -((numBars * (barWidth + spacing)) / 2) + (i-1) * (barWidth + spacing)
            self:xy(xPos, 0):zoomto(barWidth, minHeight)
            self:diffuse(bcolor);
			if rainbow then
				self:rainbowt(rainbow):effectperiod(tperiod);
			else
				self:diffuseshift():effectcolor1(bcolor):effectcolor2(bcolor2):effectperiod(tperiod)
			end;
			self:vertalign(bottom);

			self:fadetop(.05);
        end;
        UpdateCommand=function(self)
			local beatFactor;
				local songPos = GAMESTATE:GetSongPosition():GetMusicSeconds()  -- Tiempo en segundos
				beatFactor = math.sin(songPos * speed + i * 0.5) * 0.5 + 0.5  -- Oscilación entre 0 y 1
            local newHeight = minHeight + (beatFactor * maxHeight*(math.random(0,100)/100))  -- Ajuste de altura basado en la oscilación
			
            self:stoptweening():decelerate(0.1):zoomy(newHeight)  -- Animación suave
            self:sleep(1/30):queuecommand("Update")  -- Repite la animación cada 1/30s (~30FPS)
        end;

        OnCommand=function(self)
            self:queuecommand("Update")  -- Activa la animación en cuanto aparece en pantalla
        end;
    }
end

return t
end;