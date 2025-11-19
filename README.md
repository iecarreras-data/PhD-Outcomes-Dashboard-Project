# PhD Career Outcomes Dashboard

## Project Overview

This dashboard addresses the common need for academic departments to understand and showcase the diverse career paths of their alumni. It provides a clean, professional, and powerful resource for faculty, prospective students, and administrators to explore employment outcomes across Computer Science, Physics, and Biomedical Sciences PhD programs.

The end product is an interactive tool that transforms complex career outcome data into an intuitive platform for strategic decision-making, showcasing my ability to build sophisticated data products from concept to deployment.

**Live Demo:** [View Dashboard](https://iecarreras-data.github.io/phd-outcomes-dashboard-web.html)

### Core Competencies Showcased

*   **Develop Advanced Dashboards:** Structuring a complex, multi-tab layout with global filtering using flexdashboard and crosstalk
*   **Data Simulation:** Creating realistic, high-fidelity synthetic datasets using Generative AI that accurately mimic real-world PhD career outcome distributions
*   **Implement Linked Visualizations:** Using the crosstalk package to allow a single dropdown menu to dynamically filter multiple independent plots across the dashboard
*   **Create Rich Data-Driven Stories:** Designing targeted visualizations (stacked bars, choropleth maps, horizontal bars, interactive tables) to answer specific questions about job sectors, institutional characteristics, and geography

---

### Tech Stack & Repository Structure

*   **Language:** R
*   **Key R Packages:** tidyverse, here, flexdashboard, plotly, crosstalk, DT, scales, countrycode

The repository is structured as a self-contained RStudio Project to ensure full reproducibility.

    .
    ├── R/
    │   ├── 01_create_cohorts.R
    │   ├── 02_assign_careers.R
    │   ├── 03_add_location_data.R
    │   ├── 07_build_dashboard.R
    │   └── phd-outcomes-dashboard.Rmd
    ├── data/
    │   └── processed/
    ├── output/
    ├── .gitignore
    ├── PhD-Outcomes-Dashboard-Project.Rproj
    └── README.md

---

### How to Reproduce This Project

Follow these steps to run the entire data pipeline and generate the final dashboard.

#### 1. Setup & Prerequisites

1.  **Clone the Repository:** Clone this repository to your local machine using git clone.

2.  **Open the Project:** Open RStudio by double-clicking the PhD-Outcomes-Dashboard-Project.Rproj file. This is crucial as it sets the correct working directory.

3.  **Install Packages:** Open the R console in RStudio and install all necessary packages using pacman.

#### 2. Run the Data Generation Pipeline

The scripts in the R folder must be run in numerical order. Each script's output serves as the next script's input.

##### Running the Scripts

Execute each script in order:

    source(here::here("R", "01_create_cohorts.R"))
    source(here::here("R", "02_assign_careers.R"))
    source(here::here("R", "03_add_location_data.R"))

Then build both dashboard versions:

    source(here::here("R", "07_build_dashboard.R"))

##### Pipeline Details

1.  **01_create_cohorts.R**
    *   **Purpose:** Generates the initial cohort of simulated PhD graduates with personID, program, and graduation year
    *   **Input:** None (creates synthetic data)
    *   **Output:** data/processed/01_simulated_cohorts.rds

2.  **02_assign_careers.R**
    *   **Purpose:** Assigns realistic career outcomes including job sector, employer, and position based on department-specific probability distributions
    *   **Input:** data/processed/01_simulated_cohorts.rds
    *   **Output:** data/processed/02_simulated_careers.rds

3.  **03_add_location_data.R**
    *   **Purpose:** Parses employer names to extract geographic location, adds institutional characteristics (Carnegie classification, AAU status, institutional control)
    *   **Input:** data/processed/02_simulated_careers.rds
    *   **Output:** data/processed/03_final_dataset.rds

4.  **07_build_dashboard.R**
    *   **Purpose:** Renders two versions of the interactive HTML dashboard: a self-contained portable version and a GitHub Pages version with external libs folder
    *   **Input:** data/processed/03_final_dataset.rds
    *   **Output:** output/phd-outcomes-dashboard.html (portable), output/phd-outcomes-dashboard-web.html (GitHub Pages)

After running all scripts, open output/phd-outcomes-dashboard.html in your web browser to view the final, interactive dashboard.

---

### Key Technical Solutions

This project demonstrates advanced data visualization and dashboard development practices:

- **Global Cross-Chart Filtering:** Single dropdown menu controls all visualizations simultaneously using SharedData objects from the crosstalk package
- **Realistic Probability Distributions:** Department-specific career outcome probabilities that reflect actual PhD employment patterns (e.g., Physics grads have higher postdoc rates than CS grads)
- **Geographic Data Processing:** Automated parsing of location strings from employer names and mapping to U.S. states, international countries, and institutional metadata
- **Two-Repository Deployment Strategy:** Separate source code repository and GitHub Pages repository for clean separation of development and production environments
- **Interactive Data Tables:** Searchable, sortable graduate listings with built-in CSV/Excel export functionality using the DT package

---

### Customization

#### Modifying the Data

To adjust the simulation parameters, edit these variables in R/01_create_cohorts.R:

    n_cs <- 150           # Number of Computer Science graduates
    n_physics <- 325      # Number of Physics graduates
    n_biomed <- 425       # Number of Biomedical Sciences graduates
    start_year <- 2016    # First graduation year
    end_year <- 2025      # Last graduation year

#### Changing Career Probability Distributions

Edit the career_definitions list in R/02_assign_careers.R to modify job sector probabilities, employer lists, and position titles for each department and cohort.

#### Adjusting Visual Design

- **Color Palettes:** Modify industry_palette and academic_palette in the .Rmd setup chunk
- **Fonts:** Change the Google Fonts import in the CSS block
- **Layout:** Adjust flexdashboard column widths using data-width attributes

---

### Contact & Attribution

**Author:** Ismael E. Carreras  
**GitHub:** @iecarreras  
**LinkedIn:** Ismael E. Carreras

This project uses entirely synthetic data generated with assistance from Generative AI for demonstration purposes. All graduate records are simulated and do not represent real individuals.
