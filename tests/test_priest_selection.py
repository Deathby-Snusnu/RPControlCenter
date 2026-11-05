"""PriesterRP can be configured without being required for startup."""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
CODE = (ROOT / "RPControlCenter.lua").read_text(encoding="utf-8")
TOC = (ROOT / "RPControlCenter.toc").read_text(encoding="utf-8")

class PriestIntegrationTests(unittest.TestCase):
    def test_optional_priest_addon(self):
        self.assertIn('{"PriesterRP","PriesterRP"}', CODE)
        self.assertIn('PriesterRP', TOC.split('## OptionalDeps:', 1)[1])
        self.assertIn('local addon = _G[selected]', CODE)
    def test_priest_chance_and_ambient_controls(self):
        self.assertIn('selected~="PriesterRP"', CODE)
        self.assertIn('selected=="PriesterRP"', CODE)
        self.assertIn('selected == "PriesterRP" and key == "textChance"', CODE)
        self.assertIn('addon.ResetAmbientTimer()', CODE)
        self.assertIn('setSetting("racialTextChance"', CODE)
if __name__ == "__main__":
    unittest.main()
