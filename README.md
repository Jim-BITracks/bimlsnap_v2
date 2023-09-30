# bimlsnap_v2 - Getting Started
## Install BimlSnap v2 Desktop

See the bimlSnap installation video at: https://www.youtube.com/watch?v=gezORyAWVQQ 

1. Use the Data-tier application wizard in *Azure Data Studio* (SSMS has bug with this step, apparently due to some of the table names) to **Import** the 'bimlsnap_v2' .bacpac" file in this repository. This is the primary BimlSnap database, which holds all Project/Package/Connection/Etc. configurations, as well as the stored procedures and functions used to create the BIML output.
2. Unzip the file "BimlSnap_Desktop.zip". This is our Windows based (C#) front-end program, and place in the file folder of your choice.
3. Open the application file: "BimlSnap Desktop v2.exe" and connect to the "bimlsnap_v2" database created in step 1. If needed, the location of this SQL Server database can be modified by editing the file: "BimlSnap Desktop v2.exe.Config" file (see: *BimlSnapConnection* under the "connection strings" tag).
4. Again use the Data-tier application wizard to create database called 'SSIS_Data' by **deploying** the included .dacpac file which called: "SSIS_Data.dacpac" (be sure to choose the option for "New Database"). This database is used to support the BimlSnap runtime framework options, and compliments the standard SSISDB runtime database which is provided in Microsoft's SQL Server Integration Services (SSIS).
6. Unzip the SSIS Project: "Metadata Refresh v2" to your folder of choice. This project is used to collect *metadata* from one or more database servers. Note that this project definition is also provided in the 'bimlsnap_v2' database, and its configuration can be viewed from the included front-end program. This allows you to compare the resulting SSIS Project with how it was defined in BimlSnap.
7. Open the SSIS Project: "Metadata Refresh v2", verify the parameters settings (the server values all default to 'localhost), and execute the "Run All..." package. This first run will populate only the 'database' metadata table: (bimlsnap_v2.etl.dim_database).
8. Click on the top menu item "Metadata Manager" from the Front-end program, choose the "Database Selection" tab, and place a 'Y' under the "Extract Metadata (Y/N)" column for all databases which you would like to collect metadata.
9. Re-run the SSIS Project: "Metadata Refresh v2" to extract 'table', and 'column' metadata from the databases selected in step 8. It's a good practice to run this Metadata Refresh project whenever your database DDL (table and column definitions) changes.

## Prerequisites for Building SSIS packages in Visual Studio using BIML Express:
Note: BimlSnap was created based on a Visual Studio extension called "BIML Express". The creators of this extension (Varigence) appears to be behind Microsoft's release cycles, so for the best results we recommend using the following versions:
- Visual Studio 2019 (Community Edition is fine)
- SQL Server Integration Services Projects (also called SQL Server Data Tools) version 3.15 (https://marketplace.visualstudio.com/items?itemName=SSIS.SqlServerIntegrationServicesProjects)
- BIML Express (https://www.varigence.com/BimlExpress)