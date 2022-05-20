/**
*FECHA          -   AUTOR           -   DESCRIPCIÓN DEL CAMBIO
*15/09/2019     -   Accenture JSS   -   Creación: Clase de test para el Batch_CloseExpiredOpportunities y Schedulable_CloseExpiredOpportunities.
*/ 
@isTest
public class Batch_CloseExpiredOpportunities_Test {

  /**
   * instancia de la clase de utilidades de test
   */
  private static DES_UtilTestClass utilTestClass = new DES_UtilTestClass();
  /**
   * fecha dummy para programar la tarea
   */
  public static final String CRON_EXP = '0 0 2 * * ?';

  /**
   * Creación de la cuenta y oportunidades
   */
  @testSetup
  static void setup() {

    final Account acc1 = utilTestClass.createClient();
    insert acc1;

    final List<Opportunity> opps = new List<Opportunity>();

    // insert 20 opportunities
    for (Integer i = 0; i < 20; i++) {
      final Opportunity opp = utilTestClass.createOpportunity(acc1);
      opp.DES_Confirm_Duplicate_Message__c = true;
      opp.Name = 'Opp ' + i;
      opp.CloseDate = Date.today().addDays(-11);
      opps.add(opp);
    }

    final Opportunity oppCl = utilTestClass.createOpportunity(acc1);
    oppCl.name = 'oppCl';
    opps.add(oppCl);
    insert opps;

  }

  /**
   * Test sobre la clase Schedulable_CloseExpiredOpportunities
   */
  @IsTest
  static void test_01() {
    Test.startTest();
      final Batch_CloseExpiredOpportunities batch_aux = new Batch_CloseExpiredOpportunities();
      final String jobId = System.schedule('Test Check', CRON_EXP, new Schedulable_CloseExpiredOpportunities());
    Test.stopTest();
    final List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
    System.assertEquals(1, cronTriggers.size(), 'The schedulable hasn\'t been launched correctly :(');

  }

}