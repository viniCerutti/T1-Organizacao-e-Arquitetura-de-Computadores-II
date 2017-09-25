--#############################################################################
--
--   Controlador de interface serial com autobaud - versão sem CTS nem RTS!
--	
--  Descrição: 
--			Trata-se de uma implementação full-duplex de um controlador de
--		interface serial que pode se adaptar à velocidade de transmissão 
--		do periférico. Ele interage com um processador via handshake assíncrono
--		de comunicação, também chamado aqui hospedeiro ou host. A interface
--		com o host é de 8 bits, também full-duplex.
--	Operação:
--			Após a inicialização do controlador (via reset), o periférico deve
--		mandar o dado 0x55 (equivalente a 01010101 em binário) na sua velocidade.
--		Este valor habilita a interface a ajustar sua velocidade àquela do
--		periférico. A velocidade do host não é controlada mas tipicamente deve 
--		ser bem mais alta que esta, tal como 30MHz/50MHz/100MHz ou até mais alta.
--		A interface opera com o relógio do host.
--		Assume-se aqui que a velocidade do periférico será tipicamente entre
--		1.200 e 115.200 bits por segundo (ou qualquer velocidade entre estas,
--		em múltiplos de 1.200 bps) a faixa de velocidades de uma interface serial
--		típica. 
--	Observações:
--			 Nada é assumido sobre a necessidade de sincronizar o relógio do host
--		e do periférico.
--
-- Sinais da Interface
--    clock     -- clock
--    reset     -- reset (ativo em 1)
--
--    rxd       -- envia dados pela serial
--    txd       -- dados vindos da serial
--
--    tx_data   -- barramento que contem o byte que vem do pc
--    tx_av     -- indica que existe um dado disponivel no tx_data
-- 
--    rx_data   -- byte a ser transmitido para o pc
--    rx_start  -- indica byte disponivel no rx_data (ativo em 1) 
--    rx_busy   -- fica em '1' enquando envia ao PC (do rx_start ao fim)
--
--             +------------------+
--             | SERIAL           |<---- clock                   
--             |    +--------+    |<---- reset
--        TXD  |    |        |    |
--        --------->|        |=========> tx_data (8bits)
--             |    | SENDER |    |
--             |    |        |---------> tx_av
--             |    |        |    |
--    Lado     |    +--------+    |							Lado
-- Periférico  |                  |						Hospedeiro
--             |    +--------+    |
--             |    |        |    |
--        RXD  |    |        |<========== rx_data (8bits)
--        <---------|RECEIVER|<---------- rx_start
--             |    |        |----------> rx_busy
--             |    |        |    |
--             |    +--------+    |
--             +------------------+
--
--  Revisado por Fernando Moraes em 20/maio/2002
--  Alterado por Ney Calazans em Ago/2017
--
--#############################################################################

--*****************************************************************************   
--   Módulo de interface com periférico serial
--*****************************************************************************   
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity serialinterface is
port(
    clock: in std_logic;                        
    reset: in std_logic;                        

    rxd: out std_logic;                         
    txd: in std_logic;                          

    rx_data: in std_logic_vector (7 downto 0);  
    rx_start: in std_logic;                     
    rx_busy: out std_logic;                     

    tx_data: out std_logic_vector (7 downto 0); 
    tx_av: out std_logic                        
  );
end serialinterface;
 
architecture serialinterface of serialinterface is
 -- sinais do circuito autobaud
 type Sreg_type is (S1, S2, S3, S4, S5);
 signal Sreg	:	Sreg_type; -- Esta é a saída do registrador de estado da MEF autobaud
 signal ctr0	:	STD_LOGIC_VECTOR(16 downto 0);  -- conta o número de clocks do
		-- hospedeiro durante os 4 primeiros tempos em que txd está em 0 durante a 
		-- transmissão de um dado de aferição (0x55) pelo periférico
 signal PUpEdgeCt	:	STD_LOGIC_VECTOR (1 downto 0);  -- conta o número de bordas de subida
		-- durante a transmissão de um dado de aferição (0x55) pelo periférico
 -- sinais de geracao do clock da serial    
 signal host_cycles	:	STD_LOGIC_VECTOR(13 downto 0);      
 signal counter	:	STD_LOGIC_VECTOR(13 downto 0);
 signal serial_clk:	STD_LOGIC; 
 -- sinais de recepção
 signal word, busy:	STD_LOGIC_VECTOR (8 downto 0);
 signal go        :	STD_LOGIC;
 -- sinais de transmissão
 signal regin		:	STD_LOGIC_VECTOR(9 downto 0);   -- 10 bits:  start/byte/stop
 signal resync, r	:	STD_LOGIC;
begin                                                                            

