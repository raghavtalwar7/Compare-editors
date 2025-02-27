# Compare Text editors

This repository contains the experiment code for the 2025 TU Delft course "Sustainable Software Engineering" [link](https://luiscruz.github.io/course_sustainableSE/2025/)

Notepad++, vim and Neovim text were compared in terms of energy usage.

Procedure to run the project: 

a. Run the automation script. [Note: there are several paths that need to be edited according to where the softwares used have be stored in the machine you are testing on.]

b. After the script is finished there will be 90 results.csv files generated 30 for each type of editor.

c. These files need to be moved in a similar way as they are in the already present results folder.

    1. results01.csv, results02.csv ........ results030.csv belong to Notepad++.

    2. results11.csv, results12.csv ........ results130.csv belong to Vim.

    3. results21.csv, results22.csv ........ results230.csv belong to Neovim.
    
d. Now these results can be used for data analysis which can be done using **data_analysis.py**. [Note: You might need to change the path of results folder]