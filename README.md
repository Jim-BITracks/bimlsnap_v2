# bimlsnap_v2 - Getting Started
## Install BimlSnap v2 Solution (under the "BimlSnap Build" Folder)
1. Open and run the bimlsnap_v2 database (DDL script) in SQL Server Management Studio (SSMS)
2. Unzip the file "BimlSnapDesktop.zip" (this is the front-end application)
3. Open the application file: "BimlSnap Desktop v2.exe" and connect to the "bimlsnap_v2" database created in step 1
4. Open and run the SSIS_Data database (DDL script) in SQL Server Management Studio (SSMS). This is used to support the BimlSnap runtime framework options, and extends the standard SSISDB runtime database
5. Unzip the file "VS Deploy 1.2.zip" (this utility simplifies copying the Biml files from the bimlsnap_v2 database into Visual Studio). This program can be called directly from the BimlSnap Desktop application via a configuration file (see the contents of: "BimlSnap Desktop v2.exe.Config")

## Install Metadata Solution (under the "Metadata Management" Folder)
1. Open and run the bimlsnap_mart_v2 database (DDL script) in SQL Server Management Studio (SSMS)
2. Unzip the file "Metadata Management Front-end.zip". This is used to customize, report on, and extend your metadata collections
3. Unzip the SSIS Project: "Metadata Refresh v2". This is used to collect metadata from one or more database servers
4. Unzip the SSIS Project: "Metadata Sync v2". This project is used to 'sync' your metadata from the "bimlsnap_mart_v2" database to the bimlsnap_v2 (build) database