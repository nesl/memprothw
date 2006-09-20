#include <stdio.h>
#include <inttypes.h>

#define MAX_MEMORY 262144 //How much memory is to be filled up
#define DIGITS_PER_LINE 64 //How many digits to be printed per line

void processData (uint8_t input); //Function to process data and print it out properly

int main ( int argc, char *argv[]) {

  FILE *fp; //File pointer to open the file
  uint8_t input;
  unsigned long counter = 0;

  //Ensure right amounts of args received
  if ( argc != 2) {
    printf("Please supply one agrument, Exiting the program\n");
    exit(1);
  }

  //Open the file for reading
  fp = fopen (argv[1],"r");

  //Print out the binary file
  while(feof(fp) == 0) {
    input = fgetc(fp);
    processData(input);
    counter++;

    if (counter % (DIGITS_PER_LINE / 2) == 0) {
      printf("\n");
    }
  }

  
  //Fill the rest with FF data
  while(counter < MAX_MEMORY) {
    printf("FF");
    counter++;
    if (counter % (DIGITS_PER_LINE / 2) == 0) {
      printf("\n");
    }
  }
  
  return 0;
}

void processData (uint8_t input) {
  //Print the first digit
  if (input / 16 > 0) {
    printf("%x",input / 16);
  }
  else {
    printf("0");
  }
  //Print the second digit
  printf("%x",input % 16);
  
}
