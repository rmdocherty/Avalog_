extends Node

const MALORY = "- Malory, Le Morte D'Arthur"
const HISTORY = "- Morgan, Historia"

const codex_data = {
	"0": {
		"name": "",
		"faction": 0,
		"type": "",
		"tooltip": "", # TODO: Change will be to are in final
		"lore": "Welcome to Avalog!\n\nAvalog is continuous chess game - pieces aren't just stuck to discrete squares on the board.\nThere are some slight changes to normal chess:\n1) No check - take the King to win!\n2) Auto-promotion to queen.\n3) En-passant in 'Classic' mode only\n4) The King can castle into/out of check.\n\nThere are other factions, with similar pieces that will be available in Draft or Custom mode. This enchanted book (try clicking the pieces!) explains how they move and their story.\n\nHave fun!",
		"author": ""
		},
	"1": {
		"name": "Arthur",
		"faction": 0,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] Pawns can move twice as far on their first move & this can swap  with Rooks if neither has moved yet.",
		"lore": "How gat ye this sword? said Sir Ector to Arthur. Sir, I will tell you. When I came home for my brother’s sword, I found nobody at home to deliver me his sword; and so I thought my brother Sir Kay should not be swordless, and so I came hither eagerly and pulled it out of the stone without any pain. Found ye any knights about this sword? said Sir Ector. Nay, said Arthur.\n  Now, said Sir Ector to Arthur, I understand ye must be king of this land. Wherefore I, said Arthur, and for what cause? Sir, said Ector, for God will have it so; for there should never man have drawn out this sword, but he that shall be rightwise king of this land.",
		"author": MALORY
	},
	"2": {
		"name": "Guinevere",
		"faction": 0,
		"type": "q",
		"tooltip": "Queen-like",
		"lore": "Some are quick to blame Guinevere for what happened - for the betrayal, the schism, the collapse of the round table. But we must look further - was her affair unprompted, or was it his later conquests, his later madness that drove the rift betwixt them?\nWe do know she was even-tempered, kind, and frequently a voice of reason in the council. It is still unknown quite when her relationship with Lancelot started; whether it was whilst he was still a Queen's Knight or after, when he sat on the Round Table. ",
		"author": HISTORY
	},
	"3": {
		"name": "Merlin",
		"faction": 0,
		"type": "b",
		"tooltip": "Bishop-like",
		"lore": "So they rode till they came to a lake, the which was a fair water and broad, and in the midst of the lake Arthur was ware of an arm clothed in white samite, that held a fair sword in that hand. Lo! said Merlin, yonder is that sword that I spake of. With that they saw a damosel going upon the lake. What damosel is that? said Arthur. That is the Lady of the Lake, said Merlin; and within that lake is a rock, and therein is as fair a place as any on earth, and richly beseen; and this damosel will come to you anon, and then speak ye fair to her that she will give you that sword.",
		"author": MALORY
	},
	"4": {
		"name": "Rogue",
		"faction": 0,
		"type": "n",
		"tooltip": "[color=red]Jumping[/color] in a circle",
		"lore": "The older chivalry was slowly breaking up, and a new, wealthy burgher and trading community was rapidly gaining influence in the land; whilst the clergy, corrupted by excess of wealth and power, had strained, almost to breaking, the controlling force of religion. It was therefore natural that in these latter days a class of women should arise to avail themselves of the unique opportunities of the time—women who, loving liberty and hating oppression, took the law into their own hands and executed a rough and ready justice between the rich and the poor which embodied the best traditions of knight-errantry, whilst they themselves lived a free and merry life on the tolls they exacted from their wealthy victims.", #a wanted description from town
		"author": "- *Ebbutt, Hero-Myths & Legends ..."
	},
	"5": {
		"name": "Gaheris",
		"faction": 0,
		"type": "r",
		"tooltip": "Rook-like",
		"lore": "Thereat sat Sir Gawaine in great envy and told Gaheris his brother, yonder knight is put to great worship, the which grieveth me sore, for he slew our father King Lot, therefore I will slay him, said Gawaine, with a sword that was sent me that is passing trenchant. Ye shall not so, said Gaheris, at this time, for at this time I am but a squire, and when I am made knight I will be avenged on him, and therefore, brother, it is best ye suffer till another time, that we may have him out of the court, for an we did so we should trouble this high feast. I will well, said Gawaine, as ye will.",
		"author": MALORY
	},
	"6": {
		"name": "Peasant",
		"faction": 0,
		"type": "p",
		"tooltip": "[color=red]No attack[/color] forward.\n[color=red]Attacks[/color] diagonally.",
		"lore": "‘Now herkneth,’ quod the Miller, ‘alle and some!\nBut first I make a protestacioun\nThat I am dronke, I knowe it by my soun;\nAnd therfore, if that I misspeke or seye,\nWyte it the ale of Southwerk, I yow preye;\nFor I wol telle a legende and a lyf\nBothe of a Carpenter, and of his wyf,\nHow that a clerk hath set the wrightes cappe.’",
		"author": "- Chaucer, the Canterbury Tales"
	},
	"7": {
		"name": "Count Lucius",
		"faction": 1,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] you always start first.",
		"lore": "Now turn we to the Emperor of Rome, which espied that these prisoners should be sent to Paris, and anon he sent to lie in a bushment certain knights and princes with sixty thousand men, for to rescue his knights and lords that were prisoners. And so on the morn as Launcelot and Sir Cador, chieftains and governors of all them that conveyed the prisoners, as they should pass through a wood, Sir Launcelot sent certain knights to espy if any were in the woods to let them. And when the said knights came into the wood, anon they espied and saw the great embushment, and returned and told Sir Launcelot that there lay in await for them three score thousand Romans.",
		"author": MALORY
	},
	"8": {
		"name": "The Contessa",
		"faction": 1,
		"type": "q",
		"tooltip": "[color=red]Jumping[/color] in two circles.",
		"lore": "If Count Lucius was the hand, the Contessa was the dagger. Endlessly embroiled in scandal and intrigue, it is tough to know when the stories end and the history begins. Daughter of a disgraced Italian noble, her childhood was tumultuous - both her father and nanny went missing when she was just 15.\n At Bolgona's prestigious fencing school she excelled, graduating second in her cohort. It was there she met Count Lucius, Prince Gradlon, and his beau. This cliqué fell apart as quickly and as intensely as it had formed, culminating in a notorious public duel and was allegedly the reason the school burnt down.", # her as 'the muscle', 2nd best fencer @ fencing school
		"author": HISTORY
},
	"9": {
		"name": "Cardinal",
		"faction": 1,
		"type": "b",
		"tooltip": "",
		"lore": "FIFTH ARTICLE [I, Q. 115, Art. 5]\nWhether Heavenly Bodies Can Act on the Demons?\n\nObjection 1: It would seem that heavenly bodies can act on the demons. For the demons, according to certain phases of the moon, can harass men, who on that account are called lunatics, as appears from Matt. 4:24 and 17:14. But this would not be if they were not subject to the heavenly bodies. Therefore the demons are subject to them.\n\nObj. 2: Further, necromancers observe certain constellations in order to invoke the demons. But these would not be invoked through the heavenly bodies unless they were subject to them. Therefore they are subject to them.",
		"author": "- St. Aquinas, Summa Theologica"
	},
	"10": {
		"name": "Captain",
		"faction": 1,
		"type": "n",
		"tooltip": "",
		"lore": "",
		"author": HISTORY
	},
	"11": {
		"name": "Elephant",
		"faction": 1,
		"type": "r",
		"tooltip": "",
		"lore": "PAWOOOO PFTTEEE STOMP AROOUUU",
		"author": "- Nelly"
	},
	"12": {
		"name": "Phalanx",
		"faction": 1,
		"type": "p",
		"tooltip": "",
		"lore": "",
		"author": HISTORY
	},
	"13": {
		"name": "Gradlon II",
		"faction": 2,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] your pieces can move up to 1 square further.",
		"lore": "The legend of the submerged city of Ys, or Is, is perhaps the most romantic and imaginative effort of Breton popular legend. Who has not heard of the submerged bells of Ys, and who has not heard them ring in the echoes of his own imagination? This picturesque legend tells us that in the early days of the Christian epoch the city of Ys, or Ker-is, was ruled by a prince called Gradlon, surnamed Meur, which in Celtic means ‘the Great.’ Gradlon was a saintly and pious man, and acted as patron to Gwénnolé, founder and first abbé of the first monastery built in Armorica. But, besides being a religious man, Gradlon was a prudent prince, and defended his capital of Ys from the invasions of the sea by constructing an immense basin", #rhyme about Ys
		"author": "- Lewis Spence F.R.A.I."
	},
	"14": {
		"name": "Knight of the Sun",
		"faction": 2,
		"type": "q",
		"tooltip": "[color=red]Jumping[/color] in a star pattern",
		"lore": "",
		"author": HISTORY
	},
	"15": {
		"name": "Druide",
		"faction": 2,
		"type": "b",
		"tooltip": "[color=red]Ranged[/color]",
		"lore": "    [i]Pa vo beuzet Paris[/i]\n    [i]Ec'h adsavo Ker Is[/i]\n\n\n    When Paris will be engulfed\n    Will re-emerge the City of Ys",
		"author": "- A Breton saying"
	},
	"16": {
		"name": "Archer",
		"faction": 2,
		"type": "n",
		"tooltip": "[color=red]Ranged[/color]",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"17": {
		"name": "Hallebarde",
		"faction": 2,
		"type": "r",
		"tooltip": "",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"18": {
		"name": "Agriculteur",
		"faction": 2,
		"type": "p",
		"tooltip": "[color=red]No attack[/color] diagonally.\n[color=red]Attacks[/color] forward.",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"19": {
		"name": "Roxelena",
		"faction": 3,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] your multi-state pieces have all states at once.",
		"lore": "On the 22d day of May, 1524, the Sultan celebrated with great pomp the marriage of Ibrahim Pasha. Who the bride was we cannot be certain, but this is in accord with Turkish etiquette which strictly forbids all mention of the harem, and considers any public knowledge of woman as an insult to her, thus depriving historians of desirable information concerning such important political figures as Roxelana, who greatly influenced Suleiman the Magnificent, Baffa the Venetian sultana, and others.",
		"author": "- Hester D. Jenkins"
	},
	"20": {
		"name": "Suleiman",
		"faction": 3,
		"type": "q",
		"tooltip": "[color=red]State 1:[/color] star shaped lines.\n[color=red]State 2: jumping[/color] in concentric crescents.",
		"lore": "",
		"author": HISTORY
	},
	"21": {
		"name": "Grand Vizier",
		"faction": 3,
		"type": "b",
		"tooltip": "",
		"lore": "Ibrahim’s first office was page to the heir apparent Suleiman. When the latter came to the throne in 1520, he made Ibrahim Head Falconer, and then raised him in rapid succession to the respective posts of Khass‐oda‐Bashi, or Master of the Household, of Beylerbey of Roumelie, Vizir, Grand Vizir, and finally Serasker, or general‐in‐chief of the Imperial forces—a dazzlingly rapid promotion. Baudier tells a story in this connection which might easily be true, being quite in character, although it can not be verified. The story runs thus: “Ibrahim’s rapid rise began to alarm him. [...] He besought Suleiman not to advance him so high that his fall would be his ruin.“",
		"author": "- Hester D. Jenkins"
	},
	"22": {
		"name": "Janissary",
		"faction": 3,
		"type": "n",
		"tooltip": "[color=red]State 1: Jumping[/color] in a circle.\n[color=red]State 2: Ranged[/color].",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"23": {
		"name": "Dardanelles Cannon",
		"faction": 3,
		"type": "r",
		"tooltip": "[color=red]Ranged[/color]",
		"lore": "Geri gel!",
		"author": "- Munir Ali"
	},
	"24": {
		"name": "Yaya",
		"faction": 3,
		"type": "p",
		"tooltip": "[color=red]State 1[/color] move & attack forwards. \n[color=red]State 2:[/color] move & attack diagonally.",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"25": {
		"name": "Morgana",
		"faction": 4,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] start with an extra zombie.",
		"lore": "So when Accolon was dead he let send him on an horse-bier with six knights unto Camelot, and said: Bear him to my sister Morgan le Fay, and say that I send her him to a present, and tell her I have my sword Excalibur and the scabbard; so they departed with the body. Then came tidings unto Morgan le Fay that Accolon was dead, and his body brought unto the church, and how King Arthur had his sword again. But when Queen Morgan wist that Accolon was dead, she was so sorrowful that near her heart to-brast. But because she would not it were known, outward she kept her countenance, and made no semblant of sorrow. But well she wist an she abode till her brother Arthur came thither, there should no gold go for her life.",
		"author": MALORY
	},
	"26": {
		"name": "Modred",
		"faction": 4,
		"type": "q",
		"tooltip":"",
		"lore": "And never was there seen a more dolefuller battle in no Christian land; for there was but rushing and riding, foining and striking, and many a grim word was there spoken either to other, and many a deadly stroke. But ever King Arthur rode throughout the battle of Sir Mordred many times, and did full nobly as a noble king should, and at all times he fainted never; and Sir Mordred that day put him in devoir, and in great peril. And thus they fought all the long day, and never stinted till the noble knights were laid to the cold earth; and ever they fought still till it was near night, and by that time was there an hundred thousand laid dead upon the down. Then was Arthur wood wroth out of measure, when he saw his people so slain from him.",
		"author": MALORY
	},
	"27": {
		"name": "Shadow Wizard",
		"faction": 4,
		"type": "b",
		"tooltip": "",
		"lore": "",
		"author": HISTORY
	},
	"28": {
		"name": "Skeleton Archer",
		"faction": 4,
		"type": "n",
		"tooltip": "[color=red]Ranged[/color] in a square.",
		"lore": "",
		"author": "- Friar Morgan, Historia"
	},
	"29": {
		"name": "The Maiden, the Mother, the Crone",
		"faction": 4,
		"type": "r",
		"tooltip": "[color=red]State 1:[/color] knight-like. \n[color=red]State 2:[/color] bishop-like. \n[color=red]State 3:[/color] rook-like.",
		"lore": "",
		"author": ""
	},
	"30": {
		"name": "Zombie",
		"faction": 4,
		"type": "p",
		"tooltip": "",
		"lore": "",
		"author": ""
	},
}
