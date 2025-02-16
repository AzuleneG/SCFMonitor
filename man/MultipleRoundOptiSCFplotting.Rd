% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MultipleRoundOptiSCFplotting.R
\name{MultipleRoundOptiSCFplotting}
\alias{MultipleRoundOptiSCFplotting}
\title{Plot the SCF Convergence Process for Multiple Rounds of Optimization}
\arguments{
\item{SCFData}{The tibble generated by OptiSCFMonitorAsWholeTibble() describing the SCF convergence process for multiple rounds of optimization(if any).}

\item{SCFconver}{A numeric vector showing the SCF convergence requirement read from the gaussian .log file.}

\item{BOT}{A numeric vector describing the starting optimization round for plotting}

\item{TOP}{A numeric vector describing the ending optimization round for plotting}
}
\value{
No return value, called for side effects
}
\description{
An internal function plots the generated SCF convergence tibble
}
\examples{
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)

temp_dat <- OptiSCFMonitorAsWholeTibble(SCFMonitorExample())
MultipleRoundOptiSCFplotting(temp_dat[[1]],
  SCFconver = -log10(temp_dat[[2]]),
  BOT = 10,
  TOP = 15
)

}
