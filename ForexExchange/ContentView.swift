//
//  ContentView.swift
//  ForexExchange
//
//  Created by Quadir on 2/4/20.
//  Copyright © 2020 Quadir. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct ContentView: View {
    @State var inputValue: String = ""
    @State var outputValue: String = ""
    @ObservedObject var viewModel = ViewModel()
    var rate = ["BuyTT","SellTT","BuyNotes","SellNotes"]
    @State private var selectedRate = 0
    @State private var selectedCurrency = 0
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        VStack {
            Image("westpac-logo-social")
            VStack {
                HStack {
                    Text("   Input")
                    .fontWeight(.bold)
                        .font(.title)
                    TextField("0", text: $inputValue)
                        .font(.largeTitle)
                        .background(Color.black)
                         .cornerRadius(10)
                        .frame(width: 150.0, height: 5.0, alignment: .trailing)
                        .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    if(viewModel.curr.count > 0){
                        Text(self.viewModel.curr[selectedCurrency].productID)
                    }
                }.padding(.leading,20)
                 .padding(.top,15)
                
                HStack {
                    Text("Output")
                    .fontWeight(.bold)
                        .font(.title)
                    TextField("0", text: $outputValue)
                    .font(.largeTitle)
                        .background(Color.black)
                    .cornerRadius(10)
                        .frame(width: 150.0, height: 5.0, alignment: .trailing)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    Text("AUD")
                }.padding(.leading,20)
                
                VStack {
                    Picker(selection: $selectedCurrency, label: Text("Curr")
                     .fontWeight(.bold)) {
                        ForEach(0 ..< viewModel.curr.count) {
                            Text(self.viewModel.curr[$0].productID).tag($0)
                            
                        }
                    }
                    
                    Picker(selection: $selectedRate, label: Text("Rate")
                        .fontWeight(.bold)) {
                         ForEach(0 ..< rate.count) {
                            Text(self.rate[$0]).tag($0)
                      
                            }
                            
                    }
                    if (rate[selectedRate] == "BuyTT") {
                        if(viewModel.curr.count == 0){
                        Text("Rate: \(0)")
                        }else{
                        Text("Rate: \(self.viewModel.BuyTT[self.viewModel.curr[selectedCurrency].productID]!)")
                        }
                    } else if(rate[selectedRate] == "SellTT") {
                         if(viewModel.curr.count == 0){
                            Text("Rate: \(0)")
                        }else{
                            Text("Rate: \(self.viewModel.SellTT[self.viewModel.curr[selectedCurrency].productID]!)")
                            }
                    } else if(rate[selectedRate] == "BuyNotes") {
                        if(viewModel.curr.count == 0){
                            Text("Rate: \(0)")
                        }else{
                            Text("Rate: \(self.viewModel.BuyNotes[self.viewModel.curr[selectedCurrency].productID]!)")
                        }
                    }else if(rate[selectedRate] == "SellNotes") {
                        if(viewModel.curr.count == 0){
                            Text("Rate: \(0)")
                        }else{
                            Text("Rate: \(self.viewModel.SellNotes[self.viewModel.curr[selectedCurrency].productID]!)")
                        }
                    }else if(rate[selectedRate] == "BuyTC") {
                          if(viewModel.curr.count == 0){
                            Text("Rate: \(0)")
                          }else{
                            Text("Rate: \(self.viewModel.BuyTC[self.viewModel.curr[selectedCurrency].productID]!)")
                                }
                    }
                    
                    
                    
                
                }.padding([.leading, .trailing],10.0)
                
                Button(action: {
                    self.displayInAUD(self.inputValue,self.rate[self.selectedRate])
                }) {
                    Text("Convert")
                        .frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 30.0,
                           maxHeight: 30.0)
                }.foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(10.0)
                    .padding([.leading, .trailing], 100)
                    
                Spacer(minLength: 10)
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 950.0, alignment: .center)
            .background(Color.gray)
            .cornerRadius(10.0)
            .padding([.leading, .trailing],5.0)
            .shadow(radius: 10.0)

        }

    }
    
    private func displayInAUD(_ inputText: String,_ rate:String) {
        if(rate == "BuyTT"){
            let x = Double(inputText)
            let y = Double(self.viewModel.BuyTT[self.viewModel.curr[selectedCurrency].productID]! )
            
            outputValue = String(x!/y!)
        }else if(rate == "SellTT"){
            let x = Double(inputText)
            let y = Double(self.viewModel.SellTT[self.viewModel.curr[selectedCurrency].productID]! )
                       
            outputValue = String(x!/y!)
        }else if(rate == "BuyNotes"){
             let x = Double(inputText)
            let y = Double(self.viewModel.BuyNotes[self.viewModel.curr[selectedCurrency].productID]! )
                       
            outputValue = String(x!/y!)
        }else if(rate == "SellNotes"){
            let x = Double(inputText)
            let y = Double(self.viewModel.SellNotes[self.viewModel.curr[selectedCurrency].productID]! )
                       
            outputValue = String(x!/y!)
        }else if(rate == "BuyTC"){
            let x = Double(inputText)
            let y = Double(self.viewModel.BuyTC[self.viewModel.curr[selectedCurrency].productID]! )
                       
            outputValue = String(x!/y!)
        }
        
        
    }
}

struct NavigationButton: View {
  let text: String
  let tapAction: () -> Void
  
  var body: some View {
    Button(action: tapAction, label: {
      Text(text)
    })
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
