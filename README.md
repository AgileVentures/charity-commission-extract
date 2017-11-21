# Charity Commission Extract

Ruby utility for handling the import of data from the Charity Commission data extract

Work in progress project to convert the bcp data from http://data.charitycommission.gov.uk/default.aspx to standard CSV files that can be used to import data to mysql and progresql databases.

To extract the data into CSV format run the following command:

```
import.rb -i <path_to_bcp_directory>
```

```
import.rb -i <path_to_bcp_directory> -o <path_to_output_directory>
```

Note: If no input or output paramters are provided the current working directory will be used.


Related
--------

* https://github.com/ncvo/charity-commission-extract/blob/master/beginners-guide.md
* https://data.ncvo.org.uk/a/almanac16/how-to-create-a-database-for-charity-commission-data/

