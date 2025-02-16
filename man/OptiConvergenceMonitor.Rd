% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OptiConvergenceMonitor.R
\name{OptiConvergenceMonitor}
\alias{OptiConvergenceMonitor}
\title{Read and Plot the Optimization Process of a Gaussian Log File.}
\arguments{
\item{directory}{A string vector describing the directory of the Gaussian log file.}
}
\value{
No return value, called for side effects
}
\description{
This function reads a log file automatically and shows the optimization convergence process of it by generating line plots
}
\examples{
library(readr)
library(stringr)
library(tidyselect)
library(dplyr)
library(tibble)
library(ggplot2)

OptiConvergenceMonitor(SCFMonitorExample())

}
