#####################################################################
# Program Name: 02_assign_careers
# Created: 13NOV2025 (IEC/Model)
# Modified: 14NOV2025 (IEC)
# GOAL:  Upgraded based on real-world outcome data provided by the user.
#   - Assigns jobSector, a location-specific entityName (employer), and a
#     position (job title) to each graduate with much higher realism.
#   - Incorporates a wider variety of industries, fictitious startups,
#     and stronger geographic/international weighting.
#
# INPUT: 'data/processed/01_simulated_cohorts.rds'
# OUTPUT: 'data/processed/02_simulated_careers.rds'
#####################################################################

# --- 1. SETUP: Load necessary libraries ---
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  here,
  tidyverse
)

set.seed(456) # Keep seed for reproducibility


# --- 2. DEFINE CAREER PATHS (SYNTAX CORRECTED & FULLY EXPANDED) ---
career_definitions <- list(
  
  "Computer Science" = list(
    Cohorts = list(
      "Younger" = list(probabilities = c("For-Profit" = 45, "Faculty (TT)" = 20, "Post Doc/Fellow" = 17, "Other Academic" = 3, "Nonprofit" = 5, "Not available" = 10)),
      "Older" = list(probabilities = c("For-Profit" = 50, "Faculty (TT)" = 30, "Other Academic" = 10, "Not available" = 10))
    ),
    Employers = list(
      "For-Profit" = c("Google (Cambridge, MA)", "Google (Cambridge, MA)", "Google (Mountain View, CA)", "Google (Mountain View, CA)", "Google (New York, NY)", "Google (Seattle, WA)","Meta (Menlo Park, CA)", "Meta (Menlo Park, CA)", "Meta (Cambridge, MA)", "Meta (Seattle, WA)","Apple (Cupertino, CA)", "Apple (Cupertino, CA)", "Apple (Boston, MA)","Amazon (Seattle, WA)", "Amazon (Seattle, WA)", "Amazon (Boston, MA)", "Amazon Web Services (Cambridge, MA)","Microsoft (Redmond, WA)", "Microsoft (Redmond, WA)", "Microsoft (Cambridge, MA)","NVIDIA (Santa Clara, CA)", "Salesforce (San Francisco, CA)", "Adobe (San Jose, CA)", "Oracle (Austin, TX)", "Intel (Santa Clara, CA)", "Qualcomm (San Diego, CA)", "LinkedIn (Sunnyvale, CA)", "Spotify (New York, NY)", "Twitter/X (San Francisco, CA)", "Netflix (Los Gatos, CA)","Jane Street (New York, NY)", "Two Sigma (New York, NY)", "Citadel Securities (Chicago, IL)", "Goldman Sachs (New York, NY)", "Bloomberg (New York, NY)", "DE Shaw (New York, NY)","OpenAI (San Francisco, CA)", "Databricks (San Francisco, CA)", "Snowflake (Bozeman, MT)", "Palantir (Palo Alto, CA)", "Stripe (San Francisco, CA)", "Rippling (San Francisco, CA)","CyberSynth AI (Cambridge, MA)", "DataWeave Analytics (Palo Alto, CA)", "Reexpress AI (Boston, MA)", "LogiCore Systems (Austin, TX)", "SynthNet (New York, NY)", "QuantumLeap Computing (Boulder, CO)", "Veritas Analytics (Washington, DC)", "Axon Logic (Chicago, IL)", "Helia Dynamics (San Diego, CA)"),
      "Faculty_R1" = c("MIT (Cambridge, MA)", "Harvard University (Cambridge, MA)", "Boston University (Boston, MA)", "Carnegie Mellon University (Pittsburgh, PA)", "Stanford University (Stanford, CA)", "UC Berkeley (Berkeley, CA)", "UCLA (Los Angeles, CA)", "Columbia University (New York, NY)", "Cornell University (Ithaca, NY)", "University of Washington (Seattle, WA)", "Georgia Institute of Technology (Atlanta, GA)", "University of Warwick (UK)", "ETH Zurich (Switzerland)", "Brown University (Providence, RI)", "Dartmouth College (Hanover, NH)", "Tufts University (Medford, MA)", "University of Southern California (Los Angeles, CA)", "University of Illinois, Urbana-Champaign (Urbana, IL)", "University of Texas-Austin (Austin, TX)", "University of Wisconsin-Madison (Madison, WI)", "University of Massachusetts Amherst (Amherst, MA)", "UC San Diego (San Diego, CA)", "University of Maryland-College Park (College Park, MD)", "University of Pennsylvania (Philadelphia, PA)", "Purdue University (West Lafayette, IN)", "Yale University (New Haven, CT)", "Duke University (Durham, NC)", "Rice University (Houston, TX)", "Northeastern University (Boston, MA)", "Northwestern University (Evanston, IL)", "New York University (New York, NY)"),
      "Faculty_LAC" = c("Wellesley College (Wellesley, MA)", "Vassar College (Poughkeepsie, NY", "Amherst College (Amherst, MA)", "Harvey Mudd College (Claremont, CA)", "Bowdoin College (Brunswick, ME)", "Williams College (Williamstown, MA)", "Pomona College (Claremont, CA)"),
      "Post Doc/Fellow" = c("MIT (Cambridge, MA)", "Harvard University (Cambridge, MA)", "Stanford University (Stanford, CA)", "Microsoft Research (Cambridge, MA)", "Columbia University (New York, NY)", "UCLA (Los Angeles, CA)", "University of Washington (Seattle, WA)", "McGill University (Canada)"),
      "Nonprofit" = c("SRI International (Menlo Park, CA)", "Allen Institute for AI (Seattle, WA)", "Flatiron Institute (New York, NY)", "Mozilla Foundation (Mountain View, CA)", "Signal Foundation (Mountain View, CA)"),
      "Other Academic" = c("Broad Institute (Cambridge, MA)", "MIT Lincoln Laboratory (Lexington, MA)")
    ),
    Titles = list(
      "For-Profit" = list("Younger" = c("Software Engineer", "Data Scientist", "Applied Scientist", "Research Scientist", "ML Engineer"), "Older" = c("Senior Software Engineer", "Staff Research Scientist", "Principal ML Engineer", "Director", "VP Engineering", "Co-Founder")),
      "Faculty (TT)" = list("Younger" = c("Assistant Professor", "Lecturer"), "Older" = c("Associate Professor", "Professor")),
      "Post Doc/Fellow" = list("Younger" = c("Postdoctoral Fellow", "Postdoctoral Researcher"), "Older" = c("Postdoctoral Fellow", "Postdoctoral Researcher")),
      "Nonprofit" = list("Younger" = c("Research Scientist", "Developer"), "Older" = c("Research Scientist", "Developer")),
      "Other Academic" = list("Younger" = c("Research Scientist", "Staff Scientist"), "Older" = c("Research Scientist", "Staff Scientist"))
    )
  ),
  
  "Physics" = list(
    # *** FIX: Restored the Cohorts list definition ***
    Cohorts = list(
      "Younger" = list(probabilities = c("Post Doc/Fellow" = 26, "Not available" = 20, "For-Profit" = 15, "Other Academic" = 15, "Government" = 10, "Nonprofit" = 10, "Faculty (TT)" = 2, "Faculty (Other)" = 2)),
      "Older" = list(probabilities = c("For-Profit" = 50, "Faculty (TT)" = 20, "Other Academic" = 10, "Post Doc/Fellow" = 6, "Not available" = 6, "Faculty (Other)" = 4, "Government" = 2, "Nonprofit" = 2))
    ),
    Employers = list(
      "For-Profit" = c("The D. E. Shaw Group (New York, NY)", "Citadel Securities (Chicago, IL)", "Citadel Securities (New York, NY)", "Jane Street (New York, NY)", "Two Sigma (New York, NY)", "Renaissance Technologies (East Setauket, NY)", "McKinsey & Company (Boston, MA)", "Bain & Company (Boston, MA)", "Boston Consulting Group (New York, NY)", "Booz Allen Hamilton (McLean, VA)", "Morgan Stanley (New York, NY)", "Goldman Sachs (New York, NY)", "Google Quantum AI (Santa Barbara, CA)", "Waymo (Mountain View, CA)", "Amazon Web Services (Cambridge, MA)", "Apple (Cupertino, CA)", "IBM Research (Yorktown Heights, NY)", "DeepMind (London, UK)", "Intel (Hillsboro, OR)", "ASML (Wilton, CT)", "NVIDIA (Santa Clara, CA)", "Lam Research (Fremont, CA)", "KLA (Milpitas, CA)", "QuEra Computing (Boston, MA)", "Aliro Quantum (Boston, MA)", "IonQ (College Park, MD)", "Atlantic Quantum (Cambridge, MA)", "SandboxAQ (Palo Alto, CA)", "Motional (Boston, MA)", "Helios Fusion (Munich, Germany)", "Entangled Systems (Boulder, CO)", "Q-Logic Devices (Cambridge, MA)", "Chroma Photonics (Bozeman, MT)", "Aperture Sensing (Tucson, AZ)"),
      "Faculty_R1" = c("MIT (Cambridge, MA)", "Harvard University (Cambridge, MA)", "University of Chicago (Chicago, IL)", "Caltech (Pasadena, CA)", "Princeton University (Princeton, NJ)", "Cornell University (Ithaca, NY)", "Stanford University (Stanford, CA)", "University of Oxford (UK)", "King's College London (UK)", "Carnegie Mellon University (Pittsburgh, PA)", "New York University (New York, NY)", "Rice University (Houston, TX)", "Brown University (Providence, RI)", "Dartmouth College (Hanover, NH)", "University of Southern California (Los Angeles, CA)", "University of Illinois, Urbana-Champaign (Urbana, IL)", "University of Texas-Austin (Austin, TX)", "University of Wisconsin-Madison (Madison, WI)", "University of Massachusetts Amherst (Amherst, MA)", "UC San Diego (San Diego, CA)", "University of Maryland-College Park (College Park, MD)", "University of Pennsylvania (Philadelphia, PA)", "Purdue University (West Lafayette, IN)", "Yale University (New Haven, CT)", "Duke University (Durham, NC)", "Northeastern University (Boston, MA)", "Northwestern University (Evanston, IL)", "University of Colorado-Boulder (Boulder, CO)", "Stony Brook University (Stony Brook, NY)", "UC Santa Barbara (Santa Barbara, CA)"),
      "Faculty_LAC" = c("Williams College (Williamstown, MA)", "Amherst College (Amherst, MA)", "Wesleyan University (Middletown, CT)", "Harvey Mudd College (Claremont, CA)", "Pomona College (Claremont, CA)", "Vassar College (Poughkeepsie, NY)", "Colorado College (Colorado Springs, CO)"),
      "Faculty (Other)" = c("Harvard University (Cambridge, MA)", "Pomona College (Claremont, CA)", "McGill University (Canada)", "Boston University (Boston, MA)"),
      "Post Doc/Fellow" = c("MIT (Cambridge, MA)", "Harvard University (Cambridge, MA)", "Caltech (Pasadena, CA)", "Princeton University (Princeton, NJ)", "University of Chicago (Chicago, IL)", "Lawrence Berkeley National Lab (Berkeley, CA)", "Fermilab (Batavia, IL)", "Max Planck Institutes (Germany)", "Perimeter Institute (Canada)", "University of Amsterdam (Netherlands)", "École Polytechnique Fédérale de Lausanne (CH)"),
      "Government" = c("MIT Lincoln Laboratory (Lexington, MA)", "NIST (Gaithersburg, MD)", "Los Alamos National Lab (Los Alamos, NM)", "US Dept of Energy (Washington, DC)", "Sandia National Laboratories (Albuquerque, NM)", "JPL (Pasadena, CA)"),
      "Nonprofit" = c("The Flatiron Institute (New York, NY)", "The Charles Stark Draper Laboratory (Cambridge, MA)", "Howard Hughes Medical Institute (Chevy Chase, MD)", "JILA (Boulder, CO)", "Aerospace Corporation (El Segundo, CA)"),
      "Other Academic" = c("MIT (Cambridge, MA)", "Harvard University (Cambridge, MA)", "Caltech (Pasadena, CA)", "Princeton University (Princeton, NJ)", "University of Chicago (Chicago, IL)", "Lawrence Berkeley National Lab (Berkeley, CA)", "Fermilab (Batavia, IL)", "Max Planck Institutes (Germany)", "Perimeter Institute (Canada)", "University of Amsterdam (Netherlands)", "École Polytechnique Fédérale de Lausanne (CH)","Brown University (Providence, RI)", "Dartmouth College (Hanover, NH)")
    ),
    Titles = list(
      "For-Profit" = list("Younger" = c("Quantitative Analyst", "Data Scientist", "Research Scientist", "Systems Engineer", "Associate"), "Older" = c("Quantitative Researcher", "Senior Optical Engineer", "Manager", "Senior Data Scientist")),
      "Faculty (TT)" = list("Younger" = c("Assistant Professor"), "Older" = c("Associate Professor", "Professor", "Lecturer")),
      "Post Doc/Fellow" = list("Younger" = c("Postdoctoral Fellow", "Postdoctoral Scholar", "Named Postdoctoral Fellow"), "Older" = c("Postdoctoral Fellow", "Postdoctoral Scholar", "Named Postdoctoral Fellow")),
      "Faculty (Other)" = list("Younger" = c("Visiting Assistant Professor", "Preceptor", "Lecturer"), "Older" = c("Adjunct Professor", "Senior Lecturer")),
      "Government" = list("Younger" = c("Staff Scientist", "Physicist", "ORISE Fellow"), "Older" = c("Staff Scientist", "Physicist", "ORISE Fellow")),
      "Nonprofit" = list("Younger" = c("Research Fellow", "Staff Scientist"), "Older" = c("Research Fellow", "Staff Scientist")),
      "Other Academic" = list("Younger" = c("Visiting Assistant Professor", "Research Assistant Professor"), "Older" = c("Visiting Assistant Professor", "Research Assistant Professor"))
    )
  ),
  
  "Biomedical Sciences" = list(
    # *** FIX: Restored the Cohorts list definition ***
    Cohorts = list(
      "Younger" = list(probabilities = c("For-Profit" = 35, "Post Doc/Fellow" = 20, "Not available" = 20, "Other Academic" = 15, "Nonprofit" = 10)),
      "Older" = list(probabilities = c("For-Profit" = 50, "Faculty (TT)" = 10, "Other Academic" = 10, "Nonprofit" = 10, "Post Doc/Fellow" = 6, "Not available" = 5, "Government" = 5, "Faculty (Other)" = 4))
    ),
    Employers = list(
      "For-Profit" = c("Moderna (Cambridge, MA)", "Moderna (Cambridge, MA)", "Pfizer (Cambridge, MA)", "Pfizer (Cambridge, MA)", "Pfizer (New York, NY)", "Vertex Pharmaceuticals (Boston, MA)", "Vertex Pharmaceuticals (Boston, MA)", "Vertex Pharmaceuticals (Boston, MA)", "Merck (Boston, MA)", "Merck (Boston, MA)", "Bristol Myers Squibb (Cambridge, MA)", "Novartis (Cambridge, MA)", "AstraZeneca (Waltham, MA)", "Ginkgo Bioworks (Boston, MA)", "Sanofi (Cambridge, MA)", "Takeda (Cambridge, MA)", "Genentech (South San Francisco, CA)", "Genentech (South San Francisco, CA)", "Gilead Sciences (Foster City, CA)", "Amgen (Thousand Oaks, CA)", "Biogen (Cambridge, MA)", "RA Capital Management (Boston, MA)", "Atlas Venture (Cambridge, MA)", "Flagship Pioneering (Cambridge, MA)", "Third Rock Ventures (Boston, MA)", "OrbiMed Advisors (New York, NY)", "McKinsey & Company (Boston, MA)", "Boston Consulting Group (Boston, MA)", "L.E.K. Consulting (Boston, MA)", "ZS Associates (Boston, MA)", "Chroma Medicine (Cambridge, MA)", "Generate Biomedicines (Somerville, MA)", "Alnylam Pharmaceuticals (Cambridge, MA)", "Beam Therapeutics (Cambridge, MA)", "Sarepta Therapeutics (Cambridge, MA)", "Finnegan, Henderson, et al. (Boston, MA)", "Cooley LLP (Boston, MA)", "Goodwin Procter (Boston, MA)", "GeneVerve Therapeutics (Cambridge, MA)", "Beacon Bio (Watertown, MA)", "VectorPath Bio (San Diego, CA)", "MitoGen Pharma (Cambridge, MA)", "Axonix Bio (South San Francisco, CA)", "Tidal Therapeutics (Cambridge, MA)", "CRISPR-X (Boston, MA)", "Helixion (San Diego, CA)", "Morphic Tx (Waltham, MA)"),
      "Faculty_R1" = c("Harvard Medical School (Boston, MA)", "MIT (Cambridge, MA)", "UCSF (San Francisco, CA)", "Johns Hopkins University (Baltimore, MD)", "University of Michigan (Ann Arbor, MI)", "Osaka University (Japan)", "Emory University (Atlanta, GA)", "University of Virginia (Charlottesville, VA)", "Tufts University (Medford, MA)", "Brown University (Providence, RI)", "Scripps Research Institute (La Jolla, CA)", "Columbia University (New York, NY)", "Cornell University (Ithaca, NY)", "Duke University (Durham, NC)", "University of Chicago (Chicago, IL)", "University of Pennsylvania (Philadelphia, PA)", "Washington University in St. Louis (St. Louis, MO)", "Rockefeller University (New York, NY)", "UC Davis (Davis, CA)", "UCLA (Los Angeles, CA)", "UC San Diego (San Diego, CA)", "University of Wisconsin-Madison (Madison, WI)", "University of Washington (Seattle, WA)", "Baylor College of Medicine (Houston, TX)", "University of Texas-Austin (Austin, TX)", "University of North Carolina at Chapel Hill (Chapel Hill, NC)", "Vanderbilt University (Nashville, TN)", "Northwestern University (Evanston, IL)"),
      "Faculty_LAC" = c("Swarthmore College (Swarthmore, PA)", "Wellesley College (Wellesley, MA)", "Amherst College (Amherst, MA)", "Bowdoin College (Brunswick, ME)"),
      "Post Doc/Fellow" = c("Broad Institute (Cambridge, MA)", "Broad Institute (Cambridge, MA)", "Whitehead Institute (Cambridge, MA)", "Whitehead Institute (Cambridge, MA)", "Dana-Farber Cancer Institute (Boston, MA)", "Mass General Hospital (Boston, MA)", "Stanford University (Stanford, CA)", "The Francis Crick Institute (UK)", "University of Cambridge (UK)"),
      "Faculty (Other)" = c("Harvard University (Cambridge, MA)", "Swarthmore College (Swarthmore, PA)", "UC Berkeley (Berkeley, CA)"),
      "Government" = c("National Institutes of Health (NIH) (Bethesda, MD)", "Food and Drug Administration (FDA) (Silver Spring, MD)", "CDC (Atlanta, GA)"),
      "Nonprofit" = c("Memorial Sloan Kettering (New York, NY)", "Prion Alliance (Cambridge, MA)", "Food Allergy Science Initiative (Cambridge, MA)", "St. Jude Children's Research Hospital (Memphis, TN)"),
      "Other Academic" = c("Mass General Hospital (Boston, MA)", "Brigham and Women's Hospital (Boston, MA)", "Boston Children's Hospital (Boston, MA)", "Yale University (New Haven, CT)")
    ),
    Titles = list(
      "For-Profit" = list("Younger" = c("Scientist I", "Associate Consultant", "Bioinformatics Scientist", "Associate", "Patent Agent"), "Older" = c("Senior Scientist", "Principal Scientist", "Associate Director", "Life Sciences Specialist", "Venture Capital Principal", "Manager")),
      "Faculty (TT)" = list("Younger" = c("Assistant Professor"), "Older" = c("Associate Professor", "Professor")),
      "Post Doc/Fellow" = list("Younger" = c("Postdoctoral Research Fellow", "Postdoctoral Scholar"), "Older" = c("Postdoctoral Research Fellow", "Postdoctoral Scholar")),
      "Faculty (Other)" = list("Younger" = c("Visiting Assistant Professor", "Instructor"), "Older" = c("Instructor")),
      "Government" = list("Younger" = c("Senior Health Science Policy Analyst", "Staff Scientist"), "Older" = c("Senior Health Science Policy Analyst", "Staff Scientist")),
      "Nonprofit" = list("Younger" = c("Medical Resident", "Clinical Fellow", "Instructor"), "Older" = c("Medical Resident", "Clinical Fellow", "Instructor")),
      "Other Academic" = list("Younger" = c("Medical Resident", "Clinical Fellow", "Instructor", "Physician"), "Older" = c("Medical Resident", "Clinical Fellow", "Instructor", "Physician"))
    )
  )
)


