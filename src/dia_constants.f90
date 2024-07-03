module dia1_constants
    implicit none

    integer, parameter :: pr = selected_real_kind(15) 
        !! Precisión de maquina (los reales definidos con `pr` como se muestra
        !! abajo aseguran que tiene precisión hasta 15 decimales)

    real(pr) :: R = 0.082 !! Constante de gases
end module