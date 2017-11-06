/*
 * *@author- Vishnu Belkone
 * *@Description - This class is to make call out.
*/
public class HTTPCallOut {
    public HttpResponse sendRequest(HttpRequest request){
           
		    HttpResponse response = new HttpResponse();
            Http http = new Http();
			response = http.send(request); 			                      
			return response;
    }
}