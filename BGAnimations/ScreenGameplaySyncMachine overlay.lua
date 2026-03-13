--############################################################################################################
-- GRAPH
--############################################################################################################
local TNSName = {
		TapNoteScore_CheckpointHit = "perfect";
		TapNoteScore_W1 = "perfect";
		TapNoteScore_W2 = "perfect";
		TapNoteScore_W3 = "great";
		TapNoteScore_W4 = "good";
		TapNoteScore_W5 = "bad";
		TapNoteScore_Miss = "miss";
		TapNoteScore_CheckpointMiss = "miss";
}

local TNSframe = {
		TapNoteScore_CheckpointHit = 0;
		TapNoteScore_W1 = 0;
		TapNoteScore_W2 = 0;
		TapNoteScore_W3 = 2;
		TapNoteScore_W4 = 3;
		TapNoteScore_W5 = 4;
		TapNoteScore_Miss = 5;
		TapNoteScore_CheckpointMiss = 5;
}

local dataPressSync = {};
local binsSyncGameplay = {};
local tnsColors = {"#b9feff","#00ccff","#00ff24","#fff600","#ff00de","#ff0000"};


--This reset the bins to 0, ideally call when the songs ends to reset the graph.
function resetBins(bins,MinOffset,MaxOffset)
	--create array for data
	for i = MinOffset, MaxOffset do
	    bins[i] = { total = 0, tns = "" , color = "#000000" };
	end;
	return bins;
end;

--populate the bins with data from the inputs :3
function populateBins(bins,offsetAction,tns,tns_name)

		local color = tnsColors[tns+1];

		if offsetAction > 200 then
			offsetAction = 200;
		end;

		if offsetAction < -200 then
			offsetAction = -200;
		end;

		local tempCount = bins[offsetAction]["total"];
		bins[offsetAction]["total"] = tempCount + 1;
		bins[offsetAction]["tns"] = tns_name; --perfect,great,good,bad,miss
		bins[offsetAction]["color"] = color;

		return bins;
end;

