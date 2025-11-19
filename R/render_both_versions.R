#####################################################################
# Program Name: render_both_versions.R
# Created: 16NOV2025 (IEC)
# Modified: 19NOV2025 (IEC)
# GOAL:  Generate HTML dashboard files, one self contained, the other
#        for upload into GitHub Pages
#####################################################################

# --- 1. SETUP: Load necessary libraries ---
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  here,
  rmarkdown
)

cat("--- BUILDING DASHBOARD VERSIONS ---\n\n")

# --- 2. ENSURE OUTPUT DIRECTORY EXISTS ---
output_dir <- here("output")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# --- 3. BUILD PORTABLE VERSION (SELF-CONTAINED) ---
cat("Creating portable version (self-contained)...\n")
rmarkdown::render(
  input = here("R", "phd-outcomes-dashboard.Rmd"),
  output_file = "phd-outcomes-dashboard.html",
  output_dir = output_dir,
  output_options = list(self_contained = TRUE),
  quiet = FALSE
)

# --- 4. BUILD GITHUB PAGES VERSION (WITH LIBS FOLDER) ---
cat("\nCreating GitHub Pages version (with libs folder)...\n")
rmarkdown::render(
  input = here("R", "phd-outcomes-dashboard.Rmd"),
  output_file = "phd-outcomes-dashboard-web.html",
  output_dir = output_dir,
  output_options = list(
    self_contained = FALSE,
    lib_dir = here("output", "libs")
  ),
  quiet = FALSE
)

# --- 5. VERIFY OUTPUT FILES ---
cat("\n--- BUILD COMPLETE ---\n\n")

portable_path <- here("output", "phd-outcomes-dashboard.html")
web_path <- here("output", "phd-outcomes-dashboard-web.html")

if (file.exists(portable_path)) {
  portable_size <- file.size(portable_path) / 1024 / 1024
  cat("✓ Portable version created:", round(portable_size, 1), "MB\n")
  cat("  Location:", portable_path, "\n\n")
} else {
  cat("✗ ERROR: Portable version not created\n\n")
}

if (file.exists(web_path)) {
  web_size <- file.size(web_path) / 1024 / 1024
  cat("✓ GitHub Pages version created:", round(web_size, 1), "MB\n")
  cat("  Location:", web_path, "\n")
  cat("  Libs folder:", here("output", "libs"), "\n\n")
} else {
  cat("✗ ERROR: GitHub Pages version not created\n\n")
}

cat("--- NEXT STEPS ---\n")
cat("1. Open output/phd-outcomes-dashboard.html to test locally\n")
cat("2. For GitHub Pages deployment:\n")
cat("   - Copy output/phd-outcomes-dashboard-web.html to your GitHub Pages repo\n")
cat("   - Copy output/libs/ folder to your GitHub Pages repo\n")
cat("   - Commit and push both files\n")