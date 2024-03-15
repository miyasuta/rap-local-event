CLASS zcl_nr_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_nr_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(lo_get_number) = cl_numberrange_buffer=>get_instance( ).
    try.
*    lo_get_number->if_numberrange_buffer~number_get_main_memory(
*      EXPORTING
*        iv_object            = 'ZBKACCOUNT'
*        iv_interval          = '01'
*      IMPORTING
*        ev_number            = DATA(lv_number)
*    ).
       lo_get_number->if_numberrange_buffer~number_get_no_buffer(
         EXPORTING
          iv_object            = 'ZBKACCOUNT'
          iv_interval          = '01'
           iv_quantity          = 1
         IMPORTING
           ev_number            = DATA(lv_number) ).
      out->write( lv_number ).
    catch CX_NUMBER_RANGES into data(lx_number_ranges).
      out->write( lx_number_ranges->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
