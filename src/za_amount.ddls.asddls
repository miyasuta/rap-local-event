@EndUserText.label: 'Amount'
define abstract entity ZA_AMOUNT
{
    @EndUserText.label: 'Amount'
    @Semantics.amount.currencyCode: 'currency'
    amount: abap.curr( 13, 2 );
    @EndUserText.label: 'Currency'
    @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Currency')
    currency: abap.cuky( 5 );
    
}
