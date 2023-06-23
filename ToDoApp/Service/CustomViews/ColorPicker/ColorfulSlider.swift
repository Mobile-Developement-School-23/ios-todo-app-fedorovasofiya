//
//  ColorfulSlider.swift
//  ColorfulSlider
//
//  Created by Sonya Fedorova on 23.06.2023.
//

import UIKit
import Foundation

class ColorfulSlider: UIView {
    
    var value: Float {
        return slider.value
    }
    
    private lazy var imageView = UIImageView()
    private lazy var slider = UISlider()
    private lazy var gradientLayer = CAGradientLayer()
    
    private let minimumValue: Float
    private let maximumValue: Float
    private let defaultValue: Float
    private let colors: [CGColor]
    
    init(minimumValue: Float, maximumValue: Float, defaultValue: Float, colors: [CGColor]) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.defaultValue = defaultValue
        self.colors = colors
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.frame
    }
    
    override func draw(_ rect: CGRect) {
        print("draw")
        setupColorImageView()
        setupColorSlider()
        setupColorGradientLayer(cornerRadius: rect.height / 2)
    }
    
    private func setupColorImageView() {
        imageView.frame = frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupColorSlider() {
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = defaultValue
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.addTarget(self, action: #selector(colorValueChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            slider.topAnchor.constraint(equalTo: self.topAnchor),
            slider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupColorGradientLayer(cornerRadius: CGFloat) {
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = colors
        imageView.layer.addSublayer(gradientLayer)
    }
    
    func changeColors(colors: [CGColor]) {
        gradientLayer.colors = colors
    }
    
    @objc func colorValueChanged() {}
    
}
