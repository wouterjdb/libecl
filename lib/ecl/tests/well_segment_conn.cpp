/*
   Copyright (C) 2013  Statoil ASA, Norway.

   The file 'well_segment_conn.c' is part of ERT - Ensemble based Reservoir Tool.

   ERT is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   ERT is distributed in the hope that it will be useful, but WITHOUT ANY
   WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.

   See the GNU General Public License at <http://www.gnu.org/licenses/gpl.html>
   for more details.
*/
#include <stdlib.h>
#include <stdbool.h>

#include <ert/util/test_util.hpp>
#include <ert/util/stringlist.hpp>
#include <ert/util/util.h>

#include <ert/ecl/ecl_util.hpp>
#include <ert/ecl/ecl_grid.hpp>

#include <ert/ecl_well/well_const.hpp>
#include <ert/ecl_well/well_segment.hpp>
#include <ert/ecl_well/well_conn.hpp>
#include <ert/ecl_well/well_conn_collection.hpp>


int main(int argc , char ** argv) {
  test_install_SIGNALS();
  double * rseg_data = (double *) util_calloc( 100 , sizeof * rseg_data );
  {
    double CF = 88;
    int segment_id = 78;
    int outlet_segment_id = 100;
    int branch_nr = WELL_SEGMENT_BRANCH_MAIN_STEM_VALUE;
    well_segment_type * ws = well_segment_alloc(segment_id , outlet_segment_id , branch_nr, rseg_data);
    well_conn_type * conn1 = well_conn_alloc_MSW(1,1,1,CF,well_conn_dirX,true,segment_id);
    well_conn_type * conn2 = well_conn_alloc_MSW(1,1,1,CF,well_conn_dirX,true,segment_id + 1);

    test_assert_false( well_segment_has_global_grid_connections( ws ));

    test_assert_true( well_segment_add_connection( ws , ECL_GRID_GLOBAL_GRID , conn1 ));
    test_assert_false( well_segment_add_connection( ws , ECL_GRID_GLOBAL_GRID , conn2 ));

    test_assert_true( well_segment_has_grid_connections( ws , ECL_GRID_GLOBAL_GRID ));
    test_assert_true( well_segment_has_global_grid_connections( ws ));
    test_assert_false( well_segment_has_grid_connections( ws , "DoesNotExist"));

    test_assert_true( well_conn_collection_is_instance( well_segment_get_connections( ws , ECL_GRID_GLOBAL_GRID)));
    test_assert_true( well_conn_collection_is_instance( well_segment_get_global_connections( ws)));
    test_assert_NULL( well_segment_get_connections( ws , "doesNotExist"));

    well_conn_free( conn1 );
    well_conn_free( conn2 );
    well_segment_free( ws );
  }
  free( rseg_data );
  exit(0);
}
