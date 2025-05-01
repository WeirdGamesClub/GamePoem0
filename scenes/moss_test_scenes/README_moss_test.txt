moss_test_3D.tscn is the parent scene (Node3D) where everything happens
moss_test_3d.gd is the script attached to that scene.
- wrangles UI visiblity 
- calls setup_image from UI_drawing_interface on "new painting" button press
- calls finish_image from UI_drawing_interface on "accept" button press
- sends out signal with the finished image which is read by test_painting
(pipes image as a PackedBufferArray between those last two steps)

----------------

UI_drawing_interface.tscn and .gd are for the UI canvas that handles painting.
(it inherits from TextureRect) 
- calling setup_image sets up a new image. 
- calling finish_image returns the final image.
- there is a parameter for the brush path if you want to change that image

----------------

test_painting.tscn and .gd are the in-world painting object
(it is a MeshInstance3D)
- it listens for a signal from moss_test_3D 
- once the signal is received it updates its own texture
- parameter for which painting # it displays

----------------

OLD_DONOTUSE_moss_drawing_test.tscn is OLD, DO NOT USE

----------------

hope this helps. sorry if it doesnt
reach out with questions thats probably easier than reading this all
with love, moss <3
