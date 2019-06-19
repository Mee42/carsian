//
// Created by carson on 6/19/19.
//

#include "memcopy.h"
#include "byte.h"


void memcopy(const void * start, void * end, int bytes){
    char *d = end;
    const char*s = start;
    for(int i = 0;i<bytes;i++){
        d[i] = s[i];
    }

}