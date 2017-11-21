//
//  ScannerViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/20/17.
//  Copyright © 2017 company. All rights reserved.
//

import UIKit
import AVFoundation
import Starscream

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var qrMessageLabel: UILabel!
    
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerConnect.socket?.delegate = self
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video){
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Initialize the captureSession object.
                captureSession = AVCaptureSession()
                
                // Set the input device on the capture session.
                captureSession?.addInput(input)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
                
                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
                let previewLayerConnection = videoPreviewLayer!.connection;
                
                if previewLayerConnection!.isVideoOrientationSupported {
                    switch(UIApplication.shared.statusBarOrientation){
                    case .landscapeLeft:
                        previewLayerConnection?.videoOrientation = .landscapeLeft
                    default:
                        previewLayerConnection?.videoOrientation = .landscapeRight
                    }
                }
                
//                if ([previewLayerConnection isVideoOrientationSupported])
//                [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
                
                // Start video capture.
                captureSession?.startRunning()
                
                // Move the message label and top bar to the front
                view.bringSubview(toFront: topbar)
                
                // Initialize QR Code Frame to highlight the QR code
                qrCodeFrameView = UIView()
                
                if let qrCodeFrameView = qrCodeFrameView {
                    qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                    qrCodeFrameView.layer.borderWidth = 2
                    view.addSubview(qrCodeFrameView)
                    view.bringSubview(toFront: qrCodeFrameView)
                }
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                print(error)
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let messageContent = ["id" : metadataObj.stringValue]
                let m1 = SendingMessage(command: "joinGame", params: messageContent as! [String : String])
                let jsonEncoder = JSONEncoder()
                do {
                    if let jsonData = try? jsonEncoder.encode(m1) {
                        if let jsonString = String(data: jsonData, encoding: .utf8){
                            ServerConnect.socket?.write(string: jsonString)
                            qrMessageLabel.text = "Connecting..."
                            print("below is the jsonString")
                            print(jsonString)
                            print("has tried to write the data")
                        }
                        else{
                            print ("encoding failed")
                        }
                    }
                    else {
                        print ("encoding failed")
                        return
                    }
                }
            }
        }
    }
    
}

extension ScannerViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("below is the text from the server")
        print(text)
        
        let jsonData = text.data(using: .utf8)!
        print ("jsonData is listed below")
        print (jsonData)
        let decoder = JSONDecoder()
        let receivedMessage = try! decoder.decode(ReceivedMessage.self, from: jsonData)
        print ("This is the recieved message")
        print (receivedMessage)
        if receivedMessage.params["success"] == "true" {
            performSegue(withIdentifier: "waitingForPlayersSegue", sender: nil)
        }else{
            qrMessageLabel.text = receivedMessage.params["error"]
        }
        
    }
    
    
    
}
