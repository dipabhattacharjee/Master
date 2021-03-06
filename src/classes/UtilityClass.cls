/**
* @author Vishnu Belkone
* @date 10/08/2015
* @description This class has helper methods.
*/
public class UtilityClass {
  /**
  * @author Vishnu Belkone
  * @date 10/08/2015
  * @description Gets the type name of the SObject.
  * @param SObject The SObject for which the name to be obtained.
  * @return String - The type name.
  */
  public static String getSObjectTypeName(SObject so) {
    return so.getSObjectType().getDescribe().getName();
  }
}