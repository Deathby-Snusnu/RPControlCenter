from pathlib import Path
import unittest

SOURCE = (Path(__file__).parent / "RPControlCenter.lua").read_text(encoding="utf-8")

class MageControlTests(unittest.TestCase):
    def test_mage_is_selectable(self):
        self.assertIn('{"MagierRP","MagierRP"}', SOURCE)
        self.assertIn('local addon = _G[selected]', SOURCE)

    def test_racial_chance_bound_to_selected_mage(self):
        self.assertIn('selected~="MagierRP"', SOURCE)
        self.assertIn('setSetting("racialTextChance"', SOURCE)
        self.assertIn('math.min(100', SOURCE)
        self.assertIn('math.max(0', SOURCE)

    def test_controls_disabled_without_mage(self):
        self.assertIn('controls.mageRaceMinus:SetEnabled(mage)', SOURCE)
        self.assertIn('controls.mageRacePlus:SetEnabled(mage)', SOURCE)

    def test_output_channel_hidden_for_mage(self):
        self.assertIn('controls.channelLabel=makeText(main,"Ausgabekanal"', SOURCE)
        self.assertIn('controls.channel,controls.channelFrame=dropdown', SOURCE)
        self.assertIn('if selected=="MagierRP" then', SOURCE)
        self.assertIn('controls.channelLabel:Hide()', SOURCE)
        self.assertIn('controls.channelFrame:Hide()', SOURCE)

if __name__ == "__main__":
    unittest.main()