# --- 3. LOAD & PREPARE DATA ---
input_path <- here("data", "processed", "01_simulated_cohorts.rds")
simulated_data <- readRDS(input_path)

simulated_data <- simulated_data %>%
  mutate(cohort = ifelse(gradYear >= 2020, "Younger", "Older"))


# --- 4. HELPER FUNCTIONS (No changes needed) ---
assign_sector <- function(program, cohort) {
  probs <- career_definitions[[program]][["Cohorts"]][[cohort]][["probabilities"]]
  if (is.null(probs) || length(probs) == 0) return(NA_character_)
  sample(names(probs), size = 1, prob = probs)
}

assign_details <- function(program, sector, cohort) {
  
  if (is.na(sector) || sector == "Not available") {
    return(list(entityName = NA_character_, position = NA_character_))
  }
  
  # --- NEW LOGIC FOR FACULTY PLACEMENTS ---
  if (sector == "Faculty (TT)") {
    
    # 1. Decide probabilistically whether to place in an R1 or LAC
    institution_type <- sample(
      c("Faculty_R1", "Faculty_LAC"),
      size = 1,
      prob = c(0.90, 0.10) # 75% chance for R1, 25% chance for LAC
    )
    
    # 2. Get the employer list based on that decision
    employers_list <- career_definitions[[program]][["Employers"]][[institution_type]]
    
  } else {
    # --- Original logic for all other sectors ---
    employers_list <- career_definitions[[program]][["Employers"]][[sector]]
  }
  
  # Get titles (this logic is unchanged)
  titles_list <- career_definitions[[program]][["Titles"]][[sector]][[cohort]] %||%
    career_definitions[[program]][["Titles"]][[sector]]
  
  if (is.null(employers_list) || is.null(titles_list)) {
    return(list(entityName = NA_character_, position = NA_character_))
  }
  
  entity <- sample(employers_list, 1)
  position <- sample(titles_list, 1)
  
  return(list(entityName = entity, position = position))
}


