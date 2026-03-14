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
SongInfoStrip_Y = -294

--SongInfoStrip_YSongChosen = 0 --original
SongInfoStrip_YSongChosen = -278

SongInfoStrip_Zoom = 1
SongInfoStrip_ZoomSongChosen = 1.5

-- SONG INDEX COUNTER

--SongIndexCounter_Y = 106 --original
SongIndexCounter_Y = -252

-- MUSIC WHEEL

-- Y position is done through metrics.ini ([ScreenSelectMusic] > MusicWheelY)
-- original is: SCREEN_CENTER_Y*1.68
-- modified is: SCREEN_CENTER_Y-84

-- YELLOW ARROW TO THE LEFT OF THE MUSIC WHEEL

--YellowArrows_Y = SCREEN_CENTER_Y*1.66; --original
YellowArrows_Y = SCREEN_CENTER_Y-130

-- FAVORITE SONG ICON

--FavoriteIcon_Y = -40 --original
FavoriteIcon_Y = -334

--FavoriteIcon_YSongChosen = -40 --original
FavoriteIcon_YSongChosen = -334

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

--DifficultyDetails_Y = -70 --original
DifficultyDetails_Y = -90
--DifficultyDetails_XPlayer1 = -568 --original
DifficultyDetails_XPlayer1 = -400
--DifficultyDetails_XPlayer2 = 556 --original
DifficultyDetails_XPlayer2 = 400


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