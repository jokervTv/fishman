module log_mod

  use hash_table_mod
  use string_mod

  implicit none

  private

  public log_init
  public log_add_diag
  public log_notice
  public log_warning
  public log_error

  type(hash_table_type) diags

contains

  subroutine log_init()

    diags = hash_table()

    call log_notice('Log module is initialized.')

  end subroutine log_init

  subroutine log_add_diag(name, value)

    character(*), intent(in) :: name
    class(*), intent(in) :: value

    call diags%insert(name, value)

    select type (value)
    type is (integer)
    type is (real(4))
    type is (real(8))
    class default
      call log_error('Unsupported diagnostic value type!')
    end select

  end subroutine log_add_diag

  subroutine log_notice(message, file, line)

    character(*), intent(in) :: message
    character(*), intent(in), optional :: file
    integer, intent(in), optional :: line

    if (present(file) .and. present(line)) then
      write(6, *) '[Notice]: ' // trim(file) // ':' // trim(to_string(line)) // ': ' // trim(message)
    else
      write(6, *) '[Notice]: ' // trim(message)
    end if

  end subroutine log_notice

  subroutine log_warning(message, file, line)

    character(*), intent(in) :: message
    character(*), intent(in), optional :: file
    integer, intent(in), optional :: line

    if (present(file) .and. present(line)) then
      write(6, *) '[Warning]: ' // trim(file) // ':' // trim(to_string(line)) // ': ' // trim(message)
    else
      write(6, *) '[Warning]: ' // trim(message)
    end if

  end subroutine log_warning

  subroutine log_error(message, file, line)

    character(*), intent(in) :: message
    character(*), intent(in), optional :: file
    integer, intent(in), optional :: line

    if (present(file) .and. present(line)) then
      write(6, *) '[Error]: ' // trim(file) // ':' // trim(to_string(line)) // ': ' // trim(message)
    else
      write(6, *) '[Error]: ' // trim(message)
    end if
    stop 1

  end subroutine log_error

end module log_mod
