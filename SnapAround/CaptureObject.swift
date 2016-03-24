//
//  CaptureObject.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 29/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation
import AVFoundation

class CaptureObject {
    
    var session : AVCaptureSession!
    var output : AVCaptureStillImageOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var input : AVCaptureDeviceInput?
    
    init(inView view: UIView, atlayerIndex layerLevel: Int) {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        //Add device
        let device : AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        
        //Input
        do {
            input = try AVCaptureDeviceInput(device: device)
            if( session.canAddInput(input) ) {
                session.addInput(input)
            }
            
            //Output
            output = AVCaptureStillImageOutput()
            let outputSettings : Dictionary<String,String> = [AVVideoCodecKey : AVVideoCodecJPEG]
            output.outputSettings = outputSettings
            session.addOutput(output)
            
            
            //PreviewLayer
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.insertSublayer(previewLayer, atIndex: UInt32(layerLevel))
            
            session.startRunning()
        } catch {
            
        }
        
    }
    
    func stopVideo() {
        session.stopRunning()
    }
    
    
    func takePicture(completionHandler completionHandler: (image: UIImage) -> Void ){
        
        var videoConnection : AVCaptureConnection?
        for connection : AVCaptureConnection  in output.connections as! Array<AVCaptureConnection>  {
            for port : AVCaptureInputPort in connection.inputPorts as! Array<AVCaptureInputPort> {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection
                    break
                }
            }
            if (videoConnection != nil) {
                break
            }
        }
        
        
        func captureCompletionHandler(imageDataSampleBuffer : CMSampleBuffer!, error : NSError!) -> Void {
            if ( imageDataSampleBuffer != nil) {
                let imageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image : UIImage = UIImage(data: imageData)!
                completionHandler(image: image)
            }
        }
        output.captureStillImageAsynchronouslyFromConnection(videoConnection,completionHandler: captureCompletionHandler)
    }
    
    func focusAtPoint(touchPoint : CGPoint) {
        let convertedPoint : CGPoint = previewLayer.captureDevicePointOfInterestForPoint(touchPoint)
        let currentDevice : AVCaptureDevice! = input?.device
        
        if (currentDevice.focusPointOfInterestSupported && currentDevice.isFocusModeSupported(AVCaptureFocusMode.AutoFocus)) {
            do {
                try currentDevice.lockForConfiguration()
                currentDevice.focusPointOfInterest = convertedPoint
                currentDevice.focusMode = AVCaptureFocusMode.AutoFocus
                currentDevice.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    func turnOnFlash() {
        let device : AVCaptureDevice! = input?.device
        if( device.hasTorch ) {
            do {
                try device.lockForConfiguration()
                device.torchMode = AVCaptureTorchMode.On
                device.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    func turnOffFlash() {
        let device : AVCaptureDevice! = input?.device
        if( device.hasTorch ) {
            do {
                try device.lockForConfiguration()
                device.torchMode = AVCaptureTorchMode.Off
                device.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    func flashTurnedOn() -> Bool {
        return input?.device.torchMode == AVCaptureTorchMode.On
    }
    
    func switchCameraTapped() {
        //Change camera source
        
        //Indicate that some changes will be made to the session
        session.beginConfiguration()
        
        
        //Remove existing input
        let currentCameraInput : AVCaptureInput = session.inputs[0] as! AVCaptureInput
        session.removeInput(currentCameraInput)
        
        
        // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
        func cameraWithPosition(position : AVCaptureDevicePosition) -> AVCaptureDevice? {
            let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            
            for device : AVCaptureDevice in devices as! Array<AVCaptureDevice> {
                if device.position == position {
                    return device
                }
            }
            return nil
        }
        
        //Get new input
        let newCamera : AVCaptureDevice?
        if( (currentCameraInput as! AVCaptureDeviceInput).device.position == AVCaptureDevicePosition.Back ) {
            newCamera = cameraWithPosition(AVCaptureDevicePosition.Front)
        } else {
            newCamera = cameraWithPosition(AVCaptureDevicePosition.Back)
        }
        
        //Add input to session
        //Input
        do {
            input = try AVCaptureDeviceInput(device: newCamera)
            if( session.canAddInput(input)) {
                session.addInput(input)
            }
            //Commit all the configuration changes at once
            session.commitConfiguration()
        } catch {
            
        }
        
    }
    
    func isBackCamera() -> Bool {
        return (session.inputs[0] as? AVCaptureDeviceInput)?.device.position == AVCaptureDevicePosition.Back
    }
    
}