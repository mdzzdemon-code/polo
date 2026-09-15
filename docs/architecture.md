# Architecture technique

Moteur : **Godot 4 (3D, Forward+)**, cible PC/Windows, ~60 FPS, style non
photoréaliste mais lisible.

## Arborescence

```
LE PARADOXE DE L'ÉCHO
│
├── PROJECT                 (project.godot, icône, réglages)
│
├── CORE                     autoloads (singletons globaux)
│   ├── GameManager           état global : scène courante, mode (exploration/combat/dialogue)
│   ├── TimeManager            heure, jour, routines PNJ, événements temporels
│   ├── LoopManager             numéro de boucle, début/fin/reset de boucle
│   ├── RealityManager           glitches, contradictions, dégradation, corrections
│   ├── MemoryManager              souvenirs (connus, perdus, récupérés, faux, dangereux)
│   ├── SaveManager                  persistance (ce qui survit à une boucle vs non)
│   └── EventManager                  bus d'événements découplé entre systèmes
│
├── PLAYER
│   ├── Player / Movement / Interaction / Combat / Inventory / Keywords / Abilities
│
├── WORLD
│   ├── Solenne (les 7 régions : Boiselle, Foret_Aube, Campi_Lucis, Lac_Lune,
│   │             Cite_Caelum, Mont_Cieux, Sanctuaire_Seuil)
│   ├── NPC / Animals / Interactive / Environment
│
├── NARRATIVE
│   ├── Dialogue / Quests / Memories / Characters / Events / Endings
│
├── COMBAT
│   ├── Weapons / Traumas / Stability / SynapseLink / Keywords
│
├── REALITY
│   ├── Glitches / Contradictions / Degradation / Consequences
│
├── UI
│   ├── HUD / Dialogue / Inventory / CarnetAnomalie / CarnetRealite / Menus
│
└── AUDIO
    ├── Music / Ambience / SFX / Voice
```

## Principe directeur : données séparées du code

Les personnages, objets, mots-clés, Traumatismes, dialogues, quêtes,
événements et souvenirs sont définis comme **données** (`Resource` / `.tres`),
pas codés en dur dans des scripts de comportement. Un personnage comme Maëlle
n'est donc pas entièrement défini dans son script : il référence une ressource
`CharacterData` (voir `narrative/Characters/character_data.gd`) qui porte :

```
CharacterData
├── name
├── age
├── personality
├── schedule
├── memories
├── relationships
├── dialogue
├── quests
├── death_conditions
└── loop_state
```

Le même principe s'appliquera aux armes, objets, mots-clés, Traumatismes,
dialogues, quêtes et événements au fur et à mesure de leur implémentation.
Objectif : produire beaucoup de contenu sans transformer les scripts en
spaghetti.

## Autoloads (singletons)

Enregistrés dans `project.godot` sous `[autoload]`, dans cet ordre de
dépendance croissante : `GameManager`, `TimeManager`, `LoopManager`,
`RealityManager`, `MemoryManager`, `SaveManager`, `EventManager`. Ce sont des
squelettes minimaux pour l'instant (étape 2 de la feuille de route) ; leur
logique sera étoffée au fil des étapes suivantes (temps/boucles, mémoire,
combat, etc.).

## État actuel

- [x] Étape 1 — Projet Godot initialisé (`project.godot`, rendu Forward+, 3D).
- [x] Étape 2 — Arborescence de dossiers posée, autoloads squelettes en place,
      gabarit de données `CharacterData`.
- [ ] Étape 3 et suivantes — voir `docs/GDD.md` § Feuille de route.
