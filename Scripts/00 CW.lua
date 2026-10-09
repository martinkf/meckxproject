-- JNC - all
--ACTIVAR MODS 
mBGADARK = true;
mSortMod = true;
mCustomLabel = true;

--WriteGamePrefToFile("DBG", nxtstg );

local cwMainDescription = {

	["EN-speed"] = 		"Change the note speed";			--1
	["EN-display"] = 	"Change Game Screen display";		--2
	["EN-note skin"] = 	"Change note Skin";					--3
	["EN-path"] = 		"Change the note movement";		--4
	["EN-alternate"] = 	"Change the appearance of Steps";	--5
	["EN-judge"] = 		"Change the Judgement";				--6
	["EN-rush"] = 		"Change the speed of the music";	--7
	["EN-reset"] = 		"Reset all options";				--8
	["EN-rank"] = 		"Rank Mode Settings";				--9
	["EN-sort"] = 		"Set how to sort songs";			--9
	["EN-av"] = 		"Set the speed of auto velocity.";	--9
	["EN-cv"] = 		"Set a constant speed for the song | Removes all speed changes and gimmicks.";	--9
	["EN-info"] = 		"Set the gameplay information.";	--9
	["EN-vsmode"] = 	"1 vs 1 UI | 2 Players only";	--9

	["EN-speed/1X"] = 		"Set note speed to 1x";		
	["EN-speed/2X"] = 		"Set note speed to 2x";
	["EN-speed/3X"] = 		"Set note speed to 3x";
	["EN-speed/4X"] = 		"Set note speed to 4x";
	["EN-speed/5X"] =		"Set note speed to 5x";
	["EN-speed/6X"] =		"Set note speed to 6x";
	["EN-speed/+0.25"] =	"Set note speed to +0.25";
	["EN-speed/+0.5"] =		"Set note speed to +0.5";
	["EN-speed/EW"] =		"Notes move as an earthworm";		
	["EN-speed/RV"] =		"Note speed changes randomly";		
	["EN-speed/AV"] =		"Set the note speed automatically with the song's BPM";
	["EN-speed/AC"] =		"Note speed moves with increasing speed";
	["EN-speed/DC"] =		"Note speed moves with decreasing speed";
	
	--display
	["EN-display/V"] = 					"Notes disappear from the middle of the screen";
	["EN-display/AP"] = 				"Notes appear from the middle of the screen";
	["EN-display/NS"] = 				"Makes notes invisible";
	["EN-display/FD"] = 				"Makes the sequence zone invisible";
	["EN-display/FL"] = 				"Notes will blink as they move";
	["EN-display/RANDOM NOTE"] = 		"Choose a random Note Skin";
	["EN-display/BGA OFF"] = 			"Deactive the song's BGA";
	["EN-display/BGA DARK"] = 			"Darkens the song’s BGA.";
	["EN-display/BGA PARTIAL"] = 		"Darkens only your playfield";
	["EN-display/MI"] =					"Makes notefield zoomed out";
	["EN-display/FOOTGUIDE"] =			"Notes will display the foot pattern";
	--noteskin
	["EN-note skin/GENERICTEXT"] =		"Set ";
	["EN-note skin/FLOWER"] =			"Set Korean Trump Skin";
	["EN-note skin/OLD"] =				"Set Old Skin";
	["EN-note skin/EASY"] =				"Set Easy Skin";
	["EN-note skin/SLIME"] =			"Set Slime Skin";
	["EN-note skin/MUSIC"] =			"Set Music Skin";
	["EN-note skin/CANON"] =			"Set Canon Skin";
	["EN-note skin/NX"] =				"Set NX Skin";
	["EN-note skin/SHEEP"] =			"Set Lamb Skin";
	["EN-note skin/HORSE"] =			"Set Horse Skin";
	["EN-note skin/DOG"] =				"Set Dog Skin";
	["EN-note skin/GIRL"] =				"Set Girl Skin";
	["EN-note skin/FIRE"] =				"Set Fire Skin";
	["EN-note skin/ICE"] =				"Set Ice Skin";
	["EN-note skin/WIND"] =				"Set Wind Skin";
	["EN-note skin/NXA"] =				"Set NXA Skin";
	["EN-note skin/NX2"] =				"Set NX2 Skin";
	["EN-note skin/LIGHTNING"] =		"Set Lightning Skin";
	["EN-note skin/DRUM"] =				"Set Drum Skin";
	["EN-note skin/MISSILE"] =			"Set Missile Skin";
	["EN-note skin/SOCCER"] =			"Set Football Skin";
	["EN-note skin/REBIRTH"] =			"Set Rebirth Skin";
	["EN-note skin/BASIC"] =			"Set Basic mode Skin";
	["EN-note skin/FIESTA"] =			"Set Fiesta Skin";
	["EN-note skin/FIESTA2"] =			"Set Fiesta 2 Skin";	
	["EN-note skin/PRIME2"] =			"Set Prime 2 Skin";	
	["EN-note skin/XX"] =				"Set XX Anniversary Skin";	
	["EN-note skin/INFINITY"] =			"Set Infinity Skin";
	["EN-note skin/INFINITY-RHYTHM"] =	"Set Infinity Rhythm Skin";
	["EN-note skin/PRO-RHYTHM"] =		"Set Pro Rhythm Skin";
	["EN-note skin/PRO2-RHYTHM"] =		"Set Pro 2 Rhythm Skin";
	["EN-note skin/DEFAULT"] =			"Set Prime Skin";	
	
	--path
	["EN-path/X"] =			"Note moves diagonally";
	["EN-path/NX"] =		"Notes move in a different perspective";
	["EN-path/UA"] =		"Notes and Sequence zone are rotated by 180 degrees";
	["EN-path/DR"] =		"Notes come down from top to the bottom";
	["EN-path/SI"] =		"Notes move with a sinking curve";
	["EN-path/RI"] =		"Notes move with a rising curve";
	["EN-path/SN"] =		"Notes move like snake";
	["EN-path/ZZ"] =		"Notes move in zigzag";

	--alternate
	["EN-alternate/M"] =		"Swap sides song's steps";
	["EN-alternate/RS"] =		"Randomize the appearance of the steps";
	["EN-alternate/SS"] =		"Rotate the song's steps by 180 degrees";
	
	--judge
	["EN-judge/EJ"] =		"Change to a Easy Judgement";
	["EN-judge/HJ"] =		"Change to a Hard Judgement";
	["EN-judge/JR"] =		"Change the judgement range to it's opposite";
	["EN-judge/VJ"] =		"Change to a Very Hard  Judgement";
	["EN-judge/XJ"] =		"Change to a Extra Hard  Judgement";
	["EN-judge/UJ"] =		"Change to a Ultra Hard  Judgement";

	--rush
	["EN-rush/60"] =		"Set the music speed to 0.6x from the original BPM";		
	["EN-rush/70"] =		"Set the music speed to 0.7x from the original BPM";		
	["EN-rush/80"] =		"Set the music speed to 0.8x from the original BPM";		
	["EN-rush/90"] =		"Set the music speed to 0.9x from the original BPM";
	["EN-rush/110"] =		"Set the music speed to 1.1x from the original BPM";
	["EN-rush/120"] =		"Set the music speed to 1.2x from the original BPM";
	["EN-rush/130"] =		"Set the music speed to 1.3x from the original BPM";
	["EN-rush/140"] =		"Set the music speed to 1.4x from the original BPM";
	["EN-rush/150"] =		"Set the music speed to 1.5x from the original BPM";
	["EN-rush/160"] =		"Set the music speed to 1.6x from the original BPM";
	["EN-rush/170"] =		"Set the music speed to 1.7x from the original BPM";

	--rank
	["EN-rank/RANK"] =		"Applies to the status of BGA ON, VJ Judge, Break ON";
	["EN-sort/TITLE"] =	"Sort songs in order of alphabet";

	--av
	["EN-av/100"] =		"Velocity plus 100";
	["EN-av/10"] =		"Velocity plus 10";
	["EN-av/1"] =		"Velocity plus 1";
	["EN-av/-1"] =		"Velocity minus 1";
	["EN-av/-10"] =		"Velocity minus 10";
	["EN-av/-100"] =	"Velocity minus 100";

	--cv
	["EN-cv/100"] =		"Velocity plus 100";
	["EN-cv/10"] =		"Velocity plus 10";
	["EN-cv/1"] =		"Velocity plus 1";
	["EN-cv/-1"] =		"Velocity minus 1";
	["EN-cv/-10"] =		"Velocity minus 10";
	["EN-cv/-100"] =	"Velocity minus 100";

	--INFO
	["EN-info/BASIC"] =		"Show Basic information on gameplay";
	["EN-info/FULL"] =		"Show More information on gameplay";
	["EN-info/EXTRA"] =		"Show All the information on gameplay";

	["EN-info/TIMING"] =		"Displays your gameplay timing";
	["EN-info/TIMINGBAR"] =		"Displays your gameplay timing in a bar";
	["EN-info/BREAKICON"] =		"Show an icon on the lifebar indicating the break status";
	["EN-info/SCORE"] =		"Show an item with your actual score";
	["EN-info/JUDGEDATA"] =		"Show an item with your actual judgment data";
	["EN-info/MUSICDURATION"] =		"Show the music duration on the bottom of the screen";
	["EN-info/TOPBARMUSIC"] =		"Show the music duration bar on top of the screen";
	["EN-info/STEPLV"] =		"Show the level and gamemode of the stepchart selected";
	["EN-info/ALL"] =		"Activate all";
	["EN-info/NONE"] =		"Deactivate all";


	--JudgeSkin
	["EN-judgeskin"] = 	"Set the judgment skin";
	["EN-judgeskin/GENERICTEXT"] = 	"Set ## skin";

	--JudgeSkinZoom
	["EN-judgeskinzoom"] = 	"Set the zoom for the judgment skin ";
	["EN-judgeskinzoom/GENERICTEXT"] = 	"Active zoom:     ";

	--lifebarskin
	["EN-lifebarskin"] = 	"Set the skin for the lifebar ";
	["EN-lifebarskin/GENERICTEXT"] = 	"Set ## skin ";		

	--lifebarskin
	["EN-lifebarsettings"] = 	"Choose the break behavior";
	["EN-lifebarsettings/BREAKONLIFEBAR"] = 	"Enable or disable song break. If ON, the song will break when the player's life bar reaches 0";
	["EN-lifebarsettings/SUDDEND"] = 	"If you MISS once, the song ends.";
	["EN-lifebarsettings/5MISSMAX"] = 	"If you get 6 or more MISSES, the song ends.";
	["EN-lifebarsettings/PFCMODE"] = 	"If you get anything below PERFECT, the song ends.";
	["EN-lifebarsettings/FCMODE"] = 	"If you get anything below GREAT, the song ends.";
	["EN-lifebarsettings/EFCMODE"] = 	"If you get anything below GOOD, the song ends.";
	["EN-lifebarsettings/GENERICTEXT"] = 	"-";	


	["EN-timingadj"] = 	"Tweak the timing - you can shift the notechart to start a bit earlier or later.";
	["EN-timingadjEarly"] =	"Early";
	["EN-timingadjLate"] =	"Late";
	["EN-timingadjRecom"] =	"Recommended";
	["EN-timingadj/GENERICTEXT"] = 	"";	

	--companion
	["EN-companion"] = 	"Set your companion ";	
	["EN-companion/GENERICTEXT"] = 	"Set ##";	

	-- Spanish Default below :v
	["speed"] = 		"Cambia la velocidad de la nota";		--1
	["display"] = 		"Cambia la apariencia del juego";		--2
	["note skin"] =		"Cambia la apariencia de las notas";	--3
	["path"] = 			"Cambia la apariencia de los pasos";	--4
	["alternate"] =		"Cambia el patrón de la canción";		--5
	["judge"] =			"Cambia la dificultad del juicio";		--6
	["rush"] =			"Cambia la velocidad de la canción";	--7
	["reset"] =			"Reestablece los parámetros";			--8
	["rank"] =			"Configurar el RANK MODE";				--9
	["sort"] =			"Cambia el orden de las canciones";	--9
	["av"] =			"Establece la velocidad de Auto Velocity.";	--9
	["cv"] = 			"Establece una velocidad constante para la canción | Remueve todo tipo de cambios de velocidad";	--9
	["info"] = 			"Establece la información disponible en el juego.";	--9
	["vsmode"] = 		"1 vs 1 UI | Solo para 2 Jugadores";	--9
	
	--speed
	["speed/1X"] = 		"Cambia la velocidad de la nota por 1x";		
	["speed/2X"] = 		"Cambia la velocidad de la nota por 2x";		
	["speed/3X"] = 		"Cambia la velocidad de la nota por 3x";	
	["speed/4X"] = 		"Cambia la velocidad de la nota por 4x";		
	["speed/5X"] =		"Cambia la velocidad de la nota por 5x";	
	["speed/6X"] =		"Cambia la velocidad de la nota por 6x";		
	["speed/+0.25"] =	"Aumenta la velocidad de la nota en 0.25x";		
	["speed/+0.5"] =	"Aumenta la velocidad de la nota en 0.5x";		
	["speed/EW"] =		"La nota se mueve como un gusano";		
	["speed/RV"] =		"La nota se mueve con velocidad aleatoria";		
	["speed/AV"] =		"Cambia la velocidad de la nota automáticamente con los BPM de la canción.";
	["speed/AC"] =		"La velocidad de la nota cambia acelerando";
	["speed/DC"] =		"La velocidad de la nota cambia desacelerando";
	
	--display
	["display/V"] = 			"Las notas desaparecen en medio de la pantalla";
	["display/AP"] = 			"Las notas aparecen desde el medio de la pantalla";
	["display/NS"] = 			"Las notas son invisibles";
	["display/FD"] = 			"El receptor de notas es invisible";
	["display/FL"] =			"Las notas parpadean mientras aparecen";
	["display/RANDOM NOTE"] = 	"Las notas aparecen aleatoriamente";
	["display/BGA OFF"] = 		"Desactiva el video de la canción";
	["display/BGA DARK"] =		"Atenuar el video de la canción";
	["display/BGA PARTIAL"] = 		"Atenuar el video de la canción";
	["display/MI"] =			"Aleja las notas y el receptor";
	["display/FOOTGUIDE"] =			"Las notas mostrarán el patrón del pie";
	--noteskin
	["note skin/GENERICTEXT"] =	"Usa la apariencia de notas ";
	["note skin/SOCCER"] =		"Usa la apariencia de notas FOOTBALL";
	["note skin/BASIC"] =		"Usa la apariencia de notas BASIC MODE";
	["note skin/FIESTA2"] =		"Usa la apariencia de notas FIESTA 2";
	["note skin/PRIME2"] =		"Usa la apariencia de notas PRIME 2";
	["note skin/DEFAULT"] =			"Usa la apariencia de notas PRIME";
	
	["note skin/INFINITY"] =			"Usa la apariencia de notas Infinity";
	["note skin/INFINITY-RHYTHM"] =			"Usa la apariencia de notas Infinity Rhythm";
	["note skin/PRO-RHYTHM"] =			"Usa la apariencia de notas Pro Rhythm";
	["note skin/PRO2-RHYTHM"] =			"Usa la apariencia de notas Pro 2 Rhythm";
	
	--path
	["path/UA"] =			"Las notas y receptores se invierten";
	["path/NX"] =			"Las notas aparecen a la distancia";
	["path/X"] =			"Las notas aparecen en diagonal";
	["path/DR"] =			"Las notas van de arriba hacia abajo";
	["path/SI"] =			"Se muestra una curva surgida en el centro";
	["path/RI"] =			"Se muestran una curva hundida en el centro";
	["path/SN"] =			"Las notas se mueven como una serpiente";
	["path/ZZ"] =			"Las notas se mueven en zigzag";
	
	--alternate
	["alternate/M"] =		"Los pasos se muestran del lado opuesto";
	["alternate/RS"] =		"Los pasos se muestran al azar";
	["alternate/SS"] =		"Los pasos se muestran al revéz";
	
	--judge
	["judge/EJ"] =			"Establece el juicio en la dificultad facil";
	["judge/HJ"] =			"Establece el juicio en la dificultad difícil";
	["judge/JR"] =			"Invierte el juicio se visualiza al contrario";
	["judge/VJ"] =			"Establece el juicio en la dificultad muy difícil";
	["judge/XJ"] =			"Establece el juicio en la dificultad extra difícil";
	["judge/UJ"] =			"Establece el juicio en la dificultad ultra difícil";
	
	
	--rush
	["rush/60"] =			"Cambia la velocidad de la canción por 0.6x";		
	["rush/70"] =			"Cambia la velocidad de la canción por 0.7x";		
	["rush/80"] =			"Cambia la velocidad de la canción por 0.8x";		
	["rush/90"] =			"Cambia la velocidad de la canción por 0.9x";
	["rush/110"] =			"Cambia la velocidad de la canción por 1.1x";
	["rush/120"] =			"Cambia la velocidad de la canción por 1.2x";
	["rush/130"] =			"Cambia la velocidad de la canción por 1.3x";
	["rush/140"] =			"Cambia la velocidad de la canción por 1.4x";
	["rush/150"] =			"Cambia la velocidad de la canción por 1.5x";
	["rush/160"] =			"Cambia la velocidad de la canción por 1.6x";
	["rush/170"] =			"Cambia la velocidad de la canción por 1.7x";
	
	--rank	
	["rank/RANK"] =			"Aplica el estado BGA ON, Juicio VJ Break ON";
	["sort/TITLE"] =		"Ordenar las canciones en orden alfabético";
	
	
	--av
	["av/100"] =		"Velocidad más 100";
	["av/10"] =		"Velocidad más 10";
	["av/1"] =		"Velocidad más 1";
	["av/-1"] =		"Velocidad menos 1";
	["av/-10"] =		"Velocidad menos 10";
	["av/-100"] =	"Velocidad menos 100";

	--cv
	["cv/100"] =		"Velocidad más 100";
	["cv/10"] =		"Velocidad más 10";
	["cv/1"] =		"Velocidad más 1";
	["cv/-1"] =		"Velocidad menos 1";
	["cv/-10"] =		"Velocidad menos 10";
	["cv/-100"] =	"Velocidad menos 100";

	--INFO
	["info/BASIC"] =	"Muestra información basica en el juego";
	["info/FULL"] =		"Muestra más información en el juego";
	["info/EXTRA"] =	"Muestra toda la información en el juego";

	["info/TIMING"] =		"Muestra el timing de la canción";
	["info/TIMINGBAR"] =		"Muestra el timing de la canción en una barra";
	["info/BREAKICON"] =		"Muestra un icono en la barra de vida indicando el estado del BREAK";
	["info/SCORE"] =		"Muestra un item con tu puntaje actual";
	["info/JUDGEDATA"] =		"Muestra un item con el detalle de tu gameplay actual";
	["info/MUSICDURATION"] =		"Muestra la duración de la canción en la parte inferior de la pantalla";
	["info/TOPBARMUSIC"] =		"Muestra la barra de duración de la canción en la parte superior de la pantalla";
	["info/STEPLV"] =		"Muestra el nivel y el modo de juego del stepchart seleccionado";
	["info/ALL"] =		"Activar todos";
	["info/NONE"] =		"Desactivar todos";	

	--JudgeSkin
	["judgeskin"] = 	"Selecciona la apariencia del judgment";
	["judgeskin/GENERICTEXT"] = 	"Aplicar apariencia ## ";

	--JudgeSkinZoom
	["judgeskinzoom"] = 	"selecciona el zoom del judgment";
	["judgeskinzoom/GENERICTEXT"] = "Zoom activo:     ";	
	
	--lifebarskin
	["lifebarskin"] = 	"Selecciona la apariencia del la barra de vida";
	["lifebarskin/GENERICTEXT"] = 	"Aplicar apariencia ## ";		

	--lifebarskin
	["lifebarsettings"] = 	"Selecciona como la barra de vida funciona";
	["lifebarsettings/BREAKONLIFEBAR"] = 	"Activa o desactiva el Song Break, si la vida del jugador llega 0, la canción termina.";
	["lifebarsettings/SUDDEND"] = 	"La canción termina si obtienes un MISS";
	["lifebarsettings/5MISSMAX"] = 	"La canción termina si obtienes 6 MISS o más";
	["lifebarsettings/PFCMODE"] = 	"La canción termina si obtienes algo que no sea un PERFECT.";
	["lifebarsettings/FCMODE"] = 	"La canción termina si obtienes un GOOD, BAD o MISS";
	["lifebarsettings/EFCMODE"] = 	"La canción termina si obtienes un BAD o MISS";
	["lifebarsettings/GENERICTEXT"] = 	"-";	

	["timingadj"] = 	"Ajusta el timing - puedes mover el notechart para que empiece un poco antes o después";
	["timingadjEarly"] =	"Antes";
	["timingadjLate"] =	"Despues";
	["timingadjRecom"] ="Recomendado";

	["timingadj/GENERICTEXT"] = 	"";	

	--companion
	["companion"] = 	"Selecciona tu compañero";	
	["companion/GENERICTEXT"] = "Seleccionar ##";	

	["PT-speed"] = 		"Altere a velocidade da seta";		--1
	["PT-display"] = 	"Altere a tela do jogo";		--2
	["PT-note skin"] = 	"Altere o tipo de setas";	--3
	["PT-path"] = 		"Altere  o movimento das setas";		--4
	["PT-alternate"] = 	"Altere a aparência dos Steps";	--5
	["PT-judge"] = 		"Altere o julgamento";		--6
	["PT-rush"] = 		"Altere a velocidade da música";		--7
	["PT-reset"] = 		"Reseta todas as opções";		--8
	["PT-rank"] = 		"Modo Rank Mode";		--9
	["PT-sort"] = 		"Sorteie as músicas";		--9
	["PT-info"] = 		"Sorteie as músicas";		--9
	["PT-vsmode"] = 	"Interface 1 vs 1 | Apenas para 2 jogadores";
	
	["PT-av"] = "Defina a velocidade desejável em Auto Velocity.";		--9
	["PT-cv"] = "Defina uma velocidade constante para a música | Remove todas as mudanças de velocidade e gimmicks.";	--9

	["PT-speed/1X"] = 		"Defina velocidade da seta em 1x";		
	["PT-speed/2X"] = 		"Defina velocidade da seta em 2x";
	["PT-speed/3X"] = 		"Defina velocidade da seta em 3x";
	["PT-speed/4X"] = 		"Defina velocidade da seta em 4x";
	["PT-speed/5X"] =		"Defina velocidade da seta em 5x";
	["PT-speed/6X"] =		"Defina velocidade da seta em 6x";
	["PT-speed/+0.25"] =	"Defina velocidade da seta em +0.25";
	["PT-speed/+0.5"] =		"Defina velocidade da seta em +0.5";
	["PT-speed/EW"] =		"Setas se movimentam como minhocas";		
	["PT-speed/RV"] =		"Velocidade das setas alteram aleatoriamente";		
	["PT-speed/AV"] =		"Defina a velocidade da seta automaticamente dentro do BPM da música";
	["PT-speed/AC"] =		"Velocidade da seta em  crescente";
	["PT-speed/DC"] =		"Velocidade da seta em  decrescente";
	
	--display
	["PT-display/V"] = 					"Setas desaparecem do meio da tela";
	["PT-display/AP"] = 				"Setas aparecem do meio da tela";
	["PT-display/NS"] = 				"Torna todas as setas invisiveis";
	["PT-display/FD"] = 				"Torna a  zona de sequência invisivel";
	["PT-display/FL"] = 				"Setas piscam ao se moverem";
	["PT-display/RANDOM NOTE"] = 		"Escolha Note Skin aleatório";
	["PT-display/BGA OFF"] = 			"Desative o BGA das músicas";
	["PT-display/BGA DARK"] = 			"Desative o BGA das músicas";
	["PT-display/BGA PARTIAL"] = 		"Desative o BGA das músicas";
	["PT-display/MI"] =					"Diminui o zoom do campo de notas";
	["PT-display/FOOTGUIDE"] =			"As notas exibirão o padrão dos pés";
	--noteskin
	["PT-note skin/GENERICTEXT"] =		"Setas ";
	["PT-note skin/FLOWER"] =			"Setas Baralho Koreano";
	["PT-note skin/OLD"] =				"Setas Old (Extra)";
	["PT-note skin/EASY"] =				"Setas Easy";
	["PT-note skin/SLIME"] =			"Setas Gelatina";
	["PT-note skin/MUSIC"] =			"Setas Musicais ";
	["PT-note skin/CANON"] =			"Setas Canon D";
	["PT-note skin/NX"] =				"Setas NX";
	["PT-note skin/SHEEP"] =			"Setas Lamb";
	["PT-note skin/HORSE"] =			"Setas Horse";
	["PT-note skin/DOG"] =				"Setas Dog";
	["PT-note skin/GIRL"] =				"Setas Girl";
	["PT-note skin/FIRE"] =				"Setas de Fogo";
	["PT-note skin/ICE"] =				"Setas de Gelo";
	["PT-note skin/WIND"] =				"Setas de Vento";
	["PT-note skin/NXA"] =				"Setas NXA";
	["PT-note skin/NX2"] =				"Setas NX2";
	["PT-note skin/LIGHTNING"] =		"Setas Raios";
	["PT-note skin/DRUM"] =				"Setas Tambores";
	["PT-note skin/MISSILE"] =			"Setas Missil";
	["PT-note skin/SOCCER"] =			"Setas Football";
	["PT-note skin/REBIRTH"] =			"Setas Rebirth";
	["PT-note skin/BASIC"] =			"Setas Modo Basico";
	["PT-note skin/FIESTA"] =			"Setas Fiesta";
	["PT-note skin/FIESTA2"] =			"Setas Fiesta 2";	
	["PT-note skin/PRIME2"] =			"Setas Prime 2";	
	["PT-note skin/XX"] =				"Setas XX Anniversary";	
	
	["PT-note skin/INFINITY"] =			"Setas Infinity";
	["PT-note skin/INFINITY-RHYTHM"] =			"Setas Infinity Rhythm";
	["PT-note skin/PRO-RHYTHM"] =			"Setas Pro Rhythm";
	["PT-note skin/PRO2-RHYTHM"] =			"Setas Pro 2 Rhythm";
	["PT-note skin/DEFAULT"] =				"Setas Prime";	
	
	--path
	["PT-path/X"] =			"Setas se movem em diagonal";
	["PT-path/NX"] =		"Setas se movem em diferentes perspectivas";
	["PT-path/UA"] =		"Setas e Zona de Sequência são rotacionadas em 180 graus";
	["PT-path/DR"] =		"Setas surgem de baixo para cima";
	["PT-path/SI"] =		"Setas se movem com curva para o fundo";
	["PT-path/RI"] =		"Setas se movem com com curva para frente";
	["PT-path/SN"] =		"Setas se movem como uma cobra";
	["PT-path/ZZ"] =		"Setas se movem em zigzag";

	--alternate
	["PT-alternate/M"] =		"Rotaciona os passos em 180 graus";
	["PT-alternate/RS"] =		"As setas surgem de modo aleatório";
	["PT-alternate/SS"] =		"Trocar os lados das etapas da música";
	
	--judge
	["PT-judge/EJ"] =		"Altera para julgamento Easy";
	["PT-judge/HJ"] =		"Altera para julgamento Hard";
	["PT-judge/JR"] =		"Aparência do julgamento será oposta";
	["PT-judge/VJ"] =		"Altera para julgamento Very Hard";
	["PT-judge/XJ"] =		"Altera para julgamento Extra Hard";
	["PT-judge/UJ"] =		"Altera para julgamento Ultra Hard";

	--rush
	["PT-rush/60"] =		"Defina velocidade das setas em 0.6x do BPM original";		
	["PT-rush/70"] =		"Defina velocidade das setas em 0.7x do BPM original";		
	["PT-rush/80"] =		"Defina velocidade das setas em 0.8x do BPM original";		
	["PT-rush/90"] =		"Defina velocidade das setas em 0.9x do BPM original";
	["PT-rush/110"] =		"Defina velocidade das setas em 1.1x do BPM original";
	["PT-rush/120"] =		"Defina velocidade das setas em 1.2x do BPM original";
	["PT-rush/130"] =		"Defina velocidade das setas em 1.3x do BPM original";
	["PT-rush/140"] =		"Defina velocidade das setas em 1.4x do BPM original";
	["PT-rush/150"] =		"Defina velocidade das setas em 1.5x do BPM original";
	["PT-rush/160"] =		"Defina velocidade das setas em 1.6x do BPM original";
	["PT-rush/170"] =		"Defina velocidade das setas em 1.7x do BPM original";
	--rank
	["PT-rank/RANK"] =		"Aplica-se ao status do BGA ON, VJ Judge, Break ON";
	["PT-sort/TITLE"] =		"Sorteia as músicas em ordem alfabética";

	--av
	["PT-av/100"] =		"Velocidade mais 100";
	["PT-av/10"] =		"Velocidade mais 10";
	["PT-av/1"] =		"Velocidade mais 1";
	["PT-av/-1"] =		"Velocidade menos 1";
	["PT-av/-10"] =		"Velocidade menos 10";
	["PT-av/-100"] =	"Velocidade menos 100";

	--cv
	["PT-cv/100"] =		"Velocidade mais 100";
	["PT-cv/10"] =		"Velocidade mais 10";
	["PT-cv/1"] =		"Velocidade mais 1";
	["PT-cv/-1"] =		"Velocidade menos 1";
	["PT-cv/-10"] =		"Velocidade menos 10";
	["PT-cv/-100"] =	"Velocidade menos 100";


	--INFO
	["PT-info/BASIC"] = "Exibe informações básicas no jogo";
	["PT-info/FULL"] = "Exibe mais informações no jogo";
	["PT-info/EXTRA"] = "Exibe todas as informações no jogo";

	["PT-info/TIMING"] =        "Mostrar o tempo da sua jogabilidade";
	["PT-info/TIMINGBAR"] =		"Mostra o tempo da sua jogabilidade em uma barra";
	["PT-info/BREAKICON"] =     "Mostrar um ícone na barra de vida indicando o estado de break";
	["PT-info/SCORE"] =         "Mostrar um item com sua pontuação atual";
	["PT-info/JUDGEDATA"] =     "Mostrar um item com seus dados de julgamento atuais";
	["PT-info/MUSICDURATION"] = "Mostrar a duração da música na parte inferior da tela";
	["PT-info/TOPBARMUSIC"] = "Mostrar a barra de duração da música no topo da tela";
	["PT-info/STEPLV"] = "Mostra o nível e o modo de jogo da stepchart selecionada";
	["PT-info/ALL"] =           "Ativar tudo";
	["PT-info/NONE"] =          "Desativar tudo";



	["PT-judgeskin"] = 	"Selecione a aparência do julgamento";
	["PT-judgeskin/GENERICTEXT"] = 	"Aplicar aparência ##";	

	--JudgeSkinZoom
	["PT-judgeskinzoom"] = 	"Selecione o zoom do judgment";
	["PT-judgeskinzoom/GENERICTEXT"] = "Zoom ativo:     ";	

	--lifebarskin
	["PT-lifebarskin"] = 	"Selecione a aparência da barra de vida.";
	["PT-lifebarskin/GENERICTEXT"] = 	"Aplicar aparência ## ";	

	--lifebarskin
	["PT-lifebarsettings"] = 	"Selecione como a barra de vida funciona";
	["PT-lifebarsettings/BREAKONLIFEBAR"] = 	"Ativa ou desativa o Song Break; se a vida do jogador chegar a 0, a música termina.";
	["PT-lifebarsettings/SUDDEND"] = 	"A música termina se você obtiver um MISS";
	["PT-lifebarsettings/5MISSMAX"] = 	"A música termina se você obtiver 6 MISS ou mais";
	["PT-lifebarsettings/PFCMODE"] = 	"A música termina se você obtiver algo diferente de PERFECT.";
	["PT-lifebarsettings/FCMODE"] = 	"A música termina se você obtiver um GOOD, BAD ou MISS";
	["PT-lifebarsettings/EFCMODE"] = 	"A música termina se você obtiver um BAD ou MISS";
	["PT-lifebarsettings/GENERICTEXT"] = 	"-";	

	["PT-timingadj"] = 	"Ajuste o timing - você pode mudar se o notechart começa um pouco antes ou depois.";
	["PT-timingadjEarly"] =	"Cedo";
	["PT-timingadjLate"] =	"Tarde";
	["PT-timingadjRecom"] =	"Recomendado";
	["PT-timingadj/GENERICTEXT"] = 	"";	

	--companion
	["PT-companion"] = 	"Selecione seu companheiro";	
	["PT-companion/GENERICTEXT"] = "Selecionar ##";	


	["KO-speed"] = 		"노트 속도를 변경합니다.";			--1
	["KO-display"] = 	"게임 화면 연출을 변경합니다.";		--2
	["KO-note skin"] = 	"노트 스킨을 변경합니다.";					--3
	["KO-path"] = 		"노트의 움직임을 변경합니다.";		--4
	["KO-alternate"] = 	"채보의 출현 방식을 변경합니다.";	--5
	["KO-judge"] = 		"판정을 변경합니다.";				--6
	["KO-rush"] = 		"곡의 재생 속도를 변경합니다.";	--7
	["KO-reset"] = 		"모든 세팅을 초기화합니다.";				--8
	["KO-rank"] = 		"랭크 모드를 설정합니다.";				--9
	["KO-sort"] = 		"곡의 정렬 방식을 설정합니다.";			--9
	["KO-av"] = 		"자동 배속 속도를 설정합니다.";	--9
	["KO-cv"] = 		"곡에 일정한 속도를 설정합니다 | 모든 속도 변경과 기믹을 제거합니다.";	--9
	["KO-info"] = 		"게임 화면을 설정합니다.";	--9
	["KO-vsmode"] = 	"2인 플레이 1:1 대결 모드를 설정합니다.";

	["KO-speed/1X"] = 		"노트 속도를 1배속 설정합니다.";		
	["KO-speed/2X"] = 		"노트 속도를 2배속 설정합니다.";
	["KO-speed/3X"] = 		"노트 속도를 3배속 설정합니다.";
	["KO-speed/4X"] = 		"노트 속도를 4배속 설정합니다.";
	["KO-speed/5X"] =		"노트 속도를 5배속 설정합니다.";
	["KO-speed/6X"] =		"노트 속도를 6배속 설정합니다.";
	["KO-speed/+0.25"] =	"노트 속도를 +0.25배속 설정합니다.";
	["KO-speed/+0.5"] =		"노트 속도를 +0.5배속 설정합니다.";
	["KO-speed/EW"] =		"노트가 지렁이처럼 이동합니다.";		
	["KO-speed/RV"] =		"노트의 이동 속도가 무작위로 바뀝니다.";		
	["KO-speed/AV"] =		"노트의 이동 속도를 곡의 BPM에 맞춥니다.";
	["KO-speed/AC"] =		"노트가 가속하면서 이동합니다.";
	["KO-speed/DC"] =		"노트가 감속하면서 이동합니다.";
	
	--display
	["KO-display/V"] = 					"중간 부분부터 노트가 사라집니다.";
	["KO-display/AP"] = 				"중간 부분부터 노트가 나타납니다.";
	["KO-display/NS"] = 				"노트가 보이지 않게 설정합니다.";
	["KO-display/FD"] = 				"시퀸스 존이 보이지 않게 설정합니다.";
	["KO-display/FL"] = 				"노트가 깜빡이면서 이동합니다.";
	["KO-display/RANDOM NOTE"] = 		"노트 스킨이 랜덤으로 나타납니다.";
	["KO-display/BGA OFF"] = 			"BGA를 사용하지 않습니다.";
	["KO-display/BGA DARK"] = 			"BGA를 어둡게 설정합니다.";
	["KO-display/BGA PARTIAL"] = 		"BGA에서 노트가 이동하는 부분만 어둡게 설정합니다.";
	["KO-display/MI"] =					"노트와 시퀸스 존의 크기를 축소합니다.";
	["KO-display/FOOTGUIDE"] =			"노트에 발 패턴이 표시됩니다";
	--noteskin
	["KO-note skin/GENERICTEXT"] =		"##으로 설정합니다.";
	["KO-note skin/FLOWER"] =			"Korean Trump Skin 으로 설정합니다.";
	["KO-note skin/OLD"] =				"Old Skin 으로 설정합니다.";
	["KO-note skin/EASY"] =				"Easy Skin 으로 설정합니다.";
	["KO-note skin/SLIME"] =			"Slime Skin 으로 설정합니다.";
	["KO-note skin/MUSIC"] =			"Music Skin 으로 설정합니다.";
	["KO-note skin/CANON"] =			"Canon Skin 으로 설정합니다.";
	["KO-note skin/NX"] =				"NX Skin 으로 설정합니다.";
	["KO-note skin/SHEEP"] =			"Lamb Skin 으로 설정합니다.";
	["KO-note skin/HORSE"] =			"Horse Skin 으로 설정합니다.";
	["KO-note skin/DOG"] =				"Dog Skin 으로 설정합니다.";
	["KO-note skin/GIRL"] =				"Girl Skin 으로 설정합니다.";
	["KO-note skin/FIRE"] =				"Fire Skin 으로 설정합니다.";
	["KO-note skin/ICE"] =				"Ice Skin 으로 설정합니다.";
	["KO-note skin/WIND"] =				"Wind Skin 으로 설정합니다.";
	["KO-note skin/NXA"] =				"NXA Skin 으로 설정합니다.";
	["KO-note skin/NX2"] =				"NX2 Skin 으로 설정합니다.";
	["KO-note skin/LIGHTNING"] =		"Lightning Skin 으로 설정합니다.";
	["KO-note skin/DRUM"] =				"Drum Skin 으로 설정합니다.";
	["KO-note skin/MISSILE"] =			"Missile Skin 으로 설정합니다.";
	["KO-note skin/SOCCER"] =			"Football Skin 으로 설정합니다.";
	["KO-note skin/REBIRTH"] =			"Rebirth Skin 으로 설정합니다.";
	["KO-note skin/BASIC"] =			"Basic mode Skin 으로 설정합니다.";
	["KO-note skin/FIESTA"] =			"Fiesta Skin 으로 설정합니다.";
	["KO-note skin/FIESTA2"] =			"Fiesta 2 Skin 으로 설정합니다.";	
	["KO-note skin/PRIME2"] =			"Prime 2 Skin 으로 설정합니다.";	
	["KO-note skin/XX"] =				"XX Anniversary Skin 으로 설정합니다.";	
	["KO-note skin/INFINITY"] =			"Infinity Skin 으로 설정합니다.";
	["KO-note skin/INFINITY-RHYTHM"] =	"Infinity Rhythm Skin 으로 설정합니다.";
	["KO-note skin/PRO-RHYTHM"] =		"Pro Rhythm Skin 으로 설정합니다.";
	["KO-note skin/PRO2-RHYTHM"] =		"Pro 2 Rhythm Skin 으로 설정합니다.";
	["KO-note skin/DEFAULT"] =			"Prime Skin 으로 설정합니다.";	
	
	--path
	["KO-path/X"] =			"노트가 대각선으로 이동합니다.";
	["KO-path/NX"] =		"노트가 원근감 있게 이동합니다.";
	["KO-path/UA"] =		"노트와 시퀸스 존을 180도 반전합니다.";
	["KO-path/DR"] =		"노트가 위에서 아래로 내려옵니다.";
	["KO-path/SI"] =		"노트가 가라앉는 곡선으로 이동합니다.";
	["KO-path/RI"] =		"노트가 떠오르는 곡선으로 이동합니다.";
	["KO-path/SN"] =		"노트가 뱀처럼 이동합니다.";
	["KO-path/ZZ"] =		"노트가 지그재그로 이동합니다.";

	--alternate
	["KO-alternate/M"] =		"곡의 채보를 180도 반전합니다.";
	["KO-alternate/RS"] =		"채보가 무작위로 나타납니다.";
	["KO-alternate/SS"] =		"채보 위치를 앞뒤로 반전합니다.";
	
	--judge
	
	["KO-judge/EJ"] =		"이지 판정으로 변경합니다.";
	["KO-judge/HJ"] =		"하드 판정으로 변경합니다.";
	["KO-judge/JR"] =		"판정이 반대로 보이도록 설정합니다.";
	["KO-judge/VJ"] =		"베리 하드 판정으로 변경합니다.";
	["KO-judge/XJ"] =		"엑스트라 하드 판정으로 변경합니다.";
	["KO-judge/UJ"] =		"울트라 하드 판정으로 변경합니다.";

	--rush
	["KO-rush/60"] =		"곡 재생 속도를 0.6배속 설정합니다.";		
	["KO-rush/70"] =		"곡 재생 속도를 0.7배속 설정합니다.";		
	["KO-rush/80"] =		"곡 재생 속도를 0.8배속 설정합니다.";		
	["KO-rush/90"] =		"곡 재생 속도를 0.9배속 설정합니다.";
	["KO-rush/110"] =		"곡 재생 속도를 1.1배속 설정합니다.";
	["KO-rush/120"] =		"곡 재생 속도를 1.2배속 설정합니다.";
	["KO-rush/130"] =		"곡 재생 속도를 1.3배속 설정합니다.";
	["KO-rush/140"] =		"곡 재생 속도를 1.4배속 설정합니다.";
	["KO-rush/150"] =		"곡 재생 속도를 1.5배속 설정합니다.";
	["KO-rush/160"] =		"곡 재생 속도를 1.6배속 설정합니다.";
	["KO-rush/170"] =		"곡 재생 속도를 1.7배속 설정합니다.";

	--rank
	["KO-rank/RANK"] =		"Applies to the status of BGA ON, VJ Judge, Break ON";
	["KO-sort/TITLE"] =	"곡의 제목을 알파벳 순서로 정렬합니다.";

	--av
	["KO-av/100"] =		"현재 배속을 100 올립니다.";
	["KO-av/10"] =		"현재 배속을 10 올립니다.";
	["KO-av/1"] =		"현재 배속을 1 올립니다.";
	["KO-av/-1"] =		"현재 배속을 1 줄입니다.";
	["KO-av/-10"] =		"현재 배속을 10 줄입니다.";
	["KO-av/-100"] =	"현재 배속을 100 줄입니다.";

	--av
	["KO-cv/100"] =		"현재 배속을 100 올립니다.";
	["KO-cv/10"] =		"현재 배속을 10 올립니다.";
	["KO-cv/1"] =		"현재 배속을 1 올립니다.";
	["KO-cv/-1"] =		"현재 배속을 1 줄입니다.";
	["KO-cv/-10"] =		"현재 배속을 10 줄입니다.";
	["KO-cv/-100"] =	"현재 배속을 100 줄입니다.";

	--INFO
	["KO-info/BASIC"] =		"Show Basic information on gameplay";
	["KO-info/FULL"] =		"Show More information on gameplay";
	["KO-info/EXTRA"] =		"Show All the information on gameplay";

	["KO-info/TIMING"] =		"입력한 노트의 타이밍 판정을 표시합니다.";
	["KO-info/TIMINGBAR"] =		"입력한 노트의 타이밍 게이지 바를 표시합니다.";
	["KO-info/BREAKICON"] =		"라이프바에 중단 상태를 나타내는 아이콘을 표시합니다.";
	["KO-info/SCORE"] =		"실제 점수가 표시된 항목을 보입니다.";
	["KO-info/JUDGEDATA"] =		"실제 판정 데이터가 표시된 항목을 보입니다.";
	["KO-info/MUSICDURATION"] =		"화면 아래에 곡의 재생 시간을 보입니다.";
	["KO-info/TOPBARMUSIC"] = "화면 상단에 음악 재생 시간 바를 표시합니다.";
	["KO-info/STEPLV"] =		"선택한 채보 난이도와 게임 모드를 보입니다.";
	["KO-info/ALL"] =		"모든 기능을 활성화 합니다.";
	["KO-info/NONE"] =		"모든 기능을 비활성화 합니다.";


	--JudgeSkin
	["KO-judgeskin"] = 	"판정 스킨을 설정합니다.";
	["KO-judgeskin/GENERICTEXT"] = 	"## 스킨으로 설정합니다.";

	--JudgeSkinZoom
	["KO-judgeskinzoom"] = 	"판정 스킨의 배율을 설정합니다. ";
	["KO-judgeskinzoom/GENERICTEXT"] = 	"배율 ";

	--lifebarskin
	["KO-lifebarskin"] = 	"라이프바 스킨을 설정합니다.";
	["KO-lifebarskin/GENERICTEXT"] = 	"## 스킨으로 설정합니다.";			

	--lifebarskin
	["KO-lifebarsettings"] = 	"라이프바의 효과를 설정합니다.";
	["KO-lifebarsettings/BREAKONLIFEBAR"] = 	"플레이어의 체력이 0이 되면 스테이지 브레이크가 됩니다.";
	["KO-lifebarsettings/SUDDEND"] = 	"MISS를 한 번이라도 하면 곡이 종료됩니다.";
	["KO-lifebarsettings/5MISSMAX"] = 	"MISS를 6번 이상 하면 곡이 종료됩니다.";
	["KO-lifebarsettings/PFCMODE"] = 	"PERFECT보다 낮은 판정을 받으면 곡이 종료됩니다.";
	["KO-lifebarsettings/FCMODE"] = 	"GREAT보다 낮은 판정을 받으면 곡이 종료됩니다.";
	["KO-lifebarsettings/EFCMODE"] = 	"GOOD보다 낮은 판정을 받으면 곡이 종료됩니다.";
	["KO-lifebarsettings/GENERICTEXT"] = 	"-";	


	["KO-timingadj"] = 	"판정 타이밍을 조절합니다.";
	["KO-timingadjEarly"] =	"빠름";
	["KO-timingadjLate"] =	"늦음";
	["KO-timingadjRecom"] =	"권장";
	["KO-timingadj/GENERICTEXT"] = 	"";	

	--companion
	["KO-companion"] = 	"팀원을 설정하세요.";	
	["KO-companion/GENERICTEXT"] = 	"## 설정";

}

