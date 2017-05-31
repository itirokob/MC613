LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

ENTITY logicaDeControle IS
	PORT(	switches: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			reset: IN STD_LOGIC;
			pushButton: IN STD_LOGIC;
			scoreJ0, scoreJ1, scoreJ2, scoreJ3, scoreJ4, scoreJ5: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			over: BUFFER STD_LOGIC);
END ENTITY;

ARCHITECTURE Behavior OF logicaDeControle IS
--Vetores de 8 posicoes para 2 jogadas: 4 bits para cada jogada. É resetado toda vez que trocar o turno.
SIGNAL tempScoreJ0, tempScoreJ1, tempScoreJ2, tempScoreJ3, tempScoreJ4, tempScoreJ5: STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL jogadasJ0, jogadasJ1, jogadasJ2, jogadasJ3, jogadasJ4, jogadasJ5: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL strikeNaJogadaJ0, strikeNaJogadaJ1, strikeNaJogadaJ2, strikeNaJogadaJ3, strikeNaJogadaJ4, strikeNaJogadaJ5: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL spareJ0, spareJ1, spareJ2, spareJ3, spareJ4, spareJ5: STD_LOGIC;
SIGNAL spareJogadorAtual: STD_LOGIC;
SIGNAL jogadaAtual: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL strikeJogadaAtual: STD_LOGIC;
SIGNAL strikeJogadorAtual: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL contadorJogadas: INTEGER RANGE 0 TO 2;
SIGNAL contadorTurnos: INTEGER RANGE 0 TO 10;
SIGNAL jogadorDaVez: INTEGER RANGE 0 TO 6;
SIGNAL scoreJogadorDaVez: STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL enableCalculaScore:STD_LOGIC;

COMPONENT input IS
	PORT(	switches: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			reset: IN STD_LOGIC;
			pushButton: IN STD_LOGIC;
			saidaJogada: BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
			isStrike: OUT STD_LOGIC);
END COMPONENT;

COMPONENT calculaScore IS
	PORT(	enableCalculaScore: IN STD_LOGIC;
			scoreAtual: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			strike: BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
			spare: BUFFER STD_LOGIC;
			pushButton: IN STD_LOGIC;
			jogada0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			jogada1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			novoScore: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			newSpare: OUT STD_LOGIC);
END COMPONENT;

