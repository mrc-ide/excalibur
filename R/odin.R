## Automatically generated by odin 1.1.15 - do not edit
agesirdGenerator_ <- R6::R6Class(
  "odin_model",
  cloneable = FALSE,

  private = list(
    ptr = NULL,
    use_dde = NULL,

    odin = NULL,
    variable_order = NULL,
    output_order = NULL,
    n_out = NULL,
    ynames = NULL,
    interpolate_t = NULL,
    cfuns = list(
      rhs_dde = "agesirdGenerator_rhs_dde",
      rhs_desolve = "agesirdGenerator_rhs_desolve",
      initmod_desolve = "agesirdGenerator_initmod_desolve",
      output_dde = "agesirdGenerator_output_dde"),
    dll = "excalibur",
    user = c("Alpha", "Betas", "changeTimes", "D0", "Gamma", "I0", "R0", "S0"),

    ## This is never called, but is used to ensure that R finds our
    ## symbols that we will use from the package; without this they
    ## cannot be found by dynamic lookup now that we use the package
    ## FFI registration system.
    registration = function() {
      if (FALSE) {
        .C("agesirdGenerator_rhs_dde", package = "excalibur")
        .C("agesirdGenerator_rhs_desolve", package = "excalibur")
        .C("agesirdGenerator_initmod_desolve", package = "excalibur")
        .C("agesirdGenerator_output_dde", package = "excalibur")
      }
    },

    ## This only does something in delay models
    set_initial = function(t, y, use_dde) {
      .Call("agesirdGenerator_set_initial", private$ptr, t, y, use_dde,
            PACKAGE= "excalibur")
    },

    update_metadata = function() {
      meta <- .Call("agesirdGenerator_metadata", private$ptr,
                    PACKAGE = "excalibur")
      private$variable_order <- meta$variable_order
      private$output_order <- meta$output_order
      private$n_out <- meta$n_out
      private$ynames <- private$odin$make_names(
        private$variable_order, private$output_order, FALSE)
      private$interpolate_t <- meta$interpolate_t
    }
  ),

  public = list(
    initialize = function(..., user = list(...), use_dde = FALSE,
                          unused_user_action = NULL) {
      private$odin <- asNamespace("odin")
      private$ptr <- .Call("agesirdGenerator_create", user, PACKAGE = "excalibur")
      self$set_user(user = user, unused_user_action = unused_user_action)
      private$use_dde <- use_dde
      private$update_metadata()
    },

    ir = function() {
      path_ir <- system.file("odin/agesirdGenerator.json", mustWork = TRUE,
                             package = "excalibur")
      json <- readLines(path_ir)
      class(json) <- "json"
      json
    },

    ## Do we need to have the user-settable args here? It would be
    ## nice, but that's not super straightforward to do.
    set_user = function(..., user = list(...), unused_user_action = NULL) {
      private$odin$support_check_user(user, private$user, unused_user_action)
      .Call("agesirdGenerator_set_user", private$ptr, user, PACKAGE = "excalibur")
      private$update_metadata()
    },

    ## This might be time sensitive and, so we can avoid computing
    ## it. I wonder if that's an optimisation we should drop for now
    ## as it does not seem generally useful. This would bring us
    ## closer to the js version which requires that we always pass the
    ## time in.
    initial = function(t) {
      .Call("agesirdGenerator_initial_conditions", private$ptr, t, PACKAGE = "excalibur")
    },

    rhs = function(t, y) {
      .Call("agesirdGenerator_rhs_r", private$ptr, t, y, PACKAGE = "excalibur")
    },

    deriv = function(t, y) {
      self$rhs(t, y)
    },

    contents = function() {
      .Call("agesirdGenerator_contents", private$ptr, PACKAGE = "excalibur")
    },

    transform_variables = function(y) {
      private$odin$support_transform_variables(y, private)
    },

    run = function(t, y = NULL, ..., use_names = TRUE) {
      private$odin$wrapper_run_ode(
        self, private, t, y, ..., use_names = use_names)
    }
  ))


