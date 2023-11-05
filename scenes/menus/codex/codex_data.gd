extends Node

const MALORY = "- T. Malory, Le Morte D'Arthur"
const HISTORY = "- F. Morgan, Historia"
const SPENCE = "- L. Spence, Legends & Romances ..."

const codex_data: Dictionary = {
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
		"tooltip": "[color=red]Aura:[/color] Pawns can move twice as far on their first move & this can swap with Rooks if neither has moved yet.",
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
		"author": "- G. Chaucer, the Canterbury Tales"
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
		"author": "- St. T. Aquinas, Summa Theologica"
	},
	"10": {
		"name": "Captain",
		"faction": 1,
		"type": "n",
		"tooltip": "",
		"lore": "the Roman emperors had a third difficulty in having to put up with the cruelty and avarice of their soldiers, a matter so beset with difficulties that it was the ruin of many; for it was a hard thing to give satisfaction both to soldiers and people; because the people loved peace, and for this reason they loved the unaspiring prince, whilst the soldiers loved the warlike prince who was bold, cruel, and rapacious, which qualities they were quite willing he should exercise upon the people, so that they could get double pay and give vent to their own greed and cruelty.",
		"author": "- N. Machiavelli, the Prince"
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
		"tooltip": "", # maybe some fake history about them fighting gradlon near paris?
		"lore": "Their enemy was outside Paris, his plans well in motion. To stop him, they had to traverse the land of the Gauls - they had conquered them before, they could do it again. For the first (and the last) time in their history, in the twilight of their empire, they had not come to subjugate, but to save. \n And so they marched, they marched for Rome, for the Pope, for God and even for France. They were the sword and shield of the empire - conscripted from farmers, bakers, merchants then trained, honed and unleashed. They had fought winter wars, guerilla wars and pitched battles. There was no force more organized or experienced in all of Christendom. They were, sadly, not enough.",
		"author": HISTORY
	},
	"13": {
		"name": "Gradlon II",
		"faction": 2,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] your pieces can move up to 1 square further.",
		"lore": "The legend of the submerged city of Ys, or Is, is perhaps the most romantic and imaginative effort of Breton popular legend. Who has not heard of the submerged bells of Ys, and who has not heard them ring in the echoes of his own imagination? This picturesque legend tells us that in the early days of the Christian epoch the city of Ys, or Ker-is, was ruled by a prince called Gradlon, surnamed Meur, which in Celtic means ‘the Great.’ Gradlon was a saintly and pious man, and acted as patron to Gwénnolé, founder and first abbé of the first monastery built in Armorica. But, besides being a religious man, Gradlon was a prudent prince, and defended his capital of Ys from the invasions of the sea by constructing an immense basin", #rhyme about Ys
		"author": SPENCE
	},
	"14": {
		"name": "Knight of the Sun",
		"faction": 2,
		"type": "q",
		"tooltip": "[color=red]Jumping[/color] in a star pattern",
		"lore": "It was there in the chamber, with victory all but assured, that he had his doubts. He had been injured in the melee, struck in the leg by a rogue arrow. He was prepared to die - even if the tales were true, he had always assumed they'd die before they reached it. They had been told that deep in the cave was an altar that could restore them back to their former glory, to rule Brittany and France as they were meant to.\nSlumped against the cold cave wall, seeing the lights and phantoms pour from the altar, he finally understood Gradlon's plan and realised he had to stop it. He was a virtuosic swordsman, a generational talent, and this was the only duel he ever lost.", # about how he turned on gradlon in the end but was too late to stop him?
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
		"lore": "The scene changes to the fortress of Nomenoë, and we see its master returning from the chase, accompanied by his great hounds and laden with trophies. His bow is in his hand, and he carries the carcass of a boar upon his shoulder. The red blood drops from the dead beast’s mouth and stains his hand. The aged chief, well-nigh demented, awaits his coming, and Nomenoë greets him courteously.\n“Hail, honest mountaineer!” he cries. “What is your news? What would you with Nomenoë?”\n“I come for justice, Lord Nomenoë,” replies the aged man. “Is there a God in heaven and a chief in Brittany?",
		"author": SPENCE
	},
	"17": {
		"name": "Hallebarde",
		"faction": 2,
		"type": "r",
		"tooltip": "Moves in a square",
		"lore": "The Roman vanguard had arrived before Gradlon II could reach the altar, so her task was simple: hold the bridge. And so she held it, wave after wave beaten back by axe or sword or arrow. By all accounts she slew at least fifty men herself, and having held the bridge for four hours it came time to push back, to create a widnow for Gradlon to cross. It was suicide, of course, insanity even - a bridge is a chokepoint, it could be held, supplied, defended. Charging a forward formation was a different story; maybe that was why it worked. They say she's buried there, a giant rusted ax-head for a gravestone. ", # how she was strong fighter and about the battle with count lucius?
		"author": HISTORY
	},
	"18": {
		"name": "Agriculteur",
		"faction": 2,
		"type": "p",
		"tooltip": "[color=red]No attack[/color] diagonally.\n[color=red]Attacks[/color] forward.",
		"lore": "On one occasion, we are told, Goezenou asked a farmer’s wife for some cream cheeses, but the woman, not wishing to part with them, declared that she had none. “You speak the truth,” said the Saint. “You had some, but if you will now look in your cupboard you will find they have been turned into stone,” and when the ungenerous housewife ran to her cupboard she found that this was so! The petrified cheeses were long preserved in the church of Goezenou—being removed during the Revolution, and afterward preserved in the manor of Kergivas.",
		"author": SPENCE
	},
	"19": {
		"name": "Roxelena",
		"faction": 3,
		"type": "k",
		"tooltip": "[color=red]Aura:[/color] your multi-state pieces have all states at once.",
		"lore": "On the 22d day of May, 1524, the Sultan celebrated with great pomp the marriage of Ibrahim Pasha. Who the bride was we cannot be certain, but this is in accord with Turkish etiquette which strictly forbids all mention of the harem, and considers any public knowledge of woman as an insult to her, thus depriving historians of desirable information concerning such important political figures as Roxelana, who greatly influenced Suleiman the Magnificent, Baffa the Venetian sultana, and others.",
		"author": "- H D. Jenkins, Ibrahim Pasha"
	},
	"20": {
		"name": "Suleiman",
		"faction": 3,
		"type": "q",
		"tooltip": "[color=red]State 1:[/color] star shaped lines.\n[color=red]State 2: jumping[/color] in concentric crescents.",
		"lore": "They sent a delegation once, when he was younger. Four knights of the Round Table: Lancelot, Gawain, Galehaut and Gaheris, and a host of scholars and priests. They shared stories - tales of honor and heroism - the Grail quest, the Green knight, slaying the dragon of Corbenic. There seemed to be no malice in their words or deeds, which only made it more confusing when twenty years later they returned with swords and catapults and men.",
		"author": HISTORY
	},
	"21": {
		"name": "Grand Vizier",
		"faction": 3,
		"type": "b",
		"tooltip": "",
		"lore": "Ibrahim’s first office was page to the heir apparent Suleiman. When the latter came to the throne in 1520, he made Ibrahim Head Falconer, and then raised him in rapid succession to the respective posts of Khass‐oda‐Bashi, or Master of the Household, of Beylerbey of Roumelie, Vizir, Grand Vizir, and finally Serasker, or general‐in‐chief of the Imperial forces—a dazzlingly rapid promotion. Baudier tells a story in this connection which might easily be true, being quite in character, although it can not be verified. The story runs thus: “Ibrahim’s rapid rise began to alarm him. [...] He besought Suleiman not to advance him so high that his fall would be his ruin.“",
		"author": "- H D. Jenkins, Ibrahim Pasha"
	},
	"22": {
		"name": "Janissary",
		"faction": 3,
		"type": "n",
		"tooltip": "[color=red]State 1: Jumping[/color] in a circle.\n[color=red]State 2: Ranged[/color].",
		"lore": "Sigismund made a speech to the chevaliers from western and central Europe, in which he declared: ‘Let him come or not come, in the summer which will return, if it pleases God, we shall get through the kingdom of Armenia and shall pass the Bras Saint-George and shall go into Syria and shall get from the Saracens the gates of Jaffa and Beirut and several other [cities] to go down into Syria, and we shall go to conquer the city of Jerusalem and all the Holy Land. And if the Sultan, with all the strength he can muster, comes before us, we shall fight him, and there will be no going away without the battle, in God’s pleasure.’ Froissart naïvely adds immediately after his report of this speech: ‘But it turned out very much in another way.’",
		"author": "- H A Gibbons, The Foundation of ..."
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
		"lore": "The English had cut a bloody swathe through Europe towards Constantinople. They had pushed through, progressing without care for logistics or losses. Suleiman's plan was to draw out the heavy cavalry with a sacrificial platoon, encircle them and attack any units sent to support them. They did not expect Arthur to only send half his horses or that he would completely abandon them in favour of attacking the city.",
		"author": HISTORY
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
		"name": "Mordred",
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
		"lore": "[b]We love casting spells![/b]",
		"author": "- Shadow Wizard Money Gang"
	},
	"28": {
		"name": "Skeleton Archer",
		"faction": 4,
		"type": "n",
		"tooltip": "[color=red]Ranged[/color] in a square.",
		"lore": "The kingdom was in disarray, reeling from the disastrous crusade, upheaval on the continent and the open revolt of half the round table. The people were scared and the atmosphere charged. The king was a recluse, confused and prone to lashing out at anyone who distrubed him. It was against this backdrop that Mordred made his move. Whether he was motivated by genuine concern for the people, or whether he simply felt he deserved the throne we may never know. All we know is what happened: how Morgana summoned legions of beasts and ghouls and dead men and marched on Camelot. How the land was razed, the people slain and how, with the enemy at the gates, Arthur roused and rode to meet them.",
		"author": HISTORY
	},
	"29": {
		"name": "The Maiden, the Mother, the Crone",
		"faction": 4,
		"type": "r",
		"tooltip": "[color=red]State 1:[/color] knight-like. \n[color=red]State 2:[/color] bishop-like. \n[color=red]State 3:[/color] rook-like.",
		"lore": "MACBETH.\nSpeak, if you can;—what are you?\n\nFIRST WITCH.\nAll hail, Macbeth! hail to thee, Thane of Glamis!\n\nSECOND WITCH.\nAll hail, Macbeth! hail to thee, Thane of Cawdor!\n\nTHIRD WITCH.\nAll hail, Macbeth! that shalt be king hereafter!", # bit from Macbeth?
		"author": "W. Shakespeare, Macbeth"
	},
	"30": {
		"name": "Zombie",
		"faction": 4,
		"type": "p",
		"tooltip": "",
		"lore": "Yet some men say in many parts of England that King Arthur is not dead, but had by the will of our Lord Jesu into another place; and men say that he shall come again, and he shall win the holy cross. I will not say it shall be so, but rather I will say: here in this world he changed his life. But many men say that there is written upon his tomb this verse: HIC IACET ARTHURUS, REX QUONDAM, REXQUE FUTURUS",
		"author": MALORY
	},
}