--*****************************************************************************   
-- MEF Autobaud: Inicialmente, o periférico deve enviar 55H (0101 0101) para 
-- esta MEF. Esta conta quantos pulsos de clock 'cabem' em cada '0'.
-- Logo, conta-se 4 vezes. Para se obter o semi-período, divide-se a
-- contagem obtida no estado S5 por 8 (oito).
--
-- Atenção: Note-se que a ordem de envio dos bits é do bit menos significativo
-- (bit 0 da palavra) para o mais significativo (bit 7).
--*****************************************************************************   
  Autobaud_FSM: process (reset, clock)
  begin
    if Reset = '1' then
      Sreg <= S1;				-- Estado inicial da máquina de autobaud é S1
      PUpEdgeCt <= "00";	-- Contador de bordas de subida em txd inicia com 0
      host_cycles <= (OTHERS=>'0');	-- host_cycles é calculado pelo autobaud 
      ctr0 <=(OTHERS=>'0');	-- é o contador de clocks que cabem em quatro
				-- tempos de 0 bit
    elsif clock'event and clock = '1' then
     case Sreg is
       when S1 => if txd = '0'  then	-- a primeira descida de txd é o start bit,
							Sreg <= S2;			-- que dispara o cálculo da MEF autobaud
                     ctr0 <= (OTHERS=>'0');
                  end if;
       when S2 => ctr0 <= ctr0 + 1;	-- Incrementa o número de pulsos de clock
							-- do host que vem do periférico durante a transmissão
							-- do dado de aferição (0x55)
						if txd = '1' then
                     Sreg <= S3;
                     PUpEdgeCt <= PUpEdgeCt + '1';
                  end if;
       when S3 => if PUpEdgeCt /= "00"   and txd = '0' then
                     Sreg <= S2;
                  elsif PUpEdgeCt = "00" and txd = '0' then
                     Sreg <= S4;
                  end if;
       when S4 => if txd = '1' then	-- espera em S4 até aparecer o stop bit (txd='1')
                     Sreg <= S5;		-- Quando isto acontece MEF autobaud concluiu.
                  end if;
       when S5 => Sreg <= S5;			-- Em S5, armazena o número de ciclos contados  
                  host_cycles <= ctr0(16 downto 3);	-- dividido por 8
     end case;
   end if;
  end process; 
    
--*****************************************************************************   
-- SENDER
--*****************************************************************************   
   -- Processo de envio de dados do periférico ao hospedeiro.
   -- Sinais: txd (periférico) e tx_data e tx_av (hospedeiro)
   -- Registrador de deslocamento de 10 bits que lê o dado vindo da serial.
   process (resync, serial_clk)
   begin
     if  resync = '1' then
       regin <= (others=>'1'); -- inicializa todos os bits do registrador com '1'
     elsif serial_clk'event and serial_clk='1' then
       regin <= txd & regin(9 downto 1); -- bit vindo do periférico
						-- entra pela esquerda do registrador de deslocamento
     end if;
   end process;
  
   -- O processo abaixo detecta o start bit, gerando o sinal de resincronismo
	-- resync. O sinal host_cycles em 0 funciona como um reset do processo.
   process (clock, host_cycles)
   begin
     if host_cycles=0 then 
          r      <= '0';
          resync <= '1';
          tx_data <= (others=>'0'); -- zera os 8 bits de tx_data
          tx_av <= '0';
     elsif clock'event and clock='1' then
        if r='0' and txd='0' then  --- start bit
          r      <= '1';
          resync <= '1';
          tx_av <= '0';
        elsif r='1' and regin(0)='0' then  --- start bit chegou no último bit
          r      <= '0';
          tx_data <= regin(8 downto 1);	-- tx_data recebe os bits de dados recebidos
          tx_av <= '1';							-- ativa o sinal de dado discponível
        else
          resync <= '0'; 
          tx_av <= '0';
        end if;
     end if;
   end process;
  
--*****************************************************************************   
-- RECEIVER - Sinais rxd (periférico), rx_data, rx_start, rx_busy (hospedeiro)
--*****************************************************************************   
   -- Processo de geração do clock para a transmissão serial (serial_clk).
   --	De tempos em tempos este é resincronizado, para ajuste da recepção
   -- dos dados provenientes do hospedeiro.
   process(resync, clock)      
    begin 
      if resync='1' then   
              counter <= (0=>'1', others=>'0'); -- escreve 1 em counter
              serial_clk <='0';		-- ressincroniza o clock da serial
      elsif clock'event and clock='0' then     
        if counter = host_cycles then	-- aguarda que se passem host_cycles
              serial_clk <= not serial_clk; -- gera borda sincronizada
              counter <= (0=>'1', others=>'0');	-- escreve 1 em counter
        else
              counter <= counter + 1;	-- maior parte das vezes passa aqui
        end if;
    end if;       
   end process;
	
   -- Registrador de deslocamento - fica colocando '1' na linha de dados.
   -- Quando o usuário requer dados (pulso em rx_start) coloca-se o start bit e o
   -- byte a ser transmitido
   process(rx_start, reset, serial_clk)
     begin     
       if rx_start='1' or reset='1' then   
           go      <= rx_start ;
           rx_busy <= rx_start ;
           word    <= (others=>'1'); -- todos os 9 bits em '1' inicialmente
           busy    <= (others=>'0'); -- busy, inicialmente livre p/ receber 9 bits
       elsif serial_clk'event and serial_clk ='1' then
           go <= '0';  -- desce o go um ciclo depois
           if go='1' then      
             word <= rx_data & '0';   -- armazena o byte que é enviado à serial 
             busy <= (8=>'0', others=>'1');
           else
             word <= '1' & word(8 downto 1); -- desloca para a esquerda word
             busy <= '0' & busy(8 downto 1); -- e busy
             rx_busy <= busy(0); -- rx_busy fica ocupado enquanto enviando start e bits
											-- de dados
           end if;
      end if; 
    end process;    
    
    rxd <= word(0);	-- bit de saída, que vai para o periférico. Pode mudar a cada
							-- borda de serial_clk
   
end serialinterface;