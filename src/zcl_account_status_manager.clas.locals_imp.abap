CLASS lcl_abap_behv_event_handler DEFINITION INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.
    METHODS update_rank_with_balance FOR ENTITY EVENT eventparam FOR BankAccount~balanceChanged.

ENDCLASS.

CLASS lcl_abap_behv_event_handler IMPLEMENTATION.

  METHOD update_rank_with_balance.
    DATA lo_operation TYPE REF TO if_bgmc_op_single.
    DATA lo_process TYPE REF TO if_bgmc_process_single_op.
    DATA lo_process_monitor TYPE REF TO if_bgmc_process_monitor.

    "trigger bgPF
    lo_operation = NEW zcl_account_status_bgpf( eventparam ).

    TRY.
        lo_process = cl_bgmc_process_factory=>get_default(  )->create(  ).
        lo_process->set_name( 'Invoke Account Status Manager'
                             )->set_operation( lo_operation ).
        lo_process_monitor = lo_process->save_for_execution( ).
      CATCH cx_bgmc INTO DATA(lx_bgmc).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
