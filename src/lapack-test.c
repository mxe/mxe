/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

/*  taken from https://www.netlib.org/lapack/lapacke.html */

/*  Calling CGEQRF and CUNGQR to compute Q with workspace querying */

#include <stdio.h>
#include <stdlib.h>
#include <lapacke_utils.h>
#include <cblas.h>

int main (int argc, const char * argv[])
{
   (void)argc;
   (void)argv;

   lapack_complex_float *a,*tau,*r,*work,one,zero,query;
   lapack_int info,m,n,lda,lwork;
   int i,j;
   float err;
   m = 10;   n = 5;   lda = m;
   one = lapack_make_complex_float(1.0,0.0);
   zero= lapack_make_complex_float(0.0,0.0);
   a = calloc(m*n,sizeof(lapack_complex_float));
   r = calloc(n*n,sizeof(lapack_complex_float));
   tau = calloc(m,sizeof(lapack_complex_float));
   for(j=0;j<n;j++)
      for(i=0;i<m;i++)
         a[i+j*m] = lapack_make_complex_float(i+1,j+1);
   info = LAPACKE_cgeqrf_work(LAPACK_COL_MAJOR,m,n,a,lda,tau,&query,-1);
   lwork = (lapack_int)query;
   info = LAPACKE_cungqr_work(LAPACK_COL_MAJOR,m,n,n,a,lda,tau,&query,-1);
   lwork = MAX(lwork,(lapack_int)query);
   work = calloc(lwork,sizeof(lapack_complex_float));
   info = LAPACKE_cgeqrf_work(LAPACK_COL_MAJOR,m,n,a,lda,tau,work,lwork);
   info = LAPACKE_cungqr_work(LAPACK_COL_MAJOR,m,n,n,a,lda,tau,work,lwork);
   for(j=0;j<n;j++)
      for(i=0;i<n;i++)
         r[i+j*n]=(i==j)?-one:zero;
   cblas_cgemm(CblasColMajor,CblasConjTrans,CblasNoTrans,
               n,n,m,&one,a,lda,a,lda,&one,r,n);
   err=0.0;
   for(i=0;i<n;i++)
      for(j=0;j<n;j++)
         err=MAX(err,cabs(r[i+j*n]));
   printf("error=%e\n",err);
   free(work);
   free(tau);
   free(r);
   free(a);
   return(info);
}