local langTextMisc = {
		["EN-F9"] =	 "P1 PROFILE";
		["EN-F10"] = "P2 PROFILE";
		["EN-F11"] = "SEARCH SONG";
		["EN-F8"] = "PROFILE EDITOR";
		["EN-F7"] = "PERFORMANCE MODE";
		["EN-RCTRL"] = "RANDOM SONG";
		["EN-F5"] = "NONSTOP CENTER";

		["F9"] =  "P1 PERFIL";
		["F10"] = "P2 PERFIL";
		["F11"] = "BUSCAR CANCION";
		["F8"] = "EDITOR DE PERFIL";
		["F7"] = "MODO RENDIMIENTO";
		["RCTRL"] = "CANCIÓN ALEATORIA";
		["F5"] = "NONSTOP CENTER";

		["PT-F9"] =	 "P1 PERFIL";
		["PT-F10"] = "P2 PERFIL";
		["PT-F11"] = "BUSCAR MUSICA";				
		["PT-F8"] = "PROFILE EDITOR";
		["PT-F7"] = "MODO DE DESEMPENHO";
		["PT-RCTRL"] = "MÚSICA ALEATÓRIA";
		["PT-F5"] = "NONSTOP CENTER";

		["KO-F9"] =	 "P1 PROFILE";
		["KO-F10"] = "P2 PROFILE";
		["KO-F11"] = "곡 검색";
		["KO-F8"] = "PROFILE EDITOR";
		["KO-F7"] = "퍼포먼스 모드";
		["KO-RCTRL"] = "랜덤 곡";
		["KO-F5"] = "NONSTOP CENTER";
}

