extends Node

signal torch_visibility_changed(visible: bool)
signal key_collected(id: int)
signal torch_energy_changed(energy: float, max_energy: float)
signal door_interacted()
signal launch_computer_screen(frame_id: int)
signal computer_screen_closed(computer_id: int, success: bool)
signal computer_unlocked(computer_id: int)
signal player_caught()
signal screamer_finished()
signal player_locked()
signal player_unlocked()
