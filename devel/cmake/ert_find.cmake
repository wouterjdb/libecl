set(NEED_LIBDL OFF)
find_library( DL_LIBRARY NAMES dl )
find_path( DLFUNC_HEADER dlfcn.h )
if (DL_LIBRARY AND DLFUNC_HEADER)
    set(CMAKE_REQUIRED_LIBRARIES dl)

    check_function_exists( dladdr HAVE_DLADDR )
    if (HAVE_DLADDR)
       add_definitions( -DHAVE_DLADDR )                       
       set(NEED_LIBDL ON)
    endif()
endif()
#-----------------------------------------------------------------
find_library( ZLIB_LIBRARY NAMES z )
find_path( ZLIB_HEADER zlib.h /usr/include )

if (ZLIB_LIBRARY AND ZLIB_HEADER)
   option(WITH_ZLIB "Include support for zlib functions compress()/uncompress()" ON)
   if (WITH_ZLIB)
      add_definitions( -DWITH_ZLIB )
   endif()
else()
   set( WITH_ZLIB FALSE )
   message("ZLib not found - zlib support will not be included." )       
endif()
#-----------------------------------------------------------------
find_library( PTHREAD_LIBRARY NAMES pthread )
if (PTHREAD_LIBRARY)
   option( WITH_PTHREAD "Include support for pthreads" ON )
   if (WITH_PTHREAD)
     add_definitions( -DWITH_PTHREAD )
   endif()
else()
   set( WITH_PTHREAD FALSE )
   message("pthread library not found - pthread support will not be included")
endif()
#-----------------------------------------------------------------
find_library( LAPACK_LIBRARY NAMES lapack)
if (LAPACK_LIBRARY)
   set(CMAKE_REQUIRED_LIBS LAPACK_LIBRARY)
   try_compile( BLAS0 ${CMAKE_BINARY_DIR} ${PROJECT_SOURCE_DIR}/cmake/Tests/test_blas.c )
   if (BLAS0)
      set(NEED_BLAS OFF)    
   else()
      set(NEED_BLAS ON)
      find_library( BLAS_LIBRARY NAMES blas)
   endif()
   option(WITH_LAPACK "Build LAPACK enabled code" ON)
   if (WITH_LAPACK)
      add_definitions( -DWITH_LAPACK )
   endif()
else()
   set( WITH_LAPACK OFF)     
   message("LAPACK library not found - LAPACK support will not be included")
endif()
#-----------------------------------------------------------------
find_program(LATEX_PATH NAMES pdflatex)
if (LATEX_PATH)
   option( WITH_LATEX "Build small class for compiling LaTeX files" ON)
   if (WITH_LATEX)
      set( WITH_LATEX ON)
      add_definitions( -DWITH_LATEX )
   endif()
else()
   set( WITH_LATEX OFF )
endif()
#-----------------------------------------------------------------f
find_program(PING_PATH NAMES ping)
#-----------------------------------------------------------------
find_path( EXECINFO_HEADER execinfo.h /usr/include )
if (EXECINFO_HEADER)
  add_definitions( -DHAVE_EXECINFO )
endif()
#-----------------------------------------------------------------
find_path( GETOPT_HEADER getopt.h /usr/include )
if (GETOPT_HEADER)
   add_definitions( -DHAVE_GETOPT )
endif()
#-----------------------------------------------------------------
find_path( UNISTD_HEADER unistd.h /usr/include )
if (UNISTD_HEADER)
   add_definitions( -DHAVE_UNISTD )
endif()

if (ERT_WINDOWS)
   find_library( SHLWAPI_LIBRARY NAMES Shlwapi )
endif()
