@isTest
public class CountryLayerServiceTest {
    @isTest static void testFetchCountries() {
        // 1. Configurar la simulación de llamada a API
        Test.setMock(HttpCalloutMock.class, new CountryLayerMock());

        // 2. Llamar al método que trae y guarda países
        Test.startTest();
        CountryLayerService.fetchCountries();
        Test.stopTest();

        // 3. Verificar que el país "Testland" fue creado con los datos correctos
        Country__c c = [SELECT Name, Alpha2Code__c, Alpha3Code__c, Capital__c, Region__c, RegionalBlocs__c FROM Country__c WHERE Name = 'Testland' LIMIT 1];

        System.assertEquals('TL', c.Alpha2Code__c);
        System.assertEquals('TST', c.Alpha3Code__c);
        System.assertEquals('Test City', c.Capital__c);
        System.assertEquals('Test Region', c.Region__c);
        System.assertEquals('TBloc', c.RegionalBlocs__c);
    }
}