extends Node

const DEBUG: bool = false

const TILE_SIZE : int = 96
const MIN_ROW_LENGTH: int = 10 if DEBUG else 2
const EFFECT_SPAWN_CHANCE: float = 1.0 if DEBUG else 0.3
const EFFECT_SPAWN_MARGIN: float = TILE_SIZE # omit the view left and right margins

const DISABLE_WINNING : bool = DEBUG
const HORIZONTAL_DELETION_THRESHOLD = 1200
