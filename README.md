# Sistema de comunicação serial com  Raspberry PI, FPGA Cyclone IV e Sensor DHT11

<div id="inicio">
	<p> 
		Este projeto consiste na implementação um protótipo de sistema para medição de temperatura e umidade atravéz do sensor <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">DHT11</a>. O protótipo realiza a leitura dos dados enviados pelo sensor por meio de uma FPGA e, estabelece uma comunicação serial RS-232 com o SBC Raspberry Pi Zero, o qual faz requisições e recebe os dados como resposta. 	
	</p><br>
    <p>
        O sistema foi dividido em duas partes: 
    </p><br>
    <ul>
		<li><p>Raspberry Pi Zero: Implementação da requisição de dados na Linguagem C em conjunto com a UART desenvolvida em Assembly ainda no <a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%201">Problema 1</a>;</p></li>
		<li><p>FPGA: Implementação em Verilog da UART de comunicação e da máquina de estadoa para leitura dos dados recebidos pelo sensor.</p></li>
	</ul>	
</div>


## Equipe: <br>
* Abel Ramalho Galvão; <br>
* Aurélio Rocha Barreto; <br>
* Amanda Silva Santos. <br>

## :Tutor: <br>
* Thiago Cerqueira de Jesus <br>


<div id="recursos-utilizados">
	<h1> Recursos Utilizados</h1>
	<ul>
		<li>FPGA Cyclone IV (EP4CE30F23);</li>
		<li>Raspberry Pi Zero.</li>
	</ul>	
</div>

<div id="implementacao">
    <h1>Implementação</h1>
    <p>
        Para realizar a implementação deste projeto siga as etapas a seguir:
    </p><br>
    <h2>Realize o download do projeto</h2>
    <p><code>$ git clone https://github.com/amandassa/sensor-via-uart.git</code></p>
    <h2>Compilando o projeto na Raspberry Pi Zero</h2>
    <p><code>$ cd /sensor-via-uart/Problema 2</code></p><br>
    <p>
        Tranfira os seguintes aquivos para o Raspberry P zero: 
    </p><br>
    <ul>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/Makefile">Makefile</a></li>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/pbl2.c">pbl2.c</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartConfig.s">uartConfig.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartGet.s">uartGet.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/uartPut.s">uartPut.s</a></li>
	</ul><br>
    <p>Execute os seguintes comandos:</p><br>
    <p><code>$ make</code></p><br>
    <p><code>$ sudo ./pbl2</code></p><br>
</div>
## Uso/Exemplos

    ```bash
    $ exemplo de solicitação e resposta 
    ```


## Demonstração

Exemplo de conexão (fotos)

