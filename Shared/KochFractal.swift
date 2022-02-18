//
//  KochFractal.swift
//  KochFractal
//
//  Created by Jeff_Terry on 1/19/22.
//  Modified by Michael Cardiff
//

import Foundation
import SwiftUI

class KochFractal: NSObject, ObservableObject {
    
    @MainActor @Published var kochVerticesForPath = [(xPoint: Double, yPoint: Double)]() ///Array of tuples
    @Published var timeString = ""
    @Published var enableButton = true
    @Published var iterationsFromParent: Int?
    @Published var angleFromParent: Int?
    
    /// Class Parameters Necessary for Drawing
    var x: CGFloat = 75
    var y: CGFloat = 100
    let pi = CGFloat(Float.pi)
    var piDivisorForAngle = 0.0
    
    var angle: CGFloat = 0.0
    
    @MainActor init(withData data: Bool) {
        super.init()
        kochVerticesForPath = []
    }
    
    /// calculateKoch
    ///
    /// This function ensures that the program will not crash if non-valid input is applied.
    ///
    /// - Parameters:
    ///   - iterations: number of iterations in the fractal
    ///   - piAngleDivisor: integer that sets the angle as pi/piAngleDivisor so if 2, then the angle is π/2
    ///
    func calculateKoch(iterations: Int?, piAngleDivisor: Int?) async {
        var newIterations :Int? = 0
        var newPiAngleDivisor :Int? = 2
        
        // Test to make sure the input is valid
        if (iterations != nil) && (piAngleDivisor != nil) {
            newIterations = iterations
            newPiAngleDivisor = piAngleDivisor
        } else {
            newIterations = 0
            newPiAngleDivisor = 2
        }
        
        print("Start Time of \(newIterations!) \(Date())\n")
        
        await calculateKochFractalVertices(iterations: newIterations!, piAngleDivisor: newPiAngleDivisor!)
        
        print("End Time of \(newIterations!) \(Date())\n")
    }
        
    
    /// calculateKochFractalVertices
    ///
    /// - Parameters:
    ///   - iterations: number of iterations in the fractal
    ///   - piAngleDivisor: integer that sets the angle as pi/piAngleDivisor so if 2, then the angle is π/2
    ///
    func calculateKochFractalVertices(iterations: Int, piAngleDivisor: Int) async  {
        
        var KochPoints: [(xPoint: Double, yPoint: Double)] = []  ///Array of tuples
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        let size: Double = 500
        
        let width :CGFloat = 600.0
        let height :CGFloat = 600.0
        
        
        // draw from the center of our rectangle
        let center = CGPoint(x: width / 2, y: height / 2)
        
        // Offset from center in y-direction for KOCH Fractal
        let yoffset = -140// size*sin(30.0 / 180.0 * Double.pi) // size/(2.0*tan(60.0/180.0*Double.pi))
        
        x = center.x - CGFloat(size/2.0)
        y = height/2.0 - CGFloat(yoffset)
        
        guard iterations >= 0 else {
            await updateData(pathData: KochPoints)
            return
        }
        guard iterations <= 15 else {
            await updateData(pathData: KochPoints)
            return
            
        }
        guard piAngleDivisor > 0 else {
            await updateData(pathData: KochPoints)
            return
        }
        
        guard piAngleDivisor <= 50 else {
            await updateData(pathData: KochPoints)
            return
        }
    
        KochPoints = KochFractalCalculator(
            fractalnum: iterations, x: x, y: y, size: size, angleDivisor: piAngleDivisor)
        
            
        await updateData(pathData: KochPoints)
        return
    }
    
    
    /// updateData
    ///
    /// The function runs on the main thread so it can update the GUI
    ///
    /// - Parameters:
    ///   - pathData: array of tuples containing the calculated Koch Vertices
    ///
    @MainActor func updateData(pathData: [(xPoint: Double, yPoint: Double)]){
        
        kochVerticesForPath.append(contentsOf: pathData)
        
    }
    
    /// eraseData
    ///
    /// This function erases the cesaroVertices on the main thread so the drawing can be cleared
    ///
    @MainActor func eraseData(){
        
        Task.init {
            await MainActor.run {
                self.kochVerticesForPath.removeAll()
            }
        }
    }
    
    
    /// updateTimeString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of Pi
    @MainActor func updateTimeString(text:String){
        self.timeString = text
    }
    
    
    /// setButton Enable
    ///
    /// Toggles the state of the Enable Button on the Main Thread
    ///
    /// - Parameter state: Boolean describing whether the button should be enabled.
    /// 
    @MainActor func setButtonEnable(state: Bool){
        if state {
            Task.init {
                await MainActor.run {
                    self.enableButton = true
                }
            }
        } else {
            Task.init {
                await MainActor.run {
                    self.enableButton = false
                }
            }
        }
    }
}
