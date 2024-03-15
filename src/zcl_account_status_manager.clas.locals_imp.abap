CLASS lcl_abap_behv_event_handler DEFINITION INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.
    METHODS update_rank_with_balance FOR ENTITY EVENT eventparam FOR BankAccount~balanceChanged.

ENDCLASS.

CLASS lcl_abap_behv_event_handler IMPLEMENTATION.

  METHOD update_rank_with_balance.
    DATA rank TYPE zaccountrank.
    DATA rank_table TYPE STANDARD TABLE OF zaccountrank.

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
               rank = COND #( WHEN account-BalanceInJpy < 10000 THEN 'A'
                       WHEN account-BalanceInJpy < 100000 THEN 'B'
                       ELSE 'C' )
               last_changed_by = cl_abap_context_info=>get_user_technical_name( ) ).
      GET TIME STAMP FIELD rank-last_changed_at.
      APPEND rank TO rank_table.
    ENDLOOP.

    "Update Rank
    MODIFY zaccountrank FROM TABLE @rank_table.

  ENDMETHOD.

ENDCLASS.
