Codebook
========
This is my first codebook. 

Will describe tidy dataset

structure of dataset:

```
> str(dt_tidy)
Classes ‘data.table’ and 'data.frame':	11880 obs. of  11 variables:
 $ subject            : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity           : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ domain_signal      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
 $ acceleration_signal: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
 $ tool_signal        : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
 $ jerk_signal        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
 $ magnitude_signal   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
 $ variable           : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
 $ axis_signal        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
 $ count              : int  50 50 50 50 50 50 50 50 50 50 ...
 $ average            : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
 - attr(*, "sorted")= chr  "subject" "activity" "domain_signal" "acceleration_signal" ...
 - attr(*, ".internal.selfref")=<externalptr> 
```


Variable list and descriptions:
* subject - number of subject
* activity - activity name
* domain_signal - factor variable that indicates time domain of frequency domain signal
* acceleration_signal - factor variable that indicates is it body or gravity signal (or non)
* tool_signal - factor variable that indicates the tool that was used to measure
* jerk_signal - factor variable that indicates is it Jerk signal or not
* magnitude_signal - factor variable that indicates is it Magnitude signal or not
* variable - factor variable that indicates is it mean or SD
* axis_signal - factor variable that indicates XYZ
* count - count for each variable
* average - average of each variable


Head of data:
```
> head(dt_tidy)
   subject activity domain_signal acceleration_signal tool_signal jerk_signal
1:       1   LAYING          Time                  NA   Gyroscope          NA
2:       1   LAYING          Time                  NA   Gyroscope          NA
3:       1   LAYING          Time                  NA   Gyroscope          NA
4:       1   LAYING          Time                  NA   Gyroscope          NA
5:       1   LAYING          Time                  NA   Gyroscope          NA
6:       1   LAYING          Time                  NA   Gyroscope          NA
   magnitude_signal variable axis_signal count     average
1:               NA     Mean           X    50 -0.01655309
2:               NA     Mean           Y    50 -0.06448612
3:               NA     Mean           Z    50  0.14868944
4:               NA       SD           X    50 -0.87354387
5:               NA       SD           Y    50 -0.95109044
6:               NA       SD           Z    50 -0.90828466
```


Tail of data:
```
tail(dt_tidy)
   subject         activity domain_signal acceleration_signal   tool_signal
1:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
2:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
3:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
4:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
5:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
6:      30 WALKING_UPSTAIRS          Freq                Body Accelerometer
   jerk_signal magnitude_signal variable axis_signal count    average
1:        Jerk               NA     Mean           Z    65 -0.7378039
2:        Jerk               NA       SD           X    65 -0.5615652
3:        Jerk               NA       SD           Y    65 -0.6108266
4:        Jerk               NA       SD           Z    65 -0.7847539
5:        Jerk        Magnitude     Mean          NA    65 -0.5497849
6:        Jerk        Magnitude       SD          NA    65 -0.5808781
```


Summary of data:
```
> summary(dt_tidy)
    subject                   activity    domain_signal acceleration_signal
 Min.   : 1.0   LAYING            :1980   Time:7200     NA     :4680       
 1st Qu.: 8.0   SITTING           :1980   Freq:4680     Body   :5760       
 Median :15.5   STANDING          :1980                 Gravity:1440       
 Mean   :15.5   WALKING           :1980                                    
 3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                                    
 Max.   :30.0   WALKING_UPSTAIRS  :1980                                    
        tool_signal   jerk_signal  magnitude_signal variable    axis_signal
 Accelerometer:7200   NA  :7200   NA       :8640    Mean:5940   NA:3240    
 Gyroscope    :4680   Jerk:4680   Magnitude:3240    SD  :5940   X :2880    
                                                                Y :2880    
                                                                Z :2880    
                                                                           
                                                                           
     count          average        
 Min.   :36.00   Min.   :-0.99767  
 1st Qu.:49.00   1st Qu.:-0.96205  
 Median :54.50   Median :-0.46989  
 Mean   :57.22   Mean   :-0.48436  
 3rd Qu.:63.25   3rd Qu.:-0.07836  
 Max.   :95.00   Max.   : 0.97451  
```

