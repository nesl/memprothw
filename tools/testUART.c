#include <avr/io.h>
#include <inttypes.h>
#include <avr/signal.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>

#include <avr/io.h>
#include <inttypes.h>

int main () {

  //Initialize
  //It seems like the baud rate is multiplied by 16
  //This sets it to a baud rate of 2400
  
  UBRR = 51;
  UCR = 0x00;
  UCR = (1 << TXEN);
  
  DDRA = 0xFF;
  PORTA = 0x02;
  
  while(1) {
  //Transmit
    while (!(USR & (1<<UDRE)));
    PORTA = PORTA ^ 0xFC;
    UDR = (unsigned char)'U';
  }
  while(1);
  return 0;
}
