local t =  Def.ActorFrame
{
	Def.Banner{
		OnCommand=cmd(finishtweening;diffusealpha,0);
		InitCommand=cmd(zbuffer,true);
		SelectChannelMessageCommand=cmd(finishtweening;diffusealpha,1);
		ChannelChosenMessageCommand=cmd(finishtweening;sleep,.1;diffusealpha,0);
		SetMessageCommand=function(self,params)
			local song = params.Song;
			local path = song:GetBannerPath();
			self:Load(path);
			self:zoom(1.1);
			if not string.find(path, "Themes/") then
				local img_h = self:GetHeight();
				local img_w = self:GetWidth();
				
				if img_w == 372 and img_h == 214 then -- banner cropped
					self:setsize(372,214);
				elseif img_w == 340 and img_h == 340 then	-- trs related
					self:setsize(374,374);
				elseif img_w == 500 and img_h == 500 then	-- common
					self:setsize(400,400);
				elseif img_w == 512 and img_h == 512 then	-- common
					self:setsize(400,400);	
				elseif img_w == 1024 and img_h == 1024 then	-- common
					self:setsize(400,400);	
				else
					self:setsize(440,280);
				end;
				self:zoom(1);
			end
		end;
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0)
	};

};

return t;
