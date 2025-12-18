/*
 * Adapter Registration
 *
 * Merkezi adapter registration sistemi.
 * Environment'a göre farklı adapter kombinasyonları sağlar.
 */

part of 'initialization_adapters.dart';

/*
 * NOT: Adapter'lar priority değerlerine göre otomatik sıralanır.
 * Registration sırası önemli değil, her adapter'ın kendi priority'si var.
 */
void registerInitializationAdapters() {
  AppInitializer.register(FirebaseInitializationAdapter());
  AppInitializer.register(DependencyInjectionAdapter());
  AppInitializer.register(FirebaseServicesAdapter());
  AppInitializer.register(UserPreferencesAdapter());
  AppInitializer.register(SystemUIAdapter());
}

void registerProductionAdapters() {
  registerInitializationAdapters();
}

void registerDevelopmentAdapters() {
  registerInitializationAdapters();
}

/*
 * NOT: Test ortamında minimal setup - sadece DI yeterli.
 * Firebase ve diğer external service'ler skip edilir.
 */
void registerTestAdapters() {
  AppInitializer.register(DependencyInjectionAdapter());
}
