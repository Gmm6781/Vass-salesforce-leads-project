public class CountryScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        CountryLayerService.fetchCountries(); // Llama al método que trae y actualiza países
    }
}