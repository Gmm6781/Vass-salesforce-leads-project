trigger LeadCountryTrigger on Lead (before insert, before update) {
    Set<String> countryNames = new Set<String>();

    for (Lead l : Trigger.new) {
        if (l.Country != null) {
            countryNames.add(l.Country.trim());
        }
    }

    Map<String, Country__c> countriesMap = new Map<String, Country__c>();

    if (!countryNames.isEmpty()) {
        for (Country__c c : [
            SELECT Name, Capital__c, Region__c, RegionalBlocs__c, Alpha3Code__c
            FROM Country__c
            WHERE Name IN :countryNames
        ]) {
            countriesMap.put(c.Name.trim(), c);
        }
    }

    for (Lead l : Trigger.new) {
        if (l.Country != null && countriesMap.containsKey(l.Country.trim())) {
            Country__c country = countriesMap.get(l.Country.trim());
            l.Country_Capital__c = country.Capital__c;
            l.Country_Region__c = country.Region__c;
            l.Country_Blocs__c = country.RegionalBlocs__c;
            l.Alpha3code_Lead__c = country.Alpha3Code__c;
            
        } else {
            l.Country_Capital__c = null;
            l.Country_Region__c = null;
            l.Country_Blocs__c = null;
            l.Alpha3code_Lead__c = null;
        }
    }
}