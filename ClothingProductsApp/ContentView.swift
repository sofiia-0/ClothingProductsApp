//
//  ContentView.swift
//  ClothingProductsApp
//
//  Created by User-UAM on 1/25/25.
//
import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false // Estado para saber si el usuario está autenticado

    var body: some View {
        VStack {
            // Si está autenticado, mostramos la lista de productos
            if isAuthenticated {
                ProductsListView()
            } else {
                // Si no está autenticado, mostramos LoginView
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
