-- -- -- 01 - LEVERS

-- -- SCREEN SELECT MUSIC

-- PROFILE OVERLAY

--ProfileBase_Y = 32 --original
ProfileBase_Y = 32+546
--Scorazones_Y = 65 --original
Scorazones_Y = 65+546
--ProfileEditorText_Y = SCREEN_CENTER_Y-268 --original
ProfileEditorText_Y = SCREEN_CENTER_Y-268+546+83
--ChangeProfile_Y = SCREEN_CENTER_Y-320 --original
ChangeProfile_Y = SCREEN_CENTER_Y-320+546+83
--AvatarPic_Y = 32 --original
AvatarPic_Y = 32+546

-- PLAYER MOD ICONS

--Player1ModIcons_X = SCREEN_CENTER_X-608 --original
Player1ModIcons_X = SCREEN_CENTER_X-604
--Player2ModIcons_X = SCREEN_CENTER_X+610 --original
Player2ModIcons_X = SCREEN_CENTER_X+604
--PlayerModIcons_Y = SCREEN_CENTER_Y-257 --original
PlayerModIcons_Y = SCREEN_CENTER_Y-376+338

-- FUNCTION KEYS HELPER INFORMATION

--FunctionKeysSearch_Y = SCREEN_CENTER_Y+347 --original
FunctionKeysSearch_Y = SCREEN_CENTER_Y-350

-- SONG INFORMATION STRIP

--SongInfoStrip_Y = 0 --original
SongInfoStrip_Y = -320

--SongInfoStrip_YSongChosen = 0 --original
SongInfoStrip_YSongChosen = -278

SongInfoStrip_Zoom = 1
SongInfoStrip_ZoomSongChosen = 1.5

-- SONG INDEX COUNTER

--SongIndexCounter_Y = 106 --original
SongIndexCounter_Y = -243

-- MUSIC WHEEL

-- Y position is done through metrics.ini ([ScreenSelectMusic] > MusicWheelY)
-- original is: SCREEN_CENTER_Y*1.68
-- modified is: SCREEN_CENTER_Y-84

-- YELLOW ARROW TO THE LEFT OF THE MUSIC WHEEL

--YellowArrows_Y = SCREEN_CENTER_Y*1.66; --original
YellowArrows_YLeftArrow = SCREEN_CENTER_Y-130
YellowArrows_YRightArrow = SCREEN_CENTER_Y-130-5

-- FAVORITE SONG ICON

--FavoriteIcon_Y = -40 --original
FavoriteIcon_Y = -354

--FavoriteIcon_YSongChosen = -40 --original
FavoriteIcon_YSongChosen = -354

-- DIFFICULTY LIST

--DifficultyListOrbs_Y = SCREEN_CENTER_Y+124; --original
DifficultyListOrbs_Y = SCREEN_CENTER_Y+46

--DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y+128; --original
DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y-80

--DifficultyListOrbs_SongChosenTransition1 = 0.065 --original
DifficultyListOrbs_SongChosenTransition1 = 0.25
--DifficultyListOrbs_SongChosenTransition2 = 0.065 --original
DifficultyListOrbs_SongChosenTransition2 = 0.125

--DifficultyListBackArtAssets_Y = SCREEN_CENTER_Y*1.37 --original
DifficultyListBackArtAssets_Y = DifficultyListOrbs_Y
DifficultyListBackArtAssets_ZoomY = 0.75
DifficultyListBackArtAssets_YSongChosen = DifficultyListOrbs_YSongChosen
DifficultyListBackArtAssets_ZoomYSongChosen = 1.25

-- FLOATING CATEGORY AND CHANNEL LABELS

--FloatingLabels_Visibility = true --original
FloatingLabels_Visibility = false


-- -- SCREEN SELECT MUSIC - SONG CHOSEN (CHART DETAILS)

-- CHART DETAIL LABELS

--DifficultyDetails_Y = -70 --original
DifficultyDetails_Y = -90
--DifficultyDetails_XPlayer1 = -568 --original
DifficultyDetails_XPlayer1 = -400
--DifficultyDetails_XPlayer2 = 556 --original
DifficultyDetails_XPlayer2 = 400

