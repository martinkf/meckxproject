local t = Def.ActorFrame {}
local zoomTextVs=0.8;


t[#t+1] = Def.ActorFrame
{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y+90);
	end;

	JudgmentMessageCommand=function(self,param)
		local scorep1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPhoenixScore();
		local scorep2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetPhoenixScore();

		local scoreStatP1 = scorep1 - scorep2;
		local scoreStatP2 = scorep2 - scorep1;

		if scoreStatP1 >= 0 then
			self:GetChild("p1ScoreDif"):diffusecolor(color("#ffffff")):settext("+"..scoreStatP1);
		else
			self:GetChild("p1ScoreDif"):diffusecolor(color("#ff0000")):settext(scoreStatP1);
		end;

		if scoreStatP2 >= 0 then
			self:GetChild("p2ScoreDif"):diffusecolor(color("#ffffff")):settext("+"..scoreStatP2);
		else
			self:GetChild("p2ScoreDif"):diffusecolor(color("#ff0000")):settext(scoreStatP2);
		end;

	end;

	LoadFont("normalxolonium")..{
		Name="p1ScoreDif";
		InitCommand=cmd(x,-248;shadowlength,1;shadowcolor,color("#00000");zoom,zoomTextVs;horizalign,"center";diffusecolor,color("#ffffff"));
		OnCommand=function(self)
			self:settext("+0")
		end;

	};

	LoadFont("normalxolonium")..{
		Name="p2ScoreDif";
		InitCommand=cmd(x,235;shadowlength,1;shadowcolor,color("#00000");zoom,zoomTextVs;horizalign,"center";diffusecolor,color("#ffffff"));
		OnCommand=function(self)
			self:settext("+0")
		end;
	};

}

return t;