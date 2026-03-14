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
Player1ModIcons_X = SCREEN_CENTER_X-606
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
SongInfoStrip_YSongChosen = -258

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
DifficultyListOrbs_Y = SCREEN_CENTER_Y+40

--DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y+128; --original
DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y-80

--DifficultyListOrbs_SongChosenTransition1 = 0.065 --original
DifficultyListOrbs_SongChosenTransition1 = 0.25
--DifficultyListOrbs_SongChosenTransition2 = 0.065 --original
DifficultyListOrbs_SongChosenTransition2 = 0.125

--DifficultyListBackArtAssets_Y = SCREEN_CENTER_Y*1.37 --original
DifficultyListBackArtAssets_Y = SCREEN_CENTER_Y+40
DifficultyListBackArtAssets_ZoomY = 0.75
DifficultyListBackArtAssets_YSongChosen = SCREEN_CENTER_Y-80
DifficultyListBackArtAssets_ZoomYSongChosen = 1.25

-- FLOATING CATEGORY AND CHANNEL LABELS

--FloatingLabels_Visibility = true --original
FloatingLabels_Visibility = false