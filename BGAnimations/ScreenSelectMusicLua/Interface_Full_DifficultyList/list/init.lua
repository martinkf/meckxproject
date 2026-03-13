local t = Def.ActorFrame{};
t[#t+1] = LoadActor("2_LvList");
t[#t+1] = LoadActor("0_SimpleDiffList")..{
	OnCommand=function(self)
		self:y(7);
	end;

	SongChosenMessageCommand=function(self)
		self:diffusealpha(0);
	end;
	SongUnchosenMessageCommand=function(self)
		self:diffusealpha(1);
	end;
	ChangeChannelMessageCommand=function(self)
		self:diffusealpha(0);
	end;
	SelectChannelMessageCommand=function(self)
		self:diffusealpha(1);
	end;
	ChannelChosenMessageCommand=function(self)
		self:diffusealpha(1);
	end;

};
t[#t+1] = LoadActor("1_DifficultDetail");

return t;