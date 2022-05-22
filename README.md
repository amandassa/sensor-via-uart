# Sistema de comunicação serial com  Raspberry PI, FPGA Cyclone IV e Sensor DHT11

<div id="inicio">
	<p> 
		Este projeto consiste na implementação um protótipo de sistema para medição de temperatura e umidade atravéz do sensor <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">DHT11</a>. O protótipo realiza a leitura dos dados enviados pelo sensor por meio de uma FPGA e, estabelece uma comunicação serial RS-232 com o SBC Raspberry Pi Zero, o qual faz requisições e recebe os dados como resposta. 	
	</p><br>
    <p>
        O sistema foi dividido em duas partes: 
    </p>
    <ul>
		<li><p>Raspberry Pi Zero: Implementação da requisição de dados na Linguagem C em conjunto com a UART desenvolvida em Assembly ainda no <a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%201">Problema 1</a>;</p></li>
		<li><p>FPGA: Implementação em Verilog da UART de comunicação e da máquina de estadoa para leitura dos dados recebidos pelo sensor.</p></li>
	</ul>	
</div>


## Equipe: <br>
* Abel Ramalho Galvão; <br>
* Aurélio Rocha Barreto; <br>
* Amanda Silva Santos. <br>

## Tutor: <br>
* Thiago Cerqueira de Jesus <br>

<h1>Sumário</h1>
<div id="sumario">
	<ul>
		<li><a href="#inicio"> Início</li>
		<li><a href="#recursos-utilizados"> Recursos Utilizados </a></li>
		<li><a href="#implementacao"> Implementação </a> </li>
		<li><a href="#anexos"> Anexos </a></li>
	</ul>	
</div>

<div id="recursos-utilizados">
	<h1> Recursos Utilizados </h1>
	<ul>
		<li>FPGA Cyclone IV (EP4CE30F23);</li>
		<li>Raspberry Pi Zero.</li>
	</ul>	
</div>

<div id="implementacao">
    <h1>Implementação</h1>
    <p>
        Para realizar a implementação deste projeto siga as etapas a seguir:
    </p>
    <h3>Realize o download do projeto</h3>
    <p><code>$ git clone https://github.com/amandassa/sensor-via-uart.git</code></p>
    <h3>Compilando o projeto na Raspberry Pi Zero</h3>
    <p><code>$ cd /sensor-via-uart/Problema 2</code></p>
    <p>
        Tranfira os seguintes aquivos para o Raspberry P zero: 
    </p>
    <ul>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/Makefile">Makefile</a></li>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/pbl2.c">pbl2.c</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartConfig.s">uartConfig.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartGet.s">uartGet.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartPut.s">uartPut.s</a></li>
	</ul><br>
    <p>Execute os seguintes comandos:</p>
    <p><code>$ make</code></p>
    <p><code>$ sudo ./pbl2</code></p>
    <h3>Compilando o projeto na FPGA</h3>
    <p><code>$ cd /sensor-via-uart/Problema 2/fpga</code></p>
    <p>
        Crie um projeto no <it>Altera Quartus Prime Lite Edition 21</it>, especificamente para a família EP4CE30F23 e importe os seguintes arquivos: 
    </p>
</div>

<div id="anexos">
	<h1> Anexos </h1>
    <div id="raspberry-pi-zero" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/raspberry.jpg"/><br>
		<p>
		Placa Raspberry Pi Zero. <b>Fonte:</b> <a href="https://www.embarcados.com.br/raspberry-pi-zero-o-computador-de-5-dolares/">Embarcados</a>
		</p>
	</div>
	<div id="fpga" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/KitMERCURIO.png"/><br>
		<p>
		Kit de Desenvolvimento Altera FPGA Mercurio IV. <b>Fonte:</b> <a href="https://wiki.sj.ifsc.edu.br/index.php/Pinagem_dos_dispositivos_de_entrada_e_sa%C3%ADda_do_kit_MERCURIO_IV">IFSC</a>
		</p>
	</div>	
</div>