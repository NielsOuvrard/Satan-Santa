extends Node

signal torch_visibility_changed(visible: bool)
signal key_collected(id: int)
signal torch_energy_changed(energy: float, max_energy: float)
signal door_interacted()
signal launch_computer_screen()
signal computer_screen_closed()
signal computer_unlocked(computer_id: int)
