# 장비서

* 한이음 ICT 멘토링 포르보노 공모전 (2021.08 ~ )


## 0. Contents

[장비서](#---)

​	[0. Contents](#0-contents)

​	[1. Overeview](#1-overeview)

​	[2. Features](#2-features)

​	[3. Requirements](#3-requirements)

​	[4. Installation](#4-installation)

​	[5. Technologies used](#5-technologies-used)

## 1. Overeview

- 시각 장애인을 위한 큐브 냉장고인 [냉대표]를 관리해주는 iOS 애플리케이션 입니다.
  - 냉대표는 아두이노 및 라즈베리파이를 활용한 냉장고 선반과 반찬통으로 이루어져 있습니다.
  - 주요기능으로는 반찬의 무게, 위치 등을 센서 등으로 측정하고 이를 관리해 주고 반찬통을 들어올리면 해당 반찬통의 지정된 이름이 스피커를 통해 출력됩니다.
- 늘어가는 장애인의 수와 장애인 1인 가구의 수를 보았을 때 장애인들이 홀로서기를 할 수 있도록 도움을 줄 수 있는 기능이 필요하다고 생각되어서 해당 프로젝트를 진행하게 되었습니다. 

* 프로젝트 구성도

  ![시스템 구성도](https://user-images.githubusercontent.com/68215452/134124885-fd774dc8-e266-43a4-9cd8-471c05b1f0c5.png)

  <img width="815" alt="스크린샷 2021-09-21 오후 3 51 21" src="https://user-images.githubusercontent.com/68215452/134124775-ecaf2c8f-7723-4b4e-a23f-89308dd11d17.png">

## 2. Features 

* 로그인 및 회원가입 기능

   <img src = "https://user-images.githubusercontent.com/68215452/136070636-1e685633-bda3-4918-aeb0-81e102a002a3.gif" width="25%" height="20%">   <img src = "https://user-images.githubusercontent.com/68215452/136070875-87f77c30-7fc4-4d5c-a2d7-7b2388e09b30.gif" width="25%" height="20%">
    

* 냉장고 선반 등록 기능 (NFC 태그, 고유번호 입력) 

  <img src = "https://user-images.githubusercontent.com/68215452/136071084-bf5309f4-b045-416d-a153-16c5bb656ced.gif" width="25%" height="20%"> <img src = "https://user-images.githubusercontent.com/68215452/136070977-fc17e8bd-3c14-45af-b63a-d929dfad29b6.gif" width="25%" height="20%">
  

* 반찬통 등록 기능

  <img src = "https://user-images.githubusercontent.com/68215452/136072329-d65cd8c9-df1a-4e0b-8a10-8e08b55d722c.gif" width="25%" height="20%">
    

* 반찬통 정보 조회 및 변경 기능

  <img src = "https://user-images.githubusercontent.com/68215452/136070745-d5662c34-4327-4cf7-bd93-a39b0b84a51a.gif" width="25%" height="20%">
  

   
* 얼음 상태 확인 기능 

  <img src = "https://user-images.githubusercontent.com/68215452/136068844-711540d3-346d-45ba-aecb-56c12ffed6e5.gif" width="25%" height="20%">



* 계정 관리 (선반 재등록, 로그아웃)

  <img src = "https://user-images.githubusercontent.com/68215452/136068121-ce8689b9-5f1a-409a-a897-73fc11792496.gif" width="25%" height="20%">


* 냉장고 이상 감지 알림 기능 (진행중)

  * Push Notification / CoreBluetooth


## 3. Requirements

-  iOS 13.0+

- Swift 5.0+

- An Apple developer account

- A Physical iOS Device

  

## 4. Installation

1. 해당 프로젝트를 `clone` 합니다.
2. 프로젝트 파일에서 `pod init` 후에 `pod install` 로 필요 라이브러리를 설치합니다.

3. `SmartRefrigerator.xcworkspace` 를 Xcode로 실행합니다.
4. NFC 기능을 사용하기 위한 세팅을 진행합니다.
   * https://developer.apple.com/documentation/corenfc/building_an_nfc_tag-reader_app 의 `Configure the App to Detect NFC Tags` 항목을 참고

5. 프로젝트를 iOS 디바이스에 빌드합니다.



## 5. Technologies used

* 사용중인 기술
  * **RxSwift + MVVM**
    * 반응형 프로그래밍, 안정적인 비동기 처리 등을 위한 구조로 채택
  * **CoreNFC**
    * NFC 통신을 위한 Apple Framework
    * 큐브 냉장고 선반 및 반찬통의 NFC 태그와 통신

* 사용 예정 기술
  * **CoreBluetooth**
    * Bluetooth 통신을 위한 Apple Framework
    * 냉장고 이상 확인을 위해 냉장고 선반과의 직접적인 통신
  * **Push Notification**
    * 사용자에게 냉장고 이상을 알리기 위한 기술로 사용 예정
  * **Voice Over**
    * 화면을 보지 않고도 아이폰을 사용할 수 있도록 도와주는 제스처 기반 화면 읽기 기능
    * 시각 장애인들의 원활한 앱 사용을 돕기 위해 Voice Over 기능 활용 예정
    * `UIAccessibilityElementProperty` 의 프로퍼티들에 적절한 값 부여
  * **TTS(Text To Speech)**
    * 사용자에게 필요한 순간 적절한 음성 가이드 제공을 위한 기술
    * Apple의 미디어 Framework인 `AVFoundation` 사용 예정



