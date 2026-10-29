"""Static regression contract for tabbed GUI and ambient interval editor."""
from pathlib import Path
import unittest

SOURCE = (Path(__file__).resolve().parent / "RPControlCenter.lua").read_text(encoding="utf-8")

class ControlCenterTabs(unittest.TestCase):
    def test_tabs(self):
        for token in ('showTab("general")', 'showTab("ambient")', 'showTab("class")',
                      'tabRegions = {general={}, ambient={}, class={}}'):
            self.assertIn(token, SOURCE)

    def test_interval_controls(self):
        for token in ('"Min -30"', '"Min +30"', '"Max -30"', '"Max +30"',
                      'setSetting("ambientMinInterval",lower)',
                      'setSetting("ambientMaxInterval",upper)',
                      'a.ResetAmbientTimer()'):
            self.assertIn(token, SOURCE)
        self.assertIn('math.min(3600', SOURCE)
        self.assertIn('math.min(7200', SOURCE)

    def test_paladin_is_untouched(self):
        self.assertIn('{"PaladinRP","PaladinRP"}', SOURCE)
        self.assertIn('type(a.db.ambientEnabled)', SOURCE)

if __name__ == "__main__":
    unittest.main()
