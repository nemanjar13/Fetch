//
//  DetailView.swift
//  FetchInterview
//
//  Created by Nemanja Risteski on 3/6/23.
//

import SwiftUI

struct DetailView: View {
    var desert: Desert
    @StateObject var vm: DesertDetailViewModel
    
    init(desert: Desert) {
        self.desert = desert
        _vm = StateObject(wrappedValue: DesertDetailViewModel(desert: desert))
    }
    
    var body: some View {
        VStack {
            HStack {
                // General Information about desert
                VStack() {
                    Text("General Information\n")
                        .fontWeight(.bold).font(.system(size: 14))
                        .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                        .padding(.horizontal)
                        .background(Color(.systemGreen))
                        .cornerRadius(10)
                    let genInfoDic = getGeneralInfo(dic: vm.dessertDictionary ?? nil)
                    
                    
                    // Get all general information about the desert by looping through
                    // genInfo dictionary and setting each value to a TextField if it is not "" string
                    VStack (spacing: 2) {
                        ForEach(genInfoDic.sorted(by: >), id: \.key) {key, value in
                            if (value != "") {
                                Text("\(key):  \(value)")
                                    .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(5)
                    
                    Spacer()
                    
                    // VStack for the ingredients and measures
                    VStack (spacing: 0) {
                        Text("Ingredients and Measures")
                            .fontWeight(.bold).font(.system(size: 14))
                            .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .topLeading)
                            .padding(.horizontal)
                            .background(Color(.systemYellow))
                            .cornerRadius(10)
                        let ingAndMeasureDic = getIngredientsAndMeasures(dic: vm.dessertDictionary ?? nil)
                        // Get all ingredients with their measures by looping through the arranged dictionary
                        // No need to worry about the empty ones since we already filtered those in function
                        ScrollView {
                            ForEach(ingAndMeasureDic.sorted(by: <), id: \.key) {key, value in
                                Text("\(key): \(value)")
                                    .frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                            }
                        }
                        .background(Color(.systemGray5))
                        .cornerRadius(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.3, alignment: .topLeading)
                
                // VStack in which image is put
                VStack {
                    // Image
                    let url = URL(string: vm.desertInfo?.strMealThumb ?? "")
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable().frame(width: 75, height: 75).aspectRatio(contentMode: .fit)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.3, alignment: .center)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3, alignment: .top)
            
            
            
            VStack {
                Text("Preparation Instructions")
                    .fontWeight(.bold).font(.system(size: 16))
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 35, alignment: .center)
                    .padding(.horizontal)
                    .background(Color(.systemRed))
                    .cornerRadius(10)
                
                // Get the preparation process from getPreparation function that returns
                // dictionary that maps single key to instructions value from obtained data
                let preparationDic = getPreparation(dic: vm.dessertDictionary ?? nil)
                
                ScrollView {
                    ForEach(preparationDic.sorted(by: <), id: \.key) {key, value in
                        Text("\(value)")
                            .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                .scrollIndicators(.visible)
                .background(Color(.systemGray5))
                .cornerRadius(5)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .center)
            .padding()
            
        }
        .navigationTitle(vm.desertInfo?.strMeal ?? "Loading your Information...")
        .padding()
        
    }
    
    
    // MARK: Helper Functions
    
    
    // MARK: Get general info about the Desert
    // Returns dictionary of the general information about the sepcific desert
    func getGeneralInfo(dic: [String: Any]?) -> [String: String] {
        guard let dic = dic else {
            print("Your dic is empty Dumbass")
            return [String: String]()
        }
        var genInfoDic = [String: String]()
        let name = dic["strMeal"] as? String ?? ""
        let drinkForDes = dic["strDrinkAlternate"] as? String ?? ""
        let category = dic["strCategory"] as? String ?? ""
        let area = dic["strArea"] as? String ?? ""
        
        
        genInfoDic["Name"] = name
        genInfoDic["Drink"] = drinkForDes
        genInfoDic["Category"] = category
        genInfoDic["Area"] = area
        
        return genInfoDic
    }
    
    
    // MARK: Get ingredients and measures
    // takes is dictionary of data downloaded from the server after it's converted
    // to JSON and filters it creating new dictionary containing only values for ingredients that are not nil and respective measurements for those ingredients
    // returns dictionary of ingredients and measures
    func getIngredientsAndMeasures(dic: [String: Any]?) -> [String: String] {
        guard let dic = dic else {
            print("Your dic is empty Dumbass")
            return [String: String]()
        }
        var ingredientsAndMeasures = [String: String]()
        
        // get all indgredients that have value diff from ""
        // capture the index of ingredients
        var index = 0
        let allKeys = dic.keys
        
        // capture the keys that represents ingredients and their number
        var ingredients: [String] = []
        for el in allKeys {
            if (el.contains("strIngredient")) {
                let tmp = dic[el] as? String ?? ""
                if (tmp != "") {
                    ingredients.append(el)
                    index = index + 1
                }
            }
        }
        ingredients = ingredients.sorted()
        
        
        // populate new dictionary with key - value pairs
        // where key is ingredient# and value is measure#
        for i in 1...index {
            let curIngredient = dic["strIngredient\(i)"] as? String ?? ""
            let curMeasure = dic["strMeasure\(i)"] as? String ?? ""
            ingredientsAndMeasures[curIngredient] = curMeasure
        }
        
        return ingredientsAndMeasures
    }
    
    
    // MARK: Get how meal is prepared
    // returns dictionary of ingredients and measures
    func getPreparation(dic: [String: Any]?) -> [String: String] {
        guard let dic = dic else {
            print("Your dic is empty Dumbass")
            return [String: String]()
        }
        var prepareDic = [String: String]()
        let prep = dic["strInstructions"] as? String ?? ""
        
        prepareDic["instructions"] = prep
        
        return prepareDic
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(desert: Desert(strMeal: "", strMealThum: "", idMeal: ""))
    }
}
