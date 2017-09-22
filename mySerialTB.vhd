
Library ieee;
Use IEEE.std_logic_1164.All;
Use IEEE.std_logic_arith.All;
Use IEEE.std_logic_unsigned.All; 

Entity mySerialTB Is
	Port (
		clock : In std_logic; 
		reset : In std_logic; 
		rxd : In std_logic;
		txd : Out std_logic
	);
End mySerialTB;

Architecture mySerialTB Of mySerialTB Is

	Type State_type Is (a, b, c, d, e);
	Signal State : State_type;

	Signal result : std_logic_vector(9 Downto 0);

	Type data_memInf Is Array(0 To 1) Of std_logic_vector(7 Downto 0);
	Signal memInf : data_memInf := (Others => (Others => '0'));
	Signal contBitsReceiver, contBitsSend : std_logic_vector (7 Downto 0);
	Signal contVetor : std_logic_vector (7 Downto 0) := "00000000";
Begin
	Process (reset, clock)
	Begin
		If (reset = '1') Then
			result <= "0000000000";
			contVetor<=x"00";
			State <= a;
		Elsif (clock'EVENT And clock = '1') Then
			Case State Is
				When a => 
					If (contVetor /= x"10") Then
						contBitsReceiver <= x"08";
						State <= b;
					Else
						contBitsSend <= x"08";
						result(8 Downto 1) <= memInf(0)(7 Downto 0) + memInf(1)(7 Downto 0);
						result(0) <= '1';
						State <= e;
					End If;
				When b => 
					If (rxd = '0') Then
						State <= c;
					Else
						State <= b; 
					End If;
				When c => 
					If (contBitsReceiver > 1) Then
						contBitsReceiver <= contBitsReceiver - x"01";
						memInf(CONV_INTEGER(contVetor)) <= rxd & memInf(CONV_INTEGER(contVetor))(7 Downto 1);
						State <= c;
					Else
						State <= d;
					End If;
				When d => 
					If (rxd /= '0') Then
						contVetor <= contVetor + x"01";
						State <= a;
					Else
						State <= d;
					End If;
				When e => 
					If (contBitsSend >= x"01") Then
						contBitsSend <= contBitsSend - x"01";
						txd <= result(CONV_INTEGER(contBitsSend));
 
						State <= e;
					Else
						txd <= result(CONV_INTEGER(contBitsSend));
						contVetor <= x"00";
						State <= a;
					End If;
				When Others => 
					State <= a;
			End Case;
		End If;
	End Process;
End mySerialTB;