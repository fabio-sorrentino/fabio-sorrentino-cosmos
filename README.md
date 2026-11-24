# COSMOS CINEMA

App mobile in Flutter per scoprire film e serie TV. Mostra i titoli popolari, in uscita e più votati, permette di cercarli e di organizzarli in tre liste personali: **preferiti**, **da guardare** e **già visti**. I dati arrivano in tempo reale dall'API di [The Movie Database (TMDB)](https://www.themoviedb.org/).

Il progetto è stato realizzato per il corso di programmazione Flutter e segue il design creato in Figma, con tema scuro e tema chiaro.

## Funzionalità

- **Login** con controllo dei campi (campi vuoti, email non valida, credenziali errate) e messaggio di errore.
- **Home** con la card "Continua a guardare" e due sezioni a scorrimento orizzontale: film più visti e serie più viste.
- **Catalogo** con ricerca per titolo, filtro per tipo (Tutti, Film, Serie TV) e per categoria (Popolari, In uscita, Più votati), in griglia a 3 colonne.
- **Dettaglio** di un film o di una serie: locandina, titolo, tipo, anno, voto e trama. Da qui si aggiunge ai preferiti, alla watchlist o ai titoli visti.
- **La mia lista** (watchlist), divisa tra film e serie.
- **Preferiti**, raggiungibili dal cuore in alto nella Home.
- **Profilo** con avatar, statistiche (film visti, serie viste, preferiti), impostazioni e logout.
- **Impostazioni** per cambiare tema chiaro o scuro.
- Gestione di **caricamento** ed **errori** di rete, con pulsante "Riprova".

## Credenziali demo

Il login non usa un server: confronta i dati inseriti con un utente di prova definito in `lib/data/demo_user.dart`.

| Campo    | Valore            |
| -------- | ----------------- |
| Email    | fabio@gmail.com   |
| Password | cosmos123         |

## Tecnologie

- **Flutter** e **Dart** (Material 3)
- **provider** per la gestione dello stato
- **http** per le chiamate REST a TMDB
- Font **Inter**

## Struttura del progetto

```
lib/
├── main.dart                  # Avvio app, provider e tema
├── config/
│   └── api_keys.dart          # Token TMDB (non da condividere)
├── data/
│   └── demo_user.dart         # Utente di prova per il login
├── models/
│   └── movie.dart             # Modello unico per film e serie
├── services/
│   └── tmdb_service.dart      # Chiamate all'API TMDB
├── providers/
│   ├── movies_provider.dart   # Elenchi scaricati da TMDB, loading ed errori
│   ├── user_lists_provider.dart # Preferiti, watchlist e visti
│   └── theme_provider.dart    # Tema chiaro o scuro
├── theme/
│   └── app_theme.dart         # Colori e temi dell'app
├── screens/                   # Una schermata per file
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── catalog_screen.dart
│   ├── detail_screen.dart
│   ├── watchlist_screen.dart
│   ├── favorites_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
└── widgets/                   # Componenti riutilizzabili
    ├── main_shell.dart        # Contenitore con barra di navigazione
    ├── movie_poster.dart      # Locandina o card di un film
    ├── primary_button.dart
    └── custom_text_field.dart
```

## Come funziona

1. **`TmdbService`** scarica da TMDB sei elenchi: film e serie popolari, film in uscita e serie in onda, film e serie più votati. Ogni risposta JSON viene convertita in oggetti `Movie`.
2. **`MoviesProvider`** chiama il servizio all'avvio (`loadAll`), tiene gli elenchi in memoria ed espone `isLoading` ed `errorMessage`. Le schermate si ridisegnano da sole quando i dati cambiano.
3. **`UserListsProvider`** gestisce le liste dell'utente. Ogni titolo è identificato da una chiave che unisce tipo e id (per esempio `movie_550` o `tv_550`), perché un film e una serie possono avere lo stesso id su TMDB.
4. **`MainShell`** mostra una sola schermata alla volta tra Home, Catalogo, Lista e Profilo, con una barra di navigazione flottante personalizzata.
5. **`AppTheme`** definisce una volta sola colori, testi, pulsanti e campi per i due temi. `ThemeProvider` decide quale applicare.

## Come avviare il progetto

**Requisiti:** Flutter installato e un emulatore o un dispositivo collegato.

1. Scarica il progetto e apri la cartella nel terminale.
2. Installa le dipendenze:
   ```
   flutter pub get
   ```
3. Crea un account gratuito su [TMDB](https://www.themoviedb.org/) e copia il tuo **API Read Access Token** (si trova in Impostazioni, sezione API).
4. Crea il file `lib/config/api_keys.dart` con questo contenuto, sostituendo il testo con il tuo token:
   ```dart
   class ApiKeys {
     static const tmdbToken = 'INCOLLA_QUI_IL_TUO_TOKEN';
   }
   ```
5. Avvia l'app:
   ```
   flutter run
   ```

> Il file `api_keys.dart` contiene una chiave personale: non va caricato su GitHub né condiviso. Se è già stato condiviso, rigenera il token dal tuo account TMDB.

## Limiti noti e possibili sviluppi

- Il login è dimostrativo: usa un solo utente fisso e non c'è un vero account.
- Preferiti, watchlist e titoli visti sono salvati solo in memoria e si azzerano alla chiusura dell'app. Si potrebbero salvare sul dispositivo.
- La card "Continua a guardare" mostra per ora un titolo popolare scelto in modo provvisorio, non uno storico reale.
- Il catalogo carica solo la prima pagina di risultati per ogni categoria.
- Mancano test automatici, navigazione con rotte con nome e adattamento a schermi grandi.

## Crediti

Questo prodotto usa l'API di TMDB ma non è approvato né certificato da TMDB.