#include <stdio.h>

int main()
{
    int N;
    double *restrict A = NULL;
    printf("sizeof(N)=%lu\n", sizeof(N));
    printf("sizeof(*A)=%lu\n", sizeof(*A));
}
