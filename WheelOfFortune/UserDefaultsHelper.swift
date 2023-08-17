//
//  UserDefaultsHelper.swift
//  WheelOfFortune
//
//  Created by Сергей Анпилогов on 17.08.2023.
//

import Foundation

struct UserDefaultsHelper {
    
    private static let totalPointsKey = "totalScore"
    private static let lastWinKey = "lastWin"
    
    static func saveTotalPoints(_ points: Int) {
        UserDefaults.standard.set(points, forKey: totalPointsKey)
        UserDefaults.standard.synchronize()
    }
    
    static func saveLastWin(_ win: Int) {
        UserDefaults.standard.set(win, forKey: lastWinKey)
        UserDefaults.standard.synchronize()
    }
    
    static func loadTotalPoints() -> Int {
        return UserDefaults.standard.integer(forKey: totalPointsKey)
    }
    
    static func loadLastWin() -> Int {
        return UserDefaults.standard.integer(forKey: lastWinKey)
    }
}
