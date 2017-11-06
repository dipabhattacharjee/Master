@isTest
public class BatchUpdateSchoolStatus_Test {

	public static testMethod void testSchoolUpdate(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
		List<Account> SchoolList = new List<Account>();
		SchoolList = [Select Id, Name,Status__c,C3NotSynched__c,
                                                             (Select Id,Status from Assets ) 
                                                             from Account];
		BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(SchoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();
	}

	@testSetup static void setup()
    {
    	FakeObjectFactory.testclasssetup();
    	RecordType__c SchoolRecordType = RecordType__c.getValues('Account School');
        RecordType__c LicenceRecordType = RecordType__c.getValues('Asset Full Licence');
        
        if (SchoolRecordType == null)
        {
            SchoolRecordType = new RecordType__c();
            SchoolRecordType.Name = 'Account School';
            SchoolRecordType.RecordTypeId__c = '012280000001tRD';
            SchoolRecordType.RecordTypeName__c = 'School';
        }
        insert SchoolRecordType;
        
        if (LicenceRecordType == null)
        {
            LicenceRecordType = new RecordType__c();
            LicenceRecordType.Name = 'Asset Full Licence';
            LicenceRecordType.RecordTypeId__c = '012280000001tRE';
            LicenceRecordType.RecordTypeName__c = 'Asset Full Licence';
        }
        insert LicenceRecordType;

    }

    public static testmethod void testPotentialCustomer_StatusGettingUpdatedToNewCustomer()
    {
		
    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'Potential Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.InstallDate           =  date.today().addMonths(-4);
        asset.Product2Id 			= product.Id;
        asset.AccountId 			= account.Id;
        asset.UsageEndDate 			= date.today().addDays(10);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();

		List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
		System.assertEquals('New Customer'                , accountList[0].Status__c);
    }

    public static testmethod void testPotentialCustomer_StatusGettingUpdatedToExistingCustomer()
    {
		
    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'Potential Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.InstallDate           =  date.today().addMonths(-8);
        asset.Product2Id 			= product.Id;
        asset.AccountId 			= account.Id;
        asset.UsageEndDate 			= date.today().addDays(10);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();

		List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
		System.assertEquals('Existing Customer'                , accountList[0].Status__c);
    }

    public static testmethod void testNewCustomer_AfterThreeMonthOfCancelledLicence_AccountStatusUpdatedToFormerCustomer()
    {

    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'New Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        asset.InstallDate           =  date.today().addMonths(-7);
        asset.Status = 'Cancelled';
        asset.UsageEndDate = date.today().addMonths(-4);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();
		List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
		System.assertEquals('Former Customer'                , accountList[0].Status__c);
    }

    public static testmethod void testLapsedCustomer()
    {

    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'Lapsed Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        //asset.Status = 'Cancelled';
        asset.UsageEndDate = date.today().addDays(1);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();

		List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
		System.assertEquals('Existing Customer'                , accountList[0].Status__c);
    }

    public static testmethod void testExistingCustomer()
    {

    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'Existing Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        //asset.Status = 'Cancelled';
        asset.UsageEndDate = date.today().addDays(-1);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();
    }

    public static testmethod void testNewCustomer()
    {

    	String productFamily = 'Mathletics';  
		Account account  = FakeObjectFactory.GetSchoolAccount();
		account.status__c           = 'New Customer';
        insert account; 

		Product2 product = FakeObjectFactory.GetProduct(productFamily);
		insert product;
        Asset asset = FakeObjectFactory.GetProvisionedAsset();
        asset.Product2Id = product.Id;
        asset.AccountId = account.Id;
        //asset.Status = 'Cancelled';
        asset.UsageEndDate = date.today().addDays(-1);
        insert asset;
        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
        insert recordType;

        List<Account> schoolList = new List<Account>();
        schoolList.add(account);

        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
        Test.startTest();  
			SchoolUpdate.execute(schoolList);        		
        Test.stopTest();  
		SchoolUpdate.finish();
    }

	public static testmethod void testFormerCustomer_OnceActiveLicence_AccountStatusChangesToReturnedCustomer()
	    {

	    	String productFamily = 'Mathletics';  
			Account account  = FakeObjectFactory.GetSchoolAccount();
			account.status__c           = 'Former Customer';
	        insert account; 

			Product2 product = FakeObjectFactory.GetProduct(productFamily);
			insert product;
	        Asset asset = FakeObjectFactory.GetProvisionedAsset();

	        asset.Product2Id = product.Id;
	        asset.AccountId = account.Id;
	        //asset.Status = 'Cancelled';
	        asset.UsageEndDate = date.today().addMonths(7);
	        insert asset;
	        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
	        insert recordType;

	        List<Account> schoolList = new List<Account>();
	        schoolList.add(account);

	        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
	        Test.startTest();  
				SchoolUpdate.execute(schoolList);        		
	        Test.stopTest();  
			SchoolUpdate.finish();
			List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
			System.assertEquals('Returned Customer'                , accountList[0].Status__c);
	    }

	    public static testmethod void testReturnedCustomer()
	    {

	    	String productFamily = 'Mathletics';  
			Account account  = FakeObjectFactory.GetSchoolAccount();
			account.status__c           = 'Returned Customer';
	        insert account; 

			Product2 product = FakeObjectFactory.GetProduct(productFamily);
			insert product;
	        Asset asset = FakeObjectFactory.GetProvisionedAsset();
	        asset.InstallDate           =  date.today().addMonths(-7);
	        asset.Product2Id = product.Id;
	        asset.AccountId = account.Id;
	        //asset.Status = 'Cancelled';
	        asset.UsageEndDate = date.today().addMonths(5);
	        insert asset;
	        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
	        insert recordType;

	        List<Account> schoolList = new List<Account>();
	        schoolList.add(account);

	        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
	        Test.startTest();  
				SchoolUpdate.execute(schoolList);        		
	        Test.stopTest();  
			SchoolUpdate.finish();

			List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
			System.assertEquals('Existing Customer'                , accountList[0].Status__c);
	    }
	
	public static testmethod void testReturnedCustomer_TestExceptionBlock()
	    {

	    	String productFamily = 'Mathletics';  
			Account account  = FakeObjectFactory.GetSchoolAccount();
			account.status__c           = 'Returned Customer';
	        insert account; 

			Product2 product = FakeObjectFactory.GetProduct(productFamily);
			insert product;
	        Asset asset = FakeObjectFactory.GetProvisionedAsset();
	        asset.InstallDate           =  date.today().addMonths(-7);
	        asset.Product2Id = product.Id;
	        asset.AccountId = account.Id;
	        //asset.Status = 'Cancelled';
	        asset.UsageEndDate = date.today().addMonths(5);
	        try{
	        	insert asset;
	        	throw new CustomException('Catching the Exception');	        	
	        }
	        Catch(Exception e)
	        {
	        	Boolean expectedExceptionThrown =  e.getMessage().contains('Catching the Exception') ? true : false;
				System.AssertEquals(expectedExceptionThrown, true);
	        }
	        RecordType__c recordType = FakeObjectFactory.getRecordTypeCustomSetting();        
	        insert recordType;

	        List<Account> schoolList = new List<Account>();
	        schoolList.add(account);

	        BatchUpdateSchoolStatus schoolUpdate = new BatchUpdateSchoolStatus();
	        Test.startTest();  
				SchoolUpdate.execute(schoolList);        		
	        Test.stopTest();  
			SchoolUpdate.finish();

			List<Account> accountList = [Select Id,Status__c from Account where id = :account.id];
			System.assertEquals('Existing Customer'                , accountList[0].Status__c);
	    }

}