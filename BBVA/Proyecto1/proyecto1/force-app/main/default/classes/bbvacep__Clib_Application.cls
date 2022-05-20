/**
 * This implements the factories for the different domains for the Core Lib Module
 **/

public inherited sharing class Clib_Application {
        // Configure and create the UnitOfWorkFactory for the Core Lib Module
	public static final fflib_Application.UnitOfWorkFactory UNITOFWORK =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType> {
		clib_QuickActions__mdt.SObjectType,
		clib_Synchronizator__mdt.SObjectType,
		clib_Mapping_Fields__mdt.SObjectType,
		clib_Encrypted_Key__mdt.SObjectType,
		clib_SObjectFieldSetInclusion__mdt.SObjectType
	});

        // Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory SERVICE =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type> {
		Clib_ISynchronizatorService.class => Clib_SynchronizatorServiceImpl.class,
		Clib_IDecryptorService.class => Clib_DecryptorServiceImpl.class,
		Clib_IEmailServiceParserService.class => Clib_EmailServiceParserServiceImpl.class
	});

        // Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory SELECTOR =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
		clib_QuickActions__mdt.sObjectType => Clib_QuickActionsSelector.class,
		clib_Synchronizator__mdt.sObjectType => Clib_MDTSynchronizatorSelector.class,
		clib_Mapping_Fields__mdt.sObjectType => Clib_MDTMappingFieldsSelector.class,
		clib_Encrypted_Key__mdt.SObjectType => Clib_EncryptedKeysSelector.class,
		clib_SObjectFieldSetInclusion__mdt.SObjectType => Clib_SObjectFieldSetInclusionsSelector.class,
		clib_Email_Service_Parser__mdt.SObjectType => Clib_MDTEmailServiceParserSelector.class,
		clib_TriggerExtension__mdt.SObjectType => Clib_MDTTriggerExtensionSelector.class
	});
}