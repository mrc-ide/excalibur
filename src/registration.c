#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void agesirdGenerator_initmod_desolve(void *);
extern void agesirdGenerator_rhs_dde(void *);
extern void agesirdGenerator_rhs_desolve(void *);
extern void seirdGenerator_initmod_desolve(void *);
extern void seirdGenerator_output_dde(void *);
extern void seirdGenerator_rhs_dde(void *);
extern void seirdGenerator_rhs_desolve(void *);
extern void sirdGenerator_initmod_desolve(void *);
extern void sirdGenerator_output_dde(void *);
extern void sirdGenerator_rhs_dde(void *);
extern void sirdGenerator_rhs_desolve(void *);

/* .Call calls */
extern SEXP agesirdGenerator_contents(SEXP);
extern SEXP agesirdGenerator_create(SEXP);
extern SEXP agesirdGenerator_initial_conditions(SEXP, SEXP);
extern SEXP agesirdGenerator_metadata(SEXP);
extern SEXP agesirdGenerator_rhs_r(SEXP, SEXP, SEXP);
extern SEXP agesirdGenerator_set_initial(SEXP, SEXP, SEXP, SEXP);
extern SEXP agesirdGenerator_set_user(SEXP, SEXP);
extern SEXP seirdGenerator_contents(SEXP);
extern SEXP seirdGenerator_create(SEXP);
extern SEXP seirdGenerator_initial_conditions(SEXP, SEXP);
extern SEXP seirdGenerator_metadata(SEXP);
extern SEXP seirdGenerator_rhs_r(SEXP, SEXP, SEXP);
extern SEXP seirdGenerator_set_initial(SEXP, SEXP, SEXP, SEXP);
extern SEXP seirdGenerator_set_user(SEXP, SEXP);
extern SEXP sirdGenerator_contents(SEXP);
extern SEXP sirdGenerator_create(SEXP);
extern SEXP sirdGenerator_initial_conditions(SEXP, SEXP);
extern SEXP sirdGenerator_metadata(SEXP);
extern SEXP sirdGenerator_rhs_r(SEXP, SEXP, SEXP);
extern SEXP sirdGenerator_set_initial(SEXP, SEXP, SEXP, SEXP);
extern SEXP sirdGenerator_set_user(SEXP, SEXP);

static const R_CMethodDef CEntries[] = {
    {"agesirdGenerator_initmod_desolve", (DL_FUNC) &agesirdGenerator_initmod_desolve, 1},
    {"agesirdGenerator_rhs_dde",         (DL_FUNC) &agesirdGenerator_rhs_dde,         1},
    {"agesirdGenerator_rhs_desolve",     (DL_FUNC) &agesirdGenerator_rhs_desolve,     1},
    {"seirdGenerator_initmod_desolve",   (DL_FUNC) &seirdGenerator_initmod_desolve,   1},
    {"seirdGenerator_output_dde",        (DL_FUNC) &seirdGenerator_output_dde,        1},
    {"seirdGenerator_rhs_dde",           (DL_FUNC) &seirdGenerator_rhs_dde,           1},
    {"seirdGenerator_rhs_desolve",       (DL_FUNC) &seirdGenerator_rhs_desolve,       1},
    {"sirdGenerator_initmod_desolve",    (DL_FUNC) &sirdGenerator_initmod_desolve,    1},
    {"sirdGenerator_output_dde",         (DL_FUNC) &sirdGenerator_output_dde,         1},
    {"sirdGenerator_rhs_dde",            (DL_FUNC) &sirdGenerator_rhs_dde,            1},
    {"sirdGenerator_rhs_desolve",        (DL_FUNC) &sirdGenerator_rhs_desolve,        1},
    {NULL, NULL, 0}
};

static const R_CallMethodDef CallEntries[] = {
    {"agesirdGenerator_contents",           (DL_FUNC) &agesirdGenerator_contents,           1},
    {"agesirdGenerator_create",             (DL_FUNC) &agesirdGenerator_create,             1},
    {"agesirdGenerator_initial_conditions", (DL_FUNC) &agesirdGenerator_initial_conditions, 2},
    {"agesirdGenerator_metadata",           (DL_FUNC) &agesirdGenerator_metadata,           1},
    {"agesirdGenerator_rhs_r",              (DL_FUNC) &agesirdGenerator_rhs_r,              3},
    {"agesirdGenerator_set_initial",        (DL_FUNC) &agesirdGenerator_set_initial,        4},
    {"agesirdGenerator_set_user",           (DL_FUNC) &agesirdGenerator_set_user,           2},
    {"seirdGenerator_contents",             (DL_FUNC) &seirdGenerator_contents,             1},
    {"seirdGenerator_create",               (DL_FUNC) &seirdGenerator_create,               1},
    {"seirdGenerator_initial_conditions",   (DL_FUNC) &seirdGenerator_initial_conditions,   2},
    {"seirdGenerator_metadata",             (DL_FUNC) &seirdGenerator_metadata,             1},
    {"seirdGenerator_rhs_r",                (DL_FUNC) &seirdGenerator_rhs_r,                3},
    {"seirdGenerator_set_initial",          (DL_FUNC) &seirdGenerator_set_initial,          4},
    {"seirdGenerator_set_user",             (DL_FUNC) &seirdGenerator_set_user,             2},
    {"sirdGenerator_contents",              (DL_FUNC) &sirdGenerator_contents,              1},
    {"sirdGenerator_create",                (DL_FUNC) &sirdGenerator_create,                1},
    {"sirdGenerator_initial_conditions",    (DL_FUNC) &sirdGenerator_initial_conditions,    2},
    {"sirdGenerator_metadata",              (DL_FUNC) &sirdGenerator_metadata,              1},
    {"sirdGenerator_rhs_r",                 (DL_FUNC) &sirdGenerator_rhs_r,                 3},
    {"sirdGenerator_set_initial",           (DL_FUNC) &sirdGenerator_set_initial,           4},
    {"sirdGenerator_set_user",              (DL_FUNC) &sirdGenerator_set_user,              2},
    {NULL, NULL, 0}
};

void R_init_excalibur(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
