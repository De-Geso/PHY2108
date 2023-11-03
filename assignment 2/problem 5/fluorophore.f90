program fluorophore
implicit none


integer, parameter :: trials = 10**6
integer, parameter :: bins = 2**7

real, parameter :: r = 1.0
real, parameter :: r0 = 0.1
real, parameter :: tau = 1/(r+r0)

real :: dt, t(trials), u, hist(bins), tsum, tf, tn
integer :: state, counter(3)
integer :: i, io


call random_seed()

t = 0.0
tsum = 0.0
tf = 0.0

do i = 1, trials
	state = 2
	do while (state /= 3)
		call random_number(u)
		! Roll to determine time step
		call random_exp(tau, dt)
		if (state == 1)	tf = tf + dt
		if (state == 2)	tn = tn + dt

		counter(state) = counter(state) + 1
		if (u < r*tau) then
			if (state == 1) then;	state = 2
			else; state = 1
		end if
		else
			state = 3
		end if
		t(i) = t(i) + dt
	end do
	tsum = tsum + t(i)
end do
close(io)

print *, "Mean time to enter refractory state:", tsum/trials
print *, "Mean time spent in fluorescent state:", tf/trials
print *, "Mean time spent in non-fluorescent state:", tn/trials


call dumphist(t)
call dumptheory


contains


subroutine dumptheory()
	integer, parameter :: n = 10**2
	real :: dt
	integer :: i
	
	dt = maxval(t)/n
	
	open(newunit=io, file='theory.dat')
	do i = 1, n
		write(io,*) i*dt, 1-exp(-r0*i*dt), exp(-r0*i*dt)
	end do
	close(io)
	
end subroutine


subroutine dumphist(dat)
	real, dimension(trials), intent(in) :: dat
	real, dimension(2, bins) :: hist
	real :: width
	integer :: i, j
	
	hist = 0.0
	width = maxval(dat)/bins
	
	do i = 1, bins
		hist(1,i) = width*(i-0.5)
		do j = 1, trials
			if (dat(j) >= width*(i-1) .and. dat(j) < width*i) then
				hist(2,i) = hist(2,i) + 1
			end if 
		end do
	end do
	
	! Normalize histogram
	hist(2,:) = hist(2,:)/(sum(hist(2,:))*width)
	
	! Sum to get cumulative distribution
	hist(2,1) = hist(2,1) * width
	do i = 2, bins
		hist(2,i) = hist(2,i-1) + hist(2,i)*width
	end do
	
	open(newunit=io, file='hist.dat')
	do i = 1, bins
		write(io,*) hist(:,i), 1-hist(2,i)
	end do
	close(io)
end subroutine

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
