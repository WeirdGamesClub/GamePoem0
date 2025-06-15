extends Node

var wave1_count : int = 0
var wave2_count : int = 0
var wave3_count : int = 0
var wave4_count : int = 0

signal new_wave(int)

var current_wave = 1

func pickup(wave : int)->void:
	match(wave):
		1 : wave1_count += 1
		2 : wave2_count += 1
		3 : wave3_count += 1
		4 : wave4_count += 1
		
	match(current_wave):
		1: if(wave1_count >= 1):
			new_wave.emit(2)
			current_wave = 2
		2: if(wave2_count >= 2):
			new_wave.emit(3)
			current_wave = 3
		3: if(wave3_count >= 2):
			new_wave.emit(4)
			current_wave = 4
		4: if(wave4_count >= 1):
			new_wave.emit(5)
			current_wave = 5
