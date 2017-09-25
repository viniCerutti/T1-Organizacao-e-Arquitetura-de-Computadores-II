-------------------------------------------------------------------------
--  TEST_BENCH PARA SIMULACAO DA SERIAL 
--  Simular por 100 microssegundos
-------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;          

entity serial_tb is
end serial_tb;

architecture serial_tb of serial_tb is
	signal sckg, reset, txd, rx_start, rxd :std_logic; 
	signal av, ack: std_logic;
	signal Sin, Sout : std_logic_vector(7 downto 0);    
	constant B1 : time := 1000 ns;     
	constant B2 : time := B1*2;     
	constant B3 : time := B1*3;     
	constant B4 : time := B1*4;     
	constant B5 : time := B1*5;     
	constant B6 : time := B1*6;     
	constant B7 : time := B1*7;     
	constant B8 : time := B1*8;     
	constant B9 : time := B1*9;     
	constant B10 : time := B1*10;     

begin
        -------------------------------------------------------------------------------------
serial_inst : entity work.serialinterface port map (       
       clock    => sckg,
       reset    => reset,  
       rx_data  => sin,
       rx_start => rx_start,
       rx_busy  => ack, 
       rxd      => rxd,
       txd      => txd, 
       tx_data  => sout,
       tx_av    => av
    );  
   
	-------------------------------------------------------------------------------------
	-- Processo que simula o hospedeiro enviando dados para o periférico. 
	-- Manda-se dados depois que a simulação já está executando por 20 microssegundos.
	--
	-- Assume-se que antes disto o periférico já programou a velocidade da interface
	-- serial para adaptá-la a sua velocidade (ver abaixo o processo que simula o 
	--	periférico)
	--
	-- Envia-se 4 valores de 8 bits na seguinte ordem, a intervalos de 20 microssegundos:
	-- 0x37, 0x9A, 0x00 e 0xFF
	--
	-- O processo está concluído após uns 100 microssegundos.
	-------------------------------------------------------------------------------------
   sin <=(others=>'0'), 
			x"37" after 20 us, x"9A" after 40 us,
			x"00" after 60 us, x"FF" after 80 us;

   rx_start <= '0', '1' after 20020 ns, '0' after 20070 ns, 
					'1' after 42020 ns, '0' after 42090 ns,
					'1' after 62020 ns, '0' after 62090 ns,
					'1' after 82020 ns, '0' after 82090 ns;

	-------------------------------------------------------------------------------------
	-- Processo de geração do clock para o hospedeiro e para a interface serial. O clock
	-- apresenta uma frequencia em torno de 30MHz
	-------------------------------------------------------------------------------------
        process								-- gera o clock
        begin
				sckg <= '1', '0' after 16.66 ns;
            wait for 33ns;
        end process;
        
        reset <='1', '0' after 20ns;	-- gera o reset
    
	-------------------------------------------------------------------------------------
	-- Processo que simula o periférico enviando dados para o hospedeiro. 
	-- Primeiro o periférico programa a MEF de autobaud, enviando o valor de 
	-- aferição de velocidade 0x55H. Em seguida o processo envia 4 valores de 8 bits:
	-- 0x87, 0x5F, 0x00 e 0xFF
	-- O processo está concluído após 56,496 microssegundos. 
	--	Se a simulação continuar depois de uns 100 microssegundos o processo de 
	-- envio do periférico começa a ser repetido.
	-------------------------------------------------------------------------------------
    process	-- 55H (valor de aferição), 87H, 5FH, 00H, FFH
        begin
        txd <= '1', '0' after B1, '1' after B2, 
					'0' after B3, '1' after B4, 
					'0' after B5, '1' after B6, 
					'0' after B7, '1' after B8, 
					'0' after B9, '1' after B10;
        wait for B1*11;
					 
        txd <= '0', '1' after B1, 
					'1' after B2, '1' after B3,
					'0' after B4, '0' after B5, 
					'0' after B6, '0' after B7, 
					'1' after B8, '1' after B9;
        wait for B1*10;
					 
        txd <= '0', '1' after B1, 
					'1' after B2, '1' after B3,
					'1' after B4, '1' after B5, 
					'0' after B6, '1' after B7, 
					'0' after B8, '1' after B9;
        wait for B1*16;
					 
        txd <= '0', '0' after B1, 
					'0' after B2, '0' after B3,
					'0' after B4, '0' after B5,
					'0' after B6, '0' after B7,
					'0' after B8, '1' after B9;
        wait for B1*10;
					 
        txd <= '0', '1' after B1,
					'1' after B2, '1' after B3,
					'1' after B4, '1' after B5,
					'1' after B6, '1' after B7,
					'1' after B8, '1' after B9;
        wait for B1*10;
		  
		  wait for 50us; 	-- acrescentado para evitar que processo repita depois de apenas uns
								-- 50 microssegundos
		  
        end process;      
    
 
end serial_tb;