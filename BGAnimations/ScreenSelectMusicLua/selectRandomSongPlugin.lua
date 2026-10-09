--ty VVVVVVVV for the idea on how to do this :P
local t = Def.ActorFrame {}
local bufferSong = nil;

function getRandomSongFromGroup()
	local currentSong = GAMESTATE:GetCurrentSong();
	if currentSong == nil then
	 	return nil;
	end;

	local groupName = currentSong:GetGroupName();
	if groupName == nil or groupName == "" then 
		return nil;
	end;

	local stepsOnGroup = SONGMAN:GetSongsInGroup(groupName) or {};
	if #stepsOnGroup == 0 then
		return nil;
	end;
	return stepsOnGroup[math.random(1, #stepsOnGroup)];
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)

	    SCREENMAN:GetTopScreen():AddInputCallback(function(event)
	        if event.type == "InputEventType_FirstPress" and event.DeviceInput.button == "DeviceButton_right ctrl" then
	     		if GAMESTATE:GetFilterTwo() ~= "FilterTwo_Channel" then return false end;
			    if SCREENMAN:GetTopScreen():GetSelectionState() == "SelectingSong" then
					local tmpB = getRandomSongFromGroup();
					local getChannelName = GAMESTATE:GetChannelName();
					bufferSong = tmpB;
					if tmpB == nil or getChannelName == "ALLTUNES" then
						return;
					end;
					
					local topScreen = SCREENMAN:GetTopScreen();
			    	local musicWheel = topScreen:GetChild("MusicWheel");
			    	musicWheel:SelectSong(tmpB);
			    	SCREENMAN:GetTopScreen():PostScreenMessage("SM_SongChanged", 0);
			    	MESSAGEMAN:Broadcast("NextSong");
			    	MESSAGEMAN:Broadcast("PreviousSong");
				    self:stoptweening();
				    self:sleep(0.1);
					self:queuecommand("reUpdate");
			    end;
	        end
	    end)
	end;

	reUpdateCommand = function(self)
			local songRandomSelected = bufferSong;
			if songRandomSelected == nil then
				return;
			end;
			local topScreen = SCREENMAN:GetTopScreen();
	    	local musicWheel = topScreen:GetChild("MusicWheel");
	    	musicWheel:SelectSong(songRandomSelected);
	    	bufferSong = nil;
	    	self:GetChild("switchSound"):queuecommand("Lot");
	end;

	Def.Sound {	--BGM
		Name="switchSound";
		OnCommand=cmd();
		LotCommand=function(self)
			self:stoptweening();			
			SOUND:PlayOnce(THEME:GetPathS("","MusicWheel change"));
		end;
	};
};

return t;

