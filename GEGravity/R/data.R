#' Trade Data 2000 - 2014
#'
#' @description
#' The data set represents the aggregate trade between 44 countries observed over 2000-2014,
#' using years 2000, 2005, 2010, and 2014.
#'
#' Trade and domestic sales data has been aggregated from the WIOD database (see sources).
#' For its use, consider "An Illustrated User Guide to the World Input-Output Database.
#'
#' Information on Free Trade Agreements (FTAs) is taken from the NSF-Kellogg database
#' maintained by Scott Baier and Jeff Bergstrand (see sources).
#'
#' @format A list with 7744 rows and 9 variables:
#' \describe{
#'   \item{\code{exporter}}{Country code of exporter country}
#'   \item{\code{importer}}{Country code of importer country}
#'   \item{\code{expcode }}{Label encoding of exporter country}
#'   \item{\code{impcode }}{Label encoding of importer country}
#'   \item{\code{year    }}{Year of row data}
#'   \item{\code{trade   }}{Aggregate trade flow between importer and exporter for that year}
#'   \item{\code{eu_enlargement}}{0-1 Booleanic; whether this pair in the EU}
#'   \item{\code{other_fta     }}{0-1 Booleanic; other FTA pairwise satisfaction}
#'   \item{\code{FTA           }}{0-1 Booleanic; eu_enlargement or other_fta}
#' }
#' @source \url{http://www.wiod.org/database/wiots16}
#' @source \url{https://sites.nd.edu/jeffrey-bergstrand/database-on-economic-integration-agreements/}
#' @source \url{http://www.tomzylkin.com/uploads/4/1/0/4/41048809/help_file.pdf}
"TradeData0014"



#' Trade Data 2000 - 2014 Results When Running Stata ge_gravity
#'
#' @description
#' Given the approach described in the example file of \code{ge_gravity}, running the function
#' in conjunction with the \code{ppmlhdfe} function yields the following results when
#' converted to a list. This is provided to test the R implementation against this, as
#' this is package is commissioned to mimic the performance of the Stata counterpart.
#'
#' @format A list with 7744 rows and 15 variables:
#' \describe{
#'   \item{\code{exporter} - \code{FTA}}{described by \code{TradeData0014}}
#'   \item{\code{new_eu_pair}}{0-1 Booleanic: Did they shift from non-EU pair to EU pair in time period}
#'   \item{\code{eu_effect  }}{Effect of EU entrance on country based on partial, if entry happened}
#'   \item{\code{w_eu  }}{Estimated exporter welfare at equilibrium, with
#'            default (additive) assumption on national expendature.
#'            Omitted for entries where year != 2000}
#'   \item{\code{w_mult}}{Estimated exporter welfare at equilibrium, with
#'            multiplicative assumption on national expendature.
#'            Omitted for entries where year != 2000}
#'   \item{\code{X_eu  }}{Estimated level of trade at equilibrium, with
#'            default (additive) assumption on national expendature.
#'            Omitted for entries where year != 2000}
#'   \item{\code{X_mult}}{Estimated level of trade at equilibrium, with
#'            multiplicative assumption on national expendature.
#'            Omitted for entries where year != 2000}
#' }
#' @source \url{http://www.tomzylkin.com/uploads/4/1/0/4/41048809/help_file.pdf}
"TradeData0014_Results"

