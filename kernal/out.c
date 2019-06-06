#include "out.h"

int * lineIndex = (int *)0x1001;
int * rowIndex = (int *)(0x1001 + sizeof(int));
int * updated = (int *)(0x1001 + 2*sizeof(int));

void resetScreen(){
  *lineIndex = 21;
  *rowIndex = 0;
}
//unsigned int lineIndex = 22;
//unsigned int rowIndex = 0;

void printNewline(){
  *lineIndex++;
  *rowIndex = 0;
}

void printString(char * c){
  while(*c != 0){
    printChar(*c);
    c = c + 1;
  }

}

void printChar(char c){
  unsigned int pos = 0xb8000;
  unsigned int offset = *lineIndex * 80 + *rowIndex;
  pos += offset * 2;
  *((char *)pos) = c;
  *rowIndex++;
  if(*rowIndex == 80){
    *rowIndex = 0;
    *lineIndex++;
  }
}

