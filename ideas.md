## Ideas / Actions

- General refactor and tidy up
- Build as a Gem (with command line implementation)
- Add tests
- Are there better gems to help build as a command line tool
- Add functionality to import and write to database
    - Mysql
    - PostgreSQL
    - MongoDB
- Needs a command name!!

```bash
import --dir /data --db mysql --database-name charities --db-username test --db-password test
```
When importing and writing direct to database:
 - Import all files in folder
 - Removes existing tables if exist (based on files to import)
 - Create new tables (based on filed to import)
 - Loads data from BCP files to Database Tables

```bash
import -i /data/extract_aoo_ref.bcp -o /data/aoo_ref.csv
```

 - batch (or working with zip)
 - default name for initial location of file/folder

