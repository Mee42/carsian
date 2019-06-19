#include "out.h"
#include "colors.h"

unsigned int lineIndex = 22;
unsigned int rowIndex = 0;

void resetScreen(){
  lineIndex = 21;
  rowIndex = 0;
}
void printNewline(){
  lineIndex++;
  rowIndex = 0;
}

void movePointerBack(){
    rowIndex--;
    if(rowIndex == -1){
        rowIndex = ROW_MAX - 1;
        lineIndex--;
        if(lineIndex == -1){
            lineIndex = 0;//don't go past here
        }
    }
}

void printString(char * c){
  while(*c != 0){
    printChar(*c);
    c = c + 1;
  }
}
void printStringColored(char * c, char color){
    while(*c != 0){
        printCharColored(color,*c);
        c = c + 1;
    }
}

void setPointerTo(int line, int row){
    lineIndex = line;
    rowIndex = row;
}

void printCharColored(char color, char c){
    unsigned int offset = lineIndex * 80 + rowIndex;
    unsigned int pos = 0xb8000;
    pos += (offset * 2);
    *((char *)pos + 1) = color;
    *((char *)pos) = c;
    rowIndex++;
    if(rowIndex == 80){
        rowIndex = 0;
        lineIndex++;
    }
    if(lineIndex == LINE_MAX){
        lineIndex = 0;
    }
}

void setCharColored(int line,int row,char color, char c){
    unsigned int offset = line * 80 + row;
    unsigned int pos = 0xb8000;
    pos += (offset * 2);
    *((char *)pos + 1) = color;
    *((char *)pos) = c;
}


void printChar(char c){
    printCharColored(colorCodeFor(WHITE,BLACK),c);
}

