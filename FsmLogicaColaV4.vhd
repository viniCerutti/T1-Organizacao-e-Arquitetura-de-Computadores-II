library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 

entity FsmLogicaCola is
    port(
    clock: in std_logic;   --                     
    reset: in std_logic;   --                     
    
    data: inout std_logic_vector(31 downto 0); --
    address: in std_logic_vector(31 downto 0); --
    
    ce: in std_logic;    --                     
    rw: in std_logic;      --                    
    mem_ce : out std_logic; --
    
    rx_data: out std_logic_vector (7 downto 0);  
    rx_start: out std_logic;                     
    rx_busy: in std_logic;                    

    tx_data: in std_logic_vector (7 downto 0); 
    tx_av: in std_logic                        
  );
end FsmLogicaCola;

architecture FsmLogicaCola of FsmLogicaCola is
	type State_type is (a,b,c,d);
	signal State_next, State : State_type;

	signal ce_Serial : std_logic;
	signal auxData : std_logic_vector (31 downto 0);
	signal tx_dataReg, rx_dataReg : std_logic_vector (7 downto 0);

	signal loadRxDataReg, loadTx_dataReg, tx_dado_ja_lido : std_logic := '0';
	signal valor_tx_av : std_logic;
	signal bug :std_logic_vector (3 downto 0);

begin
	ce_Serial <= '1' when (ce='0' and address >= x"10008000" and address <= x"10008004") else '0';
	mem_ce <= '1' when (ce_Serial = '1' or ce='1') else '0';


	process (clock,reset) 
	begin
	if (reset = '1') then 
        rx_dataReg <= x"00"; 
    else if rising_edge(clock) then 
        if (loadRxDataReg = '1') then 
            rx_dataReg <= data(7 downto 0); 
        end if; 
    end if;
    end if;
	end process; 

	process (clock,reset) 
	begin
	 if (reset = '1') then 
        tx_dataReg <= x"00"; 
     else if rising_edge(clock) then 
		if (loadTx_dataReg = '1') then 
            tx_dataReg <= tx_data; 
        end if; 
      end if;
      end if;
	end process; 

	process (clock, tx_av)
	begin
		if rising_edge(clock) then 
		valor_tx_av <= tx_av;
		end if;
	end process;

	process (reset, clock)
	begin
		if (reset = '1') then
			State <= a;
		elsif (clock'EVENT and clock = '1') then
			State <= State_next;
		end if;
	end process;

	process (State, ce_Serial,rw,rx_busy)
		begin
			case State is
				when a => 
					rx_start <= '0';
						if (ce_Serial ='1') then -- que dizer que não estou mexendo com a memoria e sim com periferico
						-- leitura do endereço rx_busy
							if (address = x"10008004" and rw = '1') then
								if (rx_busy = '0') then
									auxData <= x"00000000";
									State_next <= b;
								else 
									auxData <= x"00000001";
									State_next <=  a;
								end if;
							end if;
						-- leitura do endereço tx_av
							if (address = x"10008001" and rw = '1') then
								if(tx_dado_ja_lido = '0') then
									auxData <= x"0000000"&"000"&valor_tx_av;
									loadTx_dataReg <='1';
									State_next <=  d;
								else 
									tx_dado_ja_lido <= '0';
									auxData <= x"0000000"&"000"&valor_tx_av;
									State_next <=  a;
								end if;
							end if;
						else State_next <= a; 
						end if;
				when b => 
						-- escrita no endereço rx_data
						if (ce_Serial = '1' and address = x"10008002" and rw = '0') then
							loadRxDataReg <= '1';
							rx_start <= '1';
							State_next <= c;
						else State_next <= b;
						end if;
				when c => 
						rx_start <='0';
						-- verificar se aquele dado foi enviado
						loadRxDataReg <= '0';
						if (ce_Serial = '1' and address = x"10008004" and rw = '1') then
							if (rx_busy = '0') then 
								bug <= "0001";
								auxData <= x"00000000";
								State_next <= b;
							else 
								bug <= "0010";
								auxData <= x"00000001";
								State_next <=  c;
							end if;
						else if (rx_busy = '0') then -- é assim para outras instrucoes?
								bug <= "0011";
								State_next <= a;
							else 
								bug <= "0100";
								State_next <=  c;
							end if;
						end if;
				when d =>
					-- Leitura no endereço tx_data
						 if (ce_Serial = '1' and address = x"10008000" and rw = '1') then
						 		loadTx_dataReg <='0';
						 		auxData <= x"000000"&tx_dataReg;
						 		tx_dado_ja_lido <= '1'; 
						 		State_next <= a;	  			 
						 else 
						 	State_next <= c;					  
						 end if;
				when others => 
							State_next <= a;
			end case;
    end process;

   rx_data <= rx_dataReg;

   data <= auxData when (ce_Serial='1' and rw ='1') else (others=>'Z');  -- corrigido 07/09 bug com DATA assim não atrapalha entrada e saida de dados
   																		 -- corrigido 07/09 a saida saia para quando leitura quando escrita
end FsmLogicaCola;