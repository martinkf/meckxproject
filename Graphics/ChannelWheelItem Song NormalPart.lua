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
				else
					--anything outside 512 <-> and 512 | will be pushed back to 400x400. 
					if img_w >= 500 or img_h >=500 then
						self:setsize(400,400);
					else
						self:setsize(img_w,img_h);
					end;
				end;
				self:zoom(1);
			else
				self:setsize(self:GetWidth(),self:GetHeight());
				self:zoom(1);
			end
		end;
		FinalizedMessageCommand=cmd(finishtweening;diffusealpha,0)
	};

};

return t;
