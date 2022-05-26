<div id="inicio">
    <h1>Sistema de comunicação serial com  Raspberry PI, FPGA Cyclone IV e Sensor DHT11</h1>
	<p align="justify"> 
		Este projeto consiste na implementação de um protótipo de sistema para medição de temperatura e umidade através do sensor <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">DHT11</a>. O produto implementa comunicação serial entre o SBC Raspberry Pi Zero, de onde partem as solicitações de medição e a FPGA Cyclone IV, que atua como plataforma para ativação e leitura do sensor.
    <p>
        O sistema é composto por duas partes principais: 
    </p>
    <ul>
		<li><p>Raspberry Pi Zero: Módulo responsável pela requisição de medição, usando Linguagem C e Assembly na implementação da UART desenvolvida ainda no <a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%201">Problema 1</a>;</p></li>
		<li><p>FPGA: Implementação em Verilog da UART para comunicação serial e dos módulos de ativação e comunicação com o sensor.</p></li>
	</ul>	
</div>

<div id="equipe">
    <h1>Equipe de Desenvolvimento</h1>
    <ul>
		<li><a href="https://github.com/argalvao"> Abel Ramalho Galvão</li>
		<li><a href="https://github.com/aureliobarreto"> Aurélio Rocha Barreto </a></li>
        <li><a href="https://github.com/amandassa"> Amanda Silva Santos </a> </li>
	</ul>
    <h1>Tutor</h1>
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
		<li><a href="#como-executar"> <b>Como executar</b> </a> </li>
        <li><a href="#funcionamento"> <b>Funcionamento do sensor (DHT11)</b> </a> </li>
        <li><a href="#implementacao"> <b>Implementação</b> </a> </li>
        <li><a href="#testes"> <b>Exemplo de montagem</b> </a> </li>
        <li><a href="#conclusoes"> <b>Conclusões</b> </a> </li>
		<li><a href="#anexos"> <b>Anexos</b> </a></li>
	</ul>	
</div>

<div id="recursos-utilizados">
	<h1> Recursos Utilizados </h1>
	<ul>
        <li><a href="#raspberry-pi-zero">Raspberry Pi Zero</a></li>
		<li><a href="#fpga">FPGA Cyclone IV (EP4CE30F23)</a></li>
	</ul>	
</div>

<div id="como-executar">
    <h1>Como executar</h1>
    <p>
        Para executar, é necessário dispor de todos os <a href="#recursos-utilizados">itens</a> listados na seção de recursos.
    </p>
    <p>
        Siga as etapas a seguir:
    </p>
    <h3>Realize o download do projeto</h3>
    <p><code>$ git clone https://github.com/amandassa/sensor-via-uart.git</code></p>
    <h3>Compilando o projeto na Raspberry Pi Zero</h3>
    <p><code>$ cd /sensor-via-uart/Problema 2/sbc</code></p>
    <p>
        Tranfira os seguintes arquivos para o Raspberry PI Zero: 
    </p>
    <ul>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/sbc/Makefile">Makefile</a></li>
		<li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/sbc/pbl2.c">pbl2.c</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/sbc/uartConfig.s">uartConfig.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/sbc/uartGet.s">uartGet.s</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/sbc/uartPut.s">uartPut.s</a></li>
	</ul><br>
    <p>Execute os seguintes comandos:</p>
    <p><code>$ make</code></p>
    <p><code>$ sudo ./pbl2</code></p>
    <h3>Compilando o projeto na FPGA</h3>
    <p><code>$ cd /sensor-via-uart/Problema 2/fpga</code></p>
    <p>
        Crie um projeto no <it>Altera Quartus Prime Lite Edition 21</it>, especificamente para a família EP4CE30F23 e importe os seguintes arquivos: 
    </p>
    <ul>
		<li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/baudrate_gen.v">baudrate_gen.v</a></li>
		<li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/controlador.v">controlador.v</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/decodificador.v">decodificador.v</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/dht11.v">dht11.v</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/receiver.v">receiver.v</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/transmiter.v">transmiter.v</a></li>
        <li><a href="https://github.com/amandassa/sensor-via-uart/tree/main/Problema%202/fpga/uart0.v">uart0.v</a></li>
	</ul><br>
    <p>Assegure-se de que o arquivo "uart0.v" está definido como top-level do projeto para compilação. Com o projeto compilado, configure os seguintes pinos:</p>
    <div>
    <table align="center">
    <tr>
        <th>Node Name</th>
        <th>Direction</th>
        <th>Location</th>
    </tr>
    <tr>
        <td>DHT_DATA</td>
        <td>Output</td>
        <td>PIN_H17</td>
    </tr>
    <tr>
        <td>clk_50mhz</td>
        <td>Output</td>
        <td>PIN_T1</td>
    </tr>
    <tr>
        <td>in</td>
        <td>Input</td>
        <td>PIN_E13</td>
    </tr>
    <tr>
        <td>out</td>
        <td>Output</td>
        <td>PIN_E13</td>
    </tr>
    </table>
    </div>
    <p>
        Carregue o projeto na FPGA com a ferramenta Programmer do Quartus Lite.
    </p>
    <p> 
        Assegure-se de que os componentes estão devidamente conectados para a comunicação serial: O TX (out) de um módulo deve estar ligado ao RX (in) do outro, assim como o ground (GND) dos módulos que devem estar conectados, como mostra o <a href="#conexaoimg">diagrama</a>. Além disso, o sensor também deve estar devidamente conectado com o pino referente a DHT_DATA do módulo verilog.
    </p>
    <div id="conexoes" style="display: inline_block" align="center">
        <img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/CONEXOES.jpg"/><br>
        <p>
        <b>Imagem 01</b> - Diagrama ilustrativo da conexão adequada do circuito.
        </p>
    </div>
