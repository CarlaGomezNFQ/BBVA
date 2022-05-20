public inherited sharing class Clib_EmailServiceParserServiceHelper {
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        List <clib_Email_Service_Parser__mdt> parsers = Clib_MDTEmailServiceParserSelector.newInstance().selectAll();
        MatcherResultInfoType regExResult;
        try {
            for(clib_Email_Service_Parser__mdt parser : parsers) {
                system.debug(' Clib_EmailServiceParserServiceHelper parser.clib_Attributes__c: '+ parser.clib_Attributes__c);
                system.debug(' Clib_EmailServiceParserServiceHelper parser.MasterLabel: '+ parser.MasterLabel);
                system.debug(' Clib_EmailServiceParserServiceHelper parser.clib_DeveloperName: '+ parser.DeveloperName);
                List <Matcher> matcherList = new List <Matcher>();
                List <String> allowedFromAddress = parser.clib_From_Address__c != null ? parser.clib_From_Address__c.split(',') : null;
                system.debug('Clib_EmailServiceParserServiceHelper.handleInboundEmail email.fromAddress:' +  email.fromAddress);
                system.debug('Clib_EmailServiceParserServiceHelper.handleInboundEmail allowedFromAddress:' +  allowedFromAddress);
                if(allowedFromAddress == null || allowedFromAddress != null && allowedFromAddress.contains(email.fromAddress)) {
                    regExResult = processRegEx(email, parser);
                    if (regExResult.success) {
                        system.debug('Clib_EmailServiceParserServiceHelper.handleInboundEmail regExResult.success para :' +  parser.MasterLabel);
                        Type t = Type.forName(parser.clib_ApexClass__c);
                        Clib_IEmailServiceParser serviceParser = (Clib_IEmailServiceParser)t.newInstance();
                        serviceParser.processEmail(email, regExResult.matcherList, parser.clib_Attributes__c);
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return (result);
        }
        return result;
    }

    private static MatcherResultInfoType processRegEx(Messaging.InboundEmail email, clib_Email_Service_Parser__mdt config) {
        
        List <Matcher> matcherList = new List <Matcher>();
        if(config.clib_Regex_Expression__c == null) {return new MatcherResultInfoType(true, matcherList);}
        Map <String, List <String>> mapRegExp = (Map <String, List <String>>)JSON.deserializeStrict(config.clib_Regex_Expression__c, Map <String, List <String>>.class);
        for(String key : mapRegExp.keySet()) {
            List <Matcher> matcherListTemp;
            switch on key {
                when 'subject' {
                    matcherListTemp = executeRegEx(email.subject, mapRegExp.get(key));
                }
                when 'body' {
                    matcherListTemp = executeRegEx(email.plainTextBody, mapRegExp.get(key));
                }
                when 'htmlbody' {
                    matcherListTemp = executeRegEx(email.htmlBody, mapRegExp.get(key));
                }
            }
            if(matcherListTemp.size() == 0) {
                return new MatcherResultInfoType(false , null);
            } else {
                matcherList.addAll(matcherListTemp);
            }
        }
        return  new MatcherResultInfoType(true , matcherList); 
    }

    private static List <Matcher> executeRegEx(String str, List <String> regExList) {
        List <Matcher> matcherList = new List <Matcher>();
        for(String regEx : regExList) {
            Matcher matcher = Pattern.compile(regEx).matcher(str);
            system.debug(' Clib_EmailServiceParserServiceHelper executeRegEx str: '+ str);
            system.debug(' Clib_EmailServiceParserServiceHelper executeRegEx regex: '+ regEx);
            if(matcher.find()) {
                matcherList.add(matcher);
            } else {
                return new List <Matcher>();
            }
        }
        return matcherList;
    }

    private class MatcherResultInfoType {
        Boolean success;
        List <Matcher> matcherList;

        public MatcherResultInfoType(Boolean success, List <Matcher> matcherList) {
            this.success = success;
            this.matcherList = matcherList;
        }
    }
}