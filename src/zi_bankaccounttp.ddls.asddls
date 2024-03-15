@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forBankAccount'
define root view entity ZI_BankAccountTP
  provider contract transactional_interface
  as projection on ZR_BankAccountTP as BankAccount
{
  key AccountID,
  Balance,
  Currency,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
