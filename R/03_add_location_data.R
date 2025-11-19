#####################################################################
# Program Name: 03_add_location_data
# Created: 13NOV2025 (IEC/Model)
# Modified: 
# GOAL:  - Parses entityName to extract location and clean names.
#        - Merges in an expanded list of academic institutional data.
#        - Produces the final, complete dataset for analysis.
#
# INPUT: 'data/processed/02_simulated_careers.rds'
# OUTPUT: 'data/processed/03_final_dataset.rds'
#####################################################################

# --- 1. SETUP: Load necessary libraries ---
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  here,
  tidyverse
)

set.seed(789) # Set a final seed for reproducibility


# --- 2. CREATE INSTITUTIONAL DATA DICTIONARY (EXPANDED AGAIN) ---
institutional_dictionary <- tribble(
  ~entityName_clean, ~carnegie, ~aau, ~control,
  
  # --- Core R1 Universities ---
  "MIT", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Harvard University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Harvard Medical School", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Stanford University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Princeton University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Yale University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Columbia University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "University of Pennsylvania", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Johns Hopkins University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "University of Chicago", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Caltech", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Northwestern University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Duke University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Dartmouth College", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Brown University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Emory University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Rice University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Vanderbilt University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Washington University in St. Louis", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Carnegie Mellon University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "New York University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Boston University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "University of Southern California", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Private",
  "Rockefeller University", "R1: Doctoral Universities – Very high research activity", "Non-AAU Member", "Private",
  "Tufts University", "R1: Doctoral Universities – Very high research activity", "Non-AAU Member", "Private",
  "Northeastern University", "R1: Doctoral Universities – Very high research activity", "Non-AAU Member", "Private",
  
  # --- Public R1 Universities ---
  "UC Berkeley", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "UCLA", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Michigan", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Washington", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Virginia", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Illinois, Urbana-Champaign", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Texas-Austin", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Wisconsin-Madison", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "UC San Diego", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "UC Davis", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "UC Santa Barbara", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Maryland-College Park", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of North Carolina at Chapel Hill", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "Purdue University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "Stony Brook University", "R1: Doctoral Universities – Very high research activity", "AAU Member", "Public",
  "University of Massachusetts Amherst", "R1: Doctoral Universities – Very high research activity", "Non-AAU Member", "Public",
  
  # --- Medical Schools & Special Focus ---
  "UCSF", "Special Focus Four-Year: Medical Schools & Centers", "AAU Member", "Public",
  "Baylor College of Medicine", "Special Focus Four-Year: Medical Schools & Centers", "Non-AAU Member", "Private",
  "Scripps Research Institute", "Special Focus Four-Year: Medical Schools & Centers", "Non-AAU Member", "Private",
  
  # --- Liberal Arts Colleges ---
  "Wellesley College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Amherst College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Harvey Mudd College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Bowdoin College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Williams College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Pomona College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Wesleyan University", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Vassar College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  "Colorado College", "Baccalaureate Colleges: Arts & Sciences Focus", "Non-AAU Member", "Private",
  
  # --- International Institutions ---
  "University of Oxford", "International", "Non-AAU Member", "International",
  "University of Cambridge", "International", "Non-AAU Member", "International",
  "McGill University", "International", "AAU Member", "International",
  "King's College London", "International", "Non-AAU Member", "International",
  "ETH Zurich", "International", "Non-AAU Member", "International",
  "École Polytechnique Fédérale de Lausanne", "International", "Non-AAU Member", "International",
  "University of Warwick", "International", "Non-AAU Member", "International",
  "University of Amsterdam", "International", "Non-AAU Member", "International",
  "Osaka University", "International", "Non-AAU Member", "International",
  "The Francis Crick Institute", "International", "Non-AAU Member", "International",
  "Max Planck Institutes", "International", "Non-AAU Member", "International",
  "Perimeter Institute", "International", "Non-AAU Member", "International"
)

# --- 3. LOAD & PROCESS DATA (CORRECTED LOGIC) ---

# Load the data from the previous script
input_path <- here("data", "processed", "02_simulated_careers.rds")
simulated_data <- readRDS(input_path)

# *** FIX APPLIED HERE: Split data to keep the "Not available" group ***

# 3a. Isolate graduates WITH an employer
employed_grads <- simulated_data %>%
  filter(!is.na(entityName))

# 3b. Isolate graduates WITHOUT an employer (the "missings")
missing_grads <- simulated_data %>%
  filter(is.na(entityName))

# 3c. Process ONLY the graduates with an employer
processed_employed_grads <- employed_grads %>%
  # Extract the location string from inside the parentheses
  mutate(
    location_string = str_extract(entityName, "(?<=\\().*(?=\\))"),
    # Extract the clean entity name (everything before the parenthesis)
    entityName_clean = str_replace(entityName, " \\(.*\\)$", "")
  ) %>%
  # Parse the location string into City, State, and Country
  mutate(
    city = if_else(str_detect(location_string, ","), str_extract(location_string, "^[^,]+"), NA_character_),
    state = if_else(str_detect(location_string, ","), str_extract(location_string, "(?<=, ).*"), NA_character_),
    country = case_when(
      !is.na(state) ~ "USA",
      !is.na(location_string) ~ location_string,
      TRUE ~ NA_character_
    )
  ) %>%
  # Join with the institutional data dictionary
  left_join(institutional_dictionary, by = "entityName_clean") %>%
  # Add a simulated startYear
  rowwise() %>%
  mutate(
    startYear = gradYear + sample(0:1, 1, prob = c(0.8, 0.2))
  ) %>%
  ungroup()

# 3d. Recombine the two groups into the final dataset
final_dataset <- bind_rows(processed_employed_grads, missing_grads) %>%
  # Final selection and ordering of columns
  select(
    personID,
    program,
    degree,
    gradYear,
    startYear,
    entityName = entityName_clean, # Use the clean name
    position,
    jobSector,
    academicPosition,
    city,
    state,
    country,
    carnegie,
    aau,
    control
  ) %>%
  # Arrange by personID to restore original order
  arrange(personID)


# --- 4. VERIFICATION ---

cat("--- FINAL DATASET SUMMARY --- \n\n")
cat("Final data dimensions:", dim(final_dataset)[1], "rows,", dim(final_dataset)[2], "columns\n\n")

cat("Breakdown by Job Sector (including 'Not available'):\n")
print(count(final_dataset, jobSector, sort = TRUE))

cat("\nSample of the final, complete dataset:\n")
glimpse(final_dataset)


# --- 5. SAVE OUTPUT ---

output_dir <- here("data", "processed")
output_path <- file.path(output_dir, "03_final_dataset.rds")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

saveRDS(final_dataset, file = output_path)

cat(
  "\n--- SCRIPT COMPLETE ---\n",
  "Final, complete dataset has been saved to:\n",
  output_path, "\n"
)