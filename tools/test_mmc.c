#include <avr/io.h>
#include <inttypes.h>
#include <avr/signal.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>

#define Mem_Map_Section __attribute__((section(".memmap_section")))

//--------------------------------------------------
// MEMORY MAP REGISTERS
//--------------------------------------------------
#define MMBL _SFR_IO8(0x08)
#define MMBH _SFR_IO8(0x07)
#define MMTL _SFR_IO8(0x06)
#define MMTH _SFR_IO8(0x05)
#define MMPL _SFR_IO8(0x1D)
#define MMPH _SFR_IO8(0x1E)
#define MSR _SFR_IO8(0x04)
#define JTL _SFR_IO8(0x1C)
#define JTH _SFR_IO8(0x1F)

//--------------------------------------------------
// MEMORY MAP STATUS REGISTER CONFIG
//--------------------------------------------------
#define MMP_BLK_SIZE_8 (0x3 << 5)
#define MMP_TWO_DOMAINS (0x1 << 1) // Default is multi-domains
#define MMP_ENABLE 0x1




uint8_t mem_map[64] Mem_Map_Section;

static inline void init_mmc( void ) {
  uint8_t index;

  MMBH = 0x04;
  MMBL = 0x00;

  MMTH = 0x07;
  MMTL = 0xFF;

  MMPH = 0x00;
  MMPL = 0x60;

  JTL = 0x55;
  JTH = 0x55;

  MSR = MMP_BLK_SIZE_8;

  for(index = 0; index < 64; index++)
    mem_map[index] = 0xFF;

}

int main (void) {
  uint8_t ndx;
  register uint8_t* wrPtr = (uint8_t*)0x401;

  DDRA = 0xFF;
  PORTA = 0xFF;
  init_mmc();
  PORTA = 0x00;

  MSR |= MMP_ENABLE; // Start Memoroy Map Controller


  for (ndx = 0; ndx < 20; ndx++)
    wrPtr[ndx] = ndx;
  
  PORTA = 0xFF;

  PORTA = wrPtr[5];

  PORTA = MMBH;
  PORTA = MMBL;
  PORTA = MMTL;
  PORTA = MMTH;
  PORTA = JTH;
  PORTA = MMTH;
  PORTA = JTL;

  // The following causes us to panic
  wrPtr = (uint8_t*)0x800;
  *wrPtr = 10;
  PORTA = 0xFF;

  while (1);
  return 0;
}
