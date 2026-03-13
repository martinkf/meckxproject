--Player timing data
--we will use ENV vars to save this data, this need to be dispose on screen select music, before entering to another song :)
--restart env
GAMESTATE:Env()["timingP1"] = {};
GAMESTATE:Env()["timingP2"] = {};

local timingPlayer1={};
local timingPlayer2={};




local extraJudgment = GAMESTATE:GetExtraJudgment();
local TNSframe = {
		TapNoteScore_CheckpointHit = 0;
		TapNoteScore_W1 = 0;
		TapNoteScore_W2 = 0;
		TapNoteScore_W3 = 2;
		TapNoteScore_W4 = 3;
		TapNoteScore_W5 = 4;
		TapNoteScore_Miss = 5;
		TapNoteScore_CheckpointMiss = 5;
}

local TNSName = {
		TapNoteScore_CheckpointHit = "perfect";
		TapNoteScore_W1 = "perfect";
		TapNoteScore_W2 = "perfect";
		TapNoteScore_W3 = "great";
		TapNoteScore_W4 = "good";
		TapNoteScore_W5 = "bad";
		TapNoteScore_Miss = "miss";
		TapNoteScore_CheckpointMiss = "miss";
}

--frames para RG
local TNSframeReversed = {
		TapNoteScore_CheckpointHit = 5;
		TapNoteScore_W1 = 5;
		TapNoteScore_W2 = 5;
		TapNoteScore_W3 = 3;
		TapNoteScore_W4 = 2;
		TapNoteScore_W5 = 1;
		TapNoteScore_Miss = 0;
		TapNoteScore_CheckpointMiss = 0;
}

if extraJudgment then
	--frame correspondiente de cada judgment
	TNSframe = {
		TapNoteScore_CheckpointHit = 0;
		TapNoteScore_W1 = 0;
		TapNoteScore_W2 = 1;
		TapNoteScore_W3 = 2;
		TapNoteScore_W4 = 3;
		TapNoteScore_W5 = 4;
		TapNoteScore_Miss = 5;
		TapNoteScore_CheckpointMiss = 5;
	}

	--frames para RG
	TNSframeReversed = {
		TapNoteScore_CheckpointHit = 5;
		TapNoteScore_W1 = 5;
		TapNoteScore_W2 = 4;
		TapNoteScore_W3 = 3;
		TapNoteScore_W4 = 2;
		TapNoteScore_W5 = 1;
		TapNoteScore_Miss = 0;
		TapNoteScore_CheckpointMiss = 0;
	}
end;




local t = Def.ActorFrame
{
	JudgmentMessageCommand=function(self,param)
		local noteOffset = -1;
		local isEarly = 0;		
		local iTns = TNSframe[param.TapNoteScore];
		local tnsName = TNSName[param.TapNoteScore];
		local tnsRaw = TapNoteScore;
		local track = -1;
		local totalNotesInRow=0;
		local totalHoldHeadInRow=0;
		local isHoldNote=0;

		if param.TapNoteScore == "TapNoteScore_CheckpointHit" or param.TapNoteScore == "TapNoteScore_CheckpointMiss" then
			isHoldNote = 1;
		end;
		
		if GAMESTATE:GetPlayerState(param.Player):GetPlayerOptions('ModsLevel_Current'):JudgeReverse() then
			iTns = TNSframeReversed[param.TapNoteScore]
		end

		noteOffset = param.TapNoteOffset and math.floor(param.TapNoteOffset * 1000 + 0.5) or nil;
		--[[
		Trace("Judg--");
		Trace("Tns: "..tnsName);
		Trace("Real OffsetNote: "..param.TapNoteOffset);
		Trace("OffsetNote: "..noteOffset);
		]]


		if iTns > 0 and iTns < 5 then
			if param.Early then
				isEarly = 1;
			end;
		end;

		track = param.FirstTrack;
		totalNotesInRow = param.Notes;
		totalHoldHeadInRow = param.Holds;


		--Time of action
	    local sp = GAMESTATE:GetPlayerState(param.Player):GetSongPosition();
	    local sec  = math.max(0, sp:GetMusicSeconds());
	    local ms   = math.floor(sec * 1000 + 0.5);
	    --Beat
	    local beat = sp:GetSongBeat()

		if param.Player == PLAYER_1 then
		    table.insert(timingPlayer1, {
		      songPosition	= sp:GetMusicSeconds(),
		      msSongPosition = ms,
		      beat      = beat,            -- posición exacta en beats
		      col       = track,             
		      tns       = iTns, 			-- 0,1,2,3,4,5
		      tns_raw   = tnsRaw,
		      tns_name	= tnsName,
		      offset_ms = noteOffset,        -- timing (+late / -early)
		      isHoldNote = isHoldNote,
		      isEarly	= isEarly
		    });	
		    GAMESTATE:Env()["timingP1"] = timingPlayer1;
		else
		    table.insert(timingPlayer2, {
		      songPosition	= sp:GetMusicSeconds(),
		      msSongPosition = ms,
		      beat      = beat,            -- posición exacta en beats
		      col       = track,             
		      tns       = iTns, 			-- 0,1,2,3,4,5
		      tns_name	= tnsName,
		      tns_raw   = tnsRaw,
		      offset_ms = noteOffset,        -- timing (+late / -early)
		      isHoldNote = isHoldNote,
		      isEarly	= isEarly
		    });		
			--save on array for player 2
			GAMESTATE:Env()["timingP2"] = timingPlayer2;
		end;

	end;
};

return t;