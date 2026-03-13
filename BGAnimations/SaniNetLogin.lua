--INIT USER PARAMS
local t = Def.ActorFrame{	
	OnCommand=function(self)
		self:addy(30);
		self:visible(false);
	end;

	SaniNetAliveMessageCommand=function(self,params)
		self:visible(params.Alive);
	end;

	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-30;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;diffusealpha,0);	
		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():linear(0.1):diffusealpha(0.9);
			elseif params.Status == 2 then	--success
				self:stoptweening():sleep(0.9):decelerate(0.1):diffusealpha(0);
			elseif params.Status == 3 then	--failed
				-- self:stoptweening():diffuse(color('1,0,0,1'));
			elseif params.Status == 0 then
				self:stoptweening():sleep(0.1):linear(0.2):diffusealpha(0);
			end;
		end;
	};
--[[
	LoadActor( THEME:GetPathG("","SaniNet/login/background_login") )..{
		Name="backgroundImg";
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y);			
			self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT);
			self:diffusealpha(0);
			self:stop();
		end;

		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():play():diffusealpha(0.5);
			elseif params.Status == 2 then	--success
				self:stoptweening():linear(0.2):diffusealpha(0):stop();
			elseif params.Status == 3 then	--failed
				-- self:stoptweening():diffuse(color('1,0,0,1'));
			elseif params.Status == 0 then
				self:stoptweening():linear(0.2):diffusealpha(0):stop();
			end;
		end;

	};
]]

	LoadActor(THEME:GetPathG("","SaniNet/login/loginframe"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y-45;zoomy,0;visible,false);
		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():zoomy(0):accelerate(0.1):zoomy(1);
			elseif params.Status == 2 then	--success
				self:stoptweening():sleep(0.9):decelerate(0.1):zoomy(0);
			elseif params.Status == 3 then	--failed
				-- self:stoptweening():diffuse(color('1,0,0,1'));
			elseif params.Status == 0 then
				self:stoptweening():decelerate(0.1):zoomy(0);
			end;
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/login/logoframe"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X-2,SCREEN_CENTER_Y-120;zoomy,0;visible,false);
		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():zoomy(0):accelerate(0.1):zoomy(1);
			elseif params.Status == 2 then	--success
				self:stoptweening():sleep(0.9):decelerate(0.1):zoomy(0);				
			elseif params.Status == 0 then
				self:stoptweening():decelerate(0.1):zoomy(0);
			end;
		end;
	};

	LoadActor(THEME:GetPathG("","SaniNet/login/info"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X-20,SCREEN_CENTER_Y-35;zoomy,0;visible,false);
		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():zoomy(0):accelerate(0.1):zoomy(1);
			elseif params.Status == 2 then	--success
				self:stoptweening():sleep(0.9):decelerate(0.1):zoomy(0);
			elseif params.Status == 3 then	--failed
				-- self:stoptweening():diffuse(color('1,0,0,1'));
			elseif params.Status == 0 then
				self:stoptweening():decelerate(0.1):zoomy(0);
			end;
		end;
	};	

	LoadFont('_TitleXolonium 30px')..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y - 65;diffusealpha,0;rainbow;effectperiod,5;zoom,0.75);
		SaniNetLoginScreenMessageCommand=function(self, params)
			if params.Status == 1 then
				self:stoptweening():diffusealpha(0):settext(params.Username):sleep(0.1):diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1);
			elseif params.Status == 2 then
				self:stoptweening():diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1):sleep(0.8):diffusealpha(0);
			elseif params.Status == 3 then
				self:stoptweening():diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1):sleep(0.025):diffusealpha(0):sleep(0.025):diffusealpha(1);
			elseif params.Status == 0 then
				self:stoptweening():settext(""):diffusealpha(0);
			end;
		end;
	};


	LoadFont('_TitleXolonium 30px')..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X - 0,SCREEN_CENTER_Y + 60;horizalign,center;vertalign,top;zoom,0.6;diffusealpha,0);
		SaniNetLoginScreenMessageCommand=function(self, params)
			if params.Status == 1 then
				local textLogin = getSaninetTextLang("login-text");
				self:stoptweening():settext(textLogin):diffusealpha(0):sleep(0.1):diffusealpha(1);
			elseif params.Status == 2 then
				local textSuccess = getSaninetTextLang("login-success");
				self:stoptweening():cropright(1):settext(textSuccess):linear(0.2):cropright(0):sleep(0.7):diffusealpha(0);
			elseif params.Status == 3 then
				local textFailed = getSaninetTextLang("login-failed");
				self:stoptweening():cropright(1):settext(textFailed):linear(0.2):cropright(0);
			elseif params.Status == 0 then
				self:stoptweening():diffusealpha(0);
			end;
		end;
	};


	LoadFont('_TitleXolonium 30px')..
	{
		OnCommand=cmd(horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y + 120;diffusealpha,0;zoom,0.4;sleep,0.25;diffusealpha,1;settext,'');
		SaniNetLoginScreenMessageCommand=function(self, params)
			if params.Status == 1 then
				local textBack = getSaninetTextLang("login-exit");
				self:stoptweening():settext(textBack);
				self:diffusealpha(1);
			elseif params.Status == 2 then
				self:stoptweening():sleep(0.9):diffusealpha(0);
			elseif params.Status == 0 then
				self:stoptweening():diffusealpha(0);
			end;
		end;
	};
};

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y + 230);
		self:zoom(0.6);
	end;

	SaniNetLoginScreenMessageCommand=function(self, params)
		self:visible(true);
		if params.Status == 1 then
			self:visible(false);
		elseif params.Status == 2 then	--success
			self:visible(true);
		elseif params.Status == 3 then	--failed
			self:visible(false);
		elseif params.Status == 0 then
			self:visible(true);
		end;
	end;

	LoadActor(THEME:GetPathG("","SaniNet/glow_saninet_info_login"))..
	{
		OnCommand=cmd(visible,false;zoomx,1.1;y,20;blend,"BlendMode_Add");
		SaniNetClientConnectedMessageCommand=function(self, params)
			self:visible(false);
		 end;
		SaniNetAliveMessageCommand=function(self, params)
			self:visible(false);
		end;

		SaniNetLoginScreenMessageCommand=function(self, params)
			-- if params.Status == 1 then
				-- self:settext("Not Logged In");
			if params.Status == 2 then	--success
				self:visible(true);
			elseif params.Status == 3 then	--failed
				self:visible(false);
			elseif params.Status == 0 then
				self:visible(false);
			end;
		end;

		SaniNetErrorMessageMessageCommand=function(self, params)
			if params.Message == 2 then	--success
				self:visible(false);
			end;
		end;

	};

	LoadActor(THEME:GetPathG("","SaniNet/saninet_info_login"))..
	{
		OnCommand=cmd(visible,false;zoomx,1.1;y,20);
		SaniNetClientConnectedMessageCommand=function(self, params)
			self:visible(false);
		 end;
		SaniNetAliveMessageCommand=function(self, params)
			self:visible(false);
		end;

		SaniNetLoginScreenMessageCommand=function(self, params)
			-- if params.Status == 1 then
				-- self:settext("Not Logged In");
			if params.Status == 2 then	--success
				self:visible(true);
			elseif params.Status == 3 then	--failed
				self:visible(false);
			elseif params.Status == 0 then
				self:visible(false);
			end;
		end;

		SaniNetErrorMessageMessageCommand=function(self, params)
			if params.Message == 2 then	--success
				self:visible(false);
			end;
		end;

	};

	LoadActor(THEME:GetPathG("","SaniNet/pre_saninet_info_login"))..
	{
		OnCommand=cmd(visible,false;zoomx,1.1;y,15);
		SaniNetClientConnectedMessageCommand=function(self, params)
			self:visible(true);
		 end;
		SaniNetAliveMessageCommand=function(self, params)
			self:visible(params.Alive);
		end;



		SaniNetLoginScreenMessageCommand=function(self, params)
			-- if params.Status == 1 then
				-- self:settext("Not Logged In");
			if params.Status == 2 then	--success
				self:visible(false);
			elseif params.Status == 3 then	--failed
				self:visible(true);
			elseif params.Status == 0 then
				self:visible(true);
			end;
		end;

		SaniNetErrorMessageMessageCommand=function(self, params)
			if params.Message == 2 then	--success
				self:visible(true);
			end;
		end;

	};

	LoadActor(THEME:GetPathG("","SaniNet/login/logoframe"))..
	{
		OnCommand=cmd(visible,false;y,-70;zoom,0.8);
		SaniNetClientConnectedMessageCommand=function(self, params)
			self:visible(true);
		 end;
		SaniNetAliveMessageCommand=function(self, params)
			self:visible(params.Alive);
		end;
	};

	LoadFont('_TitleXolonium 30px')..
	{
		--OnCommand=cmd(horizalign,center;y,-4;diffusealpha,0;zoom,0.9;sleep,0.25;diffusealpha,1;settext,'');
		OnCommand=function(self)
			self:horizalign(center);
			self:y(-4);
			self:diffusealpha(0);
			self:zoom(0.9);
			self:sleep(0.25);
			self:diffusealpha(1);
			self:settext('');
		end;

		SaniNetAliveMessageCommand=function(self, params)
			if params.Alive then
				local textFooterNoUser = getSaninetTextLang("login-footer-no-user");
				self:settext(textFooterNoUser);
				self:y(12);
				if PREFSMAN:GetPreference('Language') == "es" then
					self:zoom(0.7);
				else
					self:zoom(0.9);
				end;
			end;
		end;
		SaniNetLoginScreenMessageCommand=function(self, params)
			-- if params.Status == 1 then
				-- self:settext("Not Logged In");
			if params.Status == 2 then	--success
				local textFooterConnected = getSaninetTextLang("login-footer-connected");
				self:settext(textFooterConnected..params.Username);
				self:y(18);
				self:zoom(0.9);
			elseif params.Status == 3 then	--failed
				local textFooterFailed = getSaninetTextLang("login-failed");
				self:settext("Login Failed");
				self:y(12);
				self:zoom(0.9);
			elseif params.Status == 0 then
				local textFooterNoUser = getSaninetTextLang("login-footer-no-user");
				self:settext(textFooterNoUser);
				self:y(12);
				if PREFSMAN:GetPreference('Language') == "es" then
					self:zoom(0.7);
				else
					self:zoom(0.9);
				end;
			end;
		end;
		SaniNetErrorMessageMessageCommand=function(self, params)
			if params.Message == 2 then	--success
				local textFooterNoUser = getSaninetTextLang("login-footer-no-user");
				self:settext(textFooterNoUser);
				self:y(12);
				if PREFSMAN:GetPreference('Language') == "es" then
					self:zoom(0.7);
				else
					self:zoom(0.9);
				end;
			end;
		end;
	};
};


