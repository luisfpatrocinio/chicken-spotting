extends CanvasLayer

func _ready():
	# levelRef.winners é um array[int] que guarda os indices dos jogadores vencedores.
	# Obter texto a partir do level.winners
	if len(Global.levelRef.winners) == 1:
		# Apenas um jogador venceu:
		$Label.text = "Player %d is the winner!" % [Global.levelRef.winners[0] + 1]
	elif len(Global.levelRef.winners) > 1:
		# Mais de um jogador venceu:
		var winners_text = "Players"
		for i in range(len(Global.levelRef.winners)):
			if i == len(Global.levelRef.winners) - 1:
				winners_text += " and %d" % [Global.levelRef.winners[i] + 1]
			elif i == 0:
				winners_text += " %d" % [Global.levelRef.winners[i] + 1]
			else:
				winners_text += ", %d" % [Global.levelRef.winners[i] + 1]
		$Label.text = "%s are the winners!" % winners_text
	else:
		# Nenhum jogador venceu.
		$Label.text = "No winners this time."

