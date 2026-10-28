# RP Control Center 0.2.0

Zentrales Ingame-Fenster für RPChatMod, HexerRP, PaladinRP, JaegerRP, DruidenRP und MagierRP (sobald installiert).

## Installation

Kopiere `RPControlCenter` neben die fünf anderen AddOn-Ordner in `Interface/AddOns`. Aktiviere es in der AddOn-Auswahl. Öffne es mit `/rpconfig` oder `/rpcc`.

## Einstellungen

- AddOn-Auswahl: stellt die **echten** pro Charakter gespeicherten Einstellungen des ausgewählten AddOns dar.
- RP-Textausgabe: setzt `textChance` auf 0; bei Wiederaktivierung wird der vorherige positive Wert wiederhergestellt. Emote-Animationen können weiter ausgeführt werden.
- Textchance: ±10 Prozentpunkte; Textsprache: `outputLanguage`; Ausgabekanal: `chatChannel`.
- RPChatMod: `racialLanguageMode` (`auto/on/off`), `groupLanguageMode` (`on/off`), `nativeEmotes`.
- Ambient: aktivieren, Kampf-Freigabe, Chance in 10-Prozent-Schritten,
  Intervallanzeige und Test für unterstützte Ambient-AddOns. Das Intervall
  wird weiterhin über den Slash-Befehl des jeweiligen AddOns eingestellt.
  Details stehen in
  [AMBIENT.md](AMBIENT.md).
- Diagnose: meldet **nur Einstellungsänderungen durch das Control Center**, kein systemweites Debugging.
- Sprachstatus: ruft die bestehende Diagnose `/rc languagestatus` auf.

Die Optionen der fünf AddOns bleiben in ihren ursprünglichen `SavedVariablesPerCharacter` gespeichert. Das Control Center speichert nur Diagnosemodus und zuletzt verwendete Textchancen in `RPControlCenter_CharacterDB`. Änderungen über Slash-Befehle werden beim erneuten Öffnen aktualisiert.

## MagierRP

MagierRP erscheint in der AddOn-Auswahl. Für ein geladenes MagierRP gibt es die
Einstellung **volkstypische Zaubertexte** (0 bis 100 % in Schritten von 10 %).
Diese Änderung wird pro Charakter in den MagierRP-SavedVariables gespeichert.
Ohne installiertes/geladenes MagierRP sind die Bedienelemente deaktiviert.
Die MagierRP-Integration benötigt eine MagierRP-Version, die `racialTextChance`
in ihrer Charakterdatenbank und `_G.MagierRP` bereitstellt (parallel im
RPTextStudio-PR #34). Der Client-Test steht noch aus.

## Grenzen

Dies ist eine erste WoW-Forever-16001-GUI. Nicht alle Bedienelemente sind deaktiviert, wenn ein AddOn fehlt (Textlisten werden jedoch nicht verändert). Die Spracheinstellung für die Ausgabe ist **nicht** die WoW-Volkssprache. `GROUP` als Kanal wird nur angeboten, wenn das jeweilige AddOn ihn unterstützt. Keine automatische Zaubererkennung, keine Textbearbeitung, kein automatisches globales Debug-Logging.

## Backup

Vor der Installation vorhandene AddOn-Ordner und den `WTF`-Ordner sichern. Das Gesamtpaket wird als neue ZIP geliefert; die bestehenden Quellcodedateien der fünf AddOns werden nicht geändert. Im Spiel persistiert WoW SavedVariables beim Ausloggen/Reload.

## Test im Spiel

1. `/rpconfig`, alle fünf AddOns durchschalten.
2. RPChatMod: Volkssprache `auto`, Gruppensprache aktivieren, mit `/rc languagestatus` testen.
3. RP-Ausgabe deaktivieren, Chat-Text kontrollieren und anschließend wieder aktivieren.
4. `/reload`, gespeicherte Werte kontrollieren.
5. Fehlende AddOns durch vorübergehendes Deaktivieren testen.

## Lizenz

Code MPL-2.0, siehe `LICENSE`.
