library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
---------------------------------------------
-- 0x10008000  - tx_data
-- 0x10008001  -  tx_av
-- 0x10008002  - rx_data
-- 0x10008003  - rx_start
-- 0x10008004  - r_busy
---------------------------------------------
-- TESTADOS
-- ENDEREÇOS DIFERENTES DO PERIFERICO SEGUIDAMENTE
-- rx_busy
-- rx_data, rx_start
-- tx_av, tx_data = tx_disponivel = '1'

-- se ligar com a instrucao SBm
---------------------------------------------
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
	signal tx_dado_ja_lido : std_logic := '0';
	signal tx_dataReg, rx_dataReg : std_logic_vector (7 downto 0);
	signal auxData : std_logic_vector (31 downto 0);

begin
	
	ce_Serial <= '1' when (ce='0' and address >= x"10008000" and address <= x"10008004") else '0';
	mem_ce <= '1' when (ce_Serial = '1' or ce='1') else '0'; -- bug corrigido 07/09 mem_ce tava invertido os sinais
															 -- bug corrigido 09/09 mem_ce estaba habilitado quando não era sw ou lw

	process (reset, clock)
	begin
		if (reset = '1') then
			State <= a;
		elsif (clock'EVENT and clock = '1') then
			State <= State_next;
		end if;
	end process;

	process (State, ce_Serial)
		begin
			case State is
				when a =>
					rx_start <= '0';
					if (ce_Serial ='1') then -- que dizer que não estou mexendo com a memoria e sim com periferico
					-- leitura do endereço rx_busy
						if (address = x"10008004" and rw = '1') then
						-- CUIDADO POSSIVELMENTE BUG NA ORDEM DESTES IF'S 07/09
							if (rx_busy = '0') then 
								auxData <= x"00000000";
								State_next <= b;
							else 
								auxData <= x"00000001";
								State_next <=  a;
							end if;
							else if(data(0) = '0') then
								State_next <=  a;
							end if;
						end if;

					-- leitura do endereço tx_av
						if (address = x"10008001" and rw = '1') then
							if(tx_av = '1' and tx_dado_ja_lido = '0') then -- flag de tx_dado_ja_lido
								auxData <= x"00000001";
								tx_dataReg <= tx_data;
								State_next <=  c;
							else 
								tx_dado_ja_lido <= '0';
								auxData <= x"00000000";
								State_next <=  a;
							end if;
						end if;

					else State_next <= a; -- to mexendo com a memoria então permance neste estado
					end if;

				when b => 
					-- escrita no endereço rx_data
						if (ce_Serial = '1' and address = x"10008002" and rw = '0') then
							rx_dataReg <= data(7 downto 0);
							State_next <=  d;
						else 
							State_next <= b;
						end if ;
				when c =>
					-- Leitura no endereço tx_data
						 if (ce_Serial = '1' and address = x"10008000" and rw = '1') then -- corrigido 08/09 rw = '0'
						 		auxData <= x"000000"&tx_dataReg;
						 		tx_dado_ja_lido <= '1'; -- corrigido 08/09 faltou esta linha
						 		State_next <= a;	  -- corrigido 08/09 faltou esta linha -- VERIFICAR SE VOLTA PARA 
						 							  -- O INICIO DEPOIS DESTE ESTADO 
						 else 
						 	State_next <= c;		-- se não for uma Leitura no endereço tx_data					  
						 end if;
				when d => 
					-- -- escrita no endereço rx_start
						if (ce_Serial = '1' and address = x"10008003" and rw = '0' and data(0) = '1') then
							rx_start <= '1';
							rx_data <= rx_dataReg; -- corrigido 07/09 bug antes estava com data
							State_next <= a;
						else State_next <= d;
						end if;
				when others => 
					State_next <= a;
		end case;
    end process;
   data <= auxData when (ce_Serial='1' and rw ='1') else (others=>'Z');  -- corrigido 07/09 bug com DATA assim não atrapalha entrada e saida de dados
   																		 -- corrigido 07/09 a saida saia para quando leitura quando escrita
end FsmLogicaCola;
