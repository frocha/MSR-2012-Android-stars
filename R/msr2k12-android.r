# Function meanWindows
# This function splits a vector into segments of a given window size, and returns
# a vector containing the means of each window
# Params:
#  v: vector which want to be "windowized"
#  windowSize: integer containing the size of the window
# Return:
#  A vector containing the windows means
meanWindows <- function(v, windowSize)
{
  windowsNumber = as.integer(length(v)/windowSize)
  means = 1:windowsNumber
  
  counter = 1
  for (i in seq(1, length(v), windowSize))
  {
    means[counter] = mean(v[i:(i+windowSize-1)], na.rm=T)
    counter = counter + 1
  }
  
  means
}

# Function medianMaker2
# This function calculates the median values from the given vector grouping
# the values in function of the stars of the vector x
# Params:
#  v: vector containing the values
#  x: vector containing the stars rankings of each value from v with the same index
# Return:
#  A vector containing the median values, each index for a star value
medianMaker2 <- function(v, x)
{
  starsLimit = max(x)
  medians = 0:starsLimit
  
  for (star in 0:starsLimit)
  {
    medians[star] = median(v[x==star])
  }
  
  medians
}

# Function meanMaker2
# This function calculates the mean values from the given vector grouping
# the values in function of the stars of the vector x
# Params:
#  v: vector containing the values
#  x: vector containing the stars rankings of each value from v with the same index
# Return:
#  A vector containing the mean values, each index for a star value
meanMaker2 <- function(v, x)
{
  starsLimit = max(x)
  means = 0:starsLimit
  
  for (star in 0:starsLimit)
  {
    means[star] = mean(v[x==star])
  }
  
  means
}

# Function meanMaker
# This function calculates the mean values from the given vector grouping
# the values in function of the stars of the vector x
# Params:
#  v: vector containing the values
#  stars: vector containing the stars rankings of each value from v with the same index
#  starsLimit: limit of the maximum star value to be used (to improve calculation time)
# Return:
#  A vector containing the mean values, each index for a star value
meanMaker <- function(v, stars, starsLimit=max(stars))
{
  means = 0:starsLimit
  
  for (star in 0:starsLimit)
  {
    counter = 0
    means[star] = 0
    for (i in 1:length(stars))
    {
      if (star == stars[i])
      {
        means[star] = means[star] + v[i]
        counter = counter + 1
      }
    }
    means[star] = means[star] / counter
  }
  
  means
}

library("lattice")

# Setting the working path
setwd("~/mswl/17.Dynamics-of-Libre-Software-Communities/MSR-2012-Android-stars/R/")

# Read the data (relative path to the working path)
android = read.table("~/workspace/msr2k12-android/bug_stars_duration_clean.txt", header=T)
attach(android)

# Stars variable
print("Stars")
print(summary(Stars))
print(paste("Standard deviation", sd(Stars)))
boxplot(Stars, main="Stars boxplot", ylab="Stars")
barplot(Stars, main="Stars barplot", xlab="Bugs", ylab="Stars")

# Duration variable
print("Duration")
print(summary(Duration))
print(paste("Standard deviation", sd(Duration)))
boxplot(Duration/(60*60*24*365), main="Durations boxplot", ylab="Durations (years)")
barplot(Duration/(60*60*24*365), main="Durations barplot", xlab="Bugs", ylab="Durations (years)")

# Type variable
print("Type")
print(summary(Type))
TypeInt = as.integer(Type)
print(summary(TypeInt))
print(paste("Standard deviation", sd(TypeInt)))
boxplot(TypeInt, main="Types boxplot", ylab="Types")
barplot(TypeInt, main="Types barplot", xlab="Bugs", ylab="Types")
plot(TypeInt, main="Types", xlab="Bugs", ylab="Types")

