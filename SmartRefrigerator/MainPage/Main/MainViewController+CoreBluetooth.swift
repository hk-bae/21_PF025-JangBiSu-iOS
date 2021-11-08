//
//  MainViewController+CoreBluetooth.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/11/01.
//

import UIKit
import CoreBluetooth
import UserNotifications

// Local Notification 관련
extension MainViewController {

    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "냉장고 문 열림 감지"
        notificationContent.body = "냉장고 문이 열려있습니다. 확인해 주십시오."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "noti",
                                            content: notificationContent,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}

extension MainViewController : BluetoothSerialDelegate {
    func configureBLESerialSetting(){
        BluetoothSerial.shared.delegate = self
    }
    
    
    
    func serialDidUpateState(central : CBCentralManager){
        
        DispatchQueue.main.async{ [weak self] in
            if central.state == .poweredOn {
                self?.bleButton.accessibilityLabel = "연결할 기기를 찾고 있습니다."
            }else{
                self?.bleButton.accessibilityLabel = "온도 정보 제공을 위하여 블루투스 권한이 필요합니다. 권한 관리로 이동하려면 이중탭 하십시오."
            }
        }
        
    }
    
    func serialDidConnectPeripheral(peripheral : CBPeripheral)
    {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bleButton.isHidden = true
            self.temperatureLabel.isHidden = false
            self.bleButton.layoutIfNeeded()
            self.temperatureLabel.layoutIfNeeded()
        }
        
    }

    
    func serialDidDisconnectPeripheral(peripheral : CBPeripheral){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.bleButton.isHidden = false
            self.temperatureLabel.isHidden = true
            self.bleButton.layoutIfNeeded()
            self.temperatureLabel.layoutIfNeeded()
        }
    }
    
    func serialDidReceiveTemperatureInfo(temperature : Float){
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = "\(temperature)℃"
            self?.temperatureLabel.accessibilityLabel = "현재 온도는 \(temperature)도 입니다."
//            self?.temperatureLabel.layoutIfNeeded()
        }
    }
    
    func serialDidReceiveDoorOpenedInfo(isOpened: Bool) {
        sendNotification(seconds: 0.5)
    }
}


extension MainViewController {
    func moveToOpenSetting(){
        if BluetoothSerial.shared.state != .poweredOn {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
