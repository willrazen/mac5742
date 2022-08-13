/* Aqui é onde os testes são implementados */

#include "matrix.h"
#include "time_extra.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Se o seu processador tiver pouco cache (muito lento), talvez seja prático
 * diminuir esses números. Use uma pot. de 2
 */
#define NMIN 256
#define NMAX 2048
#define REP 10

int main()
{
    int N;

    printf("algorithm[int],N[int],time[s],result_check[bool]\n");

    for(N = NMIN; N <= NMAX; N*=2) {
        double *restrict A, *restrict B, *restrict C, *restrict D = NULL;
        posix_memalign((void **)&A, 8, N*N*sizeof(*A));
        posix_memalign((void **)&B, 8, N*N*sizeof(*B));
        posix_memalign((void **)&C, 8, N*N*sizeof(*C));
        posix_memalign((void **)&D, 8, N*N*sizeof(*D));
        double *restrict res[3] = {C, D, D};
        struct timeval t[3];
        struct timeval t1, t2;
        int i, r;

        srand(1337);
        matrix_fill_rand(N, A);
        matrix_fill_rand(N, B);

        for(r = 0; r < REP; ++r) {
            FOR_EACH_DGEMM(i)
            {
                printf("%d,%d,", i, N);
                memset(res[i], 0, N*N*sizeof(*res[i]));
                gettimeofday(&t1, NULL);
                matrix_which_dgemm(i, N, res[i], A, B);
                gettimeofday(&t2, NULL);

                timeval_subtract(&t[i], &t2, &t1);

                printf("%lu.%06lu,",
                        (unsigned long)t[i].tv_sec,
                        (unsigned long)t[i].tv_usec
                );

                if (matrix_eq(N, res[i], C))
                    printf("1");
                else
                {
                    printf("0");
                }
                printf("\n");
            }
        }
    free(A);
    free(B);
    free(C);
    free(D);
    }
}
