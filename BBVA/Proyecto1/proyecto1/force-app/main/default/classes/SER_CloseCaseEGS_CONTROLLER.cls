/***************************************************************************************
* @author       BBVA
* @date         20-02-2020
* @description  Controlador del aura component SER_CloseCaseEGS.

****************************************************************************************/
public with sharing class SER_CloseCaseEGS_CONTROLLER {
  /*Constante STACKTRACE*/
  public static final String STACKTRACE = ' , StackTrace: ';
  /*Constante 'Discarded / Duplicated'*/
  public static final String DISCARTED = 'Discarded / Duplicated';
  /*Constante EGS RECORD TYPE*/
  public static final Id EGSRT;
  static {
    EGSRT = SER_RecordTypeUtils.getRecordTypeByName('Task', 'SER_Task_EGS');
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_CloseCaseEGS_CONTROLLER() {}

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   initCloseCase.

      IN:            String caseId..
      OUT:           Boolean.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static string initCloseCase(String caseId) {
    Case caso;
    caso = new Case();
    try {
      caso = [SELECT Status,SER_Email_received__c FROM Case WHERE Id = :caseId];  //NOSONAR
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    system.debug('caso.status: '+caso.Status);
    system.debug('caso.SER_Email_received__c: '+caso.SER_Email_received__c);
    return (caso.Status+';'+caso.SER_Email_received__c);
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   cloneCase.

      IN:            String caseId.
      OUT:           String caseIdClonado.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static Id cloneCase(String caseId) {
    Case casoP;
    casoP = new Case();
    Case casoC;
    casoC = new Case();
	  Id response;
    try {
      //Recuperamos el Caso original y el último correo entrante
      casoP = [SELECT OwnerId,SER_Email_received__c,gf_group_incidence_case_name__c,AccountId,customer_system_id__c,Local_Client_EGS__c,SER_Local_Reference__c,gf_reference_id__c,solution_cateogry_id__c, RecordTypeId, SER_Outbound_Mailbox__c FROM Case WHERE Id = :caseId];  //NOSONAR
	  
      if (casoP.SER_Email_received__c) {
        //Creamos nuevo caso con datos de Owner y estructura del cliente
        casoC.OwnerId = casoP.OwnerId;
        casoC.gf_group_incidence_case_name__c = casoP.gf_group_incidence_case_name__c;
        casoC.AccountId = casoP.AccountId;
        casoC.customer_system_id__c = casoP.customer_system_id__c;
        casoC.Local_Client_EGS__c = casoP.Local_Client_EGS__c;
        casoC.SER_Local_Reference__c = casoP.SER_Local_Reference__c;
        casoC.gf_reference_id__c = casoP.gf_reference_id__c;
        casoC.solution_cateogry_id__c = casoP.solution_cateogry_id__c;
        casoC.SER_Email_received__c = true;
        casoC.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case', 'EGS_User');
        casoC.SER_Outbound_Mailbox__c = casoP.SER_Outbound_Mailbox__c;
        insert casoC;
        response = casoC.id;
        //updatemamos el caso padre quitando el check de chaser
        casoP.SER_Email_received__c = false; 
        update casoP;
      } 
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return response;
  }
  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   update Caso Padre

      IN:            String caseId.
      OUT:           void.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static void updateCasoP (String caseId) {
    Case casoP = new Case();
    casoP = [SELECT id,SER_Email_received__c FROM Case WHERE Id = :caseId];
    casoP.SER_Email_received__c = false; 
    update casoP;
  }
  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   clone EmailMessage and Attachment.

      IN:            String caseId.
      OUT:           void.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static void cloneEmailMessage(String caseId, String caseCId) {

    List<EmailMessage> emPs = new List<EmailMessage>();
    EmailMessage emP;
    EmailMessage emC;
    emC = new EmailMessage();
    list<String> splitTxtBody;
    list<String> splitHtmlBody;
    try {
      //Recuperamos el Caso original y el último correo entrante
      emPs = [SELECT TextBody,HtmlBody,Headers,Subject,FromName,FromAddress,ValidatedFromAddress,ToAddress,CcAddress,BccAddress,Incoming,HasAttachment,Status,MessageDate FROM EmailMessage WHERE parentId = :caseId ORDER BY CreatedDate DESC LIMIT 1];
      emP = emPs.get(0);	
	  
      //Lo primero desvinculamos el hilo del caso origen quitnado la referencia
      splitTxtBody = emp.TextBody.split('ref:_');
      splitHtmlBody = emp.HtmlBody.split('ref:_');
      //Procedemos a recortar el body del correo para quedarnos solo con la info del último correo
      //Para recortar dependerá del servidor, en nuestro caso comprobamos Gmail y Outlook
      String fin = '';
      if (emP.HtmlBody.contains('schemas-microsoft')) {
         fin = splitTxtBody.get(0).split('From: ').get(0);
      	 splitHtmlBody = splitHtmlBody.get(0).split('>From:<');      
      } else {
        splitTxtBody = splitTxtBody.get(0).split('>');
     	  splitHtmlBody = splitHtmlBody.get(0).split('<div class="gmail_quote">');
        //Eliminamos la última linea ya que contiene información del hilo
      	final String nuevo = splitTxtBody.get(0);
      	final list<String> textBodyFinal = nuevo.split('\n');
      
      	for (integer i = 0; i < textBodyFinal.size()-2; i++) {
          fin = fin+textBodyFinal.get(i)+'\n';
      	}
      }
      
	  //Creamos un nuevo EmailMessage con solo el contenido del último correo para linkarlo al nuevo caso
      emC.TextBody = fin;
      emC.HtmlBody = splitHtmlBody.get(0);
      emC.FromAddress = emP.FromAddress;
      emC.Incoming = emP.Incoming;
      emC.ParentId = caseCid;
      emC.RelatedToId = caseCid;
      emC.Status = emP.Status;
      emC.Subject = emP.Subject;
      emC.Headers = emP.Headers;
      emC.ToAddress = emP.ToAddress;
      emC.CcAddress = emP.CcAddress;
      emC.BccAddress = emP.BccAddress;
      emC.MessageDate = emP.MessageDate;

      insert emC;

      //Vamos a actualizar el caso nuevo indicando que debe mandarse la notificación automática de nuevo caso creado
      Case casoCloned = [SELECT Id, SER_New_case_notification_EGS__c, SER_Business_Case_Type__c, Status, SER_LastEmailFromAddress__c, SuppliedEmail  FROM Case WHERE Id = :caseCId];  //NOSONAR
      casoCloned.SER_New_case_notification_EGS__c = true;
      update casoCloned;

      //Si el EmailMessage original tiene attachment también deberemos añadirselos a este nuevo
	    if (emP.HasAttachment) {
	  	  List <Attachment> listAtt = new List<Attachment>();
      	listAtt = [SELECT Id, ParentId, Name, IsPrivate, ContentType, Body, OwnerId, Description  FROM Attachment  WHERE ParentId = :emP.id ];
     	  For (Attachment att : listAtt) {
           insertAttachment (att, emC.id,caseCId);
        }
      }  
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }
  private static void insertAttachment (Attachment att, String emCid, String caseCId) {
    ContentVersion conVer;
    conVer = new ContentVersion();
    conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
    conVer.PathOnClient = att.name; // The files name, extension is very important here which will help the file in preview.
    conVer.Title = att.name; // Display name of the files
    conVer.VersionData = EncodingUtil.base64Decode(Encodingutil.base64Encode(att.body)); // converting your binary string to Blog
    insert conVer; //NOSONAR
    
    //Creamos e insertamos el File asociado al Nuevo caso. Para ello buscamos por el nombre del att.
    //create ContentDocumentLink  record 
    List <ContentVersion> contDocuId;
    contDocuId =  new List<ContentVersion>();
    contDocuId = [select contentdocumentid from ContentVersion where id = :conVer.id];
    ContentDocumentLink conDocLink;
    conDocLink = new ContentDocumentLink();
    conDocLink.ContentDocumentId = contDocuId.get(0).contentdocumentid;  //ContentDocumentId Id from ContentVersion
    conDocLink.shareType = 'I';
    conDocLink.LinkedEntityId = caseCId;
    insert conDocLink;
                      
    //Creamos e insertamos el attachment asociado al EmailMessage
    Attachment aux;
    aux = new Attachment ();
    aux.ParentId = emCid;
    aux.name = att.name;
    aux.ContentType = att.ContentType;
    aux.Body = att.Body;
    aux.Description = att.Description;
    insert aux;

  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   CloseCase.

      IN:            String caseId.
      IN:            Boolean progress.
      IN:            Boolean trateAsMC.
      IN:            Boolean discard.
      OUT:           String.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String closeCase(String caseId, Boolean progress, Boolean trateAsMC, Boolean discard) {
    //Response.
    String response;
    response = '';
    //Caso.
    Case caso;
    caso = new Case();
    //Lista de tareas relacionadas.
    List<Task> taskList;
    taskList = new List<Task>();
    //Lista de casos hijos.
    List<Case> mCChildList;
    mCChildList = new List<Case>();

    try {
      //Recuperamos el caso principal, sus tareas relacionadas.
      caso = [SELECT Id, SER_Classification__c, case_channel_source_type__c, gf_case_channel_source_name__c,
              Description, gf_cust_impact_case_name__c, SER_Solution__c, gf_case_cause_on_closure_desc__c,
              gf_case_area_name__c, validation_criticality_type__c, AccountId, gf_case_creation_type__c, SER_Email_received__c, 
              gf_case_countries_desc__c, CaseNumber, gf_case_environment_name__c, Subject, SER_Is_Master_Case__c, SER_Master_Case__c, SER_Master_Case__r.CaseNumber,
              (SELECT Id, gf_spec_task_op_case_ind_type__c, Status, Priority, TaskComment__r.gf_action_result_desc__c,
              TaskComment__r.Id, departament_name__c, incidence_id__c, Skip_Validations__c, gf_task_id__c,
              gf_tech_impact_case_name__c FROM Tasks WHERE RecordTypeId = :EGSRT AND (Status = 'New' OR Status = 'Working'
              OR Status = 'Remedy - Escalated' OR Status = 'Remedy - Pending information' OR Status = 'Remedy - Pending to close'
              OR Status = 'Remedy - Rejected')) FROM Case WHERE Id = :caseId];

      //Guardamos la lista de tareas en la lista taskList.
      taskList = caso.Tasks;

      //Recuperamos los casos hijos con sus tareas.
      mCChildList = [SELECT Id, SER_Classification__c, case_channel_source_type__c, gf_case_channel_source_name__c,
                    Description, gf_cust_impact_case_name__c, SER_Solution__c, gf_case_cause_on_closure_desc__c,
                    gf_case_area_name__c, validation_criticality_type__c, AccountId, gf_case_creation_type__c, SER_Email_received__c, 
                    gf_case_countries_desc__c, CaseNumber, gf_case_environment_name__c, Subject, SER_Is_Master_Case__c, SER_Master_Case__c, SER_Master_Case__r.CaseNumber,
                    (SELECT Id, gf_spec_task_op_case_ind_type__c, Status, Priority, TaskComment__r.gf_action_result_desc__c,
                    TaskComment__r.Id, departament_name__c, incidence_id__c, Skip_Validations__c, gf_task_id__c,
                    gf_tech_impact_case_name__c FROM Tasks WHERE RecordTypeId = :EGSRT AND (Status = 'New' OR Status = 'Working'
                    OR Status = 'Remedy - Escalated' OR Status = 'Remedy - Pending information' OR Status = 'Remedy - Pending to close'
                    OR Status = 'Remedy - Rejected')) FROM Case WHERE SER_Master_Case__c = :caseId];

      //Validamos si el caso es Master Case y si tiene casos hijos.
      Boolean isMasterCase;
      isMasterCase = caso.SER_Is_Master_Case__c && mCChildList.isEmpty() == false && trateAsMC;

      //Booleano encargado de parar el proceso y que no se cierrene los casos/tareas si es un master Case para mostrar la ventana de confirmación.
      Boolean continueProcess;
      continueProcess = true;

      // Booleano que controla el 1er proceso de master case. Progress = false - 1ª vuelta, si el caso maestro o los hijos
      // tienen tareas se muestra la ventana modal de confirmación, si no hay tareas se procede al cerrado.
      // process = true - ya procede a cerrar los casos, se pone a true una vez que se confirma en la ventana modal que 
      // si se quiere seguir con el cerrado / descartado aunque haya tareas abiertas.
      Boolean processMC;
      processMC = isMasterCase && progress == false;

      //Booleano que controla al 2º proceso de MC en el que ya se cierran los casos.
      Boolean processMCTwo;
      processMCTwo = isMasterCase && progress == true;

      //Proceso 1º de Master Case.
      if(processMC) {
        response = SER_CloseCaseEGS_HELPER.processMasterCase(mCChildList, taskList, caso, discard);
        //Ponemos la variable continueProcess = false para que pare el proceso.
        continueProcess = false;
      //Proceso 2º de Master Case. Una vez que el usuario a pulsado continue al close de master case se cierran los casos, tareas y tickets
      } else if(processMCTwo) {
        closeCase(caso.Id, true, false, discard);
        continueProcess = false;
      }

      if(continueProcess) {
        // Añadimos el caso principal a la lista de hijos para iterar sobre ellos y cerrarlos
        mCChildList.add(caso);
        response = continueProcessCloseCase(mCChildList, discard, progress, isMasterCase);
      }
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   continueProcessCloseCase.

      IN:            List<Case> mCChildList.
      IN:            Boolean discard.
      IN:            Boolean progress.
      IN:            Boolean isMasterCase.

      OUT:           String.
  ---------------------------------------------------------------------------------------*/
  private static String continueProcessCloseCase(List<Case> mCChildList, Boolean discard, Boolean progress, Boolean isMasterCase) {
    //Response.
    String response;
    response = '';
    //Lista de casos para cerrar sin tareas.
    List<Case> casesToClose;
    casesToClose = new List<Case>();
    //Lista de casos para cerrar con tareas.
    List<Case> casesToCloseWT;
    casesToCloseWT = new List<Case>();
    //Lista de casos con errores de validacion.
    List<Case> casesWithError;
    casesWithError = new List<Case>();

    for(Case caseToClose : mCChildList) {
      //Booleano que controla si se validan los campos obligatorios en el caso de close, o no se validan en el caso de discard.
      Boolean closeTask;
      if(discard) {
        closeTask = true;
      } else {
        closeTask = SER_CloseCaseEGS_HELPER.validateRequiredFields(caseToClose);
      }

      //Cerramos casos, tareas y remedys.
      Boolean closeWOTask;
      closeWOTask = caseToClose.Tasks.isEmpty() && closeTask;
      Boolean caseWithTask;
      caseWithTask = caseToClose.Tasks.isEmpty() == false && closeTask;
      if(closeWOTask) {
        Case caseWOTask;
        caseWOTask = new Case(Id = caseToClose.Id, Status = SER_Constant.CLOSED, case_status_type__c = SER_Constant.CLOSED, activity_status_type__c = SER_Constant.CLOSED, RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'Close_Case_EGS_User'), SER_Close__c = true, SER_Email_received__c = false, SER_Skip_validations__c = true, SER_Classification__c = discard ? DISCARTED : caseToClose.SER_Classification__c);
        casesToClose.add(caseWOTask);
      } else if(caseWithTask) {
        casesToCloseWT.add(caseToClose);
      } else if(closeTask == false) {
        casesWithError.add(caseToClose);
      }
    }

    if(casesWithError.isEmpty() == false) {
      response = fillErrorResponse(casesWithError);
    } else {
      update casesToClose;
      //Caso con tareas que pasa las validacione
      response = manageTask(casesToCloseWT, progress, isMasterCase, discard);
      response = String.isNotBlank(response) ? response : Label.SER_EGS_Reopen_Success;
    }
    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   ResolveCase.

      IN:            String caseId.
      IN:            Boolean progress.
      OUT:           String.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String resolveCase(String caseId, Boolean progress) {
    String response;
    response = '';
    Case caso;
    caso = new Case();
    try {
      caso = [SELECT Id, SER_Classification__c, case_channel_source_type__c, gf_case_channel_source_name__c, Description,
              gf_cust_impact_case_name__c, SER_Solution__c, gf_case_cause_on_closure_desc__c, gf_case_area_name__c,
              validation_criticality_type__c, AccountId, gf_case_creation_type__c, gf_case_environment_name__c,
              gf_case_countries_desc__c, CaseNumber, Subject FROM Case WHERE Id = :caseId];
      Boolean resolveCase;

      //Se debe de verificar que los siguientes campos están rellenos
      if(caso.SER_Classification__c == SER_Constant.INCIDENT) {
        resolveCase = String.isNotBlank(caso.SER_Classification__c) &&
                    String.isNotBlank(caso.case_channel_source_type__c) &&
                    String.isNotBlank(caso.gf_case_channel_source_name__c) &&
                    String.isNotBlank(caso.Description) &&
                    String.isNotBlank(caso.gf_cust_impact_case_name__c) &&
                    String.isNotBlank(caso.SER_Solution__c) &&
                    String.isNotBlank(caso.gf_case_cause_on_closure_desc__c) &&
                    String.isNotBlank(caso.gf_case_area_name__c) &&
                    String.isNotBlank(caso.validation_criticality_type__c) &&
                    caso.AccountId != null &&
                    String.isNotBlank(caso.gf_case_creation_type__c) &&
                    String.isNotBlank(caso.gf_case_environment_name__c) &&
                    String.isNotBlank(caso.Subject) &&
                    String.isNotBlank(caso.gf_case_countries_desc__c);
      } else if(caso.SER_Classification__c == SER_Constant.QUERY) {
        resolveCase = String.isNotBlank(caso.SER_Classification__c) &&
                    String.isNotBlank(caso.case_channel_source_type__c) &&
                    String.isNotBlank(caso.gf_case_channel_source_name__c) &&
                    String.isNotBlank(caso.Description) &&
                    String.isNotBlank(caso.SER_Solution__c) &&
                    caso.AccountId != null &&
                    String.isNotBlank(caso.gf_case_environment_name__c) &&
                    String.isNotBlank(caso.Subject);
      }

      if(resolveCase) {
        //Se resuelve el caso.
        caso.Status = SER_Constant.RESOLVED;
        caso.case_status_type__c = SER_Constant.RESOLVED;
        caso.activity_status_type__c = SER_Constant.RESOLVED_SUBS;
        //caso.SER_Resolved_Date__c = date.today();
        caso.SER_Resolved_Date__c = datetime.now();
        caso.SER_Skip_validations__c = true;
        update caso;
        response = Label.SER_EGS_Resolved_Success; //NOSONAR
      } else {
        List<Case> caseList;
        caseList = new List<Case>();
        caseList.add(caso);
        response = fillErrorResponse(caseList);
      }
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   ReopenCase.

      IN:            String caseId.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static void reopenCase(String caseId) {
    try {
      Case caso;
      caso = [SELECT Id, SER_Classification__c, SER_Initial_Classification__c, SER_Batch_Resolved__c, SER_Resolved_Date__c FROM Case WHERE Id = :caseId];
      if(caso.SER_Classification__c == DISCARTED) {
        caso = new Case(Id = caseId, Status = SER_Constant.WORKING, case_status_type__c = SER_Constant.WORKING, activity_status_type__c = SER_Constant.WORKING, RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'EGS_User'), SER_Close__c = false, SER_Skip_validations__c = true, SER_Classification__c = caso.SER_Initial_Classification__c);
      } else {
        caso = new Case(Id = caseId, Status = SER_Constant.WORKING, case_status_type__c = SER_Constant.WORKING, activity_status_type__c = SER_Constant.WORKING, RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'EGS_User'), SER_Close__c = false, SER_Batch_Resolved__c = false, SER_Resolved_Date__c = null, SER_Skip_validations__c = true);
      }
      update caso;
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = STACKTRACE + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   saveLog.

      IN:            String subject.
      IN:            String recordId.
      IN:            String remedyUser.
      IN:            String errMsg.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static void saveLog(String subject, String recordId, String remedyUser, String errMsg) {
    try {
      CIB_LogUtils.create_RemedyErrorLog(subject, recordId, remedyUser, errMsg);
    } catch(Exception exc) {
      System.debug('An error occurred while saving the CIB_Log: ' + exc);
    }
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Gestiona las tareas asociadas al caso.

      IN:            List<Task> taskList.
      IN:            Boolean progress.
      IN:            Case caso.
      IN:            Boolean isMasterCase.
      IN:            Boolean dicard.
      OUT:           String.
  ---------------------------------------------------------------------------------------*/
  public static String manageTask(List<Case> caseList, Boolean progress, Boolean isMasterCase, Boolean discard) {
    String response;
    response = '';
    //Lista donde se van a ir guardando las tareas que hay que cerrar.
    List<Task> taskToClose;
    taskToClose = new List<Task>();
    //Mapa donde se guardan las tareas con remedy y su caso asociado como valor para cerrar los tickets.
    Map<Task, Case> taskWithRemedy;
    taskWithRemedy = new Map<Task, Case>(); //NOSONAR
    //Mapa que guarda los status de las tareas con Remedy por si hubiese que reabrirlos.
    Map<Id, String> remedyStatuses;
    remedyStatuses = new Map<Id, String>(); //NOSONAR
    //Lista donde se van a ir guardando los casos que hay que cerrar.
    List<Case> casesToClose;
    casesToClose = new List<Case>();
    //Booleano que se pone a false para evitar que se cierre el caso y las tareas si añlguna de las tareas no pasa las validaciones.
    Boolean updateTask;
    updateTask = true;

    for(Case casoWT : caseList) {
      //Validamos las tareas del caso.
      for(Task tarea : casoWT.Tasks) {
        Boolean isActionLine;
        isActionLine = tarea.gf_spec_task_op_case_ind_type__c && tarea.Status != SER_Constant.COMPLETED && isMasterCase == false && casoWT.SER_Master_Case__c == null && progress && discard == false;
        Boolean notComplete;
        notComplete = tarea.Status != SER_Constant.COMPLETED && progress == false && isMasterCase == false;
        Boolean hasOpenRemedy;
        hasOpenRemedy = String.isNotBlank(tarea.incidence_id__c) && tarea.Status != SER_Constant.COMPLETED;
        if(isActionLine) {
          //No se podrá cerrar un caso si tiene una “Línea de Acción” abierta.
          response = Label.SER_EGS_Reopen_Error_Action_Line;
          updateTask = false;
          break;
        } else if(notComplete) {
          //Validamos que estén todas las tareas completadas.
          response = 'PROGR' + Label.SER_EGS_Reopen_Task_In_Proogress;
          updateTask = false;
          break;
        } else if(hasOpenRemedy) {
          //Guardamos las tareas en la lista taskToClose para cerrarlas posteriormente.
          taskToClose.add(tarea);
          //Guardamos las tareas con Remedys en otra lista, taskWithRemedy, para cerrar los Tickets.
          taskWithRemedy.put(tarea, casoWT);
          //Guardamos el status de Remedy
          remedyStatuses.put(tarea.Id, tarea.Status);
        } else {
          //Guardamos elñ resto de las tareas en la lista taskToClose para cerrarlas posteriormente.
          taskToClose.add(tarea);
        }
      }
      Boolean closeCase;
      closeCase = taskToClose.isEmpty() == false && updateTask;
      if(closeCase) {
        //Se cierra el caso.
        Case caseToUpdate;
        caseToUpdate = new Case(Id = casoWT.Id, Status = SER_Constant.CLOSED, case_status_type__c = SER_Constant.CLOSED, activity_status_type__c = SER_Constant.CLOSED, RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'Close_Case_EGS_User'), SER_Close__c = true, SER_Email_received__c = false, SER_Skip_validations__c = true, SER_Classification__c = discard ? DISCARTED : casoWT.SER_Classification__c);
        casesToClose.add(caseToUpdate);
      }
    }

    SER_CloseCaseEGS_HELPER.closeCaseAndTAsk(casesToClose, taskWithRemedy, remedyStatuses, discard, taskToClose);

    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA.
      Description:   Rellena el response si ha habido algún error de validación..

      IN:            List<Case> caseWErrors.
      OUT:           String.
  ---------------------------------------------------------------------------------------*/
  public static String fillErrorResponse(List<Case> caseWErrors) {
    String response;
    response = '';
    String caseNumberST;
    caseNumberST = '(Cases:';
    for(Case caso : caseWErrors) {
      caseNumberST += ' ' + caso.CaseNumber + ',';
    }
    caseNumberST = caseNumberST.removeEnd(',');
    caseNumberST += ')';

    if(caseWErrors[0].SER_Classification__c == SER_Constant.INCIDENT) {
      response = Label.SER_EGS_Reopen_Error_Validation + (caseWErrors.size() == 1 ? '' : caseNumberST); //NOSONAR
    } else if(caseWErrors[0].SER_Classification__c == SER_Constant.QUERY) {
      response = Label.SER_EGS_Query_Error_Validation + (caseWErrors.size() == 1 ? '' : caseNumberST); //NOSONAR
    }
    return response;
  }

  /*---------------------------------------------------------------------------------------
      Company:       BBVA
      Description:   Fill Initial Case Classification.

      IN:            List<Case> newList.
      IN:            Map<Id,Case> oldMap.
      OUT:           Void.
  ---------------------------------------------------------------------------------------*/
  public static void fillInitialClassification(List<Case> newList, Map<Id,Case> oldMap) {
    for(Case caso : newList) {
      if(caso.SER_Classification__c != oldMap.get(caso.Id).SER_Classification__c && caso.SER_Classification__c != DISCARTED) {
        caso.SER_Initial_Classification__c = caso.SER_Classification__c;
      }
    }
  }

}