local saninetTextMisc = {

	["en-room-create"] = "Create Room";
	["en-room-join-room"] = "Join Room";
	["en-room-join-public-room"] = "Join Public Room";
	["en-room-leave-room"] = "Leave Room";
	["en-login-text"] = "Enter your 4 digits pin";
	["en-login-exit"] = "PRESS F12 TO CANCEL AND GO BACK";
	["en-login-success"] = "Login success";
	["en-login-failed"] = "Login failed";
	["en-login-footer-no-user"] = "SELECT YOUR PROFILE\n AND PRESS F12 TO LOG IN";
	["en-login-footer-connected"] = "Connected as: ";

	["es-room-create"] = "Crear Sala";
	["es-room-join-room"] = "Unirse a una sala";
	["es-room-join-public-room"] = "Unirse a sala publica";
	["es-room-leave-room"] = "Salir de la sala";

	["es-login-text"] = "Ingresa tu pin de 4 digitos";
	["es-login-exit"] = "Presiona F12 para cancelar y cerrar la ventana";
	["es-login-success"] = "Inicio de sesión exitoso";
	["es-login-failed"] = "Error al iniciar sesión";
	["es-login-footer-no-user"] = "SELECCIONA TU PERFIL Y PRESIONA\n F12 PARA INICIAR SESION";
	["es-login-footer-connected"] = "Conectado como: ";

	["pt-room-create"] = "Criar sala";
	["pt-room-join-room"] = "Entrar em uma sala";
	["pt-room-join-public-room"] = "Entrar em sala pública";
	["pt-room-leave-room"] = "Sair da sala";
	["pt-login-text"] = "Digite seu PIN de 4 dígitos";
	["pt-login-exit"] = "Pressione F12 para cancelar e fechar a janela";
	["pt-login-success"] = "Login realizado com sucesso";
	["pt-login-failed"] = "Erro no login";
	["pt-login-footer-no-user"] = "SELECIONE SEU PERFIL\n E PRESSIONE F12 PARA FAZER LOGIN";
	["pt-login-footer-connected"] = "Logado como: ";

	["ko-room-create"] = "방 만들기";
	["ko-room-join-room"] = "방 참여하기";
	["ko-room-join-public-room"] = "공방 참여하기";
	["ko-room-leave-room"] = "방 나가기";
	["ko-login-text"] = "비밀번호 4자리를 입력하세요";
	["ko-login-exit"] = "F12키로 취소 후 뒤로가기";
	["ko-login-success"] = "로그인 성공";
	["ko-login-failed"] = "로그인 실패";
	["ko-login-footer-no-user"] = "프로필 선택 후 \n F12키로 로그인 하세요";
	["ko-login-footer-connected"] = " 님으로 접속되었습니다.";
}

