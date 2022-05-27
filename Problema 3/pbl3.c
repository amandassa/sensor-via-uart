#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <wiringPi.h>
#include <lcd.h>

char teste = "Teste 01!";

void bmp(){ // Função para leitura de pressão atmosférica do sensor BMP180 ou BMP085

}

void dht11(){ // Função para leitura de temperatura e humidade do sensor DHT11
    #define TEMPO 85
    #define DHT	3
    int data[5] = {0, 0, 0, 0, 0};

    uint8_t laststate	= HIGH;
	uint8_t counter		= 0;
	uint8_t j			= 0, i;
	data[0] = data[1] = data[2] = data[3] = data[4] = 0;

    pinMode(DHT, OUTPUT);
	digitalWrite( DHT_PIN, LOW );
	delay( 18 );

    pinMode(DHT, INPUT);

    for (i = 0; i < TEMPO; i++){
        counter = 0;
        while (digitalRead(DHT) == laststate){
			counter++;
			delayMicroseconds(1);
			if (counter == 255){
				break;
			}
		}
		laststate = digitalRead(DHT);
        if ( counter == 255 ){
		    break;
        }
        if ( (i >= 4) && (i % 2 == 0) ){
			data[j / 8] <<= 1;
			if ( counter > 16 )
				data[j/8] |= 1;
			j++;
		}
    }
    if ( (j >= 40) && (data[4] == ((data[0] + data[1] + data[2] + data[3]) & 0xFF))){
		float h = (float)((data[0] << 8) + data[1]) / 10;
		if ( h > 100 ){
			h = data[0];
		}
		float c = (float)(((data[2] & 0x7F) << 8) + data[3]) / 10;
		if ( c > 125 ){
			c = data[2];
		}
		if ( data[2] & 0x80 ){
			c = -c;
		}
		float f = c * 1.8f + 32;
		printf( "Umidade = %.1f %% Temperatura = %.1f *C (%.1f *F)\n", h, c, f );
	}else{
		printf( "Sensor com problemas!\n" );
	}
}

void ldr(){ // Função para leitura de luminosidade do sensor LDR
    #define LDR 7
    int ldr_data;

    pinMode(LDR, INPUT);
    ldr_data = digitalRead(LDR);
    printf("Luminosidade: %d\n", ldr_data);
    delay(500);
    //return ldr_data;
}

void lcd(char data){ // Função para impressão de dados no LCD
    #define LCD_RS  25               
    #define LCD_E   24               
    #define LCD_D4  23               
    #define LCD_D5  22               
    #define LCD_D6  21               
    #define LCD_D7  14                            

    int lcd;
    lcd = lcdInit (2, 16, 4, LCD_RS, LCD_E, LCD_D4, LCD_D5, LCD_D6, LCD_D7, 0, 0, 0, 0);

    lcdPuts(lcd, teste); // Escrevendo no display
}

void mqtt(){ // Função para envio de informações via protocolo MQTT

}

int main(){ // Função principal do sistema
    wiringPiSetup();

    while (1)
    {
        lcd();
        ldr();
        dht11();
        delay(2000);
    }
    return 0;
}