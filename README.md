# PlatinumRx Data Analyst Assignment

This repository contains the completed assignment answering tasks divided into SQL, Python, and Spreadsheets.

## Directory Structure

- `SQL/`: Contains the database schema setup and query scripts for the Hotel and Clinic management systems.
  - `01_Hotel_Schema_Setup.sql`: Tables and Sample data for the Hotel system.
  - `02_Hotel_Queries.sql`: SQL Queries answering Questions 1-5 for Part A.
  - `03_Clinic_Schema_Setup.sql`: Tables and Sample data for the Clinic system.
  - `04_Clinic_Queries.sql`: SQL Queries answering Questions 1-5 for Part B.
- `Python/`: Contains logic test scripts.
  - `01_Time_Converter.py`: Converts raw minutes into formatted `X hrs Y minutes` values.
  - `02_Remove_Duplicates.py`: Safely removes duplicate characters from strings natively using looping.
- `Spreadsheets/`: Contains the generated target Excel file and the Python builder logic.
  - `Ticket_Analysis.xlsx`: The generated output containing 2 sheets (`ticket`, `feedbacks`). Includes computed helper columns for same-day (`INT`) and same-hour ticket logic. Feedback dynamically pulls `ticket_created_at` using backwards `INDEX-MATCH` lookup.
  - `create_excel.py`: Can be run using Python (`pip install openpyxl`) to procedurally verify the formula generations.

## How to use
- **SQL**: You can execute the setup scripts inside any MySQL Workbench or PostgreSQL environment.
- **Python**: Run any file with `python <filename>.py`.
- **Spreadsheets**: Open `Ticket_Analysis.xlsx` in Microsoft Excel to visualize formulas and evaluation outputs.
