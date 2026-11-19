public with sharing class PaymentOrderService {
    public static Integer callCount = 0;
    
    public static Map<String,List<Payment_Order__c>> groupByStatus(List<Payment_Order__c> orders)
    {
        Map<String,List<Payment_Order__c>> ordersByStatus = new Map<String,List<Payment_Order__c>>() ;
        callCount++;
        for(Payment_Order__c orderRecord:orders)
        {
            String status = orderRecord.Status__c;
            if(!ordersByStatus.containsKey(status))
            {
                ordersByStatus.put(status,new List<Payment_Order__c>());
            }
            ordersByStatus.get(status).add(orderRecord);
            
        }
        return ordersByStatus;
    }
    public static Map<String,Decimal> totalsByCurrency(List<Payment_Order__c> orders)
    {
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
        return currencyTotal;
    }
    public static Set<Id> getAccountIds(List<Payment_Order__c> orders)
    {
        Set<Id> uniqueAccts = new Set<Id>();
        for(Payment_Order__c ord:orders){
            if(ord.Account__c !=null)
            {
                uniqueAccts.add(ord.Account__c);
            }
        }
        return uniqueAccts;
    }
    public static String getStatusMessage(String status)
    {       
        switch on status {
            when 'Pending' { return 'Awaiting authorisation'; }
            when 'Authorised' { return 'Ready to capture'; }
            when 'Failed', 'Expired' { return 'Needs follow-up'; }
            when else { return 'Unknown status: ' + status; }
        }      
    }
    public class PaymentSummary {
        public Integer orderCount;
        public Decimal totalAmount;
        
        public PaymentSummary(Integer orderCount, Decimal totalAmount) {
            this.orderCount = orderCount;
            this.totalAmount = totalAmount;
        }
    }
    public static PaymentSummary buildSummary(List<Payment_Order__c> orders){
        Decimal total= 0;
        for(Payment_Order__c ord:orders){
            Decimal amount = ord.Amount__c!=null ? ord.Amount__c : 0;
            total=total+amount;
        }
        return new PaymentSummary (orders.size(),total);
    }
}