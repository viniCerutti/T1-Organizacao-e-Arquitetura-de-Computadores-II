library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 


entity FsmLogicaCola is
    port(
    clock: in std_logic;   --                     
    reset: in std_logic;   --                     
    
    data: inout std_logic_vector(31 downto 0); --
    address: inout std_logic_vector(31 downto 0); --
    
    ce: in std_logic;    --                     
    rw: in std_logic;      --                    
    mem_ce : out std_logic --
    
    --rx_data: out std_logic_vector (7 downto 0);  
    --rx_start: out std_logic;                     
    --rx_busy: in std_logic;                     

    --tx_data: in std_logic_vector (7 downto 0); 
    --tx_av: in std_logic                        
  );
end FsmLogicaCola;

architecture FsmLogicaCola of FsmLogicaCola is
	type State_type is (a,b,c,d);
	signal State_next, State : State_type;

begin
	process (reset, clock)
	begin
		if (reset = '1') then
			State <= a;
			mem_ce <= '1';
		elsif (clock'EVENT and clock = '1') then
			State <= State_next;
		end if;
	end process;

	process (State, ce)
		begin
			case State is
			when a => 
				if ce='0' then
					if address /= x"10010000" and 
					   address /= x"10010004" and
					   address /= x"10010008" and 
					   address /= x"1001000c" and 
					   address /= x"10010010" 
					then
						mem_ce <= '0';
					else 
						mem_ce <= '1';
						State_next <= b;
					end if;
				end if;
			when b =>
				-- rx_start ativo e no modo de leitura
				if ce ='0' and rw = '0' and address = x"1001000c" then -- faltou a representacao de bit 0 em dado???
					-- mandar os dados para serial
					State_next <= c;
				end if;
			when c => 
			-- leitura no endereço de rx_busy
				if ce ='0' and rw = '1' and address = x"10010010" then
					-- pega o valor de rx_busy coloca no bit 0 do barramento de dados
					-- se este valor ja esta em zero assume que tu acabou 
					State_next <= a;
				end if;
			when others => 
				State_next <= a;
		end case;
    end process;
end FsmLogicaCola;
