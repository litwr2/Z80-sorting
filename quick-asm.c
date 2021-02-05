#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

#define osz 10
#define sz 40000
#define splimit 20
#define type unsigned short
#define ssz 200
#define swap(x,y) {type t = x; x = y; y = t;}
jmp_buf jmp_point;
type *sa[ssz], **sp;
void push(type *d) {
    *sp-- = d;
}
type* pop() {
    return *++sp;
}
type data[sz];
type x, *ub, *lb, *i2, *j2;
void quick0() {
    sp--;
    if (sp - sa < splimit) {puts("oo");longjmp(jmp_point, 1);}
    i2 = lb;
    j2 = ub;
    x = *(type*)(((unsigned long)j2 + (unsigned long)i2) >> 1 & ~(sizeof(type) - 1));
qsloop1:
    if (*i2 >= x) goto qs_l1;
    i2 += 1;
    goto qsloop1;
qs_l1:
    if (x >= *j2) goto qs_l3;
    j2 -= 1;
    goto qs_l1;
qs_l3:
    if (j2 < i2) goto qs_l8;
    if (j2 != i2) swap(*i2, *j2);
    i2 += 1;
    j2 -= 1;
    if (j2 >= i2) goto qsloop1;
qs_l8:
    if (lb >= j2) goto qs_l5;
    push(i2);
    push(ub);
    ub = j2;
    quick0();
    ub = pop();
    i2 = pop();
qs_l5:
    if (i2 >= ub) goto quit;
    lb = i2;
    quick0();
quit:
    sp++;
}
void quick() {
    type *gub = ub, *glb = lb;
    setjmp(jmp_point);
    sp = sa + ssz - 1;
    ub = gub;
    lb = glb;
    quick0();
}
void fill_for_quadratic_qsort_hoare() {
    data[0] = 1;
    data[1] = 3;
    data[2] = 5;
    data[3] = 0;
    data[4] = 2;
    data[5] = 4;
    for (int i = 3; i < sz/2; i++) {
	    data[2*i] = data[i];
        data[2*i + 1] = data[2*i - 1] + 2;
        data[i] = 2*i + 1;
    }
}
int main() {
    //fill_for_quadratic_qsort_hoare();
    for (int i = 0; i < sz; i++) data[i] = rand()%65536;
    for (int i = 0; i < osz; i++) printf("%d ", data[i]);puts("");
    lb = data;
    ub = data + sz - 1;
    quick();
    for (int i = 0; i < osz; i++) printf("%d ", data[i]);puts("");
    for (int i = 1; i < sz; i++)
        if (data[i - 1] > data[i]) { puts("ERROR!!!"); return 1; }
    return 0;
}
