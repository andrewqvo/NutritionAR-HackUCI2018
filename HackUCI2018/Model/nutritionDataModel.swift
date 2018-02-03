import Foundation
import Alamofire
import SwiftyJSON

class Nutrition
{
    var parameters: [String: String]
    var headers: [String: String]
    var results: [String: Double]
    var percentages: [String: Int]
    var maxCalories: Double
    var maxFat: Double
    var maxSodium: Double
    var maxCarbs: Double
    
    init()
    {
        self.parameters = [String: String]()
        self.headers = [
            // Change these values when API key expires.
            "x-app-id": "81bbc455",
            "x-app-key": "3b48ed3f395d5a25d351ed151b3e93c0"
        ]
        self.results = [String: Double]()
        self.percentages = [String: Int]()
        self.maxCalories = 2000.0
        self.maxFat = 65.0
        self.maxSodium = 2400.0
        self.maxCarbs = 300.0
    }
    
    func processNutrition(food: String)
    {
        self.parameters["query"] = food
        let baseURL = "https://trackapi.nutritionix.com/v2/natural/nutrients"
        
        Alamofire.request(baseURL, method: .post, parameters: self.parameters, encoding: URLEncoding.default, headers: self.headers).responseJSON { (response) in
            
            if let value = response.result.value
            {
                var json = JSON(value)
                //                print(value)
                let calories = (json["foods"][0]["nf_calories"]).doubleValue
                let fat = (json["foods"][0]["nf_total_fat"]).doubleValue
                let sodium = (json["foods"][0]["nf_sodium"]).doubleValue
                let carbs = (json["foods"][0]["nf_total_carbohydrate"]).doubleValue
                
                self.results["calories"] = round(calories)
                self.results["fat"] = Double(String(format: "%.1f", fat))
                self.results["sodium"] = Double(String(format: "%.1f", sodium))
                self.results["carbs"] = Double(String(format: "%.1f", carbs))
                
                self.percentages["calories"] = Int(round((calories / self.maxCalories) * 100))
                self.percentages["fat"] = Int(round((fat / self.maxFat) * 100))
                self.percentages["sodium"] = Int(round((sodium / self.maxSodium) * 100))
                self.percentages["carbs"] = Int(round((carbs / self.maxCarbs) * 100))
            }
        }
    }
    
    func getResults() -> [String: Double]
    {
        return self.results
    }
    
    func getResultsPercentages() -> [String: Int]
    {
        return self.percentages
    }
}

// Use Nutrition class as shown:

//let foodInput = "hot dog"
//let currentFood = Nutrition()
//
//var dailyValues = [String: Double]()
//var dailyPercentages = [String: Int]()
//currentFood.processNutrition(food: foodInput)
//DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//    dailyValues = currentFood.getResults()
//    dailyPercentages = currentFood.getResultsPercentages()
//    print(dailyValues)
//    print(dailyPercentages)
//})