function getGraphCard(width,height,MinOffset,MaxOffset,padding,smooth_radius)
	--we obtain the data colected.

	--[[
	local width = 460;
	local height = 150;
	local padding = 4;
	local smooth_radius = 14;
	]]

	binsSyncGameplay = resetBins(binsSyncGameplay,MinOffset,MaxOffset);

	return Def.ActorFrame {
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X+220);
			self:y(SCREEN_CENTER_Y-200);
		end;

	    Def.Quad{
	      InitCommand=function(self)
	        self:zoomto(width-3, height+40):diffuse(0,0,0,0.65):diffusebottomedge(0,0,0,0.8):x(-2);
	      end
	    };

		Def.ActorFrame {
			OnCommand=function(self)
				self:zoomx(1);
				self:y(-10);
			end;

		    Def.ActorMultiVertex{
		      InitCommand=function(self) 
		      	self:SetDrawState{Mode="DrawMode_Triangles"} 
		      end;

		      OnCommand=function(self)
		        local verts = build_area_verts(binsSyncGameplay,MinOffset,MaxOffset,padding,width,height,smooth_radius);
		        self:SetNumVertices(#verts)
		        self:SetVertices(verts)
		      end;

		      JudgmentMessageCommand=function(self,param)

				local player = GAMESTATE:GetMasterPlayerNumber();
				local checkpointPerfect =STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");
				local pf = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1") + STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2") + checkpointPerfect;
				local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
				local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
				local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
				local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
				local totalNotes = pf+gr+gd+bd+miss;

				--Trace("# TOTAL NOTES->"..totalNotes);


				local noteOffset = -1;
				local isEarly = 0;		
				local iTns = TNSframe[param["TapNoteScore"]];
				local tnsName = TNSName[param["TapNoteScore"]];

				noteOffset = param["TapNoteOffset"] and math.floor(param["TapNoteOffset"] * 1000 + 0.5) or nil;
				if iTns > 0 and iTns < 5 then
					if param["Early"] then
						isEarly = 1;
					end;
				end;

			    table.insert(dataPressSync, {
			      tns_name	= tnsName,
			      offset_ms = noteOffset,        -- timing (+late / -early)
			      isEarly	= isEarly
			    });	

			    if totalNotes  == 252 then			    	
			    	binsSyncGameplay = resetBins(binsSyncGameplay,MinOffset,MaxOffset);
			    	self:sleep(3);
			    	self:playcommand("refreshGraph");

			    else
			    	populateBins(binsSyncGameplay,noteOffset,iTns,tnsName);
		      		self:queuecommand("showInfo");
			    end;
		      end;

		      showInfoCommand=function(self)
		        local verts = build_area_verts(binsSyncGameplay,MinOffset,MaxOffset,padding,width,height,smooth_radius);
		        self:SetNumVertices(#verts)
		        self:SetVertices(verts)
		      end;

		      refreshGraphCommand=function(self)
			        local verts = build_area_verts(binsSyncGameplay,MinOffset,MaxOffset,padding,width,height,smooth_radius);
			        self:SetNumVertices(#verts)
			        self:SetVertices(verts);
		      end;
		    };
		};

	    Def.Quad{
	      InitCommand=function(self) self:zoomto(2, height-padding*2+35):diffuse(color("#fff000")) end
	    },

	    Def.Quad{
	      InitCommand=function(self) self:zoomto(width-1, 1):diffuse(color("#ffffff")):y(61):x(-2) end
	    },

		LoadFont("xolonium 20px")..{	
				OnCommand=function(self)
					self:zoom(0.8);
					self:x(96);
					self:y(80);
					self:settext("0 MS / Perfect Timing");
				end;
				FinalizedMessageCommand=cmd(finishtweening;visible,false);
		};	    

	    --early
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,0;x,-170;y,-80;zoom,0.6);
		};
	    --early
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,-170;y,-50;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,-135;y,-40;zoom,0.6);
		};
		--late
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/timing 1x2"))..{
			OnCommand=cmd(animate,false;setstate,1;x,170;y,-80;zoom,0.6);
		};	
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,170;y,-50;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,203;y,-60;zoom,0.6);
		};


		 LoadActor(THEME:GetPathG("","ScreenEvaluation/information/receptor_icon"))..{
			OnCommand=cmd(x,-52;y,80;zoom,0.75);
		};
	    LoadActor(THEME:GetPathG("","ScreenEvaluation/information/arrow_timing"))..{
			OnCommand=cmd(x,-17;y,80;zoom,0.6);
		};

	};	

end;


