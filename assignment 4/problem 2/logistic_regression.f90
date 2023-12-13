program logistic_regression
! Perform a logistic regression, either linear or quadratic on the data
! from Fig. 39.4a in McKay. For PHY2109 HW2 Problem 2.
! Compile with: gfortran -O3 -fdefault-real-8 logistic_regression.f90
implicit none

integer :: io
! logical :: exists
! character(len=32) :: filename
! real, dimension(4,5) :: points
! Data
real, parameter :: pi = 4.D0*datan(1.D0)
real, dimension(2,5) :: squares, stars
real, dimension(2,10) :: x
integer, dimension(10) :: y
! Weights
real, dimension(3) :: w = 0.
real, dimension(5) :: v = 0.
! Iterative things (don't need to separate for each case).
real, dimension(10) :: y_guess, error
real :: z, objective, magnitude
integer i

! Hard code the data in. Hopefully the readability is improved this way.
squares = reshape((/2., 3., &
					3., 2., &
					5., 3., &
					5.5, 4.5, &
					3., 6./), shape(squares))
stars = reshape((/5., 6., &
				  7., 4., &
				  8., 6., &
				  9., 7., &
				  9.5, 5./), shape(stars))
! Labels for squares and stars
y(1:5) = 0
y(6:10) = 1
! Coordinates for squares and stars
x(:,1:5) = squares
x(:,6:10) = stars

! Write point positions to file.
open(newunit=io, file="points.dat", action="write")
do i = 1,size(y)/2
	write(io,*) x(1,i), x(2,i), x(1,i+5), x(2,i+5)
end do
close(io)

call linear_logistic_regression(10**5, 0.01)
call quadratic_logistic_regression(10**5, 0.0001)
call dump()


contains


subroutine quadratic_logistic_regression(n, eta)
	integer, intent(in) :: n
	real, intent(in) :: eta
	real, dimension(5,10) :: grad
	integer :: i, j

	write(*,*) "Quadratic Logistic Regression"
	open(newunit=io, file="quad_iterative.dat", action="write")
	do j = 1,n
		objective = 0.
		do i = 1,size(y)
			z = v(1)*x(1,i) + v(2)*x(2,i) + v(3)*x(1,i)**2 +  &
				v(4)*x(2,i)**2 + v(5)
			y_guess(i) = 1./(1. + exp(-z))
			error(i) = y(i) - y_guess(i)
			! Calculate the gradient.
			grad(1,i) = -error(i)*x(1,i)
			grad(2,i) = -error(i)*x(2,i)
			grad(3,i) = -error(i)*x(1,i)**2
			grad(4,i) = -error(i)*x(2,i)**2
			grad(5,i) = -error(i)
			! Calculate error function
			objective = objective + y(i)*log(y_guess(i)+1E-16) + (1.-y(i))*log(1.-y_guess(i)+1E-16)
			! Calculate magnitude of weights vector
			magnitude = norm2(v)
		end do
		! I'm not sure why I have to do this, but it works.
		objective = -objective
		! Output all iterative data
		write(io,*) j, v(1), v(2), v(3), v(4), v(5), objective, magnitude
		! Update weights based on gradient.
		do i = 1,size(v)
			v(i) = v(i) - eta*sum(grad(i,:))
		end do
	end do
	close(io)

	write(*,*) y
	write(*,*) y_guess
end subroutine

subroutine linear_logistic_regression(n, eta)
	integer, intent(in) :: n
	real, intent(in) :: eta
	real, dimension(3,10) :: grad
	integer :: i, j

	write(*,*) "Linear Logistic Regression"
	open(newunit=io, file="lin_iterative.dat", action='write')
	do j = 1,n
		objective = 0.
		do i = 1,size(y)
			z = w(1)*x(1,i) + w(2)*x(2,i) + w(3)
			y_guess(i) = 1./(1. + exp(-z))
			error(i) = y(i) - y_guess(i)
			! Calculate the gradient.
			grad(1,i) = -error(i)*x(1,i)
			grad(2,i) = -error(i)*x(2,i)
			grad(3,i) = -error(i)
			! Calculate error function
			objective = objective + y(i)*log(y_guess(i)+1E-16) + (1.-y(i))*log(1.-y_guess(i)+1E-16)
			! Calculate magnitude of w
			magnitude = norm2(w)
		end do
		! I'm not sure why I have to do this, but it works.
		objective = -objective
		! Output all iterative data
		write(io,*) j, w(1), w(2), w(3), objective, magnitude
		! Update weights based on gradient.
		do i = 1,size(w)
			w(i) = w(i) - eta*sum(grad(i,:))
		end do
	end do
	close(io)

	write(*,*) y
	write(*,*) y_guess
end subroutine


! Dump a=0, +-1 lines to file.
subroutine dump()
	integer :: i, io, n=1000
	real :: xmin=0, xmax=10, x, dx
	real :: a0, b0, a1, b1, a2, b2, h, k, s, ds, phi
	
	! Dump linear
	dx = (xmax-xmin)/n
	open(newunit=io, file="lin_fit.dat", action="write")
	do i = 0,n
		x = i*dx
		write(io,*) x, (-w(1)*x - w(3))/w(2), & 
			(-w(1)*x - w(3) + 1.)/w(2), & 
			(-w(1)*x - w(3) - 1.)/w(2)
	end do
	close(io)
	
	
	! Dump quadratic
	ds = 2.*pi/n
	open(newunit=io, file="quad_fit.dat", action="write")
	do i = 0,n
		s = i*ds
		phi = v(1)**2/(4.*v(3)) + v(2)**2/(4.*v(4)) - v(5)
		a0 = sqrt(phi/v(3))
		b0 = sqrt(phi/v(4))
		a1 = sqrt((phi+1.)/v(3))
		b1 = sqrt((phi+1.)/v(4))
		a2 = sqrt((phi-1.)/v(3))
		b2 = sqrt((phi-1.)/v(4))
		h = -v(1)/(2.*v(3))
		k = -v(2)/(2.*v(4))
		write(io,*) h + a0*cos(s), k + b0*sin(s), &
					h + a1*cos(s), k + b1*sin(s), &
					h + a2*cos(s), k + b2*sin(s)
	end do
	close(io)
	
end subroutine


! I decided to just hardcode the data in. 
! There's only 10 points, and I'm probably never going to change it
! ever. Leaving the file reading code just in case, but it doesn't
! parse the data, just imports it.
!filename = "McKay_fig39-4a.csv"
!! Make sure the file we're trying to read exists, then read it
!! into points.
!inquire(file=filename, exist=exists)
!if (exists) then
!	open(newunit=io, file=filename, status="old", action="read")
!	! Skip the two lines of headers in the .csv
!	read(io,*)
!	read(io,*)
!	do i=1,5
!		read(io, *) points(:,i)
!		write(*,*) points(:,i)
!	end do
!	close(io)
!else
!	! Exit if we're missing the file.
!	stop "File DNE."
!end if

end program
