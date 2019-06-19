#include "colors.h"
//
// Created by carson on 6/17/19.
//


char colorCodeFor(char foreground,char background){
    return background * 0x10 + foreground;
}