function build_area_verts(bins,MIN_BIN,MAX_BIN,PADDING,WIDTH,HEIGHT,SMOOTH_RADIUS)

  local counts, maxCount = smooth_counts(bins, SMOOTH_RADIUS,MIN_BIN,MAX_BIN)
  local verts = {}
  if maxCount == 0 then return verts end

  local innerW = WIDTH - PADDING*2
  local innerH = HEIGHT - PADDING*2
  local binCount = (MAX_BIN - MIN_BIN + 1)
  local binW = innerW / binCount
  local leftX = -WIDTH/2 + PADDING
  local baseY =  HEIGHT/2 - PADDING

  for i=MIN_BIN,MAX_BIN do
    local c = counts[i] or 0
    local h = math.max(1, (c / maxCount) * innerH)
    local xL = leftX + (i - MIN_BIN) * binW
    local xR = xL + binW
    local yB = baseY
    local yT = baseY - h
    local col = color_for_ms(bins[i])  -- color fijo por ventana
    if i == 0 then
    	col = color("#fff000"); 
    end;

    -- rectángulo como 2 triángulos
    verts[#verts+1] = { {xL, yB, 0}, col }
    verts[#verts+1] = { {xL, yT, 0}, col }
    verts[#verts+1] = { {xR, yT, 0}, col }

    verts[#verts+1] = { {xL, yB, 0}, col }
    verts[#verts+1] = { {xR, yT, 0}, col }
    verts[#verts+1] = { {xR, yB, 0}, col }
  end

  return verts
end

function color_for_ms(data)
	return color(data["color"]);
end;

function smooth_counts(bins, r,MIN_BIN,MAX_BIN)
  if r<=0 then
    local raw, m = {}, 0
    for i=MIN_BIN,MAX_BIN do raw[i]=bins[i].total; if raw[i]>m then m=raw[i] end end
    return raw, m
  end
  local k = gaussian_kernel(r); local half = math.floor(#k/2)
  local out, m = {}, 0
  for i=MIN_BIN,MAX_BIN do
    local s=0
    for j=-half,half do
      local jj=i+j
      if jj>=MIN_BIN and jj<=MAX_BIN then s = s + bins[jj].total * k[j+half+1] end
    end
    out[i]=s; if s>m then m=s end
  end
  return out, m
end

function gaussian_kernel(r)
  if r <= 0 then return {1} end
  local sigma = r * 0.75
  local twoS2 = 2*sigma*sigma
  local k, sum = {}, 0
  for x=-r, r do
    local w = math.exp(-(x*x)/twoS2); k[#k+1]=w; sum=sum+w
  end
  for i=1,#k do k[i]=k[i]/sum end
  return k
end

--############################################################################################################
--############################################################################################################


local t = Def.ActorFrame
{
	InitCommand=function(self)
		
	end;

	JudgmentMessageCommand=function(self,param)
		--[[
			param[FirstTrack] = 2
			param[Player] = P1
			param[TapNoteScore] = W2
			param[Notes] = table: 0000020D051C4890
			param[Holds] = table: 0000020D051C5790
			param[Early] = true
		]]

		
		--esta jugando con extra judgment?
		local player = GAMESTATE:GetMasterPlayerNumber();
		local extraJudgment = GAMESTATE:GetExtraJudgment();
		local pfplus = 0;
		local pf = 0;

		local checkpointPerfect =STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");
		if extraJudgment then
			pfplus = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1") + checkpointPerfect;
			pf = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2");
		else
			pfplus = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1") + STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2") + checkpointPerfect;
			pf = 0;
		end;

	
		local gr = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
		local gd = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
		local bd= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
		local miss= STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+ STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");
		local totalNotes = pfplus+pf+gr+gd+bd+miss;
		noteOffset = param["TapNoteOffset"] and math.floor(param["TapNoteOffset"] * 1000 + 0.5) or nil;

		--[[
		Trace("#####################");
		Trace("# MPERFECT->"..pfplus);
		Trace("# PERFECT ->"..pf);
		Trace("# GREAT   ->"..gr);
		Trace("# GOOD    ->"..gd);
		Trace("# BAD     ->"..bd);
		Trace("# MISS    ->"..miss);
		Trace("####");
		Trace("#OFFSET JUDGMENT:"..noteOffset);
		Trace("#OFFSET JUDGMENT:"..param["TapNoteScore"]);
		]]



		--[[
	    Trace("=== SomeMessage param ===")
	    if not param then Trace("(nil)"); return end
	    for k, v in pairs(param) do
	        -- Convierte enums a texto legible cuando existan
	        if k == "Player" or k == "pn" then
	            v = ToEnumShortString(v)  -- PLAYER_1 -> "P1"
	        elseif k == "TapNoteScore" or k == "tns" then
	            v = ToEnumShortString(v)  -- TapNoteScore_W1 -> "W1"
	        end
	        Trace(string.format("param[%s] = %s", tostring(k), tostring(v)))
	    end

	    Trace(param["TapNoteOffset"]);
		]]
	end;

	resetGraphCommand=function(self)
		--Trace("# Reseteo grafico");
	end;

};


t[#t+1] = getGraphCard(550,220,-200,200,4,14);




return t;
