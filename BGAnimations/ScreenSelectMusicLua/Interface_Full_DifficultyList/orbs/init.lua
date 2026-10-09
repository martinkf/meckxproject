local t = Def.ActorFrame{};
--base list.
t[#t+1] = LoadActor("0_difficulty_list")..{
	OnCommand=function(self)
		self:y(SCREEN_CENTER_Y+124);

		if isAspectRatio1610() then
			self:y(SCREEN_CENTER_Y+138);
		end;

		if isAspectRatio43() then
			self:y(SCREEN_CENTER_Y+166);
		end;		

		self:x(SCREEN_CENTER_X);
		self:zoom(0.55);
	end;

	SongChosenMessageCommand=function(self)
		self:stoptweening();


		if isAspectRatio43() then
			self:y(SCREEN_CENTER_Y+141);
			self:linear(0.065);
			self:zoom(0.7);
			self:y(SCREEN_CENTER_Y+145);
		else
			self:y(SCREEN_CENTER_Y+124);
			self:linear(0.065);
			self:zoom(0.7);
			self:y(SCREEN_CENTER_Y+128);
		end;	

	end;
	SongUnchosenMessageCommand=function(self)
		self:stoptweening();
		self:y(SCREEN_CENTER_Y+128);
		self:linear(0.065);

		if isAspectRatio1610() then
			self:y(SCREEN_CENTER_Y+138);
		elseif isAspectRatio43() then
			self:y(SCREEN_CENTER_Y+166);
		else
			self:y(SCREEN_CENTER_Y+124);
		end;

	
		self:zoom(0.55);
	end;
	OffCommand=function(self)
		self:linear(0.07);
		self:diffusealpha(0);

	end;
};

t[#t+1] = LoadActor("01_difficulty_detail")..{

	OnCommand=function(self)
		self:y(SCREEN_CENTER_Y+70);
		self:x(SCREEN_CENTER_X);
		self:zoom(0.8);

		if isAspectRatio43() then
			self:y(SCREEN_CENTER_Y+125);
		end;
	end;

};

return t;