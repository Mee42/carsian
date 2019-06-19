//
// Created by carson on 6/18/19.
//

#include "memory.h"
#include "bool.h"
#include "byte.h"

typedef struct block {
    void * ptr;
    byte size;
    bool free;
} block;


static block * storage = (block *)0xB92C00;//way out of the way of video memory
static const int blocks = 0x1000;// 4096, to start
static void * startMemory = (void *)0xF42400;//16~ MB


void freeAll(){
    int index = 0;
    block * b = storage;
    while(index < blocks){
        b->free = true;
        b->size = 0;
        b->ptr = 0x0;
        b++;
        index++;
    }
    storage->free = false;
    storage->size = 0x10;
    storage->ptr = startMemory;
}

void * malloc(byte size){
    block * b = storage;
    while(b->ptr != 0x0){
        //while looking for block
        if(b->free && size <= b->size){
            //use a pre-existing block that's been allocated some memory
            b->free = false;
            return b->ptr;
        }
        b++;
    }
    //if we've reached the max blocks. Crash? Return null?
    if((void *)b > startMemory){
        //error
        //oof
        return 0x0;
    }
    //there is no block that we can use. Delegate a new one
    b->ptr = (b - 1)->ptr + (b - 1)->size;

    b->free = false;
    b->size = size;
    return b->ptr;
}

void* free(void* ptr) {
    block * b = storage;
    int i = 0;
    while(i < blocks){
        if(b->ptr == ptr) {
            b->free = true;
            return b->ptr;
        }
        b++;
        i++;
    }
    return 0x0;
}