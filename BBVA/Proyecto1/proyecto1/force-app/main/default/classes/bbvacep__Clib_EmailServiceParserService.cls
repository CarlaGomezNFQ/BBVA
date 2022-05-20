global inherited sharing class Clib_EmailServiceParserService implements Messaging.InboundEmailHandler,Clib_IEmailServiceParserService  {

    global static Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        return service().handleInboundEmail(email, envelope);
    }

	private static Clib_IEmailServiceParserService service() {
		return (Clib_IEmailServiceParserService) Clib_Application.SERVICE.newInstance(Clib_IEmailServiceParserService.class);
	}
}