local nonstopCenterText = {
	["en-songs"] = "Add songs to the list.";
	["en-listopt"] = "Manage your list.";
	["en-ready"] = "Start the game!";
	["en-exit"] = "Return to the main game mode.";

	["en-nsduration"] = "Playlist Duration";
	["en-keyshortcuts"] = "Hotkeys";

	["en-keyshortcuts_deletelast"] = "Remove the last song from the list.";
	["en-keyshortcuts_deletelastKey"] = "Space Bar";

	["en-songSubCenterSelect"] = "SELECT";
	["en-songSubCenterAdd"] = "ADD";

	["en-readySubCenterAlert"] = "Both players need to be ready!";
	["en-readySubCenterSongAlert"] = "Select at least one song to start.";

	["en-shortcutSongRemove"] = "Remove the last song in the list.";
	["en-shortcutPauseTime"] = "Seconds before the next song starts";

	["es-songs"] = "Agrega canciones a la lista.";
	["es-listopt"] = "Administra la lista.";
	["es-ready"] = "Comienza el juego!";
	["es-exit"] = "Retorna al juego principal.";

	["es-nsduration"] = "Duración de la lista";
	["es-keyshortcuts"] = "Atajos";
	["es-keyshortcuts_deletelast"] = "Eliminar la última canción de la lista.";
	["es-keyshortcuts_deletelastKey"] = "Barra espaciadora";

	["es-songSubCenterSelect"] = "SELECCIONAR";
	["es-songSubCenterAdd"] = "AGREGAR";

	["es-readySubCenterAlert"] = "¡Ambos jugadores deben estar listos!";
	["es-readySubCenterSongAlert"] = "Selecciona al menos una canción para comenzar.";

	["es-shortcutSongRemove"] = "Elimina la ultima canción de la lista.";
	["es-shortcutPauseTime"] = "Segundos antes de la próxima canción";

	["pt-songs"] = "Adicione músicas à lista.";
	["pt-listopt"] = "Gerencie a lista.";
	["pt-ready"] = "Inicie o jogo!";
	["pt-exit"] = "Volte ao menu principal.";

	["pt-nsduration"] = "Duração da lista";
	["pt-keyshortcuts"] = "Atalhos";
	["pt-keyshortcuts_deletelast"] = "Remover a última música da lista.";
	["pt-keyshortcuts_deletelastKey"] = "Barra de espaço";

	["pt-songSubCenterSelect"] = "SELECIONAR";
	["pt-songSubCenterAdd"] = "ADICIONAR";

	["pt-readySubCenterAlert"] = "Ambos os jogadores precisam estar prontos!";
	["pt-readySubCenterSongAlert"] = "Selecione pelo menos uma música para começar.";

	["pt-shortcutSongRemove"] = "Remova a última música da lista.";
	["pt-shortcutPauseTime"] = "Segundos antes da próxima música";


	["ko-songs"] = "목록에 곡을 추가하세요.";
	["ko-listopt"] = "목록을 관리하세요.";
	["ko-ready"] = "게임을 시작하세요!";
	["ko-exit"] = "메인 게임 모드로 돌아갑니다.";

	["ko-nsduration"] = "재생 목록 길이";
	["ko-keyshortcuts"] = "단축키";
	["ko-keyshortcuts_deletelast"] = "목록에서 마지막 곡을 제거합니다.";
	["ko-keyshortcuts_deletelastKey"] = "스페이스바";

	["ko-songSubCenterSelect"] = "선택";
	["ko-songSubCenterAdd"] = "추가";

	["ko-readySubCenterAlert"] = "두 플레이어 모두 준비되어 있어야 합니다!";
	["ko-readySubCenterSongAlert"] = "시작하려면 최소 한 곡을 선택하세요.";
	["ko-shortcutSongRemove"] = "목록에서 마지막 곡을 제거하세요.";
	["ko-shortcutPauseTime"] = "다음 곡이 시작되기 전 대기 시간(초)";
}

