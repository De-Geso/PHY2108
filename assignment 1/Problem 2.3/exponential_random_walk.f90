program exponential_random_walk
! compile with:
! gfortran -O3 -fdefault-real-8 exponential_random_walk.f90 -llapack
implicit none

real, parameter :: lambda = 1.
real, parameter :: tau = 1.
real, parameter :: a = 10.
integer, parameter :: steps = 10**2
integer, parameter :: runs = 10**0

real, dimension(steps) :: r = 0., r2 = 0., ravg = 0., r2avg = 0., t, B
integer, dimension(runs) :: returns = 0

real u, s
integer i, j

forall (i=1:steps) t(i) = tau*i

call random_seed()

do j=1,runs
	s = 0
	do i=1,steps
		! Get step size.
		call random_exp(lambda,u)
		! Step
		s = s + u
		do while (s < 0. .OR. s > a)
			if (s > a) then ! If we go past a, turn around.
				s = a-(s-a)
			else ! If we go past 0, turn around.
				s = -s
			end if
		end do
		! Update vectors holding sums of r and r*r
		r(i) = s
		r2(i) = s*s
		! Update sums of r and r*r
		ravg(i) = ravg(i) + r(i)
		r2avg(i) = r2avg(i) + r2(i)
		if (i /= 1 .AND. ((s-u)*s) < 1.) returns(j) = 1
	end do
end do
write (*,*) "Total trajectories:", runs
write (*,*) "Trajectories that returned:", sum(returns), 1.0*sum(returns)/runs

ravg = ravg/runs
r2avg = r2avg/runs
! r2avg = r2avg + ravg*ravg

! call solve()
call dump()


contains


! Converts continuous random variable (0,1] to exponential random
! variable with lambda=l.
subroutine random_exp(l,u)
	real, intent(out) :: u
	real l, x
	call random_number(x)
	u = -l*log(x)
	call random_number(x)
	if (x <= 0.5) u = -u
end subroutine

subroutine dump()
	do i=1,steps
		write(1,*) t(i), ravg(i), r2avg(i)
	end do
end subroutine dump

subroutine solve()
	real A(steps), s(1), W(6*steps)
	integer R, info
	A = t
	B = ravg
	
	call dgelss(steps, 1, 1, A, steps, B, steps, s, 1e-6, R, W, 6*steps, info)
	write(*,*) "status:", info
	write(*,*) "Slope:", B(1)
end subroutine solve

end program
