public with sharing class CountryLayerService {

    public class CountryWrapper {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public List<RegionalBloc> regionalBlocs;
    }

    public class RegionalBloc {
        public String acronym;
    }

    @future(callout=true)
    public static void fetchCountries() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:CountryLayerAPI/all?access_key=4da03d8ed51999c48fdade6a2ddc6c02');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            List<CountryWrapper> countries = 
                (List<CountryWrapper>) JSON.deserialize(response.getBody(), List<CountryWrapper>.class);

            if (countries == null || countries.isEmpty()) return;

            // Obtener nombres únicos
            Set<String> names = new Set<String>();
            for (CountryWrapper c : countries) {
                if (c.name != null) {
                    names.add(c.name);
                }
            }

            // Obtener registros existentes en Salesforce
            Map<String, Country__c> existingCountries = new Map<String, Country__c>();
            for (Country__c existing : [
                SELECT Id, Name, Alpha2Code__c, Alpha3Code__c, Capital__c, Region__c, RegionalBlocs__c
                FROM Country__c
                WHERE Name IN :names
            ]) {
                existingCountries.put(existing.Name, existing);
            }

            List<Country__c> toInsert = new List<Country__c>();
            List<Country__c> toUpdate = new List<Country__c>();

            for (CountryWrapper c : countries) {
                if (String.isBlank(c.name)) continue;

                String regionalBlocsString = '';
                if (c.regionalBlocs != null) {
                    List<String> acronyms = new List<String>();
                    for (RegionalBloc bloc : c.regionalBlocs) {
                        if (bloc.acronym != null) acronyms.add(bloc.acronym);
                    }
                    regionalBlocsString = String.join(acronyms, ',');
                }

                if (existingCountries.containsKey(c.name)) {
                    Country__c existing = existingCountries.get(c.name);

                    Boolean changed = false;
                    if (existing.Alpha2Code__c != c.alpha2Code) { existing.Alpha2Code__c = c.alpha2Code; changed = true; }
                    if (existing.Alpha3Code__c != c.alpha3Code) { existing.Alpha3Code__c = c.alpha3Code; changed = true; }
                    if (existing.Capital__c != c.capital) { existing.Capital__c = c.capital; changed = true; }
                    if (existing.Region__c != c.region) { existing.Region__c = c.region; changed = true; }
                    if (existing.RegionalBlocs__c != regionalBlocsString) { existing.RegionalBlocs__c = regionalBlocsString; changed = true; }

                    if (changed) {
                        toUpdate.add(existing);
                    }
                } else {
                    Country__c newCountry = new Country__c(
                        Name = c.name,
                        Alpha2Code__c = c.alpha2Code,
                        Alpha3Code__c = c.alpha3Code,
                        Capital__c = c.capital,
                        Region__c = c.region,
                        RegionalBlocs__c = regionalBlocsString
                    );
                    toInsert.add(newCountry);
                }
            }

            if (!toInsert.isEmpty()) {
                insert toInsert;
            }

            if (!toUpdate.isEmpty()) {
                update toUpdate;
            }
        } else {
            System.debug('CountryLayer API error: ' + response.getStatusCode() + ' - ' + response.getBody());
        }
    }
}