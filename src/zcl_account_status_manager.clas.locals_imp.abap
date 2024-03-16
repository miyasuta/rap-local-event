CLASS lcl_abap_behv_event_handler DEFINITION INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.
    METHODS update_rank_with_balance FOR ENTITY EVENT eventparam FOR BankAccount~balanceChanged.

ENDCLASS.

CLASS lcl_abap_behv_event_handler IMPLEMENTATION.

  METHOD update_rank_with_balance.
    DATA rank TYPE zaccountrank.
    DATA rank_table TYPE STANDARD TABLE OF zaccountrank.

    "enter save phase
    cl_abap_tx=>save( ).

    CHECK eventparam IS NOT INITIAL.

    "Get balance
    SELECT accountid, balanceinjpy
    FROM ZI_BankAccount
    FOR ALL ENTRIES IN @eventparam
    WHERE AccountID = @eventparam-AccountID
    INTO TABLE @DATA(accounts).

    "Check balance
    LOOP AT accounts INTO DATA(account).
      rank = VALUE #(
               accountid = account-Accountid
               rank = COND #( WHEN account-BalanceInJpy < 100 THEN 'A'
                       WHEN account-BalanceInJpy < 1000 THEN 'B'
                       ELSE 'C' )
               last_changed_by = cl_abap_context_info=>get_user_technical_name( ) ).
      GET TIME STAMP FIELD rank-last_changed_at.
      APPEND rank TO rank_table.
    ENDLOOP.

    "Update Rank
    MODIFY zaccountrank FROM TABLE @rank_table.

*    DATA lo_operation TYPE REF TO if_bgmc_op_single.
*    DATA lo_process TYPE REF TO if_bgmc_process_single_op.
*    DATA lo_process_monitor TYPE REF TO if_bgmc_process_monitor.
*    lo_operation = NEW zcl_account_status_bgpf( eventparam ).
*
*    TRY.
*        lo_process = cl_bgmc_process_factory=>get_default(  )->create(  ).
*        lo_process->set_name( 'Invoke Account Status Manager'
*                             )->set_operation( lo_operation ).
*        lo_process_monitor = lo_process->save_for_execution( ).
*      CATCH cx_bgmc INTO DATA(lx_bgmc).
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