local customProfileGlobalOption = {
		["en-ejudg"] = "Enable Extra Judgment";
		["es-ejudg"] = "Activar Extra Judgment";
		["pt-ejudg"] = "Ativar Julgamento Extra";
		["ko-ejudg"] = "엑스트라 판정 사용";

		["en-ucs"] = "Show UCS outside UCS Channel";
		["es-ucs"] = "Mostrar UCS fuera del canal UCS";
		["pt-ucs"] = "Mostrar UCS fora do canal UCS";
		["ko-ucs"] = "UCS 채널 외부에서 UCS 표시";
		
		["en-mission"] = "Show QUEST STEPS outside QUEST Channel";
		["es-mission"] = "Mostrar QUEST STEPS fuera del canal QUEST";
		["pt-mission"] = "Mostrar QUEST STEPS fora do canal QUEST";
		["ko-mission"] = "QUEST 채널 외부에서 QUEST STEPS 표시";

		["en-train"] = "Show TRAIN STEPS outside TRAIN Channel";
		["es-train"] = "Mostrar TRAIN STEPS fuera del canal TRAIN";
		["pt-train"] = "Mostrar TRAIN STEPS fora do canal TRAIN";
		["ko-train"] = "TRAIN 채널 외부에서 TRAIN STEPS 표시";

		["en-keytext"] = "Change value";
		["es-keytext"] = "Cambiar valor";
		["pt-keytext"] = "Alterar valor";
		["ko-keytext"] = "값 변경";
};

