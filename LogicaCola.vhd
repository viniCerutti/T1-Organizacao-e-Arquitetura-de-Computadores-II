library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 


entity LogicaCola is
    port(
    clock: in std_logic;   --                     
    reset: in std_logic;   --                     
    
    --data: in std_logic_vector(31 downto 0); --
    address: in std_logic_vector(31 downto 0); --
    
    ce: in std_logic;    --                     
    rw: in std_logic;      --                    
    mem_ce : out std_logic --
    
    --rx_data: out std_logic_vector (7 downto 0);  
    --rx_start: out std_logic;                     
    --rx_busy: in std_logic;                     

    --tx_data: in std_logic_vector (7 downto 0); 
    --tx_av: in std_logic                        
  );
end LogicaCola;

architecture LogicaCola of LogicaCola is
begin
    process (reset,ce)
        begin
				if reset = '1' then
					mem_ce <= '1';
				end if;	
						if ce='0' then
						 if address /= x"10010000" and 
							 address /= x"10010004" and
							 address /= x"10010008" and 
							 address /= x"1001000c" and 
							 address /= x"10010010" 
						 then
							  mem_ce <= '0';
						 else mem_ce <= '1';
						 end if;
					end if;
				
					

    end process;
end LogicaCola;
