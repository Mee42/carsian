#include "out.h"
#include "colors.h"
#include "bool.h"
#include "byte.h"

unsigned int lineIndex = 22;
unsigned int rowIndex = 0;



// 0 - off
// 1 - on
// 2 - or
void setBlinker(int row, int col,int mode){
    int offset = col * 80 + row;
    byte * pos = (byte *)0xb8000;
    pos += (offset * 2) + 1;

    //                    76543210
    byte mask =         0b10000000;
    byte setToZero    = 0b00000000;

    if(mode == 1) {
        *pos = ((*pos) | mask) & ~setToZero;
    }else if(mode == 0){
        *pos = ((*pos) & ~mask) & ~setToZero;
    }else if(mode == 2){
//        *pos = ((*pos) ^ mask) & ~setToZero;
    }
}

void adjustBlinker(){
    for(int r = 0;r<ROW_MAX;r++){
        for(int c = 0;c<LINE_MAX;c++){
            if(r != rowIndex && lineIndex != c) {
                setBlinker(r, c, 0);
            }
        }
    }
    setBlinker(rowIndex,lineIndex,1);
}

void resetScreen(){
    setBlinker(rowIndex,lineIndex,0);
    lineIndex = 21;
    rowIndex = 0;

}

void printNewline(){
    setBlinker(rowIndex,lineIndex,0);
    lineIndex++;
    rowIndex = 0;
}


void movePointerUp(){
    setBlinker(rowIndex,lineIndex,0);
    lineIndex--;
    if(lineIndex == -1){
        lineIndex++;
    }
}
void movePointerDown(){
    setBlinker(rowIndex,lineIndex,0);
    lineIndex++;
    if(lineIndex == LINE_MAX){
        lineIndex--;
    }
}

void movePointerLeft(){
    setBlinker(rowIndex,lineIndex,0);
    rowIndex--;
    if(rowIndex == -1){
        rowIndex = ROW_MAX - 1;
        lineIndex--;
        if(lineIndex == -1){
            lineIndex = 0;//don't go past here
        }
    }
}
void movePointerRight(){
    setBlinker(rowIndex,lineIndex,0);
    rowIndex++;
    if(rowIndex == ROW_MAX){
        rowIndex = 0;
        lineIndex++;
        if(lineIndex == LINE_MAX){
            lineIndex--;
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
    setBlinker(rowIndex,lineIndex,0);
    lineIndex = line;
    rowIndex = row;
}

void printCharColored(char color, char c){
    unsigned int offset = lineIndex * 80 + rowIndex;
    unsigned int pos = 0xb8000;
    pos += (offset * 2);
    setBlinker(rowIndex,lineIndex,0);
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

