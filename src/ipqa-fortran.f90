module ipqa_fortran
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, ipqa-fortran!"
  end subroutine say_hello
end module ipqa_fortran
