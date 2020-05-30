//
//  ContentView.swift
//  hse_summer_school_test_task
//
//  Created by Daniel Khromov on 5/30/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var valueToConvert: String = ""
    @State var showChooseView = false
    @State var to: String = ""
    @State var from: String = ""
    @State var mode: String = ""
    
    var body: some View {
        NavigationView{
            if showChooseView == true{
                chooseView(to: $to, from: $from, showThisView: $showChooseView, mode: $mode)
            }
            VStack
            {
                TextField("Value to convert", text: $valueToConvert).padding([.top, .horizontal], 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                Text("From")
                    Button(action: {
                        self.mode = "to"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                Text("\(to)")
                }
                
                HStack{
                Text("To")
                    Button(action: {
                        self.mode = "from"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                Text("\(from)")
                }
                Button(action: {
                    }, label: {Text("Convert!")}).padding()
            .navigationBarTitle("Converter")
            Spacer()
            }
        }
    }
}



struct chooseView: View {
    
    @Binding var to: String
    @Binding var from: String
    @State var currency = ["$", "Rub"]
    @State var selectedCurrency = 0
    @Binding var showThisView: Bool
    @Binding var mode: String
    
    var body: some View{
        ZStack{
        Color(.lightGray).opacity(0.2).edgesIgnoringSafeArea(.all)
        ZStack{
        RoundedRectangle(cornerRadius: 20)
        .frame(width: 300, height: 300)
            .foregroundColor(.white)
        .padding()
            VStack{
                Picker("", selection: $selectedCurrency){
                    ForEach(0 ..< currency.count)
                    {
                        Text(self.currency[$0])
                    }
                }.labelsHidden()
                Button(action: {
                    if self.mode == "to"{
                        self.to = self.currency[self.selectedCurrency]}
                    else{
                        self.from = self.currency[self.selectedCurrency]}
                    self.showThisView = false
                }, label: {Text("Done")})
            }
        }
    }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
