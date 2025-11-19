# PhD Career Outcomes Dashboard

An interactive R dashboard that visualizes simulated career outcome data for PhD graduates across three academic departments: Computer Science, Physics, and Biomedical Sciences. Built with R, Flexdashboard, and Plotly, this project demonstrates advanced data visualization techniques and dashboard development skills.

## Project Overview

This dashboard addresses the common need for academic departments to understand and showcase the diverse career paths of their alumni. It provides a clean, professional, and powerful resource for faculty, prospective students, and administrators.

**Live Demo:** [View Dashboard](https://iecarreras-data.github.io/phd-outcomes-dashboard-web.html)

**Source Code Repository:** [PhD-Outcomes-Dashboard-Project](https://github.com/iecarreras/PhD-Outcomes-Dashboard-Project)

## Features

### Interactive Visualizations

- **Job Sector Distribution:** Stacked bar charts showing employment sectors (academic, industry, government, nonprofit) by graduation cohort
- **Academic Position Tracking:** Counts of graduates in faculty, postdoc, and research positions over time
- **Institutional Characteristics:** Analysis of AAU membership, institutional control (public/private), and Carnegie classifications
- **Academic Institution Rankings:** Bar charts showing top employers in academia
- **Geographic Distribution:** Interactive U.S. choropleth map and international placement charts
- **Graduate Listings:** Searchable, sortable table with individual graduate records and downloadable CSV/Excel export

### Technical Features

- **Global Filtering:** Single dropdown menu dynamically filters all visualizations across the dashboard using the `crosstalk` package
- **Responsive Layout:** Multi-tab flexdashboard design optimized for desktop viewing
- **Custom Styling:** Google Fonts (Instrument Sans) and custom CSS for professional appearance
- **Data Export:** Built-in download functionality for graduate listings (CSV, Excel, print)

## Data & Methodology

### Simulated Dataset

To ensure privacy while demonstrating full functionality, this dashboard is built upon an **entirely synthetic dataset**. The simulation process showcases a critical modern data science skill:

- **Generative AI for Data Simulation:** Used GenAI to create a realistic, high-fidelity dataset that accurately mimics the structure, distributions, and complexity of real-world PhD career outcomes
- **900 Simulated Graduates:** 150 Computer Science, 325 Physics, and 425 Biomedical Sciences PhDs
- **Graduation Years:** 2016-2025 cohorts
- **Career Sectors:** Faculty (tenure-track and other), postdocs, industry, government, nonprofit, and unavailable outcomes
- **Geographic Diversity:** U.S. states and international locations (Canada, UK, Switzerland, Germany, Japan, Netherlands)
- **Institutional Data:** AAU membership, Carnegie classifications, and institutional control types

### Data Generation Process

1. **Script 01:** Generates initial cohorts with personID, program, and graduation year
2. **Script 02:** Assigns career outcomes (job sector, employer, position) based on realistic probability distributions specific to each department
3. **Script 03:** Adds location data (city, state, country) and institutional characteristics (Carnegie classification, AAU status)

All data is stored as RDS files in `data/processed/` (git-ignored).

## Technical Stack

### Core Technologies

- **R (v4.0+):** Statistical computing and data processing
- **RStudio:** IDE and project management
- **flexdashboard:** Dashboard framework
- **plotly:** Interactive visualizations
- **crosstalk:** Linked filtering across visualizations
- **DT (DataTables):** Interactive data tables with search/sort/export
- **tidyverse:** Data manipulation (dplyr, tidyr, ggplot2, etc.)
- **here:** Reproducible file paths

### Key Packages

pacman::p_load(
  flexdashboard, plotly, crosstalk, DT,
  tidyverse, here, scales, countrycode
)

## Project Structure

    PhD-Outcomes-Dashboard-Project/
    ├── R/
    │   ├── 01_create_cohorts.R          # Generate initial cohort data
    │   ├── 02_assign_careers.R          # Assign job sectors and employers
    │   ├── 03_add_location_data.R       # Add geographic and institutional data
    │   ├── 07_build_dashboard.R         # Render HTML outputs
    │   └── phd-outcomes-dashboard.Rmd   # Dashboard source code
    ├── data/
    │   └── processed/                   # Generated RDS files (git-ignored)
    │       ├── 01_simulated_cohorts.rds
    │       ├── 02_simulated_careers.rds
    │       └── 03_final_dataset.rds
    ├── output/                          # Generated HTML files (git-ignored)
    │   ├── phd-outcomes-dashboard.html      # Portable version
    │   ├── phd-outcomes-dashboard-web.html  # GitHub Pages version
    │   └── libs/                            # JavaScript/CSS dependencies
    ├── .gitignore
    ├── README.md
    └── PhD-Outcomes-Dashboard-Project.Rproj

## Installation & Usage

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)
- Required R packages (installed automatically via `pacman`)

### Setup

1. Clone the repository
2. Open the R Project by double-clicking `PhD-Outcomes-Dashboard-Project.Rproj` in RStudio
3. Run the data generation pipeline by executing these commands in the RStudio Console:

source("R/01_create_cohorts.R")
source("R/02_assign_careers.R")
source("R/03_add_location_data.R")

4. Build the dashboard:

source("R/07_build_dashboard.R")

5. View the output by opening `output/phd-outcomes-dashboard.html` in your web browser

### File Paths

This project uses the `here` package for robust, portable file paths. All scripts work regardless of your working directory as long as you open the `.Rproj` file.

## Deployment

### Two-Repository Strategy

This project uses a dual-repository approach for clean separation of source code and deployed content:

1. **Source Code Repository** contains R scripts, .Rmd source, and documentation. Uses `self_contained: TRUE` for portable HTML output. Excludes generated data and HTML files via `.gitignore`.

2. **GitHub Pages Repository** hosts the live dashboard. Contains `phd-outcomes-dashboard-web.html` and `libs/` folder. Uses `self_contained: FALSE` to reduce file size.

### Deployment Steps

1. Run `source("R/07_build_dashboard.R")` to generate both versions
2. Copy `output/phd-outcomes-dashboard-web.html` to your GitHub Pages repo
3. Copy `output/libs/` folder to your GitHub Pages repo
4. Commit and push to GitHub Pages repo using RStudio Git pane
5. Access at: `https://iecarreras-data.github.io/phd-outcomes-dashboard-web.html`

## Skills Demonstrated

### Data Science & Analytics
- Synthetic data generation using probability distributions
- Data pipeline development (extract → transform → aggregate → visualize)
- Statistical analysis and cohort-based comparisons
- Geographic data processing and mapping

### Data Visualization
- Interactive dashboard design with multiple linked visualizations
- Effective use of color palettes for categorical data
- Choropleth maps (U.S. state-level)
- Stacked bar charts with custom ordering
- Horizontal bar charts for institutional rankings
- Custom tooltips and hover interactions

### Software Engineering
- Modular, numbered script workflow (01, 02, 03, etc.)
- Reproducible research practices (here package, .Rproj)
- Version control with Git/GitHub
- Documentation (README, inline comments)
- Separation of concerns (data generation → processing → visualization)

### Web Development
- HTML/CSS customization (Google Fonts, custom styling)
- Responsive flexdashboard layouts
- GitHub Pages deployment
- JavaScript library integration (plotly, DT)

## Customization

### Modifying the Data

To adjust the simulation parameters, edit these variables in `R/01_create_cohorts.R`:

    n_cs <- 150           # Number of Computer Science graduates
    n_physics <- 325      # Number of Physics graduates
    n_biomed <- 425       # Number of Biomedical Sciences graduates
    start_year <- 2016    # First graduation year
    end_year <- 2025      # Last graduation year

### Changing Career Probability Distributions

Edit the `career_definitions` list in `R/02_assign_careers.R` to modify:
- Job sector probabilities by department and cohort
- Employer lists
- Position titles

### Adjusting Visual Design

- **Color Palettes:** Modify `industry_palette` and `academic_palette` in the .Rmd setup chunk
- **Fonts:** Change the Google Fonts import in the CSS block
- **Layout:** Adjust flexdashboard column widths using `{data-width=}` attributes

## Known Limitations

- **Synthetic Data Only:** All graduate records are simulated and do not represent real individuals
- **Desktop Optimized:** Dashboard is designed for desktop viewing (limited mobile responsiveness)
- **Static Snapshots:** Data represents a fixed point in time (2025 snapshot of 2016-2025 cohorts)
- **Simplified Geography:** International locations are limited to a few countries

## Future Enhancements

- Add salary/compensation data (simulated)
- Include time-to-degree metrics
- Track career progression over time (initial placement vs. current position)
- Add more advanced filtering (multi-select for job sectors, graduation years)
- Mobile-responsive design
- Automated data refresh pipeline

## Contact

**Ismael E. Carreras**  
GitHub: [@iecarreras](https://github.com/iecarreras)  
Portfolio: [iecarreras-data.github.io](https://iecarreras-data.github.io)

## Acknowledgments

- Dashboard framework: [flexdashboard](https://pkgs.rstudio.com/flexdashboard/)
- Interactive visualizations: [plotly](https://plotly.com/r/)
- Data manipulation: [tidyverse](https://www.tidyverse.org/)
- Linked filtering: [crosstalk](https://rstudio.github.io/crosstalk/)
