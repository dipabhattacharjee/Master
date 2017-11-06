/**
 * @author: Vishnu Belkone
 * @Description: This class implament the StatelessBatchExecutor to update price book.
 * @Test Class:    PriceBookUpdater_Test
 * @History: 
	15/09/2015 created.
 */
public class PriceBookUpdater implements StatelessBatchExecutor.CustomBatchable{
    public void execute(List<Pricebook2> scope){    
        updatePriceBooks(scope);
    }
    
    public void finish(){}

	/**
	 * @author: Vishnu Belkone
	 * @Description: Method to update pricebooks Active Inactive.
	 * @Param : PriceBook List to update.	 
	 * @History: 
		15/09/2015 created.
	 */
    public Integer updatePriceBooks(List<Pricebook2> priceBookList){
       try{
           for(Pricebook2 priceBook : priceBookList){
                if(priceBook.End_Date__c != null){
                    if(priceBook.Start_Date__c <= System.today() && priceBook.End_Date__c  >= System.today()){
                        priceBook.IsActive = True;
                    }else{
                        priceBook.IsActive = False;
                    }
                }
            }
            update priceBookList;
			return priceBookList.size();
       }catch(Exception ex){
           System.debug('Exception -' +ex);
		   return null;
       }       
        
    }
}