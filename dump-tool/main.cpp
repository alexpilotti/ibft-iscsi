#include <cstdio>
#include <cstring>
#include "ibft.h"
int main(int argn, char** argv){
    if (argn == 1){
        printf("Usage:\n");
        printf("%s dumpfile [-enum](show enum on screen)\n", argv[0]);
        printf("%s -pretty dumpfile\n", argv[0]);
        return 0;
    }
    if (strcmp("-pretty", argv[1]) == 0){
        pretty_print_file(argv[2]);
        while (1);
        return 0;
    }
    int errno;
    FILE* dumpfile;
    fopen_s(&dumpfile, argv[1], "w");
    if (argn == 3){
        if (strcmp("-enum", argv[2]) == 0){
            errno = get_ibft_data(dumpfile, 1);
        }
        else{
            errno = get_ibft_data(dumpfile, 0);
        }
    }
    else{
        errno = get_ibft_data(dumpfile, 0);
    }
    printf("Exit code:%i", errno);
    fclose(dumpfile);
    return errno;
}