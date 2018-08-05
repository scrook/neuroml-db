cellParser.py takes Human Brain Project (HBP) .nml files in "cells" folder and generates a CSV file that can be used by scripts in ../CSV-Importer. 

Input: cells folder with .nml files
Output: cells_data.csv file that describes the cell models and their channel dependencies. The acronyms used in the .nml file names are expanded into long names, neurolex ids, and keywords based on definitions in the term_mapping.csv file.