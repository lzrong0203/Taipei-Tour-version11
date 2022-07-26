//
//  ContentView.swift
//  Taipei Tour
//
//  Created by Steve Lai on 2022/7/26.
//

import SwiftUI



struct TaipeiTourListView: View {
    
    let dataBank = ["Coding", "Buy Milk", "Go to school"]
//    @State var places: Places?
    @State var tourPlaces: [Place] = []
    
    var body: some View {
        NavigationView {
            List{
                if let data = tourPlaces {
                    ForEach(data.indices, id: \.self) { index in
                        ListCellView(place: data[index])
                    }
                }
            }
            .onAppear(perform: self.loadData)
            .navigationTitle("Taipei Tour")
        }
        
        
        
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
//            print(data)
            do{
                let places = try JSONDecoder().decode(Places.self, from: data)
                DispatchQueue.main.async {
                    
                    for p in places.data{
                        if let image = p.images.first?.src{
                            self.tourPlaces.append(Place(name:p.name, introduction: p.introduction, tel: p.tel, image: image, address:p.address, isFavor: false))
                        }else{
                            self.tourPlaces.append(Place(name:p.name, introduction: p.introduction, tel: p.tel, image: "", address:p.address, isFavor: false))
                        }
                    }
                    
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
        var address: String
        var tel: String
        var images: [image]
        struct image: Codable{
            var src: String
        }
    }
}

struct TaipeiTourListView_Previews: PreviewProvider {
    static var previews: some View {

//        let example = [Place(name: "Test", introduction: "Test", tel: "Test", image: "", address: "", isFavor: false)]
        TaipeiTourListView()

    }
}

struct ListCellView: View {
    
    var place: Place
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            
            let url = place.image
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .frame(width: 120, height: 120)
                    .cornerRadius(20)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.system(.title2))
                Text(place.address)
                    .foregroundColor(.gray)
                Text(place.tel)
                    .foregroundColor(.gray)
                
            }
        }
    }
}
