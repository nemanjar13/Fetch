//
//  DesertListView.swift
//  FetchInterview
//
//  Created by Nemanja Risteski on 3/5/23.
//

import SwiftUI

struct DesertListView: View {
    @StateObject var vm = DesertViewModel()
    
    var body: some View {
        // List where every item in the list is wrapped in the navigation link that helps
        // navigate between the list of deserts and detailed view about the specific desert after
        NavigationView {
            VStack {
                List(vm.desertList) { item in
                    NavigationLink(destination: DetailView(desert: item)) {
                        HStack {
                            Text(item.strMeal)
                            Spacer().padding()
                            let url = URL(string: item.strMealThum)
                            AsyncImage(url: url) { image in
                                image.resizable().frame(width: 75, height: 75).aspectRatio(contentMode: .fit)
                            } placeholder: {
                                // placeholder image in case that
                                // data for image hasn't been provided
                                // or downloaded correctly
                                Image(systemName: "photo")
                                    .resizable().frame(width: 75, height: 75).aspectRatio(contentMode: .fit)
                            }
                            
                        }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Deserts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DesertListView_Previews: PreviewProvider {
    static var previews: some View {
        DesertListView()
    }
}
