program tf_absorption
! PHY 2108 HW 2 problem 1.
! Simulate a random walk by the transcription factor (tf). It has an
! absorbing boundary at xf > x0.
! compile with: gfortran -O3 tf_absorption
implicit none

! Number of trials to do for each location.
integer, parameter :: n = 10**3
! Where to place xf
integer, parameter :: xf = 100
! We also need an escape location to stop the simulation early. For
! simplicity's sake, set L=0.

! Be careful changing these. If p and q are very close, it greatly
! increases the run time.
! Probability to step right.
real, parameter :: p = 0.49
! Probability to step left.
real, parameter :: q = 1.0-p

real :: u, p_abs(0:xf), t_avg(0:xf)
integer :: x, nabs(0:xf), t
integer :: i, j

! Illegal probability check.
if (abs(p) > 1.0) stop "p or q > 1."

call random_seed()

nabs = 0
nabs(0) = 0
nabs(xf) = n
t_avg = 0

! Do n runs for each starting point between 0 and nf.
do i = 1, xf-1
	do j = 1, n
		x = i
		t = 0
		! Step left or right.
		do while (x > 0 .and. x < xf)
			call random_number(u)
			if (u < p) then
				x = x + 1
			else
				x = x - 1
			end if
			t = t + 1
		end do
		if (x == xf) then
			nabs(i) = nabs(i) + 1
			! If we were absorbed, count the time.
			t_avg(i) = t_avg(i) + t
		end if
	end do
end do

p_abs = 1.0 * nabs/n
t_avg = 1.0 * t_avg/nabs

call dump()


contains


! Dump results.
subroutine dump()
	integer :: i
	
	do i = 0, xf
		write (*,*) i, n-nabs(i), 1.0-p_abs(i), 1.0-abs_theory(i), t_avg(i), t_avg_theory(i)
	end do
end subroutine


! Theoretical absorption probabilities for all cases.
pure function abs_theory(x0) result(prob)
	integer, intent(in) :: x0
	real :: prob
	
	if (p > q) then
		prob = 1.0
	else if (p < q) then
		prob = (q/p)**(x0-xf)
	else 
		prob = 1.0 * x0/xf
	end if
end function


pure function t_avg_theory(x0) result(t)
	integer, intent(in) :: x0
	real :: t, tau
	tau = 1.0
	
	if (p > q) then
		t = tau/(p-q)*(xf-x0)
	else
		t = 1.0 * tau/(p-q)*(xf-x0 + xf/(-(q/p)**xf) * ((q/p)**x0 - (q/p)**xf))
		t = tau/(p-q) * (xf-x0 + xf/(q/p)**xf * ((q/p)**x0 - (q/p)*xf))
		t = t / (q/p)**(x0-xf)
	end if
end function

end program 
