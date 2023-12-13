program atom_separation
! PHY2108 HW 2 Problem 3.
! Use the Langevin equation to simulate two atoms attached to eachother
! with a harmonic potential.
! Compile with: gfortran -O3 atom_separation.f90
implicit none

real, parameter :: pi=4.D0*DATAN(1.D0)

! Program parameters
integer, parameter :: trials = 2**6
real, parameter :: tmax = 2.0**6
real, parameter :: dt = 0.0001
integer, parameter :: steps = floor(tmax/dt)

! Physical parameters
real, parameter :: x0 = 1.0
real, parameter :: beta = 1.0
real, parameter :: a = 2.0
real, parameter :: D = 1.0
real, parameter :: mu = beta*D

real, dimension(trials) :: xnext, xnow, r, rsum, r2sum
real :: u, t

integer :: i, j

call random_seed()

rsum = 0.0
r2sum = 0.0
xnow = x0

open(1, file='mean_r.dat')
open(2, file='var_r.dat')
do i = 1, steps
	t = dt*i
	do j = 1, trials
		r(j) = xnow(j)
		rsum(j) = rsum(j) + abs(r(j))
		r2sum(j) = r2sum(j) + abs(r(j)**2)
		call rand_norm(u, 0.0, 2.0*D*dt)
		! Calculate next x position. Change to Runge-Kutte 4 later?
		xnext(j) = xnow(j) + mu*force(r(j))*dt + u
		xnow(j) = xnext(j)
	end do
	! Average r
	write (1,*) t, sum(rsum)/i/trials, ravg_theory(t)
	! Variance of r
	write (2,*) t, sum(r2sum)/i/trials - (sum(rsum)/i/trials)**2, var_theory(t)/sqrt(pi)
end do
close(1)
close(2)

print *, 'Average separation is:', sum(rsum)/i/trials

! Plot histograms
call execute_command_line('gnuplot -p ' // 'atom_separation.gp')


contains 


pure function var_theory(t) result(var)
	real, intent(in) :: t
	real :: var
	
	var = 2/(pi*a)*(1-exp(-2*a*D*t))
end function


pure function ravg_theory(t) result(r)
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
