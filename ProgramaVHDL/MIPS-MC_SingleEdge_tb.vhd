-------------------------------------------------------------------------
--
-- 32 bits PROCESSOR TESTBENCH    LITTLE  ENDIAN      13/october/2004
--
-- It must be observed that the processor is hold in reset
-- (rstCPU <= '1') at the start of simulation, being activated
-- (rstCPU <= '0') just after the end of the object file reading be the
-- testbench.
--
-- This testbench employs two memories, implying a HARVARD organization
--
-- Changes:
--	16/05/2012 (Ney Calazans)
--		- Corrected bug in memory filling during reset. The instruction
--		memory fill process, makes the processor produce "ce" signals to 
--		memory which ended up by filling data memory with rubbish at
--		the same time. To solve this, the first line of the data memory
--		Dce control signal generation was changed from 
--			--	ce='1' or go_d='1'	 to 
--			-- (ce='1' and rstCPU/='1') or go_d='1'
--		- Also, there was a problem with the data memory write operation in
--		monocycle MIPS implementations: when multiple SW instructions
--		were issued one after the other, the write operation was executed
--		in two sets of memory positions at once after the first SW. To
--		solve this the data signal was removed from the memory write
--		process sensitivity list.
--	10/10/2015 (Ney Calazans)
--		- Signal bw from memory set to '1', since the CPU
--		does not generate it anymore.
--	28/10/2016 (Ney Calazans)
--		- Also, regX defs were changed to wiresX, to improve
--		code readability.
--	02/06/2017 (Ney Calazans) - bugfix
--		- tmp_address changed to int_address in the memory definition
--		-IN the definition of the memory read/write processes,
--		  CONV_INTEGER(low_address+3)<=MEMORY_SIZE was changed to
--		  CONV_INTEGER(low_address)<=MEMORY_SIZE-3
-- 		This avoids an error that freezes the simulation when the
--		   ALU contains a large number (>65533) in its output 
--		   immediately before an LW or SW instruction.
-------------------------------------------------------------------------

library IEEE;
use IEEE.Std_Logic_1164.all;
use std.textio.all;
package aux_functions is  

   subtype wires32  is std_logic_vector(31 downto 0);
   subtype wires16  is std_logic_vector(15 downto 0);
   subtype wires8   is std_logic_vector( 7 downto 0);
   subtype wires4   is std_logic_vector( 3 downto 0);

   -- definio do tipo 'memory', que ser utilizado para as memrias de dados/instrues
   constant MEMORY_SIZE : integer := 2048;     
   type memory is array (0 to MEMORY_SIZE) of wires8;

   constant TAM_LINHA : integer := 200;
   
   function CONV_VECTOR( letra : string(1 to TAM_LINHA);  pos: integer ) return std_logic_vector;
	
	procedure readFileLine(file in_file: TEXT; outStrLine: out string);
   
end aux_functions;

package body aux_functions is

  --
  -- converte um caracter de uma dada linha em um std_logic_vector
  --
  function CONV_VECTOR( letra:string(1 to TAM_LINHA);  pos: integer ) return std_logic_vector is         
     variable bin: wires4;
   begin
      case (letra(pos)) is  
              when '0' => bin := "0000";
              when '1' => bin := "0001";
              when '2' => bin := "0010";
              when '3' => bin := "0011";
              when '4' => bin := "0100";
              when '5' => bin := "0101";
              when '6' => bin := "0110";
              when '7' => bin := "0111";
              when '8' => bin := "1000";
              when '9' => bin := "1001";
              when 'A' | 'a' => bin := "1010";
              when 'B' | 'b' => bin := "1011";
              when 'C' | 'c' => bin := "1100";
              when 'D' | 'd' => bin := "1101";
              when 'E' | 'e' => bin := "1110";
              when 'F' | 'f' => bin := "1111";
              when others =>  bin := "0000";  
      end case;
     return bin;
  end CONV_VECTOR;

  procedure readFileLine(file in_file: TEXT; 
					      outStrLine: out string) is
		
		variable localLine: line;
		variable localChar:  character;
		variable isString: 	boolean;
			
	begin
				
		 readline(in_file, localLine);

		 for i in outStrLine'range loop
			 outStrLine(i) := ' ';
		 end loop;   

		 for i in outStrLine'range loop
			read(localLine, localChar, isString);
			outStrLine(i) := localChar;
			if not isString then -- found end of line
				exit;
			end if;   
		 end loop; 
						 
	end readFileLine;
	