-- WHITE ARROWS

--ChartSelectArrows_Y = 225 --original
ChartSelectArrows_Y = -16
--ChartSelectArrows_XLeftArrowP1 = -335 --original
ChartSelectArrows_XLeftArrowP1 = -576
--ChartSelectArrows_XRightArrowP1 = -115 --original
ChartSelectArrows_XRightArrowP1 = -225
--ChartSelectArrows_XLeftArrowP2 = 115 --original
ChartSelectArrows_XLeftArrowP2 = -ChartSelectArrows_XRightArrowP1
--ChartSelectArrows_XRightArrowP2 = 335 --original
ChartSelectArrows_XRightArrowP2 = -ChartSelectArrows_XLeftArrowP1

-- RECORDS GRID (MY BEST AND MACHINE BEST)
--RecordsGrid_Y1 = 175 --original: MY BEST (Grade letter)
RecordsGrid_Y1 = 175-52
--RecordsGrid_Y2 = 142 --original: MY BEST (Grade commentary)
RecordsGrid_Y2 = 142-52
--RecordsGrid_Y3 = 172 --original: MY BEST (Numerical score)
RecordsGrid_Y3 = 172-52
--RecordsGrid_Y4 = 249 --original: MACHINE BEST (User name)
RecordsGrid_Y4 = 249-52
--RecordsGrid_Y5 = 262 --original: MACHINE BEST (Numerical score)
RecordsGrid_Y5 = 262-52
--RecordsGrid_Y6 = 218 --original: MACHINE BEST (Grade commentary)
RecordsGrid_Y6 = 218-52
--RecordsGrid_Y7 = 252 --original: MACHINE BEST (Grade letter)
RecordsGrid_Y7 = 252-52
RecordsGrid_Y8 = (SCREEN_CENTER_Y+90)-52
RecordsGrid_Y9 = (SCREEN_CENTER_Y-140)-52
RecordsGrid_YA = (SCREEN_CENTER_Y+125)-52

-- -- SCREEN MECKX STAGE INFORMATION

-- CHART DETAIL LABELS

LoadingDifficultyDetails_YAnchor = -150
LoadingDifficultyDetails_XPlayer1 = -400
LoadingDifficultyDetails_XPlayer2 = 400




-- -- -- 02 - FUNCTIONS
-- inputs:
-- 1) a chart object
-- 2) a string detailing what you want, from this list:
-- "Chart Original Name", "Chart Origin",
-- "Chart Author", "Chart Level"
-- returns:
-- check below
function Meckx_FetchFromChart(input_chart, fetch_details)

	local output = ""

	if fetch_details == "Chart Original Name" then
		-- returns a string such as "NORMAL ii"

		local chartFullChartnameFromSSC = input_chart:GetChartName()
		local openParen = chartFullChartnameFromSSC:find("%(")
		output = chartFullChartnameFromSSC:sub(1, openParen - 2)

	elseif fetch_details == "Chart Origin" then
		-- returns a string such as "The 2nd DF"

		local chartFullChartnameFromSSC = input_chart:GetChartName()
		local openParen = chartFullChartnameFromSSC:find("%(")
		local closeParen = chartFullChartnameFromSSC:find("%)")
		output = chartFullChartnameFromSSC:sub(openParen + 1, closeParen - 1)

	elseif fetch_details == "Chart Author" then
		-- returns a string such as "Andamiro"

		if (input_chart:GetAuthorCredit() == "") then output = "Author is blank"
		else output = input_chart:GetAuthorCredit() end

	elseif fetch_details == "Chart Level" then
		-- returns a string such as "16"

		if input_chart:GetMeter() == 99 then output = "??"
		else output = string.format("%02d", input_chart:GetMeter()) end

	end

	return output

end

