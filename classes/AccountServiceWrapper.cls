/**
* @author: Vishnu Belkone
* @date 10/08/2015
* @description - this class is an wrapper class of account fields which we have to use in post/put service. 
*/

public class AccountServiceWrapper {
    public Integer Id;  //924779
    public Integer SchoolId;    //144181
    public String Name; //Brand New Test School
    public cls_Email Email;
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
    public Integer FocusLevelId;    //21
    public String MarketSectorCode; //U
    public cls_SchoolLowYear SchoolLowYear;
    public cls_SchoolHighYear SchoolHighYear;
    public cls_Status Status;
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
    public cls_ExternalId ExternalId;
    public Integer NumberOfStudents;
    public String BusinessProfile;
    class cls_Email {
    }
    class cls_PostalAddress {
        public String RegionName;   //Australian Capital Territory
        public String CountryCode;  //AUS
        public cls_Province Province;
        public String StateCode;    //ACT
        public String PostCode; //
        public cls_Locality Locality;
        public Integer UkCountryModelName;  //0
        public String City; //
        public cls_Suburb Suburb;
        public String Street1;  //
        public String Street2;  //
        public String Street3;  //
        public String Street4;  //
    }
    class cls_Province {
    }
    class cls_Locality {
    }
    class cls_Suburb {
    }
    class cls_MainAddress {
        public String RegionName;   //New South Wales
        public String CountryCode;  //AUS
        public cls_Province Province;
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
    class cls_SchoolLowYear {
    }
    class cls_SchoolHighYear {
    }
    class cls_Status {
    }
    class cls_ExternalId {
    }
    public static AccountServiceWrapper parse(String json){
        return (AccountServiceWrapper) System.JSON.deserialize(json, AccountServiceWrapper.class);
    }
        //AccountServiceWrapper obj = parse(json);
        //System.assert(obj != null);
}