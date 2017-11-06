/**
* @author vishnu belkone
* @description this class is to post big deal alert on chatter group. 
* @TestClass : OppBigDealAlertOnChatter_Test
*/
public class OppBigDealAlertOnChatter {
 /*   public void postBigDealAlert(List<Opportunity> oppList , Map<Id,Opportunity> oppOldMap){
        List<FeedItem> feedItemList = new List<FeedItem>();
        FeedItem post;
        List<Opportunity>oppListToUpdate = getOpptyVsProducts(oppList);
        for (Opportunity opp : oppListToUpdate)
        {
        System.debug('Test the code' + opp.StageName +'test - ' + opp.Amount + 'currencyCode - '+opp.CurrencyIsoCode+ 'opp.School_Site_Country__c ' + opp.School_Site_Country__c);
            if (opp.StageName != oppOldMap.get(opp.Id).StageName && opp.StageName == 'Negotiation')
            {
                if ((opp.CurrencyIsoCode == 'NZD' && opp.Amount > 8000) || (opp.CurrencyIsoCode == 'AUD' && opp.Amount > 25000) || 
                    (opp.CurrencyIsoCode == 'ZAR' && opp.Amount > 150000) || (opp.CurrencyIsoCode == 'CAD' && opp.Amount > 15000) ||
                    (opp.CurrencyIsoCode == 'GBP' && opp.Amount > 7000) || (opp.CurrencyIsoCode == 'EUR' && opp.Amount > 14000) ||
                    (opp.CurrencyIsoCode == 'USD' && opp.Amount > 15000 && opp.School_Site_Country__c == 'United States') || 
                    (opp.CurrencyIsoCode == 'USD' && opp.Amount > 20000 && opp.School_Site_Country__c != 'United States'))
                { 
                    post  = new FeedItem();
                    post.parentId = '0F928000000LZ5C';
                    post.Body  = 'The following Opportunity '+opp.Name+' is currently at Stage '+ opp.StageName + '\n' +
                    'Close Date : '+opp.closeDate+'\n'+
                    'Amount : '+ opp.Amount +' '+ opp.CurrencyIsoCode+'\n'+
                    'the Owner is' +opp.Owner.FirstName+' '+opp.Owner.LastName+'\n'+
                     'please click following link ' + opp.Record_Link__c + '\n'+ 'for more information';
                    
                    //insert post;
                    feedItemList.add(post);
                }
            }
            if (feedItemList != null && feedItemList.size() > 0)
            {
                insert feedItemList;
            }
        }
    }

    //fetch opportunity vs product  list 
    public List<Opportunity> getOpptyVsProducts(List<Opportunity> oppList){
        List<Opportunity> oppListToClone = [select Id,name,Record_Link__c,Owner.FirstName,Owner.LastName,CurrencyIsoCode,account.name,Amount,CloseDate,Owner.name,StageName,School_Site_Country__c,account.OwnerId from Opportunity Where Id In :oppList];
        System.debug('Hi this is to test the data ' + oppListToClone);
        return oppListToClone;
    } */

}