-- BRAINSTORMING
--
-- AFTER PROFILE SELECT, SCREENSELECTGAMEMODE
--
-- 01 - PIU HISTORIA MODE
--				1 OR 2 PLAYERS
--				SINGLES, HALF-DOUBLES, DOUBLES [OK]
--				CO-OP CHARTS FILTERED OUT [X]
--				PLAYERS CAN SELECT DIFFERENT PLAYLISTS - THE CHARTS AVAILABLE TO PLAY IN ANY GIVEN OLD OFFICIAL VERSION
--				WHAT HAPPENS WHEN PRESS 7 OR 9?
--					DEFAULT: THE FOLLOWING DOUBLE-WHEEL SYSTEM
--						WHEEL 1 - PLAYLISTS
--							1ST
--							2ND
--							3RD
--							(...)
--						WHEEL 2 - FILTERS
--							FULL DISPLAY MODE
--							SHOW REMIX ONLY
--							SHOW FULL SONG ONLY
--							SHOW SHORT CUT ONLY
--							SINGLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							SINGLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							HALF-DOUBLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							HALF-DOUBLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							DOUBLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							DOUBLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							SURVIVAL MODE
--
-- 02 - HALLYU MODE
--				1 OR 2 PLAYERS
--				SINGLES, HALF-DOUBLES, DOUBLES [OK]
--				CO-OP CHARTS FILTERED OUT [X]
--				ONE UNIQUE PLAYLIST, MADE OF K-POP ONLY, BOTH FROM ANDAMIRO AND FROM FANS
--				WHAT HAPPENS WHEN PRESS 7 OR 9?
--					THE FOLLOWING SINGLE-WHEEL SYSTEM
--						WHEEL 1 - FILTERS
--							ORDER ALL SONGS BY YEAR > ARTIST
--							ORDER ALL SONGS BY ARTIST > YEAR
--							SINGLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							SINGLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							HALF-DOUBLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							HALF-DOUBLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							DOUBLE LV. 01 - make sure the first element is a "PICK ONE AT RANDOM"
--							DOUBLE LV. 02 - make sure the first element is a "PICK ONE AT RANDOM"
--							(...)
--							SURVIVAL MODE
--
-- 03 - CO-OP MODE
--				1 PLAYER ONLY (DON'T SELECT A PROFILE AND ALWAYS USE GUEST)
--				CO-OP CHARTS [OK], BOTH FROM ANDAMIRO AND FROM FANS/UCS
--				SINGLES, HALF-DOUBLES, DOUBLES FILTERED OUT [X]
--				WHAT HAPPENS WHEN PRESS 7 OR 9?
--					THE FOLLOWING SINGLE-WHEEL SYSTEM
--						WHEEL 1 - FILTERS
--							SHOW CO-OP 2P ONLY
--							SHOW CO-OP 3P ONLY
--							SHOW CO-OP 4P ONLY
--
--
-- BRAINSTORM REGARDING SCORE
-- PERCENT + GRADE
-- PERCENT IS JUST PERCENT
-- GRADE IS 0-4 STARS
-- 4 STARS = "PERFECT GAME"
--				MISS+BAD+GOOD+GREAT = 0
--				COLOR OF PERFECT (BLUE PLATINUM)
-- 3+ STARS = "FULL COMBO +"
--				MISS+BAD+GOOD = 0
--				&
--				GREAT < 10
--				COLOR OF GREAT (GREEN)
-- 3 STARS = "FULL COMBO"
--				MISS+BAD+GOOD = 0
--				&
--				GREAT > 9
--				COLOR OF GREAT (GREEN)
-- 2+ STARS = "NO MISS +"
--				MISS = 0
--				&
--				BAD+GOOD < 10
--				COLOR OF GOOD (YELLOW)
-- 2 STARS = "NO MISS"
--				MISS = 0
--				&
--				BAD+GOOD > 9
--				COLOR OF GOOD (YELLOW)
-- 1 STARS = "SINGLE DIGIT FAILS"
--				MISS > 0
--				&
--				MISS+BAD+GOOD < 10
--				COLOR OF BAD (PURPLE)
-- 0 STARS = ANYTHING ELSE
--				MISS > 0
--				&
--				MISS+BAD+GOOD > 9
--				COLOR OF MISS (RED)