function getCustomProfileGLobalOption(name)
	if customProfileGlobalOption[PREFSMAN:GetPreference('Language').."-"..name] == nil then
		return "-";
	else
		return customProfileGlobalOption[PREFSMAN:GetPreference('Language').."-"..name];
	end;
end;

function getNonstopCenterText(name)

	if nonstopCenterText[PREFSMAN:GetPreference('Language').."-"..name] == nil then
		return "-";
	else
		return nonstopCenterText[PREFSMAN:GetPreference('Language').."-"..name];
	end;

end;

function getSaninetTextLang(name)
	if saninetTextMisc[PREFSMAN:GetPreference('Language').."-"..name] == nil then
		return "-";
	else
		return saninetTextMisc[PREFSMAN:GetPreference('Language').."-"..name];
	end;
end;

function getZoomSkinJudgCwPlayer(zoom,zoomBaseItemTarget)
	--aca trabajamos el zoom de 0 a 100	
	local realZoom = tonumber(zoom) / 100;

	--el target va a tener un zoom, tenemos que trabajar ese zoom.
	local zoomRes = zoomBaseItemTarget * realZoom;
	return zoomRes;
end;

function getMiscText(name)

	if (langTextMisc[gLANG() .. name] == nil ) then
		return "-";
	end

	return langTextMisc[gLANG() .. name];
