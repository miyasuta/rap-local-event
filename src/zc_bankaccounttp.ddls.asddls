@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forBankAccount'
@ObjectModel.semanticKey: [ 'AccountID' ]
@Search.searchable: true
define root view entity ZC_BankAccountTP
  provider contract transactional_query
  as projection on ZR_BankAccountTP as BankAccount
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key AccountID,
  @Semantics.amount.currencyCode: 'Currency'
  Balance,
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }, 
    useForValidation: true
  } ]
  @EndUserText.label: 'Currency'
  Currency,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
