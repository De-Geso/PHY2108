program single_receptor_sim
! Use Gilespie algorithm to simulate receptor.
! Compile with gfortran -O3 single_receptor_sim.f90
implicit none

real, parameter :: tmax = 20.0
! Binding and unbinding rates
real, parameter :: kb(4) = (/1, 4, 1, 4/)
real, parameter :: ku(4) = (/1, 1, 4, 4/)
! Concentration
real, parameter :: c = 1.0
! Tracker for bound and unbound times
real :: t, tb, tu, dt
integer :: i, state

call random_seed()

do i = 1, size(kb)
	! Reset the state of the system.
	t = 0.0
	tb = 0.0 
	tu = 0.0
	state = 0
	do while (t < tmax)		
		write(1,*) t, state
		! Roll to determine time step
		if (state == 0) then
			call random_exp(1.0/(kb(i)*c), dt)
			t = t + dt
			tu = tu + dt
			state = 1
			write(1,*) t, 0
		else 
			call random_exp(1.0/(ku(i)), dt)
			t = t + dt
			tb = tb + dt
			state = 0
			write(1,*) t, 1
		end if
		write(1,*) t, state
	end do
	write(*,*) "kb =", kb(i), "ku =", ku(i)
	write(*,*) t, tb, tu

	write(1,*) ""
	write(1,*) ""
end do


contains


! Converts continuous random variable (0,1] to exponential random
! variable with mean=l.
subroutine random_exp(l,u)
	real, intent(in) :: l
	real, intent(out) :: u
	real :: x
	
	call random_number(x)
	u = -l*log(x)
end subroutine


end program
