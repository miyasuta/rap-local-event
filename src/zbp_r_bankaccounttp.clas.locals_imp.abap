CLASS lsc_zr_bankaccounttp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_bankaccounttp IMPLEMENTATION.

  METHOD adjust_numbers.
    LOOP AT mapped-bankaccount ASSIGNING FIELD-SYMBOL(<bankaccount>).
      CHECK <bankaccount>-AccountID IS INITIAL.
      DATA(lo_get_number) = cl_numberrange_buffer=>get_instance( ).
*      lo_get_number->if_numberrange_buffer~number_get_main_memory(
*        EXPORTING
*          iv_object            = 'ZBKACCOUNT'
*          iv_interval          = '01'
*        IMPORTING
*          ev_number            = DATA(lv_number)
*      ).
       lo_get_number->if_numberrange_buffer~number_get_no_buffer(
         EXPORTING
          iv_object            = 'ZBKACCOUNT'
          iv_interval          = '01'
           iv_quantity          = 1
         IMPORTING
           ev_number            = DATA(lv_number) ).
*       CATCH cx_number_ranges.
      <bankaccount>-AccountID = lv_number.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_modified.
    loop at update-bankaccount into data(bankaccount).
      if bankaccount-%control-Balance = if_abap_behv=>mk-on.
        raise ENTITY EVENT ZR_BankAccountTP~balanceChanged
          from value #( ( %key = bankaccount-%key ) ).
      endif.
    endloop.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_bankaccount DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR BankAccount
        RESULT result,
      deposit FOR MODIFY
        IMPORTING keys FOR ACTION BankAccount~deposit RESULT result.

    METHODS withdraw FOR MODIFY
      IMPORTING keys FOR ACTION BankAccount~withdraw RESULT result.
ENDCLASS.

CLASS lhc_bankaccount IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD deposit.
    READ ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
      ENTITY BankAccount
      FIELDS ( Balance Currency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(accounts).

    MODIFY ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
      ENTITY BankAccount
      UPDATE FIELDS ( Balance )
      WITH VALUE #( FOR key IN keys (
        %tky = key-%tky
        balance = accounts[ %tky = key-%tky ]-balance + key-%param-amount
      ) ).

    READ ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
      ENTITY BankAccount
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(accounts_updated).

    result = VALUE #( FOR account_upd IN accounts_updated (
                        %tky = account_upd-%tky
                        %param = account_upd  ) ).
  ENDMETHOD.

  METHOD withdraw.
    DATA balance_upd TYPE TABLE FOR UPDATE ZR_BankAccountTP.

    READ ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
      ENTITY BankAccount
      FIELDS ( Balance Currency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(accounts).

    "check if there is enough balance
    LOOP AT keys INTO DATA(key).
      IF accounts[ %tky = key-%tky ]-balance < key-%param-amount.
        APPEND VALUE #( %tky = key-%tky ) TO failed-bankaccount.
        APPEND VALUE #( %tky = key-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'The account balance is insufficient'
                               ) ) TO reported-bankaccount.
        CONTINUE.
      ENDIF.
      APPEND VALUE #( %tky = key-%tky
                      balance = accounts[ %tky = key-%tky ]-balance - key-%param-amount ) TO balance_upd.

    ENDLOOP.

    IF balance_upd IS NOT INITIAL.
      MODIFY ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
        ENTITY BankAccount
        UPDATE FIELDS ( Balance )
        WITH balance_upd.
    ENDIF.

    READ ENTITIES OF ZR_BankAccountTP IN LOCAL MODE
      ENTITY BankAccount
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(accounts_updated).

    result = VALUE #( FOR account_upd IN accounts_updated (
                        %tky = account_upd-%tky
                        %param = account_upd  ) ).

  ENDMETHOD.

ENDCLASS.
