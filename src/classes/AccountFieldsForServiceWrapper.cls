/*
 * *@author- Vishnu Belkone
 * *@Description - This class returns fields for account post/put service.
*/
public class AccountFieldsForServiceWrapper {
   public Integer Id;   //924779
    public String SchoolId; //144181
    public String Name; //Brand New Test School
    public String Email;    //abc
    public String GeoCode;  //AUS
    public String CountryCode;  //AUS
    public String StateCode;    //NSW
    public cls_PostalAddress PostalAddress;
    public cls_MainAddress MainAddress;
    public boolean IsExceludeFromMailout;
    public boolean IsExceludeFromFaxout;
    public Integer AccountManagerEmployeeId;    //87
    public Integer RegionalManagerEmployeeId;   //87
    public Integer InternalManagerEmployeeId;   //0
    public String Description;  //
    public boolean IsActive;
    public String InactiveDateUtc;  //0001-01-01T00:00:00
    public boolean IsTest;
    public String Website;  //www.something.com.au
    public String Phone;    //02 9019 2800
    public String Fax;  //02 9019 2800
    public String FocusLevelId; //21
    public String MarketSectorCode; //U
    public String SchoolLowYear;    //abc
    public String SchoolHighYear;   //abc
    public String Status;   //abc
    public String GenderDescription;    //
    public boolean IsGsspSchool;
    public Integer DecileId;    //1
    public String SchoolRegisterationNumber;    //
    public String ReadingEggsCustomerId;    //
    public String ClientVat;    //
    public Integer BusinessProfileId;   //59
    public Integer SchoolTypeId;    //32
    public Integer CurrentSchoolAcademicYear;   //0
    public Integer NameDisplaySettingModelEnum; //0
    public String ExternalId;   //abc
    public Decimal NumberOfStudents; //0
    public String School_Category; // abc
    //public String VATNumber; 
    public class cls_PostalAddress {
        public String RegionName;   //Australian Capital Territory
        public String CountryCode;  //AUS
        public String Province; //abc
        public String StateCode;    //ACT
        public String PostCode; //
        public String Locality; //abc
        public Integer UkCountryModelName;  //0
        public String City; //
        public String Suburb;   //abc
        public String Street1;  //
        public String Street2;  //
        public String Street3;  //
        public String Street4;  //
    }
    public class cls_MainAddress {
        public String RegionName;   //New South Wales
        public String CountryCode;  //AUS
        public String Province; //abc
        public String StateCode;    //NSW
        public String PostCode; //2060
        public String Locality; //
        public Integer UkCountryModelName;  //0
        public String City; //North Sydney
        public String Suburb;   //
        public String Street1;  //L 18 124 Walker Street
        public String Street2;  //
        public String Street3;  //
        public String Street4;  //
    }
    /*public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }

    static testMethod void testParse() {
        String json=        '{'+
        '"Id": 924779,'+
        '"SchoolId": 144181,'+
        '"Name": "Brand New Test School",'+
        '"Email": "abc",'+
        '"GeoCode": "AUS",'+
        '"CountryCode": "AUS",'+
        '"StateCode": "NSW",'+
        '"PostalAddress": {'+
        '"RegionName": "Australian Capital Territory",'+
        '"CountryCode": "AUS",'+
        '"Province": "abc",'+
        '"StateCode": "ACT",'+
        '"PostCode": "",'+
        '"Locality": "abc",'+
        '"UkCountryModelName": 0,'+
        '"City": "",'+
        '"Suburb": "abc",'+
        '"Street1": "",'+
        '"Street2": "",'+
        '"Street3": "",'+
        '"Street4": ""'+
        '},'+
        '"MainAddress": {'+
        '"RegionName": "New South Wales",'+
        '"CountryCode": "AUS",'+
        '"Province": "abc",'+
        '"StateCode": "NSW",'+
        '"PostCode": "2060",'+
        '"Locality": "",'+
        '"UkCountryModelName": 0,'+
        '"City": "North Sydney",'+
        '"Suburb": "",'+
        '"Street1": "L 18 124 Walker Street",'+
        '"Street2": "",'+
        '"Street3": "",'+
        '"Street4": ""'+
        '},'+
        '"IsExceludeFromMailout": false,'+
        '"IsExceludeFromFaxout": false,'+
        '"AccountManagerEmployeeId": 87,'+
        '"RegionalManagerEmployeeId": 87,'+
        '"InternalManagerEmployeeId": 0,'+
        '"Description": "",'+
        '"IsActive": false,'+
        '"InactiveDateUtc": "0001-01-01T00:00:00",'+
        '"IsTest": false,'+
        '"Website": "www.something.com.au",'+
        '"Phone": "02 9019 2800",'+
        '"Fax": "02 9019 2800",'+
        '"FocusLevelId": 21,'+
        '"MarketSectorCode": "U",'+
        '"SchoolLowYear": "abc",'+
        '"SchoolHighYear": "abc",'+
        '"Status": "abc",'+
        '"GenderDescription": "",'+
        '"IsGsspSchool": false,'+
        '"DecileId": 1,'+
        '"SchoolRegisterationNumber": "",'+
        '"ReadingEggsCustomerId": "",'+
        '"ClientVat": "",'+
        '"BusinessProfileId": 59,'+
        '"SchoolTypeId": 32,'+
        '"CurrentSchoolAcademicYear": 0,'+
        '"NameDisplaySettingModelEnum": 0,'+
        '"ExternalId": "abc"'+
        ''+
        '}';
        //fromJSON obj = parse(json);
        //System.assert(obj != null);
    }*/

}