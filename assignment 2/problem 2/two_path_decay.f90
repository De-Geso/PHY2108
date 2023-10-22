program two_path_decay
! Use the Gillespie algorithm to simulate a molecule that can decay via
! two paths.
! compile with: gfortran -O3 two_path_decay.f90
implicit none
integer, parameter :: dp = selected_real_kind(15, 307)

! Number of trials to do.
integer, parameter :: trials = 10**5
! Number of bins for histograms.
integer, parameter :: bins = 2**6

! Rate of decay via path 1.
real(dp), parameter :: r1 = 4
! Rate of decay via path 2.
real(dp), parameter :: r2 = 6

! Record of results 
real(dp), dimension(trials) :: surv, t1, t2
real(dp) :: t, dt, u, tau
integer :: i, nt1, nt2

call random_seed()
! Tau is the mean of the exponential
tau = 1/(r1+r2)
t1 = 0
t2 = 0
nt1 = 0
nt2 = 0

do i = 1, trials
	call random_number(u)
	call random_exp(tau, t)
	
	
	if (u < tau*r1) then
		t1(i) = t
		nt1 = nt1 + 1
	else
		t2(i) = t
		nt2 = nt2 + 1
	end if
	surv(i) = t
	
!	print *, tau, t, u, nt1, nt2
end do

print *, sum(surv)/trials, 1.0_dp*nt1/trials, sum(t1)/nt1, 1.0_dp*nt2/trials, sum(t2)/nt2

! Dump data to file
call dump()
! Plot
call execute_command_line('gnuplot -p ' // 'two_path_decay_plot.gp')

contains


! Converts continuous random variable (0,1] to exponential random
! variable with mean=l.
subroutine random_exp(l,u)
	real(dp), intent(in) :: l
	real(dp), intent(out) :: u
	real(dp) :: x
	
	call random_number(x)
	u = -l*log(x)
end subroutine


! Converts decay times into frequency data.
function data2hist(dat) result (hist)
	real(dp), dimension(trials), intent(in) :: dat
	real, dimension(2, bins) :: hist
	
	real(dp) width
	integer i, j
	
	hist = 0
	width = maxval(surv)/bins
	
	do i = 1, bins
		hist(1,i) = 1.0*width*(i-1)/tau
		do j = 1, trials
			if (dat(j) > (i-1)*width .and. dat(j) <= i*width) then
				hist(2,i) = hist(2,i) + 1
			end if
		end do
	end do
	
	hist(2,:) = hist(2,:)/(sum(hist(2,:))*width)
	
	hist(2,1) = hist(2,1) * width
	do i = 2, bins
		hist(2,i) = hist(2,i-1) + hist(2,i)*width
	end do
	hist(2,:) = 1-hist(2,:)
end function
	

! Dump results to data files, and plot.
subroutine dump()
	real(dp) :: dt, t
	integer :: i, j, io, n
	real, dimension(2, bins) :: surv_hist, t1_hist, t2_hist
	
	n = 10**2
	
	! Dump data
	open(newunit=io, file='two_path_decay_data.dat')
	do i = 1, trials
		write (io,*) surv(i), t1(i), t2(i)
	end do
	close(io)
	
	! Dump theory
	! Get the number of time steps we require.
	dt = maxval(surv)/(n-1)
	open(newunit=io, file='two_path_decay_theory.dat')
	do i = 1, n
		t = dt*(i-1)
		write (io,*) t/tau, Psurv(t), P1(t), P2(t)
	end do
	close(io)
	
	! Convert data to histogram data.
	surv_hist = data2hist(surv)
	t1_hist = r1*tau*(1-data2hist(t1))
	t2_hist = r2*tau*(1-data2hist(t2))
	! Dump histogram data.
	open(newunit=io, file='two_path_decay_hist.dat')
	do i = 1, bins
		write (io,*) surv_hist(1,i), surv_hist(2,i), t1_hist(2,i), t2_hist(2,i)
	end do
	close(io)

end subroutine


! Survival probability
pure function Psurv(t)
	real(dp), intent(in) :: t
	real(dp) :: Psurv
	
	Psurv = exp(-(r1+r2)*t)
end function


! Decay probability via 1
pure function P1(t)
	real(dp), intent(in) :: t
	real(dp) :: P1
	
	P1 = r1*tau*(1-exp(-(r1+r2)*t))
end function


! Decay probability via 2
pure function P2(t)
	real(dp), intent(in) :: t
	real(dp) :: P2
	
	P2 = r2*tau*(1-exp(-(r1+r2)*t))
end function

end program
