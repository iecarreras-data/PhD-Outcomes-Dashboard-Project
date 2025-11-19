#####################################################################
# Program Name: 01_create_cohorts
# Created: 13NOV2025 (IEC/Model)
# Modified: 16NOV2025 (IEC)
# GOAL:  Generates the initial cohort of simulated PhD graduates.
#   - Creates a base data frame with personID, program, and gradYear.
#   - Saves an RDS file ('data/processed/01_simulated_cohorts.rds') that will
#     be used as the input for the next script (02_assign_careers.R).
#####################################################################

# --- 1. SETUP: Load necessary libraries ---
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  here,      # For robust file path management
  tidyverse  # For data manipulation (dplyr, tibble, etc.)
)

# --- 2. CONFIGURATION: Define simulation parameters ---

# NOTE on Working Directory:
# It's a best practice to use the 'here' package instead of setwd().
# This makes your script portable and avoids file path issues.
# The here() function automatically finds your project's top-level folder
# (the one with the .Rproj file) and builds paths from there.
#
# We will create and save files in a 'data/processed' subdirectory.
# setwd("/Users/ismaelecarrerascastro/Documents/Simulated Visualization - Outcomes/") # This is less portable

# Define the number of graduates for each program
n_cs <- 150
n_physics <- 325
n_biomed <- 425 # Renamed from "Biological and Biomedical Sciences" for brevity

# Define the graduation year range
start_year <- 2016
end_year <- 2025

# --- 3. DATA GENERATION: Create the base cohorts ---

# Set a seed for reproducibility. Anyone running this code will get the same
# random numbers and thus the same initial dataset.
set.seed(123)

# Create a tibble (modern data frame) for each program
# We'll randomly assign a graduation year to each graduate
cs_grads <- tibble(
  program = "Computer Science",
  gradYear = sample(start_year:end_year, n_cs, replace = TRUE)
)

physics_grads <- tibble(
  program = "Physics",
  gradYear = sample(start_year:end_year, n_physics, replace = TRUE)
)

biomed_grads <- tibble(
  program = "Biomedical Sciences",
  gradYear = sample(start_year:end_year, n_biomed, replace = TRUE)
)

# Combine the individual program data frames into one master data frame
# Then, add a unique personID and shuffle the rows to mix the departments
simulated_cohorts <- bind_rows(cs_grads, physics_grads, biomed_grads) %>%
  # Shuffle the dataset to make it look more like a real-world extract
  slice_sample(prop = 1) %>%
  # Add a unique personID, starting from 1001
  mutate(personID = 1000 + row_number()) %>%
  # Arrange columns in a logical order
  select(personID, program, gradYear)

# --- 5. SAVE OUTPUT: Store the results for the next script ---

# Define the output directory and file path using here()
output_dir <- here("data", "processed")
output_path <- file.path(output_dir, "01_simulated_cohorts.rds")

# Create the directory if it doesn't already exist
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# Save the data frame as an RDS file.
# RDS is an R-native format that perfectly preserves data types.
saveRDS(simulated_cohorts, file = output_path)

cat(
  "\n--- SCRIPT COMPLETE ---\n",
  "Base cohort data has been saved to:\n",
  output_path, "\n"
)