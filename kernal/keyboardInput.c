//
// Created by carson on 6/19/19.
//
#include "memory.h"
#include "ports.h"
#include "bool.h"
#include "out.h"
#include "keyboardInput.h"
#include "colors.h"

#define CACHE_SIZE 0x40

#define KEY_ESCAPE 0x01
#define KEY_BACKSPACE 0x0E
#define KEY_TAB 0x0F
#define KEY_ENTER 0x1C
#define KEY_SHIFT 0x2A

byte getReleaseFor(byte in){
//    switch(in){
//        case 0x02: return 0x82;
//        case 0x03: return 0x83;
//        case 0x04: return 0x84;
//    }
//    if(in == 0x0){
//        return 0x0;
//    }
//    return in + 0x80;
    if(in >= 0x01 && in <= 0x54){
        return in + 0x80;
    }
    return 0x0;
}

byte getKeycodeForRelease(byte in){
    if(in == 0x0){
        return 0x0;
    }
    if(in >= 0x81 && in <= 0xD3){
        return in - 0x80;
    }
    return 0x0;
}


bool isReleaseCode(byte code){
    return getKeycodeForRelease(code) != 0x0;
}

byte handleAlias(byte code){
    if(isReleaseCode(code)){
        return getReleaseFor(handleAlias(getKeycodeForRelease(code)));
    }
    switch(code){
        case 0xD2: return 0x0B;//keypad 0
        case 0xCF: return 0x02;//keypad 1
        case 0xD0: return 0x03;//keypad 2
        case 0xD1: return 0x04;//keypad 3
        case 0xCB: return 0x05;//keypad 4
        case 0xCC: return 0x06;//keypad 5
        case 0xCD: return 0x07;//keypad 6
        case 0x47: return 0x08;//keypad 7
        case 0xC8: return 0x09;//keypad 8
        case 0xC9: return 0x0a;//keypad 9
        case 0x36: return 0x2A;//right shift to left shift
    }
    return code;
}

char getKeycodeFor(byte in){
    char * numbers = "1234567890-=??qwertyuiop[]??asdfghjkl;'`?\\zxcvbnm,./?*? ?????????????789-456+1230.";
    if(in >= 0x01 && in <= 0X53){
        return numbers[in - 0x02];
    }

    return 0x0;
}


//cache stores the currently pressed keys
byte * cache = (byte *)0x0;


bool cacheContains(byte in){
    if(in == 0x0){
        return false;
    }
    for(char i = 0;i<CACHE_SIZE;i++){
        if(cache[i] == in){
            return true;
        }
    }
    return false;
}


void removeFromCache(byte b){
    if(b == 0x0){
        return;
    }
    for(char i = 0;i<CACHE_SIZE;i++){
        if(cache[i] == b){
            cache[i] = 0x0;
            return;
        }
    }
}
void addToCache(byte b){
    for(char i = 0;i<CACHE_SIZE;i++){
        if(cache[i] == 0x0){
            cache[i] = b;
            return;
        }
    }
}

char toUpperCase(char in){
    char * lower = "abcdefghjiklmnopqrstuvwxyz`1234567890-=\\[];',./!";//ends with a !
    char * upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()_+|{}:\"<>?!";
    while(*lower != '!'){
//        if(lower[size] == in){
//            return upper[size];
//        }
        if(*lower == in){
            return *upper;
        }
        lower++;
        upper++;

    }
    return in;
}


void outputChar(byte in){
    if(in == KEY_SHIFT) {
        //don't print shifts, dummy
    }else if(in == KEY_BACKSPACE){
        movePointerBack();
        printChar(' ');
        movePointerBack();
    }else if(in == KEY_ENTER){
        printNewline();
    }else if(in == KEY_ESCAPE) {
        setPointerTo(0, 0);
        for (int r = 0; r < ROW_MAX; r++) {
            for (int c = 0; c < LINE_MAX; c++) {
                setCharColored(c, r, colorCodeFor(WHITE, BLACK), ' ');
            }
        }
    } else {
        char c = getKeycodeFor(in);
        if(cacheContains(KEY_SHIFT)){
            c = toUpperCase(c);
        }
        printChar(c);
    }
}

void keeb(){
    cache = malloc(sizeof(byte) * CACHE_SIZE);//64 slots in the array
    //never free the cache, o o f

    for(char i = 0;i<CACHE_SIZE;i++){
        cache[i] = 0x0;
    }


    while(true){
        byte input = handleAlias(port_byte_in(0x60));
        if(!cacheContains(input)){
            if(isReleaseCode(input)){
                byte keycode = getKeycodeForRelease(input);
                removeFromCache(keycode);
            }else{
                //is input
                addToCache(input);
                outputChar(input);
            }
        }else{
            //repeat value, ignore
        }
    }
}
