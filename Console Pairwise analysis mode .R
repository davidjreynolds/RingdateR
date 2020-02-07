# Running RingdateR's Pairwise Analysis Mode of undated series in the console or as a script:

library("ringdater")

# Load same ring width data
# this example is using a csv file
the_data<-read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)

# Detrend the ring width data
the_data<-normalise(the.data = the_data, detrending_select = 3, splinewindow = 21)

# Run the lead-lag analysis
run_pairwise<-lead_lag_analysis(the_data = the_data, mode = 1, neg_lag = -20, pos_lag = 20, complete = FALSE, shiny = FALSE)

# Examine the lead-lag results betwen two samples as a bar chart
lead_lag_bar(the_data = as.data.frame(run_pairwise[2]), sample_1 = colnames(the_data)[2],sample_2 = colnames(the_data)[3])

# Evaluate the running-lead-lags to look for errors in the ring width data
# The data = the data.frame containing the detrended increment widths
# samp1 and samp 2 = column numbers for the samples you want to compare
# complete = FALSE constrains the lead-lag interval to that defined by the neg_lag and pos_lag parameters
heatmap_analysis(the_data = the_data, samp1 = 2, samp2 = 3, complete = FALSE)

# Check if data passes statistical thresholds
filtered_data<-filter_crossdates(the_data = as.data.frame(run_pairwise[1]), r_val = 0.3, p_val = 0.05, overlap = 50, target = colnames(the_data)[2])

# Align the data relative to a slected target sample
aligned_data<-align_series(the_data = the_data, cross_dates = filtered_data, sel_target = colnames(the_data)[2])

# plot the aligned data
plot_all_series(aligned_data)

# Evlaute the correlation between each sample and the arithemtic mean chronology with replacement
correl_replace(aligned_data)
