global interface Clib_IEmailServiceParser {
    void processEmail(Messaging.InboundEmail email, List <Matcher> matcherList, String params);
}