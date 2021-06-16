// Automatically generated by odin - do not edit
#include <R.h>
#include <Rmath.h>
#include <Rinternals.h>
#include <stdbool.h>
#include <R_ext/Rdynload.h>
#ifndef CINTERPOLTE_CINTERPOLATE_H_
#define CINTERPOLTE_CINTERPOLATE_H_

// Allow use from C++
#ifdef __cplusplus
extern "C" {
#endif

// There are only three functions in the interface; allocation,
// evaluation and freeing.

// Allocate an interpolation object.
//
//   type: The mode of interpolation. Must be one of "constant",
//       "linear" or "spline" (an R error is thrown if a different
//       value is given).
//
//   n: The number of `x` points to interpolate over
//
//   ny: the number of `y` points per `x` point.  This is 1 in the
//       case of zimple interpolation as used by Rs `interpolate()`
//
//   x: an array of `x` values of length `n`
//
//   y: an array of `ny` sets of `y` values.  This is in R's matrix
//       order (i.e., the first `n` values are the first series to
//       interpolate over).
//
//   fail_on_extrapolate: if true, when an extrapolation occurs throw
//       an error; if false return NA_REAL
//
//   auto_free: automatically clean up the interpolation object on
//       return to R. This uses `R_alloc` for allocations rather than
//       `Calloc` so freeing will always happen (even on error
//       elsewhere in the code). However, this prevents returning back
//       a pointer to R that will last longer than the call into C
//       code.
//
// The return value is an opaque pointer that can be passed through to
// `cinterpolate_eval` and `cinterpolate_free`
void *cinterpolate_alloc(const char *type, size_t n, size_t ny,
                         double *x, double *y, bool fail_on_extrapolate,
                         bool auto_free);

// Evaluate the interpolated function at a new `x` point.
//
//   x: A new, single, `x` point to interpolate `y` values to
//
//   obj: The interpolation object, as returned by `cinterpolate_alloc`
//
//   y: An array of length `ny` to store the interpolated values
//
// The return value is 0 if the interpolation is successful (with x
// lying within the range of values that the interpolation function
// supports), -1 otherwise
int cinterpolate_eval(double x, void *obj, double *y);

// Clean up all allocated memory
//
//   obj: The interpolation object, as returned by `cinterpolate_alloc`
void cinterpolate_free(void *obj);

#ifdef __cplusplus
}
#endif

#endif
typedef struct sirdGenerator_internal {
  double Alpha;
  double *Betas;
  double *changeTimes;
  double D0;
  int dim_Betas;
  int dim_changeTimes;
  double Gamma;
  double I0;
  double initial_D;
  double initial_I;
  double initial_R;
  double initial_S;
  void *interpolate_Beta;
  double R0;
  double S0;
} sirdGenerator_internal;
sirdGenerator_internal* sirdGenerator_get_internal(SEXP internal_p, int closed_error);
static void sirdGenerator_finalise(SEXP internal_p);
SEXP sirdGenerator_create(SEXP user);
void sirdGenerator_initmod_desolve(void(* odeparms) (int *, double *));
SEXP sirdGenerator_contents(SEXP internal_p);
SEXP sirdGenerator_set_user(SEXP internal_p, SEXP user);
SEXP sirdGenerator_metadata(SEXP internal_p);
SEXP sirdGenerator_initial_conditions(SEXP internal_p, SEXP t_ptr);
void sirdGenerator_rhs(sirdGenerator_internal* internal, double t, double * state, double * dstatedt, double * output);
void sirdGenerator_rhs_dde(size_t neq, double t, double * state, double * dstatedt, void * internal);
void sirdGenerator_rhs_desolve(int * neq, double * t, double * state, double * dstatedt, double * output, int * np);
void sirdGenerator_output_dde(size_t n_eq, double t, double * state, size_t n_output, double * output, void * internal_p);
SEXP sirdGenerator_rhs_r(SEXP internal_p, SEXP t, SEXP state);
double user_get_scalar_double(SEXP user, const char *name,
                              double default_value, double min, double max);
