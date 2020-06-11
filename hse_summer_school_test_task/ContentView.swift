//
//  ContentView.swift
//  hse_summer_school_test_task
//
//  Created by Daniel Khromov on 5/30/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI

// We'll decode JSON from API into this
struct Exchange:Codable {
    var rates: [String:Double]
    var date: String
    var base: String
}

struct ContentView: View {
    
    @State private var valueToConvert: String = ""
    @State private var showChooseView = false
    @State private var currencyConvertTo: String = ""
    @State private var currencyConvertFrom: String = ""
    @State private var mode: String = ""
    @State private var result: Double = 0
    @State private var firstCurr: Bool = true
    @State private var secondCur: Bool = true
    @State private var valueEntered: Bool = true
    @State private var arr = [String:Double]()
    var body: some View {
        ZStack{
            VStack
            {
                Text("CONVERTER").font(.system(size: 40, weight: .thin, design: .rounded)).bold()
                TextField("Value to convert", text: $valueToConvert).padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle()).cornerRadius(40)
                    .keyboardType(.decimalPad)
                    
                if !valueEntered
                {
                    Text("Please enter the value!").foregroundColor(.red)
                }
                HStack{
                Text("From")
                    .font(.title)
                    .fontWeight(.medium).bold()
                    .padding()
                    .opacity(0.5)
                
                    Button(action: {
                        self.mode = "from"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                    Text("\(currencyConvertFrom)").bold()
                }
                if !firstCurr{
                    Text("Please choose the first currency!").foregroundColor(.red)
                }
                HStack{
                Text("To")
                    .font(.title)
                    .fontWeight(.medium).bold()
                    .padding()
                    .opacity(0.5)
                    Button(action: {
                        self.mode = "to"
                        self.showChooseView = true
                    }, label: {Text("Choose")})
                    Text("\(currencyConvertTo)").bold()
                }
                if !secondCur{
                    Text("Please choose the second currency!").foregroundColor(.red)
                }
                Button(action: {
                    self.callAPI()
                    UIApplication.shared.endEditing()
                    if self.valueToConvert == ""{
                        self.valueEntered = false
                    }
                    else if self.currencyConvertFrom == ""{
                        self.firstCurr = false
                    }
                    else if self.currencyConvertTo == ""{
                        self.secondCur = false
                    }
                    else
                    {
                        self.result = self.arr["\(self.currencyConvertTo)"]! * Double(self.valueToConvert)!
                    }
                    }, label:
                    {
                        Text("Convert!")
                            .bold()
                            .font(.body)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(20)
                            
                    }).padding()
                
                Image("convert")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text("\(String(format: "%.2f", result))")
                    .font(.title).bold()
                
            }.onAppear(perform: callAPI)
            if showChooseView == true{
                withAnimation{
                    GeometryReader{
                        _ in
                        chooseView(to: self.$currencyConvertTo, from: self.$currencyConvertFrom, showThisView: self.$showChooseView, mode: self.$mode)
                    }
                }
                
            }
        }.onAppear(perform: callAPI)
}
    func callAPI(){
        let url = URL(string:"https://api.exchangeratesapi.io/latest?base=\(self.currencyConvertFrom)")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Exchange.self, from: data) {
                    self.arr = decodedResponse.rates
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
struct chooseView: View {
    @Binding var to: String
    @Binding var from: String
    @State private var selectedCurrency = 0
    @Binding var showThisView: Bool
    @Binding var mode: String
    @State private var arr = ["USD","RUB","BGN", "MYR", "TRY", "GBP", "ILS", "ISK", "AUD", "CZK", "PHP", "NZD", "BRL", "CHF", "RON", "INR", "CNY", "DKK", "SGD", "HKD", "HRK", "CAD", "NOK", "PLN", "HUF", "SEK", "JPY", "KRW", "IDR", "ZAR", "THB",  "MXN", "EUR"]
    var body: some View{
        ZStack{
            Color.black.opacity(0.65).edgesIgnoringSafeArea(.all)
            VStack{
                Picker("", selection: $selectedCurrency){
                    ForEach(0 ..< self.arr.sorted().count)
                    {
                        Text("\(self.arr[$0])").foregroundColor(.black)
                    }
                }.labelsHidden()
                Button(action: {
                    if self.mode == "to"{
                        self.to = self.arr[self.selectedCurrency]
                    }
                    else
                    {
                        self.from = self.arr[self.selectedCurrency]
                    }
                    self.showThisView = false
                    }, label: {Text("Done")}).padding()
                }.background(Color.white).cornerRadius(20)
    }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//dismissing keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
