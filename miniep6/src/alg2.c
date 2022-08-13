#include <stdlib.h>
#include <string.h>

void matrix_fill_rand(int n, double *restrict _A)
{
    #define A(i, j) _A[n*(i) + (j)]
	int i, j;

	for (i = 0; i < n; ++i)
        for (j = 0; j < n; ++j)
            A(i, j) = 10*(double) rand() / (double) RAND_MAX;

    #undef A
}

void matrix_dgemm_2(int n, double *restrict _C, double *restrict _A, double *restrict _B)
{
    #define A(i, j) _A[n*(i) + (j)]
    #define B(i, j) _B[n*(i) + (j)]
    #define C(i, j) _C[n*(i) + (j)]

    int i, j, k, ii, jj, kk;
    int @BLK@;

    for(ii = 0; ii < n; ii += Ah) {
    for(kk = 0; kk < n; kk += Aw) {
    for(jj = 0; jj < n; jj += Bw) {
    for(i = ii; (i < ii + Ah) && (i < n); ++i)
    for(k = kk; (k < kk + Aw) && (k < n); ++k)
    for(j = jj; (j < jj + Bw) && (j < n); ++j)
    {
        C(i, j) += A(i, k)*B(k, j);
    }}}}

    #undef A
    #undef B
    #undef C
}

int main()
{
    int n = 1024;

    double *restrict A, *restrict B, *restrict C = NULL;
    posix_memalign((void **)&A, 8, n*n*sizeof(*A));
    posix_memalign((void **)&B, 8, n*n*sizeof(*B));
    posix_memalign((void **)&C, 8, n*n*sizeof(*C));
    matrix_fill_rand(n, A);
    matrix_fill_rand(n, B);
    memset(C, 0x00, n*n*sizeof(*A));

    matrix_dgemm_2(n, C, A, B);

    free(A);
    free(B);
    free(C);

    return 0;
}
