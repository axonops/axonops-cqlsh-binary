AC_PREREQ([2.69])
AC_INIT([cqlsh], [1.0], [support@axonops.com])
AC_CONFIG_SRCDIR([cqlsh.py])
AC_PROG_CC

AC_ARG_ENABLE([debug],
  AS_HELP_STRING([--enable-debug],
    [Enable verbose debugging output during configuration]),
  [debug_enabled=$enableval],
  [debug_enabled=no]
)

AS_IF([test "x$debug_enabled" = "xyes"], [
  AC_DEFINE([CONFIG_DEBUG], [1], [Enable debug mode])
  AC_MSG_WARN([Debug mode enabled. Expect verbose output.])
  # Add debug-specific checks here
])

# Libev path customization
AC_ARG_WITH([libev],
  AS_HELP_STRING([--with-libev=DIR],
    [Specify libev installation prefix (default: /usr/local)]),
  [libev_prefix=$withval],
  [libev_prefix=/usr/local]  # Default Homebrew path
)

# Add Homebrew-specific paths as fallback
libev_include_paths="$libev_prefix/include /usr/include /usr/local/include /opt/homebrew/include $HOME/homebrew/Cellar/libev/4.33/include"
libev_lib_paths="$libev_prefix/lib /usr/lib /usr/lib64 /usr/local/lib /opt/homebrew/lib $HOME/homebrew/Cellar/libev/4.33/lib /usr/lib/`uname -m`-linux-gnu"

# Locate python3
AC_PATH_PROG([PYTHON], [python3], [no])
AS_IF([test "$PYTHON" = "no"], [AC_MSG_ERROR([Python 3 not found in PATH])])

# Add --with-python-config option
AC_ARG_WITH([python-config],
  AS_HELP_STRING([--with-python-config=PATH],
    [Specify the path to python3-config (default: auto-detect)]),
  [
    # User specified a path
    if test "x$withval" != "xyes" && test "x$withval" != "xno"; then
      python_config_path="$withval"
      AC_MSG_CHECKING([for specified python-config at $python_config_path])
      if test -x "$python_config_path"; then
        PYTHON_CONFIG="$python_config_path"
        AC_MSG_RESULT([yes])
      else
        AC_MSG_RESULT([no])
        AC_MSG_ERROR([Specified python-config at $python_config_path not found or not executable])
      fi
    else
      # Just --with-python-config with no path, fall through to auto-detection
      python_config_path=""
    fi
  ],
  [
    # No option specified, try auto-detection
    python_config_path=""
  ]
)

# If no specific path was provided, try to find python3-config in PATH
if test "x$PYTHON_CONFIG" = "x"; then
  AC_PATH_PROGS([PYTHON_CONFIG], [python3-config python3.11-config python3.10-config python3.9-config], [no])
  if test "x$PYTHON_CONFIG" = "xno"; then
    AC_MSG_ERROR([Cannot find python3-config. Please install Python development files or specify path with --with-python-config])
  fi
fi


# Check for Python include path
AC_MSG_CHECKING([Python include path])
PYTHON_INCLUDE=`$PYTHON_CONFIG --includes 2>/dev/null`
AS_IF([test -z "$PYTHON_INCLUDE"], [
  AC_MSG_ERROR([Python headers missing. Install python3-dev or ensure python3.11-config is correct.])
])
AC_SUBST([PYTHON_INCLUDE])

# Check for Python library
AC_MSG_CHECKING([Python library path])
PYTHON_LIB=`$PYTHON_CONFIG --ldflags 2>/dev/null`
AS_IF([test -z "$PYTHON_LIB"], [
  AC_MSG_ERROR([Python library missing. Install python3-dev or ensure python3.11-config is correct.])
])
AC_SUBST([PYTHON_LIB])

# Add Python library paths to LDFLAGS
LDFLAGS="$LDFLAGS $PYTHON_LIB"
CPPFLAGS="$CPPFLAGS $PYTHON_INCLUDE -I/usr/local/include"

# Check for Python.h
AC_CHECK_HEADER([Python.h], [], [AC_MSG_ERROR([Python headers missing. Install python3-dev.])])

# Add --with-gettext option
AC_ARG_WITH([gettext],
  AS_HELP_STRING([--with-gettext=DIR],
    [Specify gettext installation prefix (default: /usr/local)]),
  [gettext_prefix=$withval],
  [gettext_prefix=/usr/local]  # Default Homebrew path
)

# Add gettext paths
gettext_include_paths="$gettext_prefix/include /usr/include /usr/local/include /opt/homebrew/include $HOME/homebrew/include"
gettext_lib_paths="$gettext_prefix/lib /usr/lib /usr/lib64 /usr/local/lib /opt/homebrew/lib $HOME/homebrew/lib"

# Check for gettext headers
AC_MSG_CHECKING([for gettext headers])
gettext_include_found=""
for path in $gettext_include_paths; do
  if test -f "$path/libintl.h"; then
    gettext_include_found="$path"
    AC_MSG_RESULT([found in $path])
    break
  fi
done
AS_IF([test -z "$gettext_include_found"], 
  [AC_MSG_ERROR([gettext headers (libintl.h) not found in $gettext_include_paths])])
AC_SUBST([GETTEXT_INCLUDE], ["$gettext_include_found"])

# Check for gettext library
AC_MSG_CHECKING([for gettext library])
gettext_lib_found=""
for path in $gettext_lib_paths; do
  if test -f "$path/libintl.a" || test -f "$path/libintl.dylib" || test -f "$path/libintl.so" || test -f "$path/libintl.dll.a"; then
    gettext_lib_found="$path"
    AC_MSG_RESULT([found in $path])
    break
  fi
done
#AS_IF([test -z "$gettext_lib_found"], 
#  [AC_MSG_ERROR([gettext library not found in $gettext_lib_paths])])
AC_SUBST([GETTEXT_LIB], ["$gettext_lib_found"])

# Search for headers and store found path
AC_MSG_CHECKING([for ev.h])
libev_include_found=""
for path in $libev_include_paths; do
  if test -f "$path/ev.h"; then
    libev_include_found="$path"
    AC_MSG_RESULT([found in $path])
    break
  fi
done
AS_IF([test -z "$libev_include_found"], 
  [AC_MSG_ERROR([ev.h not found in $libev_include_paths])])
AC_SUBST([LIBEV_INCLUDE], ["$libev_include_found"])

# Search for library and store found path
AC_MSG_CHECKING([for libev library])
libev_lib_found=""
for path in $libev_lib_paths; do
  if test -f "$path/libev.a" || test -f "$path/libev.dylib" || test -f "$path/libev.so" || test -f "$path/libev.dll.a"; then
    libev_lib_found="$path"
    AC_MSG_RESULT([found in $path])
    break
  fi
done
AS_IF([test -z "$libev_lib_found"], 
  [AC_MSG_ERROR([libev library not found in $libev_lib_paths])])
AC_SUBST([LIBEV_LIB], ["$libev_lib_found"])

AC_SUBST([OUTPUT], [axonops-cqlsh])  # Default value

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
