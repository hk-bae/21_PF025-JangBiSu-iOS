//
//  MainView.swift
//  SmartRefrigerator
//
//  Created by 배한결 on 2021/08/18.
//

import SwiftUI
import Combine

struct MainView: View {
    private var user: String = "혜미" //나중에 값 받아오기 이 값 하나 받으려고 해도 설정 해야하나..? 킷이랑 유아이랑
    
    var body: some View {
        NavigationView{
            VStack{
                RegisterFoodView()
                    .padding(.bottom, 9)
                iceView()
                    .navigationBarTitle(Text("\(user)님의 냉장고"),displayMode: .inline)
                    .navigationBarItems(leading: Button(action: { }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("back")
                        }
                        .foregroundColor(.black)
                    })
            }
        }
    }
}

struct bigButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .frame(width: 330, height: 52, alignment: .center)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(26)
    }
}

struct smallButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .frame(width: 158, height: 52, alignment: .center)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(26)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
