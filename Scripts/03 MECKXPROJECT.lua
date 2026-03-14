-- SCREEN SELECT MUSIC

-- MUSIC WHEEL

-- Y position is done through metrics.ini ([ScreenSelectMusic] > MusicWheelY)
-- original is: SCREEN_CENTER_Y*1.68
-- modified is: SCREEN_CENTER_Y*1.55

-- YELLOW ARROW TO THE LEFT OF THE MUSIC WHEEL

--YellowArrows_Y = SCREEN_CENTER_Y*1.66; --original
YellowArrows_Y = SCREEN_CENTER_Y*1.55;

-- DIFFICULTY LIST

--DifficultyListOrbs_Y = SCREEN_CENTER_Y+124; --original
DifficultyListOrbs_Y = SCREEN_CENTER_Y+307;

--DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y+128; --original
DifficultyListOrbs_YSongChosen = SCREEN_CENTER_Y-158;

--DifficultyListOrbs_SongChosenTransition1 = 0.065 --original
DifficultyListOrbs_SongChosenTransition1 = 0.25

--DifficultyListOrbs_SongChosenTransition2 = 0.065 --original
DifficultyListOrbs_SongChosenTransition2 = 0.125

--DifficultyListBackArtAssets_Y1 = SCREEN_CENTER_Y*1.37 --original
DifficultyListBackArtAssets_Y1 = SCREEN_CENTER_Y*1.86
--DifficultyListBackArtAssets_Y2 = SCREEN_CENTER_Y*1.35 --original
DifficultyListBackArtAssets_Y2 = SCREEN_CENTER_Y*1.86
--DifficultyListBackArtAssets_SongChosenTransition
-- original is: stoptweening;decelerate,0.2;diffusealpha,0;
-- modified is: stoptweening;linear,0.25;y,SCREEN_CENTER_Y*0.57;zoomy,1.25;
--DifficultyListBackArtAssets_SongUnchosenTransition
-- original is: stoptweening;decelerate,0.2;diffusealpha,1;
-- modified is: stoptweening;linear,0.125;y,SCREEN_CENTER_Y*1.86;zoomy,0.75;

-- SONG INDEX COUNTER

--SongIndexCounter_Y = 106 --original
SongIndexCounter_Y = 35

-- PLAYER MOD ICONS

--Player1ModIcons_X = SCREEN_CENTER_X-608 --original
Player1ModIcons_X = SCREEN_CENTER_X-604
--Player2ModIcons_X = SCREEN_CENTER_X+610 --original
Player2ModIcons_X = SCREEN_CENTER_X+606
--PlayerModIcons_Y = SCREEN_CENTER_Y-257 --original
PlayerModIcons_Y = SCREEN_CENTER_Y-340

-- FLOATING CATEGORY AND CHANNEL LABELS

--FloatingLabels_Visibility = true --original
FloatingLabels_Visibility = false