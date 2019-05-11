# bimlsnap_v2 - Getting Started
## Install BimlSnap v2 Desktop

See the bimlSnap installation video at: https://www.youtube.com/watch?v=gezORyAWVQQ 

1. Open and run the 'bimlsnap_v2' database (DDL script) in SQL Server Management Studio (SSMS). This is the primary BimlSnap database, and it holds all Project/Package/Connection/Etc. configurations, as well as the stored procedures and functions used to build the corresponding BIML output
2. Unzip the file "BimlSnap_Desktop.zip". This is the 'primary' front-end program, and is also copy-protected. A free 15 day evaluation period is granted upon first use (note: BimlSnap_v2 can still be used without this front-end application by working directly with SQL Server back-end database commands)
3. Open the application file: "BimlSnap Desktop v2.exe" and connect to the "bimlsnap_v2" database created in step 1. If needed, the location of this SQL Server database can be modified by editing the file: "BimlSnap Desktop v2.exe.Config"
4. Open and run the SSIS_Data database (DDL script) in SQL Server Management Studio (SSMS). This is used to support the BimlSnap runtime framework options, and compliments the standard SSISDB runtime database from Microsoft
5. Unzip the file "VS Deploy 1.3.zip" and be sure the folder location of the executable "VS Deploy.exe" is properly set in the config file "BimlSnap Desktop v2.exe.Config". This optional utility simplifies the placement the Biml files into Visual Studio. 
6. Unzip the SSIS Project: "Metadata Refresh v2". This is used to collect metadata from one or more database servers.
7. Open the SSIS Project: "Metadata Refresh v2", verify the parameters settings (the server values all default to 'localhost), and execute the "Run All..." package. This first run will populate only the 'database' metadata table
8. Open the "Metadata Manager" from the Front-end program, connect to the 'bimlsnap_mart_v2' database, click on the "Database Selection" tab, and place a 'Y' under the "Extract Metadata (Y/N)" column for all databases which you would like to collect metadata.
9. Re-run the SSIS Project: "Metadata Refresh v2" to extract 'table', and 'column' metadata from the databases selected in step 8. It's a good practice to run this Metadata Refresh project whenever your database DDL (table and column definitions) change.

Additional Item:
The SSIS Project called: "Transfer Json Repository Row" can be used in conjunction with the Blog Entry: https://bitracks.wordpress.com/2018/11/21/using-json-for-table-data-movement-in-sql-server/