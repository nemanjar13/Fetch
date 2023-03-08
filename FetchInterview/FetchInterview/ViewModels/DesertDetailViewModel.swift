//
//  DesertDetailViewModel.swift
//  FetchInterview
//
//  Created by Nemanja Risteski on 3/6/23.
//

import Foundation

// View model that represents data and behavior of our DesertDetail View
// Apon initialization it downloads the all data about specific desert with previously passed mealID
// and populates our desert dictionary and uses that information to update the view
class DesertDetailViewModel : ObservableObject {
    @Published var desertInfo: DesertDetailed? // cehck if you need this
    @Published var desert: Desert
    @Published var dessertDictionary: [String: Any]?
    
    init(desert: Desert) {
        self.desert = desert
        getDesertInfo(desertID: desert.idMeal) { returnedData in
//            print("WORKING") - debugging
            DispatchQueue.main.async {
                self.dessertDictionary = returnedData
            }
        }
    }
    
    func getDesertInfo(desertID: String, completion: @escaping (_ data: [String: Any]) -> ()) {
        
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(desertID)") else {
            print("The provided URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error while obtaining desert data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("HTTP request faild - Response: \(String(describing: response))")
                return
            }
            guard let data = data else {
                print("Failed to retrieve data from the server")
                return
            }
            print("Desert information was downloaded successfully!")
            
            // MARK: Since data is represented as JSON object where key is a string and value is another JSON object
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]] else {
                print("Faild to convert JSON data into dictionary")
                return
            }
            // MARK: similarly "meals" map to a value which is json object again so we transform it to dictionary
            if let desertInformation = jsonObject["meals"] as? [[String: Any]] {
                for info in desertInformation {
//                    print(info) - debugging
                    
                    // MARK: Makes sure that object is created and dictionary is populated since we don't want to pass initially nil value
                    DispatchQueue.main.async {
                        
                        // ** pretty sure I don't need this but kept it as precaution
                        
                        self.desertInfo = DesertDetailed(idMeal: info["idMeal"] as? String, strMeal: info["strMeal"] as? String, strDrinkAlternate: info["strDrinkAlternate"] as? String, strCategory: info["strCategory"] as? String, strArea: info["strAreaa"] as? String, strInstructions: info["strInstructions"] as? String, strMealThumb: info["strMealThumb"] as? String, strTags: info["strTags"] as? String, strYoutube: info["strYoutube"] as? String, strIngredient1: info["strIngredient1"] as? String, strIngredient2: info["strIngredient2"] as? String, strIngredient3: info["strIngredient3"] as? String, strIngredient4: info["strIngredient4"] as? String, strIngredient5: info["strIngredient5"] as? String, strIngredient6: info["strIngredient6"] as? String, strIngredient7: info["strIngredient7"] as? String, strIngredient8: info["strIngredient8"] as? String, strIngredient9: info["strIngredient9"] as? String, strIngredient10: info["strIngredient10"] as? String, strIngredient11: info["strIngredient11"] as? String, strIngredient12: info["strIngredient12"] as? String, strIngredient13: info["strIngredient13"] as? String, strIngredient14: info["strIngredient14"] as? String, strIngredient15: info["strIngredient15"] as? String, strIngredient16: info["strIngredient16"] as? String, strIngredient17: info["strIngredient17"] as? String, strIngredient18: info["strIngredient18"] as? String, strIngredient19: info["strIngredient19"] as? String, strIngredient20: info["strIngredient20"] as? String, strMeasure1: info["strMeasure1"] as? String, strMeasure2: info["strMeasure2"] as? String, strMeasure3: info["strMeasure3"] as? String, strMeasure4: info["strMeasure4"] as? String, strMeasure5: info["strMeasure5"] as? String, strMeasure6: info["strMeasure6"] as? String, strMeasure7: info["strMeasure7"] as? String, strMeasure8: info["strMeasure8"] as? String, strMeasure9: info["strMeasure9"] as? String, strMeasure10: info["strMeasure10"] as? String, strMeasure11: info["strMeasure11"] as? String, strMeasure12: info["strMeasure12"] as? String, strMeasure13: info["strMeasure13"] as? String, strMeasure14: info["strMeasure14"] as? String, strMeasure15: info["strMeasure15"] as? String, strMeasure16: info["strMeasure16"] as? String, strMeasure17: info["strMeasure17"] as? String, strMeasure18: info["strMeasure18"] as? String, strMeasure19: info["strMeasure19"] as? String, strMeasure20: info["strMeasure20"] as? String, strSource: info["strSource"] as? String, strImageSource: info["strImageSource"] as? String, strCreativeCommonsConfirmed: info["strCreativeCommonsConfirmed"] as? String, dateModified: info["dateModified"] as? Date, strMealThum: info["strMealThum"] as? String)
                    }
                }
                // ** this should be enough since it returns dictionary that stores mapping for
                // only one meal and its specific information
                completion(desertInformation[0])
            }
            else {
                print("Failed to convert current json object to Desert type")
                return
            }
        }
        .resume()
    }
}
