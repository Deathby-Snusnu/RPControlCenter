# RP Control Center 0.3.0

Zentrales Ingame-Fenster für RPChatMod, HexerRP, PaladinRP, JaegerRP, DruidenRP MagierRP und KriegerRP (sobald installiert).

## Installation

Kopiere `RPControlCenter` neben die gewünschten Text-AddOns in
`Interface/AddOns`. Aktiviere es in der AddOn-Auswahl. Öffne es mit
`/rpconfig` oder `/rpcc`; die anderen AddOns sind optional.

## Einstellungen

- AddOn-Auswahl: stellt die **echten** pro Charakter gespeicherten Einstellungen des ausgewählten AddOns dar.
- RP-Textausgabe: setzt `textChance` auf 0; bei Wiederaktivierung wird der vorherige positive Wert wiederhergestellt. Emote-Animationen können weiter ausgeführt werden.
- Textchance: ±10 Prozentpunkte; Textsprache: `outputLanguage`; Ausgabekanal: `chatChannel`.
- RPChatMod: `racialLanguageMode` (`auto/on/off`), `groupLanguageMode` (`on/off`), `nativeEmotes`.
- Ambient: aktivieren, Kampf-Freigabe, Chance in 10-Prozent-Schritten,
  Intervalländerung in 30-Sekunden-Schritten und Test für unterstützte
  Ambient-AddOns. Die Intervalle lassen sich auch über die Slash-Befehle
  der jeweiligen AddOns setzen. Details stehen in [AMBIENT.md](https://github.com/Deathby-Snusnu/RPAddOns/blob/main/docs/AMBIENT-HANDBUCH.md).
- Diagnose: meldet **nur Einstellungsänderungen durch das Control Center**, kein systemweites Debugging.
- Sprachstatus: ruft die bestehende Diagnose `/rc languagestatus` auf.

Die Optionen der ausgewählten Text-AddOns bleiben in ihren ursprünglichen
`SavedVariablesPerCharacter` gespeichert. Das Control Center speichert nur
Diagnosemodus und zuletzt verwendete Textchancen in
`RPControlCenter_CharacterDB`. Änderungen über Slash-Befehle werden beim
erneuten Öffnen aktualisiert. Die Bereiche heißen **Allgemein**, **Ambient**
und **Klasse**.

## MagierRP

MagierRP erscheint in der AddOn-Auswahl. Für ein geladenes MagierRP gibt es die
Einstellung **volkstypische Zaubertexte** (0 bis 100 % in Schritten von 10 %).
Diese Änderung wird pro Charakter in den MagierRP-SavedVariables gespeichert.
Ohne geladenes und bereites MagierRP ist diese Einstellung deaktiviert.
MagierRP unterstützt den Ausgabekanal `chatChannel` und das konfigurierbare
Ambient-System mit Aktivierung, Kampf-Freigabe, Chance, Intervall und Test.
Die passenden Felder werden angezeigt, wenn MagierRP geladen und bereit ist. Die Integration benötigt
`racialTextChance` in der Charakterdatenbank und `_G.MagierRP`. Ein
Client-Test bleibt erforderlich.

## Grenzen

Dies ist eine erste WoW-Forever-16001-GUI. Nicht alle Bedienelemente sind
deaktiviert, wenn ein AddOn fehlt. Die Textsprache ist **nicht** die
WoW-Volkssprache. Die Kanalliste zeigt `GROUP` auch bei AddOns an, die diesen
Wert nicht unterstützen; `GROUP` nur für RPChatMod verwenden und ansonsten
die gültigen Kanäle der jeweiligen AddOn-README beachten. Keine automatische
Zaubererkennung, Textbearbeitung oder automatisches globales Debug-Logging.

## Backup

Vor der Installation vorhandene AddOn-Ordner und den `WTF`-Ordner sichern.
Das Control Center ändert keine Textlisten oder Quellcodedateien der anderen
AddOns. Im Spiel persistiert WoW SavedVariables beim Ausloggen/Reload.

## Test im Spiel

1. `/rpconfig`, die sechs auswählbaren Text-AddOns durchschalten, insbesondere MagierRP und seine Kanalauswahl.
2. RPChatMod: Volkssprache `auto`, Gruppensprache aktivieren, mit `/rc languagestatus` testen.
3. RP-Ausgabe deaktivieren, Chat-Text kontrollieren und anschließend wieder aktivieren.
4. `/reload`, gespeicherte Werte kontrollieren.
5. Fehlende AddOns durch vorübergehendes Deaktivieren testen.

## Lizenz

Code MPL-2.0, siehe `LICENSE`.

## KriegerRP

KriegerRP erscheint in der AddOn-Auswahl, sobald es installiert und geladen
ist. Unter **Klasse** kann dieselbe volkstypische Textchance wie beim Magier
geändert werden. Sprache, Chatkanal, Textchance und Cooldown bleiben
charakterbezogene Einstellungen in `KriegerRP_CharacterDB`.

KriegerRP wird in einem eigenständigen GitHub-Repository entwickelt:
[Deathby-Snusnu/KriegerRP](https://github.com/Deathby-Snusnu/KriegerRP).
RPAddOns bindet es als Git-Submodul ein.

### KriegerRP: Ambient und volkstypische Texte

Bei Auswahl von KriegerRP kann die Seite **Klasse** die Chance auf
volkstypische Texte verändern. Die Seite **Ambient** steuert
`ambientEnabled`, Kampffreigabe, Chance und Intervall. Ein Reset von
`KriegerRP.ResetAmbientTimer()` verwirft ausstehende Timerzustände.

**Wichtig:** KriegerRP verwendet ab dem angepassten Stand in
[KriegerRP PR #1](https://github.com/Deathby-Snusnu/KriegerRP/pull/1)
dieselbe wartende Ambient-Ausgabe wie die älteren Klassen-AddOns:
Ein Timer sendet keinen Chat. Der Text erscheint erst anlässlich
eines aktiv ausgelösten RP-Befehls.

Neue Krieger-Charaktere starten mit 30 % Textchance, 20 Sekunden
Cooldown und aktivierter Ambient-Vormerkung (180 bis 420 Sekunden).
Vorhandene SavedVariables werden nicht pauschal überschrieben.
Siehe das [KriegerRP-Ambient-Handbuch](https://github.com/Deathby-Snusnu/KriegerRP/blob/feature/initial-warrior-addon/AMBIENT.md).
