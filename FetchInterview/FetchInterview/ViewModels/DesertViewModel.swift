//
//  DesertViewModel.swift
//  FetchInterview
//
//  Created by Nemanja Risteski on 3/5/23.
//

import Foundation

// View model that represents data and behavior of our DesertList View
// Apon initialization it downloads the initial general data about deserts
// and populates our desert List and uses that information to update the view
class DesertViewModel : ObservableObject {
     @Published var desertList: [Desert] = []
    
    init() {
        getDeserts { data in
        }
    }
    
    // MARK: Used for debugging
//    func showDeserts() {
//        for desert in self.desertList {
//            print(desert.strMeal)
//        }
//    }
    
    // MARK: Get method to obtain data from the server
    func getDeserts(completionHandler: @escaping(_ data: [[String: Any]]) -> ()) {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("The provided URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found")
                return
            }
            guard error == nil else {
                print("Error while obtaining data: \(String(describing: error))")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("HTTP request faild - Response: \(String(describing: response))")
                return
            }
            
            print("Data was downloaded successfully!")
//            print(data) // debugging
            
            
//            print("Encode JSON into string below")
//            let jsonString = String(data: data, encoding: .utf8)
//            print(jsonString) // MARK: shown as raw json format
            
            
            // MARK: Since data on the server is represented as JSON object where key is a string and value is another JSON object
            // Convert it first into workable dictionary where keys are String and values are [Any] - leaves json object inside
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]] else {
                print("Faild to convert JSON data into dictionary")
                return
            }
            // MARK: values of the previously converted dictionary have to be transformed from JSON format to array of dictionaries [[String : Any]]
            // Since we know that mapping is such that every object is mapped with key meals and there is only one value - array of json object we
            // transform that, by referencing specific(the only) key value
            if let jsonsArray = jsonObject["meals"] as? [[String: Any]] {
                for x in jsonsArray {
                    // used to create Desert object before adding it to the [Desert] list
                    if let id = x["idMeal"] as? String,
                       let name = x["strMeal"] as? String,
                       let thumb = x["strMealThumb"] as? String {
                        // MARK: makes sure that list is populated with data before it is being used to create a view - otherwise it will be null
                        DispatchQueue.main.async {
                            self.desertList.append(Desert(strMeal: name, strMealThum: thumb, idMeal: id))
                        }
                    }
                    else {
                        print("Failed to convert second JSON object to Desert type")
                        return
                    }
                }
                // MARK: returnn array of JSON objects converted into dictionary [String : Any]
                completionHandler(jsonsArray)
            }
            else {
                print("Error while converting data")
                return
            }
            
        }
        .resume()
    }
}