</div>

<div id="funcionamento">
    <h1>Funcionamento do sensor (DHT11)</h1>
    <h3>Especificação</h3>
    <p>
        O sensor DHT11 possui 4 pinos:
    </p>
    <ol>
        <li>VCC</li>
        <li>DATA</li>
        <li>NULL</li>
        <li>GND</li>
    </ol>
    <p>O 2º pino, o pino de dados caracteriza-se como entrada e saída, pois, este recebe as requisições e realiza o envio dos dados ao MCU (Micro-computer Unite).</p>
    <div id="dht11" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/application.png"/><br>
		<p>
		<b>Imagem 02</b> - Especificação do DHT11. <b>Fonte:</b> <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">Datasheet</a>
		</p>
	</div>
    <h3>Comunicação</h3>
    <p align="justify">
    Para iniciar a comunicação, o MCU deve enviar ao sensor um sinal em nível de tensão baixo por 80ms, depois em nível alto por 18us. Como resposta, o sensor enviará sinal baixo por 80us seguido de alto por mais 80us. 
    Em seguida, o sensor envia sinal baixo por mais 50us e inicia a transmissão dos 40 bits de mensagem contendo a medição do ambiente e o checksum. </p>
    <p>A partir desse momento a resposta do sensor é enviada como um databus contendo sinais em nível lógico alto que podem ser interpretados de acordo com sua duração:
    <li> 0, se alto por cerca de 28us</li>
    <li> 1, se alto por cerca de 70us</li>
    Os bits de mensagem a serem decodificados são enviados pelo sensor alternando entre sinais de nível lógico baixo com duração de 50us.
    Após o envio, o sensor volta ao modo de espera e aguarda uma nova requisição.
    </p>    
    <div id="dht11-communication" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/communication_process.png"/><br>
		<p>
		<b>Imagem 03</b> - Processo de comunicação. <b>Fonte:</b> <a href="https://www.mouser.com/datasheet/2/758/DHT11-Technical-Data-Sheet-Translated-Version-1143054.pdf">Datasheet</a>
		</p>
	</div>
</div>

