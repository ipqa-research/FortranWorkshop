module ideal_gas
    use dia1_constants, only: R
    implicit none
contains
    subroutine Pressure(V, T, P, mult)
        !! Calcular presión de gas ideal
        real, intent(in) :: V !! Volume [L]
        real, intent(in) :: T
        real, intent(out) :: P
        real, optional, intent(in) :: mult
        
        P = R*T/V
        if (present(mult)) P = mult * P
    end subroutine
end module

program main
    use dia1_constants, only: R
    use ideal_gas, only: Pressure
    real :: P
    call pressure(2.0, 1.5, P)
    print *, P
    
    call pressure(V=2.0, T=1.5, P=P, mult=2.0)
    print *, P
end program
