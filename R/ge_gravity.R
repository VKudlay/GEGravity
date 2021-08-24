#' @title Solves a general equilibrium one sector Armington-CES trade model.
#'
#' @description
#'   \code{ge_gravity} solves for general equilibrium effects of changes in trade policies
#'   using a one sector Armington-CES trade model. It uses a simple fixed point
#'   algorithm that allows for fast computation that makes this program
#'   ideal for bootstrapping confidence intervals for general equilibrium simulations
#'   based on prior gravity estimates of FTAs or other similar variables.
#'
#'   Examples of references that conduct general equilibrium analysis based on FTA
#'   estimates in this way include Egger, Larch, Staub, & Winkelmann (2011),
#'   Anderson & Yotov (2016), and Baier, Yotov, & Zylkin (2019). Yotov, Piermartini,
#'   Monteiro, & Larch (2016) provide a detailed survey and introduction to the topic.
#'
#' @param exp_id
#'    String representation of the exporter/origin country associated with each observation.
#'    This is arbitrary and for organization purposes only, i.e. AUS, Australia
#' @param imp_id
#'    String representation of the importer/destination country associated with each observation.
#'    This is arbitrary and for organization purposes only, i.e. AUS, Australia
#' @param flows
#'    Observed trade flows in the data for the year being used as the baseline for the counterfactual.
#' @param beta
#'    An input reflecting the "partial" change in trade, typically obtained as a coefficient from a
#'    prior gravity estimation.
#' @param theta
#'    Overall trade elasticity
#' @param mult
#'    If true, assume that national expenditure is a fixed multiple of national output,
#'    as in Anderson & Yotov (2016).
#'    Otherwise (and by default), handle unbalances in the data by treating the
#'    trade balance as an additive component of national expenditure (see below).
#' @param data
#'    A list to which we should add the new values. By default, this is an empty list.
#'    Note that this will be converted to a named dataframe on output.
#'
#' @return A dataframe element containing resulting estimations of impacts.
#'    Specifically, it returns results for general equilibrium changes in trade flows,
#'    welfare, and real wages as a result of the change in trade frictions.
#'    If `data` is specified, the results will be added as columns.
#'
#'    This data will include the following:
#'    \itemize{
#'     \item \code{new_trade}:   The new level of trade for each pair of countries.
#'     \item \code{welfare}:     The exporter's change in welfare (new/old level of welfare)
#'     \item \code{real_wage}:   The exporter's change in real wage (new/old real wage). \cr
#'        Note: this is generally different from the change in welfare
#'        unless either trade is balanced or the "multiplicative" option is chosen.
#'     \item \code{nom_wage}:    The exporter's change in nominal wage (new/old nom wage).
#'     \item \code{price_index}: The exporter's change in price index (new/old price index)
#'    }
#'
#' @details
#' Please see \code{browseVignettes("GEGravity")} for additional details.
#'
#' @references
#' Please see \code{browseVignettes("GEGravity")} for information on references and sources.
#'
#' @seealso The vignettes allow you to access very explanatory RMD files to augment documentation.
#'      Please check them out!
#'
#' @examples
#' # For a detailed explanation, check out the vignettes (see \code{browseVignettes("GEGravity")})
#'
#' # Foreign trade subset
#' f_trade <- TradeData0014[TradeData0014$exporter != TradeData0014$importer,]
#'
#' # Normalize trade data to unit interval
#' f_trade$trade <- f_trade$trade / max(f_trade$trade)
#'
#' # classify FEs for components to be absorbed (finding variable interactions)
#' f_trade$exp_year <- interaction(f_trade$expcode, f_trade$year)
#' f_trade$imp_year <- interaction(f_trade$impcode, f_trade$year)
#' f_trade$pair     <- interaction(f_trade$impcode, f_trade$expcode)
#'
#' # Fit generalized linear model based on specifications
#' partials <- alpaca::feglm(
#'   formula = trade ~ eu_enlargement + other_fta | exp_year + imp_year + pair,
#'   data    = f_trade,
#'   family  = poisson()
#' )$coefficient  # We just need the coefficients for computation
#'
#' # Sort trade matrix to make it easier to find imp/exp pairs
#' t_trade <- TradeData0014[order(
#'   TradeData0014$exporter,
#'   TradeData0014$importer,
#'   TradeData0014$year
#' ),]
#'
#' t_trade$eu_effect <- NA      # Column for the partial effect of EU membership for new EU pairs
#' i <- 1
#' # Effect of EU entrance on country based on partial, if entry happened
#' invisible(by(t_trade, list(t_trade$expcode, t_trade$impcode), function(row) {
#'   # Was a new EU pair created within time span?
#'   t_trade[i:(i+nrow(row)-1), "eu_effect"] <<- diff(row$eu_enlargement, lag=nrow(row)-1)
#'   i <<- i + nrow(row)
#' }))
#' # If added to EU, give it the computed partial eu_enlargement coefficient as the effect
#' t_trade$eu_effect = t_trade$eu_effect * partials[1]
#'
#' # Data to be finally fed to the function
#' data <- t_trade[t_trade$year == 2000,]
#'
#' ## Running Actual Computations
#'
#' ## Difference between w_mult and w_o_mult is how trade balance is considered
#' ## mult = TRUE assumes multiplicative trade balances; false assumes additive
#'
#' w_mult = ge_gravity(
#'   exp_id = data$expcode,     # Origin country associated with each observation
#'   imp_id = data$impcode,     # Destination country associated with each observation
#'   flows  = data$trade,       # Observed trade flows for the baseline year
#'   beta   = data$eu_effect,   # "Partial" trade change; coefficient from gravity estimation
#'   theta  = 4,                # Trade elasticity
#'   mult   = TRUE,             # Assume national expenditure is fixed multiple of nat. output
#'   data   = data
#' )
#'
#' w_o_mult = ge_gravity(
#'   data$expcode,              # Origin country associated with each observation
#'   data$impcode,              # Destination country associated with each observation
#'   data$trade,                # Observed trade flows for the baseline year
#'   data$eu_effect,            # "Partial" change in trade; coefficient from gravity estimation
#'   4,                         # Trade elasticity
#'   FALSE,                     # Assume trade balance is additive component of nat. expenditure
#'   data
#' )
#'
#' @export