<div id="implementacao">
    <h1>Breve descrição da implementação</h1>
    <h2>Módulo Raspberry PI Zero</h2>
        <p>Neste módulo, a implementação do protocolo UART para Raspberry PI desenvolvida em Assembly foi utilizada como uma biblioteca C para estabelecer a comunicação RS-232 do SBC. As funções utilizadas foram:
        <li>uartConfig(): Configura a UART do SBC definindo os parâmetros de baud rate, stop bits, ativação e verificação da fila de transmissão.</li>
        <li>uartPut(): Envia o byte de mensagem pela via serial. Caso receba mais que 8 bits de mensagem, apenas os 8 menos significativos vão compor a mensagem enviada.</li>
        <li>uartGet(): Recebe o byte de mensagem lendo o registrador DATA_REGISTER.</li>
        </p>
        <p>
        Essas funções são invocadas no programa C que faz a leitura das solicitações via terminal.
        </p>
    <h2>Módulo FPGA</h2>
    <h3>UART</h3>
        <p>
        Para implementação da UART na FPGA foram desenvolvidos os módulos <a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/fpga/transmiter.v">transmitter</a> e <a href="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/fpga/receiver.v">receiver</a> baseados em máquina de estados finitos de Mealy, ambas compostas pelos três estados:
        <li>START:</li>
            <p>Estado inicial e de espera, permanece nele até que seja recebido sinal de "enable" que indique início do recebimento de dados (serial, no caso de RX ou paralelo, no caso de TX). Enquanto a entrada de EN não é recebida, este estado mantém o sinal de saída no TX em nível alto, que é o sinal de bus IDLE da comunicação.</p>
        <li>DATA:</li>
            <p>
            Estado de recebimento de dados. No RX, como o recebimento é serial os dados são armazenados em um buffer para serem transmitidos por um barramento. Já em TX os dados são recebidos em paralelo e serializados por um envio sob iteração.
            </p>
        <li>STOP: </li>
            <p>
            Estado de fim da recepção e transmissão de dados. No RX, os sinais armazenados no buffer são transmitidos pelo barramento de saída e em TX é feita a reinicialização do contador de iteração. Ao fim deste estado ambos os módulos TX e RX voltam para START.
            </p>
        </p>
    <h3>Decodificador</h3>
        <p>
        O módulo decodificador de requisições possui as funções de:
            <li>Receber do RX a solicitação de medição
            </li>
            <li>Ativar o módulo do sensor e receber sua resposta</li>
            <li>Ativar e transmitir para TX o sinal de resposta referente à medição solicitada</li>
        </p>
        <p>Para isso, foram implementados quatro estados:
        <li>START: Estado inicial. Permanece nele até que seja recebido sinal de enable. Caso ativado, ativa o módulo do sensor.</li>
        <li>WAIT_DHT11: Estado de espera da sincronização do sensor. Permanece nele até que a mensagem do sensor seja recebida.</li>
        <li>DATA: Estado de leitura de dados do sensor. Neste estado, a seção de mensagem do sensor requisitada é direcionada para a saída. Os bits de 0 a 7 da mensagem correspondem ao valor inteiro da medição de umidade. Os bits 16 a 23 correspondem ao inteiro da temperatura. Os últimos 8 bits são checksum.</li>
        <li>STOP: Neste estado, o módulo do sensor é desativado e TX é ativado, permitindo que os dados sejam enviados para o SBC.</li>
        </p>
    <h3>Controle do sensor</h3>
        <p>
        Este módulo é responsável por estabelecer a comunicação com o sensor DHT11 e encaminhar sua resposta. O módulo foi implementado como uma máquina mealy de 12 estados. Este processo segue os passos necessários para realizar a leitura seguindo o protocolo de <a href="#funcionamento">funcionamento do sensor</a>:
        <li>Enviar o sinal de sincronização e aguardar a resposta da sincronização do sensor</li>
        <li>Assim que a sincronização é completada, ocorre a decodificação de bits de mensagem de acordo com o período de tempo em que o sinal de resposta permanece em alto.</li>
        <li>Quando os 40 bits estão prontos no buffer, o barramento com a resposta é liberado para o módulo seguinte.</li>
        </p>
</div>

<div id="testes">
    <h1>Testes</h1>
    <p>
    <div id="circuito" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/circuito.jpeg"/><br>
		<p>
		<b>Imagem 04</b> - Montagem do circuito.
		</p>
	</div>
    <div id="osciloscopio" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/oscilos.jpeg"/><br>
		<p>
		<b>Imagem 05</b> - 40 bits de resposta do DHT11
		</p>
	</div>
    </p>
</div>

<div id="conclusoes">
    <h1>Conclusões</h1>
    <p>
    O produto-solução proposto implementa comunicação serial RS-232 entre um SBC (Raspberry Pi Zero) e a FPGA Cyclone IV. Com os módulos de controle desenvolvidos, é possível realizar requisições de medição de temperatura e umidade por meio do sensor DHT11, que é ativado e responde adequadamente aos comandos do sistema. No entanto, o retorno da leitura vinda da FPGA para o SBC ainda apresenta falhas. Por meio de testes foi possível identificar que a comunicação entre os componentes é interrompida a partir da integração do módulo do sensor. Possíveis ajustes futuros devem incluir a correção do problema entre os módulos de resposta do sensor e o TX da FPGA, para que seja possível receber adequadamente os 8 bits de mensagem solicitados e retorná-los no terminal de interação com o usuário.
    </p>
</div>

<div id="anexos">
	<h1> Anexos </h1>
    <div id="raspberry-pi-zero" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/raspberry.jpg"/><br>
		<p>
		<b>Imagem 06</b> - Placa Raspberry Pi Zero. <b>Fonte:</b> <a href="https://www.embarcados.com.br/raspberry-pi-zero-o-computador-de-5-dolares/">Embarcados</a>
		</p>
	</div>
	<div id="fpga" style="display: inline_block" align="center">
			<img src="https://github.com/amandassa/sensor-via-uart/blob/main/Problema%202/imagens/KitMERCURIO.png"/><br>
		<p>
		<b>Imagem 07</b> - Kit de Desenvolvimento Altera FPGA Mercurio IV. <b>Fonte:</b> <a href="https://wiki.sj.ifsc.edu.br/index.php/Pinagem_dos_dispositivos_de_entrada_e_sa%C3%ADda_do_kit_MERCURIO_IV">IFSC</a>
		</p>
	</div>	
</div>