local t = Def.ActorFrame{}

-- SUPA TRASH LUA :<
--local vChannels = SONGMAN:GetSongsInGroup("00-00SYS");
local vChannels = SONGMAN:GetPrivateChannels();

function GetDataPack(i, info)

	if (info == "banner") then
		if (vChannels[i] == nil) then
			return THEME:GetPathG("","Common nobanner");
		else
			local path = vChannels[i]:GetBannerPath();
			if path ~= nil and FILEMAN:DoesFileExist(path) then
				return path;
			else
				return THEME:GetPathG("","Common nobanner");
			end;
			
		end;
	end;

	if (info == "quad") then
		if (vChannels[i] == nil) then
			return 0;
		else
			return 1;
		end;
	end;
	
	if (vChannels[i] == nil) then
		return ""
	end;

	if (info == "name") then
		if vChannels[i]:GetGenre() == "" then
			return "Unknown";
		else
			return vChannels[i]:GetGenre();
		end;
	elseif (info == "author") then
		if vChannels[i]:GetCredit() == "" then
			return "Unknown author"
		else
			return vChannels[i]:GetCredit();
		end;
	elseif (info == "url") then
		if vChannels[i]:GetDisplaySubTitle() == "" then
			return "URL not available"
		else
			return vChannels[i]:GetDisplaySubTitle();
		end;
	elseif (info == "dir") then
		return "Song Folder: " .. vChannels[i]:GetSystemFolder();
	end;
end;

t[#t+1] = Def.Quad
{
	InitCommand=cmd(Center;y,SCREEN_CENTER_Y+50;zoomto,840,450;diffuse,color(".06,.06,.06,1"));
};

t[#t+1] =LoadActor(THEME:GetPathG("","PIU LOGO"))..{
	InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_TOP+10;zoom,.6;vertalign,top);
};


t[#t+1] = LoadFont("Common normal")..{
	InitCommand=cmd(Center;settext,"NO PACKS INSTALLED");
	HideWarningPackMessageCommand=cmd(visible,false);
};
t[#t+1] =  Def.ActorFrame
{
	InitCommand=function(self)
		self:visible(false);
		if (vChannels ~= nil and #vChannels > 0) then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;

	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 0;Center;y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  - 370;queuecommand,"CheckList");
		CheckListCommand=function(self)
			if (vChannels ~= nil and #vChannels < 9) then
				self:visible(false);
			end;
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  - 310;settext,"Previous";zoom,.7;queuecommand,"CheckList");
		CheckListCommand=function(self)
			if (vChannels ~= nil and #vChannels < 9) then
				self:visible(false);
			end;
		end;
	};

	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 1;Center;y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  + 370;queuecommand,"CheckList");
		CheckListCommand=function(self)
			if (vChannels ~= nil and #vChannels < 9) then
				self:visible(false);
			end;
		end;
	};

	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  + 320;settext,"Next";zoom,.7;queuecommand,"CheckList");
		CheckListCommand=function(self)
			if (vChannels ~= nil and #vChannels < 9) then
				self:visible(false);
			end;
		end;
	};


	
};

t[#t+1] =  Def.ActorFrame
{

	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 2;Center;y,SCREEN_CENTER_Y-150;x, SCREEN_CENTER_X  - 370);
	};

	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 3;Center;y,SCREEN_CENTER_Y-150;x, SCREEN_CENTER_X  + 370);
	};

	LoadFont("Common normal")..{
		InitCommand=cmd(zoom,.8;x,SCREEN_CENTER_X-100;y,SCREEN_CENTER_Y-150;settext,"Packages List");
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(zoom,.8;x,SCREEN_CENTER_X+100;y,SCREEN_CENTER_Y-150;settext,"Create Package");
	};
	
	Def.Quad
	{
		InitCommand=cmd(Center;y,SCREEN_CENTER_Y-130;x,SCREEN_CENTER_X-100;zoomto,140,3;diffuse,color("0,1,0,1"));
		PanelPackListMessageCommand=cmd(x,SCREEN_CENTER_X-100);
		PanelPackerMessageCommand=cmd(x,SCREEN_CENTER_X+100);
	};
	
}

