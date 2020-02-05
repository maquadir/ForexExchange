//
//  ViewModel.swift
//  ForexExchange
//
//  Created by Quadir on 2/4/20.
//  Copyright © 2020 Quadir. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CoreData

//viewmodel delegate
protocol VCViewModelDelegate{
     
    //share data with ViewController
    func shareCurrencyItems(_ currencyConv: [Curr], BuyTT:[String:String],  SellTT:[String:String],BuyNotes:[String:String],SellNotes:[String:String],BuyTC:[String:String])
    
 }
 
public class ViewModel: ObservableObject  {
    
    //variables
    
    let jsonurl:String = "https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json"
    private let dogApiUrl = "https://dog.ceo/api/breeds/list/random/10"
    var vcviewmodeldelegate:VCViewModelDelegate?
    let dataclassList: [DataClass] = []
    var product = [String: Any]()
    var items = [String:String]()
    var currencyCode = "", currencyName = "", country = "", buyTT: String = ""
    var sellTT = "", buyTC = "", buyNotes = "", sellNotes: String = ""
    var spotRateDateFmt: String = ""
    var effectiveDateFmt:String = ""
    var updateDateFmt:String = ""
    var lastupdated:String = ""
    var rates:[Rates] = []
    @Published var curr = [Curr]()
    @Published var products:[Products] = []
    var fx:[Fx] = []
    var portfolios:[Portfolios] = []
    var wbc:[Wbc] = []
    var brands:[Brands] = []
    var Dataclass:[DataClass] = []
    var currencyConv:[CurrencyConv] = []
    @Published var BuyTT = [String:String]()
    @Published var SellTT = [String:String]()
    @Published var BuyNotes = [String:String]()
    @Published var SellNotes = [String:String]()
    @Published var BuyTC = [String:String]()
    private var task: AnyCancellable?
    var objectContext: NSManagedObjectContext?
   
   
    
  
    
    //code for Initialization
    public init() {
        //initialization code
        fetchfromURL()
    }

    //code to read data from JSON URL
    public func fetchfromURL(){
         
         //code to fetch name and location from JSON URl
        
        //creating a NSURL
        URLSession.shared.dataTask(with: URL(string: jsonurl)!) { (data, res, err) in

            if let d = data {
                
                if let value = String(data: d, encoding: String.Encoding.ascii) {

                    if let jsonData = value.data(using: String.Encoding.utf8) {
                        do {
                            
//                             let decodedLists = try JSONDecoder().decode([CurrencyConv].self, from: d)
                            
                            let jsonResponse = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                            
                            //fetch data items
                            let status = jsonResponse["status"] as? Int
                            let apiVersion = jsonResponse["apiVersion"] as? String
                            let data = jsonResponse["data"] as? [String: Any]
                            let brands = data?["Brands"] as? [String: Any]
                            let wbc = brands?["WBC"] as? [String: Any]
                            let Brand = wbc?["Brand"] as? [String: Any]
                            let portfolios = wbc?["Portfolios"] as? [String: Any]
                            let FX = portfolios?["FX"] as? [String: Any]
                            let products = FX?["Products"] as? [String: Any]
                            let ProductId = products?["ProductId"] as? [String: Any]
                            
                            
                  for (thing_key, thing_value)   in  products as! [String:NSDictionary] {
                                let product = thing_value["Rates"] as?  [String: NSDictionary]
                                let rates = product?[thing_key] as?  [String: Any]
                                
                    for (thing_key, thing_value)   in  rates! {
                                    switch thing_key {
                                    case "currencyCode":
                                        self.currencyCode = thing_value as! String
                                    case "currencyName":
                                        self.currencyName = thing_value as! String
                                    case "country":
                                        self.country = thing_value as! String
                                    case "buyTT":
                                        self.buyTT = thing_value as! String
                                    case "sellTT":
                                        self.sellTT = thing_value as! String
                                    case "buyTC":
                                        self.buyTC = thing_value as! String
                                    case "buyNotes":
                                        self.buyNotes = thing_value as! String
                                    case "sellNotes":
                                        self.sellNotes = thing_value as! String
                                    case "SpotRate_Date_Fmt":
                                        self.spotRateDateFmt = thing_value as! String
                                    case "LASTUPDATED":
                                        self.lastupdated = thing_value as! String
                                    case "updateDate_Fmt":
                                        self.updateDateFmt = thing_value as! String
                                    case "effectiveDate_Fmt":
                                        self.effectiveDateFmt = thing_value as! String
                                    default: break
                                        
                                    }
                                }
                                
                                
                    let currfinal = PuneHedgehog(currencyCode: self.currencyCode, currencyName: self.currencyName, country: self.country, buyTT: self.buyTT, sellTT: self.sellTT, buyTC: self.buyTC, buyNotes: self.buyNotes, sellNotes: self.sellNotes, spotRateDateFmt: self.spotRateDateFmt, effectiveDateFmt: self.effectiveDateFmt , updateDateFmt: self.updateDateFmt , lastupdated: self.lastupdated )

                    self.BuyTT[self.currencyCode] = self.buyTT
                    self.SellTT[self.currencyCode] = self.sellTT
                    self.BuyTC[self.currencyCode] = self.buyTC
                    self.BuyNotes[self.currencyCode] = self.buyNotes
                    self.SellNotes[self.currencyCode] = self.sellNotes
                    let finalRates = Rates(curr: currfinal)
                    self.rates.append(finalRates)
                    let finalCurr = Curr(productID: thing_key,rates: finalRates)
//                    DispatchQueue.main.async {
                         self.curr.append(finalCurr)
//                    }
                   
                    let finalProducts = Products(currency: finalCurr)
                    self.products.append(finalProducts)
                    let finalFX = Fx(portfolioID: thing_key,products: finalProducts)
                    self.fx.append(finalFX)
                    let finalPortfolios = Portfolios(fx: finalFX)
                    self.portfolios.append(finalPortfolios)
                    let finalwbc = Wbc(brand: wbc?["Brand"] as! String,portfolios: finalPortfolios)
                    self.wbc.append(finalwbc)
                    let finalBrands = Brands(wbc: finalwbc)
                    self.brands.append(finalBrands)
                    let finalDataclass = DataClass(brands: finalBrands)
                    self.Dataclass.append(finalDataclass)
                    let finalCurrConv = CurrencyConv( apiVersion: apiVersion ?? "1.0",status: status ?? 1,data: finalDataclass)
                    self.currencyConv.append(finalCurrConv)
                    
                                
                  }
                    //share currency items via delegate method to ViewController
                    self.vcviewmodeldelegate?.shareCurrencyItems(self.curr,BuyTT: self.BuyTT,SellTT:self.SellTT,BuyNotes: self.BuyTC,SellNotes: self.BuyNotes,BuyTC: self.SellNotes)
                        
                           
                        } catch {
                            NSLog("ERROR \(error.localizedDescription)")
                        }
                    }
                }

            }
            }.resume()


}
    

    
   
}

