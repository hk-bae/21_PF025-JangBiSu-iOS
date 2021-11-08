//
//  BLEUtility.swift
import UIKit
import CoreBluetooth


// 블루투스 통신을 담당할 시리얼을 클래스
class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let shared = BluetoothSerial()
    // 뷰 처리를 위한 델리게이트
    weak var delegate : BluetoothSerialDelegate!
    
    var state : CBManagerState?
    
    var serviceUUID : CBUUID?
    
    // centralManager은 블루투스 주변기기를 검색하고 연결하는 역할을 수행합니다.
    var centralManager : CBCentralManager!
    
    // connectedPeripheral은 연결에 성공된 기기를 의미합니다. 기기와 통신을 시작하게되면 이 객체를 이용하게됩니다.
    var connectedPeripheral : CBPeripheral?

    private override init(){
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .utility))
    }
    
    // CBCentralManagerDelegate의 메서드. central 기기의 블루투스가 켜져있는지, 꺼져있는지 등에 대한 상태가 변화할 때 마다 호출됩니다. 이 상태는 블루투스가 켜져있을 때는 .poweredOn으로 관리
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        connectedPeripheral = nil
        state = centralManager.state
        delegate?.serialDidUpateState(central: central)
        
        if central.state == .poweredOn {
            startScan()
        }
    }
}

extension BluetoothSerial {
    // 기기 검색을 시작합니다. 연결이 가능한 모든 주변기기를 serviceUUID를 통해 찾아냅니다.
    func startScan() {
        
        guard centralManager.state == .poweredOn else { return }
        
        // CBCentralManager의 메서드인 scanForPeripherals를 호출하여 연결가능한 기기들을 검색합니다. 이 떄 withService 파라미터에 nil을 입력하면 모든 종류의 기기가 검색
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    // 기기가 검색될 때마다 호출되는 메서드입니다.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
        if ((peripheral.name?.contains("SmartRefri")) == true) {
            connectedPeripheral = peripheral
            connectedPeripheral!.delegate = self
            centralManager.stopScan()
            centralManager.connect(connectedPeripheral!) // didConnect 호출
        }
    }
    
    // 기기가 연결되면 호출되는 메서드입니다.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.serialDidConnectPeripheral(peripheral: connectedPeripheral!)
        
        // peripheral의 Service들을 검색합니다.파라미터를 nil으로 설정하면 peripheral의 모든 service를 검색합니다.
        peripheral.discoverServices(nil)
    }
    
    
    
    // service 검색에 성공 시 호출되는 메서드입니다.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            // 검색된 service에 대해서 characteristic을 검색합니다. 파라미터를 nil로 설정하면 해당 service의 모든 characteristic을 검색합니다.
            print("BLE(Ser):",service.uuid,service.uuid.data.count)
            if service.uuid.data.count == 16 {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // characteristic 검색에 성공 시 호출되는 메서드입니다.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            // 해당 기기의 데이터를 구독
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    // peripheral으로 부터 데이터를 전송받으면 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // 데이터
        guard let data = characteristic.value else { return }

        if let dataString = String(data: data, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            if let temperature = Float(dataString) {
                delegate.serialDidReceiveTemperatureInfo(temperature: temperature)
            }
            
            if let doorOpened = Bool(dataString){
                delegate.serialDidReceiveDoorOpenedInfo(isOpened: doorOpened)
            }
        }
    }
    
}

// 블루투스를 연결하는 과정에서의 시리얼과 뷰의 소통을 위하 델리게이트 프로토콜
protocol BluetoothSerialDelegate : AnyObject {
    func serialDidConnectPeripheral(peripheral : CBPeripheral)
    func serialDidDisconnectPeripheral(peripheral : CBPeripheral)
    func serialDidReceiveTemperatureInfo(temperature : Float)
    func serialDidReceiveDoorOpenedInfo(isOpened : Bool)
    func serialDidUpateState(central:CBCentralManager)
}

extension BluetoothSerialDelegate {
    func serialDidConnectPeripheral(peripheral : CBPeripheral){}
    func serialDidDisconnectPeripheral(peripheral : CBPeripheral){}
    func serialDidReceiveTemperatureInfo(temperature : Float){}
    func serialDidReceiveDoorOpenedInfo(isOpened : Bool){}
    func serialDidUpateState(central:CBCentralManager){}
}
