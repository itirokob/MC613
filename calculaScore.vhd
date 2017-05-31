LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

ENTITY calculaScore IS
	PORT(	enableCalculaScore: IN STD_LOGIC;
			scoreAtual: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			strike: BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0);
			spare: BUFFER STD_LOGIC;
			pushButton: IN STD_LOGIC;
			jogada0: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			jogada1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			novoScore: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			newSpare: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE Behavior OF calculaScore IS
SIGNAL weight: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL strike0, strike1, initialSpare: STD_LOGIC;

BEGIN
	strike1 <= strike(1);
	strike0 <= strike(0);
	initialSpare <= spare;
	
	PROCESS (pushButton)
	BEGIN
		IF enableCalculaScore='1' THEN
			IF pushButton='1' THEN
				--Calculando quando os pontos da jogada devem ser somados
				IF strike1='1' THEN novoScore <= scoreAtual+jogada0;
				ELSIF initialSpare='1' THEN novoScore <= scoreAtual+jogada0;
				END IF;
				IF strike0='1' THEN novoScore <= scoreAtual+jogada0; 
				END IF;
				
				IF strike1='1' THEN novoScore <= scoreAtual+jogada1;
				ELSIF initialSpare='1' THEN novoScore <= scoreAtual+jogada1;
				END IF;
				IF strike0='1' THEN novoScore <= scoreAtual+jogada1; 
				END IF;

				strike(1) <= strike(0);
				
				IF jogada0="1010" THEN 
					strike(1) <='1';
					spare <= '0';
				ELSE
					strike(1) <= '0';
					--Calculando quando os pontos da jogada devem ser somados
					IF strike1='1' THEN novoScore <= scoreAtual+jogada0;
					ELSIF initialSpare='1' THEN novoScore <= scoreAtual+jogada0;
					END IF;
					
					IF strike0='1' THEN novoScore <= scoreAtual+jogada0;
					END IF;	
					
					IF strike1='1' THEN novoScore <= scoreAtual+jogada1;
					ELSIF initialSpare='1' THEN novoScore <= scoreAtual+jogada1;
					END IF;
					IF strike0='1' THEN novoScore <= scoreAtual+jogada1; 				
					END IF;
					
					IF jogada0 + jogada1 = "1010" THEN 
						spare <= '1';
					ELSE
						spare <= '0';
					END IF;				
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	newSpare <= spare;
END Behavior;