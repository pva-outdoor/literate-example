AC_PREREQ([2.71])
AC_INIT(test-lua, 0.1, pva-outdoor@yandex.ru)
AC_CONFIG_MACRO_DIRS([m4])
AC_CONFIG_SRCDIR([lua/pprint.org])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])

# Checks for programs.
AC_CHECK_PROGS(PROGS, [emacs])
AC_PROG_CC
AM_PROG_AR
PKG_PROG_PKG_CONFIG
LT_INIT

# Checks for libraries.

# Checks for header files.
PKG_CHECK_VAR(LUA_CMOD, lua, INSTALL_CMOD)
PKG_CHECK_VAR(LUA_LMOD, lua, INSTALL_LMOD)

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile lua/Makefile])
AC_OUTPUT