agesirdGenerator <- function(..., user = list(...), use_dde = FALSE,
                     unused_user_action = NULL) {
  asNamespace("odin")$deprecated_constructor_call("agesirdGenerator")
  agesirdGenerator_$new(user = user, use_dde = use_dde,
                unused_user_action = unused_user_action)
}
class(agesirdGenerator) <- "odin_generator"
attr(agesirdGenerator, "generator") <- agesirdGenerator_
seirdGenerator_ <- R6::R6Class(
  "odin_model",
  cloneable = FALSE,

  private = list(
    ptr = NULL,
    use_dde = NULL,

    odin = NULL,
    variable_order = NULL,
    output_order = NULL,
    n_out = NULL,
    ynames = NULL,
    interpolate_t = NULL,
    cfuns = list(
      rhs_dde = "seirdGenerator_rhs_dde",
      rhs_desolve = "seirdGenerator_rhs_desolve",
      initmod_desolve = "seirdGenerator_initmod_desolve",
      output_dde = "seirdGenerator_output_dde"),
    dll = "excalibur",
    user = c("Alpha", "Betas", "changeTimes", "Gamma", "I0", "Lambda", "S0",
             "D0", "E0", "R0"),

    ## This is never called, but is used to ensure that R finds our
    ## symbols that we will use from the package; without this they
    ## cannot be found by dynamic lookup now that we use the package
    ## FFI registration system.
    registration = function() {
      if (FALSE) {
        .C("seirdGenerator_rhs_dde", package = "excalibur")
        .C("seirdGenerator_rhs_desolve", package = "excalibur")
        .C("seirdGenerator_initmod_desolve", package = "excalibur")
        .C("seirdGenerator_output_dde", package = "excalibur")
      }
    },

    ## This only does something in delay models
    set_initial = function(t, y, use_dde) {
      .Call("seirdGenerator_set_initial", private$ptr, t, y, use_dde,
            PACKAGE= "excalibur")
    },

    update_metadata = function() {
      meta <- .Call("seirdGenerator_metadata", private$ptr,
                    PACKAGE = "excalibur")
      private$variable_order <- meta$variable_order
      private$output_order <- meta$output_order
      private$n_out <- meta$n_out
      private$ynames <- private$odin$make_names(
        private$variable_order, private$output_order, FALSE)
      private$interpolate_t <- meta$interpolate_t
    }
  ),

  public = list(
    initialize = function(..., user = list(...), use_dde = FALSE,
                          unused_user_action = NULL) {
      private$odin <- asNamespace("odin")
      private$ptr <- .Call("seirdGenerator_create", user, PACKAGE = "excalibur")
      self$set_user(user = user, unused_user_action = unused_user_action)
      private$use_dde <- use_dde
      private$update_metadata()
    },

    ir = function() {
      path_ir <- system.file("odin/seirdGenerator.json", mustWork = TRUE,
                             package = "excalibur")
      json <- readLines(path_ir)
      class(json) <- "json"
      json
    },

    ## Do we need to have the user-settable args here? It would be
    ## nice, but that's not super straightforward to do.
    set_user = function(..., user = list(...), unused_user_action = NULL) {
      private$odin$support_check_user(user, private$user, unused_user_action)
      .Call("seirdGenerator_set_user", private$ptr, user, PACKAGE = "excalibur")
      private$update_metadata()
    },

    ## This might be time sensitive and, so we can avoid computing
    ## it. I wonder if that's an optimisation we should drop for now
    ## as it does not seem generally useful. This would bring us
    ## closer to the js version which requires that we always pass the
    ## time in.
    initial = function(t) {
      .Call("seirdGenerator_initial_conditions", private$ptr, t, PACKAGE = "excalibur")
    },

    rhs = function(t, y) {
      .Call("seirdGenerator_rhs_r", private$ptr, t, y, PACKAGE = "excalibur")
    },

    deriv = function(t, y) {
      self$rhs(t, y)
    },

    contents = function() {
      .Call("seirdGenerator_contents", private$ptr, PACKAGE = "excalibur")
    },

    transform_variables = function(y) {
      private$odin$support_transform_variables(y, private)
    },

    run = function(t, y = NULL, ..., use_names = TRUE) {
      private$odin$wrapper_run_ode(
        self, private, t, y, ..., use_names = use_names)
    }
  ))


