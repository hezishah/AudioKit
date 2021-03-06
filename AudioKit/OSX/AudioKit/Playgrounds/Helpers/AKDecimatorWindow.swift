//
//  AKDecimatorWindow.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation
import Cocoa

/// A Window to control AKDecimator in Playgrounds
public class AKDecimatorWindow: NSWindow {
    
    private let windowWidth = 400
    private let padding = 30
    private let sliderHeight = 20
    private let numberOfComponents = 3
    
    /// Slider to control decimation
    public let decimationSlider: NSSlider
    /// Slider to control rounding
    public let roundingSlider: NSSlider
    /// Slider to control finalMix
    public let finalMixSlider: NSSlider
    
    private let decimationTextField: NSTextField
    private let roundingTextField: NSTextField
    private let finalMixTextField: NSTextField
    
    private var decimator: AKDecimator
    
    /// Initiate the AKDecimator window
    public init(_ control: AKDecimator) {
        decimator = control
        let sliderWidth = windowWidth - 2 * padding
        
        decimationSlider = newSlider(sliderWidth)
        roundingSlider = newSlider(sliderWidth)
        finalMixSlider = newSlider(sliderWidth)
        
        decimationTextField = newTextField(sliderWidth)
        roundingTextField = newTextField(sliderWidth)
        finalMixTextField = newTextField(sliderWidth)
        
        let titleHeightApproximation = 50
        let windowHeight = padding * 2 + titleHeightApproximation + numberOfComponents * 3 * sliderHeight
        
        super.init(contentRect: NSRect(x: padding, y: padding, width: windowWidth, height: windowHeight),
            styleMask: NSTitledWindowMask,
            backing: .Buffered,
            `defer`: false)
        self.hasShadow = true
        self.styleMask = NSBorderlessWindowMask | NSResizableWindowMask
        self.movableByWindowBackground = true
        self.level = 7
        self.title = "AKDecimator"
        
        let viewRect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        let view = NSView(frame: viewRect)
        
        let topTitle = NSTextField()
        topTitle.stringValue = "AKDecimator"
        topTitle.editable = false
        topTitle.drawsBackground = false
        topTitle.bezeled = false
        topTitle.alignment = NSCenterTextAlignment
        topTitle.font = NSFont(name: "Lucida Grande", size: 24)
        topTitle.sizeToFit()
        topTitle.frame.origin.x = CGFloat(windowWidth / 2) - topTitle.frame.width / 2
        topTitle.frame.origin.y = CGFloat(windowHeight - padding) - topTitle.frame.height
        view.addSubview(topTitle)
        
        makeTextField(decimationTextField, view: view, below: topTitle, distance: 2,
            stringValue: "Decimation: \(decimator.decimation) ")
        makeSlider(decimationSlider, view: view, below: topTitle, distance: 3, target: self,
            action: "updateDecimation",
            currentValue: decimator.decimation,
            minimumValue: 0,
            maximumValue: 1)
        
        makeTextField(roundingTextField, view: view, below: topTitle, distance: 5,
            stringValue: "Rounding: \(decimator.rounding)")
        makeSlider(roundingSlider, view: view, below: topTitle, distance: 6, target: self,
            action: "updateRounding",
            currentValue: decimator.rounding,
            minimumValue: 0,
            maximumValue: 1)
        
        makeTextField(finalMixTextField, view: view, below: topTitle, distance: 8,
            stringValue: "Final Mix: \(decimator.mix)")
        makeSlider(finalMixSlider, view: view, below: topTitle, distance: 9, target: self,
            action: "updateFinalmix",
            currentValue: decimator.mix,
            minimumValue: 0,
            maximumValue: 1)
        
        self.contentView!.addSubview(view)
        self.makeKeyAndOrderFront(nil)
    }
    
    internal func updateDecimation() {
        decimator.decimation = decimationSlider.doubleValue
        decimationTextField.stringValue = "Decimation \(String(format: "%0.4f", decimator.decimation)) "
    }
    internal func updateRounding() {
        decimator.rounding = roundingSlider.doubleValue
        roundingTextField.stringValue = "Rounding \(String(format: "%0.4f", decimator.rounding))"
    }
    internal func updateFinalmix() {
        decimator.mix = finalMixSlider.doubleValue
        finalMixTextField.stringValue = "Final Mix \(String(format: "%0.4f", decimator.mix))"
    }
    
    /// Required initializer
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

