#include "at89c5131.h"
#include "stdio.h"

sbit p0 = P0^0;									
sbit p1 = P0^1;									
sbit p2 = P0^2;									
sbit p3 = P0^3;									
sbit p4 = P0^4;									
sbit p5 = P0^5;									
sbit p6 = P0^6;									
sbit p7 = P0^7;									

void delay_ms(int delay);

int i =0;
void main(void)
{
	P0 = 0X00;											// Make Port 0 output
	while(1)
	{
		// P0 = 0X00;							
		// delay_ms(5000);
		P0 = 0XFF;
		// delay_ms(5000);
		// P0 = 0X08;
		// delay_ms(5000);
		// P0 = 0X02;
		// delay_ms(5000);
		// P0 = 0X20;
		// delay_ms(5000);
		// P0 = 0XF0;
		// delay_ms(5000);
		// P0 = 0XFF;

		
	}
	// while(1)
	// 	{
	// 		if(i == 0) P0 = 0x01;
	// 		else if(i == 1) P0 = 0x02;
	// 		else if(i == 2) P0 = 0x04;
	// 		else if(i == 3) P0 = 0x08;
	// 		else if(i == 4) P0 = 0x20;
	// 		else if(i == 5) P0 = 0x40;
	// 		else if(i == 6) P0 = 0x80;
	// 		else if(i == 7) 
	// 			{
	// 				P0 = 0xF0;
	// 			}
	// 		else
	// 		{
	// 			i = 0;
	// 		}
	// 		i++;
	// 	}	
}

void delay_ms(int delay)					//the delay_ms function has been modified to give a delay of multiples of 1/40 ms
{																	//the number of such delays controls the sampling period
	int d=0;												//or time between samples
	while(delay>0)									//depending on the frequency selected, the function is called with 
	{																//appropriate argument.
		for(d=0;d<10;d++);
		delay--;
	}
}	