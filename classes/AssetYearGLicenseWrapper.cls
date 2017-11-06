/**
* @author vishnu belkone
* @description - This class returns fields for asset and Yeargroup licences post/put service.*/
public class AssetYearGLicenseWrapper {
    public Integer CustomerId;
    public cls_Licence Licence; 
    public class cls_Licence {
        public Integer Id;  //null
        public Integer CapUsed; //0
        public Integer CapCount;    //0
        public Decimal ProductType; //Null
        public Date StartDate;  //null
        public Date EndDate;    //null
        public Decimal LicenceType; //null
        public cls_SchoolYearGroupLicences[] SchoolYearGroupLicences;
        public String ExternalId;
        public Integer Status;
    }
     public class cls_SchoolYearGroupLicences {
        public Decimal YearGroup;   //jsbgf
        public boolean IsActive;
    }
    /*public static AssetYearGLicenseWrapper parse(String json){
        return (AssetYearGLicenseWrapper) System.JSON.deserialize(json, fromJSON.class);
    }

    static testMethod void testParse() {
        String json=        '{'+
        '    "CustomerId": "null",'+
        '    "Licence": {'+
        '        "Id": "null",'+
        '        "CapUsed": 0,'+
        '        "CapCount": 0,'+
        '        "ProductType": "Null",'+
        '        "StartDate": "null",'+
        '        "EndDate": "null",'+
        '        "LicenceType": "null",'+
        '        "SchoolYearGroupLicences": ['+
        '            {'+
        '                "YearGroup": "jsbgf",'+
        '                "IsActive": true'+
        '            },'+
        '            {'+
        '                "YearGroup": "sdjkfk",'+
        '                "IsActive": true'+
        '            }'+
        '        ]'+
        '    }'+
        '}';
        fromJSON obj = parse(json);
        System.assert(obj != null);
    }*/
}