end;


function getCWText(name,player)

	local judgSkinZoom = string.find(name, "lifebarSkin");
	if judgSkinZoom ~= nil then
		return "";
	end;

	local judgSkinZoom = string.find(name, "judgeskinzoom");
	if judgSkinZoom ~= nil then
		judgSkinZoom = string.find(name, "/");		
		if judgSkinZoom ~= nil then
			return "";
		else
			return cwMainDescription[gLANG() .. "judgeskinzoom"];
		end;
	end;




	local judgSkinName = string.find(name, "judgeskin");
	if judgSkinName ~= nil then
		--titulo?
		judgSkinName = string.find(name, "/");
		if judgSkinName ~= nil then
			local procNameText = string.gsub(name, "judgeskin/", "");
			procNameText = string.gsub(procNameText, "I_", "");
			procNameText = string.gsub(procNameText, "E_", "");

			local localeTextName = cwMainDescription[gLANG() .. "judgeskin/GENERICTEXT"];
			localeTextName = string.gsub(localeTextName, "##", procNameText);

			return localeTextName;
		else
			return cwMainDescription[gLANG() .. "judgeskin"];
		end;	  	
	end;	


	local lifebarSkin = string.find(name, "lifebarskin");
	if lifebarSkin ~= nil then
		--titulo?
		lifebarSkin = string.find(name, "/");
		if lifebarSkin ~= nil then
			local procNameText = string.gsub(name, "lifebarskin/", "");
			procNameText = string.gsub(procNameText, "I_", "");
			procNameText = string.gsub(procNameText, "E_", "");

			local localeTextName = cwMainDescription[gLANG() .. "lifebarskin/GENERICTEXT"];
			localeTextName = string.gsub(localeTextName, "##", procNameText);

			return localeTextName;
		else
			return cwMainDescription[gLANG() .. "lifebarskin"];
		end;	  	
	end;

	local companion = string.find(name,"companion");
	if companion ~= nil then
		companion = string.find(name, "/");
		if companion ~= nil then
			local procNameText = string.gsub(name, "companion/", "");
			local localeTextName = cwMainDescription[gLANG() .. "companion/GENERICTEXT"];
			localeTextName = string.gsub(localeTextName, "##", procNameText);

			return localeTextName;
		else
			return cwMainDescription[gLANG() .. "companion"];
		end;
	end;


	if (cwMainDescription[gLANG() .. name] == nil ) then
		if (string.find(name, "note skin")) then
			local procNameText = string.sub(name, 11) .. " Skin"
			local localeTextName = cwMainDescription[gLANG() .. "note skin/GENERICTEXT"]
			if string.find(localeTextName, "##", 1, true) then
				return string.gsub(localeTextName, "##", procNameText)
			end
			return localeTextName .. procNameText
		else
			return ""
		end
	end
	
	return cwMainDescription[gLANG() .. name]
end

local noteskin_BL = { "default", "xsanity", "perfor1", "perfor2", "perfor3", "aadmb", "aadmr", "aadmy", "infinity-routine-p1", "infinity-routine-p2", "infinity-routine-p3", "infinity-routine-p4", "phoenix-p1", "phoenix-p2", "phoenix-p3", "phoenix-p4", "phoenix-p5", "mission-gh", "mission-incubator", "tarotsrune", "sanityp1", "sanityp2", "sanityp3", "sanityp4", "sanityp5" };
--local noteskin_BL = { "default" };
------------------------------------------------------------------------------------
sortMode = 0;

local noteskin_Order = {
	"flower",
	"old",
	"easy",
	"slime",
	"music",
	"canon",
	"poker",
	"nx",
	"sheep",
	"horse",
	"dog",
	"girl",
	"fire",
	"ice",
	"wind",
	"nxa",
	"nx2",
	"lightning",
	"drum",
	"missile",
	"soccer",
	"rebirth",
	"pro-rhythm",
	"pro2-rhythm",
	"infinity",
	"infinity-rhythm",
	"basic",
	"fiesta",
	"fiesta2",
	"prime",
	"prime2",
	"xx",
	"phoenix",
	"phoenix2"
};

function GetNoteSkinLabel(player)
	local ns = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
	local bl = false;
	for j=1,#noteskin_BL do
		if ns==noteskin_BL[j] then bl = true; end;
	end;
	
	if bl then
		return THEME:GetPathG("","_blank");
	else
		if FILEMAN:DoesFileExist("NoteSkins/pump/" .. ns .. "/logo.png")  then
			return "NoteSkins/pump/" .. ns .. "/logo.png";
		else
			return THEME:GetPathG("","_blank");
		end;
	end;
end;


