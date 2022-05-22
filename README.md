<div id="inicio">
    <h1>Sistema de comunicação serial com  Raspberry PI, FPGA Cyclone IV e Sensor DHT11</h1>
	<p align="justify"> 
		Este projeto consiste na implementação um protótipo de sistema para medição de temperatura e umidade atravéz do sensor <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">DHT11</a>. O protótipo realiza a leitura dos dados enviados pelo sensor por meio de uma FPGA e, estabelece uma comunicação serial RS-232 com o SBC Raspberry Pi Zero, o qual faz requisições e recebe os dados como resposta. 	
	</p><br>
    <p>
        O sistema foi dividido em duas partes: 
    </p>
    <ul>
		<li><p>Raspberry Pi Zero: Implementação da requisição de dados na Linguagem C em conjunto com a UART desenvolvida em Assembly ainda no <a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%201">Problema 1</a>;</p></li>
		<li><p>FPGA: Implementação em Verilog da UART de comunicação e da máquina de estado para leitura dos dados recebidos pelo sensor.</p></li>
	</ul>	
</div>

<div id="equipe">
    <h1>Equipe de Desenvolvimento:</h1>
    <ul>
		<li><a href="https://github.com/argalvao"> Abel Ramalho Galvão</li>
		<li><a href="https://github.com/aureliobarreto"> Aurélio Rocha Barreto </a></li>
        <li><a href="https://github.com/amandassa"> Amanda Silva Santos </a> </li>
	</ul>
    <h1>Tutor:</h1>
    <ul>
        <li><a href="https://github.com/thiagocj">Thiago Cerqueira de Jesus</a></li>
    </ul>
</div>

<div id="sumario">
    <h1>Sumário</h1>
	<ul>
		<li><a href="#inicio"> <b>Início</b></li>
        <li><a href="#equipe"> <b>Equipe de Desenvolvimento</b></li>
		<li><a href="#recursos-utilizados"> <b>Recursos Utilizados</b> </a></li>
        <li><a href="#requisitos"> <b>Requisitos Atendidos</b> </a> </li>
		<li><a href="#implementacao"> <b>Implementação</b> </a> </li>
        <li><a href="#melhorias"> <b>Possíveis Melhorias</b> </a> </li>
		<li><a href="#anexos"> <b>Anexos</b> </a></li>
	</ul>	
</div>

<div id="recursos-utilizados">
	<h1> Recursos Utilizados </h1>
	<ul>
		<li>FPGA Cyclone IV (EP4CE30F23)</li>
		<li>Raspberry Pi Zero</li>
	</ul>	
</div>

<div id="requisitos">
    <h1>Requisitos Atendidos</h1>
    <p><b>Raspberry Pi Zero:</b></p>
	<ul>
		<li>O código deverá ser escrito em linguagem C :heavy_check_mark:</li>
		<li>Utilizar o driver da UART implementado anteriormente :heavy_check_mark:</li>
		<li>Capacidade de interligação com até 32 sensores :heavy_multiplication_x:</li>
		<li>Mecanismo de controle de status de funcionamento dos sensores :heavy_check_mark:</li>
        <li>Apenas o SBC será capaz de iniciar uma comunicação :heavy_check_mark:</li>
	</ul>
    <p><b>FPGA:</b></p>
    <ul>
		<li>O código deverá ser escrito em Verilog :heavy_check_mark:</li>
		<li>Deverá ser capaz de ler e interpretar comandos oriundos do SBC :heavy_check_mark:</li>
		<li>Os comandos serão compostos por palavras de 8 bits :heavy_check_mark:</li>
		<li>As requisições do SBC são compostas de 2 bytes (Comando + Endereço) :heavy_multiplication_x:</li>
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

<div id="melhorias">
    <h1>Possíveis Melhorias</h1>
    <p>
    
    </p>
</div>

<div id="anexos">
	<h1> Anexos </h1>
    <div id="raspberry-pi-zero" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/raspberry.jpg"/><br>
		<p>
		<b>Imagem 01</b> - Placa Raspberry Pi Zero. <b>Fonte:</b> <a href="https://www.embarcados.com.br/raspberry-pi-zero-o-computador-de-5-dolares/">Embarcados</a>
		</p>
	</div>
	<div id="fpga" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/KitMERCURIO.png"/><br>
		<p>
		<b>Imagem 02</b> - Kit de Desenvolvimento Altera FPGA Mercurio IV. <b>Fonte:</b> <a href="https://wiki.sj.ifsc.edu.br/index.php/Pinagem_dos_dispositivos_de_entrada_e_sa%C3%ADda_do_kit_MERCURIO_IV">IFSC</a>
		</p>
	</div>	
</div>