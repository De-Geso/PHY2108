program random_walk
! compile with:
! gfortran -O3 -fdefault-real-8 random_walk.f90 -llapack
implicit none

integer, parameter :: a = 1
integer, parameter :: tau = 1
integer, parameter :: steps = 10**3
integer, parameter :: runs = 10**5
integer, dimension(steps) :: r = 0, r2 = 0
real, dimension(steps) :: ravg = 0., r2avg = 0., t, B
integer, dimension(runs) :: returns = 0

integer u, s
integer i, j

forall (i=1:steps) t(i) = tau*i

call random_seed()

do j=1,runs
	s = 0
	do i=1,steps
		! Get step direction, and choose integer steps, or exponential.
		call random_int(0,1,u)
		u = u*2*a-a
		! Step
		s = s + u
		! Update vectors holding sums of r and r*r
		r(i) = s
		r2(i) = s*s
		! Update sums of r and r*r
		ravg(i) = ravg(i) + r(i)
		r2avg(i) = r2avg(i) + r2(i)
		if (i /= 1 .AND. s == 0) returns(j) = 1
	end do
	write(2,*) sum(r)/steps
end do
write (*,*) "Total trajectories:", runs
write (*,*) "Trajectories that returned:", sum(returns), 1.0*sum(returns)/runs
ravg = ravg/runs
r2avg = r2avg/runs

call solve()
call dump()


contains


! Converts continuous random variable (0,1] to integer random variable
! (n,m).
subroutine random_int (n,m,u)
	integer, intent(out) :: u
	integer n, m
	real r
	call random_number(r)
	u = n + floor((m-n+1)*r)
end subroutine

subroutine random_uniform(a,b,x)
   implicit none
   real,intent(in) :: a,b
   real,intent(out) :: x
   real :: u
   call random_stduniform(u)
   x = (b-a)*u + a
end subroutine random_uniform

subroutine dump()
	do i=1,steps
		write(1,*) t(i), ravg(i), r2avg(i), t(i)*B(1)
	end do
end subroutine dump

subroutine solve()
	real A(steps), s(1), W(6*steps)
	integer R, info
	! A = reshape((/t, r2avg/), (/steps, 2/))
	A = t
	B = r2avg
	
	call dgelss(steps, 1, 1, A, steps, B, steps, s, 1e-6, R, W, 6*steps, info)
	write(*,*) "status:", info
	write(*,*) "Slope:", B(1)
	
end subroutine solve

end program
