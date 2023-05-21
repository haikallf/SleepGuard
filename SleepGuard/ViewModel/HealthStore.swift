//
//  HealthStore.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 21/05/23.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    
    @Published var currentHeartRate: Double
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
        
        self.currentHeartRate = 0
    }
    
    func fetchHeartRateData() {
        print("Fetching...")
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            // Heart rate type not available
            return
        }
        
        let healthStore = HKHealthStore()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                // Handle query error
                print("Failed to fetch heart rate samples: \(error.localizedDescription)")
                return
            }
            
            if let heartRateSample = samples?.first as? HKQuantitySample {
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRateValue = heartRateSample.quantity.doubleValue(for: heartRateUnit)
                
                print("Latest heart rate: \(heartRateValue)")
                // Update the heart rate value in the main queue
                DispatchQueue.main.async {
                    self.currentHeartRate = heartRateValue
                }
            }
        }
        
        healthStore.execute(query)
    }
    
//    func requestAuthorization(completion: @escaping (Bool) -> Void) {
//
//        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
//            // Heart rate type not available
//            return
//        }
//
//        guard let healthStore = self.healthStore else { return completion(false) }
//
//        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { (success, error) in
//            completion(success)
//        }
//
//        if healthStore.authorizationStatus(for: heartRateType) == .notDetermined {
//                    // Request authorization
//            healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { success, error in
//                if success {
//                    // Authorization granted, fetch heart rate data
//                    self.fetchHeartRateData()
//                } else {
//                    // Authorization denied or error occurred
//                    print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        } else if healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized {
//            // Authorization already granted, fetch heart rate data
//            fetchHeartRateData()
//        } else {
//            // Authorization denied or restricted
//            print("Authorization denied or restricted")
//        }
//
//    }
    
    func fetchLatestHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            // Heart rate type not available
            return
        }
        
        let healthStore = HKHealthStore()
        
        // Check if authorization status is not determined
        if healthStore.authorizationStatus(for: heartRateType) == .notDetermined {
            // Request authorization
            healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { success, error in
                if success {
                    // Authorization granted, fetch heart rate data
                    self.fetchHeartRateData()
                } else {
                    // Authorization denied or error occurred
                    print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } else if healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized {
            // Authorization already granted, fetch heart rate data
            fetchHeartRateData()
        } else {
            // Authorization denied or restricted
            print("Authorization denied or restricted")
        }
    }
    
}
