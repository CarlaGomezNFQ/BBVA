//Creada por necesidad de los tests
global class Arc_GBL_User_LocatorMock implements Arc_Gen_User_Interface {//NOSONAR
    /**
    *-------------------------------------------------------------------------------
    * @description  Method that retrieves full user information
    --------------------------------------------------------------------------------
    * @author javier.soto.carrascosa@bbva.com
    * @date 2019-07-15
    * @param Id userId
    * @return wrapper user data
    * @example public static WrapperUser getUserInfo(Id userId) {
    **/
    public static Arc_Gen_User_Wrapper getUserInfo(Id userId) {
        Arc_Gen_User_Wrapper wu = new Arc_Gen_User_Wrapper();
        User userInfo = getBasicInfoUser(userId);
        wu.userBasicInfo = userInfo;
        wu.branchId = '0000';
        wu.branchText = 'Placeholder Office';
        wu.ambitUser = '1';
        wu.branchlevel = '10';
        wu.businessAgentId = userInfo.FederationIdentifier;
        wu.profileName = userInfo.Profile.Name;
        wu.cr = '0001';
        wu.territory = 'Office 1';
        wu.officeName = wu.branchText + '/' + wu.cr;
        return wu;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Method to find users
    * ---------------------------------------------------------------------------------------------------
    * @Author   Angel Fuertes Gomez - angel.fuertes2@bbva.com / BBVA DWP
    * @Date     Created: 2019-05-04
    * @param inputTerm - String to find users
    * @return a list users
    * @example getUsers(inputTerm)
    * ---------------------------------------------------------------------------------------------------
    **/
    public static List<Arc_Gen_User_Wrapper> getUsers(String inputTerm) {
        List<Arc_Gen_User_Wrapper> listWrapper = new List<Arc_Gen_User_Wrapper>();
        for (User user : [SELECT Id, Name, Profile.Name, FederationIdentifier FROM User WHERE Name like :'%'+inputTerm+'%' and isActive = true]) {
            Arc_Gen_User_Wrapper wrap = new Arc_Gen_User_Wrapper();
            wrap.userBasicInfo = user;
            wrap.branchId = '0000';
            wrap.branchText = 'Placeholder Office';
            wrap.branchlevel = '10';
            wrap.businessAgentId = user.FederationIdentifier;
            wrap.profileName = user.Profile.Name;
            listWrapper.add(wrap);
        }
        return listWrapper;
    }
    /**
    * ---------------------------------------------------------------------------------------------------
    * @Description - Private method to find user from the userId
    * ---------------------------------------------------------------------------------------------------
    * @Author   Angel Fuertes Gomez - angel.fuertes2@bbva.com / BBVA DWP
    * @Date     Created: 2019-05-04
    * @param userId - User Id
    * @return a list users
    * @example getBasicInfoUser(userId)
    * ---------------------------------------------------------------------------------------------------
    **/
    private static User getBasicInfoUser(Id userId) {
        User userDetails = [SELECT Id, Name, Profile.Name, FederationIdentifier FROM User WHERE Id =:userId];
        Return userDetails;
    }
}