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
	["EN-info"] = 		"Set the gameplay information.";	--9

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
	["EN-display/BGA DARK"] = 			"Deactive the song's BGA";
	["EN-display/BGA PARTIAL"] = 		"Deactive the song's BGA";
	["EN-display/MI"] =					"Makes notefield zoomed out";
	
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
	["EN-alternate/M"] =		"Rotate the song's steps by 180 degrees";
	["EN-alternate/RS"] =		"Randomize the appearance of the steps";
	["EN-alternate/SS"] =		"Swap sides song's steps";
	
	--judge
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
	["EN-lifebarsettings"] = 	"Choose the life bar behavior";
	["EN-lifebarsettings/BREAKONLIFEBAR"] = 	"Enable or disable song break. If ON, the song will break when the player's life bar reaches 0";		
	["EN-lifebarsettings/GENERICTEXT"] = 	"-";	


	["EN-timingadj"] = 	"Tweak the timing - you can shift the notechart to start a bit earlier or later.";
	["EN-timingadj/GENERICTEXT"] = 	"";	

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
	["info"] = 			"Establece la información disponible en el juego.";	--9
	
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
	["alternate/M"] =		"Los pasos se muestran al revéz";
	["alternate/RS"] =		"Los pasos se muestran al azar";
	["alternate/SS"] =		"Los pasos se muestran del lado opuesto";
	
	--judge
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
	["lifebarskin/BREAKONLIFEBAR"] = 	"Activa o desactiva el Song Break, si la vida del jugador llega 0, la canción termina.";		
	["lifebarskin/GENERICTEXT"] = 	"-";	

	["timingadj"] = 	"Ajusta el timing - puedes mover el notechart para que empiece un poco antes o después";
	["timingadj/GENERICTEXT"] = 	"";	

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
	
	["PT-av"] = 		"Defina a velocidade desejável em Auto Velocity.";		--9

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
	["PT-alternate/SS"] =		"Trocar os lados das etapas da música ";
	
	--judge
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
	["PT-lifebarskin/BREAKONLIFEBAR"] = 	"Ativa ou desativa o Song Break; se a vida do jogador chegar a 0, a música termina.";		
	["PT-lifebarskin/GENERICTEXT"] = 	"-";	

	["PT-timingadj"] = 	"Ajuste o timing - você pode mudar se o notechart começa um pouco antes ou depois.";
	["PT-timingadj/GENERICTEXT"] = 	"";	


}

local langTextMisc = {
		["EN-F9"] =	 "P1 PROFILE";
		["EN-F10"] = "P2 PROFILE";
		["EN-F11"] = "SEARCH SONG";
		["EN-F8"] = "PROFILE EDITOR";
		["EN-F7"] = "PERFORMANCE MODE";

		["F9"] =  "P1 PERFIL";
		["F10"] = "P2 PERFIL";
		["F11"] = "BUSCAR CANCION";
		["F8"] = "EDITOR DE PERFIL";
		["F7"] = "MODO RENDIMIENTO";

		["PT-F9"] =	 "P1 PERFIL";
		["PT-F10"] = "P2 PERFIL";
		["PT-F11"] = "BUSCAR MUSICA";				
		["PT-F8"] = "PROFILE EDITOR";
		["PT-F7"] = "MODO DE DESEMPENHO";
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
}

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


	if (cwMainDescription[gLANG() .. name] == nil ) then
		if (string.find(name, "note skin")) then
			return cwMainDescription[gLANG() .. "note skin/GENERICTEXT"].. string.sub(name, 11) .. " Skin"
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
	"phoenix"
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

