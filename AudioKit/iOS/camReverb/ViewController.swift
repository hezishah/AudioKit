//
//  ViewController.swift
//  camReverb
//
//  Created by Hezi Shahmoon on 4/4/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var camView: UIView!
    
    var timer = NSTimer()
    let TIME_INCREMENT = 0.01
    
    //var sp = AudioInit()
    var ae = AVAudioEngine()
    let session = AVCaptureSession()
    //let recorder = AKMicrophone()
    var reverb =  AKReverb(AKMicrophone())
    var mean : Double = 0

    func updateCounter() {
        camView.backgroundColor = UIColor(white: CGFloat(mean/256.0), alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Start of Audio Capture and Process area*/
        
        AKSettings.audioInputEnabled = true;
        //recorder.start()
        
        //reverb = AKReverb(recorder)
        reverb.loadFactoryPreset(.Cathedral)
        reverb.dryWetMix = 0
        //reverb.bind("dryWetMix" , toObject: dw, withKeyPath: "dryWetMix", options: [String: AnyObject]?())
        AudioKit.output = reverb
        AudioKit.start()

        /*Start of Video Capture and Process area*/
        
        session.sessionPreset = AVCaptureSessionPresetLow
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do
        {
            let input = try AVCaptureDeviceInput(device: backCamera)
            session.addInput(input)
            let output = AVCaptureVideoDataOutput()
            let cameraQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
            output.setSampleBufferDelegate(self , queue: cameraQueue)
            //output.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA]
            session.addOutput(output)
        }
        catch
        {
            
        }
        session.startRunning()

        UIApplication.sharedApplication().idleTimerDisabled = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(TIME_INCREMENT, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        CVPixelBufferLockBaseAddress(imageBuffer!, 0)
        
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer!, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, bitmapInfo.rawValue)
        let imageRef = CGBitmapContextCreateImage(context)
        CVPixelBufferUnlockBaseAddress(imageBuffer!, 0)
        
        let data:NSData = CGDataProviderCopyData(CGImageGetDataProvider(imageRef))!
        
        let pixels = UnsafePointer<UInt8>(data.bytes)
        
        //let pSize = 1
        
        //let imageSize : Int = Int(width) * Int(height) * pSize
        
        //var newPixelArray = [UInt8](count: imageSize, repeatedValue: 0)
        
        var intens = 0
        
        for index in 0.stride(to: data.length, by: 1) {
            intens += Int(pixels[index])*Int(pixels[index])
        }
        mean = sqrt(Double(intens)/Double(data.length))
        let rev = sqrt(mean-70)/100.0
        reverb.dryWetMix = rev
        //print(rev)
    }
    
    @IBAction func onExit(sender: AnyObject) {
        exit(0)
    }

}

