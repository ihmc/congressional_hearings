congressional_hearings
======================

This is an attempt to recreate the csv files for Congressional Hearings for the [NLP Unshared Task in PoliInformatics 2014](https://sites.google.com/site/unsharedtask2014/home).

The new files are colocated with the original files in the data directory with a .htm.csv file extension.

To regenerate the files, run 

    rake poliinformatics:convert
    
To test the code on your system, run 

    rspec spec
