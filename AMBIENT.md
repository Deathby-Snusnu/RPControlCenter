# Ambient-Konfiguration im RP Control Center 0.2.0

`/rpconfig` oeffnet das Fenster. Waehle JaegerRP, PaladinRP, DruidenRP oder HexerRP.

- Ambient an/aus: `ambientEnabled` im jeweiligen CharacterDB.
- Kampf an/aus: `ambientInCombat`.
- Chance: `ambientChance` in 10-Prozent-Schritten.
- Anzeige des bestehenden Mindest-/Hoechstintervalls; die genauen Werte setzt du ueber `/jrp ambient interval MIN MAX`, `/prp ambient interval ...`, `/drp ambient interval ...`, `/wrp ambient interval ...`.
- Test: Fuehrt eine durch den Klick ausgeloeste Ambient-Ausgabe aus. Cooldown und Klassenpruefung bleiben aktiv.

Wenn ein AddOn fehlt oder nicht bereit ist, bleiben dessen Ambient-Schalter deaktiviert. Einstellungen werden im eigenen SavedVariablesPerCharacter des jeweiligen Klassen-AddOns gespeichert.
