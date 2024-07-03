program dia_1_evaluation
   use fortran_workshop_testing, only: assert, test
   use dia1_modules, only: section_1 => run_tests
   use dia1_subroutines, only: section_2 => run_tests
   use dia1_allocatables, only: section_3 => run_tests
   implicit none
   character(len=5) :: sect

   call get_command_argument(1, sect)

   select case(sect)
    case("1")
      call section_1
    case("2")
      call section_2
    case("3")
      call section_2
    case default
      call section_1
      call section_2
   end select

end program dia_1_evaluation