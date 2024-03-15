CLASS zcl_account_status_manager DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  FOR EVENTS OF ZR_BankAccountTP.

  PUBLIC SECTION.
    TYPES tt_balanceChanged_param TYPE TABLE FOR EVENT ZR_BankAccountTP\\BankAccount~balanceChanged.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_account_status_manager IMPLEMENTATION.
ENDCLASS.
