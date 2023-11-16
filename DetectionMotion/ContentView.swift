//
//  ContentView.swift
//  DetectionMotion
//
//  Created by Student Account on 11/16/23.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @ObservedObject var motionManager = MotionManager()

    var body: some View {
        ScrollView {
            VStack {
                Button("Sample 10 times per second") {
                               motionManager.updateMotionInterval(0.1)
                           }

                           Button("Sample once every 2 seconds") {
                               motionManager.updateMotionInterval(2.0)
                           }
                Text("Acceleration:")
                Text("X: \(motionManager.acceleration.x)")
                Text("Y: \(motionManager.acceleration.y)")
                Text("Z: \(motionManager.acceleration.z)")

                Text("Rotation Rate:")
                Text("X: \(motionManager.rotationRate.x)")
                Text("Y: \(motionManager.rotationRate.y)")
                Text("Z: \(motionManager.rotationRate.z)")

                Text("Magnetic Field:")
                Text("X: \(motionManager.magneticField.x)")
                Text("Y: \(motionManager.magneticField.y)")
                Text("Z: \(motionManager.magneticField.z)")

                Text("Attitude:")
                Text("Roll: \(motionManager.attitude.roll)")
                Text("Pitch: \(motionManager.attitude.pitch)")
                Text("Yaw: \(motionManager.attitude.yaw)")
                
                
            }
            
            
        }
        
        
    }
    
    class MotionManager: NSObject, ObservableObject {
        private var motionManager = CMMotionManager()
        @Published var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
        @Published var rotationRate = CMRotationRate(x: 0, y: 0, z: 0)
        @Published var magneticField = CMMagneticField(x: 0, y: 0, z: 0)
        @Published var attitude = CMAttitude()
        
        func updateMotionInterval(_ interval: TimeInterval) {
               motionManager.deviceMotionUpdateInterval = interval
               if !motionManager.isDeviceMotionActive {
                   startDeviceMotionUpdates()
               }
           }
        
        private func startDeviceMotionUpdates() {
               motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                
               }
           }

        override init() {
            super.init()
            motionManager.deviceMotionUpdateInterval = 1 / 60
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                self?.acceleration = data.userAcceleration
                self?.rotationRate = data.rotationRate
                self?.magneticField = data.magneticField.field
                self?.attitude = data.attitude
            }
        }
    }

}
