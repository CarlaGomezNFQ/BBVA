/**
* ────────────────────────────────────────────────────────────────────
* ParticipantSample_Test
* Test class for ParticipantSample apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-09
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ParticipantSample_Test {

    @TestSetup
    static void makeDataOfParticipantSample() {
        final List<Account> lstAcc = Test_Utils.createAccounts(1);
        lstAcc[0].AccountNumber = '000000001';
        lstAcc[0].Rating = 'Warm';
        lstAcc[0].OwnerId = UserInfo.getUserId();
        insert lstAcc;
    }

    // Test getParticipantDetails method
    @IsTest
    static void getPartipantDetailsTest1() {

        Test.startTest();
            final List<Account> lstAcc = [SELECT Id, Name, AccountNumber, Rating FROM Account WHERE Name = 'Account Test 0' LIMIT 1];
            final List<Participant_Wrapper> expectedWrapper = new List<Participant_Wrapper>();

            final Participant_Wrapper pWrapp = new Participant_Wrapper();
            pWrapp.participantId = lstAcc[0].Id;
            pWrapp.participantName = lstAcc[0].Name;
            pWrapp.documentNumber = lstAcc[0].AccountNumber;
            pWrapp.documentType = 'CIF';
            pWrapp.documentTypeCode = '2';
            pWrapp.participantCode = lstAcc[0].AccountNumber;
            pWrapp.participantIntegrationId = 'ES0182' + lstAcc[0].AccountNumber + 'C';
            pWrapp.rating = lstAcc[0].Rating;
            expectedWrapper.add(pWrapp);
            ParticipantSample partSample = new ParticipantSample();
            final List<Participant_Wrapper> actualWrapper = partSample.getParticipantDetails(new Set<Id>{lstAcc[0].Id});
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at ParticipantSample_Test getPartipantDetailsTest1');
        Test.stopTest();

    }

    // Test getParticipantsToSelect method
    @IsTest
    static void getPartipantDetailsTest2() {

        Test.startTest();
            final List<Account> lstAcc = [SELECT Id, Name, AccountNumber, Rating FROM Account WHERE Name = 'Account Test 0' LIMIT 1];
            final List<Participant_Wrapper> expectedWrapper = new List<Participant_Wrapper>();

            final Participant_Wrapper pWrapp = new Participant_Wrapper();
            pWrapp.participantId = lstAcc[0].Id;
            pWrapp.participantName = lstAcc[0].Name;
            pWrapp.documentNumber = lstAcc[0].AccountNumber;
            pWrapp.documentType = 'CIF';
            pWrapp.documentTypeCode = '2';
            pWrapp.participantCode = lstAcc[0].AccountNumber;
            pWrapp.participantIntegrationId = 'ES0182' + lstAcc[0].AccountNumber + 'C';
            pWrapp.isCustomer = true;
            pWrapp.rating = lstAcc[0].Rating;
            expectedWrapper.add(pWrapp);
            final ParticipantSample partSample = new ParticipantSample();
            final List<Participant_Wrapper> actualWrapper = partSample.getParticipantsToSelect(new Set<Id>{lstAcc[0].Id}, UserInfo.getUserId());
            System.assertEquals(JSON.serialize(expectedWrapper), JSON.serialize(actualWrapper), 'Err at ParticipantSample_Test getPartipantDetailsTest2');
        Test.stopTest();

    }
}