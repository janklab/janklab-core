/* binsearch_mex.c
 *
 * Matlab MEX function implementation of binary search.
 *
 * Arguments:
 *   - Array to search through
 *   - Value to look for
 *
 * Returns index if found, or -1 - index of insertion point if not found.
 * Returned indexes are 0-indexed.
 */

#include "mex.h"

int binsearch_double(double x[], unsigned int n, double target);
int binsearch_float(float x[], unsigned int n, float target);

void mexFunction(int nlhs,
        mxArray *plhs[],
        int nrhs,
        const mxArray *prhs[]
        )
{
    const mxArray *pArg1;
    double *pIxOut;
    double *pX;
    void *pTarget;
    int nRows, nCols;
    unsigned int nElements;
    
    /* Input validation */
    if (nrhs != 2)
        mexErrMsgTxt("binsearch_mex requires exactly two input arguments.");
    if (nlhs > 1)
        mexErrMsgTxt("binsearch_mex requires exactly one output argument.");
    
    /* Arrange inputs and outputs */
	pArg1 = prhs[0];
    nRows = mxGetM(pArg1);
    nCols = mxGetN(pArg1);
    nElements = nRows * nCols;
	if(mxIsEmpty(pArg1) || mxIsComplex(pArg1) || ((nRows > 1) && (nCols >1)) ) { 
            mexErrMsgTxt("Input 1 (data) must be a noncomplex, non-empty vector.");
    }

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    
    
    /* Call main logic */
    pIxOut = mxGetPr(plhs[0]);
    pTarget = mxGetData(prhs[1]);
    pX = mxGetData(prhs[0]);
    if (mxIsDouble(pArg1)) {
        if (!mxIsDouble(prhs[1]))
            mexErrMsgTxt("Input 2 must be double when input 1 is double.");
        *pIxOut = (double)(binsearch_double((double*) pX,
                nElements, *((double*)pTarget)));
    } else if (mxIsSingle(pArg1)) {
        if (!mxIsSingle(prhs[1]))
            mexErrMsgTxt("Input 2 must be single when input 1 is single.");        
        *pIxOut = (double)(binsearch_float((float*) pX,
                nElements, *((float*)pTarget)));
    }
}


/*
 * Binary search on doubles
 */
int binsearch_double(double x[], unsigned int n, double target)
{
    unsigned int low, hi, ix;
    low = 0;
    hi = n;
    while (low < hi) {
    	ix = ( low + hi ) / 2;
        /* mexPrintf("low = %d, hi = %d, ix = %d, x[ix] = %f\n",
                low, hi, ix, x[ix]); */
        if (x[ix] < target) {
            low = ix + 1;
        } else if (x[ix] > target) {
            hi = ix;
        } else if (x[ix] == target) {
            return ix;
        } else {
            /* Uh oh; unexpected case */
        }
    }
    /* Didn't find value */
    return -1 - ix;
}

/*
 * Binary search on floats
 */
int binsearch_float(float x[], unsigned int n, float target)
{
    unsigned int low, hi, ix;
    low = 0;
    hi = n;
    while (low < hi) {
    	ix = ( low + hi ) / 2;
        /* mexPrintf("low = %d, hi = %d, ix = %d, x[ix] = %f\n",
                low, hi, ix, x[ix]); */
        if (x[ix] < target) {
            low = ix + 1;
        } else if (x[ix] > target) {
            hi = ix;
        } else if (x[ix] == target) {
            return ix;
        } else {
            /* Uh oh; unexpected case */
        }
    }
    /* Didn't find value */
    return -1 - ix;
}
