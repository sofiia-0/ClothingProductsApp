//
//  ProductsListView.swift
//  ClothingProductsApp
//
//  Created by User-UAM on 1/25/25.
//

import Foundation
import SwiftUI
import CoreData

// Vista principal para mostrar y gestionar productos
struct ProductsListView: View {
    @Environment(\.managedObjectContext) private var viewContext // Contexto de Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item> // Recupera los productos desde Core Data

    @State private var newItemName = "" // Nombre del nuevo producto
    @State private var selectedCategory = "Camiseta" // Categoría seleccionada para el nuevo producto
    @State private var newItemPrice = "" // Precio del nuevo producto
    @State private var isAddItemPresented = false // Estado para mostrar el formulario de agregar producto

    // Categorías disponibles para los productos
    private let categories = ["Camiseta", "Top", "Vestido", "Pantalón", "Falda", "Chaqueta"]
    // Colores personalizados para texto y iconos
    private let customTextColor = Color(red: 115/255, green: 113/255, blue: 109/255)
    private let customIconColor = Color(red: 162/255, green: 216/255, blue: 217/255)

    var body: some View {
        NavigationView {
            VStack {
                // Cabecera con imagen y título de la vista
                HStack {
                    Image("loginimage") // Imagen que aparece en la cabecera (cambiar el nombre si es necesario)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Productos") // Título de la vista
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(customTextColor)
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                // Lista de productos
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            // Vista detallada del producto cuando se selecciona
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown") // Nombre del producto
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(customTextColor)
                                Text("Categoría: \(item.category ?? "Sin categoría")") // Categoría del producto
                                    .font(.headline)
                                    .foregroundColor(customTextColor)
                                    .padding(.top, 5)
                                Text("Precio: $\(item.price, specifier: "%.2f")") // Precio del producto
                                    .font(.subheadline)
                                    .foregroundColor(customTextColor)
                                    .padding(.top, 5)
                                Text("Fecha de creación: \(item.timestamp!, formatter: itemFormatter)") // Fecha de creación del producto
                                    .font(.footnote)
                                    .foregroundColor(customTextColor)
                                    .padding(.top, 5)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                            .padding(.horizontal)
                        }
                        label: {
                            // Vista resumida de los productos en la lista
                            HStack {
                                Text(item.name ?? "Unknown") // Nombre del producto
                                    .font(.headline)
                                    .foregroundColor(customTextColor)
                                    .lineLimit(1)
                                Spacer()
                                Text(item.category ?? "Sin categoría") // Categoría del producto
                                    .font(.subheadline)
                                    .foregroundColor(customTextColor)
                                    .lineLimit(1)
                                Text("$\(item.price, specifier: "%.2f")") // Precio del producto
                                    .font(.headline)
                                    .foregroundColor(customIconColor)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteItems) // Permite eliminar productos
                }
                .listStyle(PlainListStyle()) // Estilo simple para la lista
                .background(Color.white) // Fondo blanco para la lista
                .toolbar {
                    // Botón de edición para la lista de productos
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .foregroundColor(customIconColor)
                    }
                    // Botón para agregar un nuevo producto
                    ToolbarItem {
                        Button(action: {
                            isAddItemPresented.toggle() // Muestra el formulario para agregar producto
                        }) {
                            Label("Agregar producto", systemImage: "plus")
                                .foregroundColor(customIconColor)
                        }
                    }
                }
                Spacer()
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isAddItemPresented) {
                VStack(spacing: 20) {
                    // Título de la vista para agregar un producto
                    Text("Agregar nuevo producto")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(customTextColor)
                        .padding(.top)
                        .multilineTextAlignment(.center)

                    // Campo para el nombre del nuevo producto
                    TextField("Ingresa el nombre de la prenda", text: $newItemName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)

                    // Selector de categoría para el nuevo producto
                    Picker("Selecciona la categoría", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // Estilo de selector en rueda
                    .padding(.horizontal)

                    // Campo para el precio del nuevo producto
                    TextField("Ingresa el precio", text: $newItemPrice)
                        .keyboardType(.decimalPad) // Solo acepta números decimales
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)

                    // Botón para guardar el nuevo producto
                    Button("Guardar") {
                        addItem() // Llama a la función para agregar el producto
                        isAddItemPresented = false // Cierra el formulario
                    }
                    .padding()
                    .background(customIconColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
        .background(Color.white)
    }

    // Función para agregar un nuevo producto a Core Data
    private func addItem() {
        guard !newItemName.isEmpty, let price = Double(newItemPrice), price > 0 else { return }
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = newItemName
            newItem.category = selectedCategory
            newItem.timestamp = Date() // Fecha actual de creación
            newItem.price = price

            do {
                try viewContext.save() // Guarda el producto en Core Data
                // Resetea los campos del formulario
                newItemName = ""
                selectedCategory = "Camiseta"
                newItemPrice = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Función para eliminar productos de la lista
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete) // Elimina los productos seleccionados

            do {
                try viewContext.save() // Guarda los cambios en Core Data
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// Formato de fecha para mostrar la fecha de creación del producto
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
