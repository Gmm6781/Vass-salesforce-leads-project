@isTest
public class LeadCountryTriggerTest {
    @isTest static void testLeadCountryTrigger() {
        // 1. Crear país de prueba
        Country__c testCountry = new Country__c(
            Name = 'Testland',
            Alpha2Code__c = 'TL',
            Alpha3Code__c = 'TST',
            Capital__c = 'Test City',
            Region__c = 'Test Region',
            RegionalBlocs__c = 'TBloc'
        );
        insert testCountry;

        // 2. Crear Lead con ese país
        Lead testLead = new Lead(
            LastName = 'Perez',
            Company = 'Test Company',
            Country = 'Testland'
        );

        // 3. Insertar Lead para activar trigger
        insert testLead;

        // 4. Consultar Lead insertado
        Lead insertedLead = [SELECT Country_Capital__c, Country_Region__c, Country_Blocs__c FROM Lead WHERE Id = :testLead.Id];

        // 5. Verificar que campos se llenaron
        System.assertEquals('Test City', insertedLead.Country_Capital__c);
        System.assertEquals('Test Region', insertedLead.Country_Region__c);
        System.assertEquals('TBloc', insertedLead.Country_Blocs__c);
    }
}