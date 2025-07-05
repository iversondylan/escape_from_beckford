class_name RunStartup
extends Resource

enum StartupType {NEW_RUN, CONTINUED_RUN}

@export var startup_type: StartupType
@export var player_character: CombatantData
@export var deck: CardPile
