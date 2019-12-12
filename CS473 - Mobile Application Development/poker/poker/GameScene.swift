//
//  GameScene.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let deck = Deck()
    let player = Player(initValue: 200)
    let opponent = OpposingPlayer(initValue: 200)
    let commCards = CommunityCards()
    let pot = Pot()
    let chip10 = Chip(value: .ten)
    let chip25 = Chip(value: .twentyFive)
    let chip50 = Chip(value: .fifty)
    let opponentBankLabel = SKLabelNode(text: "Bank: ")
    let playerBankLabel = SKLabelNode(text: "Bank: ")
    let potLabel = SKLabelNode(text: "Pot: ")
    let betLabel = SKLabelNode(text: "Bet: 0")
    let clearBtnBackground = SKSpriteNode(texture: SKTexture(imageNamed: "btnBackground1"))
    let betBtnBackground = SKSpriteNode(texture: SKTexture(imageNamed: "btnBackground2"))
    let clearBtnLabel = SKLabelNode(text: "Fold")
    let betBtnLabel = SKLabelNode(text: "Check")
    let opponentMoveLabel = SKLabelNode(text: "Opponent Move")
    var tempBet = 0
    var lastPlayerBet = 0
    var lastOpponentBet = 0
    let commCardLayout = SKSpriteNode()
    let playerCardLayout = SKSpriteNode()
    let potLayout = SKSpriteNode()
    let opponentCardLayout = SKSpriteNode()
    var opponentJustRaised = false
    let winLabel = SKLabelNode()
    let nextRoundLabel = SKLabelNode(text: "Next round")
    var entities = [GKEntity]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    func firstRound() {
        let opponentNameLabel = SKLabelNode(text: opponent.getName())
        let background = SKSpriteNode(imageNamed: "background")
        betBtnBackground.name = "bet"
        clearBtnBackground.name = "clear"
        clearBtnLabel.name = "clear"
        betBtnLabel.name = "bet"
        deck.shuffle()
        player.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        opponent.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        commCards.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        for n in 0...player.getHand().getCardArray().count-1 {
            let card = player.getHand().getCardArray()[n]
            let xval = (card.size.width * 0.1) + (card.size.width * (CGFloat(n) * 0.13))
            let yval = ((card.size.height * 0.5) + (-1 * self.size.height/1.2))
            card.position = CGPoint(x: xval, y: yval)
            card.xScale = CGFloat(0.1)
            card.yScale = CGFloat(0.1)
            playerCardLayout.addChild(card)
        }
        for n in 0...commCards.getHand().getCardArray().count-1 {
            let card = commCards.getHand().getCardArray()[n]
            let xval = (card.size.width * 0.1) + (card.size.width * (CGFloat(n) * 0.13))
            let yval = ((card.size.height * 0.5) + (self.size.height * -0.1))
            card.position = CGPoint(x: xval, y: yval)
            card.xScale = CGFloat(0.1)
            card.yScale = CGFloat(0.1)
            commCardLayout.addChild(card)
        }
        chip10.position = CGPoint (x: ((self.size.width / 2) + (self.size.width / -4.5)),
                                   y: ((self.size.height / 2) + (self.size.width / -4.3)))
        chip25.position = CGPoint (x: ((self.size.width / 2) + (self.size.width / -4.5) + (chip25.size.width * 1.2)),
                                   y: ((self.size.height / 2) + (self.size.width / -4.3)))
        chip50.position = CGPoint (x: ((self.size.width / 2) + (self.size.width / -4.5) + (chip25.size.width * 2.4)),
                                   y: ((self.size.height / 2) + (self.size.width / -4.3)))
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        opponent.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / 2.6)),
                                    y: ((self.size.height / 2) + (self.size.height / 4)))
        opponentNameLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / 2.6)),
                                             y: ((self.size.height / 2)))
        opponentBankLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / 2.6)),
                                             y: ((self.size.height / 2) + (self.size.height / -14)))
        opponentMoveLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / 2.6)),
                                             y: ((self.size.height / 2) + (self.size.height / -8)))
        opponentBankLabel.fontSize = 24
        playerBankLabel.fontSize = 24
        potLabel.fontSize = 24
        clearBtnLabel.fontSize = 16
        betBtnLabel.fontSize = 14
        opponentMoveLabel.fontSize = 16
        clearBtnLabel.fontColor = UIColor.black
        betBtnLabel.fontColor = UIColor.black
        opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
        playerBankLabel.text = "Bank: " + String(player.getBank().getBankValue())
        potLabel.text = "Pot: " + String(pot.getPotValue())
        potLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / -2.5)),
                                    y: ((self.size.height / 2) + (self.size.height / 5)))
        playerBankLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / -2.5)),
                                           y: ((self.size.height / 2) + (self.size.height / -4.2)))
        betBtnBackground.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / -4.5) + (chip25.size.width * 4.2)),
                                     y: ((self.size.height / 2) + (self.size.width / -4.3)))
        clearBtnBackground.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / -4.5) +        (chip25.size.width * 6.2)),
                                              y: ((self.size.height / 2) + (self.size.width / -4.3)))
        betBtnLabel.position = CGPoint(x: (betBtnBackground.position.x),
                                       y: (betBtnBackground.position.y - 5))
        clearBtnLabel.position = CGPoint(x: (clearBtnBackground.position.x),
                                       y: (clearBtnBackground.position.y - 5))
        betLabel.position = CGPoint(x: ((self.size.width / 2) + (self.size.width / -4.6)),
                             y: ((self.size.height / 2) + (self.size.width / -5.4)))
        winLabel.fontSize = 18
        winLabel.position = CGPoint(x: playerBankLabel.position.x + (self.size.width / 12),
                                    y: playerBankLabel.position.y + (self.size.height / 13))
        nextRoundLabel.position = CGPoint(x: betBtnLabel.position.x,
                                          y: betBtnLabel.position.y + (betBtnBackground.size.height * 0.2))
        nextRoundLabel.fontSize = 14
        betLabel.fontSize = 24
        betLabel.isHidden = true
        betBtnLabel.fontName = "HelveticaNeue-Bold"
        clearBtnLabel.fontName = "HelveticaNeue-Bold"
        opponentMoveLabel.fontName = "HelveticaNeue-Bold"
        nextRoundLabel.fontName = "HelveticaNeue-Bold"
        winLabel.fontName = "HelveticaNeue-Bold"
        betBtnBackground.xScale = CGFloat(0.2)
        betBtnBackground.yScale = CGFloat(0.2)
        clearBtnBackground.xScale = CGFloat(0.17)
        clearBtnBackground.yScale = CGFloat(0.17)
        betBtnBackground.zPosition = CGFloat(0)
        clearBtnBackground.zPosition = CGFloat(0)
        background.zPosition = CGFloat(-1)
        opponentMoveLabel.isHidden = true
        winLabel.isHidden = true
        nextRoundLabel.isHidden = true
        nextRoundLabel.name = "nextRound"
        addChild(background)
        addChild(opponent)
        addChild(chip10)
        addChild(chip25)
        addChild(chip50)
        addChild(opponentNameLabel)
        addChild(opponentBankLabel)
        addChild(playerBankLabel)
        addChild(potLabel)
        addChild(betBtnBackground)
        addChild(clearBtnBackground)
        addChild(betBtnLabel)
        addChild(clearBtnLabel)
        addChild(betLabel)
        addChild(opponentMoveLabel)
        addChild(commCardLayout)
        addChild(playerCardLayout)
        addChild(potLayout)
        addChild(opponentCardLayout)
        addChild(winLabel)
        addChild(nextRoundLabel)
    }
    
    func newRound() {
        winLabel.isHidden = true
        nextRoundLabel.isHidden = true
        winLabel.text = ""
        lastPlayerBet = 0
        lastOpponentBet = 0
        commCardLayout.removeAllChildren()
        playerCardLayout.removeAllChildren()
        potLayout.removeAllChildren()
        opponentCardLayout.removeAllChildren()
        deck.create()
        deck.shuffle()
        player.getHand().resetHand()
        commCards.getHand().resetHand()
        opponent.getHand().resetHand()
        player.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        opponent.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        commCards.getHand().addCards(cards: [deck.getTopCard(), deck.getTopCard()])
        for n in 0...player.getHand().getCardArray().count-1 {
            let card = player.getHand().getCardArray()[n]
            let xval = (card.size.width * 0.1) + (card.size.width * (CGFloat(n) * 0.13))
            let yval = ((card.size.height * 0.5) + (-1 * self.size.height/1.2))
            card.position = CGPoint(x: xval, y: yval)
            card.xScale = CGFloat(0.1)
            card.yScale = CGFloat(0.1)
            playerCardLayout.addChild(card)
        }
        for n in 0...commCards.getHand().getCardArray().count-1 {
            let card = commCards.getHand().getCardArray()[n]
            let xval = (card.size.width * 0.1) + (card.size.width * (CGFloat(n) * 0.13))
            let yval = ((card.size.height * 0.5) + (self.size.height * -0.1))
            card.position = CGPoint(x: xval, y: yval)
            card.xScale = CGFloat(0.1)
            card.yScale = CGFloat(0.1)
            commCardLayout.addChild(card)
        }
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if (touchedNode.name == "chip") {
            let chip = touchedNode as! Chip
            touchedChip(chip: chip)
        }
        else if (touchedNode.name == "clear") {
            pressedRedButton()
        }
        else if (touchedNode.name == "bet") {
            pressedBlueButton()
        } else if (touchedNode.name == "nextRound") {
            newRound()
        }
    }
    
    func touchedChip(chip: Chip) {
        if (chip.getValue().rawValue > player.getBank().getBankValue()) {
            print("Don't have enough to bet")
        }
        else {
            tempBet += chip.getValue().rawValue
            betLabel.isHidden = false
            betLabel.text = "Bet: " + String(tempBet)
            clearBtnLabel.text = "Clear Bet"
            betBtnLabel.text = "Raise"
        }
        if ((player.getBank().getBankValue() - tempBet ) < chip50.getValue().rawValue) {
            chip50.isHidden = true
        }
        if ((player.getBank().getBankValue() - tempBet) < chip25.getValue().rawValue) {
            chip25.isHidden = true
        }
        if ((player.getBank().getBankValue() - tempBet) < chip10.getValue().rawValue) {
            chip10.isHidden = true
        }
    }
    
    func pressedRedButton() {
        if (tempBet > 0) {
            tempBet = 0
            clearBtnLabel.text = "Fold"
            betBtnLabel.text = "Check"
            betLabel.isHidden = true
            if ((player.getBank().getBankValue() - tempBet ) < chip50.getValue().rawValue) {
                chip50.isHidden = true
            } else {
                chip50.isHidden = false
            }
            if ((player.getBank().getBankValue() - tempBet) < chip25.getValue().rawValue) {
                chip25.isHidden = true
            } else {
                chip25.isHidden = false
            }
            if ((player.getBank().getBankValue() - tempBet) < chip10.getValue().rawValue) {
                chip10.isHidden = true
            } else {
                chip10.isHidden = false
            }
        } else {
            opponentWins()
        }
    }
    
    func addChipsToPot(bet: Int) {
        var remainingBet = bet
        while (remainingBet >= 10) {
            let xmax = CGFloat(self.size.width / 2)
            let ymax = CGFloat(self.size.width / 2 + (chip10.size.height * -1.2))
            let xmin = CGFloat(((chip10.size.width / 2) * -1.25) + (self.size.width / 2))
            let ymin = CGFloat(((chip10.size.height / 2) * -1.25) + (self.size.height / 2))
            if (remainingBet >= 50) {
                let chip = PotChip(value: .fifty)
                let xPos = CGFloat.random(in: xmin...xmax)
                let yPos = CGFloat.random(in: ymin...ymax)
                chip.position = CGPoint(x: xPos,
                                        y: yPos)
                potLayout.addChild(chip)
                remainingBet += -50
            } else if (remainingBet >= 25) {
                let chip = PotChip(value: .twentyFive)
                let xPos = CGFloat.random(in: xmin...xmax)
                let yPos = CGFloat.random(in: ymin...ymax)
                chip.position = CGPoint(x: xPos,
                                        y: yPos)
                potLayout.addChild(chip)
                remainingBet += -25
            } else if (remainingBet >= 10) {
                let chip = PotChip(value: .ten)
                let xPos = CGFloat.random(in: xmin...xmax)
                let yPos = CGFloat.random(in: ymin...ymax)
                chip.position = CGPoint(x: xPos,
                                        y: yPos)
                potLayout.addChild(chip)
                remainingBet += -10
            }
        }
    }
    
    func pressedBlueButton() {
        if (getPlayerCallValue() > tempBet) {
            print("Have to at least match opponent bet")
        } else if (getPlayerCallValue() == tempBet) { // player checked
            clearBtnLabel.text = "Fold"
            betBtnLabel.text = "Check"
            betLabel.isHidden = true
            pot.addToPot(value: tempBet)
            print("tempBet / 50: " + String(tempBet/50))
            player.getBank().removeFromBank(value: tempBet)
            playerBankLabel.text = "Bank: " + String(player.getBank().getBankValue())
            potLabel.text = "Pot: " + String(pot.getPotValue())
            lastPlayerBet = 0
            lastOpponentBet = 0
            tempBet = 0
            opponentMove()
        } else {
            clearBtnLabel.text = "Fold"
            betBtnLabel.text = "Check"
            betLabel.isHidden = true
            pot.addToPot(value: tempBet)
            player.getBank().removeFromBank(value: tempBet)
            playerBankLabel.text = "Bank: " + String(player.getBank().getBankValue())
            potLabel.text = "Pot: " + String(pot.getPotValue())
            lastPlayerBet = tempBet
            addChipsToPot(bet: tempBet)
            tempBet = 0
            opponentMove()
        }
    }
    
    func getOpponentCallValue() -> Int {
        if (lastPlayerBet - lastOpponentBet < 0) {
            return 0
        } else {
            return lastPlayerBet - lastOpponentBet
        }
    }
    
    func getPlayerCallValue() -> Int {
        if (lastOpponentBet - lastPlayerBet < 0) {
            return 0
        } else {
            return lastOpponentBet - lastPlayerBet
        }
    }
    
    func opponentMove() {
        opponent.getHand().getCombos(commCardHand: commCards.getHand())
        
        if ((opponent.getHand().getStraightFlushStatus() > 0 ||
            opponent.getHand().getFourOfAKindStatus() > 0 ||
            opponent.getHand().getFullHouseStatus() > 0 ||
            opponent.getHand().getFlushStatus() > 0 ||
            opponent.getHand().getStraightStatus() > 0 ||
            opponent.getHand().getThreeOfAKindStatus() > 10 ||
            opponent.getHand().getTwoPairStatus() > 6) && !opponentJustRaised) { // opponent raises
            let strategy = Int.random(in: 0...1)
            if (player.getBank().getBankValue() < opponent.getBankValue()) {
                makeBet(min: getOpponentCallValue(), max: player.getBank().getBankValue(), strategy: strategy)
            } else {
                makeBet(min: getOpponentCallValue(), max: opponent.getBankValue(), strategy: strategy)
            }
        } else if ((opponent.getHand().getHighCardStatus() > 5 && commCards.getHand().getCardArray().count < 3) ||
            opponent.getHand().getThreeOfAKindStatus() > 0 ||
            opponent.getHand().getPairStatus() > 0 ||
            opponent.getHand().getTwoPairStatus() > 0 ||
            opponentJustRaised) { // opponent checks
            let bet = getOpponentCallValue()
            lastOpponentBet = 0
            lastPlayerBet = 0
            opponent.removeFromBank(value: bet)
            pot.addToPot(value: bet)
            addChipsToPot(bet: bet)
            opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
            potLabel.text = "Pot: " + String(pot.getPotValue())
            if (bet > 0) {
                opponentMoveLabel.text = "Call"
            } else {
                opponentMoveLabel.text = "Check"
            }
            opponentJustRaised = false
            if (commCards.getHand().getCardArray().count > 4) {
                getWinner()
            } else {
                let newCard = deck.getTopCard()
                commCards.addToCommunityCards(cards: [newCard])
                let xval = (newCard.size.width * 0.1) + (newCard.size.width * (CGFloat(commCards.getHand().getCardArray().count-1) * 0.13))
                let yval = ((newCard.size.height * 0.5) + (self.size.height * -0.1))
                newCard.position = CGPoint(x: xval, y: yval)
                newCard.xScale = CGFloat(0.1)
                newCard.yScale = CGFloat(0.1)
                commCardLayout.addChild(newCard)
            }
        } else {
            opponentMoveLabel.text = "Fold"
            opponentJustRaised = false
            playerWins()
        }
        
        opponentMoveLabel.isHidden = false
    }
    
    func playerWins() {
        player.getBank().addToBank(value: pot.getPotValue())
        pot.resetPot()
        playerBankLabel.text = "Bank: " + String(player.getBank().getBankValue())
        potLabel.text = "Pot: " + String(pot.getPotValue())
        opponentJustRaised = false
        if ((player.getBank().getBankValue()) < chip50.getValue().rawValue) {
            chip50.isHidden = true
        } else {
            chip50.isHidden = false
        }
        if ((player.getBank().getBankValue()) < chip25.getValue().rawValue) {
            chip25.isHidden = true
        } else {
            chip25.isHidden = false
        }
        if ((player.getBank().getBankValue()) < chip10.getValue().rawValue) {
            chip10.isHidden = true
        } else {
            chip10.isHidden = false
        }
        winLabel.isHidden = false
        nextRoundLabel.isHidden = false
    }
    
    func opponentWins() {
        opponent.addToBank(value: pot.getPotValue())
        pot.resetPot()
        opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
        potLabel.text = "Pot: " + String(pot.getPotValue())
        opponentJustRaised = false
        winLabel.isHidden = false
        nextRoundLabel.isHidden = false
    }
    
    func tie() {
        opponent.addToBank(value: pot.getPotValue() / 2)
        player.getBank().addToBank(value: pot.getPotValue() / 2)
        pot.resetPot()
        opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
        playerBankLabel.text = "Bank: " + String(player.getBank().getBankValue())
        potLabel.text = "Pot: " + String(pot.getPotValue())
        opponentJustRaised = false
        winLabel.isHidden = false
        nextRoundLabel.isHidden = false
    }
    
    func getWinner() {
        opponent.getHand().getCombos(commCardHand: commCards.getHand())
        player.getHand().getCombos(commCardHand: commCards.getHand())
        let oppCard1 = opponent.getHand().getCardArray()[0]
        let oppCard2 = opponent.getHand().getCardArray()[1]
        oppCard1.xScale = CGFloat(0.1)
        oppCard1.yScale = CGFloat(0.1)
        oppCard2.xScale = CGFloat(0.1)
        oppCard2.yScale = CGFloat(0.1)
        oppCard1.position = CGPoint(x: self.size.width / 2 + (self.size.width / 4),
                                    y: self.size.height / 2)
        oppCard2.position = CGPoint(x: self.size.width / 2 + (self.size.width / 4),
                                    y: self.size.height / 2 + (oppCard2.size.height * 1.2))
        opponentCardLayout.addChild(oppCard1)
        opponentCardLayout.addChild(oppCard2)
        var opponentKicker = opponent.getHand().getCardArray()[0].getValue()
        var playerKicker = player.getHand().getCardArray()[0].getValue()
        if (opponent.getHand().getCardArray()[1].getValue() > opponentKicker) {
            opponentKicker = opponent.getHand().getCardArray()[1].getValue()
        }
        if (player.getHand().getCardArray()[1].getValue() > playerKicker) {
            playerKicker = player.getHand().getCardArray()[1].getValue()
        }
        print("Opponent cards")
        opponent.getHand().printCards()
        print("Player cards")
        player.getHand().printCards()
        print("Community cards")
        commCards.getHand().printCards()
        if (player.getHand().getStraightFlushStatus() > opponent.getHand().getStraightFlushStatus()) {
            winLabel.text = ("Player wins, Straight Flush " + String(player.getHand().getStraightFlushStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getStraightFlushStatus() > player.getHand().getStraightFlushStatus()) {
            winLabel.text = ("Opponent wins, Straight Flush " + String(opponent.getHand().getStraightFlushStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getFourOfAKindStatus() > opponent.getHand().getFourOfAKindStatus()) {
            winLabel.text = ("Player wins, Four of a Kind " + String(player.getHand().getFourOfAKindStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getFourOfAKindStatus() > player.getHand().getFourOfAKindStatus()) {
            winLabel.text = ("Opponent wins, Four of a Kind " + String(opponent.getHand().getFourOfAKindStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getFullHouseStatus() > opponent.getHand().getFullHouseStatus()) {
            winLabel.text = ("Player wins, Full House " + String(player.getHand().getFullHouseStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getFullHouseStatus() > player.getHand().getFullHouseStatus()) {
            winLabel.text = ("Opponent wins, Full House " + String(opponent.getHand().getFullHouseStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getFlushStatus() > opponent.getHand().getFlushStatus()) {
            winLabel.text = ("Player wins, Flush " + String(player.getHand().getFlushStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getFlushStatus() > player.getHand().getFlushStatus()) {
            winLabel.text = ("Opponent wins, Flush " + String(opponent.getHand().getFlushStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getStraightStatus() > opponent.getHand().getStraightStatus()) {
            winLabel.text = ("Player wins, Straight " + String(player.getHand().getStraightStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getStraightStatus() > player.getHand().getStraightStatus()) {
            winLabel.text = ("Opponent wins, Straight " + String(opponent.getHand().getStraightStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getThreeOfAKindStatus() > opponent.getHand().getThreeOfAKindStatus()) {
            winLabel.text = ("Player wins, Three of a Kind " + String(player.getHand().getThreeOfAKindStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getThreeOfAKindStatus() > player.getHand().getThreeOfAKindStatus()) {
            winLabel.text = ("Opponent wins, Three of a Kind " + String(opponent.getHand().getThreeOfAKindStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getTwoPairStatus() > opponent.getHand().getTwoPairStatus()) {
            winLabel.text = ("Player wins, Two Pair " + String(player.getHand().getTwoPairStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getTwoPairStatus() > player.getHand().getTwoPairStatus()) {
            winLabel.text = ("Opponent wins, Two Pair " + String(opponent.getHand().getTwoPairStatus()) + " high")
            opponentWins()
        } else if (player.getHand().getPairStatus() > opponent.getHand().getPairStatus()) {
            winLabel.text = ("Player wins, Pair of " + String(player.getHand().getPairStatus()) + "'s")
            playerWins()
        } else if (opponent.getHand().getPairStatus() > player.getHand().getPairStatus()) {
            winLabel.text = ("Opponent wins, Pair of " + String(opponent.getHand().getPairStatus()) + "'s")
            opponentWins()
        } else if (player.getHand().getHighCardStatus() > opponent.getHand().getHighCardStatus()) {
            winLabel.text = ("Player wins, " + String(player.getHand().getHighCardStatus()) + " high")
            playerWins()
        } else if (opponent.getHand().getHighCardStatus() > player.getHand().getHighCardStatus()) {
            winLabel.text = ("Opponent wins, " + String(opponent.getHand().getHighCardStatus()) + " high")
            opponentWins()
        } else if (playerKicker > opponentKicker) {
            winLabel.text = ("Player wins, kicker")
            playerWins()
        } else if (opponentKicker > playerKicker) {
            winLabel.text = ("Opponent wins, kicker")
            opponentWins()
        } else {
            winLabel.text = "Tie, split the pot"
            tie()
        }
    }
    
    func makeBet(min: Int, max: Int, strategy: Int) {
        if (strategy == 1) { // high roller strategy
            let randBet = (Int.random(in: min...max))
            let finalBet = randBet - (randBet % 10)
            opponent.removeFromBank(value: finalBet)
            pot.addToPot(value: finalBet)
            addChipsToPot(bet: finalBet)
            opponentMoveLabel.text = "Raise " + String(finalBet)
            opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
            potLabel.text = "Pot: " + String(pot.getPotValue())
            opponentJustRaised = true
            lastOpponentBet = finalBet
        } else { // luring opponent strategy
            let randBet = (Int.random(in: min...max/2))
            let finalBet = randBet - (randBet % 10)
            addChipsToPot(bet: finalBet)
            opponent.removeFromBank(value: finalBet)
            pot.addToPot(value: finalBet)
            opponentMoveLabel.text = "Raise " + String(finalBet)
            opponentBankLabel.text = "Bank: " + String(opponent.getBankValue())
            potLabel.text = "Pot: " + String(pot.getPotValue())
            opponentJustRaised = true
            lastOpponentBet = finalBet
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didMove(to view: SKView) {
        firstRound()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