end aux_functions;     

--------------------------------------------------------------------------
-- Module implementing a behavioral model of an ASYNCHRONOUS INTERFACE RAM
--------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use std.textio.all;
use work.aux_functions.all;

entity RAM_mem is
      generic(  START_ADDRESS: wires32 := (others=>'0')  );
      port( ce_n, we_n, oe_n, bw: in std_logic;    address: in wires32;   data: inout wires32);
end RAM_mem;

architecture RAM_mem of RAM_mem is 
   signal RAM : memory;
   signal tmp_address: wires32;
   alias  low_address: wires16 is tmp_address(15 downto 0);    --  baixa para 16 bits devido ao CONV_INTEGER --
begin     

   tmp_address <= address - START_ADDRESS;   --  offset do endereamento  -- 
   
   -- writes in memory ASYNCHRONOUSLY  -- LITTLE ENDIAN -------------------
   process(ce_n, we_n, low_address) -- Modification in 16/05/2012 for monocycle processors only,
     begin
       if ce_n='0' and we_n='0' then
          if CONV_INTEGER(low_address)>=0 and CONV_INTEGER(low_address)<=MEMORY_SIZE-3 then
               if bw='1' then
                   RAM(CONV_INTEGER(low_address+3)) <= data(31 downto 24);
                   RAM(CONV_INTEGER(low_address+2)) <= data(23 downto 16);
                   RAM(CONV_INTEGER(low_address+1)) <= data(15 downto  8);
               end if;
               RAM(CONV_INTEGER(low_address  )) <= data( 7 downto  0); 
          end if;
         end if;   
    end process;   
    
   -- read from memory
   process(ce_n, oe_n, low_address)
     begin
       if ce_n='0' and oe_n='0' and
          CONV_INTEGER(low_address)>=0 and CONV_INTEGER(low_address)<=MEMORY_SIZE-3 then
            data(31 downto 24) <= RAM(CONV_INTEGER(low_address+3));
            data(23 downto 16) <= RAM(CONV_INTEGER(low_address+2));
            data(15 downto  8) <= RAM(CONV_INTEGER(low_address+1));
            data( 7 downto  0) <= RAM(CONV_INTEGER(low_address  ));
        else
            data(31 downto 24) <= (others=>'Z');
            data(23 downto 16) <= (others=>'Z');
            data(15 downto  8) <= (others=>'Z');
            data( 7 downto  0) <= (others=>'Z');
        end if;
   end process;   

end RAM_mem;
-------------------------------------------------------------------------
-----------------------------------------
-- Autores: Vinicius Cerutti e Yuri Bittencourt
-- Disciplina: Organização e arquitetura de Computadores II 

-- T1 - Comunicação Serial Periférico-Processador
-- Parte do Periferico
-----------------------------------------
--  peripheral module
--  periferico trabalha na velocidade de 115200 bits por segundo
-------------------------------------------------------------------------

Library ieee;
Use IEEE.std_logic_1164.All;
Use IEEE.std_logic_arith.All;
Use IEEE.std_logic_unsigned.All; 

Entity periferico Is
  Port (
    clock : In std_logic; 
    reset : In std_logic; 
    rxd : In std_logic;
    txd : Out std_logic
  );
End periferico;

