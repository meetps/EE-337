/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define LCD_data  P2	    					// LCD Data port
#define input_data P1
// void SPI_Init();
// void Timer_Init();
void sdelay(int delay);
void delay_ms(int delay);

sbit CS_BAR = P1^4;									// Chip Select for the ADC
sbit ONULL = P1^0;
bit transmit_completed= 0;					// To check if spi data transmit is complete
bit offset_null = 0;								// Check if offset nulling is enabled
bit roundoff = 0;
int adcVal=0, avgVal=0, initVal=0;
unsigned char serial_data;
unsigned char data_save_high;
unsigned char data_save_low;
unsigned char temp;
unsigned char count=0, i=0;
unsigned char ch1,ch2;
signed int count1;
int samples;
int square_samples;
/**

 * FUNCTION_INPUTS:  P1.5(MISO) serial input  
 * FUNCTION_OUTPUTS: P1.7(MOSI) serial output
 *                   P1.4(SSbar)
                     P1.6(SCK)
 */
 
void main(void)
{
	P3 = 0X00;											// Make Port 3 output 
	P2 = 0x00;											// Make Port 2 output 
	P1 &= 0xEF;											// Make P1 Pin4-7 output
	P0 &= 0x00;											// Make Port 0 Pins 0,1,2 output
	
	delay_ms(1);
	while(1)												// endless 
	{
		ch1 = P1 & 0x03;						//read last 2 bits (type of waveform)
		ch2 = P1 & 0x0C;						//read next 2 bits (frequency of waveform)
		if (ch2 == 0) samples = 10;
		else if (ch2 == 0x08) samples = 5;		//generate a number that corresponds to the argument of delay function 
		else if (ch2 == 0x0C) samples = 2;		//for a particular frequency
		
		if (ch2 == 0) square_samples = 4;
		else if (ch2 == 0x08) square_samples = 2;		//generate a number that corresponds to the argument of delay function 
		else if (ch2 == 0x0C) square_samples = 1;		//for a particular frequency


		// Square 
		if (ch1 == 0x00)							//square
		{
			
			P0 = 0xFF;				// FFH written to start DAC 
			delay_ms(16*square_samples);
			
			P0 = 0x00;				// 00H written to start DAC
			delay_ms(16*square_samples);				//generates the needed delay between samples for frequency selection
		}


		// DC 
	 	else if (ch1 == 0x03)					//DC output
	 	{
			
			P0 = 0xFF;				// ffH written to start DAC 
	 	}

	 	//Saw-Tooth
	 	else if (ch1 == 0x01)					//sawtooth with 10 samples per cycle
		{ 
			for (count1=0;count1<66;count1++)
				{
					
					temp = (0xFF*count1)/66;			
					P0 = temp;
					
					if (samples == 10 || samples == 5 ) //calculation of delay
						delay_ms(samples - 2);						//required a little fine-tuning to generate the correct values
					else if (samples == 2)
						delay_ms(1);			
				}
		}


		// Triangle 
		 else if (ch1 == 0x02)					//traingle wave with 10 samples per cycle
		{
			 for (count1=0;count1<33;count1++)
					{
					temp = (0xFF*count1)/33;			//increasing values given to DAC
					P0 = temp;

					if (samples == 10 || samples == 5)
						delay_ms(samples - 2);
					else if (samples == 2)
						delay_ms(1);
					}

				for (count1=33;count1>=0;count1--)			//decreasing values given to DAC
					{

					temp = (0xFF*count1)/33;			
					P0 = temp;
					if (samples == 10 || samples == 5)
						delay_ms(samples - 2);
					else if (samples == 2)		//again required some calculation to coorectly set the inter-sample delay
						delay_ms(1);						//same as previous part (sawtooth)
					}
			}
			 
	  }
}


void sdelay(int delay)
{
	char d=0;
	while(delay>0)
	{
		for(d=0;d<5;d++);
		delay--;
	}
}

/**
 * FUNCTION_PURPOSE: A delay of around 1000us for a 24MHz crystel
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void delay_ms(int delay)					//the delay_ms function has been modified to give a delay of multiples of 1/40 ms
{																	//the number of such delays controls the sampling period
	int d=0;												//or time between samples
	while(delay>0)									//depending on the frequency selected, the function is called with 
	{																//appropriate argument.
		for(d=0;d<10;d++);
		delay--;
	}
}