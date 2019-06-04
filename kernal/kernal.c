//#include <stdint.h>

unsigned int lineIndex = 22;
unsigned int rowIndex = 0;


void printChar(char c);
void printString(char * c);
void printNewline();

void main(){
  printString("Starting 32-bit C");
  printNewline();
  printString("Initualizing screen buffer");



}

void printNewline(){
  lineIndex++;
  rowIndex = 0;  
}

void printString(char * c){
  while(*c != 0){
    printChar(*c);
    c = c + 1;
  }


}
void printChar(char c){
  unsigned int pos = 0xb8000;
  unsigned int offset = lineIndex * 80 + rowIndex;
  pos += offset * 2;
  *((char *)pos) = c;
  rowIndex++;
  if(rowIndex == 80){
    rowIndex = 0;
    lineIndex++;
  }
  if(lineIndex == 25){
    for(int line = 1;line < 25;line++){
      
    
  }
}