# Type priority
print("Priority")
print(summary(Priority))
PriorityInt = as.integer(Priority)
print(summary(PriorityInt))
print(paste("Standard deviation", sd(PriorityInt)))
boxplot(PriorityInt, main="Priorities boxplot", ylab="Priorities")
barplot(PriorityInt, main="Priorities barplot", xlab="Bugs", ylab="Priorities")
#plot(PriorityInt, main="Priorities", xlab="Stars", ylab="Priorities")
plot(PriorityInt, xlab="Number of Subscribers", ylab="Priority")

stripplot(Priority~Stars, main="Priorities of the bugs in function of their stars", xlab="Stars", ylab="Priorities")

# Representations
# Duration vs Stars
plot(jitter(Stars, factor=5), jitter(Duration/(60*60*24*365), factor=2), col=rgb(0, 100, 0, 50, maxColorValue=255), pch=16, main="Time to solve a bug vs stars"); grid()
#plot(jitter(Stars, factor=5), jitter(Duration/(60*60*24*365), factor=2), col=rgb(0, 100, 0, 50, maxColorValue=255), pch=16, log="xy", main="Time to solve a bug vs stars (log)"); grid()
plot(jitter(Stars, factor=5), jitter(Duration/(60*60*24*365), factor=2), xlab="Number of Subscribers (logarithmic)", ylab="Resolution Time (logarithmic)", col=rgb(0, 100, 0, 50, maxColorValue=255), pch=16, log="xy"); grid()


# Calculation of the medians of the durations in function of the stars
timeMedians = medianMaker2(Duration, Stars)
x = 0:max(Stars)
y = timeMedians/(60*60*24*365)

# Plot of the medians of the durations in function of the stars
plot(x, y, main="Median time to solve a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Mean time to be solved (years)"); grid()
plot(log10(x), log10(y), main="Median time to solve a bug vs stars (logarithmic)", xlab="Stars", ylab="Mean time to be solved (years)"); grid()

# Calculation of the means of the durations in function of the stars
timeMeans = meanMaker2(Duration, Stars)
x = 0:max(Stars)
y = timeMeans/(60*60*24*365)

# Plot of the means of the durations in function of the stars
plot(x, y, main="Mean time to solve a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Mean time to be solved (years)"); grid()
plot(log10(x), log10(y), main="Mean time to solve a bug vs stars (logarithmic)", xlab="Stars", ylab="Mean time to be solved (years)"); grid()

# Calculation of the means of the durations in windows in function of the stars
timeMeansWindows = meanWindows(y, 100)

# Plot of the means of the durations in windows in function of the stars
barplot(timeMeansWindows, ylab="Mean time to be solved (years)", main="Mean time to solve a bug vs stars (groups 100 stars)")
plot(seq(1, length(timeMeans), 100), timeMeansWindows, ylab="Mean time to be solved (years)", main="Mean time to solve a bug vs stars (groups 100 stars)")

# Calculation of the medians of the priorities in function of the stars
prioridades = as.integer(rev(Priority))
priorityMedians = medianMaker2(prioridades, Stars)
x = 0:max(Stars)
y = priorityMedians

# Plot of the medians of the priorities in function of the stars
plot(x, y, main="Medians priority of a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Priority"); grid()
plot(log10(x), log10(y), main="Medians priority of a bug vs stars (logarithmic)", xlab="Stars", ylab="Priority"); grid()

# Calculation of the means of the priorities in function of the stars
priorityMeans = meanMaker2(prioridades, Stars)
x = 0:max(Stars)
y = priorityMeans

# Plot of the means of the priorities in function of the stars
plot(x, y, main="Mean priority of a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Priority"); grid()
plot(log10(x), log10(y), main="Mean priority of a bug vs stars (logarithmic)", xlab="Stars", ylab="Priority"); grid()

# Calcualation of the means of the priorities in windows in function of the stars
priomeansWindows = meanWindows(priorityMeans, 100)

# Plot of the means of the priorities in windows in function of the stars
barplot(priomeansWindows, ylab="Priority", main="Mean priority of a bug vs stars (groups 100 stars)")
plot(seq(1, length(timeMeans), 100), priomeansWindows, ylab="Priority", main="Mean priority of a bug vs stars (groups 100 stars)")

detach(android)
