//
// Created by carson on 6/18/19.
//

#ifndef CARSIAN_MEMORY_H
#define CARSIAN_MEMORY_H

#include "byte.h"

void freeAll();
void * malloc(byte size);
void * free(void * ptr);

#endif //CARSIAN_MEMORY_H
