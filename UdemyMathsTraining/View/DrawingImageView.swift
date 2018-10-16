//
//  DrawingImageView.swift
//  UdemyMathsTraining
//
//  Created by Cristian Misael Almendro Lazarte on 9/30/18.
//  Copyright © 2018 Cristian Misael Almendro Lazarte. All rights reserved.
//

import UIKit

class DrawingImageView: UIImageView {
    
    weak var delegate : ViewController?
    
    var curretTouchPosition : CGPoint?
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
     // Drawing code
     
     let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
     }*/
    
    func draw(from start: CGPoint, to end: CGPoint) {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size);
        
        self.image = renderer.image(actions: { (context) in
            self.image?.draw(in: self.bounds);
            
            // Se definen los parametros de dibujo
            UIColor.darkGray.setStroke();
            context.cgContext.setLineCap(CGLineCap.round);
            context.cgContext.setLineWidth(9);
            
            // Se dibuja una recta desde start hasta end
            context.cgContext.move(to: start);
            context.cgContext.addLine(to: end);
            context.cgContext.strokePath();
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        
        self.curretTouchPosition = touches.first?.location(in: self);
        
        NSObject.cancelPreviousPerformRequests(withTarget: self);
        
        //print(touches.first?.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event);
        
        guard let newTouchPoint = touches.first?.location(in: self) else{
            return;
        }
        
        guard let previousTouchPoint =  self.curretTouchPosition else {
            return;
        }
        
        draw(from: previousTouchPoint, to: newTouchPoint);
        self.curretTouchPosition = newTouchPoint;
        
        //print(touches.first?.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event);
        
        self.curretTouchPosition = nil;
        
        perform(#selector(numberDrawOnScreen), with: nil, afterDelay: 0.5);
        //print(touches.first?.location(in: self))
    }
    
    @objc func numberDrawOnScreen(){
        
        
        guard let image = self.image else{
            return;
        }
        
        let drawrect = CGRect(x: 0, y: 0, width: 28, height: 28);
        
        let format = UIGraphicsImageRendererFormat();
        
        format.scale = 1;
        
        let renderer = UIGraphicsImageRenderer(bounds: drawrect, format: format);
        
        let imageWithWhiteBackground = renderer.image { (context) in
            
            UIColor.white.setFill();
            
            context.fill(bounds);
            image.draw(in: drawrect);
            
        }
        
        // Convertimos una image UIImage de CG a CI
        
        let ciImage = CIImage(cgImage: imageWithWhiteBackground.cgImage!);
        
        // Hacemos una inversion de color para convertir el fondo blanco en negro
        
        if let filter = CIFilter(name: "CIColorInvert"){
            
            // Decine la CIImage como imagen a ser filstrada
            filter.setValue(ciImage, forKey: kCIInputImageKey);
            
            
            // Contexto para llevar a cabo la conversion
            
            let context = CIContext(options: nil);
            
            if let outputImage = filter.outputImage{
                
                if let imageRef = context.createCGImage(outputImage, from: ciImage.extent){
                    
                    let resultImage = UIImage(cgImage: imageRef);
                    
                    self.delegate?.numberDraw(image: resultImage);
                    
                }
            }
        }
    }
}