BEGIN
	PROCESS(pushButton)
	BEGIN
		IF reset='1' THEN 
			contadorJogadas <= 0;
			contadorTurnos <= 0;
			jogadorDaVez <= 0;
			enableCalculaScore <='0';
			tempScoreJ0 <= "000000000";
			tempScoreJ1 <= "000000000";
			tempScoreJ2 <= "000000000";
			tempScoreJ3 <= "000000000";
			tempScoreJ4 <= "000000000";
			tempScoreJ5 <= "000000000";
			jogadasJ0 <= "00000000";
			jogadasJ1 <= "00000000";
			jogadasJ2 <= "00000000";
			jogadasJ3 <= "00000000";
			jogadasJ4 <= "00000000";
			jogadasJ5 <= "00000000";
			strikeNaJogadaJ0 <= "00";
			strikeNaJogadaJ1 <= "00";
			strikeNaJogadaJ2 <= "00";
			strikeNaJogadaJ3 <= "00";
			strikeNaJogadaJ4 <= "00";
			strikeNaJogadaJ5 <= "00";
			spareJ0 <= '0'; 
			spareJ1 <= '0';
			spareJ2 <= '0';
			spareJ3 <= '0';
			spareJ4 <= '0';
			spareJ5 <= '0';
		END IF;
		
		IF contadorTurnos=10 THEN over<='1';
		END IF;
		
		--Pelo pushButton contaremos o numero de jogadas e de turnos
		IF pushButton='1' THEN 
			contadorJogadas<=contadorJogadas+1;
			--TO CONFUSA COM O SPARE
			IF contadorJogadas=3 THEN
				CASE jogadorDaVez IS
					WHEN 0 => 
						spareJ0 <= '0';
						strikeNaJogadaJ0 <= "00";
					WHEN 1 => 
						spareJ1 <= '0';
						strikeNaJogadaJ1 <= "00";
					WHEN 2 => 
						spareJ2 <= '0'; 
						strikeNaJogadaJ2 <= "00";
					WHEN 3 =>
						spareJ3 <= '0'; 
						strikeNaJogadaJ3 <= "00";
					WHEN 4 => 
						spareJ4 <= '0';
						strikeNaJogadaJ4 <= "00";
					WHEN OTHERS => --5, na verdade
						spareJ5 <= '0';
						strikeNaJogadaJ5 <= "00";
				END CASE;
				
				jogadorDaVez<=jogadorDaVez+1;
				contadorJogadas<=1;
			END IF;
			
			--Se o jogador da vez chegou em 6, reset
			IF jogadorDaVez=6 THEN 
				jogadorDaVez<=0;
				contadorTurnos<= contadorTurnos + 1;
			END IF;
			
			IF over='0' THEN
				--Selecionando as infos do jogador da vez
				IF jogadorDaVez=0 THEN 
					scoreJogadorDaVez<=tempScoreJ0;
					strikeJogadorAtual<=strikeNaJogadaJ0;
					spareJogadorAtual<=spareJ0;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ0(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ0(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ0(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ0(1);
					END IF;
				
				ELSIF jogadorDaVez=1 THEN 
					scoreJogadorDaVez<=tempScoreJ1;
					strikeJogadorAtual<=strikeNaJogadaJ1;
					spareJogadorAtual<=spareJ1;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ1(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ1(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ1(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ1(1);
					END IF;
					
				ELSIF jogadorDaVez=2 THEN 
					scoreJogadorDaVez<=tempScoreJ2;
					strikeJogadorAtual<=strikeNaJogadaJ2;
					spareJogadorAtual<=spareJ2;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ2(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ2(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ2(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ2(1);
					END IF;
					
				ELSIF jogadorDaVez=3 THEN 
					scoreJogadorDaVez<=tempScoreJ3;
					strikeJogadorAtual<=strikeNaJogadaJ3;
					spareJogadorAtual<=spareJ3;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ3(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ3(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ3(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ3(1);
					END IF;
					
				ELSIF jogadorDaVez=4 THEN 
					scoreJogadorDaVez<=tempScoreJ4;
					strikeJogadorAtual<=strikeNaJogadaJ4;
					spareJogadorAtual<=spareJ4;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ4(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ4(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ4(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ4(1);
					END IF;
					
				ELSIF jogadorDaVez=5 THEN 
					scoreJogadorDaVez<=tempScoreJ5;
					strikeJogadorAtual<=strikeNaJogadaJ5;
					spareJogadorAtual<=spareJ5;
					
					IF contadorJogadas=1 THEN 
						jogadaAtual<=jogadasJ5(3 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ5(0);
					ELSIF contadorJogadas=2 THEN 
						jogadaAtual<=jogadasJ5(7 DOWNTO 0);
						strikeJogadaAtual <= strikeNaJogadaJ5(1);
					END IF;
				END IF;	
			END IF;
		END IF;
			
		IF contadorJogadas=2 THEN enableCalculaScore<='1';
		END IF;
		
	END PROCESS;
	
	inp: input PORT MAP(switches, '1', pushButton, jogadaAtual, strikeJogadaAtual);
	calc: calculaScore PORT MAP(enableCalculaScore, scoreJogadorDaVez, strikeJogadorAtual, spareJogadorAtual, pushButton, jogadaAtual(3 DOWNTO 0), jogadaAtual(7 DOWNTO 4), scoreJogadorDaVez, spareJogadorAtual);
	
	PROCESS (jogadorDaVez)
	BEGIN
	--Reatualizando os scores
		CASE jogadorDaVez IS
			WHEN 0 => 
				spareJ0 <= spareJogadorAtual;
				tempScoreJ0 <= scoreJogadorDaVez;
			WHEN 1 => 
				spareJ1 <= spareJogadorAtual;
				tempScoreJ1 <= scoreJogadorDaVez;
			WHEN 2 => 
				spareJ2 <= spareJogadorAtual;
				tempScoreJ2 <= scoreJogadorDaVez; 
			WHEN 3 =>
				spareJ3 <= spareJogadorAtual;
				tempScoreJ3 <= scoreJogadorDaVez; 
			WHEN 4 => 
				spareJ4 <= spareJogadorAtual;
				tempScoreJ4 <= scoreJogadorDaVez; 
			WHEN OTHERS => --5, na verdade
				spareJ5 <= spareJogadorAtual;
				tempScoreJ5 <= scoreJogadorDaVez; 
		END CASE;	
	END PROCESS;
END Behavior;