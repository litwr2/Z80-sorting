#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <libgen.h>
#include <ctype.h>
#include <fcntl.h>
#include <memory.h>
#include "z80sim/sim.h"
#include "z80sim/simglb.h"
#define BUFSIZE	256		/* buffer size for file I/O */

int load_core(void);
extern void int_on(void), int_off(void), mon(void);
extern void init_io(void), exit_io(void);
extern int exatoi(char *);
void print_head(), print_reg(), do_dump(char*), cpu_z80();

uint8_t memcopy[65536];

char* format(size_t a) {
    static char fbuf[30];
    if (a < 1000)
        sprintf(fbuf, "%ld", a);
    else if (a < 1000000)
        sprintf(fbuf, "%d,%03d", a/1000, a%1000);
    else if (a < 1000000000)
        sprintf(fbuf, "%d,%03d,%03d", a/1000000, a%1000000/1000, a%1000);
    else
        sprintf(fbuf, "%d,%03d,%03d,%03d", a/1000000000, a%1000000000/1000000, a%1000000/1000, a%1000);
    return fbuf;
}
int cmp2(const void *i, const void *j) {
    return *(uint16_t*)i - *(uint16_t*)j;
}
int cmp1(const void *i, const void *j) {
    return *(uint8_t*)i - *(uint8_t*)j;
}
int cmp1r(const void *i, const void *j) {
    return *(uint8_t*)j - *(uint8_t*)i;
}
int gena1(int j) {
    if ((j & 1) == 1) return j - 1;
    return gena1(j/2) + j;
}
int gena(int j, int i) {
    if (i == 0) return 0;
    if ((j - i & 1) == 0) return j - i;
    return gena1(j + i - 1 >> 1) + j - i + 1;
}
#include "data.h"
#define SZB (ESZ*SZE)
#define OLIM 9
#define OSZB (OLIM < SZB ? OLIM : SZB)
#define FILLT 1
/* 1 - rnd1, 2 - rnd2, 3 - 2val, 4 - slowqsr, 5 - slowqsl, 6 - rev, 7 - ord, 8 - const */
void filling() {
    unsigned char *memory = ram;
    uint16_t *data = (uint16_t*)(memory + DATAADDR);
#if FILLT==1 || (FILLT==6 || FILLT==7) && ESZ==1
    for (int i = 0; i < SZB; i++) memory[DATAADDR + i] = rand()%256;
#endif
#if FILLT==7 && ESZ==1
    qsort(memory + DATAADDR, SZE, ESZ, cmp1);
#elif FILLT==6 && ESZ==1
    qsort(memory + DATAADDR, SZE, ESZ, cmp1r);
#elif FILLT==3
    for (int i = 0; i < SZB; i++) memory[DATAADDR + i] = rand()%2;
#elif FILLT==2
    for (int i = 1; i < SZB; i++) memory[DATAADDR + i] = (i >> 2 | (memory[DATAADDR + i - 1]  & 3) << 6) + i*i%43;
#elif FILLT==8
    for (int i = 0; i < SZB; i++) memory[DATAADDR + i] = 0xfe;
#elif FILLT==7 && ESZ==2
    for (int i = 0; i < SZB/2; i++) data[i] = i;
#elif FILLT==6 && ESZ==2
    for (int i = 0; i < SZB/2; i++) data[i] = (1U << 16) - 1 - i;
#elif FILLT==4 && ESZ==2
    data[0] = 1;
    data[1] = 3;
    data[2] = 5;
    data[3] = 0;
    data[4] = 2;
    data[5] = 4;
    for (int i = 3; i < SZB/4; i++) {
	    data[2*i] = data[i];
        data[2*i + 1] = data[2*i - 1] + 2;
        data[i] = 2*i + 1;
    }
#elif FILLT==5 && ESZ==2
    for (int i = 0; i < SZE/2; i++) {  //left
        data[SZE/2 - i - 1] = gena(SZE/2, i);
        data[i + SZE/2] = 2*i + 1;
    }
#elif ESZ==1 && (FILLT==4 || FILLT==5)
#error Wrong filling type
#endif
    for (int i = 0; i < 65536; i++) memcopy[i] = memory[i];
#if ESZ==2
    qsort(memcopy + DATAADDR, SZE, ESZ, cmp2);
#else
    qsort(memcopy + DATAADDR, SZE, ESZ, cmp1);
#endif
}