-- Lista
for i=1,4,1 do

	if ( vChannels[i] ~= nil) then
	
		t[#t+1] = Def.Quad
		{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(Center;y,(SCREEN_CENTER_Y - 140) + i * 80;x, SCREEN_CENTER_X - 200;zoomto,360,75;diffuse,color(".2,.2,.2,1");diffusealpha, GetDataPack(i, "quad") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				if (vChannels[i + params.Floor] ~= nil) then
					self:linear(.3):diffusealpha(1);
				end;
			end;
		};

		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .6;Center;y, (SCREEN_CENTER_Y - 165) + i * 80;x,SCREEN_CENTER_X - 370;horizalign,left;settext, GetDataPack(i, "name") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + params.Floor, "name" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		t[#t+1]= LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .5;Center;y, (SCREEN_CENTER_Y - 150) + i * 80;x,SCREEN_CENTER_X - 370;horizalign,left;settext, GetDataPack(i, "author") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + params.Floor, "author" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .45;Center;y, (SCREEN_CENTER_Y - 135) + i * 80;x,SCREEN_CENTER_X - 370;horizalign,left;settext, GetDataPack(i, "url") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + params.Floor, "url" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .5;Center;y, (SCREEN_CENTER_Y - 115) + i * 80;x,SCREEN_CENTER_X - 370;horizalign,left;settext, GetDataPack(i, "dir") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i, "dir"));
				self:linear(.7):diffusealpha(1);
			end;
		};

		t[#t+1] =Def.Banner {
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom,.2;Center;y, (SCREEN_CENTER_Y - 140) + i * 80;x,SCREEN_CENTER_X - 65;visible, GetDataPack(i, "quad");queuecommand, "BannerLoad");
			BannerLoadCommand=function(self)
				self:LoadChannelBanner(GetDataPack(i , "banner"));
			end;
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:LoadChannelBanner(GetDataPack(i + params.Floor, "banner"));
				self:linear(.7):diffusealpha(GetDataPack(i + params.Floor, "quad"));
			end;
		};
	end;
	
	if ( vChannels[i+4] ~= nil) then
	
		t[#t+1] = Def.Quad
		{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(Center;y,(SCREEN_CENTER_Y - 140) + i * 80;x,SCREEN_CENTER_X +200;zoomto,360,75;diffuse,color(".2,.2,.2,1");diffusealpha, GetDataPack(i, "quad"));
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				if (vChannels[i + 4 + params.Floor] ~= nil) then
					self:linear(.3):diffusealpha(1);
				end;
			end;
		};
		t[#t+1] =Def.Banner {
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom,.2;Center;y, (SCREEN_CENTER_Y - 140) + i * 80;x,SCREEN_CENTER_X + 335;visible, GetDataPack(i, "quad");queuecommand, "BannerLoad");
			BannerLoadCommand=function(self)
				self:LoadChannelBanner(GetDataPack(i + 4, "banner"));
			end;
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:LoadChannelBanner(GetDataPack(i + 4 + params.Floor, "banner"));
				self:linear(.7):diffusealpha(GetDataPack(i + 4 + params.Floor, "quad"));
				
			end;
		};
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .6;Center;y, (SCREEN_CENTER_Y - 165) + i * 80;x,SCREEN_CENTER_X +30 ;horizalign,left;settext, GetDataPack(i + 4, "name") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + 4 + params.Floor, "name" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .5;Center;y, (SCREEN_CENTER_Y - 150) + i * 80;x,SCREEN_CENTER_X +30 ;horizalign,left;settext, GetDataPack(i + 4, "author")  );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + 4 + params.Floor, "author" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .45;Center;y, (SCREEN_CENTER_Y - 135) + i * 80;x,SCREEN_CENTER_X +30 ;horizalign,left;settext, GetDataPack(i + 4, "url")  );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i + 4 + params.Floor, "url" ));
				self:linear(.7):diffusealpha(1);
			end;
		};
		
		t[#t+1] = LoadFont("Common normal")..{
			PanelPackerMessageCommand=cmd(visible,false);
			PanelPackListMessageCommand=cmd(visible,true);
			InitCommand=cmd(zoom, .5;Center;y, (SCREEN_CENTER_Y - 115) + i * 80;x,SCREEN_CENTER_X +30;horizalign,left;settext, GetDataPack(i, "dir") );
			RetrieveListMessageCommand=function(self, params)
				self:finishtweening():diffusealpha(0);
				self:settext(GetDataPack(i, "dir"));
				self:linear(.7):diffusealpha(1);
			end;
		};


	end;
	
	
end;



