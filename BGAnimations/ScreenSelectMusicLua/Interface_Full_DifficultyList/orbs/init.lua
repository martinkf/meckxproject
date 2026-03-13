local t = Def.ActorFrame{};
--base list.
t[#t+1] = LoadActor("0_difficulty_list")..{
	OnCommand=function(self)
		self:y(DifficultyListOrbs_Y);

		if isAspectRatio1610() then
			self:y(SCREEN_CENTER_Y+138);
		end;

		self:x(SCREEN_CENTER_X);
		self:zoom(0.55);
	end;

	SongChosenMessageCommand=function(self)
		self:stoptweening();
		self:y(DifficultyListOrbs_Y);
		self:linear(DifficultyListOrbs_SongChosenTransition1);
		self:zoom(0.7);
		self:y(DifficultyListOrbs_YSongChosen);
	end;
	SongUnchosenMessageCommand=function(self)
		self:stoptweening();
		self:y(DifficultyListOrbs_YSongChosen);
		self:linear(DifficultyListOrbs_SongChosenTransition2);

		if isAspectRatio1610() then
			self:y(SCREEN_CENTER_Y+138);
		else
			self:y(DifficultyListOrbs_Y);
		end;

	
		self:zoom(0.55);
	end;
};

t[#t+1] = LoadActor("01_difficulty_detail")..{

	OnCommand=function(self)
		self:y(SCREEN_CENTER_Y+70);
		self:x(SCREEN_CENTER_X);
		self:zoom(0.8);
	end;

};

return t;