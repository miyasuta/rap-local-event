@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Account'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BankAccount
  as select from zbankaccount
{
  key accountid                                     as Accountid,
      @Semantics.amount.currencyCode: 'Currency'
      balance                                       as Balance,
      currency                                      as Currency,
      abap.cuky'JPY'                                as ReferenceCurrency,
      @Semantics.amount.currencyCode: 'ReferenceCurrency'
      currency_conversion( amount => balance,
       source_currency => currency,
       target_currency => abap.cuky'JPY',
       exchange_rate_date => $session.system_date ) as BalanceInJpy,
      created_by                                    as CreatedBy,
      created_at                                    as CreatedAt,
      last_changed_by                               as LastChangedBy,
      local_last_changed_at                         as LocalLastChangedAt,
      last_changed_at                               as LastChangedAt
}
