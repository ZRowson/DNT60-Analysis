#--------------------------------------------
# Visualize Speed, Acceleration, and Jerk Curves
#   for Chemicals of Interest
# Zachary Rowson
# Rowson.Zachary@epa.gov
# Created: 12/29/2021
# Last Edit: 12/29/2021
#--------------------------------------------

# find first and second differences (acceleration and Speed)

# calculate acceleration data

## isolate speed data
ys <- grep("vt", names(pmr0), value = TRUE)
Y <- pmr0[, ..ys]

## iteratively calculate accelerations
A <- NULL
i <- 2
while (i <= length(Y)) {

  a_i <- Y[[i]] - Y[[i-1]]

  A <- cbind(A, a_i)

  i <- i + 1
}

## create pmr0 format tables with acceleration data
colnames(A) <- as <- paste0("aj", 2:50)
pmr0_A <- cbind(pmr0[, -..ys], A)


# calculate jerk data

## iteratively calculate jerk
J <- NULL
i <- 2
while (i <= ncol(A)) {

  j_i <- A[,i] - A[,i-1]

  J <- cbind(J, j_i)

  i <- i + 1
}

## create pmr0 style table with jerk data
colnames(J) <- js <- paste0("jx", 3:50)
pmr0_J <- cbind(pmr0[, -..ys], J)
