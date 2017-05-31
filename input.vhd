--Como inicializar com o saidaJogada com 0? :(

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

ENTITY input IS
	PORT(	switches: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			reset: IN STD_LOGIC;
			pushButton: IN STD_LOGIC;
			saidaJogada: BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
			isStrike: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE Behavior OF input IS
	SIGNAL um: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	um <= "0001";
	
	PROCESS (pushButton) 
	BEGIN
		IF reset='1' THEN 
			saidaJogada<="0000";
		END IF;
		
		IF pushButton='1' THEN
			gen: FOR i IN 0 TO 9 LOOP
				IF switches(i)='1' THEN saidaJogada <= saidaJogada + um;
				END IF;
			END LOOP;
		END IF;
	END PROCESS;
	
	WITH saidaJogada SELECT
		isStrike <= '1' WHEN "1010",
						'0' WHEN OTHERS;
END Behavior;