# --- 5. RUN SIMULATION (No changes needed) ---
simulated_careers <- simulated_data %>%
  rowwise() %>%
  mutate(jobSector = assign_sector(program, cohort)) %>%
  mutate(details = list(assign_details(program, jobSector, cohort))) %>%
  ungroup() %>%
  unnest_wider(details) %>%
  mutate(
    degree = "PhD",
    academicPosition = case_when(
      jobSector == "Faculty (TT)" ~ "Faculty (Tenure or Tenure Track)",
      jobSector == "Faculty (Other)" ~ "Faculty (Other)",
      jobSector == "Post Doc/Fellow" ~ "Post Doc/Fellow",
      jobSector %in% c("Government", "Nonprofit") & str_detect(position, regex("research|fellow|scientist", ignore_case = TRUE)) ~ "Researcher (Non-Teaching)",
      jobSector == "Other Academic" & str_detect(position, regex("research|scientist|fellow", ignore_case = TRUE)) ~ "Researcher (Non-Teaching)",
      jobSector == "Other Academic" & str_detect(position, regex("resident|physician|instructor", ignore_case = TRUE)) ~ "Physicians and Surgeons",
      jobSector == "Other Academic" ~ "Administrative",
      TRUE ~ NA_character_
    )
  ) %>%
  select(
    personID, program, degree, gradYear,
    jobSector, entityName, position,
    academicPosition
  )

# --- 6. VERIFICATION ---
cat("--- Career Assignment Summary (Corrected Model) ---\n\n")
cat("Sample of the generated data:\n")
print(head(simulated_careers, 10))

cat("\n--- Geographic Check for Physics 'For-Profit' Placements ---\n")
simulated_careers %>%
  filter(program == "Physics", jobSector == "For-Profit") %>%
  mutate(State = str_extract(entityName, "(?<=\\()([A-Z]{2}|[A-Za-z]+)(?=\\))")) %>%
  count(State, sort = TRUE) %>%
  print()


# --- 7. SAVE OUTPUT ---
output_dir <- here("data", "processed")
output_path <- file.path(output_dir, "02_simulated_careers.rds")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
saveRDS(simulated_careers, file = output_path)
cat(
  "\n--- SCRIPT COMPLETE ---\n",
  "Corrected and upgraded career data has been saved to:\n",
  output_path, "\n"
)