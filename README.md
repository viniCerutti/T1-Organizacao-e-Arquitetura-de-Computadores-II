# Descrição #
Trabalho I da Disciplina Organização e Arquitetura de Computadores II - 2017/2 PUCRS Ministrada pelo professor [Ney Calazans](http://www.inf.pucrs.br/calazans/) . O trabalho possui o objetivo de desenvolver a parte de comunição (Lógica de Cola) entre a CPU(MIPS) com o periferico e o  também o desenvolvimento do periferico.
## Imagem da Implementação ##
<p align="center">
  <img src="https://github.com/viniCerutti/T1-Organizacao-e-Arquitetura-de-Computadores-II/blob/master/Documentacao/modelagemT1.png">
</p>

# Autores #
Vinicius Cerutti<br/>
Yuri Bittencourt<br/>
Os arquivos relacionados à interface serial e ao MIPS foram criados pelos professores [Ney Calazans](http://www.inf.pucrs.br/calazans/) e [Fernando Moraes](https://www.inf.pucrs.br/moraes/).
# Sobre os Arquivos
 ### Documentacao(Pasta) ###
 Pasta que contem todas os arquivos para gerar o pdf da documentação do programa
 ### MaterialDeAuxilo(Pasta) ###
 Pasta que contem os arquivos VHDL que foram utilizados como auxilo para execução do programa, estes arquivos já estao na pasta ProgramaVHDL
 ### ProgramaVHDL(Pasta) ###
 Pasta que contem todos arquivos utéis para a execução e implementação do programa onde:
* LogicaDeCola.vhd - Implementação do hardware que liga a CPU com a interface Serial
#### Ordem do endereçamento do Driver na memória ####

        0x10008000 - Tx_Data <br />
        0x10008001 - tx_av <br />
        0x10008002 - rx_data <br />
        0x10008003 - rx_start <br />
        0x10008004 - rx_busy <br />

* MIPS-MC_SingleEdge.vhd - Implementação da CPU MIPS Multiciclo
* MIPS-MC_SingleEdge_tb.vhd - Implementação do arquivo Testbench do MIPS, Lógica de cola e Periferico
* MipsPerifericoSoftware.asm - Descrição em ASsembly do programa para executar no MIPS que faz o envio e recebimento de dados do periferico
* mult_div.vhd - Implementação da operações multiplicação e Divisão do Mips
* serialinterface.vhd - Implementação da interface Serial que faz ligação entre o periferico e a logica de cola
* textMips2.txt  - Arquivo para ser executado no TB do MIPS, que possui as instruções em Hexadecimal.
* waveMIPSCOMPLETA.do - Formatação das ondas para serem testadas no ModelSim
 ### Documentacao (arquivo PDF) ###
 Relatorio/Documentação de como a lógica de cola e o periferico foram desenvolvidos.
 ### TP1_OrgArqCompII_CC_2017_1 (arquivo docx) ###
 Enunciado do trabalho.

# Programa para realizar as formas de ondas e testes #
[ModelSim](https://www.altera.com/products/design-software/model---simulation/modelsim-altera-software.html) - Intel FPGA Starte Edition 10.5c

## Links Úteis ##

http://www.cs.uwm.edu/classes/cs315/Bacon/Lecture/HTML/ch14s03.html<br/>
http://www.cs.umd.edu/class/sum2003/cmsc311/Notes/IO/mapped.html<br/>
http://xenon.stanford.edu/~geksiong/cs61c-tb/week7.html<br/>
http://cseweb.ucsd.edu/classes/wi12/cse141L-a/lab2.html<br/>
http://www.cim.mcgill.ca/~langer/273/20-notes.pdf<br/>