function GetNoteSkinList()
	local toret = {};
	for i=1,#noteskin_Order do
		if NOTESKIN:DoesNoteSkinExist(noteskin_Order[i]) then
			toret[#toret+1]=noteskin_Order[i];
		end;
	end;
	
	local ns_list = NOTESKIN:GetNoteSkinNames();
	for i=1,#ns_list do
		local isinthebl = false;
		for j=1,#noteskin_BL do
			if ns_list[i]==noteskin_BL[j] then isinthebl = true; end;
		end;
		for j=1,#noteskin_Order do
			if ns_list[i]==noteskin_Order[j] then isinthebl = true; end;
		end;
		if not isinthebl then
			toret[#toret+1]=ns_list[i];
		end;
	end;
	
	return toret;
end;

function GetPrimaryNoteSkinNum()
	local num = 0;
	for i=1,#noteskin_Order do
		if NOTESKIN:DoesNoteSkinExist(noteskin_Order[i]) then
			num = num + 1;
		end;
	end;

	return num;
end;


function GetSkinName(player)
	return GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin();
end;

--lifebar skin
--acá buscaremos los skins directos de la carpeta interna por ahora. 
function getLifeBarSkinList()
	local lista = {};

    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/ScreenGamePlay_ui/lifebar/";
    local entries = FILEMAN:GetDirListing(directory, true, false);
    local folders = {};

    for _, entry in ipairs(entries) do
        if entry ~= "default" then
            table.insert(folders, "i_"..entry);
        end
    end;

    local lifebarSkinExternalPath = GetLifebarSkinExternalPath();
    local entriesExterno = {};
    if FolderExists(lifebarSkinExternalPath) then
	    entriesExterno = FILEMAN:GetDirListing(lifebarSkinExternalPath, true, false);
	    for _, entry in ipairs(entriesExterno) do
	        table.insert(folders, "e_"..entry);
	    end;
    end;


    return folders;
end;

function getLifebarSkinDataParsed(skinName)
	local esExterno=false;
	local esLua=false;
	local dataExterno = string.find(skinName, "e_");
	local dataIntero = string.find(skinName, "i_");

	local pathSkin = "";	

	local skinNameProcesado = "";
	skinNameProcesado = string.gsub(skinName, "e_", "");
	skinNameProcesado = string.gsub(skinNameProcesado, "i_", "");

	if dataExterno ~= nil then
		esExterno=true;		
	end;

	if dataIntero ~= nil then
	  	esExterno=false;
	end;

	local respuesta = {isExternal=esExterno,name=skinNameProcesado};
	return respuesta;
end;



function GetJudgSkinList()
	local lista = {};

	--obtenemos todas las carpetas del directorio "Graphics/Player judgment/skins"
    --y las carpetas del directorio /Mods/judgmentsSkins en la raiz del juego.
    --vamos a marcar de diferente forma en los 2 casos
    -- carpeta interna del theme parte con i_[nombre skin]
    -- carpeta externa del theme parte con e_[nombre skin]
    local themeName = THEME:GetCurThemeName();
    local directory = "/Themes/" .. themeName .. "/Graphics/Player judgment/skins/";
    local entries = FILEMAN:GetDirListing(directory, true, false);
    local folders = {};

    for _, entry in ipairs(entries) do
        if entry ~= "sanity" then
            table.insert(folders, "i_"..entry);
        end
    end;

    local judgmentSkinExternalPath = GetJudgSkinExternalPath();
    local entriesExterno = {};
    if FolderExists(judgmentSkinExternalPath) then
	    entriesExterno = FILEMAN:GetDirListing(judgmentSkinExternalPath, true, false);
	    for _, entry in ipairs(entriesExterno) do
	        table.insert(folders, "e_"..entry);
	    end;
    end;


    return folders;
end;

-- Iconos en Quest 
local arrCW_Icons = {
	"1X","2X","3X","4X","5X","6X","0.25X","EXPAND",
	"VANISH","APPEAR","NONSTEP","DARK","FLASH","RANDOMNOTE","BGAOFF","BGADARK",
	"FLOWER","OLD","EASY","SLIME","MUSIC","CANON","POKER","NX",
	"PERFOR2","PERFOR3","NXA","NX2","LIGHTNING","DRUM","MISSILE","AADMB",
	"SHEEP","HORSE","DOG","GIRL","FIRE","ICE","WIND","PERFOR1",
	"AADMR","AADMY","SOCCER","REBIRTH","BASIC","FIESTA","FIESTA2","PRIME",
	"XMODE","NXMODE","UNDERATTACK","DROP","0.5X","-100%RISE","100%RISE","SNAKE",
	"BACKWARDS","	*	","SUPERSHUFFLE","BGAPARTIAL","		*	","EASYJUDGEMENT","		*	","HARDJUDGEMENT",
	"VERYHARDJUDGEMENT","EXTRAJUDGEMENT","ULTRAHARDJUDGEMENT","JUDGEREVERSE","HIDEJUDGE","JL","JUDGENOTE","ZIGZAG",
	"0.8XMUSIC","0.9XMUSIC","1.1XMUSIC","1.2XMUSIC","1.3XMUSIC","1.4XMUSIC","1.5XMUSIC","NO",
	"RANDOMVEL","M550","ACCEL","DECEL","RANK","PRIME2","XX", "AUTOPLAY"
}

function GetValidQuestMods(CurrentStep)
	
	local Mods = string.gsub(string.upper(CurrentStep:GetQuestMods()), "%s+", "");
	Mods = split(',', Mods);
	
	if (CurrentStep:GetSeparateNotes() == "YES") then
		table.insert(Mods, "JUDGENOTE");
	end;
	
	local toret = {};
	
	for i=1,#Mods do
		
		if Mods[i] ~= nil then
			for x=1,#arrCW_Icons do
				if Mods[i] == arrCW_Icons[x] then
					table.insert(toret, x);
				end;
			end;
		end;
	end;

	return toret;
end;
-------------------------------------------------------------------------------------------

function CreateTableUserMods( sInput )
	local Mods = string.gsub(string.upper(sInput), "%s+", "");
	Mods = split(',', Mods);
	
	local toret = {};
	
	for i=1,#Mods do
		
		if Mods[i] ~= nil then
			for x=7,#arrCW_Icons do
				if Mods[i] == arrCW_Icons[x] then
					table.insert(toret, x);
				end;
			end;
		end;
	end;

	return toret;
end;

--get the INDEX of the option selected.
function CW_getIndexModSelectedFromModList(list,actualSelection)
	for i = 1, #list do
		
		if list[i].command == actualSelection then
			return i;
		end;
	end;
	return 1;
end;

function CW_getSkinJudgmentPreviewByPlayer(player)
	local skinPlayer = getCustomOptionValuePlayer(player,"judgmentSkin");

	if skinPlayer == nil then
		skinPlayer = "i_sanity";
	end;

	local skinExterno=false;

	local esExterno = string.find(skinPlayer, "e_");
	if esExterno ~= nil then
		skinExterno = true;
	end;

	local skinSelectedProfileProc = string.gsub(skinPlayer, "e_", "");
	skinSelectedProfileProc = string.gsub(skinSelectedProfileProc, "i_", "");

	--comprobamos archivo por archivo si existe para mostrarse.
	local skinJudgText = getSkinJudgmentTemplateNew("judgments",skinSelectedProfileProc,skinExterno);
	local skinComboLabel = getSkinJudgmentTemplateNew("combo",skinSelectedProfileProc,skinExterno);
	local skinComboNumber = getSkinJudgmentTemplateNew("comboNumber",skinSelectedProfileProc,skinExterno);
	local skinIcon = getSkinJudgmentTemplateNew("icon",skinSelectedProfileProc,skinExterno);
	local skinSelected = {skinJudgText,skinComboLabel,skinComboNumber,skinIcon};
	return skinSelected;
end;

function CW_getSkinJudgmentPreviewBySkinName(skinPlayer)
	if skinPlayer == nil then
		skinPlayer = "i_sanity";
	end;

	local skinExterno=false;

	local esExterno = string.find(skinPlayer, "e_");
	if esExterno ~= nil then
		skinExterno = true;
	end;

	local skinSelectedProfileProc = string.gsub(skinPlayer, "e_", "");
	skinSelectedProfileProc = string.gsub(skinSelectedProfileProc, "i_", "");

	--comprobamos archivo por archivo si existe para mostrarse.
	local skinJudgText = getSkinJudgmentTemplateNew("judgments",skinSelectedProfileProc,skinExterno);
	local skinComboLabel = getSkinJudgmentTemplateNew("combo",skinSelectedProfileProc,skinExterno);
	local skinComboNumber = getSkinJudgmentTemplateNew("comboNumber",skinSelectedProfileProc,skinExterno);
	local skinSelected = {skinJudgText,skinComboLabel,skinComboNumber};
	return skinSelected;
end;

function CW_subStep(value, step)
    local factor = 1 / step
    -- normalizamos al múltiplo más cercano
    value = math.floor(value * factor + 0.5) / factor
    -- restamos y aseguramos lower
    return math.floor((value - step) * factor + 1e-9) / factor
end

function CW_addStep(value, step)
    local factor = 1 / step
    -- normalizamos al múltiplo más cercano
    value = math.floor(value * factor + 0.5) / factor
    -- sumamos y aseguramos upper
    return math.ceil((value + step) * factor - 1e-9) / factor
end