t[#t+1] =  Def.ActorFrame
{
	InitCommand=cmd(visible,false);
	PanelPackerMessageCommand=cmd(visible,true);
	PanelPackListMessageCommand=cmd(visible,false);
	
	Def.Quad
	{
		InitCommand=cmd(Center;y,SCREEN_CENTER_Y+65;x,SCREEN_CENTER_X;zoomto,500,340;diffuse,color(".1,.1,.2,1"));
	};
	
	LoadFont("Common normal")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-80;settext,"Group Folder");
	};
	
	Def.Quad
	{
		InitCommand=cmd(Center;y,SCREEN_CENTER_Y-38;x,SCREEN_CENTER_X;zoomto,350,25;diffuse,color(".7,.7,.7,1"));
	};
	
	LoadFont("Common normal")..{
		InitCommand=cmd(zoom,.8;x,SCREEN_CENTER_X;horizalign,center;y,SCREEN_CENTER_Y-39;diffuse,color("0,0,0,1"));
		ChangeGroupMessageCommand=function(self, params)
			self:settext(params.Group);
		end;
	};
	
	LoadActor(THEME:GetPathG("","SSM-FULLARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 0;Center;x,SCREEN_CENTER_X-190;y,SCREEN_CENTER_Y-38;zoom,.7);
		ChangeGroupMessageCommand=function(self, params)
			if (params.Move == 0) then
				self:finishtweening():linear(.1):x(SCREEN_CENTER_X-200):linear(.1):x(SCREEN_CENTER_X-190);
			end;
		end;
	};
	
	LoadActor(THEME:GetPathG("","SSM-FULLARROWS"))..{
		InitCommand=cmd(animate, false;setstate,1;Center;x,SCREEN_CENTER_X+190;y,SCREEN_CENTER_Y-38;zoom,.7);
		ChangeGroupMessageCommand=function(self, params)
			if (params.Move == 1) then
				self:finishtweening():linear(.1):x(SCREEN_CENTER_X+200):linear(.1):x(SCREEN_CENTER_X+190);
			end;
		end;
	};
	
	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 0;Center;y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  - 370);
	};

	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  - 310;settext,"Previous";zoom,.7);
	};

	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 1;Center;y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  + 370);
	};

	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+245;x, SCREEN_CENTER_X  + 320;settext,"Next";zoom,.7);
	};
	
	
	Def.Quad
	{
		InitCommand=cmd(Center;y,SCREEN_CENTER_Y+110;x,SCREEN_CENTER_X;zoomto,400,220;diffuse,color(".03,.03,.03,1"));
	};
	
	
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+20;x, SCREEN_CENTER_X-180;horizalign,left;settext,"PACK NAME:";zoom,.7;diffuse,color("0,1,.7,1")); -- ;shadowlength,1;shadowcolor,color("#FFFBFB")
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+60;x, SCREEN_CENTER_X-180;horizalign,left;settext,"AUTHOR:";zoom,.7;diffuse,color("0,1,.7,1"));
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+100;x, SCREEN_CENTER_X-180;horizalign,left;settext,"URL:";zoom,.7;diffuse,color("0,1,.7,1"));
	};
	
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+140;x, SCREEN_CENTER_X-180;horizalign,left;settext,"DESCRIPTION CHANNEL:";zoom,.7;diffuse,color("0,1,.7,1"));
	};
	
	
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+37;x, SCREEN_CENTER_X-170;horizalign,left;settext,"Unknown";zoom,.65); -- ;shadowlength,1;shadowcolor,color("#FFFBFB")
		RetrievePackMessageCommand=function(self, params)
			self:settext(params.Name);
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+77;x, SCREEN_CENTER_X-170;horizalign,left;settext,"Unknown";zoom,.65);
		RetrievePackMessageCommand=function(self, params)
			self:settext(params.Author);
		end;
	};
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+117;x, SCREEN_CENTER_X-170;horizalign,left;settext,"Unknown";zoom,.65);
		RetrievePackMessageCommand=function(self, params)
			self:settext(params.Url);
		end;
	};
	
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+155;x, SCREEN_CENTER_X-170;horizalign,left;settext,"Unknown";zoom,.65);
		RetrievePackMessageCommand=function(self, params)
		
			local text = params.Description;
			if (string.len(text) > 30) then
				text = string.sub(text, 1, 30) .. "...";
			elseif (string.len(text) == 0) then
				text = "Not available"
			end;
			self:settext(text);
		end;
	};
	
		
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+190;x, SCREEN_CENTER_X+10;settext,"Confirm";zoom,.7);
	};
	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 4;Center;y,SCREEN_CENTER_Y+190;x, SCREEN_CENTER_X-50);
	};
	

};

t[#t+1] =  Def.ActorFrame
{
	InitCommand=cmd(visible, false);
	PackerPromptMessageCommand=cmd(visible,true);
	PackConfirmMessageCommand=cmd(visible,true);
	PanelPackListMessageCommand=cmd(visible,false);
	PanelPackerMessageCommand=cmd(visible,false);
	
	LoadActor(THEME:GetPathG("","TE-PROMPT"))..{
		InitCommand=cmd(animate, false;Center;y,SCREEN_CENTER_Y+70;x, SCREEN_CENTER_X);
		PackerPromptMessageCommand=function(self, params)
			if (params.Keep) then
				self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1);
			else
				self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1):sleep(2):linear(.1):diffusealpha(0);
			end;
		end;
		PackConfirmMessageCommand=function(self)
			self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1);
		end;
	};
	
	LoadFont("Common normal")..{
		InitCommand=cmd(y,SCREEN_CENTER_Y+50;x, SCREEN_CENTER_X;settext,"Confirm";zoom,.9);
		PackerPromptMessageCommand=function(self, params)
			self:settext(params.Message);
			if (params.Keep) then
				self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1);
			else
				self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1):sleep(2):linear(.1):diffusealpha(0);
			end;
		end;
		
		PackConfirmMessageCommand=function(self)
			self:settext("Press Center to Confirm Packing.");
			self:diffusealpha(1);
		end;
	};
	
	LoadActor(THEME:GetPathG("","GAME-ARROWS"))..{
		InitCommand=cmd(animate, false;setstate, 4;Center;y,SCREEN_CENTER_Y+110;x, SCREEN_CENTER_X);
		PackerPromptMessageCommand=function(self, params)
			self:finishtweening():diffusealpha(0);
		end;
		PackConfirmMessageCommand=function(self)
			self:finishtweening():diffusealpha(0):linear(.1):diffusealpha(1);
		end;
	};
	
}



return t;