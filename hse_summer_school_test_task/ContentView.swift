//
//  ContentView.swift
//  hse_summer_school_test_task
//
//  Created by Daniel Khromov on 5/30/20.
//  Copyright © 2020 Daniel Khromov. All rights reserved.
//

import SwiftUI


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
        NavigationView{
            if showChooseView == true{
                chooseView(to: $currencyConvertTo, from: $currencyConvertFrom, showThisView: $showChooseView, mode: $mode)
            }
            VStack
            {
                TextField("Value to convert", text: $valueToConvert).padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle()).cornerRadius(40)
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
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(40)
                            
                    }).padding()
                
                Image("convert")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text("\(String(format: "%.2f", result))")
                    .font(.title).bold()
                    .navigationBarTitle("Converter")
                Spacer()
            }.onAppear(perform: callAPI)
        }.onAppear(perform: callAPI)
}
    func callAPI(){
        guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(self.currencyConvertFrom)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Exchange.self, from: data) {
                    DispatchQueue.main.async {
                        //print(decodedResponse)
                        self.arr = decodedResponse.rates
                        self.arr = decodedResponse.rates
                    }
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
    @State private var arr = ["BGN", "MYR", "TRY", "GBP", "ILS", "ISK", "RUB", "AUD", "CZK", "PHP", "NZD", "BRL", "CHF", "RON", "INR", "CNY", "DKK", "SGD", "HKD", "HRK", "CAD", "NOK", "PLN", "HUF", "SEK", "JPY", "KRW", "IDR", "ZAR", "THB", "USD", "MXN", "EUR"]
    var body: some View{
        ZStack{
        RoundedRectangle(cornerRadius: 20)
        .frame(width: 300, height: 300)
            .foregroundColor(.white)
        .padding()
            VStack{
                Picker("", selection: $selectedCurrency){
                    ForEach(0 ..< self.arr.count)
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
                }, label: {Text("Done")})
            }.background(Color.white)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
