-------------------------------------------------------------------------
--  TEST_BENCH PARA SIMULACAO DA SERIAL 
--  Simular por 100 microssegundos
-------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;          

entity mySerialTB is
	port (
		 clock: in std_logic;                    
    	 reset: in std_logic;  
    	 rxd: in std_logic; 
    	 txd: out std_logic

	);
end mySerialTB;

architecture mySerialTB of mySerialTB is

	type State_typeReceiver is (a,b,c,d);
	signal State_nextReceiver, StateReceiver : State_typeReceiver;

	type State_typeSend is (a1,b1,c1,d1);
	signal State_nextSend, StateSend  : State_typeSend;

	signal contBits : std_logic_vector(7 downto 0);
	signal contVetor : std_logic_vector(7 downto 0);

    type data_memInf is array(0 to 1) of std_logic_vector(7 downto 0);
	signal memInf : data_memInf := (others => (others => '0'));

begin
	process (reset, clock)
	begin
		if (reset = '1') then
			contBits <= x"08";
			contVetor <= x"00";
			StateReceiver <= a;
			StateSend <= a1;
		elsif (clock'EVENT and clock = '1') then
			StateReceiver <= State_nextReceiver;
			StateSend <= State_nextSend;
		end if;
	end process;


	process (StateReceiver)
	begin
		case StateReceiver is
		when a =>
			contBits <= x"08";
			contVetor <= x"00";
			if(rxd = '0') then
				State_nextReceiver <= b;
			else State_nextReceiver <= a;
			end if;
		when b =>
			contBits <= contBits - x"01";
			memInf(CONV_INTEGER(contVetor))(CONV_INTEGER(contBits)) <= rxd;
			if (contVetor <= x"01") then
				State_nextReceiver <= c;
			else State_nextReceiver <= b;
			end if;
		when c =>
			if(rxd = '1') then 
				State_nextReceiver <= a;
				contVetor <= contVetor + x"01";
			else State_nextReceiver <= c;
			end if;
		when others => 
					State_nextReceiver <= a;
		end case;
	end process;


	process (StateSend)
	begin
		case StateSend is
		when others => 
					State_nextSend <= a1;
		end case;
	end process;

end mySerialTB;