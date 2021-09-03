//
//  iceButton.swift
//  SmartRefrigerator
//
//  Created by 정혜미 on 2021/08/31.
//

import SwiftUI
import Combine

struct iceView: View {
    @State private var isShowingIcePopover = false
    var body: some View {
        Button("얼음 확인", action: {isShowingIcePopover = true
        })
            .buttonStyle(bigButton())
            .popover(isPresented: $isShowingIcePopover, content: {
                icePopover(isPresented:self.$isShowingIcePopover)
            })
    }
}

struct icePopover: View {
    @Binding var isPresented: Bool
    @State private var isIced: Bool = false //얼음완성 시간..? 여튼 얼음 관련 값
    
    var body: some View {
        VStack{
            Text("얼음 확인")
                .font(.largeTitle)
                .padding(.bottom, 20)
            VStack(spacing: 30){
                if(isIced == false){
                    Image("ice")
                    Text("얼음을 생성 중입니다.")
                }else{
                    Image("ice_filled")
                    Text("얼음이 완성되었습니다.")
                }
            }
            .padding(.bottom, 35)
            Button("확인", action: {self.isPresented = false})
                .buttonStyle(bigButton())
        }
    }
}




struct iceButton_Previews: PreviewProvider {
    static var previews: some View {
        iceView()
    }
}
