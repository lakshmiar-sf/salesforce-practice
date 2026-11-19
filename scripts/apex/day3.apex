List<Payment_Order__c> orders = [
    SELECT Id, Name, Status__c, Amount__c, Currency__c, Account__c
    FROM Payment_Order__c
];
PaymentOrderService.PaymentSummary s = PaymentOrderService.buildSummary(orders);
System.debug('Orders: ' + s.orderCount + ', total: ' + s.totalAmount);
PaymentOrderService.groupByStatus(orders);
PaymentOrderService.groupByStatus(orders);
System.debug('callCount: ' + PaymentOrderService.callCount);

Map<String,List<Payment_Order__c>> ordersByStatus = PaymentOrderService.groupByStatus(orders);
for(String statusVal: ordersByStatus.keySet())
{
    System.debug('status is : '+statusVal+' Number of orders '+ ordersByStatus.get(statusVal).size());
}

Map<String,Decimal> currencyTotal = PaymentOrderService.totalsByCurrency(orders);
for(String currencyCode: currencyTotal.keySet())
{
    System.debug('Currency Code is : '+currencyCode+' Value '+ currencyTotal.get(currencyCode));
}

Set<Id> uniqueAccts = PaymentOrderService.getAccountIds(orders);
System.debug('size is ' + uniqueAccts.size());

for (Payment_Order__c order : orders) {
    System.debug(order.Name + ': ' + PaymentOrderService.getStatusMessage(order.Status__c));
}