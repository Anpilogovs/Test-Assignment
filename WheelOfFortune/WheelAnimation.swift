//
//  WheelAnimation.swift
//  WheelOfFortune
//
//  Created by Сергей Анпилогов on 17.08.2023.
//

import Foundation

public class WheelAnimation {
    
    private var wheelView: WheelView
    private var model: GameModel
    private var isAnimating = false

    init(wheelView: WheelView, model: GameModel) {
        self.wheelView = wheelView
        self.model = model
    }
    
    public func startAnimation(completion: @escaping (Int) -> Void) {
            guard !isAnimating else {
                return
            }
            isAnimating = true
            
            wheelView.playAnimation { [weak self] in
                self?.isAnimating = false
                
                let selectedIndex = self?.selectRandomSectionIndex() ?? 0
                completion(selectedIndex)
            }
        }
    
    public func selectRandomSectionIndex() -> Int {
        var selectedIndex = Int.random(in: 0..<model.sections.count)
        let previousIndex = wheelView.stoppedIndex
        
        while selectedIndex == previousIndex {
            selectedIndex = Int.random(in: 0..<model.sections.count)
        }
        return selectedIndex
    }
}