int main(int argc, char *argv[]) {
    FILE *prg;
    unsigned char *mem = ram;
    size_t instructions;
#ifdef CPU_SPEED
	f_flag = CPU_SPEED;
	tmax = CPU_SPEED * 10000;
#endif
     if (argc < 2) return 3;


puts("#######  #####    ###            #####    ###   #     #");
puts("     #  #     #  #   #          #     #    #    ##   ##");
puts("    #   #     # #     #         #          #    # # # #");
puts("   #     #####  #     #  #####   #####     #    #  #  #");
puts("  #     #     # #     #               #    #    #     #");
puts(" #      #     #  #   #          #     #    #    #     #");
puts("#######  #####    ###            #####    ###   #     #");

	printf("\nRelease %s, %s\n", RELEASE, COPYR);
	if (f_flag > 0)
		printf("\nCPU speed is %d MHz\n", f_flag);
	else
		printf("\nCPU speed is unlimited\n");
#ifdef	USR_COM
	printf("\n%s Release %s, %s\n", USR_COM, USR_REL, USR_CPR);
#endif
	fflush(stdout);

	wrk_ram	= PC = ram;
	STACK = ram + 0xffff;
	//int_on();
	init_io();
	//mon();

    printf("ESZ=%d SZB=%d DATA=0x%x\n", ESZ, SZB, DATAADDR);
    if ((prg = fopen(argv[1], "r")) == 0) return 2;
    printf("%lu bytes loaded\n", fread(mem + STARTP, 1, 65536 - STARTP, prg));
    fclose(prg);
    srand(0);
    PC = ram + STARTP;
    instructions = t_states = 0;
    t_flag = 1;
    x_flag = 0;
    filling();
#if ESZ==2
    for (int i = 0; i < OSZB*2; i += 2) printf("%x ", *((uint16_t *) (mem + DATAADDR + i)));puts("");
#else
    for (int i = 0; i < OSZB; i += 1) printf("%x ", mem[DATAADDR + i]);puts("");
#endif
#if 1
//    do_dump("300"); print_head();
    while(*PC != 0x76) {  //halt
        cpu_z80();
        ++instructions;
//        uint8_t *p;print_reg(); p = PC; disass(&p, p - ram);
//        if (PC == mem + 0x1b0 && L%2 == 0) {print_head();print_reg();mon();}
    }
#endif
#if ESZ==2
    for (int i = 0; i < OSZB*2; i += 2) printf("%x ", *((uint16_t*)(mem + DATAADDR + i)));puts("");
#else
    for (int i = 0; i < OSZB; i += 1) printf("%x ", mem[DATAADDR + i]);puts("");
#endif
    printf("total ticks %lu (%s); ", t_states, format(t_states));
    printf("instructions %lu (%s)\n", instructions, format(instructions));
    for (int i = 0; i < SZB; i += ESZ)
#if ESZ==2
        if (*((uint16_t*)(mem + DATAADDR + i)) != *((uint16_t*)(memcopy + DATAADDR + i))) {
            printf("ERROR! %d %x %x\n", i/ESZ, *(uint16_t*)(mem + DATAADDR + i), *(uint16_t*)(memcopy + DATAADDR + i));
#else
        if (mem[DATAADDR + i] != memcopy[DATAADDR + i]) {
            printf("ERROR! %d %x %x\n", i, mem[DATAADDR + i], memcopy[DATAADDR + i]);
#endif
            return 2;
        }
	exit_io();
	//int_off();
	return 0;
}

int load_file(char*s) {
	return 1;
}
