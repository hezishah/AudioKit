//
//  AKHighPassFilterWindow.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation
import Cocoa

/// A Window to control AKHighPassFilter in Playgrounds
public class AKHighPassFilterWindow: NSWindow {
    
    private let windowWidth = 400
    private let padding = 30
    private let sliderHeight = 20
    private let numberOfComponents = 2
    
    /// Slider to control cutoffFrequency
    public let cutoffFrequencySlider: NSSlider
    /// Slider to control resonance
    public let resonanceSlider: NSSlider
    
    private let cutoffFrequencyTextField: NSTextField
    private let resonanceTextField: NSTextField
    
    private var highPassFilter: AKHighPassFilter
    
    /// Initiate the AKHighPassFilter window
    public init(_ control: AKHighPassFilter) {
        highPassFilter = control
        let sliderWidth = windowWidth - 2 * padding
        
        cutoffFrequencySlider = newSlider(sliderWidth)
        resonanceSlider = newSlider(sliderWidth)
        
        cutoffFrequencyTextField = newTextField(sliderWidth)
        resonanceTextField = newTextField(sliderWidth)
        
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
        self.title = "AKHighPassFilter"
        
        let viewRect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        let view = NSView(frame: viewRect)
        
        let topTitle = NSTextField()
        topTitle.stringValue = "AKHighPassFilter"
        topTitle.editable = false
        topTitle.drawsBackground = false
        topTitle.bezeled = false
        topTitle.alignment = NSCenterTextAlignment
        topTitle.font = NSFont(name: "Lucida Grande", size: 24)
        topTitle.sizeToFit()
        topTitle.frame.origin.x = CGFloat(windowWidth / 2) - topTitle.frame.width / 2
        topTitle.frame.origin.y = CGFloat(windowHeight - padding) - topTitle.frame.height
        view.addSubview(topTitle)
        
        makeTextField(cutoffFrequencyTextField, view: view, below: topTitle, distance: 2,
            stringValue: "Cutoff Frequency: \(highPassFilter.cutoffFrequency) Hz")
        makeSlider(cutoffFrequencySlider, view: view, below: topTitle, distance: 3, target: self,
            action: "updateCutofffrequency",
            currentValue: highPassFilter.cutoffFrequency,
            minimumValue: 10,
            maximumValue: 22050)
        
        makeTextField(resonanceTextField, view: view, below: topTitle, distance: 5,
            stringValue: "Resonance: \(highPassFilter.resonance) dB")
        makeSlider(resonanceSlider, view: view, below: topTitle, distance: 6, target: self,
            action: "updateResonance",
            currentValue: highPassFilter.resonance,
            minimumValue: -20,
            maximumValue: 40)
        
        self.contentView!.addSubview(view)
        self.makeKeyAndOrderFront(nil)
    }
    
    internal func updateCutofffrequency() {
        highPassFilter.cutoffFrequency = cutoffFrequencySlider.doubleValue
        cutoffFrequencyTextField.stringValue =
        "Cutoff Frequency \(String(format: "%0.4f", highPassFilter.cutoffFrequency)) Hz"
    }
    internal func updateResonance() {
        highPassFilter.resonance = resonanceSlider.doubleValue
        resonanceTextField.stringValue =
        "Resonance \(String(format: "%0.4f", highPassFilter.resonance)) dB"
    }
    
    /// Required initializer
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

