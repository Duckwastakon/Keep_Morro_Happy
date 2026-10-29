extends RichTextLabel


func setText(text):
	self.clear()
	self.append_text("[wobbly wave=10]" + text + "[wobbly]")
