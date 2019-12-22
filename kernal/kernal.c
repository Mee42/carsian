void main();


void _start(){
  main();
  return;
}


void main(){
  *((char *)0xb8000) = 'X'; 
  while(1){
      *((char *)0xb8002) = 'A';
  }
  return;
}

