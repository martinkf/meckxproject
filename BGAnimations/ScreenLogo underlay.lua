local t = Def.ActorFrame
{
	OnCommand=function(self)
		if GAMESTATE:GetCoins() > 0 then SCREENMAN:SetNewScreen("ScreenTitleMenu") end;
	end;
	CoinInsertedMessageCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenTitleMenu")
	end;
};

return t;