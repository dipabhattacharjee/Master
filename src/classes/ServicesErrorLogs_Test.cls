@isTest
public class ServicesErrorLogs_Test {
	 public static testMethod void testServiceLogs(){
		ServicesErrorLogs logs= new ServicesErrorLogs();
		HttpResponse response = new HttpResponse();		

		logs.generateErrorlogs(response,'idvdsovsdnv','testObject','Custom');
	 }
}