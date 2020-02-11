library(ringdater)
# Load some undated series
undated<-read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)

# detrend the undated series
undated<-normalise(the.data = undated, detrending_select = 3, splinewindow = 21)

#### alternatively load a series of undated chronologies
# note that using the ld_undated_chron() both loads the chronology data and detrends the data at the same time before
# calculating the arithmetic mean of the series in the chronology file.
data<-list.files()
undated<- ld_undated_chron(files = data, series_names = NULL, pair_detrend = TRUE, detrending_select = 3, splinewindow = 21, powerT = FALSE, shiny = FALSE)

# Load a dated chronology
chrono<-read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)

# detrend the dated chronology
chrono<-normalise(the.data = chrono, detrending_select = 3, splinewindow = 21)

# calculate the arithmetic mean of the chronology
mean_chrono<-data.frame(chrono[,1], rowMeans(chrono[,-1], na.rm=TRUE))
colnames(mean_chrono)<-c("Year","mean_chronology")

# combine the chronology and undated data.frames
chron_n_series<-cbind.fill(mean_chrono,undated[,-1], fill = NA)

# Run the lead-lag analysis in mode 2 (chronology analysis mode)
run_chron_mode<-lead_lag_analysis(the_data = chron_n_series, mode = 2, neg_lag = -20, pos_lag = 20, complete = TRUE, shiny = FALSE)

# view the best matches between the undated samples and the chronology
print(as.data.frame(run_chron_mode[1]))

# plot a sample with the chronology and adjust the sample dates to a specific lag. Sample 2 is lagged.
line_plot(the_data = chron_n_series, series_1 = colnames(chron_n_series)[2], series_2 = colnames(chron_n_series)[3], lag = 7)

# Examine the lead-lag results betwen two samples as a bar chart
lead_lag_bar(the_data = as.data.frame(run_chron_mode[2]), sample_1 = colnames(chron_n_series)[2],sample_2 = colnames(chron_n_series)[3])

# Evaluate the running-lead-lags to look for errors in the ring width data
# The data = the data.frame containing the detrended increment widths
# samp1 and samp 2 = column numbers for the samples you want to compare
# complete = FALSE constrains the lead-lag interval to that defined by the neg_lag and pos_lag parameters
heatmap_analysis(the_data = chron_n_series, samp1 = 2, samp2 = 3, complete = FALSE)

# Check if data passes statistical thresholds
filtered_data<-filter_crossdates(the_data = as.data.frame(run_chron_mode[1]), r_val = 0.3, p_val = 0.05, overlap = 50, target = colnames(chron_n_series)[2])

# Align the undated series against the mean chronology
aligned_data<-align_series(the_data = chron_n_series, cross_dates = filtered_data, sel_target = colnames(chron_n_series)[2])

# Replace the arithemtic mean chronology with the detrended individual seris used to construct the chronology
aligned_data<-align_to_chron(the.data = aligned_data, chrono = chrono)

# plot the aligned data
plot_all_series(aligned_data)

# Evlaute the correlation between each sample and the arithemtic mean chronology with replacement
correl_replace(aligned_data)
