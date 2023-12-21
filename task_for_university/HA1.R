cat("task1", "\n")
matrix1 <- matrix(c(1,0,0,2,0,3,1,4,2,0,-3,5),ncol = 4,byrow = TRUE)
print(matrix1)
transpose_matrix <- t(matrix1)
cat("transpose matrix:", "\n")
print(transpose_matrix)
cat("size1:", nrow(matrix1), "x", ncol(matrix1), "\n")
cat("size2:", nrow(transpose_matrix), "x", ncol(transpose_matrix), "\n")

cat("rows:", matrix1[1,], "\n", matrix1[2,], "\n", matrix1[3,], "\n")
cat("cols:", matrix1[,1], "\n", matrix1[,2], "\n", matrix1[,3], "\n")

matrix1 <- matrix(c(1,3,5,1),ncol = 1,byrow = TRUE)
print(matrix1)
transpose_matrix <- t(matrix1)
cat("transpose matrix:", "\n")
print(transpose_matrix)
cat("size1:", nrow(matrix1), "x", ncol(matrix1), "\n")
cat("size2:", nrow(transpose_matrix), "x", ncol(transpose_matrix), "\n")

cat("rows:", matrix1[1,], "\n", matrix1[2,], "\n", matrix1[3,], "\n", matrix1[4,], "\n")
cat("cols:", matrix1[,1], "\n")

cat("task2", "\n")
matrix1 <- matrix(c(2,-3,4,7,6,-5,-1,8,9),ncol = 3,byrow = TRUE)

matrix2 <- matrix(c(-1,3,-4,-7,-5,5,1,-8,-8),ncol = 3,byrow = TRUE)
print(matrix1 + matrix2)


cat("task3", "\n")
matrix1 <- matrix(c(1,0,3,-4,2,1),ncol = 2,byrow = TRUE)
matrix2 <- matrix(c(1,-1,2,3,1,-5),ncol = 2,byrow = TRUE)
matrix3 <- matrix(c(3,4,1,-3,8,6),ncol = 2,byrow = TRUE)

print(3*matrix1+4*matrix2-2*matrix3)
cat("task4", "\n")
cat("3x5\n3x6\n")
cat("task5", "\n")

test_multiplication <- function(a, b) {
  return( ncol(a) == nrow(b))
}
cat("a)", "\n")
matrix1 <- matrix(c(1,0,2,-3,2,1,0,0,1),ncol = 3,byrow = TRUE)
matrix2 <-  matrix(c(-1,3,1,0,1,1,-2,1,3),ncol = 3,byrow = TRUE)
if(test_multiplication(matrix1, matrix2)) {
  print(matrix1 %*% matrix2)
}
if(test_multiplication(matrix2, matrix1)) {
  print(matrix2 %*% matrix1)
}
cat("б)", "\n")

matrix1 <- matrix(c(2,1,-2,3,-4,2,1,0,0),ncol = 3,byrow = TRUE)
matrix2 <-  matrix(c(2,0,1,1,0,-2),ncol = 2,byrow = TRUE)
if(test_multiplication(matrix1, matrix2)) {
  print(matrix1 %*% matrix2)
}
if(test_multiplication(matrix2, matrix1)) {
  print(matrix2 %*% matrix1)
}
cat("в)", "\n")

matrix1 <- matrix(c(1,-1,2),ncol = 1,byrow = TRUE)
matrix2 <-  matrix(c(3,4,1),ncol = 3,byrow = TRUE)
if(test_multiplication(matrix1, matrix2)) {
  print(matrix1 %*% matrix2)
}
if(test_multiplication(matrix2, matrix1)) {
  print(matrix2 %*% matrix1)
}



cat("г)", "\n")
matrix1 <- matrix(c(1,2,3,4,2,-1,-3,0),ncol = 4,byrow = TRUE)
matrix2 <-  matrix(c(1,0,1,2),ncol = 1,byrow = TRUE)
if(test_multiplication(matrix1, matrix2)) {
  print(matrix1 %*% matrix2)
}
if(test_multiplication(matrix2, matrix1)) {
  print(matrix2 %*% matrix1)
}


cat("task6", "\n")
matrix1 <- matrix(c(1,2,3,-1),ncol = 2,byrow = TRUE)
print(matrix1 %*% matrix1)

matrix1 <- matrix(c(2,1,1,4),ncol = 2,byrow = TRUE)
print(matrix1 %*% matrix1 %*% matrix1)



cat("task7", "\n")
f1 <- function(x) {
  return( x %*% x - 2 * x)
}
matrix1 <- matrix(c(4,-3,9,1),ncol = 2,byrow = TRUE)
print(f1(matrix1))
