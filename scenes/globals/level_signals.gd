extends Node3D

signal pickup_signal(prompt:PromptResource)
signal change_color(color:Color)
signal start_erasing()

signal prompt_added(reference:Node3D)
signal prompt_removed(reference:Node3D)

signal desaturate()
signal resaturate()
