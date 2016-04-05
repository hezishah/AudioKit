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

    //var sp = AudioInit()
    var ae = AVAudioEngine()
    let session = AVCaptureSession()
    //let recorder = AKMicrophone()
    var reverb =  AKReverb(AKMicrophone())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKSettings.audioInputEnabled = true;
        //recorder.start()
        
        //reverb = AKReverb(recorder)
        reverb.loadFactoryPreset(.Cathedral)
        reverb.dryWetMix = 0
        //reverb.bind("dryWetMix" , toObject: dw, withKeyPath: "dryWetMix", options: [String: AnyObject]?())
        AudioKit.output = reverb
        AudioKit.start()

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

        // instantiate AVAudioEngine()


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
        let mean = sqrt(Double(intens)/Double(data.length))
        let rev = sqrt(mean-70)/10.0
        reverb.dryWetMix = rev
        print(rev)
        
    }


}

