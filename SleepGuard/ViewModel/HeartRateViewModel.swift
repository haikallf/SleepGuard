//
//  HeartRateViewModel.swift
//  SleepGuard
//
//  Created by Haikal Lazuardi on 21/05/23.
//

import SwiftUI
import HealthKit

class HeartRateViewModel: ObservableObject {
    let healthStore = HKHealthStore()
    let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    
    @Published var latestHeartRate: Double = 0.0
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            if success {
                print("Heart rate data authorization granted")
                self.startHeartRateDetection()
            } else {
                print("Heart rate data authorization not granted: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func startHeartRateDetection() {
        print("Starting")
        let heartRateQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            self.fetchLatestHeartRate()
            
            completionHandler()
        }
        
        healthStore.execute(heartRateQuery)
        
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { success, error in
            if success {
                print("Heart rate background delivery enabled")
            } else {
                print("Heart rate background delivery failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchLatestHeartRate() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            guard let heartRateSample = samples?.first as? HKQuantitySample else {
                print("Heart rate sample not found")
                return
            }
            
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            let heartRateValue = heartRateSample.quantity.doubleValue(for: heartRateUnit)
            
            DispatchQueue.main.async {
                self.latestHeartRate = heartRateValue
                print(heartRateValue)
            }
        }
        
        healthStore.execute(query)
    }
}
