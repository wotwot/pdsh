##*****************************************************************************
## $Id$
##*****************************************************************************
#  AUTHOR:
#    Al Chu <chu11@llnl.gov>
#
#  SYNOPSIS:
#    AC_STATIC_MODULE
#
#  DESCRIPTION:
#    Output #include files for static modules.
#
#  WARNINGS:
#    This macro must be placed after AC_PROG_CC or equivalent.
##*****************************************************************************

AC_DEFUN([AC_STATIC_MODULES_INIT],
[
  rm -f modules/static_modules.h

  # always build xrcmd 
  MODULES=xrcmd      

])

AC_DEFUN([AC_ADD_STATIC_MODULE],
[
  if test "$ac_static_modules" = "yes" ; then
     MODULES="$MODULES $1"
  fi
])

AC_DEFUN([AC_STATIC_MODULES_EXIT],
[
  # check for module conflicts 

  if test "$ac_have_libgenders" = "yes" && test "$ac_have_nodeattr" = "yes"; then
     AC_MSG_ERROR([--with-genders conflicts with --with-nodeattr])
  fi

  if test "$ac_have_libgenders" = "yes" && test "$ac_have_machines" = "yes"; then
     AC_MSG_ERROR([--with-genders conflicts with --with-machines])
  fi

  if test "$ac_have_libgenders" = "yes" && test "$ac_have_sdr" = "yes"; then
     AC_MSG_ERROR([--with-genders conflicts with --with-sdr])
  fi

  if test "$ac_have_nodeattr" = "yes" && test "$ac_have_machines" = "yes"; then
     AC_MSG_ERROR([--with-nodeattr conflicts with --with-machines])
  fi

  if test "$ac_have_nodeattr" = "yes" && test "$ac_have_sdr" = "yes"; then
     AC_MSG_ERROR([--with-nodeattr conflicts with --with-sdr])
  fi

  if test "$ac_have_machines" = "yes" && test "$ac_have_sdr" = "yes"; then
     AC_MSG_ERROR([--with-machines conflicts with --with-sdr])
  fi

  if test "$ac_have_elan" = "yes" && test "$ac_have_mqsh" = "yes"; then
     AC_MSG_ERROR([--with-elan conflicts with --with-mqsh])
  fi

  # Output the static_modules.h file
  echo "/* This file is included by mod.c so    " >> modules/static_modules.h
  echo " * access to all pdsh_module structures " >> modules/static_modules.h 
  echo " * is available.                        " >> modules/static_modules.h
  echo " */                                     " >> modules/static_modules.h
  echo "                                        " >> modules/static_modules.h
  echo "#ifndef _STATIC_MODULES_H               " >> modules/static_modules.h
  echo "#define _STATic_MODULES_H               " >> modules/static_modules.h
  echo "                                        " >> modules/static_modules.h
  echo "#if HAVE_CONFIG_H                       " >> modules/static_modules.h
  echo "#  include \"config.h\"                 " >> modules/static_modules.h
  echo "#endif                                  " >> modules/static_modules.h
  echo "                                        " >> modules/static_modules.h
  echo "#if STATIC_MODULES                      " >> modules/static_modules.h 
  echo "                                        " >> modules/static_modules.h
  echo "/* module information structures */     " >> modules/static_modules.h

  for i in $MODULES
  do
     echo "extern struct pdsh_module ${i}_module;" >> modules/static_modules.h
  done

  echo "                                        " >> modules/static_modules.h
  echo "/*                                      " >> modules/static_modules.h
  echo " * Array of all pdsh_module structures  " >> modules/static_modules.h
  echo " * we are compiling                     " >> modules/static_modules.h
  echo " */                                     " >> modules/static_modules.h
  echo "struct pdsh_module *static_mods[[]] = { " >> modules/static_modules.h

  for i in $MODULES
  do
     echo "    &${i}_module," >> modules/static_modules.h
  done
     
  echo "    NULL                                " >> modules/static_modules.h
  echo "};                                      " >> modules/static_modules.h
  echo "                                        " >> modules/static_modules.h
  echo "/*                                      " >> modules/static_modules.h
  echo " * Names of all the module structures   " >> modules/static_modules.h
  echo " */                                     " >> modules/static_modules.h
  echo "char *static_mod_names[[]] = {          " >> modules/static_modules.h

  for i in $MODULES
  do
     echo "    \"${i}\"," >> modules/static_modules.h
  done

  echo "    NULL                                " >> modules/static_modules.h
  echo "};                                      " >> modules/static_modules.h
  echo "                                        " >> modules/static_modules.h
  echo "#endif /* STATIC_MODULES */             " >> modules/static_modules.h
  echo "#endif /* _STATIC_MODULES_H */          " >> modules/static_modules.h

])
