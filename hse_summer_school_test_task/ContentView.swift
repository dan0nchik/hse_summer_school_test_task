//
//  ContentView.swift
//  hse_summer_school_test_task
//
//  Created by Daniel Khromov on 5/30/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI
import Alamofire
struct ContentView: View {
    
    @State var valueToConvert: String = ""
    @State var showChooseView = false
    @State var currencyConvertTo: String = ""
    @State var currencyConvertFrom: String = ""
    @State var mode: String = ""
    var body: some View {
        NavigationView{
            if showChooseView == true{
                chooseView(to: $currencyConvertTo, from: $currencyConvertFrom, showThisView: $showChooseView, mode: $mode)
            }
            VStack
            {
                TextField("Value to convert", text: $valueToConvert).padding([.top, .horizontal], 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                Text("From")
                    Button(action: {
                        self.mode = "from"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                Text("\(currencyConvertFrom)")
                }
                
                HStack{
                Text("To")
                    Button(action: {
                        self.mode = "to"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                Text("\(currencyConvertTo)")
                }
                Button(action: {
                
                    }, label: {Text("Convert!")}).padding()
            .navigationBarTitle("Converter")
            Spacer()
            }
        }.onAppear {
            getRates(base: "", mode: "show")
        }
    }
}

struct chooseView: View {
    @Binding var to: String
    @Binding var from: String
    @State private var selectedCurrency = 0
    @Binding var showThisView: Bool
    @Binding var mode: String
    var arr = getRates(base: "", mode: "show")
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
                    ForEach(0 ..< arr.count)
                    {
                        Text("\(self.arr[$0].key)")
                    }
                }.labelsHidden()
                Button(action: {
                    if self.mode == "to"{
                        self.to = self.arr[self.selectedCurrency].key
                    }
                    else
                    {
                        self.from = self.arr[self.selectedCurrency].key
                    }
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


extension Dictionary{
    subscript(i: Int) -> (key: Key, value: Value){
        get{
            return self[index(startIndex, offsetBy: i)]
        }
    }
}
