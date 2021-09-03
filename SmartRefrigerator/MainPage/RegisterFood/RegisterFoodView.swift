//
//  RegisterFoodView.swift
//  SmartRefrigerator
//
//  Created by 정혜미 on 2021/09/01.
//

//group으로 반찬통 view 6개 생성해서 묶기
//각 반찬통 누르면 statusview로 이동(statusview는 modal view임)
//statusview에서 확인 누르면 다시 registerfoodview로 복귀
//변경 누르면 foodmodificationview로 돌아가기

import SwiftUI
import Combine

struct RegisterFoodView: View {
    @State private var isShowingRegisterPopover = false
    var body: some View  {
        VStack(spacing: 20){
            VStack(spacing: 9){
                HStack(spacing: 9){
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                }
                HStack(spacing: 9){
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                    Button("Empty", action: { })
                        .buttonStyle(unclikedFood())
                }
            }
            Button("반찬 등록하기", action: {isShowingRegisterPopover = true})
                .buttonStyle(bigButton())
                .popover(isPresented:$isShowingRegisterPopover, content: {
                    RegisterPopover(isPresented:self.$isShowingRegisterPopover)
                })
        }
    }
}


struct RegisterPopover: View {
    @Binding var isPresented: Bool
    @State private var foodName = ""

    var body: some View {
        VStack{
            VStack{
                Text("반찬통 등록하기")
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
                Button("입력 완료", action: {self.isPresented = false})
            }
            .buttonStyle(smallButton())
        }
    }
}




struct unclikedFood: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .frame(width: 104, height: 125, alignment: .center)
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(15)
    }
}

struct clickedFood: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .frame(width: 104, height: 125, alignment: .center)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(15)
    }
}


struct RegisterFoodView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterFoodView()
    }
}
