//
//  GameController.swift
//  WheelOfFortune
//
//  Created by Сергей Анпилогов on 17.08.2023.
//

import UIKit

class GameController: UIViewController {
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastWinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var gameModel = GameModel()
    private var wheelView: WheelView!
    private var animator: WheelAnimation!
    private var isSpinning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWheel()
        setupUI()
        loadGameData()
        updateUI()
        setupConstraints()
        setupAnimator()
    }
    
    private func setupUI() {
        view.backgroundColor = .tertiarySystemBackground
        view.addSubview(scoreLabel)
        view.addSubview(lastWinLabel)
        view.addSubview(wheelView)
    }

    private func setupWheel() {
        wheelView = WheelView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        wheelView.center = view.center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wheelImageViewTapped(_:)))
        wheelView.addGestureRecognizer(tapGesture)
        wheelView.isUserInteractionEnabled = true
    }
    
    private func saveGameData() {
        UserDefaultsHelper.saveTotalPoints(gameModel.totalPoints)
        UserDefaultsHelper.saveLastWin(gameModel.lastWin)
    }
    
    private func updateUI() {
        scoreLabel.text = "Score: \(gameModel.totalPoints)"
        lastWinLabel.text = "Last Win: \(gameModel.lastWin)"
        saveGameData()
    }
    
    @objc private func wheelImageViewTapped(_ sender: UITapGestureRecognizer) {
           guard !isSpinning else {
               return
           }
           
           isSpinning = true
           animator.startAnimation { [weak self] selectedIndex in
               if let selectedSection = self?.gameModel.sections[selectedIndex] {
                   self?.gameModel.updateLastWin(selectedSection.points)
                   self?.updateUI()
                   
                   if selectedSection.points == 0 {
                       self?.showLoseState()
                   }
                   self?.isSpinning = false
                   
                   self?.wheelView.winningSectionIndex = selectedIndex // Сохраняем выигрышную секцию
                   self?.wheelView.resetWheelColors() // Сбрасываем цвета перед новым вращением
               }
               
               self?.wheelView.stoppedIndex = selectedIndex
               self?.wheelView.winningSectionIndex = selectedIndex
           }
       }
      
    private func showLoseState() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let alertController = UIAlertController(title: "You Lost!", message: "You lost all your points.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.wheelView.backgroundColor = .clear
                
                self?.gameModel.totalPoints = 0
                self?.updateUI()
                
                self?.scoreLabel.text = "Score: \(self?.gameModel.totalPoints ?? 0)"
            }))
            self?.present(alertController, animated: true, completion: nil)
        }
        saveGameData()
        wheelView.resetWheelColors()
    }
    
    private func loadGameData() {
        gameModel.totalPoints = UserDefaultsHelper.loadTotalPoints()
        gameModel.lastWin = UserDefaultsHelper.loadLastWin()
    }
    
    private func setupAnimator() {
        animator = WheelAnimation(wheelView: wheelView, model: gameModel)
    }
}

extension GameController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lastWinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastWinLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
        ])
    }
}