seirdGenerator <- function(..., user = list(...), use_dde = FALSE,
                     unused_user_action = NULL) {
  asNamespace("odin")$deprecated_constructor_call("seirdGenerator")
  seirdGenerator_$new(user = user, use_dde = use_dde,
                unused_user_action = unused_user_action)
}
class(seirdGenerator) <- "odin_generator"
attr(seirdGenerator, "generator") <- seirdGenerator_
sirdGenerator_ <- R6::R6Class(
  "odin_model",
  cloneable = FALSE,

  private = list(
    ptr = NULL,
    use_dde = NULL,

    odin = NULL,
    variable_order = NULL,
    output_order = NULL,
    n_out = NULL,
    ynames = NULL,
    interpolate_t = NULL,
    cfuns = list(
      rhs_dde = "sirdGenerator_rhs_dde",
      rhs_desolve = "sirdGenerator_rhs_desolve",
      initmod_desolve = "sirdGenerator_initmod_desolve",
      output_dde = "sirdGenerator_output_dde"),
    dll = "excalibur",
    user = c("Alpha", "Betas", "changeTimes", "Gamma", "I0", "S0", "D0", "R0"),

    ## This is never called, but is used to ensure that R finds our
    ## symbols that we will use from the package; without this they
    ## cannot be found by dynamic lookup now that we use the package
    ## FFI registration system.
    registration = function() {
      if (FALSE) {
        .C("sirdGenerator_rhs_dde", package = "excalibur")
        .C("sirdGenerator_rhs_desolve", package = "excalibur")
        .C("sirdGenerator_initmod_desolve", package = "excalibur")
        .C("sirdGenerator_output_dde", package = "excalibur")
      }
    },

    ## This only does something in delay models
    set_initial = function(t, y, use_dde) {
      .Call("sirdGenerator_set_initial", private$ptr, t, y, use_dde,
            PACKAGE= "excalibur")
    },

    update_metadata = function() {
      meta <- .Call("sirdGenerator_metadata", private$ptr,
                    PACKAGE = "excalibur")
      private$variable_order <- meta$variable_order
      private$output_order <- meta$output_order
      private$n_out <- meta$n_out
      private$ynames <- private$odin$make_names(
        private$variable_order, private$output_order, FALSE)
      private$interpolate_t <- meta$interpolate_t
    }
  ),

  public = list(
    initialize = function(..., user = list(...), use_dde = FALSE,
                          unused_user_action = NULL) {
      private$odin <- asNamespace("odin")
      private$ptr <- .Call("sirdGenerator_create", user, PACKAGE = "excalibur")
      self$set_user(user = user, unused_user_action = unused_user_action)
      private$use_dde <- use_dde
      private$update_metadata()
    },

    ir = function() {
      path_ir <- system.file("odin/sirdGenerator.json", mustWork = TRUE,
                             package = "excalibur")
      json <- readLines(path_ir)
      class(json) <- "json"
      json
    },

    ## Do we need to have the user-settable args here? It would be
    ## nice, but that's not super straightforward to do.
    set_user = function(..., user = list(...), unused_user_action = NULL) {
      private$odin$support_check_user(user, private$user, unused_user_action)
      .Call("sirdGenerator_set_user", private$ptr, user, PACKAGE = "excalibur")
      private$update_metadata()
    },

    ## This might be time sensitive and, so we can avoid computing
    ## it. I wonder if that's an optimisation we should drop for now
    ## as it does not seem generally useful. This would bring us
    ## closer to the js version which requires that we always pass the
    ## time in.
    initial = function(t) {
      .Call("sirdGenerator_initial_conditions", private$ptr, t, PACKAGE = "excalibur")
    },

    rhs = function(t, y) {
      .Call("sirdGenerator_rhs_r", private$ptr, t, y, PACKAGE = "excalibur")
    },

    deriv = function(t, y) {
      self$rhs(t, y)
    },

    contents = function() {
      .Call("sirdGenerator_contents", private$ptr, PACKAGE = "excalibur")
    },

    transform_variables = function(y) {
      private$odin$support_transform_variables(y, private)
    },

    run = function(t, y = NULL, ..., use_names = TRUE) {
      private$odin$wrapper_run_ode(
        self, private, t, y, ..., use_names = use_names)
    }
  ))


sirdGenerator <- function(..., user = list(...), use_dde = FALSE,
                     unused_user_action = NULL) {
  asNamespace("odin")$deprecated_constructor_call("sirdGenerator")
  sirdGenerator_$new(user = user, use_dde = use_dde,
                unused_user_action = unused_user_action)
}
class(sirdGenerator) <- "odin_generator"
attr(sirdGenerator, "generator") <- sirdGenerator_
