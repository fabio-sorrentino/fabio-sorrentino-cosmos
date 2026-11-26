# COSMOS CINEMA

App mobile in Flutter per scoprire film e serie TV. Mostra i titoli popolari, in uscita e più votati, permette di cercarli, di consultare il cast e la scheda degli attori, e di organizzarli in tre liste personali: **preferiti**, **da guardare** e **già visti**. I dati arrivano in tempo reale dall'API di [The Movie Database (TMDB)](https://www.themoviedb.org/).

Il progetto è stato realizzato per il corso di programmazione Flutter e segue il design creato in Figma, con tema scuro e tema chiaro.

## Funzionalità

- **Login** con controllo dei campi (campi vuoti, email non valida, credenziali errate) e messaggio di errore.
- **Home** con la card "Continua a guardare" e due sezioni a scorrimento orizzontale: film più visti e serie più viste.
- **Catalogo** con ricerca per titolo, filtro per tipo (Tutti, Film, Serie TV) e per categoria (Popolari, In uscita, Più votati) scelta da un pannello a comparsa, in griglia a 3 colonne.
- **Dettaglio** di un film o di una serie: locandina, titolo, tipo, anno, voto, trama e **cast**. Da qui si aggiunge ai preferiti, alla watchlist o ai titoli visti.
- **Cast**: sotto la trama, una riga scorrevole con foto, nome e personaggio interpretato dei primi 15 attori. Se la foto manca compare un'icona.
- **Scheda attore**: toccando un attore si apre la sua pagina con foto, nome, data e luogo di nascita, biografia e l'elenco dei suoi film e serie TV più popolari. Toccando una locandina si apre il Dettaglio di quel titolo, quindi si può passare da film ad attore e viceversa.
- **La mia lista** (watchlist), divisa tra film e serie.
- **Preferiti**, raggiungibili dal cuore in alto nella Home. I titoli preferiti mostrano un cuore pieno sulla locandina.
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
- **shared_preferences** per salvare le liste sul dispositivo
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
│   ├── movie.dart             # Modello unico per film e serie
│   ├── cast_member.dart       # Attore nel cast: id, nome, personaggio, foto
│   └── person.dart            # Dati dell'attore: biografia, nascita
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
│   ├── actor_screen.dart      # Scheda dell'attore
│   ├── watchlist_screen.dart
│   ├── favorites_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
└── widgets/                   # Componenti riutilizzabili
    ├── main_shell.dart        # Contenitore con barra di navigazione
    ├── movie_poster.dart      # Locandina o card di un film
    ├── cast_section.dart      # Riga del cast nel Dettaglio
    ├── primary_button.dart
    └── custom_text_field.dart
```

## Come funziona

1. **`TmdbService`** scarica da TMDB sei elenchi: film e serie popolari, film in uscita e serie in onda, film e serie più votati. Ogni risposta JSON viene convertita in oggetti `Movie`. Se una trama italiana manca, viene recuperata in inglese.
2. **`MoviesProvider`** chiama il servizio all'avvio (`loadAll`), tiene gli elenchi in memoria ed espone `isLoading` ed `errorMessage`. Le schermate si ridisegnano da sole quando i dati cambiano.
3. **`UserListsProvider`** gestisce le liste dell'utente. Ogni titolo è identificato da una chiave che unisce tipo e id (per esempio `movie_550` o `tv_550`), perché un film e una serie possono avere lo stesso id su TMDB. Le liste sono salvate sul dispositivo con `shared_preferences`, separate per email, e si ricaricano al login.
4. **`CastSection`** viene creata dal Dettaglio e scarica il cast del titolo una sola volta, all'apertura. Se la richiesta fallisce o il cast è vuoto, la sezione non compare.
5. **`ActorScreen`** riceve un `CastMember` e scarica in parallelo i dati della persona e la sua filmografia. Foto e nome sono già disponibili dal cast, quindi compaiono subito.
6. **`MainShell`** mostra una sola schermata alla volta tra Home, Catalogo, Lista e Profilo, con una barra di navigazione flottante personalizzata.
7. **`AppTheme`** definisce una volta sola colori, testi, pulsanti e campi per i due temi. `ThemeProvider` decide quale applicare.

## Endpoint TMDB utilizzati

| Uso nell'app | Endpoint |
| --- | --- |
| Film popolari | `movie/popular` |
| Serie popolari | `tv/popular` |
| Film in uscita | `movie/upcoming` |
| Serie in onda | `tv/on_the_air` |
| Film più votati | `movie/top_rated` |
| Serie più votate | `tv/top_rated` |
| Cast di un film o di una serie | `movie/{id}/credits`, `tv/{id}/credits` |
| Dati di un attore | `person/{id}` |
| Film e serie di un attore | `person/{id}/combined_credits` |

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
- Le liste sono salvate solo sul dispositivo: cambiando telefono o disinstallando l'app si perdono. Il tema scelto non viene ancora ricordato alla chiusura.
- La card "Continua a guardare" mostra per ora un titolo popolare scelto in modo provvisorio, non uno storico reale.
- Il catalogo carica solo la prima pagina di risultati per ogni categoria.
- Il cast mostra al massimo 15 attori, e la filmografia di un attore al massimo 15 titoli con locandina.
- Per alcuni attori TMDB non ha la biografia in italiano: in quel caso compare quella inglese, e se manca anche quella compare "Biografia non disponibile".
- Mancano test automatici, navigazione con rotte con nome e adattamento a schermi grandi.

## Crediti

Questo prodotto usa l'API di TMDB ma non è approvato né certificato da TMDB.