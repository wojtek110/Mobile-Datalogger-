#  Mobile DataLogger

Aplikacja mobilna do rejestrowania danych z czujników telefonu wraz z trasą GPS, zbudowana w technologii Flutter. Projekt był częścią mojej pracy inżynierskiej pt.  
**"Aplikacja rejestratora danych na urządzenia mobilne z wykorzystaniem technologii Flutter"**.

##  O projekcie

Mobile DataLogger to aplikacja umożliwiająca zbieranie i zapisywanie danych z czujników urządzenia mobilnego w czasie rzeczywistym. Użytkownik widzi swoją trasę na mapie Google, a aplikacja zbiera dane z czujników i zapisuje je lokalnie lub w Firebase Realtime Database.

##  Kluczowe funkcje

-  Integracja z Mapami Google — wyświetlanie bieżącej lokalizacji i rysowanie pokonanej trasy
-  Odczyt danych z czujników telefonu:
  - Akcelerometr
  - Żyroskop
  - Magnetometr
  - Czujnik światła
  - GPS (prędkość, wysokość, dokładność)
-  Możliwość zapisu danych:
  - lokalnie w pliku (np. CSV lub JSON)
  - w chmurze (Firebase Realtime Database)
-  Uprawnienia i zarządzanie dostępem do czujników
-  Rejestrowanie danych w czasie rzeczywistym za pomoca dynamicznych wykresów 

##  Technologie

- Flutter (Dart)
- Google Maps API
- Firebase Realtime Database
- Pakiety Fluttera:
  - `google_maps_flutter`
  - `firebase_database`
  - `sensors_plus`
  - `geolocator`
  - i inne
