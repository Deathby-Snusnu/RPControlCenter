from pathlib import Path
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
 def test_no_crossaddon_changes(self):
  for addon in ('RPChatMod','HexerRP','PaladinRP','JaegerRP','DruidenRP'):self.assertIn(addon,source)
if __name__=='__main__': unittest.main()
