//
//  File.swift
//  
//
//  Created by Khoa Le on 29/09/2022.
//

import Foundation

final class Stepper {
    static let shared = Stepper()
    private let logger = Logger.shared
    
    func step(type: StepperType, _ worker: () -> Void) {
        let prefix = "Step:"

        let start: DispatchTime = .now()
        logger.log(type: .info, message: "⇣ \(prefix) \(type) (started)")
        
        worker()
        
        let end = DispatchTime.now()
        
        let timeInterval = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
        let timeSpent = String(format: "%.1f", timeInterval)

        logger.log(type: .info, message: "⇢ \(prefix) \(type) (finished) (\(timeSpent) s)")
    }
}

extension Stepper {
    enum StepperType: CustomStringConvertible {
        case preRun
        case run
        case postRun
        
        var description: String {
            switch self {
            case .preRun:
                return "pre-run"
            case .run:
                return "run"
            case.postRun:
                return "post-run"
            }
        }
    }
}
