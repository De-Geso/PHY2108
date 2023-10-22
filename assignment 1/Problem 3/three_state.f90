program three_state
! compile with:
! gfortran -O3 -fdefault-real-8 three_state.f90
implicit none

real, parameter :: tau = 1.
real, parameter :: tmax = 10.**2
real, parameter :: r = 1
real x, y, t, M(3,3), jump, k

integer state, counter(3)
integer i, j

call random_seed()

! Initialize starting point, and choose rate matrix.
state = 1
t = 0.
counter = 0
! call init_equal_rates()
call init_biased_rates()


do while (t .LT. tmax)
	counter(state) = counter(state) + 1
	k = sum(counter)
	write (1,*) t/tau, counter(1)/k, counter(2)/k, counter(3)/k, state
	
	call random_number(x)
	
	jump = 0.
	j = 1
	! Split up the probabilities to jump to each state.
	do while (jump .LT. x * sum(M(:,state)))
		jump = jump + M(j,state)
		! write (*,*) j, jump, x*sum(M(state,:))
		j = j+1
	end do
	state = j-1
	t = t + tau
end do
write (1,*) t, counter(1)/k, counter(2)/k, counter(3)/k, state
write (*,*) counter/k
! write (*,*) M(2,1)

contains

subroutine init_equal_rates()
	M = reshape((/0., r, r, &
				r, 0., r, &
				r, r, 0./), shape(M), order=(/2,1/))
end subroutine

subroutine init_biased_rates()
	M = reshape((/0., r/2., r, &
				r, r/2., r, &
				r, r, 0./), shape(M), order=(/2,1/))
end subroutine

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

end program
