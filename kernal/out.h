
#define ROW_MAX 80
#define LINE_MAX 25

void printString(char *c);
void printChar(char c);
void printNewline();
void resetScreen();

void setPointerTo(int line,int row);
void printCharColored(char color, char c);
void printStringColored(char *c,char color);

void movePointerBack();

void setCharColored(int line,int row,char color, char c);