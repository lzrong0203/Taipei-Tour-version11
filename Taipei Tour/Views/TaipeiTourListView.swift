//
//  ContentView.swift
//  Taipei Tour
//
//  Created by Steve Lai on 2022/7/26.
//

import SwiftUI



struct TaipeiTourListView: View {

    let dataBank = ["Coding", "Buy Milk", "Go to school"]
    @State var places: Places?

    var body: some View {
        List{
            if let data = places?.data {
                ForEach(data.indices, id: \.self) { index in
                    ListCellView(data: data[index].name)
                }
            }
//            ForEach(dataBank, id: \.self) { data in
//                ListCellView(data: data)
//            }
        }.onAppear(perform: self.loadData)
    }
    
    func loadData(){
        let urlString = "https://www.travel.taipei/open-api/zh-tw/Attractions/All?page=1"
        
        guard let url = URL(string: urlString) else{
            print("illegle url")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            guard let data = data else {
                return
            }
            print(data)
            do{
                let places = try JSONDecoder().decode(Places.self, from: data)
                DispatchQueue.main.async {
                    self.places = places
                    print(places.data[0].name)
                }
            }
            catch let error{
                print(error.localizedDescription)
            }
        
        }.resume()
        
    }
    
    
}

struct Places: Codable{
    var data: [Place]
    struct Place: Codable{
        var name: String
        var introduction: String
        var tel: String
    }
}

struct TaipeiTourListView_Previews: PreviewProvider {
    static var previews: some View {
        
        TaipeiTourListView()
        
    }
}

struct ListCellView: View {
    
    var data: String
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
            VStack(alignment: .leading) {
                Text(data)
                    .font(.system(.title2))
                Text(data)
                    .foregroundColor(.gray)
                Text("Tel: 0900123321")
                    .foregroundColor(.gray)
            }
        }
    }
}
