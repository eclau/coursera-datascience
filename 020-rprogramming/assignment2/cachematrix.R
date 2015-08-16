## Put comments here that give an overall description of what your
## functions do

## Accepts a matrix object and initialise the caching structure

makeCacheMatrix <- function(x = matrix()) {
  inversedMatrix <- NULL
  setMatrix <- function(matrix) {
    x <<- matrix
    inversedMatrix <<- NULL
  }
  getMatrix <- function() {
    x
  }
  setSolved <- function(solve) {
    inversedMatrix <<- solve
  }
  getSolved <- function() {
    inversedMatrix
  }
  list(setMatrix = setMatrix, getMatrix = getMatrix, setSolved = setSolved, getSolved = getSolved)
}


## Accepts a makeCacheMatrix function (with a cached matrix object) and produce the inverse
## of the matrix if it had not already been cached

cacheSolve <- function(x, ...) {
  solvedMatrix <- x$getSolved()
  if (!is.null(solvedMatrix)) {
    message("getting cahed data")
    return(solvedMatrix)
  }
  input <- x$getMatrix()
  solvedMatrix <- solve(input, ...)
  x$setSolved(solvedMatrix)
  solvedMatrix
}
