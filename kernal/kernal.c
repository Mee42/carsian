#include "out.h"
#include "colors.h"
#include "memory.h"
#include "byte.h"
#include "bool.h"
#include "memcopy.h"
#include "ports.h"
#include "keyboardInput.h"

void main();
void wait();

void _start(){
  main();
  return;
}


void fill(char color){
    for(int row = 0;row < ROW_MAX;row++){
        for(int col = 0;col < LINE_MAX;col++){
            setCharColored(col,row,colorCodeFor(color,color),' ');
        }
    }
}

int mod(int a,int b){
    return a - (a/b)*b;
}
int abs(int i){
    if(i < 0)
        return -1 * i;
    return i;
}

int isInCircle(
        int x,
        int y,
        int r,
        int X,
        int Y){
    //(x - h)^2 + (y - k)^2 = r^2
    //
    int a = (X - x) * (X - x);
    int b = (Y - y) * (Y - y);
    int rr = r * r;
    return a + b < rr;
}

void drawGreenCircle(){
    int * row = malloc(sizeof(int));
    *row = 0;
    int * col = malloc(sizeof(int));
    while((*row) < ROW_MAX){
        *col = 0;
        while(*col < LINE_MAX){
            char * color = malloc(sizeof(char));
            *color = RED;
            if (isInCircle(
                    20, 12, 10,
                    ((*row) / 2), *col
            )) {
                *color = GREEN;
            }
            setCharColored(*col,*row, colorCodeFor(*color,*color), ' ');
            free(color);
            wait();
            *col = *col + 1;
        }
        *row = (*row) + 1;
    }
    free(row);
    free(col);
}

void stopAndFlash(){
    //doesn't mess with malloc, and we know that we got to that step in the program
    char color = RED;
    while(true) {
        if(color == RED){
            color = GREEN;
        }else{
            color = RED;
        }
        setCharColored(0, 0, colorCodeFor(color, color), ' ');
        wait();
    }
}

void die(char color){
    for (int row = 0; row < ROW_MAX; row ++ ) {
        for (int col = 0; col < LINE_MAX; col ++) {
            setCharColored(col,row,colorCodeFor(color,color),' ');
        }
    }
    while(true){
        //do nothing...fun
    }
}

void assert(byte bool){
    if(bool){
        printCharColored(colorCodeFor(GREEN,GREEN),' ');
    }else{
        printCharColored(colorCodeFor(RED,RED),' ');
    }
    printChar(' ');
}



void main(){
    freeAll();
    printString("$ ");
    keeb();
}



void wait(){
    for(int i = 0;i<0x2ffffff;i++){
        //do nothing
    }
}