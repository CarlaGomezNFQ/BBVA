public inherited sharing class Clib_EmailServiceParserServiceImpl implements Clib_IEmailServiceParserService {

    Clib_EmailServiceParserServiceHelper helper = new Clib_EmailServiceParserServiceHelper();
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        return helper.handleInboundEmail(email, envelope);
    }
}