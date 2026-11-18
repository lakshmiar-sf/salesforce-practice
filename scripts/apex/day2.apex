Integer count= 5;
System.debug('count is : '+count);
Decimal amount = 1500.00;
Double rate = 0.035;
String status = 'Pending';
Boolean isPaid = false;
Date today = Date.today();
Integer x;
System.debug('x is : '+x);

List<Payment_Order__c> orders = [
    SELECT Id, Status__c, Amount__c, Currency__c, Account__c
    FROM Payment_Order__c
];

//Group by status:

Map<String,List<Payment_Order__c>> ordersByStatus = new Map<String,List<Payment_Order__c>>() ;


for(Payment_Order__c orderRecord:orders)
{
    String status = orderRecord.Status__c;
    if(!ordersByStatus.containsKey(status))
    {        
        ordersByStatus.put(status,new List<Payment_Order__c>());        
    }
    ordersByStatus.get(status).add(orderRecord);
    
}
for(String statusVal: ordersByStatus.keySet())
{
    System.debug('status is : '+statusVal+' Number of orders '+ ordersByStatus.get(statusVal).size());
}

//Total by currency:

Map<String,Decimal> currencyTotal = new Map<String,Decimal>() ;
for(Payment_Order__c orderRecord:orders)
{
    Decimal amount = orderRecord.Amount__c == null ? 0 : orderRecord.Amount__c;
    String currencyVal = orderRecord.Currency__c;   

    if(!currencyTotal.containsKey(currencyVal))
    {        
        currencyTotal.put(currencyVal,0);   
            
    }   
    currencyTotal.put(currencyVal,currencyTotal.get(currencyVal)+amount);     
}
for(String currencyCode: currencyTotal.keySet())
{
    System.debug('Currency Code is : '+currencyCode+' Value '+ currencyTotal.get(currencyCode));
}

// Unique Accounts
Set<Id> uniqueAccts = new Set<Id>();
for(Payment_Order__c ord:orders){
    if(ord.Account__c !=null)
    {
        uniqueAccts.add(ord.Account__c);
    }
}

System.debug('size is ' + uniqueAccts.size());

//Map by ID
Map<Id,Payment_order__c> mapByIds = new Map<Id,Payment_order__c>(orders);
Set<Id> orderSet = mapByIds.keySet();
Id firstOrderId = orderSet.iterator().next();

System.debug('Amount of first order ' + mapByIds.get(firstOrderId).Amount__c);

//Switch
for(Payment_Order__c orderRecord:orders){
    switch on orderRecord.Status__c {
    when 'Pending' { System.debug('Awaiting authorisation'); }
    when 'Authorised' { System.debug('Ready to capture'); }
    when 'Failed', 'Expired' { System.debug('Needs follow-up'); }
    when else { System.debug('Done'); }
}
}