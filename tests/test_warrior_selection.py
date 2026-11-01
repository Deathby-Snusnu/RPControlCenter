"""KriegerRP is optionally configurable without imposing a hard dependency."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]

class WarriorIntegrationTests(unittest.TestCase):
    def test_krieger_in_addon_picker(self):
        code = (ROOT / "RPControlCenter.lua").read_text(encoding="utf-8")
        toc = (ROOT / "RPControlCenter.toc").read_text(encoding="utf-8")
        self.assertIn('{"KriegerRP","KriegerRP"}', code)
        self.assertIn('"KriegerRP"', code)
        self.assertIn('MagierRP, KriegerRP', toc)
        self.assertIn('Volkstypische Fähigkeits- und Zaubertexte', code)
        self.assertIn('selected~="KriegerRP"', code)
        self.assertIn('selected=="KriegerRP"', code)

    def test_disabling_krieger_output_resets_ambient_timer(self):
        self.assertIn(
            'selected == "KriegerRP" and key == "textChance" and tonumber(value) == 0',
            (ROOT / "RPControlCenter.lua").read_text(encoding="utf-8"),
        )
        self.assertIn("addon.ResetAmbientTimer()", (ROOT / "RPControlCenter.lua").read_text(encoding="utf-8"))

if __name__ == "__main__":
    unittest.main()
