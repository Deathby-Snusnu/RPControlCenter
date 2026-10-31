# Ambient-Konfiguration im RP Control Center 0.3.0

`/rpconfig` oeffnet das Fenster. Waehle JaegerRP, PaladinRP, DruidenRP oder HexerRP.

- Ambient an/aus: `ambientEnabled` im jeweiligen CharacterDB.
- Kampf an/aus: `ambientInCombat`.
- Chance: `ambientChance` in 10-Prozent-Schritten.
- Mindest-/Hoechstintervall anzeigen und mit `Min -30`, `Min +30`, `Max -30`
  und `Max +30` in 30-Sekunden-Schritten aendern. Das Minimum liegt zwischen
  30 und 3600, das Maximum zwischen 30 und 7200 Sekunden; bei Bedarf wird
  die andere Grenze mit angepasst. Genaue Werte koennen auch ueber
  `/jrp ambient interval MIN MAX`, `/prp ambient interval ...`,
  `/drp ambient interval ...` oder `/wrp ambient interval ...` gesetzt werden.
- Test: Fuehrt eine durch den Klick ausgeloeste Ambient-Ausgabe aus. Cooldown und Klassenpruefung bleiben aktiv.

Wenn ein AddOn fehlt oder nicht bereit ist, bleiben dessen Ambient-Schalter deaktiviert. Einstellungen werden im eigenen SavedVariablesPerCharacter des jeweiligen Klassen-AddOns gespeichert.

MagierRP besitzt kein entsprechendes Timer-System und keine dieser
Ambient-Einstellungen. Der Testknopf ruft bei geladenem MagierRP dessen
manuelles `TryAmbient` auf; Textchance und Cooldown gelten dabei weiterhin.
