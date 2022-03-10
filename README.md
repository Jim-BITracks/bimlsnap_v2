# bimlsnap_v2 - Getting Started
## Install BimlSnap v2 Desktop

See the bimlSnap installation video at: https://www.youtube.com/watch?v=gezORyAWVQQ 

1. Create a database called 'bimlsnap_v2' from the included "bimlsnap_v2.bacpac" file. This is the primary BimlSnap database, which holds all Project/Package/Connection/Etc. configurations, as well as the stored procedures and functions used to create the BIML output.
2. Unzip the file "BimlSnap_Desktop.zip". This is our Windows based (C#) front-end program.
3. Open the application file: "BimlSnap Desktop v2.exe" and connect to the "bimlsnap_v2" database created in step 1. If needed, the location of this SQL Server database can be modified by editing the file: "BimlSnap Desktop v2.exe.Config"
4. Create a database called 'SSIS_Data' by deploying the included "data-tier application" which is located in file "SSIS_Data.dacpac". This database is used to support the BimlSnap runtime framework options, and compliments the standard SSISDB runtime database from Microsoft
6. Unzip the SSIS Project: "Metadata Refresh v2". This is used to collect metadata from one or more database servers.
7. Open the SSIS Project: "Metadata Refresh v2", verify the parameters settings (the server values all default to 'localhost), and execute the "Run All..." package. This first run will populate only the 'database' metadata table
8. Click on the top menu item "Metadata Manager" from the Front-end program, choose the "Database Selection" tab, and place a 'Y' under the "Extract Metadata (Y/N)" column for all databases which you would like to collect metadata.
9. Re-run the SSIS Project: "Metadata Refresh v2" to extract 'table', and 'column' metadata from the databases selected in step 8. It's a good practice to run this Metadata Refresh project whenever your database DDL (table and column definitions) changes.
10. (Optional) Install the Azure Data Studio 'extension' using the included file: bimlsnap-0.0.24.vsix