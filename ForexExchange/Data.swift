//
//  Data.swift
//  ForexExchange
//
//  Created by Quadir on 2/4/20.
//  Copyright © 2020 Quadir. All rights reserved.
//



import Foundation

// MARK: - Welcome
struct CurrencyConv:Codable {
    let apiVersion: String
    let status: Int
    let data: DataClass
}

// MARK: - DataClass
struct DataClass:Codable  {
    let brands: Brands

}

// MARK: - Brands
struct Brands:Codable  {
    let wbc: Wbc

}

// MARK: - Wbc
struct Wbc:Codable  {
    let brand: String
    let portfolios: Portfolios

}

// MARK: - Portfolios
struct Portfolios :Codable {
    let fx: Fx

}

// MARK: - Fx
struct Fx:Codable  {
    let portfolioID: String
    let products: Products

}

// MARK: - Products
struct Products:Codable  {
    let currency: Curr

}

// MARK: - Usd
struct Curr:Codable {
    let productID: String
    let rates: Rates
}


// MARK: - USDRates
struct Rates:Codable  {
    let curr: PuneHedgehog
}



// MARK: - PuneHedgehog
struct PuneHedgehog :Codable {
    let currencyCode, currencyName, country, buyTT: String
    let sellTT, buyTC, buyNotes, sellNotes: String
    let spotRateDateFmt: String
    let effectiveDateFmt, updateDateFmt: String
    let lastupdated: String
}
