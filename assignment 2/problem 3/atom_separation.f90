program atom_separation
! PHY2108 HW 2 Problem 3.
! Use the Langevin equation to simulate two atoms attached to eachother
! with a harmonic potential.
! Compile with: gfortran -O3 atom_separation.f90
implicit none

real, parameter :: pi=4.D0*DATAN(1.D0)

! Program parameters
integer, parameter :: trials = 2**0
real, parameter :: tmax = 2.0**6
real, parameter :: dt = 0.0001
integer, parameter :: steps = floor(tmax/dt)

! Physical parameters
real, parameter :: x0 = 1.0
real, parameter :: beta = 1.0
real, parameter :: a = 4.0
real, parameter :: D = 1.0
real, parameter :: mu = beta*D

real :: xnext, xnow
real :: r, rsum, u, t

integer :: i, j

call random_seed()

rsum = 0.0
xnow = x0

do j = 1, trials
	do i = 1, steps
		t = dt*i
		r = xnow
		rsum = rsum + abs(r)
		call rand_norm(u, 0.0, 2.0*D*dt)
		! Calculate next x position. Change to Runge-Kutte 4 later?
		xnext = xnow + mu*force(r)*dt + u
		! Record all the trials in scratch files to combine later.
		open(unit=j, status='scratch')
		write (j,*) t, xnow, abs(r), rsum/i, ravg_theory(t)
		xnow = xnext
	end do
	close(j)
end do

print *, rsum/i


contains 


subroutine dump()
	character(len=8) :: filename
	integer :: i, io
end subroutine

pure function ravg_theory(t) result (r)
	real, intent(in) :: t
	real :: r
	
	r = sqrt(x0**2*exp(-2*a*D*t) + 2/(pi*a)*(1-exp(-2*a*D*t)))
end function


pure function force(x) result(f)
	real, intent(in) :: x
	real :: f
	
	f = -a*x/beta
end function


! Convert the standard Fortran random number range from 0<=x<1 to
! 0<x<=1 so that there's no funny business with logarithms.
subroutine rand_stduni(u)
	real,intent(out) :: u
	real :: r
	call random_number(r)
	u = 1 - r
end subroutine


! Use Box-Muller to get a standard normal distribution.
subroutine rand_stdnorm(x)
	real,intent(out) :: x
	real :: u1,u2
	call rand_stduni(u1)
	call rand_stduni(u2)
	x = sqrt(-2*log(u1))*cos(2*pi*u2)
end subroutine


! Convert a given standard normal distributed random number to one with
! a new mu and variance.
subroutine rand_norm(x, mu, var)
	real, intent(out) :: x
	real :: mu, var
	call rand_stdnorm(x)
	x = sqrt(var)*x + mu
end subroutine

end program