Architecture periferico Of periferico Is

  Type State_type Is (a, c, d, e,f);
  Signal State : State_type;

  Signal dadoSync : std_logic_vector(10 Downto 0);
  Signal result : std_logic_vector(9 Downto 0);

  Type data_memInf Is Array(0 To 1) Of std_logic_vector(7 Downto 0);
  Signal memInf : data_memInf := (Others => (Others => '0'));
  Signal contBitsReceiver, contBitsSend : std_logic_vector (7 Downto 0);
  Signal contVetor : std_logic_vector (7 Downto 0);
  signal enviar_dado_sinc : std_logic := '1';

Begin
  Process (reset, clock,rxd)
  Begin
    If (reset = '1') Then
      result <= "0000000000";
      dadoSync <= "00000000000";
      contBitsSend <= "00000000";
      contBitsReceiver <= "00000000";
      contVetor<=x"00";
    Elsif (clock'EVENT And clock = '1') Then
      Case State Is
        When a => 
          -- envia dado 0x55 para sicronizacao com a interface serial
          if(enviar_dado_sinc = '1') Then
            contBitsSend <= x"0A";
            dadoSync <= "10101010101";
            State <= f;
          -- os dois dados estao recebidos logo devem ser somados e 
          -- madandos para o periferico
          elsif (contVetor = x"02") then
            contBitsSend <= x"00";
            result(8 Downto 1) <= memInf(0)(7 Downto 0) + memInf(1)(7 Downto 0);
            result(9) <= '1';
            State <= e;
          -- se ainda nao recebeu os dois valores para realizar a soma
          elsif (contVetor /= x"02") Then
            contBitsReceiver <= x"08";
            -- verifica se o primeiro bit é start bit
            If (rxd = '0') Then
              State <= c;
            else State<=a;
            End if;
          end if;
          -- estado que realiza o recebimento dos bits da interface serial
        When c => 
          If (contBitsReceiver > 1) Then
            memInf(CONV_INTEGER(contVetor)) <= rxd & memInf(CONV_INTEGER(contVetor))(7 Downto 1);
            contBitsReceiver <= contBitsReceiver - x"01";
            State <= c;
          Else
            memInf(CONV_INTEGER(contVetor)) <= rxd & memInf(CONV_INTEGER(contVetor))(7 Downto 1);
            contBitsReceiver <= contBitsReceiver - x"01";
            State <= d;
          End If;
        -- estado que verifica se existe o stop bit
        When d => 
          If (rxd /= '0') Then
            contVetor <= contVetor + x"01";
            State <= a;
          Else
            State <= d;
          End If;
        -- estado para enviar os dados do periferico para
        -- interface serial
        When e => 
          If (contBitsSend <= x"08") Then
            txd <= result(CONV_INTEGER(contBitsSend));
            contBitsSend <= contBitsSend + x"01";
            State <= e;
          Else
            txd <= result(CONV_INTEGER(contBitsSend));
            contVetor <= x"00";
            State <= a;
          end if;
        -- estado para enviar o dado de sicronizacao(0x55) para 
        -- a interface serial
         When f => 
          if(enviar_dado_sinc ='1') Then
            enviar_dado_sinc <='0';
          End If;
          If (contBitsSend >= x"01") Then
            txd <= dadoSync(CONV_INTEGER(contBitsSend));
            contBitsSend <= contBitsSend - x"01";
            State <= f;
          Else
            txd <= dadoSync(CONV_INTEGER(contBitsSend));
            State <= a;
          end if;                
        When Others => 
          State <= a;
      End Case;
    End If;
  End Process;
End periferico;
-------------------------------------------------------------------------
--  CPU PROCESSOR SIMULATION TESTBENCH
-------------------------------------------------------------------------
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;          
use STD.TEXTIO.all;
use work.aux_functions.all;

entity CPU_tb is
end CPU_tb;

architecture cpu_tb of cpu_tb is
    
    signal Dadress, Ddata, Iadress, Idata,
           i_cpu_address, d_cpu_address, data_cpu, tb_add, tb_data : wires32 := (others => '0' );
    
    signal Dce_n, Dwe_n, Doe_n, Ice_n, Iwe_n, Ioe_n, ck, rst, rstCPU, 
           go_i, go_d, ce, rw, bw: std_logic;
    
    signal mem_ce :  std_logic;

    signal tx_data,rx_data: std_logic_vector (7 downto 0);  
    signal tx_av,rx_busy, rx_start:  std_logic;

    signal rxd,txd,clkPeriferico:  std_logic;     

    
    file ARQ : TEXT open READ_MODE is "textMips2.txt";
 
begin
    
     Logica_cola: entity work.FsmLogicaCola   
              port map (ce => Dce_n,address=>Dadress, mem_ce=>mem_ce, rw=>rw, clock=>ck, reset=>rstCPU, tx_data=>tx_data,
			rx_data=>rx_data, tx_av=> tx_av, rx_busy=>rx_busy,rx_start=>rx_start, data => Ddata);
    
    Interface_Serial: entity work.serialinterface
              port map (clock=>ck,reset=>rstCPU,rxd=>rxd,txd=>txd,rx_data=>rx_data,rx_start=>rx_start,
                rx_busy => rx_busy,tx_data=>tx_data,tx_av=>tx_av
                );

   perifericoMap: entity work.periferico
            port map(clock => clkPeriferico,reset=>rstCPU,rxd=>rxd,txd=>txd);

    Data_mem:  entity work.RAM_mem 
               generic map( START_ADDRESS => x"10010000" )
               port map (ce_n=>mem_ce, we_n=>Dwe_n, oe_n=>Doe_n, bw=>bw, address=>Dadress, data=>Ddata);
                                            
    Instr_mem: entity work.RAM_mem 
               generic map( START_ADDRESS => x"00400000" )
               port map (ce_n=>Ice_n, we_n=>Iwe_n, oe_n=>Ioe_n, bw=>'1', address=>Iadress, data=>Idata);

   
    -- data memory signals --------------------------------------------------------
    Dce_n <= '0' when (ce='1' and rstCPU/='1') or go_d='1' else '1'; -- Bug corrected here in 16/05/2012
    Doe_n <= '0' when (ce='1' and rw='1')             else '1';       
    Dwe_n <= '0' when (ce='1' and rw='0') or go_d='1' else '1';    

    Dadress <= tb_add  when rstCPU='1' else d_cpu_address;
    Ddata   <= tb_data when rstCPU='1' else data_cpu when (ce='1' and rw='0') else (others=>'Z'); 
    
    data_cpu <= Ddata when (ce='1' and rw='1') else (others=>'Z');
    
    -- instructions memory signals --------------------------------------------------------
    Ice_n <= '0';                                 
    Ioe_n <= '1' when rstCPU='1' else '0';           -- impede leitura enquanto est escrevendo                             
    Iwe_n <= '0' when go_i='1'   else '1';           -- escrita durante a leitura do arquivo 
    
    Iadress <= tb_add  when rstCPU='1' else i_cpu_address;
    Idata   <= tb_data when rstCPU='1' else (others => 'Z'); 
  

    cpu: entity work.MIPS_MCS  port map(
              clock=>ck, reset=>rstCPU,
              i_address => i_cpu_address,
              instruction => Idata,
              ce=>ce,  rw=>rw,  bw=>bw,
              d_address => d_cpu_address,
              data => data_cpu
        ); 

    rst <='1', '0' after 15 ns;       -- generates the reset signal 

    process                          -- generates the clock signal 
        begin
        ck <= '1', '0' after 10 ns;
        wait for 20 ns;
    end process;

    process                          -- generates the clock signal for peripheral
        begin
        clkPeriferico <= '1', '0' after 4.34 us;
        wait for 8.68 us;
    end process;
    
    ----------------------------------------------------------------------------
    -- this process loads the instruction memory and the data memory during reset
    --
    --
    --   O PROCESSO ABAIXO  UMA PARSER PARA LER CDIGO GERADO PELO SPIM NO
    --   SEGUINTE FORMATO:
    --
    --      Text Segment
    --      [0x00400000]        0x3c011001  lui $1, 4097 [d2]               ; 16: la    $t0, d2
    --      [0x00400004]        0x34280004  ori $8, $1, 4 [d2]
    --      [0x00400008]        0x8d080000  lw $8, 0($8)                    ; 17: lw    $t0,0($t0)
    --      .....
    --      [0x00400048]        0x0810000f  j 0x0040003c [loop]             ; 30: j     loop
    --      [0x0040004c]        0x01284821  addu $9, $9, $8                 ; 32: addu $t1, $t1, $t0
    --      [0x00400050]        0x08100014  j 0x00400050 [x]                ; 34: j     x
    --      Data Segment
    --      [0x10010000]                        0x0000faaa  0x00000083  0x00000000  0x00000000
    --
    ----------------------------------------------------------------------------
    process
        variable ARQ_LINE : LINE;
        variable line_arq : string(1 to TAM_LINHA);
        variable code     : boolean;
        variable i, address_flag : integer;
    begin  
        go_i <= '0';
        go_d <= '0';
        rstCPU <= '1';           -- hold the processor during file reading
        code:=true;              -- default value of code is 1 (CODE)
                                 
        wait until rst = '1';
        
        while NOT (endfile(ARQ)) loop    -- INCIO DA LEITURA DO ARQUIVO CONTENDO INSTRUO E DADOS -----
            --readline(ARQ, ARQ_LINE);      
            --read(ARQ_LINE, line_arq(1 to  ARQ_LINE'length) );
				readFileLine(ARQ, line_arq);
                        
            if line_arq(1 to 12)="Text Segment" then 
                   code:=true;                     -- code 
            elsif line_arq(1 to 12)="Data Segment" then
                   code:=false;                    -- data 
            else 
               i := 1;                                  -- LEITORA DE LINHA - analizar o loop abaixo para compreender 
               address_flag := 0;                       -- para INSTRUO  um para (end,inst)
                                                        -- para DADO aceita (end, dado 0, dado 1, dado 2 ....)
               loop                                     
                  if line_arq(i) = '0' and line_arq(i+1) = 'x' then      -- encontrou indicao de nmero hexa: '0x'
                         i := i + 2;
                         if address_flag=0 then
                               for w in 0 to 7 loop
                                   tb_add( (31-w*4) downto (32-(w+1)*4))  <= CONV_VECTOR(line_arq,i+w);
                               end loop;    
                               i := i + 8; 
                               address_flag := 1;
                         else
                               for w in 0 to 7 loop
                                   tb_data( (31-w*4) downto (32-(w+1)*4))  <= CONV_VECTOR(line_arq,i+w);
                               end loop;    
                               i := i + 8;
                               
                               wait for 0.1 ns;
                               
                               if code=true then go_i <= '1';    -- the go_i signal enables instruction memory writing
                                            else go_d <= '1';    -- the go_d signal enables data memory writing
                               end if; 
                               
                               wait for 0.1 ns;
                               
                               tb_add <= tb_add + 4;       -- *great!* consigo ler mais de uma word por linha!
                               go_i <= '0';
                               go_d <= '0'; 
                               
                               address_flag := 2;    -- sinaliza que j leu o contedo do endereo;

                         end if;
                  end if;
                  i := i + 1;
                  
                  -- sai da linha quando chegou no seu final OU j leu par(endereo, instruo) no caso de cdigo
                  exit when i=TAM_LINHA or (code=true and address_flag=2);
               end loop;
            end if;
            
        end loop;                        -- FINAL DA LEITURA DO ARQUIVO CONTENDO INSTRUO E DADOS -----
        
        rstCPU <= '0' after 2 ns;   -- release the processor to execute
        wait for 4 ns;   -- To activate the RST CPU signal
        wait until rst = '1';  -- to Hold again!
        
    end process;
    
end cpu_tb;
