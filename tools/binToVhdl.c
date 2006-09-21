#include <stdio.h>
#include <inttypes.h>

#define MAX_MEMORY 262144 //How much memory is to be filled up
#define DIGITS_PER_LINE 64 //How many digits to be printed per line

void processData (uint8_t input); //Function to process data and print it out properly

int main ( int argc, char *argv[]) {

  FILE *fp; //File pointer to open the file
  uint8_t input[DIGITS_PER_LINE / 2];
  unsigned long counter = 0;
  int remainder;
  int index;

  //Ensure right amounts of args received
  if ( argc != 2) {
    printf("Please supply one agrument, Exiting the program\n");
    exit(1);
  }

  //Open the file for reading
  fp = fopen (argv[1],"r");

  //Print out the binary file
  while(feof(fp) == 0) {
    //Grab the input from the file
    input[counter % (DIGITS_PER_LINE / 2)] = fgetc(fp);
    counter++;

    //If we have grabbed enough input for one line
    if (counter % (DIGITS_PER_LINE / 2) == 0) {
      for (index = (DIGITS_PER_LINE / 2 - 1); index > -1; index--) {
	processData(input[index]);
      }
      printf("\n");
    }
  }

  //Fill the remaining input of the line
  remainder = DIGITS_PER_LINE / 2 - (counter % (DIGITS_PER_LINE / 2));

  for (index = 0; index < remainder; index++) {
    printf("ff");
  }
  for (index = (counter % (DIGITS_PER_LINE / 2) - 1); index > -1; index--) {
    processData(input[index]);
  }

  //Increment the counter appropriately
  counter = counter + remainder;
  
  /*  
  //Fill the rest with FF data
  while(counter < MAX_MEMORY) {
    printf("FF");
    counter++;
    if (counter % (DIGITS_PER_LINE / 2) == 0) {
      printf("\n");
    }
  }
  */
  return 0;
}

void processData (uint8_t input) {
  
  //Print the first digit
  if (input % 16 == 0) printf("0");
  else if(input % 16 == 1) printf("8");
  else if(input % 16 == 2) printf("4");
  else if(input % 16 == 3) printf("c");
  else if(input % 16 == 4) printf("2");
  else if(input % 16 == 5) printf("a");
  else if(input % 16 == 6) printf("6");
  else if(input % 16 == 7) printf("e");
  else if(input % 16 == 8) printf("1");
  else if(input % 16 == 9) printf("9");
  else if(input % 16 == 10) printf("5");
  else if(input % 16 == 11) printf("d");
  else if(input % 16 == 12) printf("3");
  else if(input % 16 == 13) printf("b");
  else if(input % 16 == 14) printf("7");
  else if(input % 16 == 15) printf("f");

  //Print the second digit
  if (input / 16 == 0) printf("0");
  else if(input / 16 == 1) printf("8");
  else if(input / 16 == 2) printf("4");
  else if(input / 16 == 3) printf("c");
  else if(input / 16 == 4) printf("2");
  else if(input / 16 == 5) printf("a");
  else if(input / 16 == 6) printf("6");
  else if(input / 16 == 7) printf("e");
  else if(input / 16 == 8) printf("1");
  else if(input / 16 == 9) printf("9");
  else if(input / 16 == 10) printf("5");
  else if(input / 16 == 11) printf("d");
  else if(input / 16 == 12) printf("3");
  else if(input / 16 == 13) printf("b");
  else if(input / 16 == 14) printf("7");
  else if(input / 16 == 15) printf("f");
}