ge_gravity <- function(
  exp_id,
  imp_id,
  flows,
  beta,
  theta = 1,
  mult  = FALSE,
  data  = list()
) {

  ################################################################
  ## Pre-Processing
  ################################################################

  if(!is.logical(mult)) {
    # If user specifies "multiplicative" option for trade imbalances
    warning("'mult' parameter non-numeric, assumed to be false")
    mult <- FALSE
  }

  # First set up the set of international trade flows matrix, X_{ij}.
  # This is the set of flows arranged in a exporter by importer fashion.
  X <- flows
  N <- sqrt(length(X))        # Length of row or column of trade matrix
  X <- t(matrix(flows, N, N)) # Square the matrix

  # Length of row or column of trade matrix
  N <- sqrt(length(X))

  if (floor(N) != N) {
    # Ensure data set includes all possible flows for each location
    stop("Non-square data set detected. The size of the data should be NxN.
      Check whether every location has N trade partners, including itself.
      Exiting.\n")
  }

  countNaN <- 0
  for(i in 1:length(X)) {
    if (is.nan(X[i])) {
      # Check if matrix has missing values
      countNaN <- countNaN + 1
      X[i] <- 0
    } else if (X[i] < 0) {
      # Check if matrix has negative values; terminate if found
      stop("Negative flow values detected. Exiting.")
    }
  }
  if(countNaN > 0) {
    warning("Flow values missing for at least 1 pair; assumed to be zero.")
  }

  countNaN <- 0
  for(i in 1:length(beta)) {
    if(is.nan(beta[i])) {
      # Check if partials matrix has missing values
      countNaN <- countNaN + 1
      beta[i] <- 0
    }
  }
  if(countNaN > 0) {
    warning("Beta values missing for at least 1 pair; assumed to be zero.\n")
  }

  # "B" (= e^beta) is the matrix of partial effects
  B <- beta
  dim(B)  <- c(N, N) # Format B to have N columns

  if(any(diag(B) != 0)) {
    # Flash warning if betas on the diagonal are not zero.
    warning("Non-zero beta values for some Beta terms detected. These have been set to zero.\n")
    diag(B) <- 0
  }

  B <- exp(B)

  # Set up Y, E, D vectors; calculate trade balances
  E <- matrix(colSums(X),N,1) # Total National Expendatures; Value of import for all origin
  Y <- matrix(rowSums(X),N,1) # Total Labor Income; Value of exports for all destinations;
  D <- E - Y                  # D: National trade deficit / surplus

  # set up pi_ij matrix of trade shares; pi_ij = X_ij/E_j
  Pi <- X / kronecker(t(E), matrix(1,N,1))  # Bilateral trade share

  ################################################################
  ## Setting up iterable loop
  ################################################################

  # Initialize w_i_hat = P_j_hat = 1
  w_hat <- P_hat <- matrix(1, N, 1)    # Wi = Ei/Pi

  # While Loop Initializations
  X_new     <- X         # Container for updated X
  crit      <- 1         # Convergence testing value
  curr_iter <- 0         # Current number of iterations
  max_iter  <- 1000000   # Maximum number of iterations
  tol       <- .00000001 # Threshold before sufficient convergence

  # B = i x j
  # D = 1 x j
  # E = 1 x j
  # w_hat = P_hat = i x 1
  # Y = E = D = i x 1

  repeat { # Event Loop (using repeat to simulate do-while)

    X_last_step <- X_new

    #### Step 1: Update w_hat_i for all origins:
    eqn_base <- ((Pi * B) %*% (E / P_hat)) / Y
    w_hat    <- eqn_base^(1/(1+theta))

    #### Step 2: Normalize so total world output stays the same
    w_hat <- w_hat * (sum(Y) / sum(Y*w_hat))

    #### Step 3: update P_hat_j
    P_hat <- (t(Pi) * t(B)) %*% (w_hat^(-theta))

    #### Step 4: Update $E_j$
    if (mult) {
      E <- (Y + D) * w_hat
    } else {
      E <- Y * w_hat + D  # default is to have additive trade imbalances
    }

    #### Calculate new trade shares (to verify convergence)
    p1 <- (Pi * B)
    p2 <- kronecker((w_hat^(-theta)), matrix(1,1,N))
    p3 <- kronecker(t(P_hat), matrix(1,N,1))
    Pi_new <- p1 * p2 / p3

    X_new <- t(Pi_new * kronecker(t(E), matrix(1,N,1)))

    # Compute difference to see if data converged
    crit = max(c(abs(log(X_new) - log(X_last_step))), na.rm = TRUE)
    curr_iter <- curr_iter + 1

    if(crit <= tol || curr_iter >= max_iter)
      break
  }

  ################################################################
  ## Post Processing
  ################################################################

  # Post welfare effects and new trade values
  dim(X_new) <- c(N*N, 1)

  # Real wage impact
  real_wage  <- w_hat / (P_hat)^(-1/theta)
  # real_wage <- (diag(Pi_new) / diag(Pi))^(-1/theta)  # (ACR formula)

  # Welfare impact
  if (mult) {
    welfare <- real_wage
  } else {
    welfare <- ((Y * w_hat) + D) / (Y+D) / (P_hat)^(-1/theta)
  }

  # Kronecker w/ this creates N dupes per dataset in column to align with X matrix
  kron_base <- matrix(1, N, 1)

  welfare     <- kronecker(welfare, kron_base)
  real_wage   <- kronecker(real_wage, kron_base)
  nom_wage    <- kronecker(w_hat, kron_base)

  price_index <- kronecker(((P_hat)^(-1/theta)), kron_base)

  # Build and return the final list
  data_out <- data

  if (length(data_out) == 0) {
    data_out$expcode <- exp_id
    data_out$impcode <- imp_id
  }

  data_out$new_trade   <- X_new
  data_out$welfare     <- welfare
  data_out$real_wage   <- real_wage
  data_out$nom_wage    <- nom_wage
  data_out$price_index <- price_index

  return(data.frame(data_out))
}

