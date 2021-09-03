//
//  StatusView.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import SwiftUI
import Combine

struct StatusView: View {
    @State private var isShowingModifiedPopover = false
    @State var isStatus = false
    
    var body: some View {
        VStack{
            VStack(spacing: 20){
                Text("반찬 정보")
                    .font(.largeTitle)
                VStack(spacing: 10){
                    Text("멸치볶음")
                        .frame(width: 270, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(26)
                    Text("잔여량 3%")
                        .frame(width: 270, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(26)
                    Text("날짜")
                        .frame(width: 270, height: 52, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(26)
                    Text("등록일로부터 며칠이 지났습니다.")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 35)
            HStack(spacing: 14){
                Button("변경하기", action: {isShowingModifiedPopover = true})
                    .popover(isPresented: $isShowingModifiedPopover, content: {
                        FoodModificationPopoverView(isPresented:self.$isShowingModifiedPopover)
                    })
                Button("확인", action: {self.isStatus = false})
            }
            .buttonStyle(smallButton())
        }
    }
}


struct FoodModificationPopoverView: View {
    @Binding var isPresented: Bool
    @State var foodName = ""
    
    var body: some View {
        VStack{
            VStack{
                Text("반찬통 변경하기")
                    .frame(width: 330, height: 30, alignment: .leading)
                    .font(.system(size: 20))
                    .padding(.bottom, 20)
                HStack{
                    TextField("반찬 이름", text:$foodName)
                    Image(systemName:"multiply.circle.fill").foregroundColor(.gray)
                }
                .padding()
                .frame(width: 330, height: 52, alignment: .center)
                .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.gray, lineWidth: 3))
                .padding(.bottom, 8)
                Text("등록일 : 2021-09-02")
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)
            
            HStack(spacing: 14){
                Button("취소", action: {self.isPresented = false})
                Button("수정 완료", action: {self.isPresented = false})
            }
            .buttonStyle(smallButton())
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
