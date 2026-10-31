from pathlib import Path
import re
import unittest
root=Path(__file__).resolve().parent
source=(root/'RPControlCenter.lua').read_text(encoding='utf-8')
class Contract(unittest.TestCase):
 def test_commands(self):
  for command in ('/rpconfig','/rpcc'): self.assertIn(command,source)
 def test_real_settings(self):
  for key in ('racialLanguageMode','groupLanguageMode','nativeEmotes','textChance','outputLanguage','chatChannel'):self.assertIn(key,source)
 def test_saved_options(self):
  self.assertIn('RPControlCenter_CharacterDB',(root/'RPControlCenter.toc').read_text())
  self.assertIn('previousChance',source)
 def test_title_matches_toc_version(self):
  toc=(root/'RPControlCenter.toc').read_text(encoding='utf-8')
  version=re.search(r'^## Version:\s*(\S+)',toc,re.MULTILINE)
  self.assertIsNotNone(version)
  self.assertIn(f'main.TitleText:SetText("RP Control Center {version.group(1)}")',source)
 def test_no_crossaddon_changes(self):
  for addon in ('RPChatMod','HexerRP','PaladinRP','JaegerRP','DruidenRP'):self.assertIn(addon,source)
if __name__=='__main__': unittest.main()
