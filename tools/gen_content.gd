extends SceneTree
## Content authoring pipeline: run with
##   godot --headless --path . --script res://tools/gen_content.gd
## to (re)generate the .tres data files under narrative/, combat/, etc.
## Safe to re-run — every save overwrites its target path idempotently.
## Editing content by hand afterward directly in the .tres is also fine;
## this script is just the safest way to author nested resource arrays.

func _init() -> void:
	gen_maelle()
	print("Content generation complete.")
	quit()


func gen_maelle() -> void:
	var char_data := CharacterData.new()
	char_data.id = &"maelle"
	char_data.character_name = "Maëlle"
	char_data.age = 19
	char_data.personality = "joyeuse, calme, curieuse, spontanée"
	char_data.schedule = [
		{"hour": 6, "location": "Foret_Aube - clairière", "activity": "cherche le fragment"},
		{"hour": 19, "location": "Foret_Aube - lisière", "activity": "rentre vers le village"},
	]
	char_data.dialogue_tree_path = "res://narrative/Dialogue/content/dialogue_maelle_premiere_rencontre.tres"
	char_data.quest_ids = [&"aider_le_chevalier"]
	char_data.placeholder_color = Color(0.85, 0.55, 0.75, 1.0)
	char_data.max_health = 25.0
	char_data.can_die = true
	ResourceSaver.save(char_data, "res://narrative/Characters/maelle.tres")

	var keyword := KeywordData.new()
	keyword.id = &"curiosite"
	keyword.display_name = "Curiosité"
	keyword.concept = "Ce qui pousse à comprendre plutôt qu'à fuir."
	keyword.description = "Un mot appris auprès de Maëlle. Rend certains dialogues et certaines faiblesses accessibles."
	keyword.damage_multiplier_vs_tag = 1.3
	keyword.vs_trauma_tag = &"peur"
	keyword.dialogue_tag = &"curiosite"
	ResourceSaver.save(keyword, "res://combat/Keywords/curiosite.tres")

	var quest := QuestData.new()
	quest.id = &"aider_le_chevalier"
	quest.title = "Aider le chevalier"
	quest.summary = "Maëlle veut présenter l'Anomalie à Victor, le chevalier du village, après la réaction étrange du fragment."
	quest.giver_character_id = &"maelle"
	quest.available_from_day = 1
	quest.available_until_day = 3
	quest.available_from_hour = 0
	quest.available_until_hour = 24
	ResourceSaver.save(quest, "res://narrative/Quests/aider_le_chevalier.tres")

	var choice_explique := DialogueChoice.new()
	choice_explique.text = "Un éclat de lumière ?"
	choice_explique.target_line_id = &"explique_fragment"

	var choice_pas_vu := DialogueChoice.new()
	choice_pas_vu.text = "Je viens d'arriver, désolé."
	choice_pas_vu.target_line_id = &"pas_vu"

	var line_intro := DialogueLine.new()
	line_intro.line_id = &"intro"
	line_intro.speaker = "Maëlle"
	line_intro.text = "Oh ! Je ne m'attendais pas à croiser quelqu'un ici... Tu n'as pas vu un éclat de lumière tomber par ici ? Je le cherche depuis ce matin."
	line_intro.sets_flags = [&"event/maelle_met"]
	line_intro.choices = [choice_explique, choice_pas_vu]

	var line_explique := DialogueLine.new()
	line_explique.line_id = &"explique_fragment"
	line_explique.speaker = "Maëlle"
	line_explique.text = "Oui ! Un fragment magique, il réagit à... enfin, à des choses particulières. C'est pour mon apprentissage. Attends... tu dégages quelque chose d'étrange."
	line_explique.auto_next_line_id = &"reaction_fragment"

	var line_pas_vu := DialogueLine.new()
	line_pas_vu.line_id = &"pas_vu"
	line_pas_vu.speaker = "Maëlle"
	line_pas_vu.text = "Pas grave, je vais continuer à chercher. Au fait, moi c'est Maëlle !"
	line_pas_vu.auto_next_line_id = &"reaction_fragment"

	var line_reaction := DialogueLine.new()
	line_reaction.line_id = &"reaction_fragment"
	line_reaction.speaker = "Maëlle"
	line_reaction.text = "(Le fragment dans sa poche se met à vibrer et à scintiller faiblement.) ...Tu as vu ça ?"
	line_reaction.triggers_glitch = true
	line_reaction.grants_item_id = &"fragment_de_maelle"
	line_reaction.sets_flags = [&"event/fragment_reacts"]
	line_reaction.auto_next_line_id = &"propose_village"

	var choice_accepte := DialogueChoice.new()
	choice_accepte.text = "D'accord, allons-y."
	choice_accepte.sets_flags = [&"quest/aider_le_chevalier/accepted"]
	choice_accepte.starts_quest_id = &"aider_le_chevalier"
	choice_accepte.target_line_id = &"accepte"

	var choice_refuse := DialogueChoice.new()
	choice_refuse.text = "Je préfère explorer un peu par ici d'abord."
	choice_refuse.target_line_id = &"refuse"

	var choice_curiosite := DialogueChoice.new()
	choice_curiosite.text = "Qu'est-ce que tu crains exactement ?"
	choice_curiosite.target_line_id = &"curiosite"

	var line_propose := DialogueLine.new()
	line_propose.line_id = &"propose_village"
	line_propose.speaker = "Maëlle"
	line_propose.text = "Je ne sais pas ce que c'est, mais je n'aime pas ça. Il y a un chevalier au village, Victor, il pourrait nous aider à comprendre. Tu viens avec moi ?"
	line_propose.choices = [choice_accepte, choice_refuse, choice_curiosite]

	var line_accepte := DialogueLine.new()
	line_accepte.line_id = &"accepte"
	line_accepte.speaker = "Maëlle"
	line_accepte.text = "Parfait, suis-moi quand tu veux, je ne suis pas loin."

	var line_refuse := DialogueLine.new()
	line_refuse.line_id = &"refuse"
	line_refuse.speaker = "Maëlle"
	line_refuse.text = "Comme tu veux ! Je resterai dans le coin un moment."

	var choice_accepte2 := DialogueChoice.new()
	choice_accepte2.text = "D'accord, allons-y."
	choice_accepte2.sets_flags = [&"quest/aider_le_chevalier/accepted"]
	choice_accepte2.starts_quest_id = &"aider_le_chevalier"
	choice_accepte2.target_line_id = &"accepte"

	var choice_refuse2 := DialogueChoice.new()
	choice_refuse2.text = "Pas tout de suite."
	choice_refuse2.target_line_id = &"refuse"

	var line_curiosite := DialogueLine.new()
	line_curiosite.line_id = &"curiosite"
	line_curiosite.speaker = "Maëlle"
	line_curiosite.text = "Je crains de ne jamais savoir. Comprendre vaut mieux que fuir, tu ne crois pas ?"
	line_curiosite.grants_keyword_id = &"curiosite"
	line_curiosite.auto_next_line_id = &"propose_village_2"

	var line_propose2 := DialogueLine.new()
	line_propose2.line_id = &"propose_village_2"
	line_propose2.speaker = "Maëlle"
	line_propose2.text = "Bref. Tu viens au village avec moi ?"
	line_propose2.choices = [choice_accepte2, choice_refuse2]

	var dlg := DialogueData.new()
	dlg.id = &"dialogue_maelle_premiere_rencontre"
	dlg.start_line_id = &"intro"
	dlg.lines = [line_intro, line_explique, line_pas_vu, line_reaction, line_propose, line_accepte, line_refuse, line_curiosite, line_propose2]
	ResourceSaver.save(dlg, "res://narrative/Dialogue/content/dialogue_maelle_premiere_rencontre.tres")
