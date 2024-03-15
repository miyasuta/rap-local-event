CLASS zcl_account_status_bgpf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .

    METHODS constructor
      IMPORTING i_eventparam TYPE zcl_account_status_manager=>tt_balancechanged_param.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA m_eventparam TYPE zcl_account_status_manager=>tt_balancechanged_param.
ENDCLASS.



CLASS zcl_account_status_bgpf IMPLEMENTATION.
  METHOD constructor.
    m_eventparam = i_eventparam.

  ENDMETHOD.

  METHOD if_bgmc_op_single~execute.
    DATA rank TYPE zaccountrank.
    DATA rank_table TYPE STANDARD TABLE OF zaccountrank.

    "TODO: アプリケーションログを仕込む

    cl_abap_tx=>save( ).

    CHECK m_eventparam IS NOT INITIAL.

    "Get balance
    SELECT accountid, balanceinjpy
    FROM ZI_BankAccount
    FOR ALL ENTRIES IN @m_eventparam
    WHERE AccountID = @m_eventparam-AccountID
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
