
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

meanMaker2 <- function(v, x)
{
  starsLimit = max(x)
  means = 1:starsLimit
  
  for (star in 1:starsLimit)
  {
    means[star] = mean(v[x==star])
  }
  
  means
}


meanMaker <- function(v, stars, starsLimit=max(stars))
{
  means = 1:starsLimit
  
  for (star in 1:starsLimit)
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

setwd("~/mswl/mswl/dynamicsls/paper/")
android = read.table("./msr2k12-android/bug_stars_duration_clean.txt", header=T)
attach(android)

mean(Stars)
sd(Stars)
boxplot(Stars, main="Stars boxplot", ylab="Stars")
barplot(Stars, main="Stars barplot", xlab="Bugs", ylab="Stars")

mean(Duration)
sd(Duration)
boxplot(Duration/(60*60*24*365), main="Durations boxplot", ylab="Durations (years)")
barplot(Duration/(60*60*24*365), main="Durations barplot", xlab="Bugs", ylab="Durations (years)")

TypeInt = as.integer(Type)
mean(TypeInt)
sd(TypeInt)
boxplot(TypeInt, main="Types boxplot", ylab="Types")
barplot(TypeInt, main="Types barplot", xlab="Bugs", ylab="Types")
plot(TypeInt, main="Types", xlab="Bugs", ylab="Types")

PriorityInt = as.integer(Priority)
mean(PriorityInt)
sd(PriorityInt)
boxplot(PriorityInt, main="Priorities boxplot", ylab="Priorities")
barplot(PriorityInt, main="Priorities barplot", xlab="Bugs", ylab="Priorities")
plot(PriorityInt, main="Priorities", xlab="Bugs", ylab="Priorities")
stripplot(Priority~Stars, main="Priorities of the bugs in function of their stars", xlab="Stars", ylab="Priorities")

#plot(Stars, Duration)

timemeans = meanMaker2(Duration, Stars)

x = 1:max(Stars)
y = timemeans/(60*60*24*365)

plot(x, y, main="Mean time to solve a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Mean time to be solved (years)", ylim=c(1,4)); grid()
plot(log10(x), log10(y), main="Mean time to solve a bug vs stars (logarithmic)", xlab="Stars", ylab="Mean time to be solved (years)", ylim=c(-4,1)); grid()

timemeansWindows = meanWindows(y, 100)
barplot(timemeansWindows, ylab="Mean time to be solved (years)", main="Mean time to solve a bug vs stars (groups 100 stars)")
plot(seq(1, length(timemeans), 100), timemeansWindows, ylab="Mean time to be solved (years)", main="Mean time to solve a bug vs stars (groups 100 stars)")

prioridades = as.integer(rev(Priority))
priomeans = meanMaker2(prioridades, Stars)

x = 1:max(Stars)
y = priomeans

plot(x, y, main="Mean priority of a bug vs stars", xlab="Stars", xlim=c(1,7500), ylab="Priority", ylim=c(0,5)); grid()
plot(log10(x), log10(y), main="Mean priority of a bug vs stars (logarithmic)", xlab="Stars", ylab="Priority"); grid()
priomeansWindows = meanWindows(priomeans, 100)
barplot(priomeansWindows, ylab="Priority", ylim=c(0,5), main="Mean priority of a bug vs stars (groups 100 stars)")
plot(seq(1, length(timemeans), 100), priomeansWindows, ylab="Priority", main="Mean priority of a bug vs stars (groups 100 stars)")

#plot(priomeans)