int user_get_scalar_int(SEXP user, const char *name,
                        int default_value, double min, double max);
void user_check_values_double(double * value, size_t len,
                                  double min, double max, const char *name);
void user_check_values_int(int * value, size_t len,
                               double min, double max, const char *name);
void user_check_values(SEXP value, double min, double max,
                           const char *name);
SEXP user_list_element(SEXP list, const char *name);
void* user_get_array_dim(SEXP user, bool is_integer, void * previous,
                         const char *name, int rank,
                         double min, double max, int *dest_dim);
void* user_get_array(SEXP user, bool is_integer, void * previous,
                     const char *name, double min, double max,
                     int rank, ...);
SEXP user_get_array_check(SEXP el, bool is_integer, const char *name,
                          double min, double max);
SEXP user_get_array_check_rank(SEXP user, const char *name, int rank,
                               bool required);
void interpolate_check_y(size_t nx, size_t ny, size_t i, const char *name_arg, const char *name_target);
sirdGenerator_internal* sirdGenerator_get_internal(SEXP internal_p, int closed_error) {
  sirdGenerator_internal *internal = NULL;
  if (TYPEOF(internal_p) != EXTPTRSXP) {
    Rf_error("Expected an external pointer");
  }
  internal = (sirdGenerator_internal*) R_ExternalPtrAddr(internal_p);
  if (!internal && closed_error) {
    Rf_error("Pointer has been invalidated");
  }
  return internal;
}
void sirdGenerator_finalise(SEXP internal_p) {
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 0);
  if (internal_p) {
    cinterpolate_free(internal->interpolate_Beta);
    internal->interpolate_Beta = NULL;
    Free(internal->Betas);
    Free(internal->changeTimes);
    Free(internal);
    R_ClearExternalPtr(internal_p);
  }
}
SEXP sirdGenerator_create(SEXP user) {
  sirdGenerator_internal *internal = (sirdGenerator_internal*) Calloc(1, sirdGenerator_internal);
  internal->Betas = NULL;
  internal->changeTimes = NULL;
  internal->Alpha = NA_REAL;
  internal->Betas = NULL;
  internal->changeTimes = NULL;
  internal->Gamma = NA_REAL;
  internal->I0 = NA_REAL;
  internal->S0 = NA_REAL;
  internal->D0 = 0;
  internal->R0 = 0;
  SEXP ptr = PROTECT(R_MakeExternalPtr(internal, R_NilValue, R_NilValue));
  R_RegisterCFinalizer(ptr, sirdGenerator_finalise);
  UNPROTECT(1);
  return ptr;
}
static sirdGenerator_internal *sirdGenerator_internal_ds;
void sirdGenerator_initmod_desolve(void(* odeparms) (int *, double *)) {
  static DL_FUNC get_desolve_gparms = NULL;
  if (get_desolve_gparms == NULL) {
    get_desolve_gparms =
      R_GetCCallable("deSolve", "get_deSolve_gparms");
  }
  sirdGenerator_internal_ds = sirdGenerator_get_internal(get_desolve_gparms(), 1);
}
SEXP sirdGenerator_contents(SEXP internal_p) {
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 1);
  SEXP contents = PROTECT(allocVector(VECSXP, 15));
  SET_VECTOR_ELT(contents, 0, ScalarReal(internal->Alpha));
  SEXP Betas = PROTECT(allocVector(REALSXP, internal->dim_Betas));
  memcpy(REAL(Betas), internal->Betas, internal->dim_Betas * sizeof(double));
  SET_VECTOR_ELT(contents, 1, Betas);
  SEXP changeTimes = PROTECT(allocVector(REALSXP, internal->dim_changeTimes));
  memcpy(REAL(changeTimes), internal->changeTimes, internal->dim_changeTimes * sizeof(double));
  SET_VECTOR_ELT(contents, 2, changeTimes);
  SET_VECTOR_ELT(contents, 3, ScalarReal(internal->D0));
  SET_VECTOR_ELT(contents, 4, ScalarInteger(internal->dim_Betas));
  SET_VECTOR_ELT(contents, 5, ScalarInteger(internal->dim_changeTimes));
  SET_VECTOR_ELT(contents, 6, ScalarReal(internal->Gamma));
  SET_VECTOR_ELT(contents, 7, ScalarReal(internal->I0));
  SET_VECTOR_ELT(contents, 8, ScalarReal(internal->initial_D));
  SET_VECTOR_ELT(contents, 9, ScalarReal(internal->initial_I));
  SET_VECTOR_ELT(contents, 10, ScalarReal(internal->initial_R));
  SET_VECTOR_ELT(contents, 11, ScalarReal(internal->initial_S));
  SET_VECTOR_ELT(contents, 13, ScalarReal(internal->R0));
  SET_VECTOR_ELT(contents, 14, ScalarReal(internal->S0));
  SEXP nms = PROTECT(allocVector(STRSXP, 15));
  SET_STRING_ELT(nms, 0, mkChar("Alpha"));
  SET_STRING_ELT(nms, 1, mkChar("Betas"));
  SET_STRING_ELT(nms, 2, mkChar("changeTimes"));
  SET_STRING_ELT(nms, 3, mkChar("D0"));
  SET_STRING_ELT(nms, 4, mkChar("dim_Betas"));
  SET_STRING_ELT(nms, 5, mkChar("dim_changeTimes"));
  SET_STRING_ELT(nms, 6, mkChar("Gamma"));
  SET_STRING_ELT(nms, 7, mkChar("I0"));
  SET_STRING_ELT(nms, 8, mkChar("initial_D"));
  SET_STRING_ELT(nms, 9, mkChar("initial_I"));
  SET_STRING_ELT(nms, 10, mkChar("initial_R"));
  SET_STRING_ELT(nms, 11, mkChar("initial_S"));
  SET_STRING_ELT(nms, 12, mkChar("interpolate_Beta"));
  SET_STRING_ELT(nms, 13, mkChar("R0"));
  SET_STRING_ELT(nms, 14, mkChar("S0"));
  setAttrib(contents, R_NamesSymbol, nms);
  UNPROTECT(4);
  return contents;
}
SEXP sirdGenerator_set_user(SEXP internal_p, SEXP user) {
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 1);
  internal->Alpha = user_get_scalar_double(user, "Alpha", internal->Alpha, NA_REAL, NA_REAL);
  internal->Betas = (double*) user_get_array_dim(user, false, internal->Betas, "Betas", 1, NA_REAL, NA_REAL, &internal->dim_Betas);
  internal->D0 = user_get_scalar_double(user, "D0", internal->D0, NA_REAL, NA_REAL);
  internal->Gamma = user_get_scalar_double(user, "Gamma", internal->Gamma, NA_REAL, NA_REAL);
  internal->I0 = user_get_scalar_double(user, "I0", internal->I0, NA_REAL, NA_REAL);
  internal->R0 = user_get_scalar_double(user, "R0", internal->R0, NA_REAL, NA_REAL);
  internal->S0 = user_get_scalar_double(user, "S0", internal->S0, NA_REAL, NA_REAL);
  internal->initial_D = internal->D0;
  internal->initial_I = internal->I0;
  internal->initial_R = internal->R0;
  internal->initial_S = internal->S0;
  internal->dim_changeTimes = internal->dim_Betas;
  internal->changeTimes = (double*) user_get_array(user, false, internal->changeTimes, "changeTimes", NA_REAL, NA_REAL, 1, internal->dim_changeTimes);
  interpolate_check_y(internal->dim_changeTimes, internal->dim_Betas, 0, "Betas", "Beta");
  cinterpolate_free(internal->interpolate_Beta);
  internal->interpolate_Beta = cinterpolate_alloc("constant", internal->dim_changeTimes, 1, internal->changeTimes, internal->Betas, true, false);
  return R_NilValue;
}
SEXP sirdGenerator_metadata(SEXP internal_p) {
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 1);
  SEXP ret = PROTECT(allocVector(VECSXP, 4));
  SEXP nms = PROTECT(allocVector(STRSXP, 4));
  SET_STRING_ELT(nms, 0, mkChar("variable_order"));
  SET_STRING_ELT(nms, 1, mkChar("output_order"));
  SET_STRING_ELT(nms, 2, mkChar("n_out"));
  SET_STRING_ELT(nms, 3, mkChar("interpolate_t"));
  setAttrib(ret, R_NamesSymbol, nms);
  SEXP variable_length = PROTECT(allocVector(VECSXP, 4));
  SEXP variable_names = PROTECT(allocVector(STRSXP, 4));
  setAttrib(variable_length, R_NamesSymbol, variable_names);
  SET_VECTOR_ELT(variable_length, 0, R_NilValue);
  SET_VECTOR_ELT(variable_length, 1, R_NilValue);
  SET_VECTOR_ELT(variable_length, 2, R_NilValue);
  SET_VECTOR_ELT(variable_length, 3, R_NilValue);
  SET_STRING_ELT(variable_names, 0, mkChar("S"));
  SET_STRING_ELT(variable_names, 1, mkChar("I"));
  SET_STRING_ELT(variable_names, 2, mkChar("R"));
  SET_STRING_ELT(variable_names, 3, mkChar("D"));
  SET_VECTOR_ELT(ret, 0, variable_length);
  UNPROTECT(2);
  SEXP output_length = PROTECT(allocVector(VECSXP, 1));
  SEXP output_names = PROTECT(allocVector(STRSXP, 1));
  setAttrib(output_length, R_NamesSymbol, output_names);
  SET_VECTOR_ELT(output_length, 0, R_NilValue);
  SET_STRING_ELT(output_names, 0, mkChar("Beta"));
  SET_VECTOR_ELT(ret, 1, output_length);
  UNPROTECT(2);
  SET_VECTOR_ELT(ret, 2, ScalarInteger(1));
  SEXP interpolate_t = PROTECT(allocVector(VECSXP, 3));
  SEXP interpolate_t_nms = PROTECT(allocVector(STRSXP, 3));
  setAttrib(interpolate_t, R_NamesSymbol, interpolate_t_nms);
  SET_VECTOR_ELT(interpolate_t, 0, ScalarReal(internal->changeTimes[0]));
  SET_VECTOR_ELT(interpolate_t, 1, ScalarReal(R_PosInf));
  SET_STRING_ELT(interpolate_t_nms, 0, mkChar("min"));
  SET_STRING_ELT(interpolate_t_nms, 1, mkChar("max"));
  SET_VECTOR_ELT(ret, 3, interpolate_t);
  UNPROTECT(2);
  UNPROTECT(2);
  return ret;
}
SEXP sirdGenerator_initial_conditions(SEXP internal_p, SEXP t_ptr) {
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 1);
  SEXP r_state = PROTECT(allocVector(REALSXP, 4));
  double * state = REAL(r_state);
  state[0] = internal->initial_S;
  state[1] = internal->initial_I;
  state[2] = internal->initial_R;
  state[3] = internal->initial_D;
  UNPROTECT(1);
  return r_state;
}
void sirdGenerator_rhs(sirdGenerator_internal* internal, double t, double * state, double * dstatedt, double * output) {
  double S = state[0];
  double I = state[1];
  double R = state[2];
  double D = state[3];
  dstatedt[3] = I * internal->Alpha;
  dstatedt[2] = I * internal->Gamma;
  double N = S + I + R + D;
  double Beta = 0.0;
  cinterpolate_eval(t, internal->interpolate_Beta, &Beta);
  dstatedt[1] = Beta * S * I / (double) N - I * internal->Gamma - I * internal->Alpha;
  dstatedt[0] = -(Beta) * S * I / (double) N;
  if (output) {
    output[0] = Beta;
  }
}
void sirdGenerator_rhs_dde(size_t neq, double t, double * state, double * dstatedt, void * internal) {
  sirdGenerator_rhs((sirdGenerator_internal*)internal, t, state, dstatedt, NULL);
}
void sirdGenerator_rhs_desolve(int * neq, double * t, double * state, double * dstatedt, double * output, int * np) {
  sirdGenerator_rhs(sirdGenerator_internal_ds, *t, state, dstatedt, output);
}
void sirdGenerator_output_dde(size_t n_eq, double t, double * state, size_t n_output, double * output, void * internal_p) {
  sirdGenerator_internal *internal = (sirdGenerator_internal*) internal_p;
  double Beta = 0.0;
  cinterpolate_eval(t, internal->interpolate_Beta, &Beta);
  output[0] = Beta;
}
SEXP sirdGenerator_rhs_r(SEXP internal_p, SEXP t, SEXP state) {
  SEXP dstatedt = PROTECT(allocVector(REALSXP, LENGTH(state)));
  sirdGenerator_internal *internal = sirdGenerator_get_internal(internal_p, 1);
  SEXP output_ptr = PROTECT(allocVector(REALSXP, 1));
  setAttrib(dstatedt, install("output"), output_ptr);
  UNPROTECT(1);
  double *output = REAL(output_ptr);
  sirdGenerator_rhs(internal, REAL(t)[0], REAL(state), REAL(dstatedt), output);
  UNPROTECT(1);
  return dstatedt;
}
double user_get_scalar_double(SEXP user, const char *name,
                              double default_value, double min, double max) {
  double ret = default_value;
  SEXP el = user_list_element(user, name);
  if (el != R_NilValue) {
    if (length(el) != 1) {
      Rf_error("Expected a scalar numeric for '%s'", name);
    }
    if (TYPEOF(el) == REALSXP) {
      ret = REAL(el)[0];
    } else if (TYPEOF(el) == INTSXP) {
      ret = INTEGER(el)[0];
    } else {
      Rf_error("Expected a numeric value for %s", name);
    }
  }
  if (ISNA(ret)) {
    Rf_error("Expected a value for '%s'", name);
  }
  user_check_values_double(&ret, 1, min, max, name);
  return ret;
}
int user_get_scalar_int(SEXP user, const char *name,
                        int default_value, double min, double max) {
  int ret = default_value;
  SEXP el = user_list_element(user, name);
  if (el != R_NilValue) {
    if (length(el) != 1) {
      Rf_error("Expected scalar integer for %d", name);
    }
    if (TYPEOF(el) == REALSXP) {
      double tmp = REAL(el)[0];
      if (fabs(tmp - round(tmp)) > 2e-8) {
        Rf_error("Expected '%s' to be integer-like", name);
      }
    }
    ret = INTEGER(coerceVector(el, INTSXP))[0];
  }
  if (ret == NA_INTEGER) {
    Rf_error("Expected a value for '%s'", name);
  }
  user_check_values_int(&ret, 1, min, max, name);
  return ret;
}
void user_check_values_double(double * value, size_t len,
                                  double min, double max, const char *name) {
  for (size_t i = 0; i < len; ++i) {
    if (ISNA(value[i])) {
      Rf_error("'%s' must not contain any NA values", name);
    }
  }
  if (min != NA_REAL) {
    for (size_t i = 0; i < len; ++i) {
      if (value[i] < min) {
        Rf_error("Expected '%s' to be at least %g", name, min);
      }
    }
  }
  if (max != NA_REAL) {
    for (size_t i = 0; i < len; ++i) {
      if (value[i] > max) {
        Rf_error("Expected '%s' to be at most %g", name, max);
      }
    }
  }
}
void user_check_values_int(int * value, size_t len,
                               double min, double max, const char *name) {
  for (size_t i = 0; i < len; ++i) {
    if (ISNA(value[i])) {
      Rf_error("'%s' must not contain any NA values", name);
    }
  }
  if (min != NA_REAL) {
    for (size_t i = 0; i < len; ++i) {
      if (value[i] < min) {
        Rf_error("Expected '%s' to be at least %g", name, min);
      }
    }
  }
  if (max != NA_REAL) {
    for (size_t i = 0; i < len; ++i) {
      if (value[i] > max) {
        Rf_error("Expected '%s' to be at most %g", name, max);
      }
    }
  }
}
void user_check_values(SEXP value, double min, double max,
                           const char *name) {
  size_t len = (size_t)length(value);
  if (TYPEOF(value) == INTSXP) {
    user_check_values_int(INTEGER(value), len, min, max, name);
  } else {
    user_check_values_double(REAL(value), len, min, max, name);
  }
}
SEXP user_list_element(SEXP list, const char *name) {
  SEXP ret = R_NilValue, names = getAttrib(list, R_NamesSymbol);
  for (int i = 0; i < length(list); ++i) {
    if (strcmp(CHAR(STRING_ELT(names, i)), name) == 0) {
      ret = VECTOR_ELT(list, i);
      break;
    }
  }
  return ret;
}
void* user_get_array_dim(SEXP user, bool is_integer, void * previous,
                         const char *name, int rank,
                         double min, double max, int *dest_dim) {
  SEXP el = user_get_array_check_rank(user, name, rank, previous == NULL);
  if (el == R_NilValue) {
    return previous;
  }

  dest_dim[0] = LENGTH(el);
  if (rank > 1) {
    SEXP r_dim = PROTECT(coerceVector(getAttrib(el, R_DimSymbol), INTSXP));
    int *dim = INTEGER(r_dim);

    for (size_t i = 0; i < (size_t) rank; ++i) {
      dest_dim[i + 1] = dim[i];
    }

    UNPROTECT(1);
  }

  el = PROTECT(user_get_array_check(el, is_integer, name, min, max));

  int len = LENGTH(el);
  void *dest = NULL;
  if (is_integer) {
    dest = Calloc(len, int);
    memcpy(dest, INTEGER(el), len * sizeof(int));
  } else {
    dest = Calloc(len, double);
    memcpy(dest, REAL(el), len * sizeof(double));
  }
  Free(previous);

  UNPROTECT(1);

  return dest;
}
void* user_get_array(SEXP user, bool is_integer, void * previous,
                     const char *name, double min, double max,
                     int rank, ...) {
  SEXP el = user_get_array_check_rank(user, name, rank, previous == NULL);
  if (el == R_NilValue) {
    return previous;
  }

  SEXP r_dim;
  int *dim;

  size_t len = LENGTH(el);
  if (rank == 1) {
    r_dim = PROTECT(ScalarInteger(len));
  } else {
    r_dim = PROTECT(coerceVector(getAttrib(el, R_DimSymbol), INTSXP));
  }
  dim = INTEGER(r_dim);

  va_list ap;
  va_start(ap, rank);
  for (size_t i = 0; i < (size_t) rank; ++i) {
    int dim_expected = va_arg(ap, int);
    if (dim[i] != dim_expected) {
      va_end(ap); // avoid a leak
      if (rank == 1) {
        Rf_error("Expected length %d value for %s", dim_expected, name);
      } else {
        Rf_error("Incorrect size of dimension %d of %s (expected %d)",
                 i + 1, name, dim_expected);
      }
    }
  }
  va_end(ap);
  UNPROTECT(1);

  el = PROTECT(user_get_array_check(el, is_integer, name, min, max));

  void *dest = NULL;
  if (is_integer) {
    dest = Calloc(len, int);
    memcpy(dest, INTEGER(el), len * sizeof(int));
  } else {
    dest = Calloc(len, double);
    memcpy(dest, REAL(el), len * sizeof(double));
  }
  Free(previous);

  UNPROTECT(1);

  return dest;
}
SEXP user_get_array_check(SEXP el, bool is_integer, const char *name,
                          double min, double max) {
  size_t len = (size_t) length(el);
  if (is_integer) {
    if (TYPEOF(el) == INTSXP) {
      user_check_values_int(INTEGER(el), len, min, max, name);
    } else if (TYPEOF(el) == REALSXP) {
      el = PROTECT(coerceVector(el, INTSXP));
      user_check_values_int(INTEGER(el), len, min, max, name);
      UNPROTECT(1);
    } else {
      Rf_error("Expected a integer value for %s", name);
    }
  } else {
    if (TYPEOF(el) == INTSXP) {
      el = PROTECT(coerceVector(el, REALSXP));
      user_check_values_double(REAL(el), len, min, max, name);
      UNPROTECT(1);
    } else if (TYPEOF(el) == REALSXP) {
      user_check_values_double(REAL(el), len, min, max, name);
    } else {
      Rf_error("Expected a numeric value for %s", name);
    }
  }
  return el;
}
SEXP user_get_array_check_rank(SEXP user, const char *name, int rank,
                               bool required) {
  SEXP el = user_list_element(user, name);
  if (el == R_NilValue) {
    if (required) {
      Rf_error("Expected a value for '%s'", name);
    }
  } else {
    if (rank == 1) {
      if (isArray(el)) {
        Rf_error("Expected a numeric vector for '%s'", name);
      }
    } else {
      SEXP r_dim = getAttrib(el, R_DimSymbol);
      if (r_dim == R_NilValue || LENGTH(r_dim) != rank) {
        if (rank == 2) {
          Rf_error("Expected a numeric matrix for '%s'", name);
        } else {
          Rf_error("Expected a numeric array of rank %d for '%s'", rank, name);
        }
      }
    }
  }
  return el;
}
void interpolate_check_y(size_t nx, size_t ny, size_t i, const char *name_arg, const char *name_target) {
  if (nx != ny) {
    if (i == 0) {
      // vector case
      Rf_error("Expected %s to have length %d (for %s)",
               name_arg, nx, name_target);
    } else {
      // array case
      Rf_error("Expected dimension %d of %s to have size %d (for %s)",
               i, name_arg, nx, name_target);
    }
  }
}
// This construction is to help odin
#ifndef CINTERPOLTE_CINTERPOLATE_H_
#endif


void * cinterpolate_alloc(const char *type, size_t n, size_t ny,
                          double *x, double *y, bool fail_on_extrapolate,
                          bool auto_clean) {
  typedef void* interpolate_alloc_t(const char *, size_t, size_t,
                                    double*, double*, bool, bool);
  static interpolate_alloc_t *fun;
  if (fun == NULL) {
    fun = (interpolate_alloc_t*)
      R_GetCCallable("cinterpolate", "interpolate_alloc");
  }
  return fun(type, n, ny, x, y, fail_on_extrapolate, auto_clean);
}


int cinterpolate_eval(double x, void *obj, double *y) {
  typedef int interpolate_eval_t(double, void*, double*);
  static interpolate_eval_t *fun;
  if (fun == NULL) {
    fun = (interpolate_eval_t*)
      R_GetCCallable("cinterpolate", "interpolate_eval");
  }
  return fun(x, obj, y);
}


void cinterpolate_free(void *obj) {
  typedef int interpolate_free_t(void*);
  static interpolate_free_t *fun;
  if (fun == NULL) {
    fun = (interpolate_free_t*)
      R_GetCCallable("cinterpolate", "interpolate_free");
  }
  fun(obj);
}
