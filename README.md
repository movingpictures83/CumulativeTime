# CumulativeTime
# Language: R
# Input: TXT (parameters)
# Output: Prefix (selected features)
# Tested with: PluMA 1.0, R 3.2.5

PluMA plugin that chooses the best features to use 
to classify a set of samples for each point over a set of timepoints.
Both input files (training and clinical) are assumed to be in TSV (tab-separated value)
format, with rows corresponding to subjects and columns corresponding to feature values.
The input for the plugin is a TXT file of keyword-value pairs, training and clinical,
each mapping to their respective filenames.

The output prefix will begin each output CSV file, named:
(prefix)(time).csv

where (time) is the current timepoint.  These consist of multiple lines of the form:

<featurename>,<value>

Note the input TSV and CSV files in the example/ directory are not publically available.
A future goal is to make a synthetic data set.  In the meantime however, one may
use it on their own tab-separated input data.