local lastPinEnter=0;

for i=0, 3 do
	
	t[#t+1]=LoadActor(THEME:GetPathG("","SaniNet/login/big_pinbase"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X - 170 + 90 * i,SCREEN_CENTER_Y + 15;horizalign,left;diffusealpha,0);
		SaniNetLoginScreenMessageCommand=function(self, params)
			if params.Status == 1 then
				self:stoptweening():diffusealpha(0):sleep(0.1):diffusealpha(1);
			elseif params.Status == 2 then
				self:stoptweening():sleep(0.9):diffusealpha(0);
			elseif params.Status == 0 then
				self:stoptweening():diffusealpha(0);
			end;
		end;
	};
	
	t[#t+1]=LoadActor(THEME:GetPathG("","SaniNet/login/bigcursorglow"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X - 162 + 90 * i,SCREEN_CENTER_Y + 15;horizalign,left;diffusealpha,0;zoom,0.92);
		SaniNetLoginScreenMessageCommand=function(self, params)
			if params.Status == 1 then
				if i == 0 then
					self:stoptweening():diffusealpha(0):sleep(0.08):diffusealpha(1):diffuseshift():effectcolor1(color('1,1,1,0')):effectcolor2(color('1,1,1,0.5')):effectperiod(0.5);
				end;
			elseif params.Status == 2 or params.Status == 3 then
				self:stoptweening():diffusealpha(0);
			elseif params.Status == 0 then
				self:stoptweening():diffusealpha(0);
			end;
		end;
		SaniNetLoginNumPadMessageCommand=function(self, params)
			if params.Position == (i) then
				self:stoptweening():sleep(0.08):diffusealpha(1):diffuseshift():effectcolor1(color('1,1,1,0')):effectcolor2(color('1,1,1,0.5')):effectperiod(0.5);
			else
				self:stoptweening():diffusealpha(0);
			end;
		end;
	};
	
	
	t[#t+1]=LoadActor(THEME:GetPathG("","SaniNet/login/pinicon"))..
	{
		OnCommand=cmd(xy,SCREEN_CENTER_X - 136 + 90 * i,SCREEN_CENTER_Y + 15;zoom,1;diffusealpha,0);
		SaniNetLoginScreenMessageCommand=function(self, params)
			self:visible(true);
			if params.Status == 1 then
				self:stoptweening():diffusealpha(0);
			elseif params.Status == 2 then
				self:stoptweening():diffusealpha(1):sleep(0.9):diffusealpha(0);
			elseif params.Status == 3 then
				self:stoptweening():diffusealpha(1);
			elseif params.Status == 0 then
				self:stoptweening():diffusealpha(0);
			end;
		end;
		SaniNetLoginNumPadMessageCommand=function(self, params)
			if params.Position == (i + 1) then
				self:stoptweening():diffusealpha(1);
			end;
		end;
	};
end;			

return t;