extends Control


func _ready() -> void:
	$screenShake/amount.text = str(Global.screenShake)
	$screenShake/HSlider.value = Global.screenShake
	
	$sfxSlider/amount2.text = str(Global.sfxVolume)
	$sfxSlider/sfx.value = Global.sfxVolume
	
	$musicSlider/amount3.text = str(Global.musicVolume)
	$musicSlider/music.value = Global.musicVolume

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	Global.screenShake = $screenShake/HSlider.value
	ConfigFileController.saveSetting("screenShake", $screenShake/HSlider.value)
	$screenShake/amount.text = str(Global.screenShake)

func _on_sfx_drag_ended(value_changed: bool) -> void:
	Global.sfxVolume = $sfxSlider/sfx.value
	ConfigFileController.saveSetting("sfxVolume", $sfxSlider/sfx.value)
	$sfxSlider/amount2.text = str(Global.sfxVolume)

func _on_music_drag_ended(value_changed: bool) -> void:
	Global.musicVolume = $musicSlider/music.value
	ConfigFileController.saveSetting("musicVolume", $musicSlider/music.value)
	$musicSlider/amount3.text = str(Global.musicVolume)
