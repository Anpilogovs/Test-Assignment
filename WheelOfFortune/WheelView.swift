//
//  WheelView.swift
//  WheelOfFortune
//
//  Created by Сергей Анпилогов on 17.08.2023.
//

import Foundation
import UIKit

class WheelView: UIView {

    private let originalWheelColors: [UIColor] =
    [
        .red,
        .green,
        .blue,
        .orange,
        .purple,
        .yellow,
        .cyan,
        .magenta,
        .darkGray,
        .brown,
        .separator
    ]
    
    private var wheelColors: [UIColor] = []

    var stoppedIndex: Int?
    var winningSectionIndex: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        resetWheelColors()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawWheel()
    }

    private func drawWheel() {
        let wheelCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let wheelRadius = min(bounds.width, bounds.height) / 2
        
        let sectionAngle = CGFloat.pi * 2 / CGFloat(wheelColors.count)
        for (index, color) in wheelColors.enumerated() {
            let startAngle = CGFloat(index) * sectionAngle
            let endAngle = startAngle + sectionAngle
            let sectionPath = UIBezierPath()
            
            sectionPath.move(to: wheelCenter)
            sectionPath.addArc(withCenter: wheelCenter, radius: wheelRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            sectionPath.close()
            
            if index == winningSectionIndex {
                UIColor.white.setFill()
            } else {
                color.setFill()
            }
            sectionPath.fill()
            
            let number = "\(index * 100)"
            
            createLabel(center: wheelCenter, radius: wheelRadius, startAngle: startAngle + sectionAngle / 2, text: number)
            
            let arrowWidth: CGFloat = 10
            let arrowHeight: CGFloat = 20
            let arrowPath = UIBezierPath()
            
            let arrowTipPoint = CGPoint(x: wheelCenter.x + wheelRadius + arrowHeight, y: wheelCenter.y)
            arrowPath.move(to: arrowTipPoint)
            arrowPath.addLine(to: CGPoint(x: arrowTipPoint.x - arrowHeight, y: arrowTipPoint.y - arrowWidth / 2))
            arrowPath.addLine(to: CGPoint(x: arrowTipPoint.x - arrowHeight, y: arrowTipPoint.y + arrowWidth / 2))
            arrowPath.close()
            
            arrowPath.fill()
        }
    }
    
    private func createLabel(center: CGPoint, radius: CGFloat, startAngle: CGFloat, text: String) {
        let labelSize: CGSize = CGSize(width: 60, height: 20)
        let labelCenter = CGPoint(
            x: center.x + (radius - labelSize.width / 2) * cos(startAngle),
            y: center.y + (radius - labelSize.height / 2) * sin(startAngle)
        )
        
        let label = UILabel(frame: CGRect(origin: .zero, size: labelSize))
        label.center = labelCenter
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = text
        addSubview(label)
    }

    private func rotateWheel(targetRotation: CGFloat, currentRotation: CGFloat = 0, completion: @escaping () -> Void) {
        let rotationIncrement: CGFloat = 0.5

        if currentRotation < targetRotation {
            UIView.animate(withDuration: 0.035, animations: { [weak self] in
                let newRotation = currentRotation + rotationIncrement
                self?.transform = CGAffineTransform(rotationAngle: newRotation)
            }) { [weak self] _ in
                self?.rotateWheel(targetRotation: targetRotation, currentRotation: currentRotation + rotationIncrement, completion: completion)
            }
        } else {
            completion()
        }
    }

    func playAnimation(completion: @escaping () -> Void) {
        let totalRotations = 5
        let targetRotation = CGFloat(totalRotations) * .pi * 2

        rotateWheel(targetRotation: targetRotation) { [weak self] in
            self?.resetWheelRotation()
            completion()
        }
    }

    private func resetWheelRotation() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.transform = .identity
        }
    }
    
    func resetWheelColors() {
        wheelColors = originalWheelColors
        setNeedsDisplay()
    }
}
