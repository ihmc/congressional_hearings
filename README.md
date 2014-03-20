congressional_hearings
======================

This is an attempt to recreate the csv files for Congressional Hearings for the [NLP Unshared Task in PoliInformatics 2014](https://sites.google.com/site/unsharedtask2014/home). In addition to the "Speaker" and "Speech" columns that existed in the original files, there are now "Type" and "Comments" columns. The type is one of

* Speech
* Statement

And if a record is a Statement, then the Comments column will include the text of the Statement header.

For example

| "Speaker" | "Speech" | "Type" | "Comment" |
| --------- | -------- | ------ | --------- |
| "Chairman Greenspan",|"Thank you very much, Mr. Chairman and Members of the Committee. I am, as always, pleased to be here today to present----", | "Statement", | "STATEMENT OF ALAN GREENSPAN, CHAIRMAN BOARD OF GOVERNORS OF THE FEDERAL RESERVE SYSTEM" |


The new files are colocated with the original files in the data directory with a **.htm.csv** file extension.

To regenerate the files, run 

    rake poliinformatics:convert
    
To test the code on your system, run 

    rspec spec
