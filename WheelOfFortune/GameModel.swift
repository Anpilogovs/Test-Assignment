//
//  GameModel.swift
//  WheelOfFortune
//
//  Created by Сергей Анпилогов on 17.08.2023.
//

import UIKit

public class GameModel {
    var sections: [WheelSection] = [
        WheelSection(points: 0, color: .red),
        WheelSection(points: 100, color:  .green),
        WheelSection(points: 200, color:  .blue),
        WheelSection(points: 300, color:  .orange),
        WheelSection(points: 400, color: .purple),
        WheelSection(points: 500, color: .yellow),
        WheelSection(points: 600, color: .cyan),
        WheelSection(points: 700, color: .magenta),
        WheelSection(points: 800, color: .darkGray),
        WheelSection(points: 900, color:  .brown),
        WheelSection(points: 1000, color:  .separator),
    ]
    
    public var totalPoints: Int = 0
    public var lastWin: Int = 0
    
    public func updateLastWin(_ win: Int) {
        lastWin = win
        totalPoints += win
    }
}
