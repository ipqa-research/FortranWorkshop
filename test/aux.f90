module fortran_workshop_testing
    implicit none

    abstract interface
        subroutine test
        end subroutine
    end interface

contains
    subroutine assert(str, failed)
        use stdlib_ansi, only: fg_color_green, fg_color_red, style_reset, operator(//)
        character(len=*), intent(in) :: str
        logical, intent(in) :: failed
        
        if (failed) then
            print *, fg_color_red // str // style_reset
        else
            print *, str // fg_color_green //  ": [Aproved ✓]"// style_reset
        end if
    end subroutine
end module